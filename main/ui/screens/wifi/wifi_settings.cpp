// WiFi Settings Screen - Full implementation
#include "wifi_settings.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"
#include "../../widgets/keyboard.h"
#include "esp_log.h"
#include <string.h>

static const char *TAG = "WiFiSettings";

// Screen elements
static lv_obj_t *wifi_screen = NULL;
static lv_obj_t *network_list = NULL;
static lv_obj_t *status_label = NULL;
static lv_obj_t *scan_btn = NULL;
static lv_obj_t *disconnect_btn = NULL;
static lv_obj_t *scan_spinner = NULL;

// Password dialog elements
static lv_obj_t *password_modal = NULL;
static lv_obj_t *password_textarea = NULL;
static lv_obj_t *keyboard_obj = NULL;
static char selected_ssid[33] = {0};

// State
static bool is_scanning = false;

// Forward declarations
static void create_network_list(lv_obj_t *parent);
static void update_network_list(void);
static void update_status_display(void);
static void show_password_dialog(const char *ssid);
static void hide_password_dialog(void);
static void on_scan_complete(int networks_found);
static void on_connection_changed(wifi_connection_status_t status);

// Signal strength to bars (0-4)
static int rssi_to_bars(int8_t rssi) {
    if (rssi >= -50) return 4;      // Excellent
    if (rssi >= -60) return 3;      // Good
    if (rssi >= -70) return 2;      // Fair
    if (rssi >= -80) return 1;      // Weak
    return 0;                        // Very weak
}

// Create signal strength indicator string
static const char* get_signal_icon(int8_t rssi) {
    int bars = rssi_to_bars(rssi);
    switch (bars) {
        case 4: return LV_SYMBOL_WIFI;
        case 3: return LV_SYMBOL_WIFI;
        case 2: return LV_SYMBOL_WIFI;
        case 1: return LV_SYMBOL_WIFI;
        default: return LV_SYMBOL_WIFI;
    }
}

// Get signal strength color
static lv_color_t get_signal_color(int8_t rssi) {
    int bars = rssi_to_bars(rssi);
    switch (bars) {
        case 4: return UI_COLOR_SECONDARY;      // Green - excellent
        case 3: return UI_COLOR_SECONDARY;      // Green - good
        case 2: return UI_COLOR_WARNING;        // Orange - fair
        case 1: return UI_COLOR_WARNING;        // Orange - weak
        default: return UI_COLOR_DANGER;        // Red - very weak
    }
}

// Event handler for scan button
static void event_scan_clicked(lv_event_t *e) {
    (void)e;
    if (!is_scanning) {
        ESP_LOGI(TAG, "Starting WiFi scan");
        is_scanning = true;
        
        // Show spinner, hide button text
        if (scan_spinner) {
            lv_obj_clear_flag(scan_spinner, LV_OBJ_FLAG_HIDDEN);
        }
        lv_obj_t *label = lv_obj_get_child(scan_btn, 0);
        if (label) {
            lv_label_set_text(label, "Scanning...");
        }
        
        // Clear current list
        if (network_list) {
            lv_obj_clean(network_list);
            
            // Show scanning message
            lv_obj_t *msg = lv_label_create(network_list);
            lv_label_set_text(msg, "Scanning for networks...");
            lv_obj_set_style_text_color(msg, UI_COLOR_TEXT_SECONDARY, 0);
            lv_obj_set_style_text_font(msg, FONT_NORMAL, 0);
            lv_obj_set_width(msg, LV_PCT(100));
            lv_obj_set_style_text_align(msg, LV_TEXT_ALIGN_CENTER, 0);
        }
        
        wifi_manager_start_scan();
    }
}

// Event handler for disconnect button
static void event_disconnect_clicked(lv_event_t *e) {
    (void)e;
    ESP_LOGI(TAG, "Disconnecting from WiFi");
    wifi_manager_disconnect();
    update_status_display();
    update_network_list();
}

