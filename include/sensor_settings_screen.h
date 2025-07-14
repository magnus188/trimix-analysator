#ifndef SENSOR_SETTINGS_SCREEN_H
#define SENSOR_SETTINGS_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"

class SensorSettingsScreen : public BaseScreen {
private:
    lv_obj_t* o2OffsetInput;
    lv_obj_t* heOffsetInput;
    lv_obj_t* co2OffsetInput;
    lv_obj_t* coOffsetInput;
    lv_obj_t* samplingRateSlider;
    lv_obj_t* samplingRateLabel;
    lv_obj_t* filteringSlider;
    lv_obj_t* filteringLabel;
    lv_obj_t* calibrationDateLabel;
    lv_obj_t* resetButton;
    lv_obj_t* testButton;
    lv_obj_t* statusLabel;
    
    StorageManager* storage;
    float o2Offset;
    float heOffset;
    float co2Offset;
    float coOffset;
    int samplingRate;
    int filteringLevel;
    unsigned long lastCalibrationDate;

public:
    SensorSettingsScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~SensorSettingsScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void loadSettings();
    void saveSettings();
    void resetToDefaults();
    void testSensors();
    void updateSamplingRate(int value);
    void updateFilteringLevel(int value);
    void updateCalibrationDate();
    
    static void o2OffsetCallback(lv_event_t* e);
    static void heOffsetCallback(lv_event_t* e);
    static void co2OffsetCallback(lv_event_t* e);
    static void coOffsetCallback(lv_event_t* e);
    static void samplingRateCallback(lv_event_t* e);
    static void filteringCallback(lv_event_t* e);
    static void resetCallback(lv_event_t* e);
    static void testCallback(lv_event_t* e);
};

#endif // SENSOR_SETTINGS_SCREEN_H
