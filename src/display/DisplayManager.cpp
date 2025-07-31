/*
 * DisplayManager.cpp 
 * Implementation of display management for ESP32-S3 Trimix Analyzer
 */

#include "display/DisplayManager.h"

// Static instance pointer for callbacks
DisplayManager* DisplayManager::instance = nullptr;

DisplayManager::DisplayManager() :
    touch(nullptr),
    display(nullptr),
    touch_indev(nullptr),
    display_buffer1(nullptr),
    display_buffer2(nullptr),
    current_brightness(128)
{
    instance = this;
}

DisplayManager::~DisplayManager() {
    if (display_buffer1) free(display_buffer1);
    if (display_buffer2) free(display_buffer2);
    if (touch) delete touch;
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
    // Update LVGL (handles display refresh and input)
    lv_timer_handler();
}

bool DisplayManager::initializeDisplay() {
    // Initialize TFT display
    tft.init();
    tft.setRotation(1); // Landscape orientation for 800x480
    tft.fillScreen(TFT_BLACK);
    
    Serial.println("DisplayManager: TFT display initialized");
    return true;
}

bool DisplayManager::initializeTouch() {
#ifdef TOUCH_ENABLED
    // Initialize touch controller
    touch = new XPT2046_Touchscreen(TOUCH_CS_PIN, TOUCH_IRQ_PIN);
    
    if (!touch->begin()) {
        Serial.println("DisplayManager: Touch controller initialization failed");
        return false;
    }
    
    Serial.println("DisplayManager: Touch controller initialized");
    return true;
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
    if (touch) {
        lv_indev_drv_init(&touch_driver);
        touch_driver.type = LV_INDEV_TYPE_POINTER;
        touch_driver.read_cb = touchRead;
        
        touch_indev = lv_indev_drv_register(&touch_driver);
        if (!touch_indev) {
            Serial.println("DisplayManager: Failed to register touch driver");
            return false;
        }
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
    if (!instance || !instance->touch) {
        data->state = LV_INDEV_STATE_REL;
        return;
    }
    
    // Check if touch is pressed
    if (instance->touch->touched()) {
        TS_Point point = instance->touch->getPoint();
        
        // Map touch coordinates to display coordinates
        // Note: This mapping may need adjustment based on your specific touch controller
        data->point.x = map(point.x, 200, 3700, 0, DISPLAY_WIDTH);
        data->point.y = map(point.y, 200, 3700, 0, DISPLAY_HEIGHT);
        data->state = LV_INDEV_STATE_PR;
        
        // Debug output (can be removed in production)
        static unsigned long last_debug = 0;
        if (millis() - last_debug > 500) {
            Serial.printf("Touch: (%d,%d) -> (%d,%d)\n", 
                         point.x, point.y, data->point.x, data->point.y);
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
    return touch && touch->touched();
}

void DisplayManager::getTouchPosition(int16_t* x, int16_t* y) {
    if (touch && touch->touched()) {
        TS_Point point = touch->getPoint();
        *x = map(point.x, 200, 3700, 0, DISPLAY_WIDTH);
        *y = map(point.y, 200, 3700, 0, DISPLAY_HEIGHT);
    } else {
        *x = -1;
        *y = -1;
    }
}