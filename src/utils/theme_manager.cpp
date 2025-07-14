#include "theme_manager.h"
#include <Arduino.h>

// Initialize static members
lv_theme_t* ThemeManager::currentTheme = nullptr;
lv_style_t ThemeManager::cardStyle;
lv_style_t ThemeManager::buttonStyle;
lv_style_t ThemeManager::labelStyle;
lv_style_t ThemeManager::navBarStyle;
lv_style_t ThemeManager::sensorCardStyle;
lv_style_t ThemeManager::warningStyle;
lv_style_t ThemeManager::dangerStyle;
lv_style_t ThemeManager::successStyle;

// Premium color palette
const lv_color_t ThemeManager::PRIMARY_COLOR = lv_color_hex(0x1E88E5);    // Professional blue
const lv_color_t ThemeManager::SECONDARY_COLOR = lv_color_hex(0x1565C0);  // Darker blue
const lv_color_t ThemeManager::BACKGROUND_COLOR = lv_color_hex(0x000000); // True black
const lv_color_t ThemeManager::CARD_COLOR = lv_color_hex(0x1E1E1E);       // Dark gray
const lv_color_t ThemeManager::TEXT_COLOR = lv_color_hex(0xFFFFFF);       // Pure white
const lv_color_t ThemeManager::SUCCESS_COLOR = lv_color_hex(0x4CAF50);    // Green
const lv_color_t ThemeManager::WARNING_COLOR = lv_color_hex(0xFF9800);    // Orange
const lv_color_t ThemeManager::DANGER_COLOR = lv_color_hex(0xF44336);     // Red
const lv_color_t ThemeManager::ACCENT_COLOR = lv_color_hex(0x00BCD4);     // Cyan

void ThemeManager::init() {
    // Initialize card style - Premium look
    lv_style_init(&cardStyle);
    lv_style_set_radius(&cardStyle, 12);
    lv_style_set_bg_color(&cardStyle, CARD_COLOR);
    lv_style_set_bg_opa(&cardStyle, LV_OPA_COVER);
    lv_style_set_border_width(&cardStyle, 1);
    lv_style_set_border_color(&cardStyle, lv_color_hex(0x333333));
    lv_style_set_border_opa(&cardStyle, LV_OPA_50);
    lv_style_set_shadow_width(&cardStyle, 8);
    lv_style_set_shadow_color(&cardStyle, lv_color_hex(0x000000));
    lv_style_set_shadow_opa(&cardStyle, LV_OPA_30);
    lv_style_set_shadow_spread(&cardStyle, 2);
    lv_style_set_pad_all(&cardStyle, 12);
    
    // Initialize button style - Interactive and modern
    lv_style_init(&buttonStyle);
    lv_style_set_radius(&buttonStyle, 8);
    lv_style_set_bg_color(&buttonStyle, PRIMARY_COLOR);
    lv_style_set_bg_opa(&buttonStyle, LV_OPA_COVER);
    lv_style_set_border_width(&buttonStyle, 0);
    lv_style_set_shadow_width(&buttonStyle, 4);
    lv_style_set_shadow_color(&buttonStyle, PRIMARY_COLOR);
    lv_style_set_shadow_opa(&buttonStyle, LV_OPA_30);
    lv_style_set_text_color(&buttonStyle, TEXT_COLOR);
    lv_style_set_text_font(&buttonStyle, &lv_font_montserrat_14);
    lv_style_set_transition(&buttonStyle, &(lv_style_transition_dsc_t){
        .props = (lv_style_prop_t[]){LV_STYLE_BG_COLOR, LV_STYLE_SHADOW_WIDTH, 0},
        .time = 150,
        .delay = 0,
        .path_xcb = lv_anim_path_ease_in_out,
        .user_data = NULL
    });
    
    // Pressed state for buttons
    lv_style_set_bg_color(&buttonStyle, SECONDARY_COLOR);
    lv_style_set_shadow_width(&buttonStyle, 2);
    
    // Initialize label style - Clean typography
    lv_style_init(&labelStyle);
    lv_style_set_text_color(&labelStyle, TEXT_COLOR);
    lv_style_set_text_font(&labelStyle, &lv_font_montserrat_14);
    lv_style_set_text_letter_space(&labelStyle, 0);
    lv_style_set_text_line_space(&labelStyle, 4);
    
    // Initialize navbar style - Professional header
    lv_style_init(&navBarStyle);
    lv_style_set_radius(&navBarStyle, 0);
    lv_style_set_bg_color(&navBarStyle, PRIMARY_COLOR);
    lv_style_set_bg_opa(&navBarStyle, LV_OPA_COVER);
    lv_style_set_border_width(&navBarStyle, 0);
    lv_style_set_shadow_width(&navBarStyle, 4);
    lv_style_set_shadow_color(&navBarStyle, lv_color_hex(0x000000));
    lv_style_set_shadow_opa(&navBarStyle, LV_OPA_40);
    lv_style_set_pad_all(&navBarStyle, 8);
    
    // Initialize sensor card style - Data visualization
    lv_style_init(&sensorCardStyle);
    lv_style_set_radius(&sensorCardStyle, 10);
    lv_style_set_bg_color(&sensorCardStyle, CARD_COLOR);
    lv_style_set_bg_opa(&sensorCardStyle, LV_OPA_COVER);
    lv_style_set_border_width(&sensorCardStyle, 2);
    lv_style_set_border_color(&sensorCardStyle, lv_color_hex(0x333333));
    lv_style_set_border_opa(&sensorCardStyle, LV_OPA_60);
    lv_style_set_shadow_width(&sensorCardStyle, 6);
    lv_style_set_shadow_color(&sensorCardStyle, lv_color_hex(0x000000));
    lv_style_set_shadow_opa(&sensorCardStyle, LV_OPA_25);
    lv_style_set_pad_all(&sensorCardStyle, 10);
    
    // Initialize status styles
    lv_style_init(&successStyle);
    lv_style_set_text_color(&successStyle, SUCCESS_COLOR);
    lv_style_set_bg_color(&successStyle, lv_color_hex(0x1B5E20));
    lv_style_set_bg_opa(&successStyle, LV_OPA_20);
    lv_style_set_border_color(&successStyle, SUCCESS_COLOR);
    lv_style_set_border_width(&successStyle, 1);
    lv_style_set_border_opa(&successStyle, LV_OPA_50);
    
    lv_style_init(&warningStyle);
    lv_style_set_text_color(&warningStyle, WARNING_COLOR);
    lv_style_set_bg_color(&warningStyle, lv_color_hex(0xE65100));
    lv_style_set_bg_opa(&warningStyle, LV_OPA_20);
    lv_style_set_border_color(&warningStyle, WARNING_COLOR);
    lv_style_set_border_width(&warningStyle, 1);
    lv_style_set_border_opa(&warningStyle, LV_OPA_50);
    
    lv_style_init(&dangerStyle);
    lv_style_set_text_color(&dangerStyle, DANGER_COLOR);
    lv_style_set_bg_color(&dangerStyle, lv_color_hex(0xB71C1C));
    lv_style_set_bg_opa(&dangerStyle, LV_OPA_20);
    lv_style_set_border_color(&dangerStyle, DANGER_COLOR);
    lv_style_set_border_width(&dangerStyle, 1);
    lv_style_set_border_opa(&dangerStyle, LV_OPA_50);
    
    Serial.println("Premium theme initialized");
}

