#pragma once
#include <lvgl.h>
#include <esp_err.h>

// Screen identifiers
typedef enum {
    SCREEN_HOME = 0,
    SCREEN_ANALYZE,
    SCREEN_SETTINGS,
    SCREEN_CALIBRATE_O2,
    SCREEN_COUNT
} screen_id_t;

// Struct holding sensor readings (mocked)
typedef struct {
    float oxygen_percent;
    float co2_ppm;
    float temperature_c;
    float pressure_bar;
    float humidity_pct;
} sensor_readings_t;

// UI lifecycle
void screens_init(void);
void screen_manager_show(screen_id_t screen);
screen_id_t screen_manager_current(void);
void update_analyze_screen(void);

// Navigation helpers
void navigate_to_home(void);
void navigate_to_analyze(void);
void navigate_to_settings(void);
void navigate_to_calibrate_o2(void);

// Sensor interface hooks (implemented in sensor_interface.c)
esp_err_t sensor_read_all(sensor_readings_t *out);
esp_err_t sensor_calibrate_oxygen_air(void);
