#include "analyze_screen.h"
#include "screen_manager.h"
#include "sensor_interface.h"
#include "theme_manager.h"
#include "animation_manager.h"
#include "history_screen.h"
#include "main.h"
#include "arduino_compat.h"

AnalyzeScreen::AnalyzeScreen(ScreenManager* screenManager) 
    : BaseScreen("analyze", screenManager), sensorGrid(nullptr), 
      o2Card(nullptr), heCard(nullptr), n2Card(nullptr), co2Card(nullptr), coCard(nullptr),
      o2Label(nullptr), heLabel(nullptr), n2Label(nullptr), co2Label(nullptr), coLabel(nullptr),
      updateTimer(nullptr) {
    
    // Initialize sensor data
    currentData.o2_percentage = 0.0f;
    currentData.he_percentage = 0.0f;
    currentData.n2_percentage = 0.0f;
    currentData.co2_ppm = 0.0f;
    currentData.co_ppm = 0.0f;
}

AnalyzeScreen::~AnalyzeScreen() {
    if (updateTimer != nullptr) {
        lv_timer_del(updateTimer);
    }
}

void AnalyzeScreen::create() {
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
    createNavBar("Trimix Analyzer", true);
    
    // Create sensor grid
    sensorGrid = lv_obj_create(screenObj);
    lv_obj_set_size(sensorGrid, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(sensorGrid, 10, 60);
    lv_obj_clear_flag(sensorGrid, LV_OBJ_FLAG_SCROLLABLE);
    
    // Grid styling
    lv_obj_remove_style_all(sensorGrid);
    lv_obj_set_style_bg_opa(sensorGrid, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(sensorGrid, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(sensorGrid, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(sensorGrid, LV_FLEX_FLOW_ROW_WRAP);
    lv_obj_set_flex_align(sensorGrid, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_SPACE_EVENLY);
    lv_obj_set_style_pad_gap(sensorGrid, 8, LV_PART_MAIN);
    
    // Create sensor cards
    o2Card = createSensorCard("O2", &o2Label);
    heCard = createSensorCard("He", &heLabel);
    n2Card = createSensorCard("N2", &n2Label);
    co2Card = createSensorCard("CO2", &co2Label);
    coCard = createSensorCard("CO", &coLabel);
    
    // Create save button
    saveButton = lv_btn_create(screenObj);
    lv_obj_set_size(saveButton, 120, 40);
    lv_obj_set_pos(saveButton, (LV_HOR_RES - 120) / 2, LV_VER_RES - 50);
    lv_obj_set_style_bg_color(saveButton, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_radius(saveButton, 5, LV_PART_MAIN);
    lv_obj_add_event_cb(saveButton, saveButtonCallback, LV_EVENT_CLICKED, this);
    
    lv_obj_t* saveLabel = lv_label_create(saveButton);
    lv_label_set_text(saveLabel, "Save Analysis");
    lv_obj_set_style_text_color(saveLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(saveLabel);
}

void AnalyzeScreen::onEnter() {
    BaseScreen::onEnter();
    
    // Smooth entrance animation
    AnimationManager::fadeIn(screenObj, 300);
    AnimationManager::scaleIn(sensorGrid, 400);
    
    // Start update timer with optimized interval
    updateTimer = lv_timer_create(updateTimerCallback, 1500, this); // Slightly slower for battery life
    
    // Initial update with animation
    updateSensorData();
}

void AnalyzeScreen::onExit() {
    BaseScreen::onExit();
    
    // Stop update timer
    if (updateTimer != nullptr) {
        lv_timer_del(updateTimer);
        updateTimer = nullptr;
    }
}

void AnalyzeScreen::update() {
    BaseScreen::update();
    updateSensorData();
}

lv_obj_t* AnalyzeScreen::createSensorCard(const char* title, lv_obj_t** valueLabel) {
    lv_obj_t* card = lv_obj_create(sensorGrid);
    lv_obj_set_size(card, (LV_HOR_RES - 40) / 2, 80);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    
    // Apply premium theme
    ThemeManager::applySensorCardStyle(card);
    
    // Title label with premium styling
    lv_obj_t* titleLabel = lv_label_create(card);
    lv_label_set_text(titleLabel, title);
    ThemeManager::applyLabelStyle(titleLabel);
    lv_obj_set_style_text_font(titleLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(titleLabel, 10, 8);
    
    // Value label with dynamic styling
    *valueLabel = lv_label_create(card);
    lv_label_set_text(*valueLabel, "--");
    lv_obj_set_style_text_font(*valueLabel, &lv_font_montserrat_16, LV_PART_MAIN);
    lv_obj_set_pos(*valueLabel, 10, 32);
    
    // Add click event with feedback
    lv_obj_add_event_cb(card, sensorCardCallback, LV_EVENT_CLICKED, this);
    lv_obj_add_flag(card, LV_OBJ_FLAG_CLICKABLE);
    
    // Add entrance animation
    AnimationManager::bounceIn(card, 300 + (rand() % 200)); // Staggered animation
    
    return card;
}

void AnalyzeScreen::updateSensorData() {
    if (sensorInterface != nullptr) {
        SensorReadings readings = sensorInterface->getReadings();
        
        if (readings.isValid) {
            // Store previous values for smooth animation
            float prevO2 = currentData.o2_percentage;
            float prevHe = currentData.he_percentage;
            float prevN2 = currentData.n2_percentage;
            float prevCO2 = currentData.co2_ppm;
            float prevCO = currentData.co_ppm;
            
            // Update current data
            currentData.o2_percentage = readings.o2;
            currentData.he_percentage = readings.he;
            currentData.n2_percentage = readings.n2;
            currentData.co2_ppm = readings.co2;
            currentData.co_ppm = readings.co;
            
            // Animate value changes for smooth updates
            if (abs(prevO2 - currentData.o2_percentage) > 0.1f) {
                AnimationManager::animateValueChange(o2Label, prevO2, currentData.o2_percentage, "%.1f%%");
            }
            if (abs(prevHe - currentData.he_percentage) > 0.1f) {
                AnimationManager::animateValueChange(heLabel, prevHe, currentData.he_percentage, "%.1f%%");
            }
            if (abs(prevN2 - currentData.n2_percentage) > 0.1f) {
                AnimationManager::animateValueChange(n2Label, prevN2, currentData.n2_percentage, "%.1f%%");
            }
            if (abs(prevCO2 - currentData.co2_ppm) > 10.0f) {
                AnimationManager::animateValueChange(co2Label, prevCO2, currentData.co2_ppm, "%.0f ppm");
            }
            if (abs(prevCO - currentData.co_ppm) > 1.0f) {
                AnimationManager::animateValueChange(coLabel, prevCO, currentData.co_ppm, "%.0f ppm");
            }
            
            // Update colors with smooth transitions
            updateSensorColors();
            
        } else {
            // Show error state with warning style
            const char* errorText = "ERR";
            lv_label_set_text(o2Label, errorText);
            lv_label_set_text(heLabel, errorText);
            lv_label_set_text(n2Label, errorText);
            lv_label_set_text(co2Label, errorText);
            lv_label_set_text(coLabel, errorText);
            
            // Apply error styling
            ThemeManager::applyDangerStyle(o2Label);
            ThemeManager::applyDangerStyle(heLabel);
            ThemeManager::applyDangerStyle(n2Label);
            ThemeManager::applyDangerStyle(co2Label);
            ThemeManager::applyDangerStyle(coLabel);
        }
    }
}

void AnalyzeScreen::updateSensorColors() {
    // O2 color coding with smooth transitions
    lv_color_t o2Color;
    if (currentData.o2_percentage > 22.0f) {
        o2Color = ThemeManager::WARNING_COLOR;
    } else if (currentData.o2_percentage < 18.0f) {
        o2Color = ThemeManager::DANGER_COLOR;
    } else {
        o2Color = ThemeManager::SUCCESS_COLOR;
    }
    ThemeManager::animateColorChange(o2Label, o2Color);
    
    // CO2 color coding
    lv_color_t co2Color;
    if (currentData.co2_ppm > 1000.0f) {
        co2Color = ThemeManager::DANGER_COLOR;
        AnimationManager::pulseEffect(co2Label, 1000); // Pulse for danger
    } else if (currentData.co2_ppm > 800.0f) {
        co2Color = ThemeManager::WARNING_COLOR;
    } else {
        co2Color = ThemeManager::SUCCESS_COLOR;
        AnimationManager::stopAllAnimations(co2Label); // Stop pulsing
    }
    ThemeManager::animateColorChange(co2Label, co2Color);
    
    // CO color coding
    lv_color_t coColor;
    if (currentData.co_ppm > 35.0f) {
        coColor = ThemeManager::DANGER_COLOR;
        AnimationManager::pulseEffect(coLabel, 1000); // Pulse for danger
    } else if (currentData.co_ppm > 25.0f) {
        coColor = ThemeManager::WARNING_COLOR;
    } else {
        coColor = ThemeManager::SUCCESS_COLOR;
        AnimationManager::stopAllAnimations(coLabel); // Stop pulsing
    }
    ThemeManager::animateColorChange(coLabel, coColor);
    
    // He and N2 typically use standard colors
    ThemeManager::animateColorChange(heLabel, ThemeManager::SUCCESS_COLOR);
    ThemeManager::animateColorChange(n2Label, ThemeManager::SUCCESS_COLOR);
}

void AnalyzeScreen::updateTimerCallback(lv_timer_t* timer) {
    AnalyzeScreen* screen = static_cast<AnalyzeScreen*>(timer->user_data);
    if (screen != nullptr) {
        screen->updateSensorData();
    }
}

void AnalyzeScreen::sensorCardCallback(lv_event_t* e) {
    AnalyzeScreen* screen = static_cast<AnalyzeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        Serial.println("Sensor card clicked - detail view not implemented yet");
    }
}

void AnalyzeScreen::saveButtonCallback(lv_event_t* e) {
    AnalyzeScreen* screen = static_cast<AnalyzeScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->saveCurrentAnalysis();
    }
}

void AnalyzeScreen::saveCurrentAnalysis() {
    // Get the history screen from screen manager
    HistoryScreen* historyScreen = static_cast<HistoryScreen*>(manager->getScreen("history"));
    if (historyScreen != nullptr) {
        // Save current analysis to history
        historyScreen->addRecord(
            currentData.o2_percentage,
            currentData.he_percentage,
            currentData.n2_percentage,
            currentData.co2_ppm,
            currentData.co_ppm
        );
        
        // Show confirmation message
        lv_obj_t* msgbox = lv_msgbox_create(NULL, "Analysis Saved", 
                                           "Analysis has been saved to history", 
                                           NULL, true);
        lv_obj_center(msgbox);
        
        // Auto-close after 2 seconds
        lv_timer_create([](lv_timer_t* timer) {
            lv_obj_del(static_cast<lv_obj_t*>(timer->user_data));
            lv_timer_del(timer);
        }, 2000, msgbox);
        
        Serial.println("Analysis saved to history");
    } else {
        Serial.println("History screen not found");
    }
}
