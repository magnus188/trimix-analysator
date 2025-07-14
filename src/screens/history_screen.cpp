#include "history_screen.h"
#include "screen_manager.h"
#include "arduino_compat.h"
#include <ctime>

HistoryScreen::HistoryScreen(ScreenManager* screenManager, StorageManager* storageManager) 
    : BaseScreen("history", screenManager), historyList(nullptr), 
      clearButton(nullptr), exportButton(nullptr), storage(storageManager) {
}

HistoryScreen::~HistoryScreen() {
    // Objects will be cleaned up by LVGL when parent is deleted
}

void HistoryScreen::create() {
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
    createNavBar("History", true);
    
    // Create button container
    lv_obj_t* buttonContainer = lv_obj_create(screenObj);
    lv_obj_set_size(buttonContainer, LV_HOR_RES - 20, 50);
    lv_obj_set_pos(buttonContainer, 10, 60);
    lv_obj_clear_flag(buttonContainer, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_remove_style_all(buttonContainer);
    lv_obj_set_style_bg_opa(buttonContainer, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(buttonContainer, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(buttonContainer, 0, LV_PART_MAIN);
    
    lv_obj_set_flex_flow(buttonContainer, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(buttonContainer, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_gap(buttonContainer, 10, LV_PART_MAIN);
    
    // Clear button
    clearButton = lv_btn_create(buttonContainer);
    lv_obj_set_size(clearButton, 100, 40);
    lv_obj_set_style_bg_color(clearButton, lv_color_hex(0xF44336), LV_PART_MAIN);
    lv_obj_set_style_radius(clearButton, 5, LV_PART_MAIN);
    
    lv_obj_t* clearLabel = lv_label_create(clearButton);
    lv_label_set_text(clearLabel, "Clear");
    lv_obj_set_style_text_color(clearLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(clearLabel);
    
    lv_obj_add_event_cb(clearButton, clearButtonCallback, LV_EVENT_CLICKED, this);
    
    // Export button
    exportButton = lv_btn_create(buttonContainer);
    lv_obj_set_size(exportButton, 100, 40);
    lv_obj_set_style_bg_color(exportButton, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_radius(exportButton, 5, LV_PART_MAIN);
    
    lv_obj_t* exportLabel = lv_label_create(exportButton);
    lv_label_set_text(exportLabel, "Export");
    lv_obj_set_style_text_color(exportLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_center(exportLabel);
    
    lv_obj_add_event_cb(exportButton, exportButtonCallback, LV_EVENT_CLICKED, this);
    
    // Create history list
    historyList = lv_list_create(screenObj);
    lv_obj_set_size(historyList, LV_HOR_RES - 20, LV_VER_RES - 130);
    lv_obj_set_pos(historyList, 10, 120);
    
    // List styling
    lv_obj_set_style_bg_color(historyList, lv_color_hex(0x212121), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(historyList, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(historyList, 1, LV_PART_MAIN);
    lv_obj_set_style_border_color(historyList, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_radius(historyList, 5, LV_PART_MAIN);
    
    // Load existing records
    loadRecords();
}

void HistoryScreen::onEnter() {
    BaseScreen::onEnter();
    refreshHistoryList();
}

void HistoryScreen::addRecord(float o2, float he, float n2, float co2, float co) {
    HistoryRecord record;
    record.timestamp = millis();
    record.o2 = o2;
    record.he = he;
    record.n2 = n2;
    record.co2 = co2;
    record.co = co;
    
    formatDateTime(record.timestamp, record.dateStr, record.timeStr);
    
    records.push_back(record);
    
    // Keep only the last MAX_RECORDS entries
    if (records.size() > MAX_RECORDS) {
        records.erase(records.begin());
    }
    
    saveRecords();
    
    // Refresh UI if screen is active
    if (isActive) {
        refreshHistoryList();
    }
}

void HistoryScreen::loadRecords() {
    if (!storage) {
        Serial.println("Storage manager not available");
        return;
    }
    
    records = storage->loadHistory();
    Serial.printf("Loaded %d history records from storage\n", records.size());
    
    // If no records loaded, add some sample data for testing
    if (records.empty()) {
        Serial.println("No history records found, adding sample data");
        addRecord(20.9, 0.0, 79.1, 400, 0);
        addRecord(21.0, 0.0, 79.0, 410, 1);
        addRecord(32.0, 0.0, 68.0, 450, 2);
    }
}

void HistoryScreen::saveRecords() {
    if (!storage) {
        Serial.println("Storage manager not available");
        return;
    }
    
    bool success = storage->saveHistory(records);
    if (success) {
        Serial.printf("Successfully saved %d history records\n", records.size());
    } else {
        Serial.println("Failed to save history records");
    }
}

void HistoryScreen::clearHistory() {
    records.clear();
    
    if (storage) {
        storage->clearHistory();
        Serial.println("History cleared from storage");
    }
    
    refreshHistoryList();
}

void HistoryScreen::refreshHistoryList() {
    // Clear existing list items
    lv_obj_clean(historyList);
    
    if (records.empty()) {
        lv_obj_t* emptyLabel = lv_label_create(historyList);
        lv_label_set_text(emptyLabel, "No history records");
        lv_obj_set_style_text_color(emptyLabel, lv_color_hex(0x888888), LV_PART_MAIN);
        lv_obj_center(emptyLabel);
        return;
    }
    
    // Add records in reverse order (newest first)
    for (int i = records.size() - 1; i >= 0; i--) {
        createHistoryItem(records[i]);
    }
}

lv_obj_t* HistoryScreen::createHistoryItem(const HistoryRecord& record) {
    lv_obj_t* item = lv_list_add_btn(historyList, NULL, "");
    lv_obj_set_height(item, 60);
    
    // Item styling
    lv_obj_set_style_bg_color(item, lv_color_hex(0x424242), LV_PART_MAIN);
    lv_obj_set_style_bg_color(item, lv_color_hex(0x616161), LV_PART_MAIN | LV_STATE_PRESSED);
    lv_obj_set_style_border_width(item, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(item, 3, LV_PART_MAIN);
    
    // Create content container
    lv_obj_t* content = lv_obj_create(item);
    lv_obj_set_size(content, LV_HOR_RES - 60, 50);
    lv_obj_set_pos(content, 5, 5);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_remove_style_all(content);
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(content, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(content, 0, LV_PART_MAIN);
    
    // Date/time label
    lv_obj_t* dateLabel = lv_label_create(content);
    lv_label_set_text_fmt(dateLabel, "%s %s", record.dateStr, record.timeStr);
    lv_obj_set_style_text_color(dateLabel, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_text_font(dateLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(dateLabel, 0, 0);
    
    // Gas composition label
    lv_obj_t* gasLabel = lv_label_create(content);
    lv_label_set_text_fmt(gasLabel, "O2: %.1f%% He: %.1f%% N2: %.1f%%", 
                         record.o2, record.he, record.n2);
    lv_obj_set_style_text_color(gasLabel, lv_color_hex(0x4CAF50), LV_PART_MAIN);
    lv_obj_set_style_text_font(gasLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(gasLabel, 0, 18);
    
    // CO2/CO label
    lv_obj_t* coLabel = lv_label_create(content);
    lv_label_set_text_fmt(coLabel, "CO2: %.0fppm CO: %.0fppm", record.co2, record.co);
    lv_obj_set_style_text_color(coLabel, lv_color_hex(0xFF9800), LV_PART_MAIN);
    lv_obj_set_style_text_font(coLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_pos(coLabel, 0, 32);
    
    lv_obj_add_event_cb(item, historyItemCallback, LV_EVENT_CLICKED, this);
    
    return item;
}

void HistoryScreen::formatDateTime(unsigned long timestamp, char* dateStr, char* timeStr) {
    // Simple timestamp formatting
    // In a real implementation, you'd use RTC or NTP time
    unsigned long seconds = timestamp / 1000;
    unsigned long minutes = seconds / 60;
    unsigned long hours = minutes / 60;
    unsigned long days = hours / 24;
    
    sprintf(dateStr, "Day %lu", days);
    sprintf(timeStr, "%02lu:%02lu:%02lu", hours % 24, minutes % 60, seconds % 60);
}

void HistoryScreen::clearButtonCallback(lv_event_t* e) {
    HistoryScreen* screen = static_cast<HistoryScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        screen->clearHistory();
    }
}

void HistoryScreen::exportButtonCallback(lv_event_t* e) {
    HistoryScreen* screen = static_cast<HistoryScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        Serial.println("Export functionality not implemented yet");
        // TODO: Implement export to SD card or WiFi transfer
    }
}

void HistoryScreen::historyItemCallback(lv_event_t* e) {
    HistoryScreen* screen = static_cast<HistoryScreen*>(lv_event_get_user_data(e));
    if (screen != nullptr) {
        Serial.println("History item clicked - detail view not implemented yet");
    }
}
