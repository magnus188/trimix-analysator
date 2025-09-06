#include "screen_analyze.h"
#include "screen_manager.h"
#include "ui_common.h"

lv_obj_t *screen_analyze_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Real-time Analysis");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    // Grid container for sensor cards
    lv_obj_t *grid_container = lv_obj_create(screen);
    lv_obj_set_size(grid_container, LV_PCT(90), 600);
    lv_obj_align(grid_container, LV_ALIGN_CENTER, 0, 20);
    lv_obj_set_style_bg_opa(grid_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(grid_container, 0, 0);
    lv_obj_set_layout(grid_container, LV_LAYOUT_GRID);
    
    static int32_t col_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    static int32_t row_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    lv_obj_set_grid_dsc_array(grid_container, col_dsc, row_dsc);
    
    // Oxygen card
    lv_obj_t *o2_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(o2_card, LV_GRID_ALIGN_STRETCH, 0, 1, LV_GRID_ALIGN_STRETCH, 0, 1);
    lv_obj_set_style_bg_color(o2_card, UI_COLOR_SECONDARY, 0);
    lv_obj_set_style_border_width(o2_card, 2, 0);
    lv_obj_set_style_border_color(o2_card, lv_color_white(), 0);
    lv_obj_set_style_radius(o2_card, 10, 0);
    
    lv_obj_t *o2_title = lv_label_create(o2_card);
    lv_label_set_text(o2_title, "Oxygen");
    lv_obj_set_style_text_color(o2_title, lv_color_white(), 0);
    lv_obj_align(o2_title, LV_ALIGN_TOP_MID, 0, 5);
    
    lv_obj_t *label_o2 = lv_label_create(o2_card);
    lv_label_set_text(label_o2, "20.9 %");
    lv_obj_set_style_text_color(label_o2, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_o2, &lv_font_montserrat_14, 0);
    lv_obj_align(label_o2, LV_ALIGN_CENTER, 0, 5);
    
    // CO2 card
    lv_obj_t *co2_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(co2_card, LV_GRID_ALIGN_STRETCH, 1, 1, LV_GRID_ALIGN_STRETCH, 0, 1);
    lv_obj_set_style_bg_color(co2_card, UI_COLOR_WARNING, 0);
    lv_obj_set_style_border_width(co2_card, 2, 0);
    lv_obj_set_style_border_color(co2_card, lv_color_white(), 0);
    lv_obj_set_style_radius(co2_card, 10, 0);
    
    lv_obj_t *co2_title = lv_label_create(co2_card);
    lv_label_set_text(co2_title, "CO2");
    lv_obj_set_style_text_color(co2_title, lv_color_white(), 0);
    lv_obj_align(co2_title, LV_ALIGN_TOP_MID, 0, 5);
    
    lv_obj_t *label_co2 = lv_label_create(co2_card);
    lv_label_set_text(label_co2, "400 ppm");
    lv_obj_set_style_text_color(label_co2, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_co2, &lv_font_montserrat_14, 0);
    lv_obj_align(label_co2, LV_ALIGN_CENTER, 0, 5);
    
    // Temperature card
    lv_obj_t *temp_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(temp_card, LV_GRID_ALIGN_STRETCH, 0, 1, LV_GRID_ALIGN_STRETCH, 1, 1);
    lv_obj_set_style_bg_color(temp_card, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(temp_card, 2, 0);
    lv_obj_set_style_border_color(temp_card, lv_color_white(), 0);
    lv_obj_set_style_radius(temp_card, 10, 0);
    
    lv_obj_t *temp_title = lv_label_create(temp_card);
    lv_label_set_text(temp_title, "Temperature");
    lv_obj_set_style_text_color(temp_title, lv_color_white(), 0);
    lv_obj_align(temp_title, LV_ALIGN_TOP_MID, 0, 5);
    
    lv_obj_t *label_temp = lv_label_create(temp_card);
    lv_label_set_text(label_temp, "22.5 °C");
    lv_obj_set_style_text_color(label_temp, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_temp, &lv_font_montserrat_14, 0);
    lv_obj_align(label_temp, LV_ALIGN_CENTER, 0, 5);
    
    // Pressure card
    lv_obj_t *press_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(press_card, LV_GRID_ALIGN_STRETCH, 1, 1, LV_GRID_ALIGN_STRETCH, 1, 1);
    lv_obj_set_style_bg_color(press_card, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(press_card, 2, 0);
    lv_obj_set_style_border_color(press_card, lv_color_white(), 0);
    lv_obj_set_style_radius(press_card, 10, 0);
    
    lv_obj_t *press_title = lv_label_create(press_card);
    lv_label_set_text(press_title, "Pressure");
    lv_obj_set_style_text_color(press_title, lv_color_white(), 0);
    lv_obj_align(press_title, LV_ALIGN_TOP_MID, 0, 5);
    
    lv_obj_t *label_pressure = lv_label_create(press_card);
    lv_label_set_text(label_pressure, "1.01 bar");
    lv_obj_set_style_text_color(label_pressure, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_pressure, &lv_font_montserrat_14, 0);
    lv_obj_align(label_pressure, LV_ALIGN_CENTER, 0, 5);
    
    // Humidity card (spans two columns)
    lv_obj_t *hum_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(hum_card, LV_GRID_ALIGN_STRETCH, 0, 2, LV_GRID_ALIGN_STRETCH, 2, 1);
    lv_obj_set_style_bg_color(hum_card, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(hum_card, 2, 0);
    lv_obj_set_style_border_color(hum_card, lv_color_white(), 0);
    lv_obj_set_style_radius(hum_card, 10, 0);
    
    lv_obj_t *hum_title = lv_label_create(hum_card);
    lv_label_set_text(hum_title, "Humidity");
    lv_obj_set_style_text_color(hum_title, lv_color_white(), 0);
    lv_obj_align(hum_title, LV_ALIGN_TOP_MID, 0, 5);
    
    lv_obj_t *label_humidity = lv_label_create(hum_card);
    lv_label_set_text(label_humidity, "45.2 %");
    lv_obj_set_style_text_color(label_humidity, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_humidity, &lv_font_montserrat_14, 0);
    lv_obj_align(label_humidity, LV_ALIGN_CENTER, 0, 5);
    
    // Register labels with screen manager for updates
    screen_manager_set_analyze_labels(label_o2, label_co2, label_temp, label_pressure, label_humidity);
    
    // Add navigation bar
    ui_create_navbar(screen);
    
    return screen;
}
