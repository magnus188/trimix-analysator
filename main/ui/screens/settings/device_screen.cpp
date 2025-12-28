#include "device_screen.h"
#include "../screen_manager.h"
#include "../../components/navbar.h"
#include "../../styles/styles.h"
#include "../../../services/settings_service.h"
#include "../../../services/backlight_service.h"
#include <esp_log.h>
#include <cstdio>

static const char* TAG = "DEVICE_SCREEN";

namespace {

// Layout constants
constexpr int SCREEN_WIDTH = 480;
constexpr int SCREEN_HEIGHT = 800;
constexpr int ITEM_HEIGHT = 56;
constexpr int SLIDER_ROW_HEIGHT = 80;
constexpr int ITEM_PAD = 8;
constexpr int CONTENT_PAD = 16;

// UI state
struct DeviceScreenState {
    lv_obj_t* screen = nullptr;
    lv_obj_t* brightness_slider = nullptr;
    lv_obj_t* brightness_label = nullptr;
    lv_obj_t* timeout_btns = nullptr;
    lv_obj_t* sound_switch = nullptr;
    lv_obj_t* depth_btns = nullptr;
    lv_obj_t* temp_btns = nullptr;
    lv_obj_t* pressure_btns = nullptr;
};

DeviceScreenState g_state;

// Forward declarations
void on_brightness_change(lv_event_t* e);
void on_timeout_change(lv_event_t* e);
void on_sound_change(lv_event_t* e);
void on_depth_unit_change(lv_event_t* e);
void on_temp_unit_change(lv_event_t* e);
void on_pressure_unit_change(lv_event_t* e);
void on_reset_click(lv_event_t* e);
void back_cb(lv_event_t* e);

// Update brightness label
void update_brightness_label(int value) {
    if (g_state.brightness_label) {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d%%", value);
        lv_label_set_text(g_state.brightness_label, buf);
    }
}

// Event handlers
void on_brightness_change(lv_event_t* e) {
    // Debounce to prevent rapid LEDC calls that crash the device
    static uint32_t last_update = 0;
    uint32_t now = lv_tick_get();
    if (now - last_update < 50) return;  // 50ms debounce
    last_update = now;
    
    lv_obj_t* slider = (lv_obj_t*)lv_event_get_target(e);
    int value = lv_slider_get_value(slider);
    update_brightness_label(value);
    settings_set(SETTING_BRIGHTNESS, value);
    backlight_set(value);  // Actually apply brightness!
}

void on_timeout_change(lv_event_t* e) {
    lv_obj_t* btnm = (lv_obj_t*)lv_event_get_target(e);
    uint32_t id = lv_buttonmatrix_get_selected_button(btnm);
    if (id != LV_BUTTONMATRIX_BUTTON_NONE) {
        settings_set(SETTING_SCREEN_TIMEOUT, id);
        const char* labels[] = {"never", "1 min", "3 min", "5 min"};
        ESP_LOGI(TAG, "Screen timeout: %s", labels[id]);
    }
}

void on_sound_change(lv_event_t* e) {
    lv_obj_t* sw = (lv_obj_t*)lv_event_get_target(e);
    bool enabled = lv_obj_has_state(sw, LV_STATE_CHECKED);
    settings_set(SETTING_SOUND_ENABLED, enabled ? 1 : 0);
    ESP_LOGI(TAG, "Sound %s", enabled ? "enabled" : "disabled");
}

void on_depth_unit_change(lv_event_t* e) {
    lv_obj_t* btnm = (lv_obj_t*)lv_event_get_target(e);
    uint32_t id = lv_buttonmatrix_get_selected_button(btnm);
    if (id != LV_BUTTONMATRIX_BUTTON_NONE) {
        settings_set(SETTING_UNITS_DEPTH, id);
        ESP_LOGI(TAG, "Depth units: %s", id == 0 ? "meters" : "feet");
    }
}

void on_temp_unit_change(lv_event_t* e) {
    lv_obj_t* btnm = (lv_obj_t*)lv_event_get_target(e);
    uint32_t id = lv_buttonmatrix_get_selected_button(btnm);
    if (id != LV_BUTTONMATRIX_BUTTON_NONE) {
        settings_set(SETTING_UNITS_TEMP, id);
        ESP_LOGI(TAG, "Temp units: %s", id == 0 ? "celsius" : "fahrenheit");
    }
}

void on_pressure_unit_change(lv_event_t* e) {
    lv_obj_t* btnm = (lv_obj_t*)lv_event_get_target(e);
    uint32_t id = lv_buttonmatrix_get_selected_button(btnm);
    if (id != LV_BUTTONMATRIX_BUTTON_NONE) {
        settings_set(SETTING_UNITS_PRESSURE, id);
        ESP_LOGI(TAG, "Pressure units: %s", id == 0 ? "bar" : "psi");
    }
}

void on_reset_click(lv_event_t* e) {
    ESP_LOGI(TAG, "Resetting device settings to defaults");
    settings_reset_category(SETTINGS_CAT_DEVICE);
    
    // Update UI
    int brightness = settings_get(SETTING_BRIGHTNESS);
    lv_slider_set_value(g_state.brightness_slider, brightness, LV_ANIM_ON);
    update_brightness_label(brightness);
    backlight_set(brightness);
    
    // Timeout buttons
    for (uint32_t i = 0; i < 4; i++) {
        lv_buttonmatrix_clear_button_ctrl(g_state.timeout_btns, i, LV_BUTTONMATRIX_CTRL_CHECKED);
    }
    lv_buttonmatrix_set_button_ctrl(g_state.timeout_btns, settings_get(SETTING_SCREEN_TIMEOUT), LV_BUTTONMATRIX_CTRL_CHECKED);
    
    // Sound
    if (settings_get(SETTING_SOUND_ENABLED)) {
        lv_obj_add_state(g_state.sound_switch, LV_STATE_CHECKED);
    } else {
        lv_obj_clear_state(g_state.sound_switch, LV_STATE_CHECKED);
    }
    
    // Reset unit buttons
    for (uint32_t i = 0; i < 2; i++) {
        lv_buttonmatrix_clear_button_ctrl(g_state.depth_btns, i, LV_BUTTONMATRIX_CTRL_CHECKED);
        lv_buttonmatrix_clear_button_ctrl(g_state.temp_btns, i, LV_BUTTONMATRIX_CTRL_CHECKED);
        lv_buttonmatrix_clear_button_ctrl(g_state.pressure_btns, i, LV_BUTTONMATRIX_CTRL_CHECKED);
    }
    lv_buttonmatrix_set_button_ctrl(g_state.depth_btns, settings_get(SETTING_UNITS_DEPTH), LV_BUTTONMATRIX_CTRL_CHECKED);
    lv_buttonmatrix_set_button_ctrl(g_state.temp_btns, settings_get(SETTING_UNITS_TEMP), LV_BUTTONMATRIX_CTRL_CHECKED);
    lv_buttonmatrix_set_button_ctrl(g_state.pressure_btns, settings_get(SETTING_UNITS_PRESSURE), LV_BUTTONMATRIX_CTRL_CHECKED);
}

void back_cb(lv_event_t* e) {
    screen_manager_show(SCREEN_SETTINGS);
}

// Helper to create section header
lv_obj_t* create_section_header(lv_obj_t* parent, const char* title) {
    lv_obj_t* label = lv_label_create(parent);
    lv_label_set_text(label, title);
    lv_obj_set_style_text_font(label, styles_get_font_bold(), 0);
    lv_obj_set_style_text_color(label, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_set_width(label, LV_PCT(100));
    lv_obj_set_style_pad_top(label, 8, 0);
    return label;
}

// Style a button matrix for selection
void style_btnmatrix(lv_obj_t* btnm) {
    lv_obj_set_style_bg_color(btnm, lv_color_hex(0x3A3A3A), LV_PART_MAIN);
    lv_obj_set_style_border_width(btnm, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(btnm, 2, LV_PART_MAIN);
    lv_obj_set_style_radius(btnm, 8, LV_PART_MAIN);
    
    lv_obj_set_style_bg_opa(btnm, LV_OPA_TRANSP, LV_PART_ITEMS);
    lv_obj_set_style_text_color(btnm, lv_color_hex(STYLE_COLOR_TEXT_DIM), LV_PART_ITEMS);
    lv_obj_set_style_text_font(btnm, &lv_font_montserrat_14, LV_PART_ITEMS);
    lv_obj_set_style_border_width(btnm, 0, LV_PART_ITEMS);
    lv_obj_set_style_radius(btnm, 6, LV_PART_ITEMS);
    
    lv_style_selector_t checked = static_cast<lv_style_selector_t>(LV_PART_ITEMS) | 
                                   static_cast<lv_style_selector_t>(LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(btnm, lv_color_hex(STYLE_COLOR_PRIMARY), checked);
    lv_obj_set_style_bg_opa(btnm, LV_OPA_COVER, checked);
    lv_obj_set_style_text_color(btnm, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), checked);
}

}  // namespace

// Static button maps
static const char* timeout_map[] = {"Never", "1m", "3m", "5m", ""};
static const char* depth_map[] = {"m", "ft", ""};
static const char* temp_map[] = {"C", "F", ""};
static const char* pres_map[] = {"bar", "psi", ""};

lv_obj_t* device_screen_create(void) {
    ESP_LOGI(TAG, "Creating device settings screen");
    
    // Screen base
    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BG_DARK), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    g_state.screen = screen;
    
    // Navbar
    navbar_create_with_back(screen, "Device Settings", back_cb);
    
    // Content container - fixed layout, no scrolling
    lv_coord_t navbar_h = navbar_get_height();
    lv_obj_t* content = lv_obj_create(screen);
    lv_obj_remove_style_all(content);
    lv_obj_set_pos(content, CONTENT_PAD, navbar_h + CONTENT_PAD);
    lv_obj_set_size(content, SCREEN_WIDTH - CONTENT_PAD * 2, SCREEN_HEIGHT - navbar_h - CONTENT_PAD * 2);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_OVERFLOW_VISIBLE);  // Clip children that overflow
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(content, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_START);
    lv_obj_set_style_pad_row(content, ITEM_PAD, 0);
    lv_obj_set_style_pad_all(content, 0, 0);  // No internal padding
    
