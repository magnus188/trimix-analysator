#ifndef SAFETY_SETTINGS_SCREEN_H
#define SAFETY_SETTINGS_SCREEN_H

#include "base_screen.h"

class StorageManager;

class SafetySettingsScreen : public BaseScreen {
private:
    lv_obj_t* co2Section;
    lv_obj_t* coSection;
    lv_obj_t* co2ThresholdSlider;
    lv_obj_t* coThresholdSlider;
    lv_obj_t* co2EnabledSwitch;
    lv_obj_t* coEnabledSwitch;
    lv_obj_t* co2ThresholdLabel;
    lv_obj_t* coThresholdLabel;
    lv_obj_t* resetButton;
    
    StorageManager* storage;
    int co2Threshold;
    int coThreshold;
    bool co2Enabled;
    bool coEnabled;

public:
    SafetySettingsScreen(ScreenManager* screenManager);
    ~SafetySettingsScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void loadSettings();
    void saveSettings();
    lv_obj_t* createSafetySection(const char* title, int minVal, int maxVal, 
                                 lv_obj_t** slider, lv_obj_t** enableSwitch, 
                                 lv_obj_t** valueLabel, lv_event_cb_t sliderCallback,
                                 lv_event_cb_t switchCallback);
    static void co2SliderCallback(lv_event_t* e);
    static void coSliderCallback(lv_event_t* e);
    static void co2SwitchCallback(lv_event_t* e);
    static void coSwitchCallback(lv_event_t* e);
    static void resetCallback(lv_event_t* e);
    void updateThresholdLabel(lv_obj_t* label, int value, const char* unit);
    void showResetConfirmation();
};

#endif // SAFETY_SETTINGS_SCREEN_H
