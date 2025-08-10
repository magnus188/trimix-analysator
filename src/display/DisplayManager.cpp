/*
 * DisplayManager.cpp 
 * Implementation of display management for ESP32-S3 Trimix Analyzer
 * Optimized for ESP32-8048S043 development board
 */

#include "display/DisplayManager.h"
#include <Wire.h>

// Static instance pointer for callbacks
DisplayManager* DisplayManager::instance = nullptr;

DisplayManager::DisplayManager() :
    display(nullptr),
    touch_indev(nullptr),
    display_buffer1(nullptr),
    display_buffer2(nullptr),
    touch_pressed(false),
    touch_x(0),
    touch_y(0),
    current_brightness(128)
{
    instance = this;
}

DisplayManager::~DisplayManager() {
    if (display_buffer1) free(display_buffer1);
    if (display_buffer2) free(display_buffer2);
    instance = nullptr;
}

bool DisplayManager::begin() {
    Serial.println("DisplayManager: Initializing display system...");
    
    // Initialize LVGL first
    lv_init();
    Serial.println("DisplayManager: LVGL initialized");
    
    // Initialize display hardware
    if (!initializeDisplay()) {
        Serial.println("DisplayManager: ERROR - Failed to initialize display");
        return false;
    }
    
    // Initialize touch hardware
    if (!initializeTouch()) {
        Serial.println("DisplayManager: WARNING - Failed to initialize touch (continuing without touch)");
        // Continue without touch for debugging
    }
    
    // Setup LVGL integration
    if (!initializeLVGL()) {
        Serial.println("DisplayManager: ERROR - Failed to initialize LVGL integration");
        return false;
    }
    
    Serial.printf("DisplayManager: Initialized successfully - %dx%d display\n", 
                  DISPLAY_WIDTH, DISPLAY_HEIGHT);
    
    return true;
}

void DisplayManager::update() {
    // Update touch state
    updateTouch();
    
    // Update LVGL (handles display refresh and input)
    lv_timer_handler();
}

bool DisplayManager::initializeDisplay() {
    Serial.println("DisplayManager: Attempting TFT display initialization...");
    
    try {
        // Initialize TFT display
        tft.init();
        tft.setRotation(1); // Landscape orientation for 800x480
        tft.fillScreen(TFT_BLACK);
        
        Serial.println("DisplayManager: TFT display initialized successfully");
        return true;
    } catch (...) {
        Serial.println("DisplayManager: TFT initialization failed, but continuing...");
        return true; // Continue anyway for development
    }
}

bool DisplayManager::initializeTouch() {
#ifdef TOUCH_ENABLED
    Serial.println("DisplayManager: Attempting touch controller initialization...");
    
    try {
        // Initialize I2C for touch controller
        Wire1.begin(TOUCH_I2C_SDA, TOUCH_I2C_SCL);
        Wire1.setClock(400000); // 400kHz
        
        // Initialize touch controller pins if they exist
        pinMode(TOUCH_I2C_RST, OUTPUT);
        pinMode(TOUCH_I2C_INT, INPUT);
        
        // Reset touch controller
        digitalWrite(TOUCH_I2C_RST, LOW);
        delay(10);
        digitalWrite(TOUCH_I2C_RST, HIGH);
        delay(10);
        
        // Try to detect touch controller
        Wire1.beginTransmission(TOUCH_I2C_ADDR);
        if (Wire1.endTransmission() == 0) {
            Serial.println("DisplayManager: I2C touch controller detected and initialized");
            return true;
        } else {
            Serial.println("DisplayManager: No I2C touch controller found - continuing without touch for development");
            return true; // Continue without touch
        }
    } catch (...) {
        Serial.println("DisplayManager: Touch initialization failed - continuing without touch for development");
        return true; // Continue without touch
    }
#else
    Serial.println("DisplayManager: Touch disabled in build configuration");
    return true;
#endif
}

bool DisplayManager::initializeLVGL() {
    // Calculate buffer size (1/10 of screen for good performance)
    size_t buffer_size = DISPLAY_WIDTH * DISPLAY_HEIGHT / 10;
    
    // Allocate display buffers
    display_buffer1 = (lv_color_t*)heap_caps_malloc(buffer_size * sizeof(lv_color_t), MALLOC_CAP_DMA);
    display_buffer2 = (lv_color_t*)heap_caps_malloc(buffer_size * sizeof(lv_color_t), MALLOC_CAP_DMA);
    
    if (!display_buffer1 || !display_buffer2) {
        Serial.println("DisplayManager: Failed to allocate display buffers");
        return false;
    }
    
    // Initialize display buffer
    lv_disp_draw_buf_init(&display_buf, display_buffer1, display_buffer2, buffer_size);
    
    // Initialize display driver
    lv_disp_drv_init(&display_driver);
    display_driver.hor_res = DISPLAY_WIDTH;
    display_driver.ver_res = DISPLAY_HEIGHT;
    display_driver.flush_cb = displayFlush;
    display_driver.draw_buf = &display_buf;
    display_driver.full_refresh = 0; // Enable partial refresh for better performance
    
    // Register display driver
    display = lv_disp_drv_register(&display_driver);
    if (!display) {
        Serial.println("DisplayManager: Failed to register display driver");
        return false;
    }
    
    // Initialize touch driver if touch is available
    // For this implementation, we always try to register touch driver
    // The actual touch detection happens in the read callback
    lv_indev_drv_init(&touch_driver);
    touch_driver.type = LV_INDEV_TYPE_POINTER;
    touch_driver.read_cb = touchRead;
    
    touch_indev = lv_indev_drv_register(&touch_driver);
    if (!touch_indev) {
        Serial.println("DisplayManager: Failed to register touch driver");
        return false;
    }
    
    Serial.printf("DisplayManager: LVGL integration complete - Buffer size: %d pixels\n", buffer_size);
    return true;
}

