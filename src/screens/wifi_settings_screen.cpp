#include "wifi_settings_screen.h"
#include "screen_manager.h"
#include "theme_manager.h"
#include "main.h"
#include "arduino_compat.h"

WiFiSettingsScreen::WiFiSettingsScreen(ScreenManager* screenManager, StorageManager* storageManager) 
    : BaseScreen("wifi_settings", screenManager), networkList(nullptr), scanButton(nullptr),
      statusLabel(nullptr), connectButton(nullptr), passwordInput(nullptr), ssidInput(nullptr),
      currentConnectionLabel(nullptr), storage(storageManager), scanTimer(nullptr), scanning(false) {
}

WiFiSettingsScreen::~WiFiSettingsScreen() {
    if (scanTimer != nullptr) {
        lv_timer_del(scanTimer);
    }
}

void WiFiSettingsScreen::create() {
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
    createNavBar("WiFi Settings", true);
    
    // Create main content container
    lv_obj_t* content = lv_obj_create(screenObj);
    lv_obj_set_size(content, LV_HOR_RES - 20, LV_VER_RES - 70);
    lv_obj_set_pos(content, 10, 60);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(content, 0, LV_PART_MAIN);
    
    // Current connection status
    currentConnectionLabel = lv_label_create(content);
    lv_label_set_text(currentConnectionLabel, "Not connected");
    lv_obj_set_style_text_color(currentConnectionLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_pos(currentConnectionLabel, 0, 0);
    
    // Scan button
    scanButton = lv_btn_create(content);
    lv_obj_set_size(scanButton, 100, 35);
    lv_obj_set_pos(scanButton, 0, 30);
    lv_obj_set_style_bg_color(scanButton, lv_color_hex(0x2196F3), LV_PART_MAIN);
    lv_obj_add_event_cb(scanButton, scanButtonCallback, LV_EVENT_CLICKED, this);
    
    lv_obj_t* scanLabel = lv_label_create(scanButton);
    lv_label_set_text(scanLabel, "Scan");
    lv_obj_set_style_text_color(scanLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(scanLabel);
    
    // Status label
    statusLabel = lv_label_create(content);
    lv_label_set_text(statusLabel, "Ready to scan");
    lv_obj_set_style_text_color(statusLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_pos(statusLabel, 110, 37);
    
    // Network list
    networkList = lv_obj_create(content);
    lv_obj_set_size(networkList, LV_HOR_RES - 40, 150);
    lv_obj_set_pos(networkList, 0, 75);
    lv_obj_set_style_bg_color(networkList, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_border_width(networkList, 1, LV_PART_MAIN);
    lv_obj_set_style_border_color(networkList, lv_color_hex(0x616161), LV_PART_MAIN);
    
    // Connection controls
    lv_obj_t* connectionContainer = lv_obj_create(content);
    lv_obj_set_size(connectionContainer, LV_HOR_RES - 40, 100);
    lv_obj_set_pos(connectionContainer, 0, 235);
    lv_obj_set_style_bg_opa(connectionContainer, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(connectionContainer, 0, LV_PART_MAIN);
    
    // SSID input
    ssidInput = lv_textarea_create(connectionContainer);
    lv_obj_set_size(ssidInput, 150, 30);
    lv_obj_set_pos(ssidInput, 0, 0);
    lv_textarea_set_one_line(ssidInput, true);
    lv_textarea_set_placeholder_text(ssidInput, "Select network");
    
    // Password input
    passwordInput = lv_textarea_create(connectionContainer);
    lv_obj_set_size(passwordInput, 150, 30);
    lv_obj_set_pos(passwordInput, 0, 35);
    lv_textarea_set_one_line(passwordInput, true);
    lv_textarea_set_placeholder_text(passwordInput, "Password");
    lv_textarea_set_password_mode(passwordInput, true);
    
    // Connect button
    connectButton = lv_btn_create(connectionContainer);
    lv_obj_set_size(connectButton, 80, 30);
    lv_obj_set_pos(connectButton, 160, 17);
    lv_obj_set_style_bg_color(connectButton, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_add_event_cb(connectButton, connectButtonCallback, LV_EVENT_CLICKED, this);
    
    lv_obj_t* connectLabel = lv_label_create(connectButton);
    lv_label_set_text(connectLabel, "Connect");
    lv_obj_set_style_text_color(connectLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(connectLabel);
}

void WiFiSettingsScreen::onEnter() {
    BaseScreen::onEnter();
    loadSavedCredentials();
    updateConnectionStatus();
}

void WiFiSettingsScreen::onExit() {
    BaseScreen::onExit();
    if (scanTimer != nullptr) {
        lv_timer_del(scanTimer);
        scanTimer = nullptr;
    }
}

void WiFiSettingsScreen::scanNetworks() {
    if (scanning) return;
    
    scanning = true;
    lv_label_set_text(statusLabel, "Scanning...");
    lv_obj_clean(networkList);
    
    // Start WiFi scan
    WiFi.scanNetworks(true);
    
    // Start timer to check scan results
    scanTimer = lv_timer_create(scanTimerCallback, 500, this);
}

void WiFiSettingsScreen::refreshNetworkList() {
    int networkCount = WiFi.scanComplete();
    if (networkCount == WIFI_SCAN_FAILED) {
        lv_label_set_text(statusLabel, "Scan failed");
        scanning = false;
        return;
    }
    
    if (networkCount == WIFI_SCAN_RUNNING) {
        return; // Still scanning
    }
    
    // Scan completed
    scanning = false;
    if (scanTimer != nullptr) {
        lv_timer_del(scanTimer);
        scanTimer = nullptr;
    }
    
    networks.clear();
    lv_obj_clean(networkList);
    
    char statusText[50];
    snprintf(statusText, sizeof(statusText), "Found %d networks", networkCount);
    lv_label_set_text(statusLabel, statusText);
    
    for (int i = 0; i < networkCount; i++) {
        WiFiNetwork network;
        network.ssid = WiFi.SSID(i).c_str();
        network.rssi = WiFi.RSSI(i);
        network.authMode = WiFi.encryptionType(i);
        network.connected = (WiFi.status() == WL_CONNECTED && WiFi.SSID() == network.ssid);
        
        networks.push_back(network);
        createNetworkItem(network);
    }
    
    WiFi.scanDelete();
}

lv_obj_t* WiFiSettingsScreen::createNetworkItem(const WiFiNetwork& network) {
    lv_obj_t* item = lv_obj_create(networkList);
    lv_obj_set_size(item, LV_HOR_RES - 60, 40);
    lv_obj_set_style_bg_color(item, lv_color_hex(0x616161), LV_PART_MAIN);
    lv_obj_set_style_border_width(item, 1, LV_PART_MAIN);
    lv_obj_add_flag(item, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(item, networkItemCallback, LV_EVENT_CLICKED, this);
    
    // Store SSID as user data
    lv_obj_set_user_data(item, (void*)network.ssid.c_str());
    
    // SSID label
    lv_obj_t* ssidLabel = lv_label_create(item);
    lv_label_set_text(ssidLabel, network.ssid.c_str());
    lv_obj_set_style_text_color(ssidLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_pos(ssidLabel, 5, 5);
    
    // Signal strength
    char signalText[20];
    snprintf(signalText, sizeof(signalText), "%d dBm", network.rssi);
    lv_obj_t* signalLabel = lv_label_create(item);
    lv_label_set_text(signalLabel, signalText);
    lv_obj_set_style_text_color(signalLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_pos(signalLabel, 5, 20);
    
    // Security indicator
    const char* securityText = (network.authMode == WIFI_AUTH_OPEN) ? "Open" : "Secured";
    lv_obj_t* securityLabel = lv_label_create(item);
    lv_label_set_text(securityLabel, securityText);
    lv_obj_set_style_text_color(securityLabel, lv_color_hex(0xAAAAAA), LV_PART_MAIN);
    lv_obj_set_pos(securityLabel, LV_HOR_RES - 120, 12);
    
    // Connected indicator
    if (network.connected) {
        lv_obj_set_style_bg_color(item, lv_color_hex(0x4CAF50), LV_PART_MAIN);
        lv_obj_t* connectedLabel = lv_label_create(item);
        lv_label_set_text(connectedLabel, "Connected");
        lv_obj_set_style_text_color(connectedLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
        lv_obj_set_pos(connectedLabel, LV_HOR_RES - 180, 12);
    }
    
    return item;
}

void WiFiSettingsScreen::updateConnectionStatus() {
    if (WiFi.status() == WL_CONNECTED) {
        char statusText[100];
        snprintf(statusText, sizeof(statusText), "Connected to: %s (IP: %s)", 
                WiFi.SSID().c_str(), WiFi.localIP().toString().c_str());
        lv_label_set_text(currentConnectionLabel, statusText);
        lv_obj_set_style_text_color(currentConnectionLabel, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    } else {
        lv_label_set_text(currentConnectionLabel, "Not connected");
        lv_obj_set_style_text_color(currentConnectionLabel, lv_color_hex(0xF44336), LV_PART_MAIN);
    }
}

void WiFiSettingsScreen::connectToNetwork(const std::string& ssid, const std::string& password) {
    lv_label_set_text(statusLabel, "Connecting...");
    
    WiFi.begin(ssid.c_str(), password.c_str());
    
    // Save credentials
    saveCredentials(ssid, password);
    
    // Update status after connection attempt
    lv_timer_create([](lv_timer_t* timer) {
        WiFiSettingsScreen* screen = static_cast<WiFiSettingsScreen*>(timer->user_data);
        screen->updateConnectionStatus();
        lv_timer_del(timer);
    }, 3000, this);
}

void WiFiSettingsScreen::loadSavedCredentials() {
    if (storage) {
        std::string savedSSID = storage->loadStringSetting("wifi_ssid", "");
        std::string savedPassword = storage->loadStringSetting("wifi_password", "");
        
        if (!savedSSID.empty()) {
            lv_textarea_set_text(ssidInput, savedSSID.c_str());
        }
        if (!savedPassword.empty()) {
            lv_textarea_set_text(passwordInput, savedPassword.c_str());
        }
    }
}

void WiFiSettingsScreen::saveCredentials(const std::string& ssid, const std::string& password) {
    if (storage) {
        storage->saveSetting("wifi_ssid", ssid.c_str());
        storage->saveSetting("wifi_password", password.c_str());
    }
}

void WiFiSettingsScreen::scanButtonCallback(lv_event_t* e) {
    WiFiSettingsScreen* screen = static_cast<WiFiSettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->scanNetworks();
    }
}

void WiFiSettingsScreen::connectButtonCallback(lv_event_t* e) {
    WiFiSettingsScreen* screen = static_cast<WiFiSettingsScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        std::string ssid = lv_textarea_get_text(screen->ssidInput);
        std::string password = lv_textarea_get_text(screen->passwordInput);
        
        if (!ssid.empty()) {
            screen->connectToNetwork(ssid, password);
        }
    }
}

void WiFiSettingsScreen::networkItemCallback(lv_event_t* e) {
    WiFiSettingsScreen* screen = static_cast<WiFiSettingsScreen*>(lv_event_get_user_data(e));
    lv_obj_t* item = lv_event_get_target(e);
    
    if (screen != nullptr && item != nullptr) {
        const char* ssid = static_cast<const char*>(lv_obj_get_user_data(item));
        if (ssid != nullptr) {
            screen->selectedSSID = ssid;
            lv_textarea_set_text(screen->ssidInput, ssid);
            lv_textarea_set_text(screen->passwordInput, ""); // Clear password
        }
    }
}

void WiFiSettingsScreen::scanTimerCallback(lv_timer_t* timer) {
    WiFiSettingsScreen* screen = static_cast<WiFiSettingsScreen*>(timer->user_data);
    if (screen != nullptr) {
        screen->refreshNetworkList();
    }
}
