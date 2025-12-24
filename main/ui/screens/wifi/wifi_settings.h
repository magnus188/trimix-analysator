#pragma once
#include <lvgl.h>
#include "esp_wifi.h"

#ifdef __cplusplus
extern "C" {
#endif

// WiFi AP information structure
typedef struct {
    char ssid[33];                    // SSID (max 32 chars + null terminator)
    int8_t rssi;                      // Signal strength
    wifi_auth_mode_t auth_mode;       // Security type
    bool connected;                   // Currently connected to this network
} wifi_ap_info_t;

// WiFi connection status
typedef enum {
    WIFI_STATUS_DISCONNECTED,
    WIFI_STATUS_CONNECTING,
    WIFI_STATUS_CONNECTED,
    WIFI_STATUS_FAILED
} wifi_connection_status_t;

// Callback type for scan completion
typedef void (*wifi_scan_callback_t)(int networks_found);

// WiFi manager functions
esp_err_t wifi_manager_init(void);
esp_err_t wifi_manager_start_scan(void);
esp_err_t wifi_manager_connect(const char *ssid, const char *password);
esp_err_t wifi_manager_disconnect(void);
wifi_connection_status_t wifi_manager_get_status(void);
wifi_ap_info_t* wifi_manager_get_scan_results(int *count);
void wifi_manager_set_scan_callback(wifi_scan_callback_t callback);

// WiFi settings screen functions
lv_obj_t *screen_wifi_settings_create(void);
void screen_wifi_settings_cleanup(void);
void wifi_settings_refresh_scan(void);
void wifi_settings_connect_to_network(const char *ssid, const char *password);
void wifi_settings_disconnect(void);
wifi_connection_status_t wifi_settings_get_status(void);

// Callback type for connection status changes
typedef void (*wifi_connection_callback_t)(wifi_connection_status_t status);

// Set connection status callback (called when connection state changes)
void wifi_manager_set_connection_callback(wifi_connection_callback_t callback);

#ifdef __cplusplus
}
#endif
