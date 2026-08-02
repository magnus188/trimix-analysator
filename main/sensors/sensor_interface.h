#pragma once
#include <esp_err.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    SENSOR_STATUS_WARMING = 0,
    SENSOR_STATUS_STABILIZING,
    SENSOR_STATUS_STABLE,
    SENSOR_STATUS_UNSTABLE,
    SENSOR_STATUS_FAULT
} sensor_status_t;

typedef enum {
    SENSOR_SOURCE_SIMULATED = 0,
    SENSOR_SOURCE_HARDWARE
} sensor_source_t;

typedef enum {
    SENSOR_MOCK_PROFILE_AIR = 0,
    SENSOR_MOCK_PROFILE_EAN32,
    SENSOR_MOCK_PROFILE_TRIMIX_18_45,
    SENSOR_MOCK_PROFILE_HIGH_CO2,
    SENSOR_MOCK_PROFILE_UNSTABLE,
    SENSOR_MOCK_PROFILE_SENSOR_FAULT,
    SENSOR_MOCK_PROFILE_COUNT
} sensor_mock_profile_t;

typedef struct {
    float oxygen_percent;
    float helium_percent;
    float co2_ppm;
    float temperature_c;
    float pressure_bar;
    float humidity_pct;
    uint32_t timestamp_ms;
    uint32_t sequence;
    sensor_status_t status;
    sensor_source_t source;
} sensor_readings_t;

esp_err_t sensor_read_all(sensor_readings_t *out);
esp_err_t sensor_calibrate_oxygen_air(void);
esp_err_t sensor_calibrate_co2_zero(void);
esp_err_t sensor_calibrate_co2_reference(uint16_t reference_ppm);
void sensor_set_mock_profile(sensor_mock_profile_t profile);
sensor_mock_profile_t sensor_get_mock_profile(void);
const char* sensor_mock_profile_name(sensor_mock_profile_t profile);
const char* sensor_status_label(sensor_status_t status);
const char* sensor_source_label(sensor_source_t source);

#ifdef __cplusplus
}
#endif
