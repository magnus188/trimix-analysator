#include "screen_history.h"
#include "ui_common.h"

lv_obj_t *screen_history_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar
    ui_create_topbar(screen, "History");
    
    lv_obj_t *info = lv_label_create(screen);
    lv_label_set_text(info, "View previous gas analyses.\nAnalysis logs and saved configurations.");
    lv_obj_set_style_text_color(info, lv_color_white(), 0);
    lv_obj_set_style_text_align(info, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(info, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    
    return screen;
}
