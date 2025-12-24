#include "status_icons.h"
#include "../styles/styles.h"
#include <esp_log.h>
#include <cstdio>

static const char* TAG = "STATUS_ICONS";

namespace {

// Status state
struct StatusState {
    lv_obj_t* container = nullptr;
    lv_obj_t* wifi_icon = nullptr;
    lv_obj_t* battery_icon = nullptr;
    lv_obj_t* battery_pct = nullptr;
    bool wifi_connected = false;
    wifi_signal_level_t wifi_signal = WIFI_SIGNAL_NONE;
    uint8_t battery_percentage = 100;
    bool battery_charging = false;
};

StatusState g_status;

// WiFi symbols based on connection state
const char* get_wifi_symbol(bool connected) {
    // Always show WiFi icon - connected or disconnected indicator
    return LV_SYMBOL_WIFI;
}

uint32_t get_wifi_color(wifi_signal_level_t level) {
    switch (level) {
        case WIFI_SIGNAL_EXCELLENT:
        case WIFI_SIGNAL_GOOD:
            return STYLE_COLOR_TEXT_LIGHT;
        case WIFI_SIGNAL_FAIR:
            return STYLE_COLOR_WARNING;
        case WIFI_SIGNAL_WEAK:
        case WIFI_SIGNAL_NONE:
        default:
            return STYLE_COLOR_TEXT_DIM;
    }
}

// Battery icon - we'll use custom drawing
const char* get_battery_symbol(uint8_t percentage, bool charging) {
    if (charging) return LV_SYMBOL_CHARGE;
    if (percentage > 75) return LV_SYMBOL_BATTERY_FULL;
    if (percentage > 50) return LV_SYMBOL_BATTERY_3;
    if (percentage > 25) return LV_SYMBOL_BATTERY_2;
    if (percentage > 10) return LV_SYMBOL_BATTERY_1;
    return LV_SYMBOL_BATTERY_EMPTY;
}

uint32_t get_battery_color(uint8_t percentage, bool charging) {
    if (charging) return STYLE_COLOR_SUCCESS;
    if (percentage <= 10) return STYLE_COLOR_ERROR;
    if (percentage <= 25) return STYLE_COLOR_WARNING;
    return STYLE_COLOR_TEXT_LIGHT;
}

void update_wifi_display() {
    if (!g_status.wifi_icon || !lv_obj_is_valid(g_status.wifi_icon)) {
        ESP_LOGW(TAG, "WiFi icon invalid, skipping update");
        return;
    }
    
    lv_label_set_text(g_status.wifi_icon, get_wifi_symbol(g_status.wifi_connected));
    
    if (g_status.wifi_connected) {
        // Connected - show in white/color based on signal strength
        lv_obj_set_style_text_color(g_status.wifi_icon, 
            lv_color_hex(get_wifi_color(g_status.wifi_signal)), 0);
        lv_obj_set_style_text_opa(g_status.wifi_icon, LV_OPA_COVER, 0);
    } else {
        // Not connected - show dimmed/grayed out (like iOS)
        lv_obj_set_style_text_color(g_status.wifi_icon, 
            lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
        lv_obj_set_style_text_opa(g_status.wifi_icon, LV_OPA_40, 0);
    }
    lv_obj_clear_flag(g_status.wifi_icon, LV_OBJ_FLAG_HIDDEN);
}

void update_battery_display() {
    if (!g_status.battery_icon || !g_status.battery_pct ||
        !lv_obj_is_valid(g_status.battery_icon) || !lv_obj_is_valid(g_status.battery_pct)) {
        ESP_LOGW(TAG, "Battery icons invalid, skipping update");
        return;
    }
    
    // Update icon
    lv_label_set_text(g_status.battery_icon, 
        get_battery_symbol(g_status.battery_percentage, g_status.battery_charging));
    lv_obj_set_style_text_color(g_status.battery_icon,
        lv_color_hex(get_battery_color(g_status.battery_percentage, g_status.battery_charging)), 0);
    
    // Update percentage text
    char buf[8];
    snprintf(buf, sizeof(buf), "%d%%", g_status.battery_percentage);
    lv_label_set_text(g_status.battery_pct, buf);
}

}  // namespace

lv_obj_t* status_icons_create(lv_obj_t* parent) {
    ESP_LOGI(TAG, "Creating status icons");
    
    // Clean up previous status icons if they exist to prevent orphaned objects
    if (g_status.container != nullptr && lv_obj_is_valid(g_status.container)) {
        ESP_LOGI(TAG, "Cleaning up previous status icons");
        lv_obj_del(g_status.container);
    }
    // Reset state
    g_status = StatusState{};
    
    // Container for status icons - use fixed size to prevent layout jumps
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_remove_style_all(cont);
    lv_obj_set_size(cont, 110, 24);  // Fixed size for WiFi + battery + percentage
    lv_obj_align(cont, LV_ALIGN_RIGHT_MID, 0, 0);
    lv_obj_set_flex_flow(cont, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(cont, LV_FLEX_ALIGN_END, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_column(cont, 8, 0);
    lv_obj_clear_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    
    g_status.container = cont;
    
    // WiFi icon - always visible, opacity indicates connection state
    g_status.wifi_icon = lv_label_create(cont);
    lv_label_set_text(g_status.wifi_icon, LV_SYMBOL_WIFI);
    lv_obj_set_style_text_font(g_status.wifi_icon, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_status.wifi_icon, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_style_text_opa(g_status.wifi_icon, LV_OPA_40, 0);  // Start dimmed (not connected)
    
    // Battery percentage
    g_status.battery_pct = lv_label_create(cont);
    lv_label_set_text(g_status.battery_pct, "100%");
    lv_obj_set_style_text_font(g_status.battery_pct, &lv_font_montserrat_12, 0);
    lv_obj_set_style_text_color(g_status.battery_pct, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Battery icon
    g_status.battery_icon = lv_label_create(cont);
    lv_label_set_text(g_status.battery_icon, LV_SYMBOL_BATTERY_FULL);
    lv_obj_set_style_text_font(g_status.battery_icon, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_status.battery_icon, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Initial update
    update_wifi_display();
    update_battery_display();
    
    return cont;
}

void status_set_wifi(bool connected, wifi_signal_level_t signal_level) {
    g_status.wifi_connected = connected;
    g_status.wifi_signal = signal_level;
    update_wifi_display();
    ESP_LOGI(TAG, "WiFi status: %s, signal: %d", connected ? "connected" : "disconnected", signal_level);
}

void status_set_battery(uint8_t percentage, bool charging) {
    if (percentage > 100) percentage = 100;
    g_status.battery_percentage = percentage;
    g_status.battery_charging = charging;
    update_battery_display();
    ESP_LOGD(TAG, "Battery: %d%%, charging: %s", percentage, charging ? "yes" : "no");
}

bool status_get_wifi_connected(void) {
    return g_status.wifi_connected;
}

uint8_t status_get_battery_percentage(void) {
    return g_status.battery_percentage;
}
