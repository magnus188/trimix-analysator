#ifndef CALIBRATION_SCREEN_H
#define CALIBRATION_SCREEN_H

#include "base_screen.h"

class CalibrationScreen : public BaseScreen {
private:
    lv_obj_t* o2Section;
    lv_obj_t* heSection;
    lv_obj_t* o2CurrentLabel;
    lv_obj_t* heCurrentLabel;
    lv_obj_t* o2RefInput;
    lv_obj_t* heRefInput;
    lv_obj_t* o2CalibrateBtn;
    lv_obj_t* heCalibrateBtn;
    lv_obj_t* resetBtn;
    lv_timer_t* updateTimer;

public:
    CalibrationScreen(ScreenManager* screenManager);
    ~CalibrationScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void updateCurrentReadings();
    lv_obj_t* createCalibrationSection(const char* title, lv_obj_t** currentLabel, 
                                      lv_obj_t** refInput, lv_obj_t** calibrateBtn);
    static void updateTimerCallback(lv_timer_t* timer);
    static void o2CalibrateCallback(lv_event_t* e);
    static void heCalibrateCallback(lv_event_t* e);
    static void resetCallback(lv_event_t* e);
    void showCalibrationResult(const char* sensor, bool success);
};

#endif // CALIBRATION_SCREEN_H
