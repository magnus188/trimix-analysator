#pragma once
#include <lvgl.h>
#include "../fonts/custom_fonts.h"

// Forward declarations for custom fonts - using larger existing custom font defaults
#ifndef FONT_HEADER
#define FONT_HEADER &custom_font_bold_24
#endif
#ifndef FONT_BUTTON
#define FONT_BUTTON &custom_font_normal_20
#endif
#ifndef FONT_NORMAL
#define FONT_NORMAL &custom_font_normal_20
#endif
#ifndef FONT_LARGE
#define FONT_LARGE &custom_font_normal_24
#endif
#ifndef FONT_MEDIUM
#define FONT_MEDIUM &custom_font_normal_24
#endif

// UI Theme Colors
#define UI_COLOR_PRIMARY lv_color_hex(0x2196F3)
#define UI_COLOR_SECONDARY lv_color_hex(0x4CAF50)
#define UI_COLOR_DANGER lv_color_hex(0xF44336)
#define UI_COLOR_WARNING lv_color_hex(0xFF9800)
#define UI_COLOR_BACKGROUND lv_color_hex(0x121212)

// Additional UI colors for enhanced styling
#define UI_COLOR_CARD_BG lv_color_hex(0x1E1E1E)
#define UI_COLOR_SEPARATOR lv_color_hex(0x333333)
#define UI_COLOR_TEXT_PRIMARY lv_color_hex(0xFFFFFF)
#define UI_COLOR_TEXT_SECONDARY lv_color_hex(0xCCCCCC)

// Navigation bar height
#define UI_TOPBAR_HEIGHT 50

#ifdef __cplusplus
extern "C" {
#endif

// Button component
typedef struct {
    const char* text;
    lv_color_t bg_color;
    lv_event_cb_t event_cb;
    void* user_data;
} ui_button_config_t;

lv_obj_t* ui_create_button(lv_obj_t* parent, const ui_button_config_t* config);

// Card component for displaying sensor data
typedef struct {
    const char* title;
    const char* value;
    const char* unit;
    lv_color_t bg_color;
} ui_card_config_t;

lv_obj_t* ui_create_sensor_card(lv_obj_t* parent, const ui_card_config_t* config);

// Navigation components
lv_obj_t* ui_create_navbar(lv_obj_t* parent);
lv_obj_t* ui_create_topbar(lv_obj_t* parent, const char* title);

// Grid container for layout
lv_obj_t* ui_create_grid_container(lv_obj_t* parent, int cols, int rows, int width_pct, int height);

// Title label
lv_obj_t* ui_create_title(lv_obj_t* parent, const char* text);

// Large settings button for finger-friendly touch interface
lv_obj_t* ui_create_large_button(lv_obj_t* parent, const char* text, lv_color_t color, lv_event_cb_t event_cb);

// Event handlers for navigation
void event_go_home(lv_event_t *e);
void event_go_analyze(lv_event_t *e);
void event_go_settings(lv_event_t *e);
void event_go_dive_planner(lv_event_t *e);
void event_go_history(lv_event_t *e);
void event_go_back(lv_event_t *e);

#ifdef __cplusplus
}
#endif
