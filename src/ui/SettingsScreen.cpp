/*
 * SettingsScreen.cpp
 * Implementation of settings management for ESP32-S3 Trimix Analyzer
 */

#include "ui/SettingsScreen.h"
#include "TrimixApp.h"
#include <WiFi.h>

SettingsScreen::SettingsScreen(TrimixApp* app) :
    app(app),
    screen(nullptr),
    back_btn(nullptr),
    tabview(nullptr),
    display_tab(nullptr),
    sensor_tab(nullptr),
    wifi_tab(nullptr),
    alarm_tab(nullptr)
{
    // Initialize all control pointers to nullptr
    brightness_slider = nullptr;
    brightness_label = nullptr;
    sleep_switch = nullptr;
    sleep_slider = nullptr;
    sleep_label = nullptr;
    o2_calib_label = nullptr;
    o2_calib_btn = nullptr;
    co2_calib_btn = nullptr;
    sensor_interval_slider = nullptr;
    sensor_interval_label = nullptr;
    wifi_switch = nullptr;
    wifi_ssid_ta = nullptr;
    wifi_pass_ta = nullptr;
    wifi_connect_btn = nullptr;
    wifi_status_label = nullptr;
    alarm_switch = nullptr;
    o2_min_slider = nullptr;
    o2_min_label = nullptr;
    o2_max_slider = nullptr;
    o2_max_label = nullptr;
    co2_max_slider = nullptr;
    co2_max_label = nullptr;
}

SettingsScreen::~SettingsScreen() {
    if (screen) {
        lv_obj_del(screen);
    }
}

bool SettingsScreen::create() {
    Serial.println("SettingsScreen: Creating settings screen");
    
    // Create screen
    screen = lv_obj_create(NULL);
    if (!screen) {
        Serial.println("SettingsScreen: Failed to create screen");
        return false;
    }
    
    // Set background color
    lv_obj_set_style_bg_color(screen, lv_color_hex(0x111111), 0);
    
    createLayout();
    createDisplayTab();
    createSensorTab();
    createWiFiTab();
    createAlarmTab();
    loadCurrentSettings();
    
    Serial.println("SettingsScreen: Settings screen created successfully");
    return true;
}

void SettingsScreen::createLayout() {
    // Create title
    lv_obj_t* title_label = lv_label_create(screen);
    lv_label_set_text(title_label, "SETTINGS");
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(title_label, lv_color_hex(0xFFFFFF), 0);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 10);
    
    // Create back button
    back_btn = lv_btn_create(screen);
    lv_obj_set_size(back_btn, 80, 40);
    lv_obj_align(back_btn, LV_ALIGN_TOP_LEFT, 10, 10);
    lv_obj_add_event_cb(back_btn, on_back_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* back_label = lv_label_create(back_btn);
    lv_label_set_text(back_label, "BACK");
    lv_obj_center(back_label);
    
    // Create tabview
    tabview = lv_tabview_create(screen, LV_DIR_TOP, 50);
    lv_obj_set_size(tabview, 780, 400);
    lv_obj_align(tabview, LV_ALIGN_CENTER, 0, 20);
    
    // Create tabs
    display_tab = lv_tabview_add_tab(tabview, "DISPLAY");
    sensor_tab = lv_tabview_add_tab(tabview, "SENSORS");
    wifi_tab = lv_tabview_add_tab(tabview, "WIFI");
    alarm_tab = lv_tabview_add_tab(tabview, "ALARMS");
}

