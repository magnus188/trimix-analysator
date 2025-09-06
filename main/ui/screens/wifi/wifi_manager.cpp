#include "wifi_settings.h"
#include "esp_log.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "nvs_flash.h"
#include "esp_netif.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/event_groups.h"
#include <string.h>

static const char *TAG = "WiFiManager";

// WiFi event bits
#define WIFI_CONNECTED_BIT BIT0
#define WIFI_FAIL_BIT      BIT1

// Static variables
static EventGroupHandle_t s_wifi_event_group = NULL;
static wifi_connection_status_t wifi_status = WIFI_STATUS_DISCONNECTED;
static char current_ssid[33] = {0};
static int retry_count = 0;
static const int MAX_RETRY = 5;
static bool wifi_initialized = false;

// Scan results and callback
static wifi_ap_info_t scan_results[20];
static int scan_count = 0;
static bool scan_done = false;
static wifi_scan_callback_t scan_callback = NULL;

// Forward declarations
static void wifi_event_handler(void* arg, esp_event_base_t event_base, int32_t event_id, void* event_data);

// WiFi manager initialization
esp_err_t wifi_manager_init(void) {
    if (wifi_initialized) {
        return ESP_OK;
    }
    
    ESP_LOGI(TAG, "Initializing WiFi manager");
    
    // Initialize NVS if not already done
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);
    
    // Create event group
    s_wifi_event_group = xEventGroupCreate();
    if (s_wifi_event_group == NULL) {
        ESP_LOGE(TAG, "Failed to create event group");
        return ESP_FAIL;
    }
    
    // Initialize TCP/IP stack
    ESP_ERROR_CHECK(esp_netif_init());
    
    // Create default event loop
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    
    // Create default WiFi station
    esp_netif_create_default_wifi_sta();
    
    // Initialize WiFi with default config
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));
    
    // Register event handlers
    ESP_ERROR_CHECK(esp_event_handler_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &wifi_event_handler, NULL));
    ESP_ERROR_CHECK(esp_event_handler_register(IP_EVENT, IP_EVENT_STA_GOT_IP, &wifi_event_handler, NULL));
    
    // Set WiFi mode to station
    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
    
    // Start WiFi
    ESP_ERROR_CHECK(esp_wifi_start());
    
    wifi_initialized = true;
    ESP_LOGI(TAG, "WiFi manager initialized successfully");
    return ESP_OK;
}

// Start WiFi scan
esp_err_t wifi_manager_start_scan(void) {
    ESP_LOGI(TAG, "Starting WiFi scan");
    
    if (!wifi_initialized) {
        wifi_manager_init();
    }
    
    scan_done = false;
    scan_count = 0;
    
    wifi_scan_config_t scan_config = {};
    memset(&scan_config, 0, sizeof(wifi_scan_config_t));
    scan_config.ssid = NULL;
    scan_config.bssid = NULL;
    scan_config.channel = 0;
    scan_config.show_hidden = false;
    scan_config.scan_type = WIFI_SCAN_TYPE_ACTIVE;
    scan_config.scan_time.active.min = 100;
    scan_config.scan_time.active.max = 300;
    
    esp_err_t err = esp_wifi_scan_start(&scan_config, false);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to start scan: %s", esp_err_to_name(err));
    }
    
    return err;
}

// Get scan results
wifi_ap_info_t* wifi_manager_get_scan_results(int *count) {
    *count = scan_count;
    return scan_results;
}

// Connect to WiFi network
esp_err_t wifi_manager_connect(const char *ssid, const char *password) {
    ESP_LOGI(TAG, "Connecting to WiFi: %s", ssid);
    
    if (!wifi_initialized) {
        wifi_manager_init();
    }
    
    if (!ssid || strlen(ssid) == 0) {
        ESP_LOGE(TAG, "Invalid SSID");
        return ESP_ERR_INVALID_ARG;
    }
    
    // Stop any existing connection
    esp_wifi_disconnect();
    
    // Configure WiFi connection
    wifi_config_t wifi_config = {};
    memset(&wifi_config, 0, sizeof(wifi_config_t));
    strncpy((char*)wifi_config.sta.ssid, ssid, sizeof(wifi_config.sta.ssid) - 1);
    if (password && strlen(password) > 0) {
        strncpy((char*)wifi_config.sta.password, password, sizeof(wifi_config.sta.password) - 1);
    }
    wifi_config.sta.threshold.authmode = (password && strlen(password) > 0) ? WIFI_AUTH_WPA2_PSK : WIFI_AUTH_OPEN;
    wifi_config.sta.pmf_cfg.capable = true;
    wifi_config.sta.pmf_cfg.required = false;
    
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_STA, &wifi_config));
    
    // Clear event group and start connection
    xEventGroupClearBits(s_wifi_event_group, WIFI_CONNECTED_BIT | WIFI_FAIL_BIT);
    retry_count = 0;
    wifi_status = WIFI_STATUS_CONNECTING;
    
    esp_err_t err = esp_wifi_connect();
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to start connection: %s", esp_err_to_name(err));
        wifi_status = WIFI_STATUS_FAILED;
    }
    
    return err;
}