// Event handler for network item click
static void event_network_clicked(lv_event_t *e) {
    (void)lv_event_get_target(e);  // Not used but available if needed
    const char *ssid = (const char *)lv_event_get_user_data(e);
    
    if (!ssid) return;
    
    ESP_LOGI(TAG, "Network selected: %s", ssid);
    
    // Check if this network requires password
    int count = 0;
    wifi_ap_info_t *results = wifi_manager_get_scan_results(&count);
    
    for (int i = 0; i < count; i++) {
        if (strcmp(results[i].ssid, ssid) == 0) {
            if (results[i].connected) {
                // Already connected, do nothing or show info
                ESP_LOGI(TAG, "Already connected to this network");
                return;
            }
            
            if (results[i].auth_mode == WIFI_AUTH_OPEN) {
                // Open network, connect directly
                ESP_LOGI(TAG, "Connecting to open network");
                wifi_manager_connect(ssid, NULL);
                update_status_display();
            } else {
                // Secured network, show password dialog
                show_password_dialog(ssid);
            }
            break;
        }
    }
}

// Keyboard event callback for password input
static void keyboard_event_handler(const keyboard_event_data_t *event_data, void *user_data) {
    (void)user_data;
    
    if (!password_textarea) return;
    
    switch (event_data->event_type) {
        case KEYBOARD_EVENT_KEY_PRESSED: {
            const char *txt = lv_textarea_get_text(password_textarea);
            size_t len = strlen(txt);
            if (len < 63) {  // Max WiFi password length
                char new_char[2] = {event_data->key_char, '\0'};
                lv_textarea_add_text(password_textarea, new_char);
            }
            break;
        }
        case KEYBOARD_EVENT_BACKSPACE:
            lv_textarea_delete_char(password_textarea);
            break;
        case KEYBOARD_EVENT_SPACE:
            lv_textarea_add_char(password_textarea, ' ');
            break;
        case KEYBOARD_EVENT_ENTER:
            // Connect with entered password
            {
                const char *password = lv_textarea_get_text(password_textarea);
                ESP_LOGI(TAG, "Connecting to %s with password", selected_ssid);
                wifi_manager_connect(selected_ssid, password);
                hide_password_dialog();
                update_status_display();
            }
            break;
        default:
            break;
    }
}

// Event handler for password dialog cancel
static void event_cancel_clicked(lv_event_t *e) {
    (void)e;
    hide_password_dialog();
}

// Event handler for password dialog connect
static void event_connect_clicked(lv_event_t *e) {
    (void)e;
    if (password_textarea) {
        const char *password = lv_textarea_get_text(password_textarea);
        ESP_LOGI(TAG, "Connecting to %s", selected_ssid);
        wifi_manager_connect(selected_ssid, password);
        hide_password_dialog();
        update_status_display();
    }
}

