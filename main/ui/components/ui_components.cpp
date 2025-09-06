#include "ui_components.h"
#include "../screens/screen_manager.h"

// Create a styled button with custom configuration
lv_obj_t* ui_create_button(lv_obj_t* parent, const ui_button_config_t* config) {
    if (!parent || !config || !config->text) {
        return NULL;
    }
    
    lv_obj_t* btn = lv_btn_create(parent);
    lv_obj_set_style_radius(btn, 12, 0);
    lv_obj_set_style_bg_color(btn, config->bg_color, 0);
    lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
    
    if (config->event_cb) {
        lv_obj_add_event_cb(btn, config->event_cb, LV_EVENT_CLICKED, config->user_data);
    }
    
    lv_obj_t* label = lv_label_create(btn);
    lv_label_set_text(label, config->text);
    lv_obj_set_style_text_font(label, FONT_BUTTON, 0);
    lv_obj_center(label);
    
    return btn;
}

// Create a sensor data card
lv_obj_t* ui_create_sensor_card(lv_obj_t* parent, const ui_card_config_t* config) {
    if (!parent || !config || !config->title) {
        return NULL;
    }
    
    lv_obj_t* card = lv_obj_create(parent);
    lv_obj_set_style_bg_color(card, config->bg_color, 0);
    lv_obj_set_style_border_width(card, 2, 0);
    lv_obj_set_style_border_color(card, lv_color_white(), 0);
    lv_obj_set_style_radius(card, 10, 0);
    
    // Title
    lv_obj_t* title = lv_label_create(card);
    lv_label_set_text(title, config->title);
    lv_obj_set_style_text_font(title, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 5);
    
    // Value label
    lv_obj_t* value_label = lv_label_create(card);
    if (config->value && config->unit) {
        lv_label_set_text_fmt(value_label, "%s %s", config->value, config->unit);
    } else if (config->value) {
        lv_label_set_text(value_label, config->value);
    } else {
        lv_label_set_text(value_label, "-- --");
    }
    lv_obj_set_style_text_color(value_label, lv_color_white(), 0);
    lv_obj_set_style_text_font(value_label, FONT_LARGE, 0);
    lv_obj_align(value_label, LV_ALIGN_CENTER, 0, 5);
    
    return card;
}

// Create grid container for organized layouts
lv_obj_t* ui_create_grid_container(lv_obj_t* parent, int cols, int rows, int width_pct, int height) {
    if (!parent || cols <= 0 || rows <= 0) {
        return NULL;
    }
    
    lv_obj_t* grid = lv_obj_create(parent);
    lv_obj_set_size(grid, LV_PCT(width_pct), height);
    lv_obj_align(grid, LV_ALIGN_CENTER, 0, 10);
    lv_obj_set_style_bg_opa(grid, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(grid, 0, 0);
    lv_obj_set_layout(grid, LV_LAYOUT_GRID);
    
    // Create column descriptors
    static int32_t col_dsc[10]; // Support up to 9 columns + template end
    for (int i = 0; i < cols && i < 9; i++) {
        col_dsc[i] = LV_GRID_FR(1);
    }
    col_dsc[cols] = LV_GRID_TEMPLATE_LAST;
    
    // Create row descriptors
    static int32_t row_dsc[10]; // Support up to 9 rows + template end
    for (int i = 0; i < rows && i < 9; i++) {
        row_dsc[i] = LV_GRID_FR(1);
    }
    row_dsc[rows] = LV_GRID_TEMPLATE_LAST;
    
    lv_obj_set_grid_dsc_array(grid, col_dsc, row_dsc);
    
    return grid;
}

// Create a title label
lv_obj_t* ui_create_title(lv_obj_t* parent, const char* text) {
    if (!parent || !text) {
        return NULL;
    }
    
    lv_obj_t* title = lv_label_create(parent);
    lv_label_set_text(title, text);
    lv_obj_set_style_text_font(title, FONT_HEADER, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 15);
    
    return title;
}

// Event handlers for navigation (moved from ui_common.cpp)
void event_go_home(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_HOME);
    }
}

