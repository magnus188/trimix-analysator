#include "lv_conf.h"
#include "screen_manager.h"
#include "home_screen.h"
#ifdef NATIVE_BUILD
// Only include working screens for native build
#include "settings_screen.h"
#include "history_screen.h"
#else
// Include all screens for Arduino build
#include "analyze_screen.h"
#include "calibration_screen.h"
#include "safety_settings_screen.h"
#include "wifi_settings_screen.h"
#include "update_settings_screen.h"
#include "sensor_interface.h"
#include "theme_manager.h"
#include "animation_manager.h"
#include "storage_manager.h"
#endif

#ifdef PIO_FRAMEWORK_ARDUINO // ESP32 build

#include <Arduino.h>
#include "TFT_eSPI.h"

// Global objects for ESP32
ScreenManager *screenManager = nullptr;
SensorInterface *sensorInterface = nullptr;
StorageManager *storageManager = nullptr;

// Display and input device drivers - Optimized for ESP32
static lv_disp_draw_buf_t draw_buf;
static lv_color_t buf1[SCREEN_WIDTH * 20]; // Increased buffer for better performance
static lv_color_t buf2[SCREEN_WIDTH * 20]; // Double buffering for smooth rendering
static lv_disp_drv_t disp_drv;
static lv_indev_drv_t indev_drv;

// TFT display object
static TFT_eSPI tft = TFT_eSPI();

// Performance monitoring
static unsigned long lastFrameTime = 0;
static unsigned int frameCount = 0;
static float avgFPS = 0.0f;

void setup()
{
    Serial.begin(115200);
    Serial.println("Trimix Analyzer ESP32 Starting...");

    // Initialize display
    tft.begin();
    tft.setRotation(1); // Landscape mode
    tft.fillScreen(TFT_BLACK);

    // Initialize LVGL
    lv_init();

    // Setup double-buffered display
    lv_disp_draw_buf_init(&draw_buf, buf1, buf2, SCREEN_WIDTH * 20);

    // Initialize display driver
    lv_disp_drv_init(&disp_drv);
    disp_drv.hor_res = SCREEN_WIDTH;
    disp_drv.ver_res = SCREEN_HEIGHT;
    disp_drv.flush_cb = my_disp_flush;
    disp_drv.draw_buf = &draw_buf;
    disp_drv.full_refresh = 0;
    disp_drv.direct_mode = 0;
    lv_disp_drv_register(&disp_drv);

    // Initialize input device (touch)
    lv_indev_drv_init(&indev_drv);
    indev_drv.type = LV_INDEV_TYPE_POINTER;
    indev_drv.read_cb = my_touchpad_read;
    lv_indev_drv_register(&indev_drv);

    // Initialize sensor interface
    sensorInterface = new SensorInterface();
    sensorInterface->init();

    // Initialize storage manager
    storageManager = new StorageManager();
    if (!storageManager->begin())
    {
        Serial.println("Failed to initialize storage manager");
    }

    // Initialize theme and animation systems
    ThemeManager::init();
    AnimationManager::init();

    // Initialize screen manager
    screenManager = new ScreenManager(storageManager);
    screenManager->init();

    // Create and add screens
    screenManager->addScreen("home", new HomeScreen(screenManager));
    screenManager->addScreen("analyze", new AnalyzeScreen(screenManager));
    screenManager->addScreen("history", new HistoryScreen(screenManager, storageManager));
    screenManager->addScreen("settings", new SettingsScreen(screenManager));
    screenManager->addScreen("calibration", new CalibrationScreen(screenManager));
    screenManager->addScreen("safety_settings", new SafetySettingsScreen(screenManager));
    screenManager->addScreen("wifi_settings", new WiFiSettingsScreen(screenManager, storageManager));
    screenManager->addScreen("update_settings", new UpdateSettingsScreen(screenManager, storageManager));

    // Set initial screen
    screenManager->setCurrentScreen("home");

    Serial.println("Setup complete!");
}