void ThemeManager::applyCardStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &cardStyle, LV_PART_MAIN);
    addHoverEffect(obj);
}

void ThemeManager::applyButtonStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &buttonStyle, LV_PART_MAIN);
    addPressEffect(obj);
}

void ThemeManager::applyLabelStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &labelStyle, LV_PART_MAIN);
}

void ThemeManager::applyNavBarStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &navBarStyle, LV_PART_MAIN);
}

void ThemeManager::applySensorCardStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &sensorCardStyle, LV_PART_MAIN);
    addHoverEffect(obj);
}

void ThemeManager::applyWarningStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &warningStyle, LV_PART_MAIN);
}

void ThemeManager::applyDangerStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &dangerStyle, LV_PART_MAIN);
}

void ThemeManager::applySuccessStyle(lv_obj_t* obj) {
    lv_obj_add_style(obj, &successStyle, LV_PART_MAIN);
}

void ThemeManager::animateColorChange(lv_obj_t* obj, lv_color_t newColor) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, 300);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_bg_color((lv_obj_t*)var, lv_color_hex(val), LV_PART_MAIN);
    });
    lv_anim_set_values(&a, lv_color_to_u32(lv_obj_get_style_bg_color(obj, LV_PART_MAIN)), 
                          lv_color_to_u32(newColor));
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in_out);
    lv_anim_start(&a);
}

void ThemeManager::addHoverEffect(lv_obj_t* obj) {
    lv_obj_add_event_cb(obj, [](lv_event_t* e) {
        lv_obj_t* obj = lv_event_get_target(e);
        if (lv_event_get_code(e) == LV_EVENT_PRESSED) {
            lv_obj_set_style_transform_zoom(obj, 95, LV_PART_MAIN);
        } else if (lv_event_get_code(e) == LV_EVENT_RELEASED) {
            lv_obj_set_style_transform_zoom(obj, 100, LV_PART_MAIN);
        }
    }, LV_EVENT_PRESSED | LV_EVENT_RELEASED, NULL);
}

void ThemeManager::addPressEffect(lv_obj_t* obj) {
    lv_obj_add_event_cb(obj, [](lv_event_t* e) {
        lv_obj_t* obj = lv_event_get_target(e);
        if (lv_event_get_code(e) == LV_EVENT_PRESSED) {
            lv_obj_set_style_shadow_width(obj, 2, LV_PART_MAIN);
            lv_obj_set_style_bg_color(obj, ThemeManager::SECONDARY_COLOR, LV_PART_MAIN);
        } else if (lv_event_get_code(e) == LV_EVENT_RELEASED) {
            lv_obj_set_style_shadow_width(obj, 4, LV_PART_MAIN);
            lv_obj_set_style_bg_color(obj, ThemeManager::PRIMARY_COLOR, LV_PART_MAIN);
        }
    }, LV_EVENT_PRESSED | LV_EVENT_RELEASED, NULL);
}
