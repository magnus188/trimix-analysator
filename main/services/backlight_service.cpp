#include "backlight_service.h"

#include "board/guition_jc4880p443.h"

#include <esp_err.h>
#include <esp_log.h>

namespace {

constexpr char TAG[] = "BACKLIGHT";
uint8_t g_brightness = 100;
bool g_initialized = false;

}  // namespace

void backlight_init(void) {
    if (g_initialized) {
        return;
    }

    // guition_display_init() initializes the board's GPIO23 PWM channel.
    g_initialized = true;
    ESP_LOGI(TAG, "Using Guition JC4880P443 backlight control");
}

void backlight_set(uint8_t percent) {
    if (!g_initialized) {
        backlight_init();
    }

    if (percent < 10) {
        percent = 10;
    } else if (percent > 100) {
        percent = 100;
    }

    esp_err_t err = guition_backlight_set(percent);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to set brightness: %s", esp_err_to_name(err));
        return;
    }

    g_brightness = percent;
}

uint8_t backlight_get(void) {
    return g_brightness;
}
