#pragma once
#include <lvgl.h>

// Forward declarations for custom fonts
#ifndef FONT_HEADER
#define FONT_HEADER &lv_font_montserrat_14
#endif
#ifndef FONT_BUTTON
#define FONT_BUTTON &lv_font_montserrat_14
#endif
#ifndef FONT_NORMAL
#define FONT_NORMAL &lv_font_montserrat_14
#endif
#ifndef FONT_LARGE
#define FONT_LARGE &lv_font_montserrat_14
#endif
#ifndef FONT_MEDIUM
#define FONT_MEDIUM &lv_font_montserrat_14
#endif

// UI Theme Colors
#define UI_COLOR_PRIMARY lv_color_hex(0x2196F3)
#define UI_COLOR_SECONDARY lv_color_hex(0x4CAF50)
#define UI_COLOR_DANGER lv_color_hex(0xF44336)
#define UI_COLOR_WARNING lv_color_hex(0xFF9800)
#define UI_COLOR_BACKGROUND lv_color_hex(0x121212)

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
