#include "analysis_history.h"
#include <algorithm>
#include <cstdio>
#include <cstring>

#ifndef TRIMIX_SIMULATOR
#include <nvs.h>
#include <nvs_flash.h>
#include <esp_log.h>
#endif

namespace {

#ifndef TRIMIX_SIMULATOR
constexpr const char* kNvsNamespace = "analysis_hist";
constexpr const char* kNvsKeyRecords = "records";
constexpr const char* kNvsKeyCount = "count";
const char* TAG = "ANALYSIS_HISTORY";
#endif

analysis_history_record_t g_records[ANALYSIS_HISTORY_CAPACITY] = {};
uint8_t g_count = 0;
bool g_initialized = false;

#ifndef TRIMIX_SIMULATOR
void normalize_count() {
    if (g_count > ANALYSIS_HISTORY_CAPACITY) {
        g_count = ANALYSIS_HISTORY_CAPACITY;
    }
}

void load_from_nvs() {
    nvs_handle_t handle;
    if (nvs_open(kNvsNamespace, NVS_READONLY, &handle) != ESP_OK) {
        return;
    }

    uint8_t count = 0;
    if (nvs_get_u8(handle, kNvsKeyCount, &count) == ESP_OK) {
        g_count = std::min<uint8_t>(count, ANALYSIS_HISTORY_CAPACITY);
    }

    size_t required = sizeof(g_records);
    if (nvs_get_blob(handle, kNvsKeyRecords, g_records, &required) != ESP_OK) {
        g_count = 0;
        std::memset(g_records, 0, sizeof(g_records));
    }
    normalize_count();
    nvs_close(handle);
}

void save_to_nvs() {
    nvs_handle_t handle;
    if (nvs_open(kNvsNamespace, NVS_READWRITE, &handle) != ESP_OK) {
        ESP_LOGW(TAG, "Failed to open history namespace");
        return;
    }
    nvs_set_u8(handle, kNvsKeyCount, g_count);
    nvs_set_blob(handle, kNvsKeyRecords, g_records, sizeof(g_records));
    nvs_commit(handle);
    nvs_close(handle);
}
#else
void load_from_nvs() {}
void save_to_nvs() {}
#endif

}  // namespace

extern "C" {

void analysis_history_init(void) {
    if (g_initialized) {
        return;
    }
#ifndef TRIMIX_SIMULATOR
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);
#endif
    load_from_nvs();
    g_initialized = true;
}

esp_err_t analysis_history_add(const analysis_history_record_t* record) {
    if (!record) {
        return ESP_ERR_INVALID_ARG;
    }
    analysis_history_init();

    if (g_count > 0) {
        const uint8_t move_count = std::min<uint8_t>(g_count, ANALYSIS_HISTORY_CAPACITY - 1);
        std::memmove(&g_records[1], &g_records[0], move_count * sizeof(g_records[0]));
    }
    g_records[0] = *record;
    if (g_count < ANALYSIS_HISTORY_CAPACITY) {
        ++g_count;
    }
    save_to_nvs();
    return ESP_OK;
}

uint8_t analysis_history_count(void) {
    analysis_history_init();
    return g_count;
}

bool analysis_history_get(uint8_t index, analysis_history_record_t* out) {
    if (!out) {
        return false;
    }
    analysis_history_init();
    if (index >= g_count) {
        return false;
    }
    *out = g_records[index];
    return true;
}

void analysis_history_clear(void) {
    analysis_history_init();
    std::memset(g_records, 0, sizeof(g_records));
    g_count = 0;
    save_to_nvs();
}

analysis_history_record_t analysis_history_record_from_result(const sensor_readings_t* readings,
                                                              const analysis_result_t* result) {
    analysis_history_record_t record = {};
    if (!readings || !result) {
        return record;
    }
    record.timestamp_ms = readings->timestamp_ms;
    record.sequence = readings->sequence;
    std::snprintf(record.mix_label, sizeof(record.mix_label), "%s", result->mix_label);
    record.oxygen_percent = result->oxygen_percent;
    record.helium_percent = result->helium_percent;
    record.nitrogen_percent = result->nitrogen_percent;
    record.co2_ppm = result->co2_ppm;
    record.planned_depth_m = result->planned_depth_m;
    record.mod_working_m = result->mod_working_m;
    record.mod_secondary_m = result->mod_secondary_m;
    record.ppo2_at_depth = result->ppo2_at_depth;
    record.ead_m = result->ead_m;
    record.end_m = result->end_m;
    record.gas_density_g_l = result->gas_density_g_l;
    record.gas_mode = result->gas_mode;
    record.severity = result->severity;
    return record;
}

}  // extern "C"
