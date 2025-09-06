#include "screen_dive_planner.h"
#include "ui_common.h"

lv_obj_t *screen_dive_planner_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Dive Planner");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    lv_obj_t *info = lv_label_create(screen);
    lv_label_set_text(info, "Plan your dive profiles here.\nDecompression calculations and gas planning.");
    lv_obj_set_style_text_color(info, lv_color_white(), 0);
    lv_obj_set_style_text_align(info, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(info, LV_ALIGN_CENTER, 0, 0);
    
    ui_create_navbar(screen);
    return screen;
}
