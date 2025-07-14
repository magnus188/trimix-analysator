#ifndef HISTORY_SCREEN_H
#define HISTORY_SCREEN_H

#include "base_screen.h"
#include "storage_manager.h"
#include <vector>

class HistoryScreen : public BaseScreen {
private:
    lv_obj_t* historyList;
    lv_obj_t* clearButton;
    lv_obj_t* exportButton;
    std::vector<HistoryRecord> records;
    StorageManager* storage;
    static const int MAX_RECORDS = 100;

public:
    HistoryScreen(ScreenManager* screenManager, StorageManager* storageManager);
    ~HistoryScreen();
    
    void create() override;
    void onEnter() override;
    void addRecord(float o2, float he, float n2, float co2, float co);
    void loadRecords();
    void saveRecords();
    void clearHistory();
    
private:
    void refreshHistoryList();
    lv_obj_t* createHistoryItem(const HistoryRecord& record);
    static void clearButtonCallback(lv_event_t* e);
    static void exportButtonCallback(lv_event_t* e);
    static void historyItemCallback(lv_event_t* e);
    void formatDateTime(unsigned long timestamp, char* dateStr, char* timeStr);
};

#endif // HISTORY_SCREEN_H
