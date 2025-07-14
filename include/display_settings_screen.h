#ifndef DISPLAY_SETTINGS_SCREEN_H
#define DISPLAY_SETTINGS_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"

class DisplaySettingsScreen : public BaseScreen {
private:
    lv_obj_t* brightnessSlider;
    lv_obj_t* brightnessLabel;
    lv_obj_t* timeoutSlider;
    lv_obj_t* timeoutLabel;
    lv_obj_t* rotationDropdown;
    lv_obj_t* themeDropdown;
    lv_obj_t* animationSwitch;
    lv_obj_t* previewCard;
    
    StorageManager* storage;
    int brightness;
    int screenTimeout;
    int rotation;
    int theme;
    bool animations;

public:
    DisplaySettingsScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~DisplaySettingsScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void loadSettings();
    void saveSettings();
    void updateBrightness(int value);
    void updateScreenTimeout(int value);
    void updateRotation(int value);
    void updateTheme(int value);
    void updateAnimations(bool enabled);
    void updatePreview();
    
    static void brightnessCallback(lv_event_t* e);
    static void timeoutCallback(lv_event_t* e);
    static void rotationCallback(lv_event_t* e);
    static void themeCallback(lv_event_t* e);
    static void animationCallback(lv_event_t* e);
};

#endif // DISPLAY_SETTINGS_SCREEN_H
