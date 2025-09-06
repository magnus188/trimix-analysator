#pragma once

#include "lvgl.h"

#ifdef __cplusplus
extern "C" {
#endif

// Custom font declarations
// These fonts will be generated from TTF files using LVGL font converter
LV_FONT_DECLARE(custom_font_normal_16);
LV_FONT_DECLARE(custom_font_normal_20);
LV_FONT_DECLARE(custom_font_normal_24);
LV_FONT_DECLARE(custom_font_bold_16);
LV_FONT_DECLARE(custom_font_bold_20);
LV_FONT_DECLARE(custom_font_bold_24);
LV_FONT_DECLARE(custom_font_light_14);
LV_FONT_DECLARE(custom_font_light_16);

// Font aliases for easier use - using larger existing custom fonts for better visibility
#define FONT_SMALL &custom_font_light_16      // Was light_14, now 16px
#define FONT_NORMAL &custom_font_normal_20    // Was normal_16, now 20px  
#define FONT_MEDIUM &custom_font_normal_24    // Was normal_20, now 24px
#define FONT_LARGE &custom_font_normal_24     // Was normal_24, keep 24px
#define FONT_TITLE &custom_font_bold_24       // Was bold_20, now 24px
#define FONT_HEADER &custom_font_bold_24      // Was bold_24, keep 24px
#define FONT_BUTTON &custom_font_normal_20    // Was normal_16, now 20px

#ifdef __cplusplus
}
#endif
