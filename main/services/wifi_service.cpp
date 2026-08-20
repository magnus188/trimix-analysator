#include "wifi_service.h"
#include "../ui/components/status_icons.h"
#include <esp_wifi.h>
#include <esp_event.h>
#include <esp_log.h>
#include <esp_netif.h>
#include <nvs_flash.h>
#include <freertos/FreeRTOS.h>
#include <freertos/event_groups.h>
#include <freertos/semphr.h>
#include <cstdio>
#include <cstring>

static const char* TAG = "WIFI_SVC";

// NVS namespace for WiFi credentials
constexpr const char* NVS_NAMESPACE = "wifi_creds";
constexpr const char* NVS_KEY_SSID = "ssid";
constexpr const char* NVS_KEY_PASS = "password";
constexpr uint16_t MAX_SCAN_RESULTS = 20;

namespace {

// Event bits
constexpr int WIFI_CONNECTED_BIT = BIT0;
constexpr int WIFI_FAIL_BIT = BIT1;
constexpr int WIFI_SCAN_DONE_BIT = BIT2;

// State
EventGroupHandle_t g_wifi_event_group = nullptr;
SemaphoreHandle_t g_wifi_mutex = nullptr;
esp_netif_t* g_sta_netif = nullptr;
bool g_initialized = false;
bool g_scanning = false;
bool g_connected = false;
char g_connected_ssid[33] = {0};
bool g_pending_credentials = false;
char g_pending_ssid[33] = {0};
char g_pending_password[65] = {0};
wifi_ap_record_t g_scan_results[MAX_SCAN_RESULTS] = {};
uint16_t g_scan_count = 0;

int s_retry_num = 0;
bool g_suppress_next_disconnect = false;
constexpr int WIFI_MAXIMUM_RETRY = 3;

void lock_wifi_state() {
    if (g_wifi_mutex) {
        xSemaphoreTake(g_wifi_mutex, portMAX_DELAY);
    }
}

void unlock_wifi_state() {
    if (g_wifi_mutex) {
        xSemaphoreGive(g_wifi_mutex);
    }
}

void wifi_event_handler(void* arg, esp_event_base_t event_base,
                        int32_t event_id, void* event_data) {
    if (event_base == WIFI_EVENT) {
        switch (event_id) {
            case WIFI_EVENT_STA_START:
                ESP_LOGI(TAG, "WiFi station started");
                break;
                
            case WIFI_EVENT_STA_DISCONNECTED: {
                wifi_event_sta_disconnected_t* event =
                    (wifi_event_sta_disconnected_t*)event_data;
                ESP_LOGI(TAG, "Disconnected from AP, reason: %d", event->reason);

                lock_wifi_state();
                g_connected = false;
                g_connected_ssid[0] = '\0';
                bool suppress_retry = g_suppress_next_disconnect;
                if (suppress_retry) {
                    g_suppress_next_disconnect = false;
                }
                bool should_retry = !suppress_retry && s_retry_num < WIFI_MAXIMUM_RETRY;
                if (should_retry) {
                    s_retry_num++;
                }
                int retry_num = s_retry_num;
                unlock_wifi_state();

                status_set_wifi(false, WIFI_SIGNAL_NONE);

                if (should_retry) {
                    esp_wifi_connect();
                    ESP_LOGI(TAG, "Retrying connection (%d/%d)", retry_num, WIFI_MAXIMUM_RETRY);
                } else if (!suppress_retry) {
                    lock_wifi_state();
                    g_pending_credentials = false;
                    unlock_wifi_state();
                    xEventGroupSetBits(g_wifi_event_group, WIFI_FAIL_BIT);
                }
                break;
            }
            
            case WIFI_EVENT_SCAN_DONE: {
                ESP_LOGI(TAG, "WiFi scan completed");
                
                // Get scan results count
                uint16_t ap_count = 0;
                esp_wifi_scan_get_ap_num(&ap_count);
                uint16_t result_count = ap_count > MAX_SCAN_RESULTS ? MAX_SCAN_RESULTS : ap_count;
                
                lock_wifi_state();
                g_scanning = false;
                g_scan_count = 0;
                if (result_count > 0) {
                    esp_err_t err = esp_wifi_scan_get_ap_records(&result_count, g_scan_results);
                    if (err == ESP_OK) {
                        g_scan_count = result_count;
                    } else {
                        ESP_LOGE(TAG, "Failed to read scan records: %s", esp_err_to_name(err));
                    }
                }
                uint16_t stored_count = g_scan_count;
                unlock_wifi_state();

                ESP_LOGI(TAG, "Found %d networks (%d stored)", ap_count, stored_count);

                xEventGroupSetBits(g_wifi_event_group, WIFI_SCAN_DONE_BIT);
                break;
            }

            default:
                break;
        }
    } else if (event_base == IP_EVENT) {
        if (event_id == IP_EVENT_STA_GOT_IP) {
            ip_event_got_ip_t* event = (ip_event_got_ip_t*)event_data;
            ESP_LOGI(TAG, "Got IP: " IPSTR, IP2STR(&event->ip_info.ip));
            
            lock_wifi_state();
            g_connected = true;
            s_retry_num = 0;
            g_suppress_next_disconnect = false;
            unlock_wifi_state();
            
            // Get current SSID
            wifi_ap_record_t ap_info;
            if (esp_wifi_sta_get_ap_info(&ap_info) == ESP_OK) {
                lock_wifi_state();
                strncpy(g_connected_ssid, (char*)ap_info.ssid, sizeof(g_connected_ssid) - 1);
                g_connected_ssid[sizeof(g_connected_ssid) - 1] = '\0';
                unlock_wifi_state();
                
                // Update status icon with signal strength
                int bars = wifi_service_rssi_to_bars(ap_info.rssi);
                status_set_wifi(true, (wifi_signal_level_t)bars);
            }

            char pending_ssid[33] = {0};
            char pending_password[65] = {0};
            lock_wifi_state();
            const bool save_pending_credentials = g_pending_credentials;
            if (save_pending_credentials) {
                memcpy(pending_ssid, g_pending_ssid, sizeof(pending_ssid));
                memcpy(pending_password, g_pending_password, sizeof(pending_password));
                g_pending_credentials = false;
            }
            unlock_wifi_state();
            if (save_pending_credentials) {
                wifi_service_save_credentials(pending_ssid, pending_password);
            }
            
            xEventGroupSetBits(g_wifi_event_group, WIFI_CONNECTED_BIT);
        }
    }
}

}  // namespace

