#ifndef SETTINGS_SCREEN_H
#define SETTINGS_SCREEN_H

#include "base_screen.h"

class SettingsScreen : public BaseScreen {
private:
    lv_obj_t* settingsList;
    lv_obj_t* calibrationCard;
    lv_obj_t* safetyCard;
    lv_obj_t* displayCard;
    lv_obj_t* aboutCard;

public:
    SettingsScreen(ScreenManager* screenManager);
    ~SettingsScreen();
    
    void create() override;
    void onEnter() override;
    
private:
    lv_obj_t* createSettingsCard(const char* title, const char* subtitle, lv_event_cb_t callback);
    static void calibrationCallback(lv_event_t* e);
    static void safetyCallback(lv_event_t* e);
    static void displayCallback(lv_event_t* e);
    static void wifiCallback(lv_event_t* e);
    static void sensorCallback(lv_event_t* e);
    static void updateCallback(lv_event_t* e);
    static void aboutCallback(lv_event_t* e);
};

#endif // SETTINGS_SCREEN_H