// Disconnect from WiFi
esp_err_t wifi_manager_disconnect(void) {
    ESP_LOGI(TAG, "Disconnecting from WiFi");
    
    wifi_status = WIFI_STATUS_DISCONNECTED;
    memset(current_ssid, 0, sizeof(current_ssid));
    retry_count = 0;
    
    return esp_wifi_disconnect();
}

// Get current connection status
wifi_connection_status_t wifi_manager_get_status(void) {
    return wifi_status;
}

// WiFi event handler
static void wifi_event_handler(void* arg, esp_event_base_t event_base, int32_t event_id, void* event_data) {
    if (event_base == WIFI_EVENT) {
        switch (event_id) {
            case WIFI_EVENT_STA_START:
                ESP_LOGI(TAG, "WiFi station started");
                break;
                
            case WIFI_EVENT_STA_CONNECTED: {
                wifi_event_sta_connected_t* event = (wifi_event_sta_connected_t*) event_data;
                ESP_LOGI(TAG, "Connected to AP SSID:%s", event->ssid);
                strncpy(current_ssid, (char*)event->ssid, sizeof(current_ssid) - 1);
                break;
            }
            
            case WIFI_EVENT_STA_DISCONNECTED: {
                wifi_event_sta_disconnected_t* event = (wifi_event_sta_disconnected_t*) event_data;
                ESP_LOGI(TAG, "Disconnected from AP SSID:%s, reason:%d", event->ssid, event->reason);
                
                if (wifi_status == WIFI_STATUS_CONNECTING && retry_count < MAX_RETRY) {
                    esp_wifi_connect();
                    retry_count++;
                    ESP_LOGI(TAG, "Retry to connect to the AP (attempt %d/%d)", retry_count, MAX_RETRY);
                } else {
                    if (wifi_status == WIFI_STATUS_CONNECTING) {
                        wifi_status = WIFI_STATUS_FAILED;
                        ESP_LOGI(TAG, "Connection failed after %d retries", MAX_RETRY);
                    } else {
                        wifi_status = WIFI_STATUS_DISCONNECTED;
                    }
                    memset(current_ssid, 0, sizeof(current_ssid));
                    xEventGroupSetBits(s_wifi_event_group, WIFI_FAIL_BIT);
                }
                break;
            }
            
            case WIFI_EVENT_SCAN_DONE: {
                ESP_LOGI(TAG, "WiFi scan completed");
                
                uint16_t ap_count = 0;
                esp_wifi_scan_get_ap_num(&ap_count);
                
                if (ap_count == 0) {
                    ESP_LOGW(TAG, "No access points found");
                    scan_count = 0;
                    scan_done = true;
                    
                    // Call the scan completion callback even when no networks found
                    if (scan_callback) {
                        scan_callback(0);
                    }
                    return;
                }
                
                // Limit to maximum we can handle
                if (ap_count > 20) {
                    ap_count = 20;
                }
                
                wifi_ap_record_t ap_records[20];
                esp_wifi_scan_get_ap_records(&ap_count, ap_records);
                
                // Convert to our format and sort by signal strength
                for (int i = 0; i < ap_count; i++) {
                    strncpy(scan_results[i].ssid, (char*)ap_records[i].ssid, sizeof(scan_results[i].ssid) - 1);
                    scan_results[i].ssid[sizeof(scan_results[i].ssid) - 1] = '\0';
                    scan_results[i].rssi = ap_records[i].rssi;
                    scan_results[i].auth_mode = ap_records[i].authmode;
                    scan_results[i].connected = (wifi_status == WIFI_STATUS_CONNECTED && 
                                               strcmp(scan_results[i].ssid, current_ssid) == 0);
                    
                    ESP_LOGI(TAG, "AP %d: %s (RSSI: %d, Auth: %d)", 
                            i, scan_results[i].ssid, scan_results[i].rssi, scan_results[i].auth_mode);
                }
                
                // Sort by signal strength (strongest first)
                for (int i = 0; i < ap_count - 1; i++) {
                    for (int j = i + 1; j < ap_count; j++) {
                        if (scan_results[i].rssi < scan_results[j].rssi) {
                            wifi_ap_info_t temp = scan_results[i];
                            scan_results[i] = scan_results[j];
                            scan_results[j] = temp;
                        }
                    }
                }
                
                scan_count = ap_count;
                scan_done = true;
                
                // Call the scan completion callback if registered
                if (scan_callback) {
                    scan_callback(scan_count);
                }
                
                break;
            }
                
            default:
                break;
        }
    } else if (event_base == IP_EVENT) {
        switch (event_id) {
            case IP_EVENT_STA_GOT_IP: {
                ip_event_got_ip_t* event = (ip_event_got_ip_t*) event_data;
                ESP_LOGI(TAG, "Got IP:" IPSTR, IP2STR(&event->ip_info.ip));
                
                wifi_status = WIFI_STATUS_CONNECTED;
                retry_count = 0;
                
                xEventGroupSetBits(s_wifi_event_group, WIFI_CONNECTED_BIT);
                break;
            }
            
            default:
                break;
        }
    }
}

// Set scan completion callback
void wifi_manager_set_scan_callback(wifi_scan_callback_t callback) {
    scan_callback = callback;
}