void loop()
{
    // Handle LVGL tasks
    lv_timer_handler();

    // FPS calculation
    frameCount++;
    unsigned long currentTime = millis();
    if (currentTime - lastFrameTime >= 1000)
    {
        avgFPS = frameCount * 1000.0f / (currentTime - lastFrameTime);
        frameCount = 0;
        lastFrameTime = currentTime;
        if (avgFPS < 30.0f)
        {
            Serial.printf("Performance warning: FPS=%.1f\n", avgFPS);
        }
    }

    // Maintain consistent timing
    static unsigned long lastLoopTime = 0;
    unsigned long loopDuration = currentTime - lastLoopTime;
    lastLoopTime = currentTime;
    if (loopDuration < 5)
    {
        delay(5 - loopDuration);
    }
    else
    {
        yield();
    }
}

void my_disp_flush(lv_disp_drv_t *disp, const lv_area_t *area, lv_color_t *color_p)
{
    uint32_t w = (area->x2 - area->x1 + 1);
    uint32_t h = (area->y2 - area->y1 + 1);
    tft.startWrite();
    tft.setAddrWindow(area->x1, area->y1, w, h);
    tft.pushColors((uint16_t *)&color_p->full, w * h, false);
    tft.endWrite();
    lv_disp_flush_ready(disp);
}

void my_touchpad_read(lv_indev_drv_t *indev_driver, lv_indev_data_t *data)
{
    uint16_t touchX, touchY;
    bool touched = tft.getTouch(&touchX, &touchY);
    if (touched)
    {
        data->state = LV_INDEV_STATE_PR;
        data->point.x = touchX;
        data->point.y = touchY;
    }
    else
    {
        data->state = LV_INDEV_STATE_REL;
    }
}

#else // Native simulator build

#include "lvgl.h"
#ifdef NATIVE_BUILD
#include <chrono>
#include <thread>
#endif

#ifdef NATIVE_BUILD
// Native build without SDL - just stub functions
inline void lv_sdl_init(int argc, char **argv) { 
    (void)argc; (void)argv; 
    // For native build, just use a minimal display buffer
    static lv_display_t * disp = lv_display_create(320, 240);
    static lv_draw_buf_t draw_buf;
    static uint8_t buf1[320 * 40];  // 1/6 buffer
    lv_draw_buf_init(&draw_buf, buf1, NULL, sizeof(buf1));
    lv_display_set_draw_buffers(disp, &draw_buf, NULL);
}
inline void lv_sdl_deinit() {}
#else
// Full SDL build for simulator
#include <SDL.h>
#include "lv_sdl.h"
#endif

int main(int argc, char **argv)
{
    // 1) Initialize LVGL
    lv_init();

    // 2) Initialize SDL window
    lv_sdl_init(argc, argv);

    // 3) Initialize application logic
#ifndef NATIVE_BUILD
    SensorInterface sensorInterface;
#endif
    StorageManager storageManager;
    storageManager.begin();

#ifndef NATIVE_BUILD
    ThemeManager::init();
    AnimationManager::init();
#endif

    ScreenManager screenManager(&storageManager);
    screenManager.init();

    // Create and register screens
    HomeScreen home(&screenManager);
#ifndef NATIVE_BUILD
    AnalyzeScreen analyze(&screenManager);
    CalibrationScreen calibration(&screenManager);
    SafetySettingsScreen safety(&screenManager);
    WiFiSettingsScreen wifi(&screenManager, &storageManager);
    UpdateSettingsScreen update(&screenManager, &storageManager);
#endif
    HistoryScreen history(&screenManager, &storageManager);
    SettingsScreen settings(&screenManager);

    screenManager.addScreen("home", &home);
#ifndef NATIVE_BUILD
    screenManager.addScreen("analyze", &analyze);
    screenManager.addScreen("calibration", &calibration);
    screenManager.addScreen("safety_settings", &safety);
    screenManager.addScreen("wifi_settings", &wifi);
    screenManager.addScreen("update_settings", &update);
#endif
    screenManager.addScreen("history", &history);
    screenManager.addScreen("settings", &settings);

    screenManager.setCurrentScreen("home");

    // 4) Enter LVGL task handler loop
    while (true)
    {
        lv_timer_handler();
#ifdef NATIVE_BUILD
        // Native build: use standard sleep
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
#else
        SDL_Delay(5);
#endif
    }

    return 0;
}
#endif