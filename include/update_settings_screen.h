#ifndef UPDATE_SETTINGS_SCREEN_H
#define UPDATE_SETTINGS_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"
#include <string>

class UpdateSettingsScreen : public BaseScreen {
private:
    lv_obj_t* versionLabel;
    lv_obj_t* currentVersionLabel;
    lv_obj_t* checkUpdateButton;
    lv_obj_t* updateButton;
    lv_obj_t* progressBar;
    lv_obj_t* statusLabel;
    lv_obj_t* changelogText;
    lv_obj_t* autoUpdateSwitch;
    
    StorageManager* storage;
    std::string currentVersion;
    std::string latestVersion;
    std::string updateUrl;
    std::string changelog;
    bool updateAvailable;
    bool updating;

public:
    UpdateSettingsScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~UpdateSettingsScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void checkForUpdates();
    void downloadUpdate();
    void installUpdate();
    void showUpdateProgress(int progress);
    void updateUI();
    void loadSettings();
    void saveSettings();
    
    static void checkUpdateCallback(lv_event_t* e);
    static void updateCallback(lv_event_t* e);
    static void autoUpdateCallback(lv_event_t* e);
    static void updateProgressCallback(int progress);
};

#endif // UPDATE_SETTINGS_SCREEN_H
