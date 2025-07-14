#ifndef SCREEN_MANAGER_H
#define SCREEN_MANAGER_H

#include <lvgl.h>
#include <map>
#include <string>

class BaseScreen;
class StorageManager;

class ScreenManager {
private:
    std::map<std::string, BaseScreen*> screens;
    BaseScreen* currentScreen;
    lv_obj_t* mainContainer;
    StorageManager* storage;

public:
    ScreenManager(StorageManager* storageManager);
    ~ScreenManager();
    
    void init();
    void addScreen(const std::string& name, BaseScreen* screen);
    void setCurrentScreen(const std::string& name);
    BaseScreen* getCurrentScreen();
    BaseScreen* getScreen(const std::string& name);
    lv_obj_t* getMainContainer();
    StorageManager* getStorage();
};

#endif // SCREEN_MANAGER_H
