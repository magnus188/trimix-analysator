#include "screen_calibrate_o2.h"
#include "screen_manager.h"
#include "ui_common.h"

static void event_back_to_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_SETTINGS);
    }
}

static void event_do_o2_calibration(lv_event_t *e) {
    if (lv_event_get_code(e) != LV_EVENT_CLICKED) return;
    
    if (sensor_calibrate_oxygen_air() == ESP_OK) {
        lv_obj_t *msg = lv_label_create(lv_scr_act());
        lv_label_set_text(msg, "Calibration Complete!");
        lv_obj_set_style_text_color(msg, UI_COLOR_SECONDARY, 0);
        lv_obj_align(msg, LV_ALIGN_CENTER, 0, 120);
    }
}

lv_obj_t *screen_calibrate_o2_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "O2 Calibration");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    lv_obj_t *instructions = lv_label_create(screen);
    lv_label_set_text(instructions, "1. Ensure sensor is exposed to normal air\n2. Wait for readings to stabilize\n3. Press 'Calibrate' to set 20.9% O2");
    lv_obj_set_style_text_color(instructions, lv_color_white(), 0);
    lv_obj_set_style_text_align(instructions, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(instructions, LV_ALIGN_CENTER, 0, -60);
    
    lv_obj_t *current_reading = lv_label_create(screen);
    lv_label_set_text(current_reading, "Current: 20.9% O2");
    lv_obj_set_style_text_font(current_reading, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(current_reading, UI_COLOR_SECONDARY, 0);
    lv_obj_align(current_reading, LV_ALIGN_CENTER, 0, 0);
    
    lv_obj_t *btn_calibrate = lv_btn_create(screen);
    lv_obj_set_size(btn_calibrate, 200, 60);
    lv_obj_align(btn_calibrate, LV_ALIGN_CENTER, 0, 60);
    lv_obj_set_style_bg_color(btn_calibrate, UI_COLOR_SECONDARY, 0);
    lv_obj_add_event_cb(btn_calibrate, event_do_o2_calibration, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *calibrate_label = lv_label_create(btn_calibrate);
    lv_label_set_text(calibrate_label, "Calibrate Now");
    lv_obj_set_style_text_font(calibrate_label, &lv_font_montserrat_14, 0);
    lv_obj_center(calibrate_label);
    
    lv_obj_t *btn_back = lv_btn_create(screen);
    lv_obj_set_size(btn_back, 100, 40);
    lv_obj_align(btn_back, LV_ALIGN_BOTTOM_LEFT, 10, -10);
    lv_obj_set_style_bg_color(btn_back, UI_COLOR_PRIMARY, 0);
    lv_obj_add_event_cb(btn_back, event_back_to_settings, LV_EVENT_CLICKED, nullptr);
    lv_obj_t *back_label = lv_label_create(btn_back);
    lv_label_set_text(back_label, "Back");
    lv_obj_center(back_label);
    
    return screen;
}
