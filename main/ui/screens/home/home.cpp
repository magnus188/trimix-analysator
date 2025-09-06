#include "home.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"

lv_obj_t *screen_home_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Create title using component
    ui_create_title(screen, "Trimix Analyzer");
    
    // Create grid container using component
    lv_obj_t *grid = ui_create_grid_container(screen, 2, 2, 90, 360);
    
    // Create buttons using components
    ui_button_config_t btn_configs[] = {
        {"Analyze", UI_COLOR_PRIMARY, event_go_analyze, NULL},
        {"Dive Planner", UI_COLOR_PRIMARY, event_go_dive_planner, NULL}, 
        {"History", UI_COLOR_PRIMARY, event_go_history, NULL},
        {"Settings", UI_COLOR_PRIMARY, event_go_settings, NULL}
    };
    
    for (int i = 0; i < 4; i++) {
        lv_obj_t *btn = ui_create_button(grid, &btn_configs[i]);
        int col = i % 2;
        int row = i / 2;
        lv_obj_set_grid_cell(btn, LV_GRID_ALIGN_STRETCH, col, 1, LV_GRID_ALIGN_STRETCH, row, 1);
    }
    
    return screen;
}
