#ifndef MAIN_H
#define MAIN_H

#include "arduino_compat.h"
#ifdef NATIVE_BUILD
// Native build stubs
#include <cstdint>

// WiFi stub types
typedef enum {
    WIFI_AUTH_OPEN = 0,
    WIFI_AUTH_WPA_PSK,
    WIFI_AUTH_WPA2_PSK,
    WIFI_AUTH_WPA_WPA2_PSK,
    WIFI_AUTH_WPA2_ENTERPRISE,
    WIFI_AUTH_WPA3_PSK,
    WIFI_AUTH_WPA2_WPA3_PSK,
    WIFI_AUTH_WAPI_PSK,
    WIFI_AUTH_MAX
} wifi_auth_mode_t;

typedef enum {
    WL_IDLE_STATUS = 0,
    WL_NO_SSID_AVAIL,
    WL_SCAN_COMPLETED,
    WL_CONNECTED,
    WL_CONNECT_FAILED,
    WL_CONNECTION_LOST,
    WL_DISCONNECTED
} wl_status_t;

#define WIFI_SCAN_RUNNING -1
#define WIFI_SCAN_FAILED -2

// WiFi stub class
class WiFiClass {
public:
    void mode(int mode) {}
    void begin(const char* ssid, const char* password) {}
    void disconnect() {}
    int scanNetworks() { return 0; }
    int scanNetworks(bool async) { return 0; }
    bool scanComplete() { return true; }
    String SSID() { return "TestNetwork"; }
    String SSID(int i) { return ""; }
    int RSSI(int i) { return -50; }
    int encryptionType(int i) { return WIFI_AUTH_OPEN; }
    wl_status_t status() { return WL_DISCONNECTED; }
    String localIP() { return "0.0.0.0"; }
    bool isConnected() { return false; }
    void scanDelete() {}
};

extern WiFiClass WiFi;

// TFT_eSPI stub
class TFT_eSPI {
public:
    void init() {}
    void setRotation(uint8_t r) {}
    void fillScreen(uint16_t color) {}
    void drawString(const char* string, int x, int y) {}
    void setTextColor(uint16_t color) {}
    void setTextSize(uint8_t size) {}
    int16_t width() { return 240; }
    int16_t height() { return 320; }
};

extern TFT_eSPI tft;

#else
// Arduino build - include real dependencies
#include <Arduino.h>
#include <TFT_eSPI.h>
#include <SPI.h>
#include <Wire.h>
#include <WiFi.h>
#endif

#include <lvgl.h>

// Display configuration
#define SCREEN_WIDTH 240
#define SCREEN_HEIGHT 320
#define LVGL_TICK_PERIOD 60

// Forward declarations
class ScreenManager;
class HomeScreen;
class AnalyzeScreen;
class SensorInterface;

// Global objects
extern ScreenManager* screenManager;
extern SensorInterface* sensorInterface;

// Function declarations
void setup();
void loop();

#ifndef NATIVE_BUILD
// These functions use LVGL types that may vary between versions
void my_disp_flush(lv_disp_drv_t *disp, const lv_area_t *area, lv_color_t *color_p);
void my_touchpad_read(lv_indev_drv_t *indev_driver, lv_indev_data_t *data);
#endif

#endif // MAIN_H
