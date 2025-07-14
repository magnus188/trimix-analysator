#include "update_settings_screen.h"
#include "screen_manager.h"
#include "theme_manager.h"
#include "ota_update_manager.h"
#include "version.h"
#include "arduino_compat.h"

// Replace with your GitHub repo
#define GITHUB_REPO "magnus188/trimix-analysator"

UpdateSettingsScreen::UpdateSettingsScreen(ScreenManager* screenManager, StorageManager* storageManager) 
    : BaseScreen("update_settings", screenManager), 
      versionLabel(nullptr), currentVersionLabel(nullptr), checkUpdateButton(nullptr),
      updateButton(nullptr), progressBar(nullptr), statusLabel(nullptr), 
      changelogText(nullptr), autoUpdateSwitch(nullptr),
      storage(storageManager), currentVersion(FIRMWARE_VERSION),
      updateAvailable(false), updating(false) {
}

UpdateSettingsScreen::~UpdateSettingsScreen() {
    // Objects will be cleaned up by LVGL when parent is deleted
}

void UpdateSettingsScreen::create() {
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
    createNavBar("Software Update", true);
    
    // Create main content container
    lv_obj_t* content = lv_obj_create(screenObj);
    lv_obj_set_size(content, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(content, 10, 60);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(content, 0, LV_PART_MAIN);
    
    // Current version section
    lv_obj_t* versionContainer = lv_obj_create(content);
    lv_obj_set_size(versionContainer, LV_HOR_RES - 40, 60);
    lv_obj_set_pos(versionContainer, 0, 0);
    lv_obj_set_style_bg_color(versionContainer, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_border_width(versionContainer, 1, LV_PART_MAIN);
    lv_obj_set_style_border_color(versionContainer, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_radius(versionContainer, 8, LV_PART_MAIN);
    
    lv_obj_t* versionTitle = lv_label_create(versionContainer);
    lv_label_set_text(versionTitle, "Current Version");
    lv_obj_set_style_text_color(versionTitle, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(versionTitle, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(versionTitle, 10, 8);
    
    currentVersionLabel = lv_label_create(versionContainer);
    lv_label_set_text(currentVersionLabel, currentVersion.c_str());
    lv_obj_set_style_text_color(currentVersionLabel, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_text_font(currentVersionLabel, &lv_font_montserrat_14, LV_PART_MAIN);
    lv_obj_set_pos(currentVersionLabel, 10, 30);
    
    // Check for updates button
    checkUpdateButton = lv_btn_create(content);
    lv_obj_set_size(checkUpdateButton, 120, 35);
    lv_obj_set_pos(checkUpdateButton, 0, 70);
    lv_obj_set_style_bg_color(checkUpdateButton, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_set_style_radius(checkUpdateButton, 5, LV_PART_MAIN);
    lv_obj_add_event_cb(checkUpdateButton, checkUpdateCallback, LV_EVENT_CLICKED, this);
    
    lv_obj_t* checkLabel = lv_label_create(checkUpdateButton);
    lv_label_set_text(checkLabel, "Check Updates");
    lv_obj_set_style_text_color(checkLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(checkLabel);
    
    // Auto-update switch
    lv_obj_t* autoUpdateContainer = lv_obj_create(content);
    lv_obj_set_size(autoUpdateContainer, LV_HOR_RES - 40, 40);
    lv_obj_set_pos(autoUpdateContainer, 0, 115);
    lv_obj_set_style_bg_opa(autoUpdateContainer, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(autoUpdateContainer, 0, LV_PART_MAIN);
    
    lv_obj_t* autoLabel = lv_label_create(autoUpdateContainer);
    lv_label_set_text(autoLabel, "Auto-check for updates");
    lv_obj_set_style_text_color(autoLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_pos(autoLabel, 0, 10);
    
    autoUpdateSwitch = lv_switch_create(autoUpdateContainer);
    lv_obj_set_size(autoUpdateSwitch, 50, 25);
    lv_obj_set_pos(autoUpdateSwitch, LV_HOR_RES - 90, 7);
    lv_obj_add_event_cb(autoUpdateSwitch, autoUpdateCallback, LV_EVENT_VALUE_CHANGED, this);
    
    // Status label
    statusLabel = lv_label_create(content);
    lv_label_set_text(statusLabel, "Ready to check for updates");
    lv_obj_set_style_text_color(statusLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_style_text_font(statusLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(statusLabel, 0, 165);
    
    // Progress bar (initially hidden)
    progressBar = lv_bar_create(content);
    lv_obj_set_size(progressBar, LV_HOR_RES - 40, 20);
    lv_obj_set_pos(progressBar, 0, 185);
    lv_obj_set_style_bg_color(progressBar, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_color(progressBar, lv_color_hex(0x4CAF50), LV_PART_INDICATOR);
    lv_obj_add_flag(progressBar, LV_OBJ_FLAG_HIDDEN);
    
    // Update button (initially hidden)
    updateButton = lv_btn_create(content);
    lv_obj_set_size(updateButton, 100, 35);
    lv_obj_set_pos(updateButton, 0, 215);
    lv_obj_set_style_bg_color(updateButton, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_radius(updateButton, 5, LV_PART_MAIN);
    lv_obj_add_event_cb(updateButton, updateCallback, LV_EVENT_CLICKED, this);
    lv_obj_add_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
    
    lv_obj_t* updateLabel = lv_label_create(updateButton);
    lv_label_set_text(updateLabel, "Install Update");
    lv_obj_set_style_text_color(updateLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(updateLabel);
    
    // Changelog text area (initially hidden)
    changelogText = lv_textarea_create(content);
    lv_obj_set_size(changelogText, LV_HOR_RES - 40, 80);
    lv_obj_set_pos(changelogText, 0, 260);
    lv_textarea_set_text(changelogText, "");
    lv_textarea_set_placeholder_text(changelogText, "Release notes will appear here...");
    lv_obj_set_style_bg_color(changelogText, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_text_color(changelogText, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_add_flag(changelogText, LV_OBJ_FLAG_HIDDEN);
}

void UpdateSettingsScreen::onEnter() {
    BaseScreen::onEnter();
    loadSettings();
    updateUI();
}

void UpdateSettingsScreen::onExit() {
    BaseScreen::onExit();
    saveSettings();
}

void UpdateSettingsScreen::checkForUpdates() {
    if (updating) return;
    
    lv_label_set_text(statusLabel, "Checking for updates...");
    
    // Create OTA manager
    OTAUpdateManager otaManager(GITHUB_REPO, currentVersion);
    
    // Set callbacks
    otaManager.setStatusCallback([this](const std::string& status) {
        lv_label_set_text(statusLabel, status.c_str());
    });
    
    GitHubRelease release;
    if (otaManager.checkForUpdates(release)) {
        if (otaManager.isUpdateAvailable(release)) {
            updateAvailable = true;
            latestVersion = release.version;
            updateUrl = release.downloadUrl;
            changelog = release.body;
            
            char versionText[100];
            snprintf(versionText, sizeof(versionText), "New version available: %s", latestVersion.c_str());
            lv_label_set_text(statusLabel, versionText);
            
            // Show update button and changelog
            lv_obj_clear_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_flag(changelogText, LV_OBJ_FLAG_HIDDEN);
            lv_textarea_set_text(changelogText, changelog.c_str());
        } else {
            lv_label_set_text(statusLabel, "You have the latest version");
            updateAvailable = false;
        }
    } else {
        lv_label_set_text(statusLabel, "Failed to check for updates");
    }
    
    updateUI();
}

void UpdateSettingsScreen::downloadUpdate() {
    if (!updateAvailable || updating) return;
    
    updating = true;
    lv_label_set_text(statusLabel, "Downloading update...");
    lv_obj_clear_flag(progressBar, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
    
    // Create OTA manager
    OTAUpdateManager otaManager(GITHUB_REPO, currentVersion);
    
    // Set callbacks
    otaManager.setStatusCallback([this](const std::string& status) {
        lv_label_set_text(statusLabel, status.c_str());
    });
    
    otaManager.setProgressCallback([this](int progress) {
        showUpdateProgress(progress);
    });
    
    otaManager.setCompleteCallback([this](bool success, const std::string& message) {
        updating = false;
        lv_label_set_text(statusLabel, message.c_str());
        
        if (success) {
            lv_obj_set_style_bg_color(progressBar, lv_color_hex(0x4CAF50), LV_PART_INDICATOR);
        } else {
            lv_obj_set_style_bg_color(progressBar, lv_color_hex(0xF44336), LV_PART_INDICATOR);
            lv_obj_clear_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
        }
    });
    
    // Create release object
    GitHubRelease release;
    release.version = latestVersion;
    release.downloadUrl = updateUrl;
    release.fileSize = 0; // Will be determined during download
    
    // Start download and installation
    otaManager.downloadAndInstall(release);
}

void UpdateSettingsScreen::showUpdateProgress(int progress) {
    lv_bar_set_value(progressBar, progress, LV_ANIM_ON);
    
    char progressText[50];
    snprintf(progressText, sizeof(progressText), "Downloading... %d%%", progress);
    lv_label_set_text(statusLabel, progressText);
}

void UpdateSettingsScreen::updateUI() {
    if (updateAvailable) {
        lv_obj_clear_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
        lv_obj_clear_flag(changelogText, LV_OBJ_FLAG_HIDDEN);
    } else {
        lv_obj_add_flag(updateButton, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(changelogText, LV_OBJ_FLAG_HIDDEN);
    }
    
    if (updating) {
        lv_obj_clear_flag(progressBar, LV_OBJ_FLAG_HIDDEN);
        lv_obj_add_flag(checkUpdateButton, LV_OBJ_FLAG_HIDDEN);
    } else {
        lv_obj_add_flag(progressBar, LV_OBJ_FLAG_HIDDEN);
        lv_obj_clear_flag(checkUpdateButton, LV_OBJ_FLAG_HIDDEN);
    }
}

void UpdateSettingsScreen::loadSettings() {
    if (storage) {
        bool autoUpdate = storage->loadBoolSetting("auto_update_check", false);
        if (autoUpdate) {
            lv_obj_add_state(autoUpdateSwitch, LV_STATE_CHECKED);
        } else {
            lv_obj_clear_state(autoUpdateSwitch, LV_STATE_CHECKED);
        }
    }
}

void UpdateSettingsScreen::saveSettings() {
    if (storage) {
        bool autoUpdate = lv_obj_has_state(autoUpdateSwitch, LV_STATE_CHECKED);
        storage->saveSetting("auto_update_check", autoUpdate);
    }
}

void UpdateSettingsScreen::checkUpdateCallback(lv_event_t* e) {
    UpdateSettingsScreen* screen = static_cast<UpdateSettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->checkForUpdates();
    }
}

void UpdateSettingsScreen::updateCallback(lv_event_t* e) {
    UpdateSettingsScreen* screen = static_cast<UpdateSettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->downloadUpdate();
    }
}

void UpdateSettingsScreen::autoUpdateCallback(lv_event_t* e) {
    UpdateSettingsScreen* screen = static_cast<UpdateSettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->saveSettings();
    }
}
