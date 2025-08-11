/*
 * SettingsManager.h
 * Manages persistent settings for ESP32-S3 Trimix Analyzer
 */

#ifndef SETTINGS_MANAGER_H
#define SETTINGS_MANAGER_H

#include <Arduino.h>
#include <Preferences.h>

class SettingsManager {
public:
    SettingsManager();
    ~SettingsManager();
    
    bool begin();
    void reset();
    
    // WiFi settings
    bool getWiFiEnabled() const;
    void setWiFiEnabled(bool enabled);
    String getWiFiSSID() const;
    void setWiFiSSID(const String& ssid);
    String getWiFiPassword() const;
    void setWiFiPassword(const String& password);
    
    // Display settings
    uint8_t getBrightness() const;
    void setBrightness(uint8_t brightness);
    bool getAutoSleep() const;
    void setAutoSleep(bool enabled);
    uint16_t getSleepTimeout() const; // minutes
    void setSleepTimeout(uint16_t minutes);
    
    // Sensor settings
    float getO2Calibration() const;
    void setO2Calibration(float airVoltage);
    float getCO2ZeroCalibration() const;
    void setCO2ZeroCalibration(float zeroVoltage);
    float getCO2SpanCalibration() const;
    void setCO2SpanCalibration(float spanVoltage);
    uint16_t getSensorUpdateInterval() const; // milliseconds
    void setSensorUpdateInterval(uint16_t interval);
    
    // Safety settings
    float getO2MinAlarm() const;
    void setO2MinAlarm(float percent);
    float getO2MaxAlarm() const;
    void setO2MaxAlarm(float percent);
    float getCO2MaxAlarm() const;
    void setCO2MaxAlarm(float ppm);
    bool getAlarmsEnabled() const;
    void setAlarmsEnabled(bool enabled);
    
    // System settings
    String getDeviceName() const;
    void setDeviceName(const String& name);
    bool getFirstRun() const;
    void setFirstRun(bool firstRun);
    unsigned long getLastCalibration() const; // timestamp
    void setLastCalibration(unsigned long timestamp);
    
    // Utility functions
    void saveAll();
    void loadDefaults();
    void printAllSettings();

private:
    mutable Preferences prefs;
    
    // Default values
    static const char* PREF_NAMESPACE;
    static const bool DEFAULT_WIFI_ENABLED = false;
    static const uint8_t DEFAULT_BRIGHTNESS = 128;
    static const bool DEFAULT_AUTO_SLEEP = true;
    static const uint16_t DEFAULT_SLEEP_TIMEOUT = 30; // minutes
    static const float DEFAULT_O2_CALIBRATION;
    static const float DEFAULT_CO2_ZERO_CALIBRATION;
    static const float DEFAULT_CO2_SPAN_CALIBRATION;
    static const uint16_t DEFAULT_SENSOR_INTERVAL = 2000; // ms
    static const float DEFAULT_O2_MIN_ALARM;
    static const float DEFAULT_O2_MAX_ALARM;
    static const float DEFAULT_CO2_MAX_ALARM;
    static const bool DEFAULT_ALARMS_ENABLED = true;
    
    // Helper methods
    String getString(const char* key, const String& defaultValue = "") const;
    bool getBool(const char* key, bool defaultValue = false) const;
    float getFloat(const char* key, float defaultValue = 0.0f) const;
    uint8_t getUInt8(const char* key, uint8_t defaultValue = 0) const;
    uint16_t getUInt16(const char* key, uint16_t defaultValue = 0) const;
    unsigned long getULong(const char* key, unsigned long defaultValue = 0) const;
    
    void setString(const char* key, const String& value);
    void setBool(const char* key, bool value);
    void setFloat(const char* key, float value);
    void setUInt8(const char* key, uint8_t value);
    void setUInt16(const char* key, uint16_t value);
    void setULong(const char* key, unsigned long value);
};

#endif // SETTINGS_MANAGER_H