// Sensor interface (mock) moved to sensors/ directory.
#include "sensor_interface.h"
#include <esp_err.h>
#include <esp_log.h>
#include <cstdlib>

static const char *TAG = "SENSOR_IF";

extern "C" {
esp_err_t sensor_read_all(sensor_readings_t *out) {
    if (!out) return ESP_ERR_INVALID_ARG;
    out->oxygen_percent = 20.5f + (std::rand() % 40) / 100.0f; // 20.5 - 20.9
    out->co2_ppm        = 380.0f + (std::rand() % 50);         // 380 - 429
    out->temperature_c  = 22.0f + (std::rand() % 30) / 10.0f;  // 22.0 - 24.9
    out->pressure_bar   = 1.00f + (std::rand() % 5) / 100.0f;  // 1.00 - 1.04
    out->humidity_pct   = 40.0f + (std::rand() % 200) / 10.0f; // 40.0 - 59.9
    return ESP_OK;
}

esp_err_t sensor_calibrate_oxygen_air(void) {
    ESP_LOGI(TAG, "Calibrating O2 sensor to ambient air (20.9%%)");
    return ESP_OK;
}
}
