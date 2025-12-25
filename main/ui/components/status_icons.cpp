#include "status_icons.h"
#include "../styles/styles.h"
#include <esp_log.h>
#include <cstdio>
#include <vector>
#include <algorithm>

static const char* TAG = "STATUS_ICONS";

namespace {

// Track all status icon instances for global updates
struct StatusInstance {
    lv_obj_t* container;
    lv_obj_t* wifi_icon;
    lv_obj_t* battery_icon;
    lv_obj_t* battery_pct;
};

std::vector<StatusInstance> g_instances;

// Global status state (shared across all instances)
bool g_wifi_connected = false;
wifi_signal_level_t g_wifi_signal = WIFI_SIGNAL_NONE;
uint8_t g_battery_percentage = 100;
bool g_battery_charging = false;

// WiFi symbols based on connection state
const char* get_wifi_symbol(bool connected) {
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

// Remove invalid instances from tracking list
void cleanup_invalid_instances() {
    g_instances.erase(
        std::remove_if(g_instances.begin(), g_instances.end(), 
            [](const StatusInstance& inst) {
                return !inst.container || !lv_obj_is_valid(inst.container);
            }),
        g_instances.end()
    );
}

// Update a single instance's WiFi display
void update_wifi_for_instance(const StatusInstance& inst) {
    if (!inst.wifi_icon || !lv_obj_is_valid(inst.wifi_icon)) return;
    
    lv_label_set_text(inst.wifi_icon, get_wifi_symbol(g_wifi_connected));
    
    if (g_wifi_connected) {
        lv_obj_set_style_text_color(inst.wifi_icon, 
            lv_color_hex(get_wifi_color(g_wifi_signal)), 0);
        lv_obj_set_style_text_opa(inst.wifi_icon, LV_OPA_COVER, 0);
    } else {
        lv_obj_set_style_text_color(inst.wifi_icon, 
            lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
        lv_obj_set_style_text_opa(inst.wifi_icon, LV_OPA_40, 0);
    }
    lv_obj_clear_flag(inst.wifi_icon, LV_OBJ_FLAG_HIDDEN);
}

// Update a single instance's battery display
void update_battery_for_instance(const StatusInstance& inst) {
    if (!inst.battery_icon || !inst.battery_pct ||
        !lv_obj_is_valid(inst.battery_icon) || !lv_obj_is_valid(inst.battery_pct)) return;
    
    lv_label_set_text(inst.battery_icon, 
        get_battery_symbol(g_battery_percentage, g_battery_charging));
    lv_obj_set_style_text_color(inst.battery_icon,
        lv_color_hex(get_battery_color(g_battery_percentage, g_battery_charging)), 0);
    
    char buf[8];
    snprintf(buf, sizeof(buf), "%d%%", g_battery_percentage);
    lv_label_set_text(inst.battery_pct, buf);
}

// Update all instances
void update_all_wifi() {
    cleanup_invalid_instances();
    for (const auto& inst : g_instances) {
        update_wifi_for_instance(inst);
    }
}

void update_all_battery() {
    cleanup_invalid_instances();
    for (const auto& inst : g_instances) {
        update_battery_for_instance(inst);
    }
}

}  // namespace

lv_obj_t* status_icons_create(lv_obj_t* parent) {
    ESP_LOGI(TAG, "Creating status icons (total instances: %d)", (int)g_instances.size());
    
    // Clean up any invalid instances first
    cleanup_invalid_instances();
    
    // Container for status icons - use fixed size to prevent layout jumps
    lv_obj_t* cont = lv_obj_create(parent);
    lv_obj_remove_style_all(cont);
    lv_obj_set_size(cont, 110, 24);
    lv_obj_align(cont, LV_ALIGN_RIGHT_MID, 0, 0);
    lv_obj_set_flex_flow(cont, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(cont, LV_FLEX_ALIGN_END, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_column(cont, 8, 0);
    lv_obj_clear_flag(cont, LV_OBJ_FLAG_SCROLLABLE);
    
    // Create new instance
    StatusInstance inst;
    inst.container = cont;
    
    // WiFi icon
    inst.wifi_icon = lv_label_create(cont);
    lv_label_set_text(inst.wifi_icon, LV_SYMBOL_WIFI);
    lv_obj_set_style_text_font(inst.wifi_icon, &lv_font_montserrat_16, 0);
    if (g_wifi_connected) {
        lv_obj_set_style_text_color(inst.wifi_icon, lv_color_hex(get_wifi_color(g_wifi_signal)), 0);
        lv_obj_set_style_text_opa(inst.wifi_icon, LV_OPA_COVER, 0);
    } else {
        lv_obj_set_style_text_color(inst.wifi_icon, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
        lv_obj_set_style_text_opa(inst.wifi_icon, LV_OPA_40, 0);
    }
    
    // Battery percentage
    inst.battery_pct = lv_label_create(cont);
    char buf[8];
    snprintf(buf, sizeof(buf), "%d%%", g_battery_percentage);
    lv_label_set_text(inst.battery_pct, buf);
    lv_obj_set_style_text_font(inst.battery_pct, &lv_font_montserrat_12, 0);
    lv_obj_set_style_text_color(inst.battery_pct, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Battery icon
    inst.battery_icon = lv_label_create(cont);
    lv_label_set_text(inst.battery_icon, get_battery_symbol(g_battery_percentage, g_battery_charging));
    lv_obj_set_style_text_font(inst.battery_icon, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(inst.battery_icon, 
        lv_color_hex(get_battery_color(g_battery_percentage, g_battery_charging)), 0);
    
    // Track this instance for future updates
    g_instances.push_back(inst);
    
    ESP_LOGI(TAG, "Status icons created, now tracking %d instance(s)", (int)g_instances.size());
    return cont;
}

void status_set_wifi(bool connected, wifi_signal_level_t signal_level) {
    g_wifi_connected = connected;
    g_wifi_signal = signal_level;
    update_all_wifi();
    ESP_LOGI(TAG, "WiFi status: %s, signal: %d (updating %d instances)", 
             connected ? "connected" : "disconnected", signal_level, (int)g_instances.size());
}

void status_set_battery(uint8_t percentage, bool charging) {
    if (percentage > 100) percentage = 100;
    g_battery_percentage = percentage;
    g_battery_charging = charging;
    update_all_battery();
    ESP_LOGD(TAG, "Battery: %d%%, charging: %s (updating %d instances)", 
             percentage, charging ? "yes" : "no", (int)g_instances.size());
}

bool status_get_wifi_connected(void) {
    return g_wifi_connected;
}

uint8_t status_get_battery_percentage(void) {
    return g_battery_percentage;
}
