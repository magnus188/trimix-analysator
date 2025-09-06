#include "analyze.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"

lv_obj_t *screen_analyze_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar using component
    ui_create_topbar(screen, "Real-time Analysis");
    
    // Create grid container using component (adjust position for topbar)
    lv_obj_t *grid_container = ui_create_grid_container(screen, 2, 3, 90, 600);
    lv_obj_align(grid_container, LV_ALIGN_CENTER, 0, UI_TOPBAR_HEIGHT / 2);
    
    // Sensor card configurations
    ui_card_config_t card_configs[] = {
        {"Oxygen", "20.9", "%", UI_COLOR_SECONDARY},
        {"CO2", "400", "ppm", UI_COLOR_WARNING},
        {"Temperature", "22.5", "°C", UI_COLOR_PRIMARY},
        {"Pressure", "1.01", "bar", UI_COLOR_PRIMARY},
        {"Humidity", "45.2", "%", UI_COLOR_PRIMARY}
    };
    
    // Create sensor cards using components
    lv_obj_t *cards[5];
    for (int i = 0; i < 5; i++) {
        cards[i] = ui_create_sensor_card(grid_container, &card_configs[i]);
        
        if (i < 4) {
            // First 4 cards in 2x2 grid
            int col = i % 2;
            int row = i / 2;
            lv_obj_set_grid_cell(cards[i], LV_GRID_ALIGN_STRETCH, col, 1, LV_GRID_ALIGN_STRETCH, row, 1);
        } else {
            // Humidity card spans two columns
            lv_obj_set_grid_cell(cards[i], LV_GRID_ALIGN_STRETCH, 0, 2, LV_GRID_ALIGN_STRETCH, 2, 1);
        }
    }
    
    // Extract value labels for screen manager updates
    lv_obj_t *label_o2 = lv_obj_get_child(cards[0], 1);     // Second child is value label
    lv_obj_t *label_co2 = lv_obj_get_child(cards[1], 1);
    lv_obj_t *label_temp = lv_obj_get_child(cards[2], 1);
    lv_obj_t *label_pressure = lv_obj_get_child(cards[3], 1);
    lv_obj_t *label_humidity = lv_obj_get_child(cards[4], 1);
    
    // Register labels with screen manager for updates
    screen_manager_set_analyze_labels(label_o2, label_co2, label_temp, label_pressure, label_humidity);
    
    return screen;
}
