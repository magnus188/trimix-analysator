#include "settings.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"

// Event handlers for settings options
static void event_go_calibrate_o2(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_CALIBRATE_O2);
    }
}

static void event_calibrate_sensors(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Navigate to sensor calibration screen
        // screen_manager_show(SCREEN_SENSOR_CALIBRATION);
    }
}

static void event_software_update(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Navigate to software update screen
        // screen_manager_show(SCREEN_SOFTWARE_UPDATE);
    }
}

static void event_wifi_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Navigate to WiFi settings screen
        // screen_manager_show(SCREEN_WIFI_SETTINGS);
    }
}

static void event_safety_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Navigate to safety settings screen
        // screen_manager_show(SCREEN_SAFETY_SETTINGS);
    }
}

static void event_reset_history(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Show confirmation dialog and reset history
    }
}

static void event_reset_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Show confirmation dialog and reset settings
    }
}

static void event_factory_reset(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        // TODO: Show confirmation dialog and perform factory reset
    }
}

lv_obj_t *screen_settings_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar using component
    ui_create_topbar(screen, "Settings");
    
    // Create static container for settings
    lv_obj_t *container = lv_obj_create(screen);
    lv_obj_set_size(container, LV_PCT(90), lv_disp_get_ver_res(lv_disp_get_default()) - UI_TOPBAR_HEIGHT - 40);
    lv_obj_align(container, LV_ALIGN_TOP_MID, 0, UI_TOPBAR_HEIGHT + 20);
    lv_obj_set_style_bg_opa(container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(container, 0, 0);
    lv_obj_set_style_pad_all(container, 20, 0);
    
    // Create content container with flex layout
    lv_obj_t *content = lv_obj_create(container);
    lv_obj_set_size(content, LV_PCT(100), LV_PCT(100));
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(content, 0, 0);
    lv_obj_set_style_pad_all(content, 0, 0);
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(content, 20, 0);
    
    // Create all settings buttons with Apple-style design
    ui_create_large_button(content, "Calibrate Sensors", UI_COLOR_PRIMARY, event_calibrate_sensors);
    ui_create_large_button(content, "Software Update", UI_COLOR_PRIMARY, event_software_update);
    ui_create_large_button(content, "WiFi Settings", UI_COLOR_PRIMARY, event_wifi_settings);
    ui_create_large_button(content, "Safety Settings", UI_COLOR_PRIMARY, event_safety_settings);
    
    // Destructive actions with warning/danger colors
    ui_create_large_button(content, "Reset History", UI_COLOR_WARNING, event_reset_history);
    ui_create_large_button(content, "Reset Settings", UI_COLOR_WARNING, event_reset_settings);
    ui_create_large_button(content, "Factory Reset", UI_COLOR_DANGER, event_factory_reset);
    
    return screen;
}