void wifi_service_init(void) {
    if (g_initialized) return;
    
    ESP_LOGI(TAG, "Initializing WiFi service");
    if (!g_wifi_mutex) {
        g_wifi_mutex = xSemaphoreCreateMutex();
        if (!g_wifi_mutex) {
            ESP_LOGE(TAG, "Failed to create WiFi mutex");
            ESP_ERROR_CHECK(ESP_ERR_NO_MEM);
        }
    }
    
    // Initialize NVS (required for WiFi)
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);
    
    // Create event group
    g_wifi_event_group = xEventGroupCreate();
    if (!g_wifi_event_group) {
        ESP_LOGE(TAG, "Failed to create WiFi event group");
        ESP_ERROR_CHECK(ESP_ERR_NO_MEM);
    }
    
    // Initialize TCP/IP stack
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    g_sta_netif = esp_netif_create_default_wifi_sta();
    
    // Initialize WiFi
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));
    
    // Register event handlers
    ESP_ERROR_CHECK(esp_event_handler_instance_register(
        WIFI_EVENT, ESP_EVENT_ANY_ID, &wifi_event_handler, nullptr, nullptr));
    ESP_ERROR_CHECK(esp_event_handler_instance_register(
        IP_EVENT, IP_EVENT_STA_GOT_IP, &wifi_event_handler, nullptr, nullptr));
    
    // Set station mode
    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
    ESP_ERROR_CHECK(esp_wifi_start());
    
    lock_wifi_state();
    g_initialized = true;
    unlock_wifi_state();
    ESP_LOGI(TAG, "WiFi initialized");
}

void wifi_service_start_scan(void) {
    lock_wifi_state();
    bool initialized = g_initialized;
    bool scanning = g_scanning;
    unlock_wifi_state();

    if (!initialized || scanning) {
        ESP_LOGW(TAG, "Cannot start scan: initialized=%d, scanning=%d", initialized, scanning);
        return;
    }
    
    ESP_LOGI(TAG, "Starting WiFi scan");
    
    xEventGroupClearBits(g_wifi_event_group, WIFI_SCAN_DONE_BIT);
    
    wifi_scan_config_t scan_config = {};
    scan_config.show_hidden = false;
    scan_config.scan_type = WIFI_SCAN_TYPE_ACTIVE;
    scan_config.scan_time.active.min = 100;
    scan_config.scan_time.active.max = 300;
    
    esp_err_t err = esp_wifi_scan_start(&scan_config, false);
    if (err == ESP_OK) {
        lock_wifi_state();
        g_scanning = true;
        unlock_wifi_state();
        ESP_LOGI(TAG, "WiFi scan started successfully");
    } else {
        lock_wifi_state();
        g_scanning = false;
        unlock_wifi_state();
        ESP_LOGE(TAG, "Failed to start WiFi scan: %s", esp_err_to_name(err));
        // Set scan done bit so UI can handle the failure
        xEventGroupSetBits(g_wifi_event_group, WIFI_SCAN_DONE_BIT);
    }
}

