#include "wifi_settings.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"
#include "esp_log.h"
#include "esp_timer.h"
#include <string.h>
#include <stdlib.h>

static const char *TAG = "WiFiSettings";

// Static UI elements
static lv_obj_t *wifi_screen = NULL;
static lv_obj_t *status_label = NULL;
static lv_obj_t *scan_button = NULL;
static lv_obj_t *networks_container = NULL;
static lv_obj_t *password_dialog = NULL;
static lv_obj_t *password_input = NULL;
static lv_timer_t *ui_update_timer = NULL;

// Simple WiFi state  
static wifi_connection_status_t current_status = WIFI_STATUS_DISCONNECTED;
static char selected_ssid[33] = {0};
static bool scan_in_progress = false;
static bool scan_results_ready = false;
static bool ui_needs_update = false;

// Forward declarations
static void update_status_display(void);
static void update_networks_list(void);
static void create_password_dialog(const char *ssid);
static void destroy_password_dialog(void);
static void on_scan_complete(int networks_found);
static void cleanup_network_button(lv_event_t *e);
static void ui_update_timer_cb(lv_timer_t *timer);

// Event handlers
static void event_scan_networks(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        ESP_LOGI(TAG, "Scan networks clicked");
        
        // Safety check - make sure we're still on the WiFi screen
        if (!wifi_screen || lv_scr_act() != wifi_screen) {
            ESP_LOGW(TAG, "WiFi screen not active, ignoring scan request");
            return;
        }
        
        if (scan_in_progress) {
            ESP_LOGI(TAG, "Scan already in progress, ignoring request");
            return;
        }
        
        ESP_LOGI(TAG, "Starting WiFi scan...");
        
        // Disable scan button during scan
        if (scan_button) {
            lv_obj_add_state(scan_button, LV_STATE_DISABLED);
        }
        
        if (status_label) {
            lv_label_set_text(status_label, "Status: Initializing WiFi...");
        }
        
        // Reset state flags
        scan_results_ready = false;
        ui_needs_update = false;
        
        // Initialize WiFi manager only when first needed
        esp_err_t err = wifi_manager_init();
        if (err != ESP_OK) {
            ESP_LOGE(TAG, "Failed to initialize WiFi manager");
            if (status_label) {
                lv_label_set_text(status_label, "Status: WiFi Init Failed");
            }
            // Re-enable scan button
            if (scan_button) {
                lv_obj_clear_state(scan_button, LV_STATE_DISABLED);
            }
            return;
        }
        
        // Set the scan completion callback
        wifi_manager_set_scan_callback(on_scan_complete);
        
        if (status_label) {
            lv_label_set_text(status_label, "Status: Scanning...");
        }
        
        // Clear existing networks list while scanning
        if (networks_container) {
            lv_obj_clean(networks_container);
            lv_obj_t *scanning_label = lv_label_create(networks_container);
            lv_label_set_text(scanning_label, "Scanning for networks...");
            lv_obj_set_style_text_color(scanning_label, UI_COLOR_TEXT_SECONDARY, 0);
            lv_obj_center(scanning_label);
        }
        
        // Start non-blocking scan
        scan_in_progress = true;
        
        esp_err_t scan_err = wifi_manager_start_scan();
        if (scan_err != ESP_OK) {
            ESP_LOGE(TAG, "Failed to start WiFi scan: %s", esp_err_to_name(scan_err));
            
            // Reset state on failure
            scan_in_progress = false;
            
            if (status_label) {
                lv_label_set_text(status_label, "Status: Scan Failed");
            }
            
            // Re-enable scan button
            if (scan_button) {
                lv_obj_clear_state(scan_button, LV_STATE_DISABLED);
            }
        }
    }
}

static void event_connect_to_network(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        lv_obj_t *btn = (lv_obj_t*)lv_event_get_target(e);
        const char *ssid = (const char*)lv_obj_get_user_data(btn);
        
        if (ssid) {
            ESP_LOGI(TAG, "Connect to network: %s", ssid);
            
            // Find the AP info to check if it requires a password
            int count;
            wifi_ap_info_t *aps = wifi_manager_get_scan_results(&count);
            wifi_ap_info_t *ap = NULL;
            
            for (int i = 0; i < count; i++) {
                if (strcmp(aps[i].ssid, ssid) == 0) {
                    ap = &aps[i];
                    break;
                }
            }
            
            if (ap && ap->auth_mode == WIFI_AUTH_OPEN) {
                // Open network, connect directly
                wifi_settings_connect_to_network(ssid, "");
            } else {
                // Secured network, show password dialog
                strncpy(selected_ssid, ssid, sizeof(selected_ssid) - 1);
                create_password_dialog(ssid);
            }
        }
    }
}