// Show password entry dialog
static void show_password_dialog(const char *ssid) {
    if (password_modal) {
        hide_password_dialog();
    }
    
    strncpy(selected_ssid, ssid, sizeof(selected_ssid) - 1);
    selected_ssid[sizeof(selected_ssid) - 1] = '\0';
    
    // Create modal overlay
    password_modal = lv_obj_create(wifi_screen);
    lv_obj_set_size(password_modal, LV_PCT(100), LV_PCT(100));
    lv_obj_align(password_modal, LV_ALIGN_CENTER, 0, 0);
    lv_obj_set_style_bg_color(password_modal, lv_color_black(), 0);
    lv_obj_set_style_bg_opa(password_modal, LV_OPA_70, 0);
    lv_obj_set_style_border_width(password_modal, 0, 0);
    lv_obj_clear_flag(password_modal, LV_OBJ_FLAG_SCROLLABLE);
    
    // Create dialog box
    lv_obj_t *dialog = lv_obj_create(password_modal);
    lv_obj_set_size(dialog, 700, 400);
    lv_obj_align(dialog, LV_ALIGN_CENTER, 0, -20);
    lv_obj_set_style_bg_color(dialog, UI_COLOR_CARD_BG, 0);
    lv_obj_set_style_radius(dialog, 16, 0);
    lv_obj_set_style_border_width(dialog, 0, 0);
    lv_obj_set_style_pad_all(dialog, 20, 0);
    lv_obj_clear_flag(dialog, LV_OBJ_FLAG_SCROLLABLE);
    
    // Title
    lv_obj_t *title = lv_label_create(dialog);
    lv_label_set_text_fmt(title, "Connect to %s", ssid);
    lv_obj_set_style_text_font(title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(title, UI_COLOR_TEXT_PRIMARY, 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 0);
    
    // Password label
    lv_obj_t *pwd_label = lv_label_create(dialog);
    lv_label_set_text(pwd_label, "Password:");
    lv_obj_set_style_text_font(pwd_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(pwd_label, UI_COLOR_TEXT_SECONDARY, 0);
    lv_obj_align(pwd_label, LV_ALIGN_TOP_LEFT, 10, 45);
    
    // Password text area
    password_textarea = lv_textarea_create(dialog);
    lv_obj_set_size(password_textarea, 660, 50);
    lv_obj_align(password_textarea, LV_ALIGN_TOP_MID, 0, 75);
    lv_textarea_set_password_mode(password_textarea, true);
    lv_textarea_set_one_line(password_textarea, true);
    lv_textarea_set_placeholder_text(password_textarea, "Enter WiFi password");
    lv_obj_set_style_text_font(password_textarea, FONT_NORMAL, 0);
    lv_obj_set_style_bg_color(password_textarea, lv_color_hex(0x2A2A2A), 0);
    lv_obj_set_style_text_color(password_textarea, UI_COLOR_TEXT_PRIMARY, 0);
    lv_obj_set_style_border_color(password_textarea, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(password_textarea, 2, 0);
    lv_obj_set_style_radius(password_textarea, 8, 0);
    
    // Button container
    lv_obj_t *btn_container = lv_obj_create(dialog);
    lv_obj_set_size(btn_container, 660, 60);
    lv_obj_align(btn_container, LV_ALIGN_TOP_MID, 0, 135);
    lv_obj_set_style_bg_opa(btn_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(btn_container, 0, 0);
    lv_obj_set_style_pad_all(btn_container, 0, 0);
    lv_obj_set_flex_flow(btn_container, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(btn_container, LV_FLEX_ALIGN_SPACE_BETWEEN, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_clear_flag(btn_container, LV_OBJ_FLAG_SCROLLABLE);
    
    // Cancel button
    lv_obj_t *cancel_btn = lv_btn_create(btn_container);
    lv_obj_set_size(cancel_btn, 200, 50);
    lv_obj_set_style_bg_color(cancel_btn, UI_COLOR_SEPARATOR, 0);
    lv_obj_set_style_radius(cancel_btn, 12, 0);
    lv_obj_add_event_cb(cancel_btn, event_cancel_clicked, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *cancel_label = lv_label_create(cancel_btn);
    lv_label_set_text(cancel_label, "Cancel");
    lv_obj_set_style_text_font(cancel_label, FONT_BUTTON, 0);
    lv_obj_center(cancel_label);
    
    // Connect button
    lv_obj_t *connect_btn = lv_btn_create(btn_container);
    lv_obj_set_size(connect_btn, 200, 50);
    lv_obj_set_style_bg_color(connect_btn, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_radius(connect_btn, 12, 0);
    lv_obj_add_event_cb(connect_btn, event_connect_clicked, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *connect_label = lv_label_create(connect_btn);
    lv_label_set_text(connect_label, "Connect");
    lv_obj_set_style_text_font(connect_label, FONT_BUTTON, 0);
    lv_obj_center(connect_label);
    
    // Create keyboard
    keyboard_obj = keyboard_create_compact(dialog, 660, 180, keyboard_event_handler, NULL);
    lv_obj_align(keyboard_obj, LV_ALIGN_BOTTOM_MID, 0, 0);
}

// Hide password dialog
static void hide_password_dialog(void) {
    if (password_modal) {
        if (keyboard_obj) {
            keyboard_destroy(keyboard_obj);
            keyboard_obj = NULL;
        }
        lv_obj_delete(password_modal);
        password_modal = NULL;
        password_textarea = NULL;
    }
    memset(selected_ssid, 0, sizeof(selected_ssid));
}

// Callback when scan completes
static void on_scan_complete(int networks_found) {
    ESP_LOGI(TAG, "Scan complete, found %d networks", networks_found);
    is_scanning = false;
    
    // Restore scan button
    if (scan_btn) {
        lv_obj_t *label = lv_obj_get_child(scan_btn, 0);
        if (label) {
            lv_label_set_text(label, "Scan");
        }
    }
    if (scan_spinner) {
        lv_obj_add_flag(scan_spinner, LV_OBJ_FLAG_HIDDEN);
    }
    
    update_network_list();
}

// Callback when connection status changes
static void on_connection_changed(wifi_connection_status_t status) {
    ESP_LOGI(TAG, "Connection status changed: %d", status);
    update_status_display();
    update_network_list();
    
    // Update global WiFi icon
    ui_update_wifi_status();
}

// Update the status display
static void update_status_display(void) {
    if (!status_label) return;
    
    wifi_connection_status_t status = wifi_manager_get_status();
    
    switch (status) {
        case WIFI_STATUS_DISCONNECTED:
            lv_label_set_text(status_label, "Status: Not connected");
            lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_SECONDARY, 0);
            if (disconnect_btn) lv_obj_add_flag(disconnect_btn, LV_OBJ_FLAG_HIDDEN);
            break;
        case WIFI_STATUS_CONNECTING:
            lv_label_set_text(status_label, "Status: Connecting...");
            lv_obj_set_style_text_color(status_label, UI_COLOR_WARNING, 0);
            if (disconnect_btn) lv_obj_add_flag(disconnect_btn, LV_OBJ_FLAG_HIDDEN);
            break;
        case WIFI_STATUS_CONNECTED: {
            // Get connected network name from scan results
            int count = 0;
            wifi_ap_info_t *results = wifi_manager_get_scan_results(&count);
            const char *connected_ssid = "Unknown";
            for (int i = 0; i < count; i++) {
                if (results[i].connected) {
                    connected_ssid = results[i].ssid;
                    break;
                }
            }
            lv_label_set_text_fmt(status_label, "Connected to: %s", connected_ssid);
            lv_obj_set_style_text_color(status_label, UI_COLOR_SECONDARY, 0);
            if (disconnect_btn) lv_obj_clear_flag(disconnect_btn, LV_OBJ_FLAG_HIDDEN);
            break;
        }
        case WIFI_STATUS_FAILED:
            lv_label_set_text(status_label, "Status: Connection failed");
            lv_obj_set_style_text_color(status_label, UI_COLOR_DANGER, 0);
            if (disconnect_btn) lv_obj_add_flag(disconnect_btn, LV_OBJ_FLAG_HIDDEN);
            break;
    }
}

// Update the network list with scan results
static void update_network_list(void) {
    if (!network_list) return;
    
    // Clear current list
    lv_obj_clean(network_list);
    
    int count = 0;
    wifi_ap_info_t *results = wifi_manager_get_scan_results(&count);
    
    if (count == 0) {
        lv_obj_t *msg = lv_label_create(network_list);
        lv_label_set_text(msg, "No networks found.\nTap 'Scan' to search.");
        lv_obj_set_style_text_color(msg, UI_COLOR_TEXT_SECONDARY, 0);
        lv_obj_set_style_text_font(msg, FONT_NORMAL, 0);
        lv_obj_set_width(msg, LV_PCT(100));
        lv_obj_set_style_text_align(msg, LV_TEXT_ALIGN_CENTER, 0);
        return;
    }
    
    // Create network items
    for (int i = 0; i < count; i++) {
        if (strlen(results[i].ssid) == 0) continue;  // Skip hidden networks
        
        // Network item container (button)
        lv_obj_t *item = lv_btn_create(network_list);
        lv_obj_set_size(item, LV_PCT(100), 60);
        lv_obj_set_style_bg_color(item, UI_COLOR_CARD_BG, 0);
        lv_obj_set_style_bg_color(item, lv_color_hex(0x2A2A2A), LV_STATE_PRESSED);
        lv_obj_set_style_radius(item, 12, 0);
        lv_obj_set_style_border_width(item, 0, 0);
        lv_obj_set_style_pad_hor(item, 15, 0);
        
        // Store SSID pointer for event handler (results array is static)
        lv_obj_add_event_cb(item, event_network_clicked, LV_EVENT_CLICKED, (void*)results[i].ssid);
        
        // Signal strength icon (left side)
        lv_obj_t *signal = lv_label_create(item);
        lv_label_set_text(signal, get_signal_icon(results[i].rssi));
        lv_obj_set_style_text_color(signal, get_signal_color(results[i].rssi), 0);
        lv_obj_set_style_text_font(signal, FONT_NORMAL, 0);
        lv_obj_align(signal, LV_ALIGN_LEFT_MID, 0, 0);
        
        // SSID name
        lv_obj_t *name = lv_label_create(item);
        lv_label_set_text(name, results[i].ssid);
        lv_obj_set_style_text_font(name, FONT_NORMAL, 0);
        lv_obj_set_style_text_color(name, UI_COLOR_TEXT_PRIMARY, 0);
        lv_obj_align(name, LV_ALIGN_LEFT_MID, 45, 0);
        lv_obj_set_width(name, 400);
        lv_label_set_long_mode(name, LV_LABEL_LONG_DOT);
        
        // Status/security indicator (right side)
        lv_obj_t *status = lv_label_create(item);
        if (results[i].connected) {
            lv_label_set_text(status, "Connected");
            lv_obj_set_style_text_color(status, UI_COLOR_SECONDARY, 0);
        } else if (results[i].auth_mode != WIFI_AUTH_OPEN) {
            lv_label_set_text(status, "Secured");
            lv_obj_set_style_text_color(status, UI_COLOR_TEXT_SECONDARY, 0);
        } else {
            lv_label_set_text(status, "Open");
            lv_obj_set_style_text_color(status, UI_COLOR_TEXT_SECONDARY, 0);
        }
        lv_obj_set_style_text_font(status, FONT_NORMAL, 0);
        lv_obj_align(status, LV_ALIGN_RIGHT_MID, 0, 0);
    }
}

// Create the network list container
static void create_network_list(lv_obj_t *parent) {
    // List container
    network_list = lv_obj_create(parent);
    lv_obj_set_size(network_list, LV_PCT(100), 280);
    lv_obj_set_style_bg_opa(network_list, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(network_list, 0, 0);
    lv_obj_set_style_pad_all(network_list, 0, 0);
    lv_obj_set_flex_flow(network_list, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(network_list, 10, 0);
    
    // Initial message
    lv_obj_t *msg = lv_label_create(network_list);
    lv_label_set_text(msg, "Tap 'Scan' to search for networks");
    lv_obj_set_style_text_color(msg, UI_COLOR_TEXT_SECONDARY, 0);
    lv_obj_set_style_text_font(msg, FONT_NORMAL, 0);
    lv_obj_set_width(msg, LV_PCT(100));
    lv_obj_set_style_text_align(msg, LV_TEXT_ALIGN_CENTER, 0);
}

lv_obj_t *screen_wifi_settings_create(void) {
    ESP_LOGI(TAG, "Creating WiFi settings screen");
    
    // Initialize WiFi manager
    wifi_manager_init();
    
    // Register callbacks
    wifi_manager_set_scan_callback(on_scan_complete);
    wifi_manager_set_connection_callback(on_connection_changed);
    
    wifi_screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(wifi_screen, UI_COLOR_BACKGROUND, 0);
    lv_obj_clear_flag(wifi_screen, LV_OBJ_FLAG_SCROLLABLE);
    
    ui_create_topbar(wifi_screen, "WiFi Settings");
    
    // Main content container
    lv_obj_t *container = lv_obj_create(wifi_screen);
    lv_obj_set_size(container, LV_PCT(90), lv_disp_get_ver_res(lv_disp_get_default()) - UI_TOPBAR_HEIGHT - 40);
    lv_obj_align(container, LV_ALIGN_TOP_MID, 0, UI_TOPBAR_HEIGHT + 20);
    lv_obj_set_style_bg_opa(container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(container, 0, 0);
    lv_obj_set_style_pad_all(container, 10, 0);
    lv_obj_set_flex_flow(container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(container, 15, 0);
    lv_obj_clear_flag(container, LV_OBJ_FLAG_SCROLLABLE);
    
    // Status bar container
    lv_obj_t *status_bar = lv_obj_create(container);
    lv_obj_set_size(status_bar, LV_PCT(100), 50);
    lv_obj_set_style_bg_color(status_bar, UI_COLOR_CARD_BG, 0);
    lv_obj_set_style_radius(status_bar, 12, 0);
    lv_obj_set_style_border_width(status_bar, 0, 0);
    lv_obj_set_style_pad_hor(status_bar, 15, 0);
    lv_obj_clear_flag(status_bar, LV_OBJ_FLAG_SCROLLABLE);
    
    // Status label
    status_label = lv_label_create(status_bar);
    lv_label_set_text(status_label, "Status: Not connected");
    lv_obj_set_style_text_font(status_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_SECONDARY, 0);
    lv_obj_align(status_label, LV_ALIGN_LEFT_MID, 0, 0);
    
    // Button row container
    lv_obj_t *btn_row = lv_obj_create(container);
    lv_obj_set_size(btn_row, LV_PCT(100), 60);
    lv_obj_set_style_bg_opa(btn_row, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(btn_row, 0, 0);
    lv_obj_set_style_pad_all(btn_row, 0, 0);
    lv_obj_set_flex_flow(btn_row, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(btn_row, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_gap(btn_row, 15, 0);
    lv_obj_clear_flag(btn_row, LV_OBJ_FLAG_SCROLLABLE);
    
    // Scan button
    scan_btn = lv_btn_create(btn_row);
    lv_obj_set_size(scan_btn, 150, 50);
    lv_obj_set_style_bg_color(scan_btn, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_radius(scan_btn, 12, 0);
    lv_obj_add_event_cb(scan_btn, event_scan_clicked, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *scan_label = lv_label_create(scan_btn);
    lv_label_set_text(scan_label, "Scan");
    lv_obj_set_style_text_font(scan_label, FONT_BUTTON, 0);
    lv_obj_center(scan_label);
    
    // Disconnect button (hidden when not connected)
    disconnect_btn = lv_btn_create(btn_row);
    lv_obj_set_size(disconnect_btn, 180, 50);
    lv_obj_set_style_bg_color(disconnect_btn, UI_COLOR_DANGER, 0);
    lv_obj_set_style_radius(disconnect_btn, 12, 0);
    lv_obj_add_event_cb(disconnect_btn, event_disconnect_clicked, LV_EVENT_CLICKED, NULL);
    lv_obj_add_flag(disconnect_btn, LV_OBJ_FLAG_HIDDEN);  // Hidden by default
    
    lv_obj_t *disconnect_label = lv_label_create(disconnect_btn);
    lv_label_set_text(disconnect_label, "Disconnect");
    lv_obj_set_style_text_font(disconnect_label, FONT_BUTTON, 0);
    lv_obj_center(disconnect_label);
    
    // Network list section title
    lv_obj_t *list_title = lv_label_create(container);
    lv_label_set_text(list_title, "Available Networks");
    lv_obj_set_style_text_font(list_title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(list_title, UI_COLOR_TEXT_PRIMARY, 0);
    
    // Create network list
    create_network_list(container);
    
    // Update status display
    update_status_display();
    
    return wifi_screen;
}

void screen_wifi_settings_cleanup(void) {
    hide_password_dialog();
    wifi_screen = NULL;
    network_list = NULL;
    status_label = NULL;
    scan_btn = NULL;
    disconnect_btn = NULL;
    scan_spinner = NULL;
}

void wifi_settings_refresh_scan(void) {
    if (wifi_screen && !is_scanning) {
        wifi_manager_start_scan();
    }
}

void wifi_settings_connect_to_network(const char *ssid, const char *password) {
    if (ssid) {
        wifi_manager_connect(ssid, password);
    }
}

void wifi_settings_disconnect(void) {
    wifi_manager_disconnect();
}

wifi_connection_status_t wifi_settings_get_status(void) {
    return wifi_manager_get_status();
}
