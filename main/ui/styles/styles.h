#pragma once
#include <lvgl.h>

#ifdef __cplusplus
extern "C" {
#endif

// Color palette
#define STYLE_COLOR_PRIMARY     0x1565C0  // Deep blue
#define STYLE_COLOR_PRIMARY_DARK 0x0D47A1 // Darker blue for pressed
#define STYLE_COLOR_ACCENT      0x00BFA5  // Teal accent
#define STYLE_COLOR_BACKGROUND  0x121212  // Main background
#define STYLE_COLOR_BG_DARK     0x121212  // Dark background (alias)
#define STYLE_COLOR_BG_CARD     0x1E1E1E  // Card background
#define STYLE_COLOR_SURFACE     0x1E1E1E  // Surface/card (alias)
#define STYLE_COLOR_TEXT_LIGHT  0xFFFFFF  // White text
#define STYLE_COLOR_TEXT_DIM    0xB0B0B0  // Dimmed text
#define STYLE_COLOR_SUCCESS     0x4CAF50  // Green
#define STYLE_COLOR_WARNING     0xFF9800  // Orange
#define STYLE_COLOR_ERROR       0xF44336  // Red

// Button colors for each menu item (gradient pairs: main + accent)
#define STYLE_COLOR_ANALYSE         0x667EEA  // Vibrant blue-purple
#define STYLE_COLOR_ANALYSE_ACCENT  0x764BA2  // Purple accent
#define STYLE_COLOR_DIVE_PLAN       0x11998E  // Teal green
#define STYLE_COLOR_DIVE_PLAN_ACCENT 0x38EF7D // Bright green accent
#define STYLE_COLOR_HISTORY         0xFC466B  // Coral pink
#define STYLE_COLOR_HISTORY_ACCENT  0x3F5EFB  // Blue accent
#define STYLE_COLOR_SETTINGS        0x485563  // Slate
#define STYLE_COLOR_SETTINGS_ACCENT 0x29323C  // Dark slate accent

/**
 * Initialize global styles and load fonts
 * Must be called after lv_init()
 */
void styles_init(void);

/**
 * Get loaded fonts
 */
const lv_font_t* styles_get_font_normal(void);
const lv_font_t* styles_get_font_bold(void);
const lv_font_t* styles_get_font_light(void);

/**
 * Get large font for buttons
 */
const lv_font_t* styles_get_font_button(void);

#ifdef __cplusplus
}
#endif
