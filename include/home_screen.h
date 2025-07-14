#ifndef HOME_SCREEN_H
#define HOME_SCREEN_H

#include "base_screen.h"

class HomeScreen : public BaseScreen {
private:
    lv_obj_t* menuGrid;
    lv_obj_t* analyzerCard;
    lv_obj_t* plannerCard;
    lv_obj_t* historyCard;
    lv_obj_t* settingsCard;

public:
    HomeScreen(ScreenManager* screenManager);
    ~HomeScreen();
    
    void create() override;
    void onEnter() override;
    
private:
    lv_obj_t* createMenuCard(const char* title, lv_event_cb_t callback);
    static void analyzerCardCallback(lv_event_t* e);
    static void plannerCardCallback(lv_event_t* e);
    static void historyCardCallback(lv_event_t* e);
    static void settingsCardCallback(lv_event_t* e);
    static void powerButtonCallback(lv_event_t* e);
};

#endif // HOME_SCREEN_H
