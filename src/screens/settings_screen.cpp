#include "settings_screen.h"
#include "screen_manager.h"
#include "arduino_compat.h"

SettingsScreen::SettingsScreen(ScreenManager* screenManager) 
    : BaseScreen("settings", screenManager), settingsList(nullptr),
      calibrationCard(nullptr), safetyCard(nullptr), displayCard(nullptr), aboutCard(nullptr) {
}

SettingsScreen::~SettingsScreen() {
    // Objects will be cleaned up by LVGL when parent is deleted
}

void SettingsScreen::create() {
    // Create main screen container
    screenObj = lv_obj_create(manager->getMainContainer());
    lv_obj_set_size(screenObj, LV_HOR_RES, LV_VER_RES);
    lv_obj_set_pos(screenObj, 0, 0);
    lv_obj_clear_flag(screenObj, LV_OBJ_FLAG_SCROLLABLE);
    
    // Remove default styling
    lv_obj_remove_style_all(screenObj);
    lv_obj_set_style_bg_color(screenObj, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(screenObj, LV_OPA_COVER, LV_PART_MAIN);
    
    // Create navigation bar with back button
    createNavBar("Settings", true);
    
    // Create settings list
    settingsList = lv_obj_create(screenObj);
    lv_obj_set_size(settingsList, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(settingsList, 10, 60);
    lv_obj_clear_flag(settingsList, LV_OBJ_FLAG_SCROLLABLE);
    
    // List styling
    lv_obj_remove_style_all(settingsList);
    lv_obj_set_style_bg_opa(settingsList, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(settingsList, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(settingsList, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(settingsList, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(settingsList, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_gap(settingsList, 10, LV_PART_MAIN);
    
    // Create settings cards
    calibrationCard = createSettingsCard("Calibration", 
                                        "Calibrate O2 and He sensors", 
                                        calibrationCallback);
    
    safetyCard = createSettingsCard("Safety Settings", 
                                  "Configure CO2 and CO alert thresholds", 
                                  safetyCallback);
    
    displayCard = createSettingsCard("Display Settings", 
                                   "Brightness and screen timeout", 
                                   displayCallback);
    
    lv_obj_t* wifiCard = createSettingsCard("WiFi Settings", 
                                           "Configure wireless network", 
                                           wifiCallback);
    
    lv_obj_t* sensorCard = createSettingsCard("Sensor Settings", 
                                             "Advanced sensor configuration", 
                                             sensorCallback);
    
    lv_obj_t* updateCard = createSettingsCard("Updates", 
                                            "Check for firmware updates", 
                                            updateCallback);
    
    aboutCard = createSettingsCard("About", 
                                 "Version info and system details", 
                                 aboutCallback);
}

void SettingsScreen::onEnter() {
    BaseScreen::onEnter();
    Serial.println("Settings screen entered");
}

lv_obj_t* SettingsScreen::createSettingsCard(const char* title, const char* subtitle, lv_event_cb_t callback) {
    lv_obj_t* card = lv_obj_create(settingsList);
    lv_obj_set_size(card, LV_HOR_RES - 40, 70);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    
    // Card styling
    lv_obj_set_style_bg_color(card, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(card, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_width(card, 1, LV_PART_MAIN);
    lv_obj_set_style_radius(card, 8, LV_PART_MAIN);
    
    // Hover effect
    lv_obj_set_style_bg_color(card, lv_color_hex(0x616161), LV_PART_MAIN | LV_STATE_PRESSED);
    
    // Title label
    lv_obj_t* titleLabel = lv_label_create(card);
    lv_label_set_text(titleLabel, title);
    lv_obj_set_style_text_color(titleLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_set_pos(titleLabel, 15, 10);
    
    // Subtitle label
    lv_obj_t* subtitleLabel = lv_label_create(card);
    lv_label_set_text(subtitleLabel, subtitle);
    lv_obj_set_style_text_color(subtitleLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_style_text_font(subtitleLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(subtitleLabel, 15, 30);
    
    // Arrow icon
    lv_obj_t* arrowLabel = lv_label_create(card);
    lv_label_set_text(arrowLabel, ">");
    lv_obj_set_style_text_color(arrowLabel, lv_color_hex(0x888888), LV_PART_MAIN);
    lv_obj_set_style_text_font(arrowLabel, &lv_font_montserrat_16, LV_PART_MAIN);
    lv_obj_set_pos(arrowLabel, LV_HOR_RES - 70, 25);
    
    // Add click event
    lv_obj_add_event_cb(card, callback, LV_EVENT_CLICKED, this);
    lv_obj_add_flag(card, LV_OBJ_FLAG_CLICKABLE);
    
    return card;
}

void SettingsScreen::calibrationCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("calibration");
    }
}

void SettingsScreen::safetyCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("safety_settings");
    }
}

void SettingsScreen::displayCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("display_settings");
    }
}

void SettingsScreen::wifiCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("wifi_settings");
    }
}

void SettingsScreen::sensorCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("sensor_settings");
    }
}

void SettingsScreen::updateCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("update_settings");
    }
}

void SettingsScreen::aboutCallback(lv_event_t* e) {
    SettingsScreen* screen = static_cast<SettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->navigateToScreen("about");
    }
}
