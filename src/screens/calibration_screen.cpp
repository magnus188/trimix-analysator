#include "calibration_screen.h"
#include "screen_manager.h"
#include "sensor_interface.h"
#include "main.h"
#include "arduino_compat.h"

CalibrationScreen::CalibrationScreen(ScreenManager* screenManager) 
    : BaseScreen("calibration", screenManager), 
      o2Section(nullptr), heSection(nullptr), 
      o2CurrentLabel(nullptr), heCurrentLabel(nullptr),
      o2RefInput(nullptr), heRefInput(nullptr),
      o2CalibrateBtn(nullptr), heCalibrateBtn(nullptr), resetBtn(nullptr),
      updateTimer(nullptr) {
}

CalibrationScreen::~CalibrationScreen() {
    if (updateTimer != nullptr) {
        lv_timer_del(updateTimer);
    }
}

void CalibrationScreen::create() {
    // Create main screen container
    screenObj = lv_obj_create(manager->getMainContainer());
    lv_obj_set_size(screenObj, LV_HOR_RES, LV_VER_RES);
    lv_obj_set_pos(screenObj, 0, 0);
    lv_obj_clear_flag(screenObj, LV_OBJ_FLAG_SCROLLABLE);
    
    // Remove default styling
    lv_obj_remove_style_all(screenObj);
    lv_obj_set_style_bg_color(screenObj, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(screenObj, LV_OPA_COVER, LV_PART_MAIN);
    
    // Create navigation bar with back button
    createNavBar("Calibration", true);
    
    // Create main content container
    lv_obj_t* content = lv_obj_create(screenObj);
    lv_obj_set_size(content, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(content, 10, 60);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_remove_style_all(content);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(content, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(content, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_gap(content, 20, LV_PART_MAIN);
    
    // Instructions label
    lv_obj_t* instructionsLabel = lv_label_create(content);
    lv_label_set_text(instructionsLabel, "Connect reference gas and enter known values");
    lv_obj_set_style_text_color(instructionsLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_style_text_font(instructionsLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_label_set_long_mode(instructionsLabel, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(instructionsLabel, LV_HOR_RES - 40);
    
    // O2 calibration section
    o2Section = createCalibrationSection("O2 Calibration", &o2CurrentLabel, &o2RefInput, &o2CalibrateBtn);
    lv_obj_set_parent(o2Section, content);
    
    // He calibration section
    heSection = createCalibrationSection("He Calibration", &heCurrentLabel, &heRefInput, &heCalibrateBtn);
    lv_obj_set_parent(heSection, content);
    
    // Add event callbacks
    lv_obj_add_event_cb(o2CalibrateBtn, o2CalibrateCallback, LV_EVENT_CLICKED, this);
    lv_obj_add_event_cb(heCalibrateBtn, heCalibrateCallback, LV_EVENT_CLICKED, this);
    
    // Reset button
    resetBtn = lv_btn_create(content);
    lv_obj_set_size(resetBtn, 150, 40);
    lv_obj_set_style_bg_color(resetBtn, lv_color_hex(0xFF5722), LV_PART_MAIN);
    lv_obj_set_style_radius(resetBtn, 5, LV_PART_MAIN);
    
    lv_obj_t* resetLabel = lv_label_create(resetBtn);
    lv_label_set_text(resetLabel, "Reset to Defaults");
    lv_obj_set_style_text_color(resetLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(resetLabel);
    
    lv_obj_add_event_cb(resetBtn, resetCallback, LV_EVENT_CLICKED, this);
}

void CalibrationScreen::onEnter() {
    BaseScreen::onEnter();
    
    // Start update timer
    updateTimer = lv_timer_create(updateTimerCallback, 1000, this);
    
    // Initial update
    updateCurrentReadings();
}

void CalibrationScreen::onExit() {
    BaseScreen::onExit();
    
    // Stop update timer
    if (updateTimer != nullptr) {
        lv_timer_del(updateTimer);
        updateTimer = nullptr;
    }
}

lv_obj_t* CalibrationScreen::createCalibrationSection(const char* title, lv_obj_t** currentLabel, 
                                                     lv_obj_t** refInput, lv_obj_t** calibrateBtn) {
    lv_obj_t* section = lv_obj_create(lv_scr_act());
    lv_obj_set_size(section, LV_HOR_RES - 40, 120);
    lv_obj_clear_flag(section, LV_OBJ_FLAG_SCROLLABLE);
    
    // Section styling
    lv_obj_set_style_bg_color(section, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(section, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_color(section, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_width(section, 1, LV_PART_MAIN);
    lv_obj_set_style_radius(section, 8, LV_PART_MAIN);
    lv_obj_set_style_pad_all(section, 15, LV_PART_MAIN);
    
    // Title
    lv_obj_t* titleLabel = lv_label_create(section);
    lv_label_set_text(titleLabel, title);
    lv_obj_set_style_text_color(titleLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_set_pos(titleLabel, 0, 0);
    
    // Current reading label
    *currentLabel = lv_label_create(section);
    lv_label_set_text(*currentLabel, "Current: --");
    lv_obj_set_style_text_color(*currentLabel, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_text_font(*currentLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(*currentLabel, 0, 25);
    
    // Reference value input
    *refInput = lv_textarea_create(section);
    lv_obj_set_size(*refInput, 80, 30);
    lv_obj_set_pos(*refInput, 0, 50);
    lv_textarea_set_one_line(*refInput, true);
    lv_textarea_set_text(*refInput, "20.9");
    lv_textarea_set_placeholder_text(*refInput, "0.0");
    
    // Input styling
    lv_obj_set_style_bg_color(*refInput, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_color(*refInput, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_border_width(*refInput, 2, LV_PART_MAIN);
    lv_obj_set_style_radius(*refInput, 3, LV_PART_MAIN);
    lv_obj_set_style_text_color(*refInput, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    
    // Unit label
    lv_obj_t* unitLabel = lv_label_create(section);
    lv_label_set_text(unitLabel, "%");
    lv_obj_set_style_text_color(unitLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_pos(unitLabel, 90, 55);
    
    // Calibrate button
    *calibrateBtn = lv_btn_create(section);
    lv_obj_set_size(*calibrateBtn, 80, 30);
    lv_obj_set_pos(*calibrateBtn, 120, 50);
    lv_obj_set_style_bg_color(*calibrateBtn, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_radius(*calibrateBtn, 3, LV_PART_MAIN);
    
    lv_obj_t* btnLabel = lv_label_create(*calibrateBtn);
    lv_label_set_text(btnLabel, "Calibrate");
    lv_obj_set_style_text_color(btnLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(btnLabel);
    
    return section;
}

void CalibrationScreen::updateCurrentReadings() {
    if (sensorInterface != nullptr) {
        SensorReadings readings = sensorInterface->getReadings();
        
        if (readings.isValid) {
            lv_label_set_text_fmt(o2CurrentLabel, "Current: %.1f%%", readings.o2);
            lv_label_set_text_fmt(heCurrentLabel, "Current: %.1f%%", readings.he);
        } else {
            lv_label_set_text(o2CurrentLabel, "Current: ERR");
            lv_label_set_text(heCurrentLabel, "Current: ERR");
        }
    }
}

void CalibrationScreen::updateTimerCallback(lv_timer_t* timer) {
    CalibrationScreen* screen = static_cast<CalibrationScreen*>(timer->user_data);
    if (screen != nullptr) {
        screen->updateCurrentReadings();
    }
}

void CalibrationScreen::o2CalibrateCallback(lv_event_t* e) {
    CalibrationScreen* screen = static_cast<CalibrationScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr && sensorInterface != nullptr) {
        const char* refText = lv_textarea_get_text(screen->o2RefInput);
        float refValue = atof(refText);
        
        if (refValue > 0.0f && refValue <= 100.0f) {
            sensorInterface->calibrateO2(refValue);
            screen->showCalibrationResult("O2", true);
        } else {
            screen->showCalibrationResult("O2", false);
        }
    }
}

void CalibrationScreen::heCalibrateCallback(lv_event_t* e) {
    CalibrationScreen* screen = static_cast<CalibrationScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr && sensorInterface != nullptr) {
        const char* refText = lv_textarea_get_text(screen->heRefInput);
        float refValue = atof(refText);
        
        if (refValue >= 0.0f && refValue <= 100.0f) {
            sensorInterface->calibrateHe(refValue);
            screen->showCalibrationResult("He", true);
        } else {
            screen->showCalibrationResult("He", false);
        }
    }
}

void CalibrationScreen::resetCallback(lv_event_t* e) {
    CalibrationScreen* screen = static_cast<CalibrationScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr && sensorInterface != nullptr) {
        sensorInterface->resetCalibration();
        screen->showCalibrationResult("All sensors", true);
    }
}

void CalibrationScreen::showCalibrationResult(const char* sensor, bool success) {
    // Create a simple message box
    lv_obj_t* msgbox = lv_msgbox_create(NULL, "Calibration Result", 
                                       success ? "Calibration successful" : "Calibration failed", 
                                       NULL, true);
    lv_obj_center(msgbox);
    
    // Auto-close after 2 seconds
    lv_timer_create([](lv_timer_t* timer) {
        lv_obj_del(static_cast<lv_obj_t*>(timer->user_data));
        lv_timer_del(timer);
    }, 2000, msgbox);
}
