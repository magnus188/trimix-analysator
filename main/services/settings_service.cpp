#include "settings_service.h"
#include <nvs_flash.h>
#include <nvs.h>
#include <esp_log.h>
#include <algorithm>

static const char* TAG = "SETTINGS";
static const char* NVS_NAMESPACE = "settings";
static const char* NVS_KEY_VERSION = "version";

// =============================================================================
// Setting Definitions - Default values and metadata
// =============================================================================
static const setting_def_t SETTING_DEFS[SETTING_COUNT] = {
    // key                      category            name                nvs_key         default  min   max
    { SETTING_BRIGHTNESS,       SETTINGS_CAT_DEVICE, "Brightness",       "brightness",   80,      10,   100 },
    { SETTING_SCREEN_TIMEOUT,   SETTINGS_CAT_DEVICE, "Screen Timeout",   "scr_timeout",   1,       0,     3 }, // 0=never,1=1m,2=3m,3=5m
    { SETTING_SOUND_ENABLED,    SETTINGS_CAT_DEVICE, "Sound",            "sound",         1,       0,     1 },
    { SETTING_UNITS_DEPTH,      SETTINGS_CAT_DEVICE, "Depth Units",      "units_depth",   0,       0,     1 },
    { SETTING_UNITS_TEMP,       SETTINGS_CAT_DEVICE, "Temp Units",       "units_temp",    0,       0,     1 },
    { SETTING_UNITS_PRESSURE,   SETTINGS_CAT_DEVICE, "Pressure Units",   "units_pres",    0,       0,     1 },
};

static const char* CATEGORY_NAMES[SETTINGS_CAT_COUNT] = {
    "Device",
    "Safety",
    "Calibration"
};

// =============================================================================
// Runtime state
// =============================================================================
static int32_t s_values[SETTING_COUNT];
static bool s_initialized = false;

// =============================================================================
// Internal helpers
// =============================================================================

static void load_from_nvs(void) {
    nvs_handle_t handle;
    
    if (nvs_open(NVS_NAMESPACE, NVS_READONLY, &handle) != ESP_OK) {
        ESP_LOGI(TAG, "No saved settings found, using defaults");
        return;
    }
    
    // Check version for potential migration
    int32_t saved_version = 0;
    nvs_get_i32(handle, NVS_KEY_VERSION, &saved_version);
    
    if (saved_version < SETTINGS_VERSION) {
        ESP_LOGI(TAG, "Settings version %ld -> %d, may need migration", saved_version, SETTINGS_VERSION);
    }
    
    // Load each setting
    for (int i = 0; i < SETTING_COUNT; i++) {
        int32_t value;
        if (nvs_get_i32(handle, SETTING_DEFS[i].nvs_key, &value) == ESP_OK) {
            // Clamp to valid range in case limits changed
            value = std::max(SETTING_DEFS[i].min_value, std::min(SETTING_DEFS[i].max_value, value));
            s_values[i] = value;
            ESP_LOGD(TAG, "Loaded %s = %ld", SETTING_DEFS[i].name, value);
        }
    }
    
    nvs_close(handle);
}

static void save_to_nvs(void) {
    nvs_handle_t handle;
    
    if (nvs_open(NVS_NAMESPACE, NVS_READWRITE, &handle) != ESP_OK) {
        ESP_LOGE(TAG, "Failed to open NVS for writing");
        return;
    }
    
    // Save version
    nvs_set_i32(handle, NVS_KEY_VERSION, SETTINGS_VERSION);
    
    // Save each setting
    for (int i = 0; i < SETTING_COUNT; i++) {
        nvs_set_i32(handle, SETTING_DEFS[i].nvs_key, s_values[i]);
    }
    
    nvs_commit(handle);
    nvs_close(handle);
    
    ESP_LOGI(TAG, "Settings saved");
}

// =============================================================================
// Public API
// =============================================================================

void settings_init(void) {
    if (s_initialized) return;
    
    ESP_LOGI(TAG, "Initializing settings service v%d", SETTINGS_VERSION);
    
    // Initialize NVS if not already done
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_LOGW(TAG, "NVS partition was truncated, erasing...");
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);
    
    // Load defaults first
    for (int i = 0; i < SETTING_COUNT; i++) {
        s_values[i] = SETTING_DEFS[i].default_value;
    }
    
    // Then overlay saved values
    load_from_nvs();
    
    s_initialized = true;
    ESP_LOGI(TAG, "Settings initialized (%d settings)", SETTING_COUNT);
}

int32_t settings_get(setting_key_t key) {
    if (key >= SETTING_COUNT) {
        ESP_LOGE(TAG, "Invalid setting key: %d", key);
        return 0;
    }
    return s_values[key];
}

bool settings_set(setting_key_t key, int32_t value) {
    if (key >= SETTING_COUNT) {
        ESP_LOGE(TAG, "Invalid setting key: %d", key);
        return false;
    }
    
    const setting_def_t* def = &SETTING_DEFS[key];
    
    // Clamp to valid range
    value = std::max(def->min_value, std::min(def->max_value, value));
    
    // Check if actually changed
    if (s_values[key] == value) {
        return false;
    }
    
    ESP_LOGI(TAG, "%s: %ld -> %ld", def->name, s_values[key], value);
    s_values[key] = value;
    
    // Auto-save
    save_to_nvs();
    
    return true;
}

void settings_reset(setting_key_t key) {
    if (key >= SETTING_COUNT) return;
    
    ESP_LOGI(TAG, "Reset %s to default", SETTING_DEFS[key].name);
    settings_set(key, SETTING_DEFS[key].default_value);
}

void settings_reset_category(settings_category_t category) {
    if (category >= SETTINGS_CAT_COUNT) return;
    
    ESP_LOGI(TAG, "Reset category: %s", CATEGORY_NAMES[category]);
    
    for (int i = 0; i < SETTING_COUNT; i++) {
        if (SETTING_DEFS[i].category == category) {
            s_values[i] = SETTING_DEFS[i].default_value;
        }
    }
    
    save_to_nvs();
}

void settings_factory_reset(void) {
    ESP_LOGW(TAG, "Factory reset");
    
    for (int i = 0; i < SETTING_COUNT; i++) {
        s_values[i] = SETTING_DEFS[i].default_value;
    }
    
    // Clear NVS namespace completely
    nvs_handle_t handle;
    if (nvs_open(NVS_NAMESPACE, NVS_READWRITE, &handle) == ESP_OK) {
        nvs_erase_all(handle);
        nvs_commit(handle);
        nvs_close(handle);
    }
    
    save_to_nvs();
}

int32_t settings_get_default(setting_key_t key) {
    if (key >= SETTING_COUNT) return 0;
    return SETTING_DEFS[key].default_value;
}

bool settings_is_modified(setting_key_t key) {
    if (key >= SETTING_COUNT) return false;
    return s_values[key] != SETTING_DEFS[key].default_value;
}

const setting_def_t* settings_get_def(setting_key_t key) {
    if (key >= SETTING_COUNT) return nullptr;
    return &SETTING_DEFS[key];
}

const char* settings_get_category_name(settings_category_t category) {
    if (category >= SETTINGS_CAT_COUNT) return "Unknown";
    return CATEGORY_NAMES[category];
}
