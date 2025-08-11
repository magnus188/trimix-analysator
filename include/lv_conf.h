/*
 * LVGL Configuration for ESP32-S3 Trimix Analyzer
 * Target: ESP32-8048S043 (4.3" 800x480 IPS Touch Display)
 * LVGL Version: 8.x
 */

#ifndef LV_CONF_H
#define LV_CONF_H

#include <stdint.h>

/*====================
   COLOR SETTINGS
 *====================*/

/* Color depth: 16 (RGB565) for better performance on ESP32-S3 */
#define LV_COLOR_DEPTH 16

/* Memory and performance settings */
#define LV_USE_PERF_MONITOR 1
#define LV_USE_MEM_MONITOR 1

/*====================
   MEMORY SETTINGS
 *====================*/

/* Graphic buffer size. Used by draw engine for partial redraw */
#define LV_DISP_DEF_REFR_PERIOD 16    /* [ms] refresh period */

/*====================
   FEATURE CONFIGURATION
 *====================*/

/* Enable animations */
#define LV_USE_ANIMATION 1

/* Enable image support */
#define LV_USE_IMG 1

/* Enable label support */
#define LV_USE_LABEL 1

/* Enable button support */
#define LV_USE_BTN 1

/* Enable image button support */
#define LV_USE_IMGBTN 1

/* Enable arc (gauge) support */
#define LV_USE_ARC 1

/* Enable chart support for sensor graphs */
#define LV_USE_CHART 1

/* Enable tabview for settings screens */
#define LV_USE_TABVIEW 1

/* Enable keyboard for WiFi input */
#define LV_USE_KEYBOARD 1

/* Enable dropdown for settings */
#define LV_USE_DROPDOWN 1

/* Enable slider for calibration */
#define LV_USE_SLIDER 1

/* Enable switch for boolean settings */
#define LV_USE_SWITCH 1

/* Enable textarea for text input */
#define LV_USE_TEXTAREA 1

/* Enable list for menu items */
#define LV_USE_LIST 1

/* Enable message box for alerts */
#define LV_USE_MSGBOX 1

/*====================
   THEME USAGE
 *====================*/

/* Use default theme */
#define LV_USE_THEME_DEFAULT 1
#define LV_THEME_DEFAULT_DARK 0

/*====================
   FONT USAGE
 *====================*/

/* Enable built-in fonts */
#define LV_FONT_MONTSERRAT_14 1
#define LV_FONT_MONTSERRAT_16 1
#define LV_FONT_MONTSERRAT_18 1
#define LV_FONT_MONTSERRAT_20 1
#define LV_FONT_MONTSERRAT_22 1
#define LV_FONT_MONTSERRAT_24 1
#define LV_FONT_MONTSERRAT_28 1

/* Font for large sensor values */
#define LV_FONT_MONTSERRAT_32 1
#define LV_FONT_MONTSERRAT_36 1
#define LV_FONT_MONTSERRAT_48 1

/*====================
   LOGGING
 *====================*/

#define LV_USE_LOG 1
#define LV_LOG_LEVEL LV_LOG_LEVEL_INFO

/*====================
   DISPLAY CONFIGURATION
 *====================*/

/* Horizontal and vertical resolution of the display */
#define LV_HOR_RES_MAX 800
#define LV_VER_RES_MAX 480

/* DPI for scaling */
#define LV_DPI_DEF 120

/* Display buffer size */
/* Use default draw buffer size; we'll set it from code */

/*====================
   HAL SETTINGS
 *====================*/

/* Default display buffer size */
#define LV_DISP_DEF_REFR_PERIOD 16  /* [ms] */

/* Input device read period in milliseconds */
#define LV_INDEV_DEF_READ_PERIOD 16  /* [ms] */

/* Use a custom tick source */
/* Provide custom tick from Arduino millis() */
/* Use default tick; we'll call lv_tick_inc() from code */
#define LV_TICK_CUSTOM 0

/*====================
   COMPILER SETTINGS
 *====================*/

/* For ESP32-S3 with GCC */
#define LV_ATTRIBUTE_TICK_INC

/* Memory alignment for performance */
#define LV_ATTRIBUTE_MEM_ALIGN __attribute__((aligned(4)))

/*====================
   GPU CONFIGURATION
 *====================*/

/* Use ESP32-S3 specific optimizations */
#define LV_USE_GPU_STM32_DMA2D 0

#endif /*LV_CONF_H*/