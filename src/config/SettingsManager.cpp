/*
 * SettingsManager.cpp
 * Implementation of persistent settings for ESP32-S3 Trimix Analyzer
 */

#include "config/SettingsManager.h"

// Static constants
const char* SettingsManager::PREF_NAMESPACE = "trimix";
const float SettingsManager::DEFAULT_O2_CALIBRATION = 0.0095f;
const float SettingsManager::DEFAULT_CO2_ZERO_CALIBRATION = 0.0f;
const float SettingsManager::DEFAULT_CO2_SPAN_CALIBRATION = 3.3f;
const float SettingsManager::DEFAULT_O2_MIN_ALARM = 16.0f;
const float SettingsManager::DEFAULT_O2_MAX_ALARM = 23.0f;
const float SettingsManager::DEFAULT_CO2_MAX_ALARM = 1000.0f;

SettingsManager::SettingsManager() {
    // Constructor
}

SettingsManager::~SettingsManager() {
    prefs.end();
}

bool SettingsManager::begin() {
    Serial.println("SettingsManager: Initializing settings...");
    
    if (!prefs.begin(PREF_NAMESPACE, false)) {
        Serial.println("SettingsManager: Failed to initialize preferences");
        return false;
    }
    
    // Check if this is first run
    if (getFirstRun()) {
        Serial.println("SettingsManager: First run detected, loading defaults");
        loadDefaults();
        setFirstRun(false);
    }
    
    Serial.println("SettingsManager: Settings initialized successfully");
    return true;
}

void SettingsManager::reset() {
    Serial.println("SettingsManager: Resetting all settings to defaults");
    prefs.clear();
    loadDefaults();
    setFirstRun(false);
}

// WiFi settings
bool SettingsManager::getWiFiEnabled() const {
    return getBool("wifi_enabled", DEFAULT_WIFI_ENABLED);
}

void SettingsManager::setWiFiEnabled(bool enabled) {
    setBool("wifi_enabled", enabled);
}

String SettingsManager::getWiFiSSID() const {
    return getString("wifi_ssid");
}

void SettingsManager::setWiFiSSID(const String& ssid) {
    setString("wifi_ssid", ssid);
}

String SettingsManager::getWiFiPassword() const {
    return getString("wifi_pass");
}

void SettingsManager::setWiFiPassword(const String& password) {
    setString("wifi_pass", password);
}

// Display settings
uint8_t SettingsManager::getBrightness() const {
    return getUInt8("brightness", DEFAULT_BRIGHTNESS);
}

void SettingsManager::setBrightness(uint8_t brightness) {
    setUInt8("brightness", brightness);
}

bool SettingsManager::getAutoSleep() const {
    return getBool("auto_sleep", DEFAULT_AUTO_SLEEP);
}

void SettingsManager::setAutoSleep(bool enabled) {
    setBool("auto_sleep", enabled);
}

uint16_t SettingsManager::getSleepTimeout() const {
    return getUInt16("sleep_timeout", DEFAULT_SLEEP_TIMEOUT);
}

void SettingsManager::setSleepTimeout(uint16_t minutes) {
    setUInt16("sleep_timeout", minutes);
}

// Sensor settings
float SettingsManager::getO2Calibration() const {
    return getFloat("o2_calib", DEFAULT_O2_CALIBRATION);
}

void SettingsManager::setO2Calibration(float airVoltage) {
    setFloat("o2_calib", airVoltage);
}

float SettingsManager::getCO2ZeroCalibration() const {
    return getFloat("co2_zero", DEFAULT_CO2_ZERO_CALIBRATION);
}

void SettingsManager::setCO2ZeroCalibration(float zeroVoltage) {
    setFloat("co2_zero", zeroVoltage);
}

float SettingsManager::getCO2SpanCalibration() const {
    return getFloat("co2_span", DEFAULT_CO2_SPAN_CALIBRATION);
}

void SettingsManager::setCO2SpanCalibration(float spanVoltage) {
    setFloat("co2_span", spanVoltage);
}

uint16_t SettingsManager::getSensorUpdateInterval() const {
    return getUInt16("sensor_interval", DEFAULT_SENSOR_INTERVAL);
}

void SettingsManager::setSensorUpdateInterval(uint16_t interval) {
    setUInt16("sensor_interval", interval);
}

// Safety settings
float SettingsManager::getO2MinAlarm() const {
    return getFloat("o2_min_alarm", DEFAULT_O2_MIN_ALARM);
}

void SettingsManager::setO2MinAlarm(float percent) {
    setFloat("o2_min_alarm", percent);
}

float SettingsManager::getO2MaxAlarm() const {
    return getFloat("o2_max_alarm", DEFAULT_O2_MAX_ALARM);
}

void SettingsManager::setO2MaxAlarm(float percent) {
    setFloat("o2_max_alarm", percent);
}

float SettingsManager::getCO2MaxAlarm() const {
    return getFloat("co2_max_alarm", DEFAULT_CO2_MAX_ALARM);
}

void SettingsManager::setCO2MaxAlarm(float ppm) {
    setFloat("co2_max_alarm", ppm);
}

bool SettingsManager::getAlarmsEnabled() const {
    return getBool("alarms_enabled", DEFAULT_ALARMS_ENABLED);
}