bool wifi_service_is_scanning(void) {
    lock_wifi_state();
    bool scanning = g_scanning;
    unlock_wifi_state();
    return scanning;
}

bool wifi_service_is_ready(void) {
    lock_wifi_state();
    bool initialized = g_initialized;
    unlock_wifi_state();
    return initialized;
}

uint16_t wifi_service_get_scan_count(void) {
    lock_wifi_state();
    uint16_t count = g_scan_count;
    unlock_wifi_state();
    return count;
}

uint16_t wifi_service_get_scan_results(wifi_network_info_t* networks, uint16_t max_count) {
    if (!networks || max_count == 0) return 0;
    
    lock_wifi_state();
    if (g_scan_count == 0) {
        unlock_wifi_state();
        return 0;
    }

    uint16_t count = (g_scan_count < max_count) ? g_scan_count : max_count;
    
    for (uint16_t i = 0; i < count; i++) {
        strncpy(networks[i].ssid, (char*)g_scan_results[i].ssid, 32);
        networks[i].ssid[32] = '\0';
        networks[i].rssi = g_scan_results[i].rssi;
        networks[i].authmode = g_scan_results[i].authmode;
        networks[i].connected = (g_connected && 
            strcmp(networks[i].ssid, g_connected_ssid) == 0);
    }
    unlock_wifi_state();
    
    return count;
}

bool wifi_service_connect(const char* ssid, const char* password) {
    lock_wifi_state();
    bool initialized = g_initialized;
    bool connected = g_connected;
    unlock_wifi_state();

    if (!initialized || !ssid) return false;
    
    ESP_LOGI(TAG, "Connecting to '%s'", ssid);
    
    // Disconnect if already connected
    if (connected) {
        lock_wifi_state();
        g_suppress_next_disconnect = true;
        unlock_wifi_state();
        esp_err_t disconnect_err = esp_wifi_disconnect();
        if (disconnect_err != ESP_OK) {
            lock_wifi_state();
            g_suppress_next_disconnect = false;
            unlock_wifi_state();
            ESP_LOGW(TAG, "Disconnect before reconnect failed: %s", esp_err_to_name(disconnect_err));
        }
        lock_wifi_state();
        g_connected = false;
        unlock_wifi_state();
    }
    
    // Configure
    wifi_config_t wifi_config = {};
    strncpy((char*)wifi_config.sta.ssid, ssid, sizeof(wifi_config.sta.ssid) - 1);
    if (password) {
        strncpy((char*)wifi_config.sta.password, password, sizeof(wifi_config.sta.password) - 1);
    }
    wifi_config.sta.threshold.authmode = password ? WIFI_AUTH_WPA2_PSK : WIFI_AUTH_OPEN;
    
    lock_wifi_state();
    s_retry_num = 0;
    strncpy(g_pending_ssid, ssid, sizeof(g_pending_ssid) - 1);
    g_pending_ssid[sizeof(g_pending_ssid) - 1] = '\0';
    strncpy(g_pending_password, password ? password : "", sizeof(g_pending_password) - 1);
    g_pending_password[sizeof(g_pending_password) - 1] = '\0';
    g_pending_credentials = true;
    unlock_wifi_state();
    xEventGroupClearBits(g_wifi_event_group, WIFI_CONNECTED_BIT | WIFI_FAIL_BIT);
    
    esp_err_t err = esp_wifi_set_config(WIFI_IF_STA, &wifi_config);
    if (err != ESP_OK) {
        lock_wifi_state();
        g_pending_credentials = false;
        unlock_wifi_state();
        ESP_LOGE(TAG, "Failed to configure WiFi: %s", esp_err_to_name(err));
        return false;
    }

    err = esp_wifi_connect();
    if (err != ESP_OK) {
        lock_wifi_state();
        g_pending_credentials = false;
        unlock_wifi_state();
        ESP_LOGE(TAG, "Failed to start WiFi connection: %s", esp_err_to_name(err));
        return false;
    }
    
    return true;
}