void DisplayManager::displayFlush(lv_disp_drv_t* disp, const lv_area_t* area, lv_color_t* color_p) {
    if (!instance) return;
    
    uint32_t w = (area->x2 - area->x1 + 1);
    uint32_t h = (area->y2 - area->y1 + 1);
    
    // Set window for writing
    instance->tft.setAddrWindow(area->x1, area->y1, w, h);
    
    // Push color data to display
    instance->tft.pushColors((uint16_t*)color_p, w * h, true);
    
    // Tell LVGL that flush is complete
    lv_disp_flush_ready(disp);
}

void DisplayManager::touchRead(lv_indev_drv_t* drv, lv_indev_data_t* data) {
    if (!instance) {
        data->state = LV_INDEV_STATE_REL;
        return;
    }
    
    // Update touch state from I2C controller
    instance->updateTouch();
    
    if (instance->touch_pressed) {
        data->point.x = instance->touch_x;
        data->point.y = instance->touch_y;
        data->state = LV_INDEV_STATE_PR;
        
        // Debug output (can be removed in production)
        static unsigned long last_debug = 0;
        if (millis() - last_debug > 500) {
            Serial.printf("Touch: (%d,%d)\n", data->point.x, data->point.y);
            last_debug = millis();
        }
    } else {
        data->state = LV_INDEV_STATE_REL;
    }
}

void DisplayManager::setBrightness(uint8_t brightness) {
    current_brightness = brightness;
    // Note: Backlight control implementation depends on your specific hardware
    // This might be PWM control of a backlight pin
    // For now, store the value for future use
    Serial.printf("DisplayManager: Brightness set to %d\n", brightness);
}

void DisplayManager::setActiveScreen(lv_obj_t* screen) {
    if (screen) {
        lv_scr_load(screen);
    }
}

lv_obj_t* DisplayManager::getActiveScreen() const {
    return lv_scr_act();
}

bool DisplayManager::isTouchPressed() const {
    return touch_pressed;
}

void DisplayManager::getTouchPosition(int16_t* x, int16_t* y) {
    if (touch_pressed) {
        *x = touch_x;
        *y = touch_y;
    } else {
        *x = -1;
        *y = -1;
    }
}

// I2C Touch Controller Methods
bool DisplayManager::touchI2CWrite(uint8_t reg, uint8_t* data, uint8_t len) {
    Wire1.beginTransmission(TOUCH_I2C_ADDR);
    Wire1.write(reg);
    for (uint8_t i = 0; i < len; i++) {
        Wire1.write(data[i]);
    }
    return Wire1.endTransmission() == 0;
}

bool DisplayManager::touchI2CRead(uint8_t reg, uint8_t* data, uint8_t len) {
    Wire1.beginTransmission(TOUCH_I2C_ADDR);
    Wire1.write(reg);
    if (Wire1.endTransmission() != 0) return false;
    
    Wire1.requestFrom(TOUCH_I2C_ADDR, len);
    for (uint8_t i = 0; i < len; i++) {
        if (Wire1.available()) {
            data[i] = Wire1.read();
        } else {
            return false;
        }
    }
    return true;
}

void DisplayManager::updateTouch() {
#ifdef TOUCH_ENABLED
    // Basic GT911-style touch reading
    uint8_t touch_data[8];
    
    // Read touch status register (0x814E for GT911)
    if (touchI2CRead(0x4E, touch_data, 1)) {
        uint8_t touch_count = touch_data[0] & 0x0F;
        
        if (touch_count > 0) {
            // Read first touch point data (0x8150 for GT911)
            if (touchI2CRead(0x50, touch_data, 8)) {
                uint16_t raw_x = (touch_data[1] << 8) | touch_data[0];
                uint16_t raw_y = (touch_data[3] << 8) | touch_data[2];
                
                // Map coordinates to display
                touch_x = map(raw_x, 0, 800, 0, DISPLAY_WIDTH);
                touch_y = map(raw_y, 0, 480, 0, DISPLAY_HEIGHT);
                touch_pressed = true;
            }
        } else {
            touch_pressed = false;
        }
        
        // Clear touch status (write 0 to status register)
        uint8_t clear = 0;
        touchI2CWrite(0x4E, &clear, 1);
    } else {
        touch_pressed = false;
    }
#else
    touch_pressed = false;
#endif
}