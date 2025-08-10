/*
 * ESP32-S3 Trimix Analyzer
 * Main application entry point
 * 
 * Hardware: ESP32-8048S043 (4.3" 800x480 IPS Touch Display)
 * Sensors: ADS1115 ADC, BME280 environmental sensor, O2/CO2 analog sensors
 */

#include <Arduino.h>
#include <WiFi.h>
#include <Preferences.h>
#include <Wire.h>
#include <lvgl.h>
#include "TrimixApp.h"
#include "sensors/SensorManager.h"
#include "display/DisplayManager.h"
#include "config/SettingsManager.h"

// Version information
#define TRIMIX_VERSION "2.0.0-ESP32"
#define BUILD_DATE __DATE__
#define BUILD_TIME __TIME__

// Global managers
TrimixApp* app = nullptr;
SensorManager* sensorManager = nullptr;
DisplayManager* displayManager = nullptr;
SettingsManager* settingsManager = nullptr;

// Timing variables
unsigned long lastSensorUpdate = 0;
unsigned long lastDisplayUpdate = 0;
unsigned long lastWiFiCheck = 0;

const unsigned long SENSOR_UPDATE_INTERVAL = 2000;  // 2 seconds
const unsigned long DISPLAY_UPDATE_INTERVAL = 100;  // 100ms for smooth UI
const unsigned long WIFI_CHECK_INTERVAL = 30000;    // 30 seconds

void setup() {
    Serial.begin(115200);
    while (!Serial && millis() < 3000); // Wait up to 3 seconds for Serial
    
    Serial.println(F("==============================================="));
    Serial.println(F("ESP32-S3 Trimix Analyzer Starting..."));
    Serial.printf("Version: %s\n", TRIMIX_VERSION);
    Serial.printf("Build: %s %s\n", BUILD_DATE, BUILD_TIME);
    Serial.printf("Free heap: %d bytes\n", ESP.getFreeHeap());
    Serial.printf("PSRAM: %d bytes\n", ESP.getPsramSize());
    
#ifdef DEVELOPMENT_MODE
    Serial.println(F("*** DEVELOPMENT MODE ENABLED ***"));
    Serial.println(F("More robust initialization with fallbacks"));
#endif
    
    Serial.println(F("==============================================="));

    // Initialize Wire (I2C) early - use pins that don't conflict with TFT
    Wire.begin(I2C_SDA, I2C_SCL);
    Wire.setClock(400000); // 400kHz I2C speed
    Serial.printf("I2C initialized (SDA: %d, SCL: %d) - updated pins to avoid TFT conflicts\n", I2C_SDA, I2C_SCL);

    // Initialize managers in order
    Serial.println(F("Initializing settings manager..."));
    settingsManager = new SettingsManager();
    if (!settingsManager->begin()) {
        Serial.println(F("ERROR: Failed to initialize settings manager"));
#ifdef DEVELOPMENT_MODE
        Serial.println(F("DEVELOPMENT MODE: Continuing anyway..."));
#else
        return;
#endif
    }

    Serial.println(F("Initializing display manager..."));
    displayManager = new DisplayManager();
    if (!displayManager->begin()) {
        Serial.println(F("ERROR: Failed to initialize display manager"));
#ifdef DEVELOPMENT_MODE
        Serial.println(F("DEVELOPMENT MODE: Continuing anyway..."));
#else
        return;
#endif
    }

    Serial.println(F("Initializing sensor manager..."));
    sensorManager = new SensorManager();
    if (!sensorManager->begin()) {
        Serial.println(F("WARNING: Failed to initialize sensor manager - using mock sensors"));
        // Continue with mock sensors for development
    }

    Serial.println(F("Initializing main application..."));
    app = new TrimixApp(displayManager, sensorManager, settingsManager);
    if (!app->begin()) {
        Serial.println(F("ERROR: Failed to initialize main application"));
#ifdef DEVELOPMENT_MODE
        Serial.println(F("DEVELOPMENT MODE: Continuing anyway..."));
#else
        return;
#endif
    }

    // Initialize WiFi if enabled
    if (settingsManager->getWiFiEnabled()) {
        String ssid = settingsManager->getWiFiSSID();
        String password = settingsManager->getWiFiPassword();
        
        if (ssid.length() > 0) {
            Serial.printf("Connecting to WiFi: %s\n", ssid.c_str());
            WiFi.begin(ssid.c_str(), password.c_str());
            
            // Non-blocking WiFi connection attempt
            int attempts = 0;
            while (WiFi.status() != WL_CONNECTED && attempts < 20) {
                delay(500);
                Serial.print(".");
                attempts++;
            }
            
            if (WiFi.status() == WL_CONNECTED) {
                Serial.printf("\nWiFi connected! IP: %s\n", WiFi.localIP().toString().c_str());
            } else {
                Serial.println("\nWiFi connection failed, continuing without network");
            }
        }
    }

    Serial.println(F("Setup complete! Starting main loop..."));
    Serial.printf("Free heap after setup: %d bytes\n", ESP.getFreeHeap());
}

void loop() {
    unsigned long currentTime = millis();

    // Update display (high frequency for smooth UI)
    if (currentTime - lastDisplayUpdate >= DISPLAY_UPDATE_INTERVAL) {
        displayManager->update();
        lastDisplayUpdate = currentTime;
    }

    // Update sensors (lower frequency to avoid overwhelming)
    if (currentTime - lastSensorUpdate >= SENSOR_UPDATE_INTERVAL) {
        sensorManager->update();
        lastSensorUpdate = currentTime;
    }

    // Check WiFi status periodically
    if (currentTime - lastWiFiCheck >= WIFI_CHECK_INTERVAL) {
        if (settingsManager->getWiFiEnabled() && WiFi.status() != WL_CONNECTED) {
            String ssid = settingsManager->getWiFiSSID();
            if (ssid.length() > 0) {
                Serial.println("WiFi disconnected, attempting reconnection...");
                WiFi.reconnect();
            }
        }
        lastWiFiCheck = currentTime;
    }

    // Update main application
    app->update();

    // Small delay to prevent watchdog issues
    delay(1);
}