static void event_password_connect(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        const char *password = lv_textarea_get_text(password_input);
        wifi_settings_connect_to_network(selected_ssid, password);
        destroy_password_dialog();
        update_status_display();
    }
}

static void event_password_cancel(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        destroy_password_dialog();
    }
}

static void event_disconnect(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        ESP_LOGI(TAG, "Disconnect clicked");
        wifi_settings_disconnect();
        update_status_display();
    }
}

// WiFi settings screen creation
lv_obj_t *screen_wifi_settings_create(void) {
    ESP_LOGI(TAG, "Creating WiFi settings screen");
    
    wifi_screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(wifi_screen, UI_COLOR_BACKGROUND, 0);
    
    // Don't initialize WiFi manager here - do it when actually needed
    
    // Add top navigation bar
    ui_create_topbar(wifi_screen, "WiFi Settings");
    
    // Create main container
    lv_obj_t *container = lv_obj_create(wifi_screen);
    lv_obj_set_size(container, LV_PCT(90), lv_disp_get_ver_res(lv_disp_get_default()) - UI_TOPBAR_HEIGHT - 40);
    lv_obj_align(container, LV_ALIGN_TOP_MID, 0, UI_TOPBAR_HEIGHT + 20);
    lv_obj_set_style_bg_opa(container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(container, 0, 0);
    lv_obj_set_style_pad_all(container, 20, 0);
    
    // Status section
    lv_obj_t *status_section = lv_obj_create(container);
    lv_obj_set_size(status_section, LV_PCT(100), 80);
    lv_obj_align(status_section, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_set_style_bg_color(status_section, UI_COLOR_CARD_BG, 0);
    lv_obj_set_style_radius(status_section, 10, 0);
    lv_obj_set_style_pad_all(status_section, 15, 0);
    
    // Status label
    status_label = lv_label_create(status_section);
    lv_label_set_text(status_label, "Status: Disconnected");
    lv_obj_set_style_text_font(status_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_PRIMARY, 0);
    lv_obj_center(status_label);
    
    // Control buttons section
    lv_obj_t *buttons_section = lv_obj_create(container);
    lv_obj_set_size(buttons_section, LV_PCT(100), 60);
    lv_obj_align(buttons_section, LV_ALIGN_TOP_MID, 0, 100);
    lv_obj_set_style_bg_opa(buttons_section, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(buttons_section, 0, 0);
    lv_obj_set_style_pad_all(buttons_section, 0, 0);
    lv_obj_set_flex_flow(buttons_section, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(buttons_section, LV_FLEX_ALIGN_SPACE_BETWEEN, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    
    // Scan button
    scan_button = lv_btn_create(buttons_section);
    lv_obj_set_size(scan_button, 120, 40);
    lv_obj_set_style_bg_color(scan_button, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_radius(scan_button, 8, 0);
    lv_obj_add_event_cb(scan_button, event_scan_networks, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *scan_label = lv_label_create(scan_button);
    lv_label_set_text(scan_label, "Scan");
    lv_obj_set_style_text_font(scan_label, FONT_BUTTON, 0);
    lv_obj_center(scan_label);
    
    // Disconnect button
    lv_obj_t *disconnect_btn = lv_btn_create(buttons_section);
    lv_obj_set_size(disconnect_btn, 120, 40);
    lv_obj_set_style_bg_color(disconnect_btn, UI_COLOR_WARNING, 0);
    lv_obj_set_style_radius(disconnect_btn, 8, 0);
    lv_obj_add_event_cb(disconnect_btn, event_disconnect, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *disconnect_label = lv_label_create(disconnect_btn);
    lv_label_set_text(disconnect_label, "Disconnect");
    lv_obj_set_style_text_font(disconnect_label, FONT_BUTTON, 0);
    lv_obj_center(disconnect_label);
    
    // Networks section title
    lv_obj_t *networks_title = lv_label_create(container);
    lv_label_set_text(networks_title, "Available Networks");
    lv_obj_set_style_text_font(networks_title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(networks_title, UI_COLOR_TEXT_PRIMARY, 0);
    lv_obj_align(networks_title, LV_ALIGN_TOP_LEFT, 0, 180);
    
    // Networks container - simple list without complex layouts
    networks_container = lv_obj_create(container);
    lv_obj_set_size(networks_container, LV_PCT(100), 250);
    lv_obj_align(networks_container, LV_ALIGN_TOP_MID, 0, 210);
    lv_obj_set_style_bg_color(networks_container, UI_COLOR_CARD_BG, 0);
    lv_obj_set_style_radius(networks_container, 10, 0);
    lv_obj_set_style_pad_all(networks_container, 10, 0);
    
    // Use simple flex layout but disable scrolling to prevent issues
    lv_obj_set_flex_flow(networks_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(networks_container, 2, 0);
    lv_obj_clear_flag(networks_container, LV_OBJ_FLAG_SCROLLABLE);
    
    // Add initial message
    lv_obj_t *initial_label = lv_label_create(networks_container);
    lv_label_set_text(initial_label, "Click 'Scan' to find WiFi networks");
    lv_obj_set_style_text_color(initial_label, UI_COLOR_TEXT_SECONDARY, 0);
    lv_obj_set_style_text_font(initial_label, FONT_NORMAL, 0);
    
    // Initial status update
    update_status_display();
    
    // Create UI update timer to safely handle scan results
    ui_update_timer = lv_timer_create(ui_update_timer_cb, 100, NULL); // Check every 100ms
    
    ESP_LOGI(TAG, "WiFi settings screen created successfully");
    return wifi_screen;
}

// WiFi settings screen cleanup
void screen_wifi_settings_cleanup(void) {
    ESP_LOGI(TAG, "Cleaning up WiFi settings screen");
    
    // Stop and delete the UI update timer
    if (ui_update_timer) {
        lv_timer_del(ui_update_timer);
        ui_update_timer = NULL;
    }
    
    // Reset state variables
    scan_in_progress = false;
    scan_results_ready = false;
    ui_needs_update = false;
    
    // Clear screen references
    wifi_screen = NULL;
    status_label = NULL;
    scan_button = NULL;
    networks_container = NULL;
    
    // Close any open dialogs
    destroy_password_dialog();
    
    ESP_LOGI(TAG, "WiFi settings screen cleanup completed");
}

// WiFi settings functions
void wifi_settings_refresh_scan(void) {
    ESP_LOGI(TAG, "Refresh scan requested");
    wifi_manager_start_scan();
}

void wifi_settings_connect_to_network(const char *ssid, const char *password) {
    ESP_LOGI(TAG, "Connect to network: %s", ssid ? ssid : "NULL");
    if (ssid) {
        current_status = WIFI_STATUS_CONNECTING;
        update_status_display();
        wifi_manager_connect(ssid, password);
        
        // Don't block the UI - status will be updated by WiFi events
        // In a proper implementation, you'd use WiFi event callbacks
    }
}

void wifi_settings_disconnect(void) {
    ESP_LOGI(TAG, "Disconnect requested");
    wifi_manager_disconnect();
    current_status = WIFI_STATUS_DISCONNECTED;
    update_status_display();
}

wifi_connection_status_t wifi_settings_get_status(void) {
    return current_status;
}

// Private helper functions
static void update_status_display(void) {
    if (!status_label) return;
    
    current_status = wifi_manager_get_status();
    
    switch (current_status) {
        case WIFI_STATUS_DISCONNECTED:
            lv_label_set_text(status_label, "Status: Disconnected");
            lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_SECONDARY, 0);
            break;
        case WIFI_STATUS_CONNECTING:
            lv_label_set_text(status_label, "Status: Connecting...");
            lv_obj_set_style_text_color(status_label, UI_COLOR_WARNING, 0);
            break;
        case WIFI_STATUS_CONNECTED:
            lv_label_set_text(status_label, "Status: Connected");
            lv_obj_set_style_text_color(status_label, UI_COLOR_SECONDARY, 0);
            break;
        case WIFI_STATUS_FAILED:
            lv_label_set_text(status_label, "Status: Connection Failed");
            lv_obj_set_style_text_color(status_label, UI_COLOR_DANGER, 0);
            break;
    }
}

static void update_networks_list(void) {
    if (!networks_container || !lv_obj_is_valid(networks_container)) {
        ESP_LOGE(TAG, "Networks container is NULL or invalid");
        return;
    }
    
    ESP_LOGI(TAG, "Updating networks list");
    
    // Safely clear existing items
    lv_obj_clean(networks_container);
    
    int count;
    wifi_ap_info_t *aps = wifi_manager_get_scan_results(&count);
    
    ESP_LOGI(TAG, "Found %d networks", count);
    
    if (count == 0) {
        lv_obj_t *no_networks_label = lv_label_create(networks_container);
        lv_label_set_text(no_networks_label, "No networks found");
        lv_obj_set_style_text_color(no_networks_label, UI_COLOR_TEXT_SECONDARY, 0);
        lv_obj_set_style_text_font(no_networks_label, FONT_NORMAL, 0);
        return;
    }
    
    // Limit to what fits in the container without scrolling
    const int max_networks = 5; // Reduced to fit container height
    if (count > max_networks) {
        count = max_networks;
        ESP_LOGW(TAG, "Limiting display to first %d networks", max_networks);
    }
    
    // Create simple clickable labels for each network
    for (int i = 0; i < count; i++) {
        wifi_ap_info_t *ap = &aps[i];
        
        // Create a simple button for each network
        lv_obj_t *network_btn = lv_btn_create(networks_container);
        lv_obj_set_size(network_btn, LV_PCT(100), 40); // Fixed height
        lv_obj_set_style_bg_color(network_btn, UI_COLOR_BACKGROUND, 0);
        lv_obj_set_style_border_width(network_btn, 1, 0);
        lv_obj_set_style_border_color(network_btn, UI_COLOR_SEPARATOR, 0);
        lv_obj_set_style_radius(network_btn, 5, 0);
        lv_obj_set_style_pad_all(network_btn, 5, 0);
        
        // Store SSID
        char *ssid_copy = (char*)malloc(33);
        if (ssid_copy) {
            strncpy(ssid_copy, ap->ssid, 32);
            ssid_copy[32] = '\0';
            lv_obj_set_user_data(network_btn, ssid_copy);
            lv_obj_add_event_cb(network_btn, event_connect_to_network, LV_EVENT_CLICKED, NULL);
            lv_obj_add_event_cb(network_btn, cleanup_network_button, LV_EVENT_DELETE, NULL);
        } else {
            ESP_LOGE(TAG, "Failed to allocate memory for SSID");
            continue;
        }
        
        // Create single label with all info
        lv_obj_t *network_label = lv_label_create(network_btn);
        
        // Format network info in one line
        char network_text[80];
        const char *auth_str = "";
        switch (ap->auth_mode) {
            case WIFI_AUTH_OPEN: auth_str = "Open"; break;
            case WIFI_AUTH_WEP: auth_str = "WEP"; break;
            case WIFI_AUTH_WPA_PSK: auth_str = "WPA"; break;
            case WIFI_AUTH_WPA2_PSK: auth_str = "WPA2"; break;
            case WIFI_AUTH_WPA_WPA2_PSK: auth_str = "WPA"; break;
            case WIFI_AUTH_WPA3_PSK: auth_str = "WPA3"; break;
            default: auth_str = "Sec"; break;
        }
        
        if (ap->connected) {
            snprintf(network_text, sizeof(network_text), "✓ %s (%s, %ddBm)", ap->ssid, auth_str, ap->rssi);
            lv_obj_set_style_text_color(network_label, UI_COLOR_SECONDARY, 0);
        } else {
            snprintf(network_text, sizeof(network_text), "%s (%s, %ddBm)", ap->ssid, auth_str, ap->rssi);
            lv_obj_set_style_text_color(network_label, UI_COLOR_TEXT_PRIMARY, 0);
        }
        
        lv_label_set_text(network_label, network_text);
        lv_obj_set_style_text_font(network_label, FONT_NORMAL, 0);
        lv_obj_center(network_label);
    }
    
    ESP_LOGI(TAG, "Networks list updated with %d items", count);
}

// Helper function to clean up network button user data
static void cleanup_network_button(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_DELETE) {
        lv_obj_t *btn = (lv_obj_t*)lv_event_get_target(e);
        char *ssid_data = (char*)lv_obj_get_user_data(btn);
        if (ssid_data) {
            free(ssid_data);
            lv_obj_set_user_data(btn, NULL);
        }
    }
}

static void create_password_dialog(const char *ssid) {
    // Create modal background
    password_dialog = lv_obj_create(lv_scr_act());
    lv_obj_set_size(password_dialog, LV_PCT(100), LV_PCT(100));
    lv_obj_set_style_bg_color(password_dialog, lv_color_hex(0x000000), 0);
    lv_obj_set_style_bg_opa(password_dialog, LV_OPA_50, 0);
    lv_obj_set_style_border_width(password_dialog, 0, 0);
    
    // Create dialog box
    lv_obj_t *dialog_box = lv_obj_create(password_dialog);
    lv_obj_set_size(dialog_box, 300, 200);
    lv_obj_center(dialog_box);
    lv_obj_set_style_bg_color(dialog_box, UI_COLOR_CARD_BG, 0);
    lv_obj_set_style_radius(dialog_box, 15, 0);
    lv_obj_set_style_pad_all(dialog_box, 20, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(dialog_box);
    lv_label_set_text_fmt(title, "Connect to %s", ssid);
    lv_obj_set_style_text_font(title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(title, UI_COLOR_TEXT_PRIMARY, 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 0);
    
    // Password input
    password_input = lv_textarea_create(dialog_box);
    lv_obj_set_size(password_input, 260, 40);
    lv_obj_align(password_input, LV_ALIGN_TOP_MID, 0, 40);
    lv_textarea_set_placeholder_text(password_input, "Enter password");
    lv_textarea_set_password_mode(password_input, true);
    lv_obj_set_style_text_font(password_input, FONT_NORMAL, 0);
    
    // Button container
    lv_obj_t *btn_container = lv_obj_create(dialog_box);
    lv_obj_set_size(btn_container, 260, 40);
    lv_obj_align(btn_container, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_opa(btn_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(btn_container, 0, 0);
    lv_obj_set_style_pad_all(btn_container, 0, 0);
    lv_obj_set_flex_flow(btn_container, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(btn_container, LV_FLEX_ALIGN_SPACE_BETWEEN, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    
    // Cancel button
    lv_obj_t *cancel_btn = lv_btn_create(btn_container);
    lv_obj_set_size(cancel_btn, 120, 35);
    lv_obj_set_style_bg_color(cancel_btn, UI_COLOR_WARNING, 0);
    lv_obj_set_style_radius(cancel_btn, 8, 0);
    lv_obj_add_event_cb(cancel_btn, event_password_cancel, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *cancel_label = lv_label_create(cancel_btn);
    lv_label_set_text(cancel_label, "Cancel");
    lv_obj_set_style_text_font(cancel_label, FONT_BUTTON, 0);
    lv_obj_center(cancel_label);
    
    // Connect button
    lv_obj_t *connect_btn = lv_btn_create(btn_container);
    lv_obj_set_size(connect_btn, 120, 35);
    lv_obj_set_style_bg_color(connect_btn, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_radius(connect_btn, 8, 0);
    lv_obj_add_event_cb(connect_btn, event_password_connect, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *connect_label = lv_label_create(connect_btn);
    lv_label_set_text(connect_label, "Connect");
    lv_obj_set_style_text_font(connect_label, FONT_BUTTON, 0);
    lv_obj_center(connect_label);
}

static void destroy_password_dialog(void) {
    if (password_dialog) {
        lv_obj_del(password_dialog);
        password_dialog = NULL;
        password_input = NULL;
    }
}

// UI update timer callback - runs in UI task context
static void ui_update_timer_cb(lv_timer_t *timer) {
    (void)timer; // Unused parameter
    
    // Safety checks - ensure we're still on the WiFi screen
    if (!wifi_screen || !lv_obj_is_valid(wifi_screen)) {
        ESP_LOGW(TAG, "WiFi screen invalid, stopping timer updates");
        return;
    }
    
    // Check if the WiFi screen is currently active
    if (lv_scr_act() != wifi_screen) {
        ESP_LOGD(TAG, "WiFi screen not active, skipping update");
        return;
    }
    
    if (ui_needs_update) {
        ui_needs_update = false;
        
        ESP_LOGI(TAG, "Processing UI update after scan completion");
        
        // Re-enable scan button
        if (scan_button && lv_obj_is_valid(scan_button)) {
            lv_obj_clear_state(scan_button, LV_STATE_DISABLED);
        }
        
        // Update networks list only if everything is valid
        if (networks_container && lv_obj_is_valid(networks_container) && scan_results_ready) {
            update_networks_list();
            scan_results_ready = false;
        }
        
        // Update status display
        if (status_label && lv_obj_is_valid(status_label)) {
            update_status_display();
        }
        
        ESP_LOGI(TAG, "UI update completed successfully");
    }
}

// Scan completion callback called from WiFi event handler
static void on_scan_complete(int networks_found) {
    ESP_LOGI(TAG, "Scan complete: %d networks found", networks_found);
    
    // Just set flags - don't update UI from WiFi task
    scan_in_progress = false;
    scan_results_ready = true;
    ui_needs_update = true;
    
    // The UI update timer will handle the actual UI updates
}
