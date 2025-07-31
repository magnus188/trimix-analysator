/*
 * SettingsScreen.h
 * Settings management screen for ESP32-S3 Trimix Analyzer
 */

#ifndef SETTINGS_SCREEN_H
#define SETTINGS_SCREEN_H

#include <Arduino.h>
#include <lvgl.h>

class TrimixApp;

class SettingsScreen {
public:
    SettingsScreen(TrimixApp* app);
    ~SettingsScreen();
    
    bool create();
    void show();
    void hide();
    void update();
    
    lv_obj_t* getScreen() const { return screen; }

private:
    TrimixApp* app;
    lv_obj_t* screen;
    
    // Navigation
    lv_obj_t* back_btn;
    lv_obj_t* tabview;
    
    // Tab objects
    lv_obj_t* display_tab;
    lv_obj_t* sensor_tab;
    lv_obj_t* wifi_tab;
    lv_obj_t* alarm_tab;
    
    // Display settings controls
    lv_obj_t* brightness_slider;
    lv_obj_t* brightness_label;
    lv_obj_t* sleep_switch;
    lv_obj_t* sleep_slider;
    lv_obj_t* sleep_label;
    
    // Sensor settings controls
    lv_obj_t* o2_calib_label;
    lv_obj_t* o2_calib_btn;
    lv_obj_t* co2_calib_btn;
    lv_obj_t* sensor_interval_slider;
    lv_obj_t* sensor_interval_label;
    
    // WiFi settings controls
    lv_obj_t* wifi_switch;
    lv_obj_t* wifi_ssid_ta;
    lv_obj_t* wifi_pass_ta;
    lv_obj_t* wifi_connect_btn;
    lv_obj_t* wifi_status_label;
    
    // Alarm settings controls
    lv_obj_t* alarm_switch;
    lv_obj_t* o2_min_slider;
    lv_obj_t* o2_min_label;
    lv_obj_t* o2_max_slider;
    lv_obj_t* o2_max_label;
    lv_obj_t* co2_max_slider;
    lv_obj_t* co2_max_label;
    
    // Private methods
    void createLayout();
    void createDisplayTab();
    void createSensorTab();
    void createWiFiTab();
    void createAlarmTab();
    void loadCurrentSettings();
    void updateWiFiStatus();
    
    // Event callbacks
    static void on_back_clicked(lv_event_t* e);
    static void on_brightness_changed(lv_event_t* e);
    static void on_sleep_toggled(lv_event_t* e);
    static void on_sleep_timeout_changed(lv_event_t* e);
    static void on_o2_calibrate_clicked(lv_event_t* e);
    static void on_co2_calibrate_clicked(lv_event_t* e);
    static void on_sensor_interval_changed(lv_event_t* e);
    static void on_wifi_toggled(lv_event_t* e);
    static void on_wifi_connect_clicked(lv_event_t* e);
    static void on_alarms_toggled(lv_event_t* e);
    static void on_o2_min_changed(lv_event_t* e);
    static void on_o2_max_changed(lv_event_t* e);
    static void on_co2_max_changed(lv_event_t* e);
};

#endif // SETTINGS_SCREEN_H