/*
 * TrimixApp.cpp
 * Implementation of main application class for ESP32-S3 Trimix Analyzer
 */

#include "TrimixApp.h"
#include "ui/HomeScreen.h"
#include "ui/AnalyzeScreen.h"
#include "ui/SettingsScreen.h"

// Static instance pointer
TrimixApp* TrimixApp::instance = nullptr;

TrimixApp::TrimixApp(DisplayManager* display, SensorManager* sensors, SettingsManager* settings) :
    displayManager(display),
    sensorManager(sensors),
    settingsManager(settings),
    homeScreen(nullptr),
    analyzeScreen(nullptr),
    settingsScreen(nullptr),
    screen_saver_active(false),
    last_activity(0),
    screen_saver_timeout(30000) // 30 seconds default
{
    instance = this;
}

TrimixApp::~TrimixApp() {
    if (homeScreen) delete homeScreen;
    if (analyzeScreen) delete analyzeScreen;
    if (settingsScreen) delete settingsScreen;
    instance = nullptr;
}

bool TrimixApp::begin() {
    Serial.println("TrimixApp: Initializing application...");
    
    // Set screen saver timeout from settings
    screen_saver_timeout = settingsManager->getSleepTimeout() * 60000; // Convert minutes to ms
    last_activity = millis();
    
    // Initialize screens
    initializeScreens();
    
    // Show home screen
    showHome();
    
    Serial.println("TrimixApp: Application initialized successfully");
    return true;
}

void TrimixApp::update() {
    // Update screen saver
    updateScreenSaver();
    
    // Check alarms
    checkAlarms();
    
    // Handle system tasks
    handleSystemTasks();
    
    // Update current screen
    if (homeScreen && lv_scr_act() == homeScreen->getScreen()) {
        homeScreen->update();
    } else if (analyzeScreen && lv_scr_act() == analyzeScreen->getScreen()) {
        analyzeScreen->update();
    } else if (settingsScreen && lv_scr_act() == settingsScreen->getScreen()) {
        settingsScreen->update();
    }
}

void TrimixApp::initializeScreens() {
    Serial.println("TrimixApp: Creating UI screens...");
    
    // Create home screen
    homeScreen = new HomeScreen(this);
    if (!homeScreen->create()) {
        Serial.println("TrimixApp: Failed to create home screen");
        return;
    }
    
    // Create analyze screen
    analyzeScreen = new AnalyzeScreen(this);
    if (!analyzeScreen->create()) {
        Serial.println("TrimixApp: Failed to create analyze screen");
        return;
    }
    
    // Create settings screen
    settingsScreen = new SettingsScreen(this);
    if (!settingsScreen->create()) {
        Serial.println("TrimixApp: Failed to create settings screen");
        return;
    }
    
    Serial.println("TrimixApp: UI screens created successfully");
}

void TrimixApp::showHome() {
    if (homeScreen) {
        Serial.println("TrimixApp: Showing home screen");
        homeScreen->show();
        wakeFromScreenSaver();
    }
}

void TrimixApp::showAnalyze() {
    if (analyzeScreen) {
        Serial.println("TrimixApp: Showing analyze screen");
        analyzeScreen->show();
        wakeFromScreenSaver();
    }
}

void TrimixApp::showSettings() {
    if (settingsScreen) {
        Serial.println("TrimixApp: Showing settings screen");
        settingsScreen->show();
        wakeFromScreenSaver();
    }
}

void TrimixApp::showScreen(lv_obj_t* screen) {
    if (screen) {
        displayManager->setActiveScreen(screen);
        wakeFromScreenSaver();
    }
}

void TrimixApp::wakeFromScreenSaver() {
    if (screen_saver_active) {
        Serial.println("TrimixApp: Waking from screen saver");
        screen_saver_active = false;
        
        // Restore display brightness
        uint8_t brightness = settingsManager->getBrightness();
        displayManager->setBrightness(brightness);
    }
    
    last_activity = millis();
}

void TrimixApp::updateScreenSaver() {
    if (!settingsManager->getAutoSleep()) {
        return; // Auto sleep disabled
    }
    
    unsigned long current_time = millis();
    
    // Check for touch activity
    if (displayManager->isTouchPressed()) {
        last_activity = current_time;
        if (screen_saver_active) {
            wakeFromScreenSaver();
        }
        return;
    }
    
    // Check if we should activate screen saver
    if (!screen_saver_active && (current_time - last_activity) > screen_saver_timeout) {
        Serial.println("TrimixApp: Activating screen saver");
        screen_saver_active = true;
        
        // Dim display (but keep it on for sensor monitoring)
        displayManager->setBrightness(10); // Very dim
    }
}

void TrimixApp::checkAlarms() {
    if (!settingsManager->getAlarmsEnabled()) {
        return;
    }
    
    static unsigned long last_alarm_check = 0;
    unsigned long current_time = millis();
    
    // Check alarms every 5 seconds
    if (current_time - last_alarm_check < 5000) {
        return;
    }
    last_alarm_check = current_time;
    
    // Get current sensor readings
    float o2 = sensorManager->getO2Percent();
    float co2 = sensorManager->getCO2PPM();
    
    // Check O2 alarms
    float o2_min = settingsManager->getO2MinAlarm();
    float o2_max = settingsManager->getO2MaxAlarm();
    
    if (o2 < o2_min || o2 > o2_max) {
        // TODO: Trigger O2 alarm
        Serial.printf("ALARM: O2 %.1f%% (range: %.1f%% - %.1f%%)\n", o2, o2_min, o2_max);
    }
    
    // Check CO2 alarm
    float co2_max = settingsManager->getCO2MaxAlarm();
    
    if (co2 > co2_max) {
        // TODO: Trigger CO2 alarm
        Serial.printf("ALARM: CO2 %.0f ppm (max: %.0f ppm)\n", co2, co2_max);
    }
}

void TrimixApp::handleSystemTasks() {
    static unsigned long last_system_check = 0;
    unsigned long current_time = millis();
    
    // System tasks every 10 seconds
    if (current_time - last_system_check < 10000) {
        return;
    }
    last_system_check = current_time;
    
    // Check free memory
    size_t free_heap = ESP.getFreeHeap();
    if (free_heap < 50000) { // Less than 50KB free
        Serial.printf("WARNING: Low memory - %d bytes free\n", free_heap);
    }
    
    // Check WiFi status
    if (settingsManager->getWiFiEnabled()) {
        // WiFi status is checked in main.cpp
    }
    
    // Update screen brightness if changed
    static uint8_t last_brightness = 255;
    uint8_t current_brightness = settingsManager->getBrightness();
    if (current_brightness != last_brightness) {
        displayManager->setBrightness(current_brightness);
        last_brightness = current_brightness;
    }
}