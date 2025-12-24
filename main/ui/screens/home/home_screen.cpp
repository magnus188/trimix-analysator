#include "home_screen.h"
#include "../screen_manager.h"
#include "../../components/navbar.h"
#include "../../styles/styles.h"
#include <esp_log.h>

static const char* TAG = "HOME_SCREEN";

namespace {

// Menu button configuration
struct MenuButton {
    const char* label;
    const char* icon;  // LV_SYMBOL_* or custom
    uint32_t color;
    screen_id_t target_screen;
};

constexpr MenuButton MENU_BUTTONS[] = {
    { "Analyse",       LV_SYMBOL_EYE_OPEN,   STYLE_COLOR_ANALYSE,   SCREEN_ANALYSE },
    { "Dive Planner",  LV_SYMBOL_LIST,       STYLE_COLOR_DIVE_PLAN, SCREEN_DIVE_PLANNER },
    { "History",       LV_SYMBOL_DIRECTORY,  STYLE_COLOR_HISTORY,   SCREEN_HISTORY },
    { "Settings",      LV_SYMBOL_SETTINGS,   STYLE_COLOR_SETTINGS,  SCREEN_SETTINGS },
};
constexpr size_t MENU_BUTTON_COUNT = sizeof(MENU_BUTTONS) / sizeof(MENU_BUTTONS[0]);

// Layout constants for 480x800 portrait
constexpr lv_coord_t GRID_PAD = 16;
constexpr lv_coord_t BUTTON_RADIUS = 16;
constexpr lv_coord_t ICON_SIZE = 48;

void menu_button_event_cb(lv_event_t* e) {
    lv_event_code_t code = lv_event_get_code(e);
    if (code == LV_EVENT_CLICKED) {
        auto target = static_cast<screen_id_t>(reinterpret_cast<intptr_t>(lv_event_get_user_data(e)));
        ESP_LOGI(TAG, "Menu button clicked, navigating to screen %d", target);
        screen_manager_show(target);
    }
}

lv_obj_t* create_menu_button(lv_obj_t* parent, const MenuButton& cfg) {
    // Button container
    lv_obj_t* btn = lv_obj_create(parent);
    lv_obj_remove_style_all(btn);
    // Size will be set by caller
    
    // Background styling
    lv_obj_set_style_bg_color(btn, lv_color_hex(cfg.color), 0);
    lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(btn, BUTTON_RADIUS, 0);
    
    // Pressed state - darker shade
    lv_obj_set_style_bg_color(btn, lv_color_darken(lv_color_hex(cfg.color), LV_OPA_30), LV_STATE_PRESSED);
    lv_obj_set_style_transform_width(btn, -2, LV_STATE_PRESSED);
    lv_obj_set_style_transform_height(btn, -2, LV_STATE_PRESSED);
    
    // Shadow for depth
    lv_obj_set_style_shadow_width(btn, 15, 0);
    lv_obj_set_style_shadow_color(btn, lv_color_black(), 0);
    lv_obj_set_style_shadow_opa(btn, LV_OPA_30, 0);
    lv_obj_set_style_shadow_ofs_y(btn, 4, 0);
    
    // Layout
    lv_obj_set_flex_flow(btn, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(btn, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_all(btn, 12, 0);
    lv_obj_clear_flag(btn, LV_OBJ_FLAG_SCROLLABLE);
    
    // Make clickable
    lv_obj_add_flag(btn, LV_OBJ_FLAG_CLICKABLE);
    
    // Icon
    lv_obj_t* icon = lv_label_create(btn);
    lv_label_set_text(icon, cfg.icon);
    lv_obj_set_style_text_font(icon, &lv_font_montserrat_36, 0);
    lv_obj_set_style_text_color(icon, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Label
    lv_obj_t* label = lv_label_create(btn);
    lv_label_set_text(label, cfg.label);
    lv_obj_set_style_text_font(label, styles_get_font_button(), 0);
    lv_obj_set_style_text_color(label, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_set_style_text_align(label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_set_style_pad_top(label, 8, 0);
    
    // Event handler
    lv_obj_add_event_cb(btn, menu_button_event_cb, LV_EVENT_CLICKED, 
                        reinterpret_cast<void*>(static_cast<intptr_t>(cfg.target_screen)));
    
    return btn;
}

}  // namespace

lv_obj_t* home_screen_create(void) {
    ESP_LOGI(TAG, "Creating home screen");
    
    // Screen base - 480x800 portrait
    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BG_DARK), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    
    // Navbar (no back button on home)
    navbar_create(screen, "Trimix Analysator");
    
    // Content area below navbar - use explicit sizes
    // navbar_get_height() returns 70 now
    lv_coord_t content_height = 800 - navbar_get_height() - (GRID_PAD * 2);
    lv_coord_t content_width = 480 - (GRID_PAD * 2);
    
    lv_obj_t* content = lv_obj_create(screen);
    lv_obj_remove_style_all(content);
    lv_obj_set_size(content, content_width, content_height);
    lv_obj_set_pos(content, GRID_PAD, navbar_get_height() + GRID_PAD);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    
    // Calculate button sizes (2x2 grid with padding)
    lv_coord_t btn_width = (content_width - GRID_PAD) / 2;
    lv_coord_t btn_height = (content_height - GRID_PAD) / 2;
    
    // Create buttons directly in content
    for (size_t i = 0; i < MENU_BUTTON_COUNT; i++) {
        lv_obj_t* btn = create_menu_button(content, MENU_BUTTONS[i]);
        uint8_t col = i % 2;
        uint8_t row = i / 2;
        lv_coord_t x = col * (btn_width + GRID_PAD);
        lv_coord_t y = row * (btn_height + GRID_PAD);
        lv_obj_set_size(btn, btn_width, btn_height);
        lv_obj_set_pos(btn, x, y);
    }
    
    ESP_LOGI(TAG, "Home screen created");
    return screen;
}
