#include "wifi_service.h"
#include "../ui/components/status_icons.h"
#include <esp_wifi.h>
#include <esp_event.h>
#include <esp_log.h>
#include <esp_netif.h>
#include <nvs_flash.h>
#include <freertos/FreeRTOS.h>
#include <freertos/event_groups.h>
#include <cstring>

static const char* TAG = "WIFI_SVC";

// NVS namespace for WiFi credentials
constexpr const char* NVS_NAMESPACE = "wifi_creds";
constexpr const char* NVS_KEY_SSID = "ssid";
constexpr const char* NVS_KEY_PASS = "password";

namespace {

// Event bits
constexpr int WIFI_CONNECTED_BIT = BIT0;
constexpr int WIFI_FAIL_BIT = BIT1;
constexpr int WIFI_SCAN_DONE_BIT = BIT2;

// State
EventGroupHandle_t g_wifi_event_group = nullptr;
esp_netif_t* g_sta_netif = nullptr;
bool g_initialized = false;
bool g_scanning = false;
bool g_connected = false;
char g_connected_ssid[33] = {0};
wifi_ap_record_t* g_scan_results = nullptr;
uint16_t g_scan_count = 0;

int s_retry_num = 0;
constexpr int WIFI_MAXIMUM_RETRY = 3;

void wifi_event_handler(void* arg, esp_event_base_t event_base,
                        int32_t event_id, void* event_data) {
    if (event_base == WIFI_EVENT) {
        switch (event_id) {
            case WIFI_EVENT_STA_START:
                ESP_LOGI(TAG, "WiFi station started");
                break;
                
            case WIFI_EVENT_STA_DISCONNECTED: {
                g_connected = false;
                g_connected_ssid[0] = '\0';
                status_set_wifi(false, WIFI_SIGNAL_NONE);
                
                wifi_event_sta_disconnected_t* event = 
                    (wifi_event_sta_disconnected_t*)event_data;
                ESP_LOGI(TAG, "Disconnected from AP, reason: %d", event->reason);
                
                if (s_retry_num < WIFI_MAXIMUM_RETRY) {
                    esp_wifi_connect();
                    s_retry_num++;
                    ESP_LOGI(TAG, "Retrying connection (%d/%d)", s_retry_num, WIFI_MAXIMUM_RETRY);
                } else {
                    xEventGroupSetBits(g_wifi_event_group, WIFI_FAIL_BIT);
                }
                break;
            }
            
            case WIFI_EVENT_SCAN_DONE: {
                ESP_LOGI(TAG, "WiFi scan completed");
                g_scanning = false;
                
                // Get scan results count
                uint16_t ap_count = 0;
                esp_wifi_scan_get_ap_num(&ap_count);
                
                // Free previous results
                if (g_scan_results) {
                    free(g_scan_results);
                    g_scan_results = nullptr;
                }
                
                if (ap_count > 0) {
                    g_scan_results = (wifi_ap_record_t*)malloc(sizeof(wifi_ap_record_t) * ap_count);
                    if (g_scan_results) {
                        esp_wifi_scan_get_ap_records(&ap_count, g_scan_results);
                        g_scan_count = ap_count;
                        ESP_LOGI(TAG, "Found %d networks", ap_count);
                    }
                } else {
                    g_scan_count = 0;
                }
                
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
            
            g_connected = true;
            s_retry_num = 0;
            
            // Get current SSID
            wifi_ap_record_t ap_info;
            if (esp_wifi_sta_get_ap_info(&ap_info) == ESP_OK) {
                strncpy(g_connected_ssid, (char*)ap_info.ssid, sizeof(g_connected_ssid) - 1);
                
                // Update status icon with signal strength
                int bars = wifi_service_rssi_to_bars(ap_info.rssi);
                status_set_wifi(true, (wifi_signal_level_t)bars);
            }
            
            xEventGroupSetBits(g_wifi_event_group, WIFI_CONNECTED_BIT);
        }
    }
}

}  // namespace

void wifi_service_init(void) {
    if (g_initialized) return;
    
    ESP_LOGI(TAG, "Initializing WiFi service");
    
    // Initialize NVS (required for WiFi)
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);
    
    // Create event group
    g_wifi_event_group = xEventGroupCreate();
    
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
    
