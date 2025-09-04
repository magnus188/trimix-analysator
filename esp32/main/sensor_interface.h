#ifndef SENSOR_INTERFACE_H
#define SENSOR_INTERFACE_H

#include <esp_err.h>
#include <stdint.h>
#include <stdbool.h>

// Sensor reading structure
typedef struct {
    float oxygen_percent;
    float co2_ppm;
    float temperature_c;
    float pressure_bar;
    float humidity_pct;
    bool power_button_pressed;
} sensor_readings_t;

// Calibration data structure
typedef struct {
    float o2_air_voltage;     // O2 voltage in air (20.9%)
    float co2_zero_voltage;   // CO2 sensor zero point
    float co2_span_voltage;   // CO2 sensor span
} sensor_calibration_t;

// Initialize the sensor interface
esp_err_t sensor_interface_init(void);

// Read all sensors at once
esp_err_t sensor_read_all(sensor_readings_t *readings);

// Individual sensor reading functions
esp_err_t sensor_read_oxygen_voltage(float *voltage);
esp_err_t sensor_read_oxygen_percent(float *percent);
esp_err_t sensor_read_co2_voltage(float *voltage);
esp_err_t sensor_read_co2_ppm(float *ppm);
esp_err_t sensor_read_temperature(float *temperature);
esp_err_t sensor_read_pressure(float *pressure);
esp_err_t sensor_read_humidity(float *humidity);
bool sensor_read_power_button(void);

// Calibration functions
esp_err_t sensor_calibrate_oxygen_air(void);
esp_err_t sensor_set_calibration(const sensor_calibration_t *cal);
esp_err_t sensor_get_calibration(sensor_calibration_t *cal);

#endif // SENSOR_INTERFACE_H