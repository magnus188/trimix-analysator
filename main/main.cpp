// Simplified main now delegates hardware & LVGL setup to lvgl_port and screens to ScreenManager.
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <lvgl.h>
#include "ui/lvgl/lvgl_port.h"
#include "ui/screens/screen_manager.h"
#include "services/settings_service.h"
#include "services/wifi_service.h"
#include "services/battery_service.h"

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
    }
}

extern "C" void app_main(void){ xTaskCreatePinnedToCore(ui_task, "ui", 12288, nullptr, 3, nullptr, 1); vTaskDelay(portMAX_DELAY); }
