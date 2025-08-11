/*
 * DisplayManager.h
 * Manages LVGL display and touch for ESP32-S3 Trimix Analyzer
 * Optimized for ESP32-8048S043 development board with Arduino_GFX
 */

#ifndef DISPLAY_MANAGER_H
#define DISPLAY_MANAGER_H

#include <Arduino.h>
#include <lvgl.h>
#include <esp_heap_caps.h>

// Use Arduino_GFX for ESP32-8048S043 RGB LCD support
#include <Arduino_GFX_Library.h>

// Display configuration
#ifndef DISPLAY_WIDTH
#define DISPLAY_WIDTH 800
#endif

#ifndef DISPLAY_HEIGHT  
#define DISPLAY_HEIGHT 480
#endif

// Touch configuration for ESP32-8048S043
// This board typically uses I2C touch controllers like GT911 or FT6336
#define TOUCH_I2C_SDA 19
#define TOUCH_I2C_SCL 20
#define TOUCH_I2C_INT 0      // Changed from 40 to avoid conflict with TFT_DE
#define TOUCH_I2C_RST 38
#define TOUCH_I2C_ADDR 0x5D  // GT911 default address

// ESP32-8048S043 RGB LCD pin definitions
#define TFT_BL 2   // Backlight control

class DisplayManager {
public:
    DisplayManager();
    ~DisplayManager();
    
    bool begin();
    void update();
    
    // Display control
    void setBrightness(uint8_t brightness);
    uint8_t getBrightness() const { return current_brightness; }
    
    // LVGL integration
    lv_disp_t* getDisplay() const { return display; }
    lv_indev_t* getTouchDevice() const { return touch_indev; }
    
    // Screen management
    void setActiveScreen(lv_obj_t* screen);
    lv_obj_t* getActiveScreen() const;
    
    // Utility functions
    bool isTouchPressed() const;
    void getTouchPosition(int16_t* x, int16_t* y);

private:
    // Hardware - Arduino_GFX for ESP32-8048S043 RGB LCD
    Arduino_ESP32RGBPanel *rgbpanel;
    Arduino_RGB_Display *gfx;
    
    // LVGL objects
    lv_disp_t* display;
    lv_indev_t* touch_indev;
    lv_disp_drv_t display_driver;
    lv_indev_drv_t touch_driver;
    
    // Display buffers
    lv_color_t* display_buffer1;
    lv_color_t* display_buffer2;
    lv_disp_draw_buf_t display_buf;
    
    // Touch state
    bool touch_pressed;
    int16_t touch_x, touch_y;
    
    // Settings
    uint8_t current_brightness;
    unsigned long last_tick_ms = 0;
    
    // Private methods
    bool initializeDisplay();
    bool initializeTouch();
    bool initializeLVGL();
    
    // Touch I2C methods
    bool touchI2CWrite(uint8_t reg, uint8_t* data, uint8_t len);
    bool touchI2CRead(uint8_t reg, uint8_t* data, uint8_t len);
    void updateTouch();
    
    // LVGL callback functions (static)
    static void displayFlush(lv_disp_drv_t* disp, const lv_area_t* area, lv_color_t* color_p);
    static void touchRead(lv_indev_drv_t* drv, lv_indev_data_t* data);
    
    // Instance pointer for static callbacks
    static DisplayManager* instance;
};

#endif // DISPLAY_MANAGER_H