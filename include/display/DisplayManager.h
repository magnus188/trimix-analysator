/*
 * DisplayManager.h
 * Manages LVGL display and touch for ESP32-S3 Trimix Analyzer
 */

#ifndef DISPLAY_MANAGER_H
#define DISPLAY_MANAGER_H

#include <Arduino.h>
#include <lvgl.h>
#include <TFT_eSPI.h>
#include <XPT2046_Touchscreen.h>

// Display configuration
#ifndef DISPLAY_WIDTH
#define DISPLAY_WIDTH 800
#endif

#ifndef DISPLAY_HEIGHT  
#define DISPLAY_HEIGHT 480
#endif

// Touch pins (adjust for your specific board)
#define TOUCH_CS_PIN 21
#define TOUCH_IRQ_PIN 22

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
    // Hardware
    TFT_eSPI tft;
    XPT2046_Touchscreen* touch;
    
    // LVGL objects
    lv_disp_t* display;
    lv_indev_t* touch_indev;
    lv_disp_drv_t display_driver;
    lv_indev_drv_t touch_driver;
    
    // Display buffers
    lv_color_t* display_buffer1;
    lv_color_t* display_buffer2;
    lv_disp_draw_buf_t display_buf;
    
    // Settings
    uint8_t current_brightness;
    
    // Private methods
    bool initializeDisplay();
    bool initializeTouch();
    bool initializeLVGL();
    
    // LVGL callback functions (static)
    static void displayFlush(lv_disp_drv_t* disp, const lv_area_t* area, lv_color_t* color_p);
    static void touchRead(lv_indev_drv_t* drv, lv_indev_data_t* data);
    
    // Instance pointer for static callbacks
    static DisplayManager* instance;
};

#endif // DISPLAY_MANAGER_H