#ifndef LV_CONF_H
#define LV_CONF_H

#define LV_USE_ASSERT_NULL          1
#define LV_USE_ASSERT_MALLOC        1
#define LV_USE_ASSERT_STYLE         0
#define LV_USE_ASSERT_MEM_INTEGRITY 0
#define LV_USE_ASSERT_OBJ           0

#define LV_USE_LOG      1
#define LV_LOG_LEVEL    LV_LOG_LEVEL_INFO
#define LV_LOG_PRINTF   1

// Memory settings - Optimized for ESP32
#define LV_MEM_CUSTOM 0
#define LV_MEM_SIZE (64U * 1024U)  // Increased for better performance
#define LV_MEM_ADR 0
#define LV_MEM_BUF_MAX_NUM 32      // More buffers for smoother rendering

// Performance optimizations
#define LV_DISP_DEF_REFR_PERIOD 16  // ~60 FPS refresh rate
#define LV_INDEV_DEF_READ_PERIOD 16  // Fast touch response

// HAL settings
#define LV_TICK_CUSTOM 0
#define LV_DPI_DEF 130

// Feature usage - Optimized for embedded
#define LV_USE_PERF_MONITOR 1        // Enable performance monitoring
#define LV_USE_MEM_MONITOR 1         // Enable memory monitoring
#define LV_USE_REFR_DEBUG 0          // Disable debug for production

// Animation settings for smooth UX
#define LV_USE_ANIMATION 1
#define LV_ANIM_DEF_TIME 200         // Fast animations
#define LV_USE_SNAPSHOT 1            // Enable smooth transitions

// Drawing
#define LV_USE_GPU_STM32_DMA2D 0
#define LV_USE_GPU_ARM2D 0
#define LV_USE_GPU_NXP_PXP 0
#define LV_USE_GPU_NXP_VG_LITE 0
#define LV_USE_GPU_SDL 0

// Color settings
#define LV_COLOR_DEPTH 16
#define LV_COLOR_16_SWAP 0
#define LV_COLOR_SCREEN_TRANSP 0
#define LV_COLOR_MIX_ROUND_OFS (LV_COLOR_DEPTH == 32 ? 0: 128)
#define LV_COLOR_CHROMA_KEY lv_color_hex(0x00ff00)

// Text settings
#define LV_USE_FONT_COMPRESSED 1
#define LV_USE_FONT_SUBPX 0
#define LV_FONT_MONTSERRAT_8  0
#define LV_FONT_MONTSERRAT_10 0
#define LV_FONT_MONTSERRAT_12 1
#define LV_FONT_MONTSERRAT_14 1
#define LV_FONT_MONTSERRAT_16 1
#define LV_FONT_MONTSERRAT_18 0
#define LV_FONT_MONTSERRAT_20 0
#define LV_FONT_MONTSERRAT_22 0
#define LV_FONT_MONTSERRAT_24 0
#define LV_FONT_MONTSERRAT_26 0
#define LV_FONT_MONTSERRAT_28 0
#define LV_FONT_MONTSERRAT_30 0
#define LV_FONT_MONTSERRAT_32 0
#define LV_FONT_MONTSERRAT_34 0
#define LV_FONT_MONTSERRAT_36 0
#define LV_FONT_MONTSERRAT_38 0
#define LV_FONT_MONTSERRAT_40 0
#define LV_FONT_MONTSERRAT_42 0
#define LV_FONT_MONTSERRAT_44 0
#define LV_FONT_MONTSERRAT_46 0
#define LV_FONT_MONTSERRAT_48 0

#define LV_FONT_DEFAULT &lv_font_montserrat_14

// Widget usage
#define LV_USE_ANIMIMG 1
#define LV_USE_ARC 1
#define LV_USE_BAR 1
#define LV_USE_BTN 1
#define LV_USE_BTNMATRIX 1
#define LV_USE_CANVAS 1
#define LV_USE_CHECKBOX 1
#define LV_USE_DROPDOWN 1
#define LV_USE_IMG 1
#define LV_USE_LABEL 1
#define LV_USE_LINE 1
#define LV_USE_LIST 1
#define LV_USE_METER 1
#define LV_USE_MSGBOX 1
#define LV_USE_ROLLER 1
#define LV_USE_SLIDER 1
#define LV_USE_SPAN 1
#define LV_USE_SPINNER 1
#define LV_USE_SWITCH 1
#define LV_USE_TEXTAREA 1
#define LV_USE_TABLE 1
#define LV_USE_TABVIEW 1
#define LV_USE_TILEVIEW 1
#define LV_USE_WIN 1

// Themes
#define LV_USE_THEME_DEFAULT 1
#define LV_USE_THEME_BASIC 1
#define LV_USE_THEME_MONO 1

// Layouts
#define LV_USE_LAYOUT_FLEX 1
#define LV_USE_LAYOUT_GRID 1

// Other settings
#define LV_USE_FILESYSTEM 0
#define LV_USE_PNG 0
#define LV_USE_BMP 0
#define LV_USE_SJPG 0
#define LV_USE_GIF 0
#define LV_USE_QRCODE 0
#define LV_USE_FREETYPE 0
#define LV_USE_RLOTTIE 0
#define LV_USE_FFMPEG 0

// Animation
#define LV_USE_SNAPSHOT 1

// Others
#define LV_USE_MONKEY 0
#define LV_USE_GRIDNAV 0
#define LV_USE_FRAGMENT 0
#define LV_USE_IMGFONT 0
#define LV_USE_MSG 0
#define LV_USE_IME_PINYIN 0

#endif /*LV_CONF_H*/
