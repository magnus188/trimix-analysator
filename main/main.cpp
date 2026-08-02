// Simplified main now delegates hardware & LVGL setup to lvgl_port and screens to ScreenManager.
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <lvgl.h>
#include <esp_log.h>
#include <cstdlib>
#include "ui/lvgl/lvgl_port.h"
#include "ui/screens/screen_manager.h"
#include "services/settings_service.h"
#include "services/wifi_service.h"
#include "services/battery_service.h"
#include "services/analysis_history.h"
#include "services/cylinder_profiles.h"

static const char* TAG = "MAIN";

static void ui_task(void *arg) {
    (void)arg;

    // Initialize settings first (loads from NVS)
    settings_init();
    
    // Initialize other services
    wifi_service_init();
    battery_service_init();
    analysis_history_init();
    cylinder_profiles_init();
    
    // Initialize display and LVGL
    lvgl_port_init();
    screens_init();
    
    // Start battery monitoring (updates status icons)
    battery_start_monitoring();
    
    // Auto-connect to saved WiFi if available
    wifi_service_auto_connect();
    
    for (;;) {
        uint32_t delay_ms = lv_timer_handler();
        if (delay_ms < 5) delay_ms = 5;
        if (delay_ms > 20) delay_ms = 20;
        vTaskDelay(pdMS_TO_TICKS(delay_ms));
    }
}

extern "C" void app_main(void) {
    BaseType_t created = xTaskCreatePinnedToCore(ui_task, "ui", 12288, nullptr, 3, nullptr, 1);
    if (created != pdPASS) {
        ESP_LOGE(TAG, "Failed to create UI task");
        std::abort();
    }

    vTaskDelay(portMAX_DELAY);
}
