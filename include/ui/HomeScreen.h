/*
 * HomeScreen.h
 * Home screen with menu cards for ESP32-S3 Trimix Analyzer
 */

#ifndef HOME_SCREEN_H
#define HOME_SCREEN_H

#include <Arduino.h>
#include <lvgl.h>

class TrimixApp;

class HomeScreen {
public:
    HomeScreen(TrimixApp* app);
    ~HomeScreen();
    
    bool create();
    void show();
    void hide();
    void update();
    
    lv_obj_t* getScreen() const { return screen; }

private:
    TrimixApp* app;
    lv_obj_t* screen;
    
    // Menu buttons
    lv_obj_t* analyze_btn;
    lv_obj_t* settings_btn;
    lv_obj_t* calibrate_btn;
    lv_obj_t* about_btn;
    
    // Title and status
    lv_obj_t* title_label;
    lv_obj_t* status_label;
    lv_obj_t* version_label;
    
    // Quick sensor display
    lv_obj_t* quick_o2_label;
    lv_obj_t* quick_temp_label;
    
    // Private methods
    void createLayout();
    void createMenuButtons();
    void createStatusDisplay();
    void updateQuickDisplay();
    
    // Event callbacks
    static void on_analyze_clicked(lv_event_t* e);
    static void on_settings_clicked(lv_event_t* e);
    static void on_calibrate_clicked(lv_event_t* e);
    static void on_about_clicked(lv_event_t* e);
};

#endif // HOME_SCREEN_H