#pragma once
#include <lvgl.h>
#include <esp_err.h>

#ifdef __cplusplus
extern "C" {
#endif

// Screen identifiers
typedef enum {
    SCREEN_HOME = 0,
    SCREEN_ANALYZE,
    SCREEN_DIVE_PLANNER,
    SCREEN_HISTORY,
    SCREEN_SETTINGS,
    SCREEN_CALIBRATE_O2,
    SCREEN_WIFI_SETTINGS,
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

// Screen manager interface
void screen_manager_init(void);
void screen_manager_show(screen_id_t screen);
screen_id_t screen_manager_current(void);
void screen_manager_set_analyze_labels(lv_obj_t *o2, lv_obj_t *co2, lv_obj_t *temp, lv_obj_t *pressure, lv_obj_t *humidity);
void screen_manager_update_analyze(void);

// Legacy compatibility functions
void screens_init(void);
void update_analyze_screen(void);
void navigate_to_home(void);
void navigate_to_analyze(void);
void navigate_to_dive_planner(void);
void navigate_to_history(void);
void navigate_to_settings(void);
void navigate_to_calibrate_o2(void);

// Sensor interface hooks
esp_err_t sensor_read_all(sensor_readings_t *out);
esp_err_t sensor_calibrate_oxygen_air(void);

#ifdef __cplusplus
}
#endif
