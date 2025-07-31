/*
 * HomeScreen.cpp
 * Implementation of home screen for ESP32-S3 Trimix Analyzer
 */

#include "ui/HomeScreen.h"
#include "TrimixApp.h"

#define TRIMIX_VERSION "2.0.0-ESP32"

HomeScreen::HomeScreen(TrimixApp* app) :
    app(app),
    screen(nullptr),
    analyze_btn(nullptr),
    settings_btn(nullptr),
    calibrate_btn(nullptr),
    about_btn(nullptr),
    title_label(nullptr),
    status_label(nullptr),
    version_label(nullptr),
    quick_o2_label(nullptr),
    quick_temp_label(nullptr)
{
}

HomeScreen::~HomeScreen() {
    if (screen) {
        lv_obj_del(screen);
    }
}

bool HomeScreen::create() {
    Serial.println("HomeScreen: Creating home screen");
    
    // Create screen
    screen = lv_obj_create(NULL);
    if (!screen) {
        Serial.println("HomeScreen: Failed to create screen");
        return false;
    }
    
    // Set background color to dark blue
    lv_obj_set_style_bg_color(screen, lv_color_hex(0x001122), 0);
    
    createLayout();
    createMenuButtons();
    createStatusDisplay();
    
    Serial.println("HomeScreen: Home screen created successfully");
    return true;
}

void HomeScreen::createLayout() {
    // Create title
    title_label = lv_label_create(screen);
    lv_label_set_text(title_label, "TRIMIX ANALYZER");
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_32, 0);
    lv_obj_set_style_text_color(title_label, lv_color_hex(0xFFFFFF), 0);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 20);
    
    // Create version label
    version_label = lv_label_create(screen);
    lv_label_set_text(version_label, TRIMIX_VERSION);
    lv_obj_set_style_text_font(version_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(version_label, lv_color_hex(0x888888), 0);
    lv_obj_align(version_label, LV_ALIGN_TOP_MID, 0, 60);
}

