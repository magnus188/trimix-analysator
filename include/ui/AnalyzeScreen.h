/*
 * AnalyzeScreen.h
 * Real-time sensor display screen for ESP32-S3 Trimix Analyzer
 */

#ifndef ANALYZE_SCREEN_H
#define ANALYZE_SCREEN_H

#include <Arduino.h>
#include <lvgl.h>

class TrimixApp;

class AnalyzeScreen {
public:
    AnalyzeScreen(TrimixApp* app);
    ~AnalyzeScreen();
    
    bool create();
    void show();
    void hide();
    void update();
    
    lv_obj_t* getScreen() const { return screen; }

private:
    TrimixApp* app;
    lv_obj_t* screen;
    
    // Back button
    lv_obj_t* back_btn;
    
    // Sensor display cards
    lv_obj_t* o2_card;
    lv_obj_t* co2_card;
    lv_obj_t* temp_card;
    lv_obj_t* pressure_card;
    lv_obj_t* humidity_card;
    
    // Sensor value labels
    lv_obj_t* o2_value_label;
    lv_obj_t* o2_unit_label;
    lv_obj_t* co2_value_label;
    lv_obj_t* co2_unit_label;
    lv_obj_t* temp_value_label;
    lv_obj_t* temp_unit_label;
    lv_obj_t* pressure_value_label;
    lv_obj_t* pressure_unit_label;
    lv_obj_t* humidity_value_label;
    lv_obj_t* humidity_unit_label;
    
    // Chart for trends (optional)
    lv_obj_t* trend_chart;
    lv_chart_series_t* o2_series;
    
    // Update timer
    unsigned long last_update;
    
    // Private methods
    void createLayout();
    void createSensorCards();
    void createTrendChart();
    lv_obj_t* createSensorCard(const char* title, lv_color_t color, int16_t x, int16_t y);
    void updateSensorValues();
    void updateAlarmStates();
    
    // Event callbacks
    static void on_back_clicked(lv_event_t* e);
};

#endif // ANALYZE_SCREEN_H