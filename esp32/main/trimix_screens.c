#include "trimix_screens.h"
#include "sensor_interface.h"
#include <esp_log.h>
#include <esp_timer.h>
#include <stdio.h>

static const char *TAG = "SCREENS";

// Global screen objects
static lv_obj_t *screens[SCREEN_COUNT];
static screen_id_t current_screen = SCREEN_HOME;

// Sensor data labels (for analyze screen)
static lv_obj_t *label_o2;
static lv_obj_t *label_co2;
static lv_obj_t *label_temp;
static lv_obj_t *label_pressure;
static lv_obj_t *label_humidity;

// Timer for sensor updates
static esp_timer_handle_t sensor_update_timer;

// Color definitions (matching trimix analyzer theme)
#define COLOR_PRIMARY lv_color_hex(0x2196F3)    // Blue
#define COLOR_SECONDARY lv_color_hex(0x4CAF50)  // Green
#define COLOR_DANGER lv_color_hex(0xF44336)     // Red
#define COLOR_WARNING lv_color_hex(0xFF9800)    // Orange
#define COLOR_BACKGROUND lv_color_hex(0x121212) // Dark background

// Forward declarations
static void sensor_update_callback(void *arg);

// Helper function to create navigation bar
static lv_obj_t *create_navbar(lv_obj_t *parent) {
    lv_obj_t *navbar = lv_obj_create(parent);
    lv_obj_set_size(navbar, LV_PCT(100), 60);
    lv_obj_align(navbar, LV_ALIGN_BOTTOM_MID, 0, 0);
    lv_obj_set_style_bg_color(navbar, COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(navbar, 0, 0);
    lv_obj_set_style_radius(navbar, 0, 0);
    
    // Home button
    lv_obj_t *btn_home = lv_btn_create(navbar);
    lv_obj_set_size(btn_home, 80, 40);
    lv_obj_align(btn_home, LV_ALIGN_LEFT_MID, 10, 0);
    lv_obj_add_event_cb(btn_home, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_home();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *label_home = lv_label_create(btn_home);
    lv_label_set_text(label_home, "Home");
    lv_obj_center(label_home);
    
    // Analyze button
    lv_obj_t *btn_analyze = lv_btn_create(navbar);
    lv_obj_set_size(btn_analyze, 80, 40);
    lv_obj_align(btn_analyze, LV_ALIGN_CENTER, 0, 0);
    lv_obj_add_event_cb(btn_analyze, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_analyze();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *label_analyze = lv_label_create(btn_analyze);
    lv_label_set_text(label_analyze, "Analyze");
    lv_obj_center(label_analyze);
    
    // Settings button
    lv_obj_t *btn_settings = lv_btn_create(navbar);
    lv_obj_set_size(btn_settings, 80, 40);
    lv_obj_align(btn_settings, LV_ALIGN_RIGHT_MID, -10, 0);
    lv_obj_add_event_cb(btn_settings, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_settings();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *label_settings = lv_label_create(btn_settings);
    lv_label_set_text(label_settings, "Settings");
    lv_obj_center(label_settings);
    
    return navbar;
}

// Helper function to create sensor card
static lv_obj_t *create_sensor_card(lv_obj_t *parent, const char *title, const char *value, const char *unit, lv_color_t color) {
    lv_obj_t *card = lv_obj_create(parent);
    lv_obj_set_size(card, 180, 100);
    lv_obj_set_style_bg_color(card, color, 0);
    lv_obj_set_style_border_width(card, 2, 0);
    lv_obj_set_style_border_color(card, lv_color_white(), 0);
    lv_obj_set_style_radius(card, 10, 0);
    
    // Title label
    lv_obj_t *title_label = lv_label_create(card);
    lv_label_set_text(title_label, title);
    lv_obj_set_style_text_color(title_label, lv_color_white(), 0);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_14, 0);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 5);
    
    // Value label
    lv_obj_t *value_label = lv_label_create(card);
    lv_label_set_text_fmt(value_label, "%s %s", value, unit);
    lv_obj_set_style_text_color(value_label, lv_color_white(), 0);
    lv_obj_set_style_text_font(value_label, &lv_font_montserrat_20, 0);
    lv_obj_align(value_label, LV_ALIGN_CENTER, 0, 5);
    
    return value_label; // Return the value label for updates
}

lv_obj_t *create_home_screen(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Trimix Analyzer");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 20);
    
    // Version info
    lv_obj_t *version = lv_label_create(screen);
    lv_label_set_text(version, "ESP32 Version v1.0.0");
    lv_obj_set_style_text_color(version, lv_color_hex(0x888888), 0);
    lv_obj_align(version, LV_ALIGN_TOP_MID, 0, 55);
    
    // Menu grid
    lv_obj_t *menu_container = lv_obj_create(screen);
    lv_obj_set_size(menu_container, LV_PCT(90), 280);
    lv_obj_center(menu_container);
    lv_obj_set_style_bg_opa(menu_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(menu_container, 0, 0);
    lv_obj_set_flex_flow(menu_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(menu_container, 20, 0);
    
    // Analyze button (main action)
    lv_obj_t *btn_analyze = lv_btn_create(menu_container);
    lv_obj_set_size(btn_analyze, LV_PCT(100), 80);
    lv_obj_set_style_bg_color(btn_analyze, COLOR_SECONDARY, 0);
    lv_obj_add_event_cb(btn_analyze, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_analyze();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *analyze_label = lv_label_create(btn_analyze);
    lv_label_set_text(analyze_label, "Start Analysis");
    lv_obj_set_style_text_font(analyze_label, &lv_font_montserrat_20, 0);
    lv_obj_center(analyze_label);
    
    // Settings button
    lv_obj_t *btn_settings = lv_btn_create(menu_container);
    lv_obj_set_size(btn_settings, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_settings, COLOR_PRIMARY, 0);
    lv_obj_add_event_cb(btn_settings, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_settings();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *settings_label = lv_label_create(btn_settings);
    lv_label_set_text(settings_label, "Settings & Calibration");
    lv_obj_set_style_text_font(settings_label, &lv_font_montserrat_16, 0);
    lv_obj_center(settings_label);
    
    // Status information
    lv_obj_t *status = lv_label_create(screen);
    lv_label_set_text(status, "Status: Ready");
    lv_obj_set_style_text_color(status, COLOR_SECONDARY, 0);
    lv_obj_align(status, LV_ALIGN_BOTTOM_MID, 0, -80);
    
    return screen;
}

lv_obj_t *create_analyze_screen(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Real-time Analysis");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    // Sensor grid container
    lv_obj_t *grid_container = lv_obj_create(screen);
    lv_obj_set_size(grid_container, LV_PCT(95), 320);
    lv_obj_align(grid_container, LV_ALIGN_CENTER, 0, -20);
    lv_obj_set_style_bg_opa(grid_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(grid_container, 0, 0);
    lv_obj_set_layout(grid_container, LV_LAYOUT_GRID);
    
    // Configure grid: 2 columns, 3 rows
    static int32_t col_dsc[] = {LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST};
    static int32_t row_dsc[] = {LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST};
    lv_obj_set_grid_dsc_array(grid_container, col_dsc, row_dsc);
    
    // Create sensor cards and store label references
    lv_obj_t *o2_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(o2_card, LV_GRID_ALIGN_STRETCH, 0, 1, LV_GRID_ALIGN_STRETCH, 0, 1);
    lv_obj_set_style_bg_color(o2_card, COLOR_SECONDARY, 0);
    lv_obj_set_style_border_width(o2_card, 2, 0);
    lv_obj_set_style_border_color(o2_card, lv_color_white(), 0);
    lv_obj_set_style_radius(o2_card, 10, 0);
    
    lv_obj_t *o2_title = lv_label_create(o2_card);
    lv_label_set_text(o2_title, "Oxygen");
    lv_obj_set_style_text_color(o2_title, lv_color_white(), 0);
    lv_obj_align(o2_title, LV_ALIGN_TOP_MID, 0, 5);
    
    label_o2 = lv_label_create(o2_card);
    lv_label_set_text(label_o2, "20.9 %");
    lv_obj_set_style_text_color(label_o2, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_o2, &lv_font_montserrat_20, 0);
    lv_obj_align(label_o2, LV_ALIGN_CENTER, 0, 5);
    
    // CO2 card
    lv_obj_t *co2_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(co2_card, LV_GRID_ALIGN_STRETCH, 1, 1, LV_GRID_ALIGN_STRETCH, 0, 1);
    lv_obj_set_style_bg_color(co2_card, COLOR_WARNING, 0);
    lv_obj_set_style_border_width(co2_card, 2, 0);
    lv_obj_set_style_border_color(co2_card, lv_color_white(), 0);
    lv_obj_set_style_radius(co2_card, 10, 0);
    
    lv_obj_t *co2_title = lv_label_create(co2_card);
    lv_label_set_text(co2_title, "CO2");
    lv_obj_set_style_text_color(co2_title, lv_color_white(), 0);
    lv_obj_align(co2_title, LV_ALIGN_TOP_MID, 0, 5);
    
    label_co2 = lv_label_create(co2_card);
    lv_label_set_text(label_co2, "400 ppm");
    lv_obj_set_style_text_color(label_co2, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_co2, &lv_font_montserrat_16, 0);
    lv_obj_align(label_co2, LV_ALIGN_CENTER, 0, 5);
    
    // Temperature card
    lv_obj_t *temp_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(temp_card, LV_GRID_ALIGN_STRETCH, 0, 1, LV_GRID_ALIGN_STRETCH, 1, 1);
    lv_obj_set_style_bg_color(temp_card, COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(temp_card, 2, 0);
    lv_obj_set_style_border_color(temp_card, lv_color_white(), 0);
    lv_obj_set_style_radius(temp_card, 10, 0);
    
    lv_obj_t *temp_title = lv_label_create(temp_card);
    lv_label_set_text(temp_title, "Temperature");
    lv_obj_set_style_text_color(temp_title, lv_color_white(), 0);
    lv_obj_align(temp_title, LV_ALIGN_TOP_MID, 0, 5);
    
    label_temp = lv_label_create(temp_card);
    lv_label_set_text(label_temp, "22.5 °C");
    lv_obj_set_style_text_color(label_temp, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_temp, &lv_font_montserrat_16, 0);
    lv_obj_align(label_temp, LV_ALIGN_CENTER, 0, 5);
    
    // Pressure card
    lv_obj_t *press_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(press_card, LV_GRID_ALIGN_STRETCH, 1, 1, LV_GRID_ALIGN_STRETCH, 1, 1);
    lv_obj_set_style_bg_color(press_card, COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(press_card, 2, 0);
    lv_obj_set_style_border_color(press_card, lv_color_white(), 0);
    lv_obj_set_style_radius(press_card, 10, 0);
    
    lv_obj_t *press_title = lv_label_create(press_card);
    lv_label_set_text(press_title, "Pressure");
    lv_obj_set_style_text_color(press_title, lv_color_white(), 0);
    lv_obj_align(press_title, LV_ALIGN_TOP_MID, 0, 5);
    
    label_pressure = lv_label_create(press_card);
    lv_label_set_text(label_pressure, "1.01 bar");
    lv_obj_set_style_text_color(label_pressure, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_pressure, &lv_font_montserrat_16, 0);
    lv_obj_align(label_pressure, LV_ALIGN_CENTER, 0, 5);
    
    // Humidity card (spans both columns)
    lv_obj_t *hum_card = lv_obj_create(grid_container);
    lv_obj_set_grid_cell(hum_card, LV_GRID_ALIGN_STRETCH, 0, 2, LV_GRID_ALIGN_STRETCH, 2, 1);
    lv_obj_set_style_bg_color(hum_card, COLOR_PRIMARY, 0);
    lv_obj_set_style_border_width(hum_card, 2, 0);
    lv_obj_set_style_border_color(hum_card, lv_color_white(), 0);
    lv_obj_set_style_radius(hum_card, 10, 0);
    
    lv_obj_t *hum_title = lv_label_create(hum_card);
    lv_label_set_text(hum_title, "Humidity");
    lv_obj_set_style_text_color(hum_title, lv_color_white(), 0);
    lv_obj_align(hum_title, LV_ALIGN_TOP_MID, 0, 5);
    
    label_humidity = lv_label_create(hum_card);
    lv_label_set_text(label_humidity, "45.2 %");
    lv_obj_set_style_text_color(label_humidity, lv_color_white(), 0);
    lv_obj_set_style_text_font(label_humidity, &lv_font_montserrat_20, 0);
    lv_obj_align(label_humidity, LV_ALIGN_CENTER, 0, 5);
    
    // Create navigation bar
    create_navbar(screen);
    
    return screen;
}

lv_obj_t *create_settings_screen(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Settings");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    // Settings menu container
    lv_obj_t *menu_container = lv_obj_create(screen);
    lv_obj_set_size(menu_container, LV_PCT(90), 300);
    lv_obj_center(menu_container);
    lv_obj_set_style_bg_opa(menu_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(menu_container, 0, 0);
    lv_obj_set_flex_flow(menu_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(menu_container, 15, 0);
    
    // O2 Calibration button
    lv_obj_t *btn_calibrate = lv_btn_create(menu_container);
    lv_obj_set_size(btn_calibrate, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_calibrate, COLOR_SECONDARY, 0);
    lv_obj_add_event_cb(btn_calibrate, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_calibrate_o2();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *calibrate_label = lv_label_create(btn_calibrate);
    lv_label_set_text(calibrate_label, "O2 Sensor Calibration");
    lv_obj_set_style_text_font(calibrate_label, &lv_font_montserrat_16, 0);
    lv_obj_center(calibrate_label);
    
    // System Info button (placeholder)
    lv_obj_t *btn_sysinfo = lv_btn_create(menu_container);
    lv_obj_set_size(btn_sysinfo, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_sysinfo, COLOR_PRIMARY, 0);
    
    lv_obj_t *sysinfo_label = lv_label_create(btn_sysinfo);
    lv_label_set_text(sysinfo_label, "System Information");
    lv_obj_set_style_text_font(sysinfo_label, &lv_font_montserrat_16, 0);
    lv_obj_center(sysinfo_label);
    
    // About button (placeholder)
    lv_obj_t *btn_about = lv_btn_create(menu_container);
    lv_obj_set_size(btn_about, LV_PCT(100), 60);
    lv_obj_set_style_bg_color(btn_about, COLOR_PRIMARY, 0);
    
    lv_obj_t *about_label = lv_label_create(btn_about);
    lv_label_set_text(about_label, "About");
    lv_obj_set_style_text_font(about_label, &lv_font_montserrat_16, 0);
    lv_obj_center(about_label);
    
    // Create navigation bar
    create_navbar(screen);
    
    return screen;
}

lv_obj_t *create_calibrate_o2_screen(void) {
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "O2 Calibration");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    
    // Instructions
    lv_obj_t *instructions = lv_label_create(screen);
    lv_label_set_text(instructions, 
        "1. Ensure sensor is exposed to normal air\n"
        "2. Wait for readings to stabilize\n"
        "3. Press 'Calibrate' to set 20.9% O2");
    lv_obj_set_style_text_color(instructions, lv_color_white(), 0);
    lv_obj_set_style_text_align(instructions, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_align(instructions, LV_ALIGN_CENTER, 0, -60);
    
    // Current reading display
    lv_obj_t *current_reading = lv_label_create(screen);
    lv_label_set_text(current_reading, "Current: 20.9% O2");
    lv_obj_set_style_text_font(current_reading, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(current_reading, COLOR_SECONDARY, 0);
    lv_obj_align(current_reading, LV_ALIGN_CENTER, 0, 0);
    
    // Calibrate button
    lv_obj_t *btn_calibrate = lv_btn_create(screen);
    lv_obj_set_size(btn_calibrate, 200, 60);
    lv_obj_align(btn_calibrate, LV_ALIGN_CENTER, 0, 60);
    lv_obj_set_style_bg_color(btn_calibrate, COLOR_SECONDARY, 0);
    lv_obj_add_event_cb(btn_calibrate, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            // Perform calibration
            esp_err_t ret = sensor_calibrate_oxygen_air();
            if (ret == ESP_OK) {
                ESP_LOGI(TAG, "O2 calibration completed");
                // Show success message
                lv_obj_t *msg = lv_label_create(lv_scr_act());
                lv_label_set_text(msg, "Calibration Complete!");
                lv_obj_set_style_text_color(msg, COLOR_SECONDARY, 0);
                lv_obj_align(msg, LV_ALIGN_CENTER, 0, 120);
            } else {
                ESP_LOGE(TAG, "O2 calibration failed");
            }
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *calibrate_label = lv_label_create(btn_calibrate);
    lv_label_set_text(calibrate_label, "Calibrate Now");
    lv_obj_set_style_text_font(calibrate_label, &lv_font_montserrat_16, 0);
    lv_obj_center(calibrate_label);
    
    // Back button
    lv_obj_t *btn_back = lv_btn_create(screen);
    lv_obj_set_size(btn_back, 100, 40);
    lv_obj_align(btn_back, LV_ALIGN_BOTTOM_LEFT, 10, -10);
    lv_obj_set_style_bg_color(btn_back, COLOR_PRIMARY, 0);
    lv_obj_add_event_cb(btn_back, [](lv_event_t *e) {
        if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
            navigate_to_settings();
        }
    }, LV_EVENT_CLICKED, NULL);
    
    lv_obj_t *back_label = lv_label_create(btn_back);
    lv_label_set_text(back_label, "Back");
    lv_obj_center(back_label);
    
    return screen;
}

// Sensor update callback
static void sensor_update_callback(void *arg) {
    if (current_screen == SCREEN_ANALYZE) {
        update_analyze_screen();
    }
}

void update_analyze_screen(void) {
    if (!label_o2 || !label_co2 || !label_temp || !label_pressure || !label_humidity) {
        return;
    }
    
    sensor_readings_t readings;
    esp_err_t ret = sensor_read_all(&readings);
    if (ret == ESP_OK) {
        lv_label_set_text_fmt(label_o2, "%.1f %%", readings.oxygen_percent);
        lv_label_set_text_fmt(label_co2, "%.0f ppm", readings.co2_ppm);
        lv_label_set_text_fmt(label_temp, "%.1f °C", readings.temperature_c);
        lv_label_set_text_fmt(label_pressure, "%.2f bar", readings.pressure_bar);
        lv_label_set_text_fmt(label_humidity, "%.1f %%", readings.humidity_pct);
    }
}

void screens_init(void) {
    ESP_LOGI(TAG, "Initializing screens");
    
    // Create all screens
    screens[SCREEN_HOME] = create_home_screen();
    screens[SCREEN_ANALYZE] = create_analyze_screen();
    screens[SCREEN_SETTINGS] = create_settings_screen();
    screens[SCREEN_CALIBRATE_O2] = create_calibrate_o2_screen();
    
    // Show home screen by default
    screen_manager_show(SCREEN_HOME);
    
    // Setup sensor update timer (2 second interval)
    const esp_timer_create_args_t timer_args = {
        .callback = &sensor_update_callback,
        .arg = NULL,
        .dispatch_method = ESP_TIMER_TASK,
        .name = "sensor_update",
        .skip_unhandled_events = true
    };
    
    esp_timer_create(&timer_args, &sensor_update_timer);
    esp_timer_start_periodic(sensor_update_timer, 2000000); // 2 seconds in microseconds
    
    ESP_LOGI(TAG, "Screens initialized");
}

void screen_manager_show(screen_id_t screen) {
    if (screen >= SCREEN_COUNT) {
        ESP_LOGE(TAG, "Invalid screen ID: %d", screen);
        return;
    }
    
    current_screen = screen;
    lv_scr_load(screens[screen]);
    ESP_LOGI(TAG, "Switched to screen %d", screen);
}

screen_id_t screen_manager_current(void) {
    return current_screen;
}

// Navigation functions
void navigate_to_home(void) {
    screen_manager_show(SCREEN_HOME);
}

void navigate_to_analyze(void) {
    screen_manager_show(SCREEN_ANALYZE);
}

void navigate_to_settings(void) {
    screen_manager_show(SCREEN_SETTINGS);
}

void navigate_to_calibrate_o2(void) {
    screen_manager_show(SCREEN_CALIBRATE_O2);
}