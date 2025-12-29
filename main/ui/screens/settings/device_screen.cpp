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
constexpr int ITEM_HEIGHT = 64;  // Larger touch targets
constexpr int SLIDER_ROW_HEIGHT = 88;
constexpr int ITEM_PAD = 6;
constexpr int CONTENT_PAD = 16;

// UI state
struct DeviceScreenState {
    lv_obj_t* screen = nullptr;
    lv_obj_t* brightness_btns = nullptr;
    lv_obj_t* timeout_btns = nullptr;
    lv_obj_t* sound_switch = nullptr;
};

DeviceScreenState g_state;

// Forward declarations
void on_brightness_change(lv_event_t* e);
void on_timeout_change(lv_event_t* e);
void on_sound_change(lv_event_t* e);
void on_reset_click(lv_event_t* e);
void back_cb(lv_event_t* e);

// Event handlers
void on_brightness_change(lv_event_t* e) {
    lv_obj_t* btnm = (lv_obj_t*)lv_event_get_target(e);
    uint32_t id = lv_buttonmatrix_get_selected_button(btnm);
    if (id != LV_BUTTONMATRIX_BUTTON_NONE) {
        // 0 = High (100%), 1 = Low (85%)
        int brightness = (id == 0) ? 100 : 95;
        settings_set(SETTING_BRIGHTNESS, brightness);
        backlight_set(brightness);
        ESP_LOGI(TAG, "Brightness: %s (%d%%)", id == 0 ? "Low" : "High", brightness);
    }
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

void on_reset_click(lv_event_t* e) {
    ESP_LOGI(TAG, "Resetting device settings to defaults");
    settings_reset_category(SETTINGS_CAT_DEVICE);
    
    // Update UI - Brightness buttons
    int brightness = settings_get(SETTING_BRIGHTNESS);
    backlight_set(brightness);
    for (uint32_t i = 0; i < 2; i++) {
        lv_buttonmatrix_clear_button_ctrl(g_state.brightness_btns, i, LV_BUTTONMATRIX_CTRL_CHECKED);
    }
    // High=100, Low=85, so if brightness >= 100 select High, else Low
    lv_buttonmatrix_set_button_ctrl(g_state.brightness_btns, brightness >= 100 ? 0 : 1, LV_BUTTONMATRIX_CTRL_CHECKED);
    
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

// Make all buttons in a button matrix checkable
void make_btnmatrix_checkable(lv_obj_t* btnm, uint32_t btn_count) {
    for (uint32_t i = 0; i < btn_count; i++) {
        lv_buttonmatrix_set_button_ctrl(btnm, i, LV_BUTTONMATRIX_CTRL_CHECKABLE);
    }
}

}  // namespace

// Static button maps
static const char* brightness_map[] = {"High", "Low", ""};
static const char* timeout_map[] = {"Never", "1m", "3m", "5m", ""};

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
    
    // Brightness row - using button matrix like other options
    lv_obj_t* bright_row = lv_obj_create(content);
    lv_obj_remove_style_all(bright_row);
    lv_obj_set_size(bright_row, LV_PCT(100), ITEM_HEIGHT);
    lv_obj_set_style_bg_color(bright_row, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
    lv_obj_set_style_bg_opa(bright_row, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(bright_row, 12, 0);
    lv_obj_set_style_pad_hor(bright_row, 16, 0);
    lv_obj_clear_flag(bright_row, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* bright_icon = lv_label_create(bright_row);
    lv_label_set_text(bright_icon, LV_SYMBOL_IMAGE);
    lv_obj_set_style_text_font(bright_icon, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(bright_icon, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_align(bright_icon, LV_ALIGN_LEFT_MID, 0, 0);
    
    lv_obj_t* bright_name = lv_label_create(bright_row);
    lv_label_set_text(bright_name, "Brightness");
    lv_obj_set_style_text_font(bright_name, styles_get_font_normal(), 0);
    lv_obj_set_style_text_color(bright_name, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(bright_name, LV_ALIGN_LEFT_MID, 36, 0);
    
    g_state.brightness_btns = lv_buttonmatrix_create(bright_row);
    lv_buttonmatrix_set_map(g_state.brightness_btns, brightness_map);
    lv_obj_set_size(g_state.brightness_btns, 130, 44);
    lv_obj_align(g_state.brightness_btns, LV_ALIGN_RIGHT_MID, 0, 0);
    style_btnmatrix(g_state.brightness_btns);
    make_btnmatrix_checkable(g_state.brightness_btns, 2);
    lv_buttonmatrix_set_one_checked(g_state.brightness_btns, true);
    // High=100, Low=85, so if brightness >= 100 select High (0), else Low (1)
    int current_brightness = settings_get(SETTING_BRIGHTNESS);
    lv_buttonmatrix_set_button_ctrl(g_state.brightness_btns, current_brightness >= 100 ? 0 : 1, LV_BUTTONMATRIX_CTRL_CHECKED);
    lv_obj_add_event_cb(g_state.brightness_btns, on_brightness_change, LV_EVENT_VALUE_CHANGED, nullptr);
    
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
    lv_obj_set_size(g_state.timeout_btns, 200, 44);  // Larger touch targets
    lv_obj_align(g_state.timeout_btns, LV_ALIGN_RIGHT_MID, 0, 0);
    style_btnmatrix(g_state.timeout_btns);
    make_btnmatrix_checkable(g_state.timeout_btns, 4);  // 4 timeout options
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
    lv_obj_set_size(g_state.sound_switch, 56, 32);  // Larger touch target
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(0x3A3A3A), LV_PART_MAIN);
    lv_style_selector_t sw_checked = static_cast<lv_style_selector_t>(LV_PART_INDICATOR) | 
                                      static_cast<lv_style_selector_t>(LV_STATE_CHECKED);
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(STYLE_COLOR_PRIMARY), sw_checked);
    lv_obj_set_style_bg_color(g_state.sound_switch, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), LV_PART_KNOB);
    if (settings_get(SETTING_SOUND_ENABLED)) {
        lv_obj_add_state(g_state.sound_switch, LV_STATE_CHECKED);
    }
    lv_obj_add_event_cb(g_state.sound_switch, on_sound_change, LV_EVENT_VALUE_CHANGED, nullptr);
    
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
