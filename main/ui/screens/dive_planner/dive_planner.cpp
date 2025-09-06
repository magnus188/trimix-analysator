#include "dive_planner.h"
#include "../../components/ui_components.h"

lv_obj_t *screen_dive_planner_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar using component
    ui_create_topbar(screen, "Dive Planner");
    
    // Create info text
    lv_obj_t *info = lv_label_create(screen);
    lv_label_set_text(info, "Plan your dive profiles here.\nDecompression calculations and gas planning.");
    lv_obj_set_style_text_color(info, lv_color_white(), 0);
    lv_obj_set_style_text_align(info, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(info, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    
    return screen;
}
