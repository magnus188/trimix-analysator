#include "storage_manager.h"
#include <time.h>

const char* StorageManager::HISTORY_FILE = "/history.json";
const char* StorageManager::SETTINGS_FILE = "/settings.json";

StorageManager::StorageManager() : initialized(false) {
}

StorageManager::~StorageManager() {
    if (initialized) {
        end();
    }
}

bool StorageManager::begin() {
    if (initialized) {
        return true;
    }
    
    if (!SPIFFS.begin(true)) {
        Serial.println("Failed to mount SPIFFS");
        return false;
    }
    
    initialized = true;
    Serial.println("SPIFFS mounted successfully");
    
    // Print filesystem info
    Serial.printf("SPIFFS Total: %d bytes\n", getTotalSpace());
    Serial.printf("SPIFFS Used: %d bytes\n", getUsedSpace());
    Serial.printf("SPIFFS Free: %d bytes\n", getFreeSpace());
    
    return true;
}

void StorageManager::end() {
    if (initialized) {
        SPIFFS.end();
        initialized = false;
    }
}

void StorageManager::ensureInitialized() {
    if (!initialized) {
        begin();
    }
}

std::vector<HistoryRecord> StorageManager::loadHistory() {
    ensureInitialized();
    std::vector<HistoryRecord> records;
    
    if (!SPIFFS.exists(HISTORY_FILE)) {
        Serial.println("History file does not exist");
        return records;
    }
    
    File file = SPIFFS.open(HISTORY_FILE, "r");
    if (!file) {
        Serial.println("Failed to open history file for reading");
        return records;
    }
    
    // Read file content
    String content = file.readString();
    file.close();
    
    if (content.isEmpty()) {
        Serial.println("History file is empty");
        return records;
    }
    
    // Parse JSON
    DynamicJsonDocument doc(8192); // Adjust size as needed
    DeserializationError error = deserializeJson(doc, content);
    
    if (error) {
        Serial.printf("JSON parsing failed: %s\n", error.c_str());
        return records;
    }
    
    JsonArray array = doc["records"].as<JsonArray>();
    
    for (JsonObject obj : array) {
        HistoryRecord record;
        record.timestamp = obj["timestamp"].as<unsigned long>();
        record.o2 = obj["o2"].as<float>();
        record.he = obj["he"].as<float>();
        record.n2 = obj["n2"].as<float>();
        record.co2 = obj["co2"].as<float>();
        record.co = obj["co"].as<float>();
        
        // Format date and time strings
        time_t timestamp = record.timestamp;
        struct tm* timeinfo = localtime(&timestamp);
        strftime(record.dateStr, sizeof(record.dateStr), "%Y-%m-%d", timeinfo);
        strftime(record.timeStr, sizeof(record.timeStr), "%H:%M:%S", timeinfo);
        
        records.push_back(record);
    }
    
    Serial.printf("Loaded %d history records\n", records.size());
    return records;
}

bool StorageManager::saveHistory(const std::vector<HistoryRecord>& records) {
    ensureInitialized();
    
    // Create backup before saving
    createBackup(HISTORY_FILE);
    
    // Create JSON document
    DynamicJsonDocument doc(8192);
    JsonArray array = doc.createNestedArray("records");
    
    // Limit to MAX_RECORDS
    size_t startIndex = records.size() > MAX_RECORDS ? records.size() - MAX_RECORDS : 0;
    
    for (size_t i = startIndex; i < records.size(); i++) {
        JsonObject obj = array.createNestedObject();
        obj["timestamp"] = records[i].timestamp;
        obj["o2"] = records[i].o2;
        obj["he"] = records[i].he;
        obj["n2"] = records[i].n2;
        obj["co2"] = records[i].co2;
        obj["co"] = records[i].co;
    }
    
    // Open file for writing
    File file = SPIFFS.open(HISTORY_FILE, "w");
    if (!file) {
        Serial.println("Failed to open history file for writing");
        return false;
    }
    
    // Write JSON to file
    size_t bytesWritten = serializeJson(doc, file);
    file.close();
    
    if (bytesWritten > 0) {
        Serial.printf("Saved %d history records (%d bytes)\n", records.size(), bytesWritten);
        return true;
    } else {
        Serial.println("Failed to write history file");
        // Restore backup if save failed
        restoreBackup(HISTORY_FILE);
        return false;
    }
}

bool StorageManager::clearHistory() {
    ensureInitialized();
    
    if (SPIFFS.exists(HISTORY_FILE)) {
        bool success = SPIFFS.remove(HISTORY_FILE);
        if (success) {
            Serial.println("History cleared successfully");
        } else {
            Serial.println("Failed to clear history");
        }
        return success;
    }
    
    return true; // File doesn't exist, so it's already "cleared"
}

bool StorageManager::saveSetting(const char* key, const char* value) {
    ensureInitialized();
    
    // Load existing settings
    DynamicJsonDocument doc(4096);
    
    if (SPIFFS.exists(SETTINGS_FILE)) {
        File file = SPIFFS.open(SETTINGS_FILE, "r");
        if (file) {
            deserializeJson(doc, file);
            file.close();
        }
    }
    
    // Update setting
    doc[key] = value;
    
    // Save settings
    File file = SPIFFS.open(SETTINGS_FILE, "w");
    if (!file) {
        Serial.println("Failed to open settings file for writing");
        return false;
    }
    
    size_t bytesWritten = serializeJson(doc, file);
    file.close();
    
    if (bytesWritten > 0) {
        Serial.printf("Saved setting %s = %s\n", key, value);
        return true;
    } else {
        Serial.println("Failed to save setting");
        return false;
    }
}