void event_go_analyze(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_ANALYZE);
    }
}

void event_go_settings(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_SETTINGS);
    }
}

void event_go_dive_planner(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_DIVE_PLANNER);
    }
}

void event_go_history(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_HISTORY);
    }
}

void event_go_back(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        screen_manager_show(SCREEN_HOME);
    }
}

// Create bottom navbar (moved from ui_common.cpp)
lv_obj_t* ui_create_navbar(lv_obj_t* parent) {
    if (!parent) {
        return NULL;
    }
    
    lv_obj_t* navbar = lv_obj_create(parent);
    lv_obj_set_size(navbar, LV_PCT(100), 60);
    lv_obj_align(navbar, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_color(navbar, lv_color_hex(0x333333), 0);
    lv_obj_set_style_border_width(navbar, 0, 0);
    lv_obj_set_style_radius(navbar, 0, 0);
    
    // Disable scrolling on navbar
    lv_obj_clear_flag(navbar, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(navbar, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_scroll_dir(navbar, LV_DIR_NONE);
    
    lv_obj_set_flex_flow(navbar, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(navbar, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    
    // Create navigation buttons
    const char* nav_labels[] = {"Home", "Analyze", "Dive", "History", "Settings"};
    lv_event_cb_t nav_callbacks[] = {event_go_home, event_go_analyze, event_go_dive_planner, event_go_history, event_go_settings};
    
    for (int i = 0; i < 5; i++) {
        lv_obj_t* btn = lv_btn_create(navbar);
        lv_obj_set_size(btn, 80, 40);
        lv_obj_set_style_bg_color(btn, UI_COLOR_PRIMARY, 0);
        lv_obj_set_style_radius(btn, 6, 0);
        lv_obj_add_event_cb(btn, nav_callbacks[i], LV_EVENT_CLICKED, NULL);
        
        lv_obj_t* label = lv_label_create(btn);
        lv_label_set_text(label, nav_labels[i]);
        lv_obj_set_style_text_font(label, FONT_NORMAL, 0);
        lv_obj_center(label);
    }
    
    return navbar;
}

// Create top navigation bar (moved from ui_common.cpp)
lv_obj_t* ui_create_topbar(lv_obj_t* parent, const char* title) {
    if (!parent || !title) {
        return NULL;
    }
    
    lv_obj_t* topbar = lv_obj_create(parent);
    lv_obj_set_size(topbar, LV_PCT(100), UI_TOPBAR_HEIGHT);
    lv_obj_align(topbar, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_set_style_bg_color(topbar, lv_color_hex(0x333333), 0);
    lv_obj_set_style_border_width(topbar, 0, 0);
    lv_obj_set_style_radius(topbar, 0, 0);
    
    // Back button
    lv_obj_t* back_btn = lv_btn_create(topbar);
    lv_obj_set_size(back_btn, 60, 35);
    lv_obj_align(back_btn, LV_ALIGN_LEFT_MID, 10, 0);
    lv_obj_set_style_bg_color(back_btn, UI_COLOR_PRIMARY, 0);
    lv_obj_set_style_radius(back_btn, 6, 0);
    lv_obj_add_event_cb(back_btn, event_go_back, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t* back_label = lv_label_create(back_btn);
    lv_label_set_text(back_label, "Back");
    lv_obj_set_style_text_font(back_label, FONT_NORMAL, 0);
    lv_obj_center(back_label);
    
    // Title
    lv_obj_t* title_label = lv_label_create(topbar);
    lv_label_set_text(title_label, title);
    lv_obj_set_style_text_font(title_label, FONT_HEADER, 0);
    lv_obj_set_style_text_color(title_label, lv_color_white(), 0);
    lv_obj_align(title_label, LV_ALIGN_CENTER, 0, 0);
    
    return topbar;
}
