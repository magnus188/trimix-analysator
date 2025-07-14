#ifndef ABOUT_SCREEN_H
#define ABOUT_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"

class AboutScreen : public BaseScreen {
private:
    lv_obj_t* versionLabel;
    lv_obj_t* buildDateLabel;
    lv_obj_t* espInfoLabel;
    lv_obj_t* memoryLabel;
    lv_obj_t* uptimeLabel;
    lv_obj_t* storageLabel;
    lv_obj_t* sensorStatusLabel;
    lv_obj_t* exportButton;
    lv_obj_t* resetButton;
    lv_obj_t* creditsText;
    
    StorageManager* storage;
    lv_timer_t* updateTimer;

public:
    AboutScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~AboutScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void updateSystemInfo();
    void exportSystemInfo();
    void factoryReset();
    void showCredits();
    
    static void exportCallback(lv_event_t* e);
    static void resetCallback(lv_event_t* e);
    static void updateTimerCallback(lv_timer_t* timer);
};

#endif // ABOUT_SCREEN_H
