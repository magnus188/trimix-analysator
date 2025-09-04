#include <esp_err.h>
#include <esp_log.h>
#include <stdlib.h>
#include "trimix_screens.h"

static const char *TAG = "SENSOR_IF";

esp_err_t sensor_read_all(sensor_readings_t *out) {
    if (!out) return ESP_ERR_INVALID_ARG;
    // Mock random-ish but stable values
    out->oxygen_percent = 20.5f + (rand() % 40) / 100.0f; // 20.5 - 20.9
    out->co2_ppm        = 380.0f + (rand() % 50);         // 380 - 429
    out->temperature_c  = 22.0f + (rand() % 30) / 10.0f;  // 22.0 - 24.9
    out->pressure_bar   = 1.00f + (rand() % 5) / 100.0f;  // 1.00 - 1.04
    out->humidity_pct   = 40.0f + (rand() % 200) / 10.0f; // 40.0 - 59.9
    return ESP_OK;
}

esp_err_t sensor_calibrate_oxygen_air(void) {
    ESP_LOGI(TAG, "Calibrating O2 sensor to ambient air (20.9%%)");
    // Pretend to perform calibration
    return ESP_OK;
}
