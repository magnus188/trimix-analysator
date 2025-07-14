#include "home_screen.h"
#include "screen_manager.h"
#include "arduino_compat.h"

HomeScreen::HomeScreen(ScreenManager* screenManager) 
    : BaseScreen("home", screenManager), menuGrid(nullptr), 
      analyzerCard(nullptr), plannerCard(nullptr), historyCard(nullptr), settingsCard(nullptr) {
}

HomeScreen::~HomeScreen() {
    // Objects will be cleaned up by LVGL when parent is deleted
}

void HomeScreen::create() {
    // Create main screen container
    screenObj = lv_obj_create(manager->getMainContainer());
    lv_obj_set_size(screenObj, LV_HOR_RES, LV_VER_RES);
    lv_obj_set_pos(screenObj, 0, 0);
    lv_obj_clear_flag(screenObj, LV_OBJ_FLAG_SCROLLABLE);
    
    // Remove default styling
    lv_obj_remove_style_all(screenObj);
    lv_obj_set_style_bg_color(screenObj, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(screenObj, LV_OPA_COVER, LV_PART_MAIN);
    
    // Create navigation bar
    lv_obj_t* navbar = lv_obj_create(screenObj);
    lv_obj_set_size(navbar, LV_HOR_RES, 50);
    lv_obj_set_pos(navbar, 0, 0);
    lv_obj_clear_flag(navbar, LV_OBJ_FLAG_SCROLLABLE);
    
    // Navbar styling
    lv_obj_set_style_bg_color(navbar, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(navbar, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(navbar, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(navbar, 0, LV_PART_MAIN);
    
    // Title
    lv_obj_t* titleLabel = lv_label_create(navbar);
    lv_label_set_text(titleLabel, "Trimix Analyzer");
    lv_obj_set_style_text_color(titleLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_align(titleLabel, LV_ALIGN_CENTER, 0, 0);
    
    // Power button
    lv_obj_t* powerBtn = lv_btn_create(navbar);
    lv_obj_set_size(powerBtn, 60, 35);
    lv_obj_set_pos(powerBtn, LV_HOR_RES - 70, 7);
    lv_obj_set_style_bg_color(powerBtn, lv_color_hex(0x1976D2), LV_PART_MAIN);
    lv_obj_set_style_radius(powerBtn, 5, LV_PART_MAIN);
    
    lv_obj_t* powerLabel = lv_label_create(powerBtn);
    lv_label_set_text(powerLabel, "Power");
    lv_obj_set_style_text_color(powerLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(powerLabel);
    
    lv_obj_add_event_cb(powerBtn, powerButtonCallback, LV_EVENT_CLICKED, this);
    
    // Create menu grid
    menuGrid = lv_obj_create(screenObj);
    lv_obj_set_size(menuGrid, LV_HOR_RES - 40, LV_VER_RES - 90);
    lv_obj_set_pos(menuGrid, 20, 70);
    lv_obj_clear_flag(menuGrid, LV_OBJ_FLAG_SCROLLABLE);
    
    // Grid styling
    lv_obj_remove_style_all(menuGrid);
    lv_obj_set_style_bg_opa(menuGrid, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(menuGrid, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(menuGrid, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(menuGrid, LV_FLEX_FLOW_ROW_WRAP);
    lv_obj_set_flex_align(menuGrid, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_SPACE_EVENLY);
    lv_obj_set_style_pad_gap(menuGrid, 10, LV_PART_MAIN);
    
    // Create menu cards
    analyzerCard = createMenuCard("Analyzer", analyzerCardCallback);
    plannerCard = createMenuCard("Dive Planner", plannerCardCallback);
    historyCard = createMenuCard("History", historyCardCallback);
    settingsCard = createMenuCard("Settings", settingsCardCallback);
}

void HomeScreen::onEnter() {
    BaseScreen::onEnter();
    Serial.println("Home screen entered");
}

lv_obj_t* HomeScreen::createMenuCard(const char* title, lv_event_cb_t callback) {
    lv_obj_t* card = lv_obj_create(menuGrid);
    lv_obj_set_size(card, (LV_HOR_RES - 60) / 2, 80);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    
    // Card styling
    lv_obj_set_style_bg_color(card, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(card, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_width(card, 1, LV_PART_MAIN);
    lv_obj_set_style_radius(card, 8, LV_PART_MAIN);
    
    // Hover effect
    lv_obj_set_style_bg_color(card, lv_color_hex(0x616161), LV_PART_MAIN | LV_STATE_PRESSED);
    
    // Card title
    lv_obj_t* label = lv_label_create(card);
    lv_label_set_text(label, title);
    lv_obj_set_style_text_color(label, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_center(label);
    
    // Add click event
    lv_obj_add_event_cb(card, callback, LV_EVENT_CLICKED, this);
    lv_obj_add_flag(card, LV_OBJ_FLAG_CLICKABLE);
    
    return card;
}

void HomeScreen::analyzerCardCallback(lv_event_t* e) {
    HomeScreen* screen = static_cast<HomeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("analyze");
    }
}

void HomeScreen::plannerCardCallback(lv_event_t* e) {
    HomeScreen* screen = static_cast<HomeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        Serial.println("Dive Planner clicked - not implemented yet");
    }
}

void HomeScreen::historyCardCallback(lv_event_t* e) {
    HomeScreen* screen = static_cast<HomeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("history");
    }
}

void HomeScreen::settingsCardCallback(lv_event_t* e) {
    HomeScreen* screen = static_cast<HomeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("settings");
    }
}

void HomeScreen::powerButtonCallback(lv_event_t* e) {
    HomeScreen* screen = static_cast<HomeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        Serial.println("Power button clicked - not implemented yet");
    }
}
