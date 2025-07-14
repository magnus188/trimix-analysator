#include "base_screen.h"
#include "screen_manager.h"
#include "arduino_compat.h"

BaseScreen::BaseScreen(const std::string& screenName, ScreenManager* screenManager) 
    : name(screenName), manager(screenManager), screenObj(nullptr), isActive(false) {
}

BaseScreen::~BaseScreen() {
    if (screenObj != nullptr) {
        lv_obj_del(screenObj);
    }
}

void BaseScreen::onEnter() {
    // Default implementation - can be overridden
    Serial.print("Entering screen: ");
    Serial.println(name.c_str());
}

void BaseScreen::onExit() {
    // Default implementation - can be overridden
    Serial.print("Exiting screen: ");
    Serial.println(name.c_str());
}

void BaseScreen::update() {
    // Default implementation - can be overridden
}

lv_obj_t* BaseScreen::getScreenObject() {
    return screenObj;
}

const std::string& BaseScreen::getName() const {
    return name;
}

bool BaseScreen::getIsActive() const {
    return isActive;
}

void BaseScreen::setActive(bool active) {
    isActive = active;
}

void BaseScreen::navigateToScreen(const std::string& screenName) {
    if (manager != nullptr) {
        manager->setCurrentScreen(screenName);
    }
}

lv_obj_t* BaseScreen::createNavBar(const std::string& title, bool showBackButton) {
    lv_obj_t* navbar = lv_obj_create(screenObj);
    lv_obj_set_size(navbar, LV_HOR_RES, 50);
    lv_obj_set_pos(navbar, 0, 0);
    lv_obj_clear_flag(navbar, LV_OBJ_FLAG_SCROLLABLE);
    
    // Styling
    lv_obj_set_style_bg_color(navbar, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(navbar, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(navbar, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(navbar, 0, LV_PART_MAIN);
    
    // Title label
    lv_obj_t* titleLabel = lv_label_create(navbar);
    lv_label_set_text(titleLabel, title.c_str());
    lv_obj_set_style_text_color(titleLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_center(titleLabel);
    
    // Back button
    if (showBackButton) {
        lv_obj_t* backBtn = lv_btn_create(navbar);
        lv_obj_set_size(backBtn, 80, 35);
        lv_obj_set_pos(backBtn, 10, 7);
        lv_obj_set_style_bg_color(backBtn, lv_color_hex(0x1976D2), LV_PART_MAIN);
        lv_obj_set_style_radius(backBtn, 5, LV_PART_MAIN);
        
        lv_obj_t* backLabel = lv_label_create(backBtn);
        lv_label_set_text(backLabel, "← Back");
        lv_obj_set_style_text_color(backLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
        lv_obj_center(backLabel);
        
        lv_obj_add_event_cb(backBtn, backButtonCallback, LV_EVENT_CLICKED, this);
    }
    
    return navbar;
}

void BaseScreen::backButtonCallback(lv_event_t* e) {
    BaseScreen* screen = static_cast<BaseScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("home");
    }
}