    // === BRIGHTNESS SECTION ===
    create_section_header(content, "Display");
    
    // Brightness row
    lv_obj_t* bright_row = lv_obj_create(content);
    lv_obj_remove_style_all(bright_row);
    lv_obj_set_size(bright_row, LV_PCT(100), SLIDER_ROW_HEIGHT);
    lv_obj_set_style_bg_color(bright_row, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
    lv_obj_set_style_bg_opa(bright_row, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(bright_row, 12, 0);
    lv_obj_set_style_pad_all(bright_row, 16, 0);
    lv_obj_clear_flag(bright_row, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* bright_icon = lv_label_create(bright_row);
    lv_label_set_text(bright_icon, LV_SYMBOL_IMAGE);
    lv_obj_set_style_text_font(bright_icon, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(bright_icon, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_align(bright_icon, LV_ALIGN_TOP_LEFT, 0, 0);
    
    lv_obj_t* bright_name = lv_label_create(bright_row);
    lv_label_set_text(bright_name, "Brightness");
    lv_obj_set_style_text_font(bright_name, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(bright_name, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(bright_name, LV_ALIGN_TOP_LEFT, 36, 2);
    
    g_state.brightness_label = lv_label_create(bright_row);
    lv_obj_set_style_text_font(g_state.brightness_label, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(g_state.brightness_label, lv_color_hex(STYLE_COLOR_ACCENT), 0);
    lv_obj_align(g_state.brightness_label, LV_ALIGN_TOP_RIGHT, 0, 2);
    
    g_state.brightness_slider = lv_slider_create(bright_row);
    lv_obj_set_size(g_state.brightness_slider, lv_pct(100), 6);
    lv_obj_align(g_state.brightness_slider, LV_ALIGN_BOTTOM_MID, 0, -4);
    lv_slider_set_range(g_state.brightness_slider, 10, 100);
    lv_slider_set_value(g_state.brightness_slider, settings_get(SETTING_BRIGHTNESS), LV_ANIM_OFF);
    lv_obj_set_style_bg_color(g_state.brightness_slider, lv_color_hex(0x3A3A3A), LV_PART_MAIN);
    lv_obj_set_style_bg_color(g_state.brightness_slider, lv_color_hex(STYLE_COLOR_PRIMARY), LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(g_state.brightness_slider, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), LV_PART_KNOB);
    lv_obj_set_style_pad_all(g_state.brightness_slider, 6, LV_PART_KNOB);
    lv_obj_add_event_cb(g_state.brightness_slider, on_brightness_change, LV_EVENT_VALUE_CHANGED, nullptr);
    update_brightness_label(settings_get(SETTING_BRIGHTNESS));
    
    // Screen timeout row
    lv_obj_t* timeout_row = lv_obj_create(content);
    lv_obj_remove_style_all(timeout_row);
    lv_obj_set_size(timeout_row, LV_PCT(100), ITEM_HEIGHT);
    lv_obj_set_style_bg_color(timeout_row, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
    lv_obj_set_style_bg_opa(timeout_row, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(timeout_row, 12, 0);
    lv_obj_set_style_pad_hor(timeout_row, 16, 0);
    lv_obj_clear_flag(timeout_row, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* timeout_icon = lv_label_create(timeout_row);
    lv_label_set_text(timeout_icon, LV_SYMBOL_EYE_CLOSE);
    lv_obj_set_style_text_font(timeout_icon, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(timeout_icon, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_align(timeout_icon, LV_ALIGN_LEFT_MID, 0, 0);
    
    lv_obj_t* timeout_name = lv_label_create(timeout_row);
    lv_label_set_text(timeout_name, "Sleep");
    lv_obj_set_style_text_font(timeout_name, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(timeout_name, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(timeout_name, LV_ALIGN_LEFT_MID, 36, 0);
    
    g_state.timeout_btns = lv_buttonmatrix_create(timeout_row);
    lv_buttonmatrix_set_map(g_state.timeout_btns, timeout_map);
    lv_obj_set_size(g_state.timeout_btns, 180, 36);
    lv_obj_align(g_state.timeout_btns, LV_ALIGN_RIGHT_MID, 0, 0);
    style_btnmatrix(g_state.timeout_btns);
    lv_buttonmatrix_set_one_checked(g_state.timeout_btns, true);
    lv_buttonmatrix_set_button_ctrl(g_state.timeout_btns, settings_get(SETTING_SCREEN_TIMEOUT), LV_BUTTONMATRIX_CTRL_CHECKED);
    lv_obj_add_event_cb(g_state.timeout_btns, on_timeout_change, LV_EVENT_VALUE_CHANGED, nullptr);
    
    // === SOUND SECTION ===
    create_section_header(content, "Feedback");
    
    lv_obj_t* sound_row = lv_obj_create(content);
    lv_obj_remove_style_all(sound_row);
    lv_obj_set_size(sound_row, LV_PCT(100), ITEM_HEIGHT);
    lv_obj_set_style_bg_color(sound_row, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
    lv_obj_set_style_bg_opa(sound_row, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(sound_row, 12, 0);
    lv_obj_set_style_pad_hor(sound_row, 16, 0);
    lv_obj_clear_flag(sound_row, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* sound_icon = lv_label_create(sound_row);
    lv_label_set_text(sound_icon, LV_SYMBOL_VOLUME_MAX);
    lv_obj_set_style_text_font(sound_icon, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(sound_icon, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_align(sound_icon, LV_ALIGN_LEFT_MID, 0, 0);
    
    lv_obj_t* sound_name = lv_label_create(sound_row);
    lv_label_set_text(sound_name, "Sound");
    lv_obj_set_style_text_font(sound_name, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(sound_name, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(sound_name, LV_ALIGN_LEFT_MID, 36, 0);
    
    g_state.sound_switch = lv_switch_create(sound_row);
    lv_obj_align(g_state.sound_switch, LV_ALIGN_RIGHT_MID, 0, 0);
    lv_obj_set_size(g_state.sound_switch, 50, 26);
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(0x3A3A3A), LV_PART_MAIN);
    lv_style_selector_t sw_checked = static_cast<lv_style_selector_t>(LV_PART_INDICATOR) | 
                                      static_cast<lv_style_selector_t>(LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(STYLE_COLOR_PRIMARY), sw_checked);
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), LV_PART_KNOB);
    if (settings_get(SETTING_SOUND_ENABLED)) {
        lv_obj_add_state(g_state.sound_switch, LV_STATE_CHECKED);
    }
    lv_obj_add_event_cb(g_state.sound_switch, on_sound_change, LV_EVENT_VALUE_CHANGED, nullptr);
    
    // === UNITS SECTION ===
    create_section_header(content, "Units");
    
    // Helper lambda for unit rows
    auto create_unit_row = [&](const char* icon, const char* name, const char** map, int current, lv_event_cb_t cb) -> lv_obj_t* {
        lv_obj_t* row = lv_obj_create(content);
        lv_obj_remove_style_all(row);
        lv_obj_set_size(row, LV_PCT(100), ITEM_HEIGHT);
        lv_obj_set_style_bg_color(row, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
        lv_obj_set_style_bg_opa(row, LV_OPA_COVER, 0);
        lv_obj_set_style_radius(row, 12, 0);
        lv_obj_set_style_pad_hor(row, 16, 0);
        lv_obj_clear_flag(row, LV_OBJ_FLAG_SCROLLABLE);
        
        lv_obj_t* ic = lv_label_create(row);
        lv_label_set_text(ic, icon);
        lv_obj_set_style_text_font(ic, &lv_font_montserrat_20, 0);
        lv_obj_set_style_text_color(ic, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
        lv_obj_align(ic, LV_ALIGN_LEFT_MID, 0, 0);
        
        lv_obj_t* nm = lv_label_create(row);
        lv_label_set_text(nm, name);
        lv_obj_set_style_text_font(nm, styles_get_font_normal(), 0);
        lv_obj_set_style_text_color(nm, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
        lv_obj_align(nm, LV_ALIGN_LEFT_MID, 36, 0);
        
        lv_obj_t* btnm = lv_buttonmatrix_create(row);
        lv_buttonmatrix_set_map(btnm, map);
        lv_obj_set_size(btnm, 100, 32);
        lv_obj_align(btnm, LV_ALIGN_RIGHT_MID, 0, 0);
        style_btnmatrix(btnm);
        lv_buttonmatrix_set_one_checked(btnm, true);
        lv_buttonmatrix_set_button_ctrl(btnm, current, LV_BUTTONMATRIX_CTRL_CHECKED);
        lv_obj_add_event_cb(btnm, cb, LV_EVENT_VALUE_CHANGED, nullptr);
        
        return btnm;
    };
    
    g_state.depth_btns = create_unit_row(LV_SYMBOL_DOWN, "Depth", depth_map, settings_get(SETTING_UNITS_DEPTH), on_depth_unit_change);
    g_state.temp_btns = create_unit_row(LV_SYMBOL_CHARGE, "Temperature", temp_map, settings_get(SETTING_UNITS_TEMP), on_temp_unit_change);
    g_state.pressure_btns = create_unit_row(LV_SYMBOL_DOWNLOAD, "Pressure", pres_map, settings_get(SETTING_UNITS_PRESSURE), on_pressure_unit_change);
    
    // === RESET BUTTON ===
    lv_obj_t* reset_btn = lv_btn_create(content);
    lv_obj_set_size(reset_btn, LV_PCT(100), 50);
    lv_obj_set_style_bg_color(reset_btn, lv_color_hex(0x3A3A3A), 0);
    lv_obj_set_style_bg_color(reset_btn, lv_color_hex(0x4A4A4A), LV_STATE_PRESSED);
    lv_obj_set_style_radius(reset_btn, 12, 0);
    lv_obj_set_style_margin_top(reset_btn, 16, 0);
    lv_obj_add_event_cb(reset_btn, on_reset_click, LV_EVENT_CLICKED, nullptr);
    
    lv_obj_t* reset_label = lv_label_create(reset_btn);
    lv_label_set_text(reset_label, "Reset to Defaults");
    lv_obj_set_style_text_font(reset_label, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(reset_label, lv_color_hex(STYLE_COLOR_WARNING), 0);
    lv_obj_center(reset_label);
    
    ESP_LOGI(TAG, "Device settings screen created");
    return screen;
}
