/*
 * TrimixApp.h
 * Main application class for ESP32-S3 Trimix Analyzer
 */

#ifndef TRIMIX_APP_H
#define TRIMIX_APP_H

#include <Arduino.h>
#include <lvgl.h>
#include "sensors/SensorManager.h"
#include "display/DisplayManager.h"
#include "config/SettingsManager.h"

// Forward declarations
class HomeScreen;
class AnalyzeScreen;
class SettingsScreen;

class TrimixApp {
public:
    TrimixApp(DisplayManager* display, SensorManager* sensors, SettingsManager* settings);
    ~TrimixApp();
    
    bool begin();
    void update();
    
    // Screen navigation
    void showHome();
    void showAnalyze();
    void showSettings();
    void showScreen(lv_obj_t* screen);
    
    // Getters for managers
    DisplayManager* getDisplayManager() const { return displayManager; }
    SensorManager* getSensorManager() const { return sensorManager; }
    SettingsManager* getSettingsManager() const { return settingsManager; }
    
    // Application state
    bool isScreenSaverActive() const { return screen_saver_active; }
    void wakeFromScreenSaver();

private:
    // Managers
    DisplayManager* displayManager;
    SensorManager* sensorManager;
    SettingsManager* settingsManager;
    
    // UI Screens
    HomeScreen* homeScreen;
    AnalyzeScreen* analyzeScreen;
    SettingsScreen* settingsScreen;
    
    // Screen saver
    bool screen_saver_active;
    unsigned long last_activity;
    unsigned long screen_saver_timeout;
    
    // Private methods
    void initializeScreens();
    void updateScreenSaver();
    void checkAlarms();
    void handleSystemTasks();
    
    // Static instance for global access
    static TrimixApp* instance;
    
public:
    // Static getter for global access
    static TrimixApp* getInstance() { return instance; }
};

#endif // TRIMIX_APP_H