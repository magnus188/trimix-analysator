#ifndef TRIMIX_SCREENS_H
#define TRIMIX_SCREENS_H

#include <lvgl.h>

// Screen identifiers
typedef enum {
    SCREEN_HOME = 0,
    SCREEN_ANALYZE,
    SCREEN_SETTINGS,
    SCREEN_CALIBRATE_O2,
    SCREEN_COUNT
} screen_id_t;

// Function prototypes
void screens_init(void);
void screen_manager_show(screen_id_t screen);
screen_id_t screen_manager_current(void);

// Individual screen creation functions
lv_obj_t *create_home_screen(void);
lv_obj_t *create_analyze_screen(void);
lv_obj_t *create_settings_screen(void);
lv_obj_t *create_calibrate_o2_screen(void);

// Screen update functions (called periodically)
void update_analyze_screen(void);

// Navigation functions
void navigate_to_home(void);
void navigate_to_analyze(void);
void navigate_to_settings(void);
void navigate_to_calibrate_o2(void);

#endif // TRIMIX_SCREENS_H