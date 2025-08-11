/*
 * DisplayManager.cpp 
 * Implementation of display management for ESP32-S3 Trimix Analyzer
 * Optimized for ESP32-8048S043 development board with Arduino_GFX
 */

#include "display/DisplayManager.h"
#include <Wire.h>

// Static instance pointer for callbacks
DisplayManager* DisplayManager::instance = nullptr;

DisplayManager::DisplayManager() :
    rgbpanel(nullptr),
    gfx(nullptr),
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
    
    // Inform LVGL about elapsed time and handle tasks
    unsigned long now = millis();
    if (last_tick_ms == 0) last_tick_ms = now;
    uint32_t diff = (uint32_t)(now - last_tick_ms);
    if (diff > 0) {
        lv_tick_inc(diff);
        last_tick_ms = now;
    }
    lv_timer_handler();
}

bool DisplayManager::initializeDisplay() {
    Serial.println("DisplayManager: Attempting Arduino_GFX RGB display initialization...");
    
    try {
        // Initialize RGB panel for ESP32-8048S043
        // Use known-good timing for ESP32-8048S043 (RGB666 panels often work with these)
        rgbpanel = new Arduino_ESP32RGBPanel(
            40 /* DE */, 41 /* VSYNC */, 39 /* HSYNC */, 42 /* PCLK */,
            45 /* R0 */, 48 /* R1 */, 47 /* R2 */, 21 /* R3 */, 14 /* R4 */,
            5 /* G0 */, 6 /* G1 */, 7 /* G2 */, 15 /* G3 */, 16 /* G4 */, 4 /* G5 */,
            8 /* B0 */, 3 /* B1 */, 46 /* B2 */, 9 /* B3 */, 1 /* B4 */,
            0 /* hsync_polarity */, 8 /* hsync_front_porch */, 4 /* hsync_pulse_width */, 44 /* hsync_back_porch */,
            0 /* vsync_polarity */, 8 /* vsync_front_porch */, 4 /* vsync_pulse_width */, 16 /* vsync_back_porch */,
            0 /* pclk_active_neg */, 18000000 /* prefer_speed */, false /* auto_flush: LVGL drives flush */
        );
        
        // Initialize display with RGB panel
        gfx = new Arduino_RGB_Display(DISPLAY_WIDTH, DISPLAY_HEIGHT, rgbpanel);
        
    // Initialize display
    if (!gfx->begin()) {
            Serial.println("DisplayManager: ERROR - Arduino_GFX initialization failed");
            return false;
        }
        
    // Clear screen
    gfx->fillScreen(BLACK);
        
        // Initialize backlight
        pinMode(TFT_BL, OUTPUT);
        digitalWrite(TFT_BL, HIGH); // Turn on backlight
        
        Serial.println("DisplayManager: Arduino_GFX RGB display initialized successfully");
        return true;
    } catch (...) {
        Serial.println("DisplayManager: Display initialization failed, but continuing...");
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
    size_t buffer_size = (DISPLAY_WIDTH * DISPLAY_HEIGHT) / 10;
    
    // Allocate display buffers
    display_buffer1 = (lv_color_t*)heap_caps_malloc(buffer_size * sizeof(lv_color_t), MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);
    display_buffer2 = (lv_color_t*)heap_caps_malloc(buffer_size * sizeof(lv_color_t), MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);
    
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
    if (!instance || !instance->gfx) return;
    
    uint32_t w = (area->x2 - area->x1 + 1);
    uint32_t h = (area->y2 - area->y1 + 1);
    // Draw the area directly
    instance->gfx->draw16bitRGBBitmap(area->x1, area->y1, (uint16_t*)color_p, w, h);
    
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
    
    Wire1.requestFrom((uint16_t)TOUCH_I2C_ADDR, (uint8_t)len);
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