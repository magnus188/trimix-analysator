// Simplified main now delegates hardware & LVGL setup to lvgl_port and screens to ScreenManager.
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <lvgl.h>
#include "ui/lvgl/lvgl_port.h"
#include "ui/screens/screen_manager.h" // screens API

static void ui_task(void *arg){
    lvgl_port_init();
    screens_init();
    for(;;){ vTaskDelay(20 / portTICK_PERIOD_MS); lv_timer_handler(); }
}

extern "C" void app_main(void){ xTaskCreatePinnedToCore(ui_task, "ui", 8192, nullptr, 1, nullptr, 1); vTaskDelay(portMAX_DELAY); }
