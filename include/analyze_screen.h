#ifndef ANALYZE_SCREEN_H
#define ANALYZE_SCREEN_H

#include "base_screen.h"

struct SensorData {
    float o2_percentage;
    float he_percentage;
    float n2_percentage;
    float co2_ppm;
    float co_ppm;
};

class AnalyzeScreen : public BaseScreen {
private:
    lv_obj_t* sensorGrid;
    lv_obj_t* o2Card;
    lv_obj_t* heCard;
    lv_obj_t* n2Card;
    lv_obj_t* co2Card;
    lv_obj_t* coCard;
    
    lv_obj_t* o2Label;
    lv_obj_t* heLabel;
    lv_obj_t* n2Label;
    lv_obj_t* co2Label;
    lv_obj_t* coLabel;
    
    lv_obj_t* saveButton;
    lv_timer_t* updateTimer;
    SensorData currentData;

public:
    AnalyzeScreen(ScreenManager* screenManager);
    ~AnalyzeScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    void update() override;
    
private:
    lv_obj_t* createSensorCard(const char* title, lv_obj_t** valueLabel);
    void updateSensorData();
    void updateSensorColors();
    void saveCurrentAnalysis();
    static void updateTimerCallback(lv_timer_t* timer);
    static void sensorCardCallback(lv_event_t* e);
    static void saveButtonCallback(lv_event_t* e);
};

#endif // ANALYZE_SCREEN_H
