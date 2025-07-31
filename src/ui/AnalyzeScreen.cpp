/*
 * AnalyzeScreen.cpp
 * Implementation of real-time sensor display for ESP32-S3 Trimix Analyzer
 */

#include "ui/AnalyzeScreen.h"
#include "TrimixApp.h"

AnalyzeScreen::AnalyzeScreen(TrimixApp* app) :
    app(app),
    screen(nullptr),
    back_btn(nullptr),
    o2_card(nullptr),
    co2_card(nullptr),
    temp_card(nullptr),
    pressure_card(nullptr),
    humidity_card(nullptr),
    o2_value_label(nullptr),
    o2_unit_label(nullptr),
    co2_value_label(nullptr),
    co2_unit_label(nullptr),
    temp_value_label(nullptr),
    temp_unit_label(nullptr),
    pressure_value_label(nullptr),
    pressure_unit_label(nullptr),
    humidity_value_label(nullptr),
    humidity_unit_label(nullptr),
    trend_chart(nullptr),
    o2_series(nullptr),
    last_update(0)
{
}

AnalyzeScreen::~AnalyzeScreen() {
    if (screen) {
        lv_obj_del(screen);
    }
}

bool AnalyzeScreen::create() {
    Serial.println("AnalyzeScreen: Creating analyze screen");
    
    // Create screen
    screen = lv_obj_create(NULL);
    if (!screen) {
        Serial.println("AnalyzeScreen: Failed to create screen");
        return false;
    }
    
    // Set background color to dark
    lv_obj_set_style_bg_color(screen, lv_color_hex(0x111111), 0);
    
    createLayout();
    createSensorCards();
    
    Serial.println("AnalyzeScreen: Analyze screen created successfully");
    return true;
}

void AnalyzeScreen::createLayout() {
    // Create title
    lv_obj_t* title_label = lv_label_create(screen);
    lv_label_set_text(title_label, "SENSOR ANALYSIS");
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(title_label, lv_color_hex(0xFFFFFF), 0);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 10);
    
    // Create back button
    back_btn = lv_btn_create(screen);
    lv_obj_set_size(back_btn, 80, 40);
    lv_obj_align(back_btn, LV_ALIGN_TOP_LEFT, 10, 10);
    lv_obj_add_event_cb(back_btn, on_back_clicked, LV_EVENT_CLICKED, this);
    
    lv_obj_t* back_label = lv_label_create(back_btn);
    lv_label_set_text(back_label, "BACK");
    lv_obj_center(back_label);
}