void SettingsScreen::createDisplayTab() {
    // Brightness control
    lv_obj_t* brightness_cont = lv_obj_create(display_tab);
    lv_obj_set_size(brightness_cont, 350, 80);
    lv_obj_align(brightness_cont, LV_ALIGN_TOP_LEFT, 10, 10);
    
    lv_obj_t* brightness_title = lv_label_create(brightness_cont);
    lv_label_set_text(brightness_title, "Brightness");
    lv_obj_align(brightness_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    brightness_slider = lv_slider_create(brightness_cont);
    lv_obj_set_size(brightness_slider, 200, 20);
    lv_obj_align(brightness_slider, LV_ALIGN_CENTER, -20, 5);
    lv_slider_set_range(brightness_slider, 10, 255);
    lv_obj_add_event_cb(brightness_slider, on_brightness_changed, LV_EVENT_VALUE_CHANGED, this);
    
    brightness_label = lv_label_create(brightness_cont);
    lv_label_set_text(brightness_label, "128");
    lv_obj_align(brightness_label, LV_ALIGN_RIGHT_MID, -10, 5);
    
    // Auto sleep control
    lv_obj_t* sleep_cont = lv_obj_create(display_tab);
    lv_obj_set_size(sleep_cont, 350, 120);
    lv_obj_align(sleep_cont, LV_ALIGN_TOP_RIGHT, -10, 10);
    
    lv_obj_t* sleep_title = lv_label_create(sleep_cont);
    lv_label_set_text(sleep_title, "Auto Sleep");
    lv_obj_align(sleep_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    sleep_switch = lv_switch_create(sleep_cont);
    lv_obj_align(sleep_switch, LV_ALIGN_TOP_RIGHT, -10, 5);
    lv_obj_add_event_cb(sleep_switch, on_sleep_toggled, LV_EVENT_VALUE_CHANGED, this);
    
    sleep_slider = lv_slider_create(sleep_cont);
    lv_obj_set_size(sleep_slider, 200, 20);
    lv_obj_align(sleep_slider, LV_ALIGN_CENTER, -20, 15);
    lv_slider_set_range(sleep_slider, 1, 60);
    lv_obj_add_event_cb(sleep_slider, on_sleep_timeout_changed, LV_EVENT_VALUE_CHANGED, this);
    
    sleep_label = lv_label_create(sleep_cont);
    lv_label_set_text(sleep_label, "30 min");
    lv_obj_align(sleep_label, LV_ALIGN_BOTTOM_MID, 0, -5);
}

void SettingsScreen::createSensorTab() {
    // O2 Calibration
    lv_obj_t* o2_calib_cont = lv_obj_create(sensor_tab);
    lv_obj_set_size(o2_calib_cont, 350, 100);
    lv_obj_align(o2_calib_cont, LV_ALIGN_TOP_LEFT, 10, 10);
    
    lv_obj_t* o2_title = lv_label_create(o2_calib_cont);
    lv_label_set_text(o2_title, "O2 Calibration");
    lv_obj_align(o2_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    o2_calib_label = lv_label_create(o2_calib_cont);
    lv_label_set_text(o2_calib_label, "Current: 0.0095V");
    lv_obj_align(o2_calib_label, LV_ALIGN_CENTER, 0, -5);
    
    o2_calib_btn = lv_btn_create(o2_calib_cont);
    lv_obj_set_size(o2_calib_btn, 120, 30);
    lv_obj_align(o2_calib_btn, LV_ALIGN_BOTTOM_MID, 0, -5);
    lv_obj_add_event_cb(o2_calib_btn, on_o2_calibrate_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* o2_btn_label = lv_label_create(o2_calib_btn);
    lv_label_set_text(o2_btn_label, "CALIBRATE");
    lv_obj_center(o2_btn_label);
    
    // CO2 Calibration
    lv_obj_t* co2_calib_cont = lv_obj_create(sensor_tab);
    lv_obj_set_size(co2_calib_cont, 350, 100);
    lv_obj_align(co2_calib_cont, LV_ALIGN_TOP_RIGHT, -10, 10);
    
    lv_obj_t* co2_title = lv_label_create(co2_calib_cont);
    lv_label_set_text(co2_title, "CO2 Calibration");
    lv_obj_align(co2_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    co2_calib_btn = lv_btn_create(co2_calib_cont);
    lv_obj_set_size(co2_calib_btn, 120, 30);
    lv_obj_align(co2_calib_btn, LV_ALIGN_BOTTOM_MID, 0, -5);
    lv_obj_add_event_cb(co2_calib_btn, on_co2_calibrate_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* co2_btn_label = lv_label_create(co2_calib_btn);
    lv_label_set_text(co2_btn_label, "CALIBRATE");
    lv_obj_center(co2_btn_label);
    
    // Sensor update interval
    lv_obj_t* interval_cont = lv_obj_create(sensor_tab);
    lv_obj_set_size(interval_cont, 720, 80);
    lv_obj_align(interval_cont, LV_ALIGN_BOTTOM_MID, 0, -10);
    
    lv_obj_t* interval_title = lv_label_create(interval_cont);
    lv_label_set_text(interval_title, "Update Interval");
    lv_obj_align(interval_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    sensor_interval_slider = lv_slider_create(interval_cont);
    lv_obj_set_size(sensor_interval_slider, 400, 20);
    lv_obj_align(sensor_interval_slider, LV_ALIGN_CENTER, -50, 5);
    lv_slider_set_range(sensor_interval_slider, 500, 5000);
    lv_obj_add_event_cb(sensor_interval_slider, on_sensor_interval_changed, LV_EVENT_VALUE_CHANGED, this);
    
    sensor_interval_label = lv_label_create(interval_cont);
    lv_label_set_text(sensor_interval_label, "2000 ms");
    lv_obj_align(sensor_interval_label, LV_ALIGN_RIGHT_MID, -10, 5);
}

void SettingsScreen::createWiFiTab() {
    // WiFi enable/disable
    lv_obj_t* wifi_enable_cont = lv_obj_create(wifi_tab);
    lv_obj_set_size(wifi_enable_cont, 720, 60);
    lv_obj_align(wifi_enable_cont, LV_ALIGN_TOP_MID, 0, 10);
    
    lv_obj_t* wifi_title = lv_label_create(wifi_enable_cont);
    lv_label_set_text(wifi_title, "WiFi Enabled");
    lv_obj_align(wifi_title, LV_ALIGN_LEFT_MID, 20, 0);
    
    wifi_switch = lv_switch_create(wifi_enable_cont);
    lv_obj_align(wifi_switch, LV_ALIGN_RIGHT_MID, -20, 0);
    lv_obj_add_event_cb(wifi_switch, on_wifi_toggled, LV_EVENT_VALUE_CHANGED, this);
    
    // WiFi SSID
    lv_obj_t* ssid_label = lv_label_create(wifi_tab);
    lv_label_set_text(ssid_label, "Network Name (SSID):");
    lv_obj_align(ssid_label, LV_ALIGN_TOP_LEFT, 20, 90);
    
    wifi_ssid_ta = lv_textarea_create(wifi_tab);
    lv_obj_set_size(wifi_ssid_ta, 300, 40);
    lv_obj_align(wifi_ssid_ta, LV_ALIGN_TOP_LEFT, 20, 120);
    lv_textarea_set_max_length(wifi_ssid_ta, 32);
    lv_textarea_set_placeholder_text(wifi_ssid_ta, "Enter WiFi name");
    
    // WiFi Password
    lv_obj_t* pass_label = lv_label_create(wifi_tab);
    lv_label_set_text(pass_label, "Password:");
    lv_obj_align(pass_label, LV_ALIGN_TOP_RIGHT, -320, 90);
    
    wifi_pass_ta = lv_textarea_create(wifi_tab);
    lv_obj_set_size(wifi_pass_ta, 300, 40);
    lv_obj_align(wifi_pass_ta, LV_ALIGN_TOP_RIGHT, -20, 120);
    lv_textarea_set_max_length(wifi_pass_ta, 64);
    lv_textarea_set_placeholder_text(wifi_pass_ta, "Enter password");
    lv_textarea_set_password_mode(wifi_pass_ta, true);
    
    // Connect button and status
    wifi_connect_btn = lv_btn_create(wifi_tab);
    lv_obj_set_size(wifi_connect_btn, 120, 40);
    lv_obj_align(wifi_connect_btn, LV_ALIGN_TOP_MID, 0, 190);
    lv_obj_add_event_cb(wifi_connect_btn, on_wifi_connect_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* connect_label = lv_label_create(wifi_connect_btn);
    lv_label_set_text(connect_label, "CONNECT");
    lv_obj_center(connect_label);
    
    wifi_status_label = lv_label_create(wifi_tab);
    lv_label_set_text(wifi_status_label, "Status: Disconnected");
    lv_obj_align(wifi_status_label, LV_ALIGN_BOTTOM_MID, 0, -20);
}

void SettingsScreen::createAlarmTab() {
    // Alarms enable/disable
    lv_obj_t* alarm_enable_cont = lv_obj_create(alarm_tab);
    lv_obj_set_size(alarm_enable_cont, 720, 60);
    lv_obj_align(alarm_enable_cont, LV_ALIGN_TOP_MID, 0, 10);
    
    lv_obj_t* alarm_title = lv_label_create(alarm_enable_cont);
    lv_label_set_text(alarm_title, "Alarms Enabled");
    lv_obj_align(alarm_title, LV_ALIGN_LEFT_MID, 20, 0);
    
    alarm_switch = lv_switch_create(alarm_enable_cont);
    lv_obj_align(alarm_switch, LV_ALIGN_RIGHT_MID, -20, 0);
    lv_obj_add_event_cb(alarm_switch, on_alarms_toggled, LV_EVENT_VALUE_CHANGED, this);
    
    // O2 Min alarm
    lv_obj_t* o2_min_cont = lv_obj_create(alarm_tab);
    lv_obj_set_size(o2_min_cont, 230, 80);
    lv_obj_align(o2_min_cont, LV_ALIGN_TOP_LEFT, 10, 80);
    
    lv_obj_t* o2_min_title = lv_label_create(o2_min_cont);
    lv_label_set_text(o2_min_title, "O2 Min %");
    lv_obj_align(o2_min_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    o2_min_slider = lv_slider_create(o2_min_cont);
    lv_obj_set_size(o2_min_slider, 150, 20);
    lv_obj_align(o2_min_slider, LV_ALIGN_CENTER, -10, 5);
    lv_slider_set_range(o2_min_slider, 100, 250); // 10.0% to 25.0%
    lv_obj_add_event_cb(o2_min_slider, on_o2_min_changed, LV_EVENT_VALUE_CHANGED, this);
    
    o2_min_label = lv_label_create(o2_min_cont);
    lv_label_set_text(o2_min_label, "16.0%");
    lv_obj_align(o2_min_label, LV_ALIGN_BOTTOM_MID, 0, -5);
    
    // O2 Max alarm
    lv_obj_t* o2_max_cont = lv_obj_create(alarm_tab);
    lv_obj_set_size(o2_max_cont, 230, 80);
    lv_obj_align(o2_max_cont, LV_ALIGN_TOP_MID, 0, 80);
    
    lv_obj_t* o2_max_title = lv_label_create(o2_max_cont);
    lv_label_set_text(o2_max_title, "O2 Max %");
    lv_obj_align(o2_max_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    o2_max_slider = lv_slider_create(o2_max_cont);
    lv_obj_set_size(o2_max_slider, 150, 20);
    lv_obj_align(o2_max_slider, LV_ALIGN_CENTER, -10, 5);
    lv_slider_set_range(o2_max_slider, 200, 300); // 20.0% to 30.0%
    lv_obj_add_event_cb(o2_max_slider, on_o2_max_changed, LV_EVENT_VALUE_CHANGED, this);
    
    o2_max_label = lv_label_create(o2_max_cont);
    lv_label_set_text(o2_max_label, "23.0%");
    lv_obj_align(o2_max_label, LV_ALIGN_BOTTOM_MID, 0, -5);
    
    // CO2 Max alarm
    lv_obj_t* co2_max_cont = lv_obj_create(alarm_tab);
    lv_obj_set_size(co2_max_cont, 230, 80);
    lv_obj_align(co2_max_cont, LV_ALIGN_TOP_RIGHT, -10, 80);
    
    lv_obj_t* co2_max_title = lv_label_create(co2_max_cont);
    lv_label_set_text(co2_max_title, "CO2 Max ppm");
    lv_obj_align(co2_max_title, LV_ALIGN_TOP_LEFT, 10, 5);
    
    co2_max_slider = lv_slider_create(co2_max_cont);
    lv_obj_set_size(co2_max_slider, 150, 20);
    lv_obj_align(co2_max_slider, LV_ALIGN_CENTER, -10, 5);
    lv_slider_set_range(co2_max_slider, 500, 5000); // 500-5000 ppm
    lv_obj_add_event_cb(co2_max_slider, on_co2_max_changed, LV_EVENT_VALUE_CHANGED, this);
    
    co2_max_label = lv_label_create(co2_max_cont);
    lv_label_set_text(co2_max_label, "1000 ppm");
    lv_obj_align(co2_max_label, LV_ALIGN_BOTTOM_MID, 0, -5);
}

void SettingsScreen::loadCurrentSettings() {
    if (!app) return;
    
    SettingsManager* settings = app->getSettingsManager();
    if (!settings) return;
    
    // Load display settings
    lv_slider_set_value(brightness_slider, settings->getBrightness(), LV_ANIM_OFF);
    lv_label_set_text_fmt(brightness_label, "%d", settings->getBrightness());
    
    if (settings->getAutoSleep()) {
        lv_obj_add_state(sleep_switch, LV_STATE_CHECKED);
    }
    lv_slider_set_value(sleep_slider, settings->getSleepTimeout(), LV_ANIM_OFF);
    lv_label_set_text_fmt(sleep_label, "%d min", settings->getSleepTimeout());
    
    // Load sensor settings
    lv_label_set_text_fmt(o2_calib_label, "Current: %.6fV", settings->getO2Calibration());
    lv_slider_set_value(sensor_interval_slider, settings->getSensorUpdateInterval(), LV_ANIM_OFF);
    lv_label_set_text_fmt(sensor_interval_label, "%d ms", settings->getSensorUpdateInterval());
    
    // Load WiFi settings
    if (settings->getWiFiEnabled()) {
        lv_obj_add_state(wifi_switch, LV_STATE_CHECKED);
    }
    lv_textarea_set_text(wifi_ssid_ta, settings->getWiFiSSID().c_str());
    // Don't load password for security
    
    // Load alarm settings
    if (settings->getAlarmsEnabled()) {
        lv_obj_add_state(alarm_switch, LV_STATE_CHECKED);
    }
    lv_slider_set_value(o2_min_slider, (int)(settings->getO2MinAlarm() * 10), LV_ANIM_OFF);
    lv_label_set_text_fmt(o2_min_label, "%.1f%%", settings->getO2MinAlarm());
    
    lv_slider_set_value(o2_max_slider, (int)(settings->getO2MaxAlarm() * 10), LV_ANIM_OFF);
    lv_label_set_text_fmt(o2_max_label, "%.1f%%", settings->getO2MaxAlarm());
    
    lv_slider_set_value(co2_max_slider, (int)settings->getCO2MaxAlarm(), LV_ANIM_OFF);
    lv_label_set_text_fmt(co2_max_label, "%.0f ppm", settings->getCO2MaxAlarm());
}

void SettingsScreen::show() {
    if (screen) {
        lv_scr_load(screen);
        loadCurrentSettings(); // Refresh settings when shown
        updateWiFiStatus();
    }
}

void SettingsScreen::hide() {
    // Screen is automatically hidden when another screen is loaded
}

void SettingsScreen::update() {
    // Update WiFi status periodically
    static unsigned long last_wifi_update = 0;
    if (millis() - last_wifi_update > 2000) {
        updateWiFiStatus();
        last_wifi_update = millis();
    }
}

void SettingsScreen::updateWiFiStatus() {
    if (!wifi_status_label) return;
    
    if (WiFi.status() == WL_CONNECTED) {
        lv_label_set_text_fmt(wifi_status_label, "Connected: %s", WiFi.localIP().toString().c_str());
        lv_obj_set_style_text_color(wifi_status_label, lv_color_hex(0x00FF00), 0);
    } else {
        lv_label_set_text(wifi_status_label, "Status: Disconnected");
        lv_obj_set_style_text_color(wifi_status_label, lv_color_hex(0xFF0000), 0);
    }
}

// Event callbacks
void SettingsScreen::on_back_clicked(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        Serial.println("SettingsScreen: Back button clicked");
        settings->app->showHome();
    }
}

void SettingsScreen::on_brightness_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        uint8_t value = lv_slider_get_value(settings->brightness_slider);
        settings->app->getSettingsManager()->setBrightness(value);
        lv_label_set_text_fmt(settings->brightness_label, "%d", value);
    }
}

void SettingsScreen::on_sleep_toggled(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        bool enabled = lv_obj_has_state(settings->sleep_switch, LV_STATE_CHECKED);
        settings->app->getSettingsManager()->setAutoSleep(enabled);
    }
}

void SettingsScreen::on_sleep_timeout_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        uint16_t value = lv_slider_get_value(settings->sleep_slider);
        settings->app->getSettingsManager()->setSleepTimeout(value);
        lv_label_set_text_fmt(settings->sleep_label, "%d min", value);
    }
}

void SettingsScreen::on_o2_calibrate_clicked(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        Serial.println("SettingsScreen: O2 calibration clicked");
        // TODO: Implement O2 calibration dialog
        // For now, just use current voltage reading
        SensorManager* sensors = settings->app->getSensorManager();
        if (sensors) {
            float voltage = sensors->getO2Voltage();
            sensors->setO2Calibration(voltage);
            settings->app->getSettingsManager()->setO2Calibration(voltage);
            lv_label_set_text_fmt(settings->o2_calib_label, "Current: %.6fV", voltage);
        }
    }
}

void SettingsScreen::on_co2_calibrate_clicked(lv_event_t* e) {
    Serial.println("SettingsScreen: CO2 calibration clicked - not implemented yet");
}

void SettingsScreen::on_sensor_interval_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        uint16_t value = lv_slider_get_value(settings->sensor_interval_slider);
        settings->app->getSettingsManager()->setSensorUpdateInterval(value);
        lv_label_set_text_fmt(settings->sensor_interval_label, "%d ms", value);
    }
}

void SettingsScreen::on_wifi_toggled(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        bool enabled = lv_obj_has_state(settings->wifi_switch, LV_STATE_CHECKED);
        settings->app->getSettingsManager()->setWiFiEnabled(enabled);
    }
}