    g_initialized = true;
    ESP_LOGI(TAG, "WiFi initialized");
}

void wifi_service_start_scan(void) {
    if (!g_initialized || g_scanning) {
        ESP_LOGW(TAG, "Cannot start scan: initialized=%d, scanning=%d", g_initialized, g_scanning);
        return;
    }
    
    ESP_LOGI(TAG, "Starting WiFi scan");
    
    xEventGroupClearBits(g_wifi_event_group, WIFI_SCAN_DONE_BIT);
    
    wifi_scan_config_t scan_config = {
        .ssid = nullptr,
        .bssid = nullptr,
        .channel = 0,
        .show_hidden = false,
        .scan_type = WIFI_SCAN_TYPE_ACTIVE,
        .scan_time = {
            .active = { .min = 100, .max = 300 }
        }
    };
    
    esp_err_t err = esp_wifi_scan_start(&scan_config, false);
    if (err == ESP_OK) {
        g_scanning = true;
        ESP_LOGI(TAG, "WiFi scan started successfully");
    } else {
        ESP_LOGE(TAG, "Failed to start WiFi scan: %s", esp_err_to_name(err));
        // Set scan done bit so UI can handle the failure
        xEventGroupSetBits(g_wifi_event_group, WIFI_SCAN_DONE_BIT);
    }
}

bool wifi_service_is_scanning(void) {
    return g_scanning;
}

bool wifi_service_is_ready(void) {
    return g_initialized;
}

uint16_t wifi_service_get_scan_count(void) {
    return g_scan_count;
}

uint16_t wifi_service_get_scan_results(wifi_network_info_t* networks, uint16_t max_count) {
    if (!networks || !g_scan_results || g_scan_count == 0) return 0;
    
    uint16_t count = (g_scan_count < max_count) ? g_scan_count : max_count;
    
    for (uint16_t i = 0; i < count; i++) {
        strncpy(networks[i].ssid, (char*)g_scan_results[i].ssid, 32);
        networks[i].ssid[32] = '\0';
        networks[i].rssi = g_scan_results[i].rssi;
        networks[i].authmode = g_scan_results[i].authmode;
        networks[i].connected = (g_connected && 
            strcmp(networks[i].ssid, g_connected_ssid) == 0);
    }
    
    return count;
}

bool wifi_service_connect(const char* ssid, const char* password) {
    if (!g_initialized || !ssid) return false;
    
    ESP_LOGI(TAG, "Connecting to '%s'", ssid);
    
    // Disconnect if already connected
    if (g_connected) {
        esp_wifi_disconnect();
        g_connected = false;
    }
    
    // Configure
    wifi_config_t wifi_config = {};
    strncpy((char*)wifi_config.sta.ssid, ssid, sizeof(wifi_config.sta.ssid) - 1);
    if (password) {
        strncpy((char*)wifi_config.sta.password, password, sizeof(wifi_config.sta.password) - 1);
    }
    wifi_config.sta.threshold.authmode = password ? WIFI_AUTH_WPA2_PSK : WIFI_AUTH_OPEN;
    
    s_retry_num = 0;
    xEventGroupClearBits(g_wifi_event_group, WIFI_CONNECTED_BIT | WIFI_FAIL_BIT);
    
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_STA, &wifi_config));
    esp_wifi_connect();
    
    return true;
}

void wifi_service_disconnect(void) {
    if (!g_initialized) return;
    
    ESP_LOGI(TAG, "Disconnecting");
    esp_wifi_disconnect();
    g_connected = false;
    g_connected_ssid[0] = '\0';
    status_set_wifi(false, WIFI_SIGNAL_NONE);
}

bool wifi_service_is_connected(void) {
    return g_connected;
}

bool wifi_service_get_connected_ssid(char* ssid) {
    if (!g_connected || !ssid) return false;
    strcpy(ssid, g_connected_ssid);
    return true;
}

int8_t wifi_service_get_rssi(void) {
    if (!g_connected) return 0;
    
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
    if (!g_connected || !g_sta_netif || !ip_str) return false;
    
    esp_netif_ip_info_t ip_info;
    if (esp_netif_get_ip_info(g_sta_netif, &ip_info) == ESP_OK) {
        sprintf(ip_str, IPSTR, IP2STR(&ip_info.ip));
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