void SettingsManager::setAlarmsEnabled(bool enabled) {
    setBool("alarms_enabled", enabled);
}

// System settings
String SettingsManager::getDeviceName() const {
    return getString("device_name", "Trimix Analyzer");
}

void SettingsManager::setDeviceName(const String& name) {
    setString("device_name", name);
}

bool SettingsManager::getFirstRun() const {
    return getBool("first_run", true);
}

void SettingsManager::setFirstRun(bool firstRun) {
    setBool("first_run", firstRun);
}

unsigned long SettingsManager::getLastCalibration() const {
    return getULong("last_calib", 0);
}

void SettingsManager::setLastCalibration(unsigned long timestamp) {
    setULong("last_calib", timestamp);
}

// Utility functions
void SettingsManager::saveAll() {
    // ESP32 Preferences auto-saves, but this can be used to force commit
    Serial.println("SettingsManager: All settings saved");
}

void SettingsManager::loadDefaults() {
    Serial.println("SettingsManager: Loading default settings");
    
    // WiFi defaults
    setWiFiEnabled(DEFAULT_WIFI_ENABLED);
    setWiFiSSID("");
    setWiFiPassword("");
    
    // Display defaults
    setBrightness(DEFAULT_BRIGHTNESS);
    setAutoSleep(DEFAULT_AUTO_SLEEP);
    setSleepTimeout(DEFAULT_SLEEP_TIMEOUT);
    
    // Sensor defaults
    setO2Calibration(DEFAULT_O2_CALIBRATION);
    setCO2ZeroCalibration(DEFAULT_CO2_ZERO_CALIBRATION);
    setCO2SpanCalibration(DEFAULT_CO2_SPAN_CALIBRATION);
    setSensorUpdateInterval(DEFAULT_SENSOR_INTERVAL);
    
    // Safety defaults
    setO2MinAlarm(DEFAULT_O2_MIN_ALARM);
    setO2MaxAlarm(DEFAULT_O2_MAX_ALARM);
    setCO2MaxAlarm(DEFAULT_CO2_MAX_ALARM);
    setAlarmsEnabled(DEFAULT_ALARMS_ENABLED);
    
    // System defaults
    setDeviceName("Trimix Analyzer");
    setLastCalibration(0);
}

void SettingsManager::printAllSettings() {
    Serial.println("=== Current Settings ===");
    Serial.printf("WiFi Enabled: %s\n", getWiFiEnabled() ? "Yes" : "No");
    Serial.printf("WiFi SSID: %s\n", getWiFiSSID().c_str());
    Serial.printf("Brightness: %d\n", getBrightness());
    Serial.printf("Auto Sleep: %s\n", getAutoSleep() ? "Yes" : "No");
    Serial.printf("Sleep Timeout: %d min\n", getSleepTimeout());
    Serial.printf("O2 Calibration: %.6f V\n", getO2Calibration());
    Serial.printf("CO2 Zero: %.3f V\n", getCO2ZeroCalibration());
    Serial.printf("CO2 Span: %.3f V\n", getCO2SpanCalibration());
    Serial.printf("Sensor Interval: %d ms\n", getSensorUpdateInterval());
    Serial.printf("O2 Min Alarm: %.1f%%\n", getO2MinAlarm());
    Serial.printf("O2 Max Alarm: %.1f%%\n", getO2MaxAlarm());
    Serial.printf("CO2 Max Alarm: %.0f ppm\n", getCO2MaxAlarm());
    Serial.printf("Alarms Enabled: %s\n", getAlarmsEnabled() ? "Yes" : "No");
    Serial.printf("Device Name: %s\n", getDeviceName().c_str());
    Serial.println("========================");
}

// Helper methods
String SettingsManager::getString(const char* key, const String& defaultValue) const {
    return prefs.getString(key, defaultValue);
}

bool SettingsManager::getBool(const char* key, bool defaultValue) const {
    return prefs.getBool(key, defaultValue);
}

float SettingsManager::getFloat(const char* key, float defaultValue) const {
    return prefs.getFloat(key, defaultValue);
}

uint8_t SettingsManager::getUInt8(const char* key, uint8_t defaultValue) const {
    return prefs.getUChar(key, defaultValue);
}

uint16_t SettingsManager::getUInt16(const char* key, uint16_t defaultValue) const {
    return prefs.getUShort(key, defaultValue);
}

unsigned long SettingsManager::getULong(const char* key, unsigned long defaultValue) const {
    return prefs.getULong(key, defaultValue);
}

void SettingsManager::setString(const char* key, const String& value) {
    prefs.putString(key, value);
}

void SettingsManager::setBool(const char* key, bool value) {
    prefs.putBool(key, value);
}

void SettingsManager::setFloat(const char* key, float value) {
    prefs.putFloat(key, value);
}

void SettingsManager::setUInt8(const char* key, uint8_t value) {
    prefs.putUChar(key, value);
}

void SettingsManager::setUInt16(const char* key, uint16_t value) {
    prefs.putUShort(key, value);
}

void SettingsManager::setULong(const char* key, unsigned long value) {
    prefs.putULong(key, value);
}