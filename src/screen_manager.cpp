#include "screen_manager.h"
#include "base_screen.h"
#include "arduino_compat.h"

ScreenManager::ScreenManager(StorageManager* storageManager) : currentScreen(nullptr), mainContainer(nullptr), storage(storageManager) {
}

ScreenManager::~ScreenManager() {
    for (auto& pair : screens) {
        delete pair.second;
    }
    screens.clear();
}

void ScreenManager::init() {
    // Create main container
    mainContainer = lv_obj_create(lv_scr_act());
    lv_obj_set_size(mainContainer, LV_HOR_RES, LV_VER_RES);
    lv_obj_set_pos(mainContainer, 0, 0);
    lv_obj_clear_flag(mainContainer, LV_OBJ_FLAG_SCROLLABLE);
    
    // Remove default styling
    lv_obj_remove_style_all(mainContainer);
    lv_obj_set_style_bg_color(mainContainer, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(mainContainer, LV_OPA_COVER, LV_PART_MAIN);
}

void ScreenManager::addScreen(const std::string& name, BaseScreen* screen) {
    if (screen != nullptr) {
        screens[name] = screen;
        screen->create();
        
        // Hide the screen initially
        lv_obj_add_flag(screen->getScreenObject(), LV_OBJ_FLAG_HIDDEN);
        
        Serial.print("Screen added: ");
        Serial.println(name.c_str());
    }
}

void ScreenManager::setCurrentScreen(const std::string& name) {
    auto it = screens.find(name);
    if (it != screens.end()) {
        // Hide current screen
        if (currentScreen != nullptr) {
            currentScreen->onExit();
            lv_obj_add_flag(currentScreen->getScreenObject(), LV_OBJ_FLAG_HIDDEN);
            currentScreen->setActive(false);
        }
        
        // Show new screen
        currentScreen = it->second;
        lv_obj_clear_flag(currentScreen->getScreenObject(), LV_OBJ_FLAG_HIDDEN);
        currentScreen->setActive(true);
        currentScreen->onEnter();
        
        Serial.print("Screen changed to: ");
        Serial.println(name.c_str());
    } else {
        Serial.print("Screen not found: ");
        Serial.println(name.c_str());
    }
}

BaseScreen* ScreenManager::getCurrentScreen() {
    return currentScreen;
}

BaseScreen* ScreenManager::getScreen(const std::string& name) {
    auto it = screens.find(name);
    return (it != screens.end()) ? it->second : nullptr;
}

lv_obj_t* ScreenManager::getMainContainer() {
    return mainContainer;
}

StorageManager* ScreenManager::getStorage() {
    return storage;
}
