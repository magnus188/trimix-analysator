#include "safety_settings_screen.h"
#include "screen_manager.h"
#include "arduino_compat.h"

SafetySettingsScreen::SafetySettingsScreen(ScreenManager* screenManager) 
    : BaseScreen("safety_settings", screenManager),
      co2Section(nullptr), coSection(nullptr),
      co2ThresholdSlider(nullptr), coThresholdSlider(nullptr),
      co2EnabledSwitch(nullptr), coEnabledSwitch(nullptr),
      co2ThresholdLabel(nullptr), coThresholdLabel(nullptr),
      resetButton(nullptr), storage(screenManager->getStorage()),
      co2Threshold(1000), coThreshold(35), co2Enabled(true), coEnabled(true) {
}

SafetySettingsScreen::~SafetySettingsScreen() {
    // Objects will be cleaned up by LVGL when parent is deleted
}

void SafetySettingsScreen::create() {
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
    createNavBar("Safety Settings", true);
    
    // Create main content container
    lv_obj_t* content = lv_obj_create(screenObj);
    lv_obj_set_size(content, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(content, 10, 60);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_remove_style_all(content);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(content, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(content, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_gap(content, 15, LV_PART_MAIN);
    
    // CO2 settings section
    co2Section = createSafetySection("CO2 Alert Settings", 400, 5000, 
                                    &co2ThresholdSlider, &co2EnabledSwitch, &co2ThresholdLabel,
                                    co2SliderCallback, co2SwitchCallback);
    lv_obj_set_parent(co2Section, content);
    
    // CO settings section
    coSection = createSafetySection("CO Alert Settings", 1, 100, 
                                  &coThresholdSlider, &coEnabledSwitch, &coThresholdLabel,
                                  coSliderCallback, coSwitchCallback);
    lv_obj_set_parent(coSection, content);
    
    // Reset button
    resetButton = lv_btn_create(content);
    lv_obj_set_size(resetButton, 150, 40);
    lv_obj_set_style_bg_color(resetButton, lv_color_hex(0xFF5722), LV_PART_MAIN);
    lv_obj_set_style_radius(resetButton, 5, LV_PART_MAIN);
    
    lv_obj_t* resetLabel = lv_label_create(resetButton);
    lv_label_set_text(resetLabel, "Reset to Defaults");
    lv_obj_set_style_text_color(resetLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(resetLabel);
    
    lv_obj_add_event_cb(resetButton, resetCallback, LV_EVENT_CLICKED, this);
}

void SafetySettingsScreen::onEnter() {
    BaseScreen::onEnter();
    loadSettings();
}

void SafetySettingsScreen::onExit() {
    BaseScreen::onExit();
    saveSettings();
}

void SafetySettingsScreen::loadSettings() {
    if (storage) {
        co2Threshold = storage->loadIntSetting("safety_co2_threshold", 1000);
        coThreshold = storage->loadIntSetting("safety_co_threshold", 35);
        co2Enabled = storage->loadBoolSetting("safety_co2_enabled", true);
        coEnabled = storage->loadBoolSetting("safety_co_enabled", true);
        
        Serial.printf("Loaded safety settings: CO2=%d ppm (%s), CO=%d ppm (%s)\n", 
                      co2Threshold, co2Enabled ? "enabled" : "disabled",
                      coThreshold, coEnabled ? "enabled" : "disabled");
    } else {
        // Use default values
        co2Threshold = 1000;
        coThreshold = 35;
        co2Enabled = true;
        coEnabled = true;
    }
    
    // Update UI elements
    lv_slider_set_value(co2ThresholdSlider, co2Threshold, LV_ANIM_OFF);
    lv_slider_set_value(coThresholdSlider, coThreshold, LV_ANIM_OFF);
    
    if (co2EnabledSwitch) {
        if (co2Enabled) {
            lv_obj_add_state(co2EnabledSwitch, LV_STATE_CHECKED);
        } else {
            lv_obj_clear_state(co2EnabledSwitch, LV_STATE_CHECKED);
        }
    }
    
    if (coEnabledSwitch) {
        if (coEnabled) {
            lv_obj_add_state(coEnabledSwitch, LV_STATE_CHECKED);
        } else {
            lv_obj_clear_state(coEnabledSwitch, LV_STATE_CHECKED);
        }
    }
    
    updateThresholdLabel(co2ThresholdLabel, co2Threshold, "ppm");
    updateThresholdLabel(coThresholdLabel, coThreshold, "ppm");
}

void SafetySettingsScreen::saveSettings() {
    if (storage) {
        storage->saveSetting("safety_co2_threshold", co2Threshold);
        storage->saveSetting("safety_co_threshold", coThreshold);
        storage->saveSetting("safety_co2_enabled", co2Enabled);
        storage->saveSetting("safety_co_enabled", coEnabled);
        
        Serial.printf("Saved safety settings: CO2=%d ppm (%s), CO=%d ppm (%s)\n", 
                      co2Threshold, co2Enabled ? "enabled" : "disabled",
                      coThreshold, coEnabled ? "enabled" : "disabled");
    } else {
        Serial.println("Storage manager not available - settings not saved");
    }
}

lv_obj_t* SafetySettingsScreen::createSafetySection(const char* title, int minVal, int maxVal, 
                                                   lv_obj_t** slider, lv_obj_t** enableSwitch, 
                                                   lv_obj_t** valueLabel, lv_event_cb_t sliderCallback,
                                                   lv_event_cb_t switchCallback) {
    lv_obj_t* section = lv_obj_create(lv_scr_act());
    lv_obj_set_size(section, LV_HOR_RES - 40, 140);
    lv_obj_clear_flag(section, LV_OBJ_FLAG_SCROLLABLE);
    
    // Section styling
    lv_obj_set_style_bg_color(section, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(section, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(section, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_width(section, 1, LV_PART_MAIN);
    lv_obj_set_style_radius(section, 8, LV_PART_MAIN);
    lv_obj_set_style_pad_all(section, 15, LV_PART_MAIN);
    
    // Title
    lv_obj_t* titleLabel = lv_label_create(section);
    lv_label_set_text(titleLabel, title);
    lv_obj_set_style_text_color(titleLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_set_pos(titleLabel, 0, 0);
    
    // Enable/disable switch
    *enableSwitch = lv_switch_create(section);
    lv_obj_set_size(*enableSwitch, 50, 25);
    lv_obj_set_pos(*enableSwitch, LV_HOR_RES - 110, 0);
    lv_obj_add_state(*enableSwitch, LV_STATE_CHECKED);
    lv_obj_add_event_cb(*enableSwitch, switchCallback, LV_EVENT_VALUE_CHANGED, this);
    
    // Threshold label
    lv_obj_t* thresholdLabel = lv_label_create(section);
    lv_label_set_text(thresholdLabel, "Threshold:");
    lv_obj_set_style_text_color(thresholdLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_style_text_font(thresholdLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(thresholdLabel, 0, 35);
    
    // Value label
    *valueLabel = lv_label_create(section);
    lv_label_set_text(*valueLabel, "1000 ppm");
    lv_obj_set_style_text_color(*valueLabel, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_text_font(*valueLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(*valueLabel, 80, 35);
    
    // Threshold slider
    *slider = lv_slider_create(section);
    lv_obj_set_size(*slider, LV_HOR_RES - 80, 20);
    lv_obj_set_pos(*slider, 0, 60);
    lv_slider_set_range(*slider, minVal, maxVal);
    lv_slider_set_value(*slider, (minVal + maxVal) / 2, LV_ANIM_OFF);
    
    // Slider styling
    lv_obj_set_style_bg_color(*slider, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_bg_color(*slider, lv_color_hex(0x2196F3), LV_PART_INDICATOR);
    lv_obj_set_style_bg_color(*slider, lv_color_hex(0x1976D2), LV_PART_KNOB);
    
    lv_obj_add_event_cb(*slider, sliderCallback, LV_EVENT_VALUE_CHANGED, this);
    
    // Min/max labels
    lv_obj_t* minLabel = lv_label_create(section);
    lv_label_set_text_fmt(minLabel, "%d", minVal);
    lv_obj_set_style_text_color(minLabel, lv_color_hex(0x888888), LV_PART_MAIN);
    lv_obj_set_style_text_font(minLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(minLabel, 0, 90);
    
    lv_obj_t* maxLabel = lv_label_create(section);
    lv_label_set_text_fmt(maxLabel, "%d", maxVal);
    lv_obj_set_style_text_color(maxLabel, lv_color_hex(0x888888), LV_PART_MAIN);
    lv_obj_set_style_text_font(maxLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(maxLabel, LV_HOR_RES - 80, 90);
    
    return section;
}

void SafetySettingsScreen::updateThresholdLabel(lv_obj_t* label, int value, const char* unit) {
    if (label != nullptr) {
        lv_label_set_text_fmt(label, "%d %s", value, unit);
    }
}

void SafetySettingsScreen::co2SliderCallback(lv_event_t* e) {
    SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->co2Threshold = lv_slider_get_value(screen->co2ThresholdSlider);
        screen->updateThresholdLabel(screen->co2ThresholdLabel, screen->co2Threshold, "ppm");
    }
}

void SafetySettingsScreen::coSliderCallback(lv_event_t* e) {
    SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->coThreshold = lv_slider_get_value(screen->coThresholdSlider);
        screen->updateThresholdLabel(screen->coThresholdLabel, screen->coThreshold, "ppm");
    }
}

void SafetySettingsScreen::co2SwitchCallback(lv_event_t* e) {
    SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->co2Enabled = lv_obj_has_state(screen->co2EnabledSwitch, LV_STATE_CHECKED);
        Serial.printf("CO2 alerts %s\n", screen->co2Enabled ? "enabled" : "disabled");
    }
}

void SafetySettingsScreen::coSwitchCallback(lv_event_t* e) {
    SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->coEnabled = lv_obj_has_state(screen->coEnabledSwitch, LV_STATE_CHECKED);
        Serial.printf("CO alerts %s\n", screen->coEnabled ? "enabled" : "disabled");
    }
}

void SafetySettingsScreen::resetCallback(lv_event_t* e) {
    SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->showResetConfirmation();
    }
}

void SafetySettingsScreen::showResetConfirmation() {
    // Create a message box with Yes/No buttons
    static const char* btns[] = {"Yes", "No", ""};
    lv_obj_t* msgbox = lv_msgbox_create(NULL, "Reset Settings", 
                                       "Reset all safety settings to factory defaults?", 
                                       btns, true);
    lv_obj_center(msgbox);
    
    // Add event handler for button clicks
    lv_obj_add_event_cb(msgbox, [](lv_event_t* e) {
        SafetySettingsScreen* screen = static_cast<SafetySettingsScreen*>(lv_event_get_user_data(e));
        lv_obj_t* msgbox = lv_event_get_current_target(e);
        const char* txt = lv_msgbox_get_active_btn_text(msgbox);
        
        if (strcmp(txt, "Yes") == 0 && screen != nullptr) {
            // Reset to defaults
            screen->co2Threshold = 1000;
            screen->coThreshold = 35;
            screen->co2Enabled = true;
            screen->coEnabled = true;
            screen->loadSettings(); // Refresh UI
            screen->saveSettings();
        }
        
        lv_msgbox_close(msgbox);
    }, LV_EVENT_VALUE_CHANGED, this);
}
