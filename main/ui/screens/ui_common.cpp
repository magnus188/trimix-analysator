#include "ui_common.h"
#include "screen_manager.h"

// Event handlers for navbar navigation
static void event_go_home(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_HOME);
    }
}

static void event_go_analyze(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_ANALYZE);
    }
}

static void event_go_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_SETTINGS);
    }
}

lv_obj_t *ui_create_navbar(lv_obj_t *parent) {
    lv_obj_t *navbar = lv_obj_create(parent);
    lv_obj_set_size(navbar, LV_PCT(100), 60);
    lv_obj_align(navbar, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_color(navbar, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(navbar, 0, 0);
    lv_obj_set_style_radius(navbar, 0, 0);

    // Home button
    lv_obj_t *btn_home = lv_btn_create(navbar);
    lv_obj_set_size(btn_home, 80, 40);
    lv_obj_align(btn_home, LV_ALIGN_LEFT_MID, 10, 0);
    lv_obj_add_event_cb(btn_home, event_go_home, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *label_home = lv_label_create(btn_home);
    lv_label_set_text(label_home, "Home");
    lv_obj_center(label_home);

    // Analyze button
    lv_obj_t *btn_analyze = lv_btn_create(navbar);
    lv_obj_set_size(btn_analyze, 80, 40);
    lv_obj_align(btn_analyze, LV_ALIGN_CENTER, 0, 0);
    lv_obj_add_event_cb(btn_analyze, event_go_analyze, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *label_analyze = lv_label_create(btn_analyze);
    lv_label_set_text(label_analyze, "Analyze");
    lv_obj_center(label_analyze);

    // Settings button
    lv_obj_t *btn_settings = lv_btn_create(navbar);
    lv_obj_set_size(btn_settings, 80, 40);
    lv_obj_align(btn_settings, LV_ALIGN_RIGHT_MID, -10, 0);
    lv_obj_add_event_cb(btn_settings, event_go_settings, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *label_settings = lv_label_create(btn_settings);
    lv_label_set_text(label_settings, "Settings");
    lv_obj_center(label_settings);

    return navbar;
}