void SettingsScreen::on_wifi_connect_clicked(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        String ssid = lv_textarea_get_text(settings->wifi_ssid_ta);
        String password = lv_textarea_get_text(settings->wifi_pass_ta);
        
        if (ssid.length() > 0) {
            settings->app->getSettingsManager()->setWiFiSSID(ssid);
            settings->app->getSettingsManager()->setWiFiPassword(password);
            
            Serial.printf("Connecting to WiFi: %s\n", ssid.c_str());
            WiFi.begin(ssid.c_str(), password.c_str());
        }
    }
}

void SettingsScreen::on_alarms_toggled(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        bool enabled = lv_obj_has_state(settings->alarm_switch, LV_STATE_CHECKED);
        settings->app->getSettingsManager()->setAlarmsEnabled(enabled);
    }
}

void SettingsScreen::on_o2_min_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        float value = lv_slider_get_value(settings->o2_min_slider) / 10.0f;
        settings->app->getSettingsManager()->setO2MinAlarm(value);
        lv_label_set_text_fmt(settings->o2_min_label, "%.1f%%", value);
    }
}

void SettingsScreen::on_o2_max_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        float value = lv_slider_get_value(settings->o2_max_slider) / 10.0f;
        settings->app->getSettingsManager()->setO2MaxAlarm(value);
        lv_label_set_text_fmt(settings->o2_max_label, "%.1f%%", value);
    }
}

void SettingsScreen::on_co2_max_changed(lv_event_t* e) {
    SettingsScreen* settings = (SettingsScreen*)lv_event_get_user_data(e);
    if (settings && settings->app) {
        float value = lv_slider_get_value(settings->co2_max_slider);
        settings->app->getSettingsManager()->setCO2MaxAlarm(value);
        lv_label_set_text_fmt(settings->co2_max_label, "%.0f ppm", value);
    }
}