#include "calibrate_o2.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"

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
    
    // Add top navigation bar using component
    ui_create_topbar(screen, "O2 Calibration");
    
    // Instructions
    lv_obj_t *instructions = lv_label_create(screen);
    lv_label_set_text(instructions, "1. Ensure sensor is exposed to normal air\n2. Wait for readings to stabilize\n3. Press 'Calibrate' to set 20.9% O2");
    lv_obj_set_style_text_color(instructions, lv_color_white(), 0);
    lv_obj_set_style_text_align(instructions, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(instructions, LV_ALIGN_CENTER, 0, -60 + UI_TOPBAR_HEIGHT / 2);
    
    // Current reading
    lv_obj_t *current_reading = lv_label_create(screen);
    lv_label_set_text(current_reading, "Current: 20.9% O2");
    lv_obj_set_style_text_font(current_reading, FONT_MEDIUM, 0);
    lv_obj_set_style_text_color(current_reading, UI_COLOR_SECONDARY, 0);
    lv_obj_align(current_reading, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    
    // Calibrate button using component
    ui_button_config_t btn_config = {"Calibrate Now", UI_COLOR_SECONDARY, event_do_o2_calibration, NULL};
    lv_obj_t *btn_calibrate = ui_create_button(screen, &btn_config);
    lv_obj_set_size(btn_calibrate, 200, 60);
    lv_obj_align(btn_calibrate, LV_ALIGN_CENTER, 0, 60 + UI_TOPBAR_HEIGHT / 2);
    
    return screen;
}
