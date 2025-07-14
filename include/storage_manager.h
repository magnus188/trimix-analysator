#ifndef STORAGE_MANAGER_H
#define STORAGE_MANAGER_H

#include <Arduino.h>
#include <SPIFFS.h>
#include <ArduinoJson.h>
#include <vector>

struct HistoryRecord {
    unsigned long timestamp;
    float o2;
    float he;
    float n2;
    float co2;
    float co;
    char dateStr[20];
    char timeStr[10];
};

class StorageManager {
private:
    static const char* HISTORY_FILE;
    static const char* SETTINGS_FILE;
    static const size_t MAX_RECORDS = 100;
    
    bool initialized;
    
    void ensureInitialized();
    bool createBackup(const char* filename);
    bool restoreBackup(const char* filename);
    
public:
    StorageManager();
    ~StorageManager();
    
    bool begin();
    void end();
    
    // History management
    std::vector<HistoryRecord> loadHistory();
    bool saveHistory(const std::vector<HistoryRecord>& records);
    bool clearHistory();
    
    // Settings management
    bool saveSetting(const char* key, const char* value);
    bool saveSetting(const char* key, float value);
    bool saveSetting(const char* key, int value);
    bool saveSetting(const char* key, bool value);
    
    String loadStringSetting(const char* key, const String& defaultValue = "");
    float loadFloatSetting(const char* key, float defaultValue = 0.0f);
    int loadIntSetting(const char* key, int defaultValue = 0);
    bool loadBoolSetting(const char* key, bool defaultValue = false);
    
    // Utility functions
    void formatFileSystem();
    size_t getUsedSpace();
    size_t getTotalSpace();
    size_t getFreeSpace();
    void listFiles();
    
    // Backup and restore
    bool exportHistory(const char* filename);
    bool importHistory(const char* filename);
};

#endif // STORAGE_MANAGER_H