void wifi_service_disconnect(void) {
    lock_wifi_state();
    bool initialized = g_initialized;
    unlock_wifi_state();

    if (!initialized) return;
    
    ESP_LOGI(TAG, "Disconnecting");
    lock_wifi_state();
    g_suppress_next_disconnect = true;
    unlock_wifi_state();
    esp_err_t err = esp_wifi_disconnect();
    if (err != ESP_OK) {
        lock_wifi_state();
        g_suppress_next_disconnect = false;
        unlock_wifi_state();
        ESP_LOGW(TAG, "WiFi disconnect failed: %s", esp_err_to_name(err));
    }
    lock_wifi_state();
    g_connected = false;
    g_connected_ssid[0] = '\0';
    g_pending_credentials = false;
    unlock_wifi_state();
    status_set_wifi(false, WIFI_SIGNAL_NONE);
}

bool wifi_service_is_connected(void) {
    lock_wifi_state();
    bool connected = g_connected;
    unlock_wifi_state();
    return connected;
}

bool wifi_service_get_connected_ssid(char* ssid) {
    if (!ssid) return false;

    lock_wifi_state();
    if (!g_connected) {
        unlock_wifi_state();
        return false;
    }
    strncpy(ssid, g_connected_ssid, 32);
    ssid[32] = '\0';
    unlock_wifi_state();
    return true;
}

int8_t wifi_service_get_rssi(void) {
    if (!wifi_service_is_connected()) return 0;
    
    wifi_ap_record_t ap_info;
    if (esp_wifi_sta_get_ap_info(&ap_info) == ESP_OK) {
        return ap_info.rssi;
    }
    return 0;
}

int wifi_service_rssi_to_bars(int8_t rssi) {
    // iOS-style signal bars
    if (rssi >= -50) return WIFI_SIGNAL_EXCELLENT;
    if (rssi >= -60) return WIFI_SIGNAL_GOOD;
    if (rssi >= -70) return WIFI_SIGNAL_FAIR;
    if (rssi >= -80) return WIFI_SIGNAL_WEAK;
    return WIFI_SIGNAL_NONE;
}

bool wifi_service_get_ip(char* ip_str) {
    if (!ip_str || !wifi_service_is_connected() || !g_sta_netif) return false;
    
    esp_netif_ip_info_t ip_info;
    if (esp_netif_get_ip_info(g_sta_netif, &ip_info) == ESP_OK) {
        snprintf(ip_str, 16, IPSTR, IP2STR(&ip_info.ip));
        return true;
    }
    return false;
}

void wifi_service_save_credentials(const char* ssid, const char* password) {
    nvs_handle_t handle;
    if (nvs_open(NVS_NAMESPACE, NVS_READWRITE, &handle) == ESP_OK) {
        nvs_set_str(handle, NVS_KEY_SSID, ssid ? ssid : "");
        nvs_set_str(handle, NVS_KEY_PASS, password ? password : "");
        nvs_commit(handle);
        nvs_close(handle);
        ESP_LOGI(TAG, "Credentials saved for '%s'", ssid);
    }
}

bool wifi_service_load_credentials(char* ssid, char* password) {
    nvs_handle_t handle;
    if (nvs_open(NVS_NAMESPACE, NVS_READONLY, &handle) != ESP_OK) {
        return false;
    }
    
    size_t ssid_len = 33, pass_len = 65;
    bool success = (nvs_get_str(handle, NVS_KEY_SSID, ssid, &ssid_len) == ESP_OK &&
                    nvs_get_str(handle, NVS_KEY_PASS, password, &pass_len) == ESP_OK &&
                    strlen(ssid) > 0);
    
    nvs_close(handle);
    return success;
}

void wifi_service_clear_credentials(void) {
    nvs_handle_t handle;
    if (nvs_open(NVS_NAMESPACE, NVS_READWRITE, &handle) == ESP_OK) {
        nvs_erase_all(handle);
        nvs_commit(handle);
        nvs_close(handle);
        ESP_LOGI(TAG, "Credentials cleared");
    }
}

void wifi_service_auto_connect(void) {
    char ssid[33], password[65];
    if (wifi_service_load_credentials(ssid, password)) {
        ESP_LOGI(TAG, "Auto-connecting to '%s'", ssid);
        wifi_service_connect(ssid, password);
    }
}
