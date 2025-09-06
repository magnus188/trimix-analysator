#include "screen_settings.h"
#include "screen_manager.h"
#include "ui_common.h"

static void event_go_calibrate_o2(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_CALIBRATE_O2);
    }
}

lv_obj_t *screen_settings_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar
    ui_create_topbar(screen, "Settings");
    
    lv_obj_t *menu_container = lv_obj_create(screen);
    lv_obj_set_size(menu_container, LV_PCT(85), 450);
    lv_obj_align(menu_container, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    lv_obj_set_style_bg_opa(menu_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(menu_container, 0, 0);
    lv_obj_set_flex_flow(menu_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(menu_container, 20, 0);
    
    // Calibration button
    lv_obj_t *btn_calibrate = lv_btn_create(menu_container);
    lv_obj_set_size(btn_calibrate, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_calibrate, UI_COLOR_SECONDARY, 0);
    lv_obj_add_event_cb(btn_calibrate, event_go_calibrate_o2, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *calibrate_label = lv_label_create(btn_calibrate);
    lv_label_set_text(calibrate_label, "O2 Sensor Calibration");
    lv_obj_set_style_text_font(calibrate_label, FONT_BUTTON, 0);
    lv_obj_center(calibrate_label);
    
    // System info button
    lv_obj_t *btn_sysinfo = lv_btn_create(menu_container);
    lv_obj_set_size(btn_sysinfo, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_sysinfo, UI_COLOR_PRIMARY, 0);
    lv_obj_t *sysinfo_label = lv_label_create(btn_sysinfo);
    lv_label_set_text(sysinfo_label, "System Information");
    lv_obj_set_style_text_font(sysinfo_label, FONT_BUTTON, 0);
    lv_obj_center(sysinfo_label);
    
    // About button
    lv_obj_t *btn_about = lv_btn_create(menu_container);
    lv_obj_set_size(btn_about, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_about, UI_COLOR_PRIMARY, 0);
    lv_obj_t *about_label = lv_label_create(btn_about);
    lv_label_set_text(about_label, "About");
    lv_obj_set_style_text_font(about_label, FONT_BUTTON, 0);
    lv_obj_center(about_label);
    
    return screen;
}
