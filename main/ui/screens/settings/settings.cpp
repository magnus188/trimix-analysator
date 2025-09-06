#include "settings.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"

static void event_go_calibrate_o2(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_CALIBRATE_O2);
    }
}

lv_obj_t *screen_settings_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar using component
    ui_create_topbar(screen, "Settings");
    
    // Create menu container
    lv_obj_t *menu_container = lv_obj_create(screen);
    lv_obj_set_size(menu_container, LV_PCT(85), 450);
    lv_obj_align(menu_container, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    lv_obj_set_style_bg_opa(menu_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(menu_container, 0, 0);
    lv_obj_set_flex_flow(menu_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(menu_container, 20, 0);
    
    // Create settings buttons using components
    ui_button_config_t btn_configs[] = {
        {"O2 Sensor Calibration", UI_COLOR_SECONDARY, event_go_calibrate_o2, NULL},
        {"System Information", UI_COLOR_PRIMARY, NULL, NULL},
        {"About", UI_COLOR_PRIMARY, NULL, NULL}
    };
    
    for (int i = 0; i < 3; i++) {
        lv_obj_t *btn = ui_create_button(menu_container, &btn_configs[i]);
        lv_obj_set_size(btn, LV_PCT(100), 60);
    }
    
    return screen;
}