bool StorageManager::saveSetting(const char* key, float value) {
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%.6f", value);
    return saveSetting(key, buffer);
}

bool StorageManager::saveSetting(const char* key, int value) {
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "%d", value);
    return saveSetting(key, buffer);
}

bool StorageManager::saveSetting(const char* key, bool value) {
    return saveSetting(key, value ? "true" : "false");
}

String StorageManager::loadStringSetting(const char* key, const String& defaultValue) {
    ensureInitialized();
    
    if (!SPIFFS.exists(SETTINGS_FILE)) {
        return defaultValue;
    }
    
    File file = SPIFFS.open(SETTINGS_FILE, "r");
    if (!file) {
        return defaultValue;
    }
    
    DynamicJsonDocument doc(4096);
    DeserializationError error = deserializeJson(doc, file);
    file.close();
    
    if (error) {
        Serial.printf("Settings JSON parsing failed: %s\n", error.c_str());
        return defaultValue;
    }
    
    if (doc.containsKey(key)) {
        return doc[key].as<String>();
    }
    
    return defaultValue;
}

float StorageManager::loadFloatSetting(const char* key, float defaultValue) {
    String value = loadStringSetting(key, "");
    if (value.isEmpty()) {
        return defaultValue;
    }
    return value.toFloat();
}

int StorageManager::loadIntSetting(const char* key, int defaultValue) {
    String value = loadStringSetting(key, "");
    if (value.isEmpty()) {
        return defaultValue;
    }
    return value.toInt();
}

bool StorageManager::loadBoolSetting(const char* key, bool defaultValue) {
    String value = loadStringSetting(key, "");
    if (value.isEmpty()) {
        return defaultValue;
    }
    return value.equals("true");
}

void StorageManager::formatFileSystem() {
    ensureInitialized();
    Serial.println("Formatting SPIFFS...");
    SPIFFS.format();
    Serial.println("SPIFFS formatted");
}

size_t StorageManager::getUsedSpace() {
    ensureInitialized();
    return SPIFFS.usedBytes();
}

size_t StorageManager::getTotalSpace() {
    ensureInitialized();
    return SPIFFS.totalBytes();
}

size_t StorageManager::getFreeSpace() {
    ensureInitialized();
    return SPIFFS.totalBytes() - SPIFFS.usedBytes();
}

void StorageManager::listFiles() {
    ensureInitialized();
    File root = SPIFFS.open("/");
    File file = root.openNextFile();
    
    Serial.println("SPIFFS Files:");
    while (file) {
        Serial.printf("  %s (%d bytes)\n", file.name(), file.size());
        file = root.openNextFile();
    }
    root.close();
}

bool StorageManager::createBackup(const char* filename) {
    ensureInitialized();
    
    if (!SPIFFS.exists(filename)) {
        return true; // No file to backup
    }
    
    String backupName = String(filename) + ".bak";
    
    File source = SPIFFS.open(filename, "r");
    if (!source) {
        return false;
    }
    
    File backup = SPIFFS.open(backupName, "w");
    if (!backup) {
        source.close();
        return false;
    }
    
    // Copy file contents
    while (source.available()) {
        backup.write(source.read());
    }
    
    source.close();
    backup.close();
    
    Serial.printf("Created backup: %s\n", backupName.c_str());
    return true;
}

bool StorageManager::restoreBackup(const char* filename) {
    ensureInitialized();
    
    String backupName = String(filename) + ".bak";
    
    if (!SPIFFS.exists(backupName.c_str())) {
        Serial.println("No backup file found");
        return false;
    }
    
    File backup = SPIFFS.open(backupName, "r");
    if (!backup) {
        return false;
    }
    
    File target = SPIFFS.open(filename, "w");
    if (!target) {
        backup.close();
        return false;
    }
    
    // Copy backup contents
    while (backup.available()) {
        target.write(backup.read());
    }
    
    backup.close();
    target.close();
    
    Serial.printf("Restored backup: %s\n", filename);
    return true;
}

bool StorageManager::exportHistory(const char* filename) {
    ensureInitialized();
    
    if (!SPIFFS.exists(HISTORY_FILE)) {
        Serial.println("No history file to export");
        return false;
    }
    
    File source = SPIFFS.open(HISTORY_FILE, "r");
    if (!source) {
        return false;
    }
    
    File export_file = SPIFFS.open(filename, "w");
    if (!export_file) {
        source.close();
        return false;
    }
    
    // Copy file contents
    while (source.available()) {
        export_file.write(source.read());
    }
    
    source.close();
    export_file.close();
    
    Serial.printf("Exported history to: %s\n", filename);
    return true;
}

bool StorageManager::importHistory(const char* filename) {
    ensureInitialized();
    
    if (!SPIFFS.exists(filename)) {
        Serial.printf("Import file not found: %s\n", filename);
        return false;
    }
    
    // Create backup of current history
    createBackup(HISTORY_FILE);
    
    File import_file = SPIFFS.open(filename, "r");
    if (!import_file) {
        return false;
    }
    
    File target = SPIFFS.open(HISTORY_FILE, "w");
    if (!target) {
        import_file.close();
        return false;
    }
    
    // Copy import file contents
    while (import_file.available()) {
        target.write(import_file.read());
    }
    
    import_file.close();
    target.close();
    
    Serial.printf("Imported history from: %s\n", filename);
    return true;
}
