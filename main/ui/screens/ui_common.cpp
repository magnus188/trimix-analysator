#include "ui_common.h"
#include "screen_manager.h"

// Event handlers for navbar navigation
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

// Create bottom navbar for home screen
lv_obj_t *ui_create_navbar(lv_obj_t *parent) {
    lv_obj_t *navbar = lv_obj_create(parent);
    lv_obj_set_size(navbar, LV_PCT(100), 60);
    lv_obj_align(navbar, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_color(navbar, lv_color_hex(0x333333), 0);
    lv_obj_set_style_border_width(navbar, 0, 0);
    lv_obj_set_style_radius(navbar, 0, 0);
    
    // Disable scrolling on navbar - it should be static
    lv_obj_clear_flag(navbar, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_scrollbar_mode(navbar, LV_SCROLLBAR_MODE_OFF);
    lv_obj_set_scroll_dir(navbar, LV_DIR_NONE);
    
    // Create buttons container
    lv_obj_set_flex_flow(navbar, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(navbar, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    
    // Helper function to create navbar button
    auto create_nav_btn = [](lv_obj_t *parent, const char *txt, lv_event_cb_t event_cb) {
        lv_obj_t *btn = lv_btn_create(parent);
        lv_obj_set_size(btn, 70, 45);
        lv_obj_set_style_bg_color(btn, UI_COLOR_PRIMARY, 0);
        lv_obj_set_style_radius(btn, 8, 0);
        lv_obj_add_event_cb(btn, event_cb, LV_EVENT_CLICKED, nullptr);
        
        lv_obj_t *label = lv_label_create(btn);
        lv_label_set_text(label, txt);
        lv_obj_set_style_text_font(label, FONT_SMALL, 0);
        lv_obj_center(label);
        
        return btn;
    };
    
    // Create navigation buttons
    create_nav_btn(navbar, "Analyze", event_go_analyze);
    create_nav_btn(navbar, "Plan", event_go_dive_planner);
    create_nav_btn(navbar, "History", event_go_history);
    create_nav_btn(navbar, "Settings", event_go_settings);
    
    return navbar;
}

// Create top navigation bar for sub-screens
lv_obj_t *ui_create_topbar(lv_obj_t *parent, const char *title) {
    // Top navigation bar
    lv_obj_t *topbar = lv_obj_create(parent);
    lv_obj_set_size(topbar, LV_PCT(100), UI_TOPBAR_HEIGHT);
    lv_obj_align(topbar, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_set_style_bg_color(topbar, lv_color_hex(0x2E2E2E), 0);
    lv_obj_set_style_border_width(topbar, 0, 0);
    lv_obj_set_style_radius(topbar, 0, 0);
    
    // Back button (left side)
    lv_obj_t *btn_back = lv_btn_create(topbar);
    lv_obj_set_size(btn_back, 44, 44);
    lv_obj_align(btn_back, LV_ALIGN_LEFT_MID, 10, 0);
    lv_obj_set_style_bg_color(btn_back, lv_color_hex(0x444444), 0);
    lv_obj_set_style_radius(btn_back, 22, 0); // Circular
    lv_obj_add_event_cb(btn_back, event_go_back, LV_EVENT_CLICKED, nullptr);

    // Back arrow symbol (using text for now, can be replaced with icon font later)
    lv_obj_t *arrow = lv_label_create(btn_back);
    lv_label_set_text(arrow, "<");
    lv_obj_set_style_text_font(arrow, FONT_MEDIUM, 0);
    lv_obj_set_style_text_color(arrow, lv_color_white(), 0);
    lv_obj_center(arrow);

    // Title (center)
    lv_obj_t *title_label = lv_label_create(topbar);
    lv_label_set_text(title_label, title);
    lv_obj_set_style_text_font(title_label, FONT_TITLE, 0);
    lv_obj_set_style_text_color(title_label, lv_color_white(), 0);
    lv_obj_align(title_label, LV_ALIGN_CENTER, 0, 0);
    
    return topbar;
}