void AnalyzeScreen::createSensorCards() {
    // O2 Card (large, top center)
    o2_card = createSensorCard("OXYGEN", lv_color_hex(0x00FF00), 0, -120);
    lv_obj_set_size(o2_card, 360, 120);
    
    o2_value_label = lv_label_create(o2_card);
    lv_label_set_text(o2_value_label, "20.9");
    lv_obj_set_style_text_font(o2_value_label, &lv_font_montserrat_48, 0);
    lv_obj_set_style_text_color(o2_value_label, lv_color_hex(0x00FF00), 0);
    lv_obj_align(o2_value_label, LV_ALIGN_CENTER, -30, 10);
    
    o2_unit_label = lv_label_create(o2_card);
    lv_label_set_text(o2_unit_label, "%");
    lv_obj_set_style_text_font(o2_unit_label, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(o2_unit_label, lv_color_hex(0x888888), 0);
    lv_obj_align(o2_unit_label, LV_ALIGN_CENTER, 60, 10);
    
    // CO2 Card
    co2_card = createSensorCard("CO2", lv_color_hex(0xFFAA00), -280, 40);
    lv_obj_set_size(co2_card, 240, 100);
    
    co2_value_label = lv_label_create(co2_card);
    lv_label_set_text(co2_value_label, "400");
    lv_obj_set_style_text_font(co2_value_label, &lv_font_montserrat_32, 0);
    lv_obj_set_style_text_color(co2_value_label, lv_color_hex(0xFFAA00), 0);
    lv_obj_align(co2_value_label, LV_ALIGN_CENTER, -20, 5);
    
    co2_unit_label = lv_label_create(co2_card);
    lv_label_set_text(co2_unit_label, "ppm");
    lv_obj_set_style_text_font(co2_unit_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(co2_unit_label, lv_color_hex(0x888888), 0);
    lv_obj_align(co2_unit_label, LV_ALIGN_CENTER, 40, 5);
    
    // Temperature Card
    temp_card = createSensorCard("TEMP", lv_color_hex(0xFF6600), 0, 40);
    lv_obj_set_size(temp_card, 240, 100);
    
    temp_value_label = lv_label_create(temp_card);
    lv_label_set_text(temp_value_label, "22.5");
    lv_obj_set_style_text_font(temp_value_label, &lv_font_montserrat_32, 0);
    lv_obj_set_style_text_color(temp_value_label, lv_color_hex(0xFF6600), 0);
    lv_obj_align(temp_value_label, LV_ALIGN_CENTER, -20, 5);
    
    temp_unit_label = lv_label_create(temp_card);
    lv_label_set_text(temp_unit_label, "°C");
    lv_obj_set_style_text_font(temp_unit_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(temp_unit_label, lv_color_hex(0x888888), 0);
    lv_obj_align(temp_unit_label, LV_ALIGN_CENTER, 35, 5);
    
    // Pressure Card
    pressure_card = createSensorCard("PRESS", lv_color_hex(0x6600FF), 280, 40);
    lv_obj_set_size(pressure_card, 240, 100);
    
    pressure_value_label = lv_label_create(pressure_card);
    lv_label_set_text(pressure_value_label, "1.013");
    lv_obj_set_style_text_font(pressure_value_label, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(pressure_value_label, lv_color_hex(0x6600FF), 0);
    lv_obj_align(pressure_value_label, LV_ALIGN_CENTER, -20, 5);
    
    pressure_unit_label = lv_label_create(pressure_card);
    lv_label_set_text(pressure_unit_label, "bar");
    lv_obj_set_style_text_font(pressure_unit_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(pressure_unit_label, lv_color_hex(0x888888), 0);
    lv_obj_align(pressure_unit_label, LV_ALIGN_CENTER, 50, 5);
    
    // Humidity Card
    humidity_card = createSensorCard("HUMID", lv_color_hex(0x00AAFF), 0, 170);
    lv_obj_set_size(humidity_card, 240, 80);
    
    humidity_value_label = lv_label_create(humidity_card);
    lv_label_set_text(humidity_value_label, "45.0");
    lv_obj_set_style_text_font(humidity_value_label, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(humidity_value_label, lv_color_hex(0x00AAFF), 0);
    lv_obj_align(humidity_value_label, LV_ALIGN_CENTER, -20, 5);
    
    humidity_unit_label = lv_label_create(humidity_card);
    lv_label_set_text(humidity_unit_label, "%");
    lv_obj_set_style_text_font(humidity_unit_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(humidity_unit_label, lv_color_hex(0x888888), 0);
    lv_obj_align(humidity_unit_label, LV_ALIGN_CENTER, 30, 5);
}

lv_obj_t* AnalyzeScreen::createSensorCard(const char* title, lv_color_t color, int16_t x, int16_t y) {
    // Create card container
    lv_obj_t* card = lv_obj_create(screen);
    lv_obj_align(card, LV_ALIGN_CENTER, x, y);
    lv_obj_set_style_bg_color(card, lv_color_hex(0x222222), 0);
    lv_obj_set_style_border_width(card, 2, 0);
    lv_obj_set_style_border_color(card, color, 0);
    lv_obj_set_style_radius(card, 10, 0);
    
    // Create title label
    lv_obj_t* title_label = lv_label_create(card);
    lv_label_set_text(title_label, title);
    lv_obj_set_style_text_font(title_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(title_label, color, 0);
    lv_obj_align(title_label, LV_ALIGN_TOP_MID, 0, 5);
    
    return card;
}

void AnalyzeScreen::show() {
    if (screen) {
        lv_scr_load(screen);
        last_update = 0; // Force immediate update
    }
}

void AnalyzeScreen::hide() {
    // Screen is automatically hidden when another screen is loaded
}

void AnalyzeScreen::update() {
    unsigned long current_time = millis();
    
    // Update every 500ms for smooth display
    if (current_time - last_update >= 500) {
        updateSensorValues();
        updateAlarmStates();
        last_update = current_time;
    }
}

void AnalyzeScreen::updateSensorValues() {
    if (!app) return;
    
    SensorManager* sensors = app->getSensorManager();
    if (!sensors) return;
    
    // Update O2
    float o2 = sensors->getO2Percent();
    lv_label_set_text_fmt(o2_value_label, "%.1f", o2);
    
    // Update CO2
    float co2 = sensors->getCO2PPM();
    lv_label_set_text_fmt(co2_value_label, "%.0f", co2);
    
    // Update Temperature
    float temp = sensors->getTemperature();
    lv_label_set_text_fmt(temp_value_label, "%.1f", temp);
    
    // Update Pressure
    float pressure = sensors->getPressure();
    lv_label_set_text_fmt(pressure_value_label, "%.3f", pressure);
    
    // Update Humidity
    float humidity = sensors->getHumidity();
    lv_label_set_text_fmt(humidity_value_label, "%.1f", humidity);
}

void AnalyzeScreen::updateAlarmStates() {
    if (!app) return;
    
    SensorManager* sensors = app->getSensorManager();
    SettingsManager* settings = app->getSettingsManager();
    if (!sensors || !settings || !settings->getAlarmsEnabled()) return;
    
    // Check O2 alarms and update color
    float o2 = sensors->getO2Percent();
    float o2_min = settings->getO2MinAlarm();
    float o2_max = settings->getO2MaxAlarm();
    
    if (o2 < o2_min || o2 > o2_max) {
        lv_obj_set_style_text_color(o2_value_label, lv_color_hex(0xFF0000), 0); // Red
        lv_obj_set_style_border_color(o2_card, lv_color_hex(0xFF0000), 0);
    } else if (o2 < (o2_min + 1.0f) || o2 > (o2_max - 1.0f)) {
        lv_obj_set_style_text_color(o2_value_label, lv_color_hex(0xFFAA00), 0); // Orange
        lv_obj_set_style_border_color(o2_card, lv_color_hex(0xFFAA00), 0);
    } else {
        lv_obj_set_style_text_color(o2_value_label, lv_color_hex(0x00FF00), 0); // Green
        lv_obj_set_style_border_color(o2_card, lv_color_hex(0x00FF00), 0);
    }
    
    // Check CO2 alarms and update color
    float co2 = sensors->getCO2PPM();
    float co2_max = settings->getCO2MaxAlarm();
    
    if (co2 > co2_max) {
        lv_obj_set_style_text_color(co2_value_label, lv_color_hex(0xFF0000), 0); // Red
        lv_obj_set_style_border_color(co2_card, lv_color_hex(0xFF0000), 0);
    } else if (co2 > (co2_max * 0.8f)) {
        lv_obj_set_style_text_color(co2_value_label, lv_color_hex(0xFFAA00), 0); // Orange
        lv_obj_set_style_border_color(co2_card, lv_color_hex(0xFFAA00), 0);
    } else {
        lv_obj_set_style_text_color(co2_value_label, lv_color_hex(0xFFAA00), 0); // Normal orange
        lv_obj_set_style_border_color(co2_card, lv_color_hex(0xFFAA00), 0);
    }
}

// Event callbacks
void AnalyzeScreen::on_back_clicked(lv_event_t* e) {
    AnalyzeScreen* analyze = (AnalyzeScreen*)lv_event_get_user_data(e);
    if (analyze && analyze->app) {
        Serial.println("AnalyzeScreen: Back button clicked");
        analyze->app->showHome();
    }
}