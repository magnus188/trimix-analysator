#ifndef BASE_SCREEN_H
#define BASE_SCREEN_H

#include <lvgl.h>
#include <string>

class ScreenManager;

class BaseScreen {
protected:
    lv_obj_t* screenObj;
    ScreenManager* manager;
    std::string name;
    bool isActive;

public:
    BaseScreen(const std::string& screenName, ScreenManager* screenManager);
    virtual ~BaseScreen();
    
    virtual void create() = 0;
    virtual void onEnter();
    virtual void onExit();
    virtual void update();
    
    lv_obj_t* getScreenObject();
    const std::string& getName() const;
    bool getIsActive() const;
    void setActive(bool active);
    
protected:
    void navigateToScreen(const std::string& screenName);
    lv_obj_t* createNavBar(const std::string& title, bool showBackButton = false);
    static void backButtonCallback(lv_event_t* e);
};

#endif // BASE_SCREEN_H