void HomeScreen::createMenuButtons() {
    // Button styles
    static lv_style_t btn_style;
    lv_style_init(&btn_style);
    lv_style_set_radius(&btn_style, 10);
    lv_style_set_bg_color(&btn_style, lv_color_hex(0x2196F3));
    lv_style_set_shadow_width(&btn_style, 5);
    lv_style_set_shadow_opa(&btn_style, LV_OPA_30);
    
    static lv_style_t btn_pressed;
    lv_style_init(&btn_pressed);
    lv_style_set_bg_color(&btn_pressed, lv_color_hex(0x1976D2));
    lv_style_set_transform_scale(&btn_pressed, 950);
    
    // Analyze button
    analyze_btn = lv_btn_create(screen);
    lv_obj_set_size(analyze_btn, 300, 80);
    lv_obj_align(analyze_btn, LV_ALIGN_CENTER, -160, -40);
    lv_obj_add_style(analyze_btn, &btn_style, 0);
    lv_obj_add_style(analyze_btn, &btn_pressed, LV_STATE_PRESSED);
    lv_obj_add_event_cb(analyze_btn, on_analyze_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* analyze_label = lv_label_create(analyze_btn);
    lv_label_set_text(analyze_label, "ANALYZE");
    lv_obj_set_style_text_font(analyze_label, &lv_font_montserrat_24, 0);
    lv_obj_center(analyze_label);
    
    // Settings button
    settings_btn = lv_btn_create(screen);
    lv_obj_set_size(settings_btn, 300, 80);
    lv_obj_align(settings_btn, LV_ALIGN_CENTER, 160, -40);
    lv_obj_add_style(settings_btn, &btn_style, 0);
    lv_obj_add_style(settings_btn, &btn_pressed, LV_STATE_PRESSED);
    lv_obj_add_event_cb(settings_btn, on_settings_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* settings_label = lv_label_create(settings_btn);
    lv_label_set_text(settings_label, "SETTINGS");
    lv_obj_set_style_text_font(settings_label, &lv_font_montserrat_24, 0);
    lv_obj_center(settings_label);
    
    // Calibrate button
    calibrate_btn = lv_btn_create(screen);
    lv_obj_set_size(calibrate_btn, 300, 80);
    lv_obj_align(calibrate_btn, LV_ALIGN_CENTER, -160, 60);
    lv_obj_add_style(calibrate_btn, &btn_style, 0);
    lv_obj_add_style(calibrate_btn, &btn_pressed, LV_STATE_PRESSED);
    lv_obj_add_event_cb(calibrate_btn, on_calibrate_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* calibrate_label = lv_label_create(calibrate_btn);
    lv_label_set_text(calibrate_label, "CALIBRATE");
    lv_obj_set_style_text_font(calibrate_label, &lv_font_montserrat_24, 0);
    lv_obj_center(calibrate_label);
    
    // About button
    about_btn = lv_btn_create(screen);
    lv_obj_set_size(about_btn, 300, 80);
    lv_obj_align(about_btn, LV_ALIGN_CENTER, 160, 60);
    lv_obj_add_style(about_btn, &btn_style, 0);
    lv_obj_add_style(about_btn, &btn_pressed, LV_STATE_PRESSED);
    lv_obj_add_event_cb(about_btn, on_about_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* about_label = lv_label_create(about_btn);
    lv_label_set_text(about_label, "ABOUT");
    lv_obj_set_style_text_font(about_label, &lv_font_montserrat_24, 0);
    lv_obj_center(about_label);
}

void HomeScreen::createStatusDisplay() {
    // Status container
    lv_obj_t* status_container = lv_obj_create(screen);
    lv_obj_set_size(status_container, 760, 100);
    lv_obj_align(status_container, LV_ALIGN_BOTTOM_MID, 0, -20);
    lv_obj_set_style_bg_color(status_container, lv_color_hex(0x333333), 0);
    lv_obj_set_style_border_width(status_container, 2, 0);
    lv_obj_set_style_border_color(status_container, lv_color_hex(0x555555), 0);
    lv_obj_set_style_radius(status_container, 10, 0);
    
    // Quick O2 display
    quick_o2_label = lv_label_create(status_container);
    lv_label_set_text(quick_o2_label, "O2: --.--%");
    lv_obj_set_style_text_font(quick_o2_label, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(quick_o2_label, lv_color_hex(0x00FF00), 0);
    lv_obj_align(quick_o2_label, LV_ALIGN_LEFT_MID, 20, -10);
    
    // Quick temperature display
    quick_temp_label = lv_label_create(status_container);
    lv_label_set_text(quick_temp_label, "TEMP: --.-°C");
    lv_obj_set_style_text_font(quick_temp_label, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(quick_temp_label, lv_color_hex(0xFFFFFF), 0);
    lv_obj_align(quick_temp_label, LV_ALIGN_LEFT_MID, 20, 20);
    
    // Status label
    status_label = lv_label_create(status_container);
    lv_label_set_text(status_label, "READY");
    lv_obj_set_style_text_font(status_label, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(status_label, lv_color_hex(0x00FF00), 0);
    lv_obj_align(status_label, LV_ALIGN_RIGHT_MID, -20, 0);
}

void HomeScreen::show() {
    if (screen) {
        lv_scr_load(screen);
        update(); // Update display immediately
    }
}

void HomeScreen::hide() {
    // Screen is automatically hidden when another screen is loaded
}

void HomeScreen::update() {
    updateQuickDisplay();
}

void HomeScreen::updateQuickDisplay() {
    if (!app || !quick_o2_label || !quick_temp_label) return;
    
    SensorManager* sensors = app->getSensorManager();
    if (!sensors) return;
    
    // Update O2 display
    float o2 = sensors->getO2Percent();
    lv_label_set_text_fmt(quick_o2_label, "O2: %.1f%%", o2);
    
    // Change color based on O2 level
    if (o2 < 16.0f || o2 > 23.0f) {
        lv_obj_set_style_text_color(quick_o2_label, lv_color_hex(0xFF0000), 0); // Red
    } else if (o2 < 18.0f || o2 > 22.0f) {
        lv_obj_set_style_text_color(quick_o2_label, lv_color_hex(0xFFAA00), 0); // Orange
    } else {
        lv_obj_set_style_text_color(quick_o2_label, lv_color_hex(0x00FF00), 0); // Green
    }
    
    // Update temperature display
    float temp = sensors->getTemperature();
    lv_label_set_text_fmt(quick_temp_label, "TEMP: %.1f°C", temp);
    
    // Update status based on sensor availability
    if (sensors->isUsingMockSensors()) {
        lv_label_set_text(status_label, "DEMO MODE");
        lv_obj_set_style_text_color(status_label, lv_color_hex(0xFFAA00), 0);
    } else if (sensors->isADS1115Available() && sensors->isBME280Available()) {
        lv_label_set_text(status_label, "READY");
        lv_obj_set_style_text_color(status_label, lv_color_hex(0x00FF00), 0);
    } else {
        lv_label_set_text(status_label, "SENSOR ERROR");
        lv_obj_set_style_text_color(status_label, lv_color_hex(0xFF0000), 0);
    }
}

// Event callbacks
void HomeScreen::on_analyze_clicked(lv_event_t* e) {
    HomeScreen* home = (HomeScreen*)lv_event_get_user_data(e);
    if (home && home->app) {
        Serial.println("HomeScreen: Analyze button clicked");
        home->app->showAnalyze();
    }
}

void HomeScreen::on_settings_clicked(lv_event_t* e) {
    HomeScreen* home = (HomeScreen*)lv_event_get_user_data(e);
    if (home && home->app) {
        Serial.println("HomeScreen: Settings button clicked");
        home->app->showSettings();
    }
}

void HomeScreen::on_calibrate_clicked(lv_event_t* e) {
    HomeScreen* home = (HomeScreen*)lv_event_get_user_data(e);
    if (home && home->app) {
        Serial.println("HomeScreen: Calibrate button clicked");
        // TODO: Implement calibration screen
    }
}

void HomeScreen::on_about_clicked(lv_event_t* e) {
    HomeScreen* home = (HomeScreen*)lv_event_get_user_data(e);
    if (home && home->app) {
        Serial.println("HomeScreen: About button clicked");
        // TODO: Implement about dialog
    }
}