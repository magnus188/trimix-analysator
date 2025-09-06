#include "screen_home.h"
#include "screen_manager.h"
#include "ui_common.h"

// Event handlers for home screen navigation
static void event_go_analyze(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_ANALYZE);
    }
}

static void event_go_dive_planner(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_DIVE_PLANNER);
    }
}

static void event_go_history(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_HISTORY);
    }
}

static void event_go_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_SETTINGS);
    }
}

lv_obj_t *screen_home_create(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, UI_COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Trimix Analyzer");
    lv_obj_set_style_text_font(title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 15);
    
    // Grid container for 2x2 buttons
    lv_obj_t *grid = lv_obj_create(screen);
    lv_obj_set_size(grid, LV_PCT(90), 360);
    lv_obj_align(grid, LV_ALIGN_CENTER, 0, 10);
    lv_obj_set_style_bg_opa(grid, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(grid, 0, 0);
    lv_obj_set_layout(grid, LV_LAYOUT_GRID);
    
    static int32_t col_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    static int32_t row_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    lv_obj_set_grid_dsc_array(grid, col_dsc, row_dsc);
    
    // Helper lambda for creating buttons
    auto make_btn = [&](const char *txt, int col, int row, lv_event_cb_t cb) {
        lv_obj_t *btn = lv_btn_create(grid);
        lv_obj_set_grid_cell(btn, LV_GRID_ALIGN_STRETCH, col, 1, LV_GRID_ALIGN_STRETCH, row, 1);
        lv_obj_set_style_radius(btn, 12, 0);
        lv_obj_set_style_bg_color(btn, UI_COLOR_PRIMARY, 0);
        lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
        lv_obj_add_event_cb(btn, cb, LV_EVENT_CLICKED, nullptr);
        
        lv_obj_t *label = lv_label_create(btn);
        lv_label_set_text(label, txt);
        lv_obj_set_style_text_font(label, FONT_BUTTON, 0);
        lv_obj_center(label);
        return btn;
    };
    
    // Create 2x2 grid of buttons
    make_btn("Analyze", 0, 0, event_go_analyze);
    make_btn("Dive Planner", 1, 0, event_go_dive_planner);
    make_btn("History", 0, 1, event_go_history);
    make_btn("Settings", 1, 1, event_go_settings);
    
    return screen;
}
