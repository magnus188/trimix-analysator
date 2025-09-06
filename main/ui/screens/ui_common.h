#pragma once
#include <lvgl.h>
#include "custom_fonts.h"

#ifdef __cplusplus
extern "C" {
#endif

// UI Theme Colors
#define UI_COLOR_PRIMARY lv_color_hex(0x2196F3)
#define UI_COLOR_SECONDARY lv_color_hex(0x4CAF50)
#define UI_COLOR_DANGER lv_color_hex(0xF44336)
#define UI_COLOR_WARNING lv_color_hex(0xFF9800)
#define UI_COLOR_BACKGROUND lv_color_hex(0x121212)

// Navigation bar height
#define UI_TOPBAR_HEIGHT 50

// Common UI components
lv_obj_t *ui_create_navbar(lv_obj_t *parent);
lv_obj_t *ui_create_topbar(lv_obj_t *parent, const char *title);

#ifdef __cplusplus
}
#endif
