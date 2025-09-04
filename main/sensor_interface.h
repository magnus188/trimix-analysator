#pragma once
#include "trimix_screens.h"
#include <esp_err.h>
#ifdef __cplusplus
extern "C" {
#endif

esp_err_t sensor_read_all(sensor_readings_t *out);
esp_err_t sensor_calibrate_oxygen_air(void);

#ifdef __cplusplus
}
#endif
