// Simplified main now delegates hardware & LVGL setup to lvgl_port and screens to ScreenManager.
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <lvgl.h>
#include <esp_log.h>
#include "ui/lvgl/lvgl_port.h"
#include "ui/screens/screen_manager.h"
#include "services/settings_service.h"
#include "services/wifi_service.h"
#include "services/battery_service.h"

static const char* TAG = "MAIN";

// Debug: log screen scroll state periodically
static void debug_log_screen_state() {
    static uint32_t last_log = 0;
    static lv_coord_t last_scroll_x = 0, last_scroll_y = 0;
    
    uint32_t now = lv_tick_get();
    if (now - last_log < 500) return;  // Log every 500ms max
    
    lv_obj_t* scr = lv_scr_act();
    if (!scr) return;
    
    lv_coord_t scroll_x = lv_obj_get_scroll_x(scr);
    lv_coord_t scroll_y = lv_obj_get_scroll_y(scr);
    
    // Only log if changed
    if (scroll_x != last_scroll_x || scroll_y != last_scroll_y) {
        ESP_LOGW(TAG, "SCROLL CHANGED! Screen scroll: x=%ld, y=%ld (was x=%ld, y=%ld)", 
                 (long)scroll_x, (long)scroll_y, (long)last_scroll_x, (long)last_scroll_y);
        last_scroll_x = scroll_x;
        last_scroll_y = scroll_y;
        
        // Log first child position too
        uint32_t child_count = lv_obj_get_child_count(scr);
        if (child_count > 0) {
            lv_obj_t* first_child = lv_obj_get_child(scr, 0);
            ESP_LOGW(TAG, "First child pos: x=%ld, y=%ld",
                     (long)lv_obj_get_x(first_child), (long)lv_obj_get_y(first_child));
        }
    }
    last_log = now;
}

static void ui_task(void *arg){
    // Initialize settings first (loads from NVS)
    settings_init();
    
    // Initialize other services
    wifi_service_init();
    battery_service_init();
    
    // Initialize display and LVGL
    lvgl_port_init();
    screens_init();
    
    // Start battery monitoring (updates status icons)
    battery_start_monitoring();
    
    // Auto-connect to saved WiFi if available
    wifi_service_auto_connect();
    
    for(;;){
        vTaskDelay(10 / portTICK_PERIOD_MS);
        lv_timer_handler();
        debug_log_screen_state();  // Debug: track scroll changes
    }
}

extern "C" void app_main(void){ xTaskCreatePinnedToCore(ui_task, "ui", 12288, nullptr, 3, nullptr, 1); vTaskDelay(portMAX_DELAY); }
