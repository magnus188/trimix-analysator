#ifndef WIFI_SETTINGS_SCREEN_H
#define WIFI_SETTINGS_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"
#include <vector>
#include <string>

struct WiFiNetwork {
    std::string ssid;
    int32_t rssi;
    wifi_auth_mode_t authMode;
    bool connected;
};

class WiFiSettingsScreen : public BaseScreen {
private:
    lv_obj_t* networkList;
    lv_obj_t* scanButton;
    lv_obj_t* statusLabel;
    lv_obj_t* connectButton;
    lv_obj_t* passwordInput;
    lv_obj_t* ssidInput;
    lv_obj_t* currentConnectionLabel;
    
    std::vector<WiFiNetwork> networks;
    std::string selectedSSID;
    StorageManager* storage;
    lv_timer_t* scanTimer;
    bool scanning;

public:
    WiFiSettingsScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~WiFiSettingsScreen();
    
    void create() override;
    void onEnter() override;
    void onExit() override;
    
private:
    void scanNetworks();
    void refreshNetworkList();
    void connectToNetwork(const std::string& ssid, const std::string& password);
    void disconnectFromNetwork();
    lv_obj_t* createNetworkItem(const WiFiNetwork& network);
    void updateConnectionStatus();
    void loadSavedCredentials();
    void saveCredentials(const std::string& ssid, const std::string& password);
    
    static void scanButtonCallback(lv_event_t* e);
    static void connectButtonCallback(lv_event_t* e);
    static void networkItemCallback(lv_event_t* e);
    static void scanTimerCallback(lv_timer_t* timer);
    static void disconnectButtonCallback(lv_event_t* e);
};

#endif // WIFI_SETTINGS_SCREEN_H
