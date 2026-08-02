#include "cylinder_profiles.h"
#include <algorithm>
#include <cstdio>
#include <cstring>

#ifndef TRIMIX_SIMULATOR
#include <esp_log.h>
#include <nvs.h>
#include <nvs_flash.h>
#endif

namespace {

#ifndef TRIMIX_SIMULATOR
constexpr const char* kNvsNamespace = "cyl_profiles";
constexpr const char* kNvsKeyProfiles = "profiles";
constexpr const char* kNvsKeySelected = "selected";
const char* TAG = "CYL_PROFILES";
#endif

cylinder_profile_t g_profiles[CYLINDER_PROFILE_CAPACITY] = {};
uint8_t g_selected = 0;
bool g_initialized = false;

void set_profile(cylinder_profile_t& profile, const char* name, const char* serial,
                 float o2, float he, float depth, analysis_gas_mode_t mode) {
    profile = {};
    profile.configured = true;
    profile.needs_recheck = true;
    std::snprintf(profile.name, sizeof(profile.name), "%s", name);
    std::snprintf(profile.serial, sizeof(profile.serial), "%s", serial);
    profile.oxygen_percent = o2;
    profile.helium_percent = he;
    profile.planned_depth_m = depth;
    profile.gas_mode = mode;
}

void load_defaults() {
    set_profile(g_profiles[0], "Back Gas", "BG-01", 18.0f, 45.0f, 60.0f,
                ANALYSIS_GAS_MODE_OC_BACK_GAS);
    set_profile(g_profiles[1], "Deco 50", "STG-50", 50.0f, 0.0f, 21.0f,
                ANALYSIS_GAS_MODE_DECO_GAS);
    set_profile(g_profiles[2], "Oxygen", "STG-O2", 100.0f, 0.0f, 6.0f,
                ANALYSIS_GAS_MODE_DECO_GAS);
    set_profile(g_profiles[3], "Diluent", "DIL-01", 10.0f, 60.0f, 80.0f,
                ANALYSIS_GAS_MODE_CCR_DILUENT);
    set_profile(g_profiles[4], "Bailout", "BO-01", 21.0f, 35.0f, 45.0f,
                ANALYSIS_GAS_MODE_BAILOUT);
    set_profile(g_profiles[5], "Spare", "SPARE", 20.9f, 0.0f, 30.0f,
                ANALYSIS_GAS_MODE_OC_BACK_GAS);
    g_selected = 0;
}

bool valid_index(uint8_t index) {
    return index < CYLINDER_PROFILE_CAPACITY;
}

void normalize() {
    if (!valid_index(g_selected)) {
        g_selected = 0;
    }
    for (auto& profile : g_profiles) {
        if (!profile.configured) {
            continue;
        }
        profile.oxygen_percent = std::max(0.0f, std::min(100.0f, profile.oxygen_percent));
        profile.helium_percent = std::max(0.0f, std::min(95.0f, profile.helium_percent));
        if (profile.oxygen_percent + profile.helium_percent > 100.0f) {
            profile.helium_percent = 100.0f - profile.oxygen_percent;
        }
        profile.planned_depth_m = std::max(0.0f, std::min(150.0f, profile.planned_depth_m));
        if (profile.gas_mode < ANALYSIS_GAS_MODE_OC_BACK_GAS ||
            profile.gas_mode >= ANALYSIS_GAS_MODE_COUNT) {
            profile.gas_mode = ANALYSIS_GAS_MODE_OC_BACK_GAS;
        }
    }
}

#ifndef TRIMIX_SIMULATOR
void load_from_nvs() {
    nvs_handle_t handle;
    if (nvs_open(kNvsNamespace, NVS_READONLY, &handle) != ESP_OK) {
        return;
    }

    uint8_t selected = 0;
    if (nvs_get_u8(handle, kNvsKeySelected, &selected) == ESP_OK) {
        g_selected = selected;
    }

    size_t required = sizeof(g_profiles);
    if (nvs_get_blob(handle, kNvsKeyProfiles, g_profiles, &required) != ESP_OK ||
        required != sizeof(g_profiles)) {
        load_defaults();
    }
    normalize();
    nvs_close(handle);
}

void save_to_nvs() {
    nvs_handle_t handle;
    if (nvs_open(kNvsNamespace, NVS_READWRITE, &handle) != ESP_OK) {
        ESP_LOGW(TAG, "Failed to open cylinder profile namespace");
        return;
    }
    nvs_set_u8(handle, kNvsKeySelected, g_selected);
    nvs_set_blob(handle, kNvsKeyProfiles, g_profiles, sizeof(g_profiles));
    nvs_commit(handle);
    nvs_close(handle);
}
#else
void load_from_nvs() {}
void save_to_nvs() {}
#endif

}  // namespace

extern "C" {

void cylinder_profiles_init(void) {
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
    load_defaults();
    load_from_nvs();
    normalize();
    g_initialized = true;
}

uint8_t cylinder_profiles_count(void) {
    cylinder_profiles_init();
    return CYLINDER_PROFILE_CAPACITY;
}

uint8_t cylinder_profiles_selected_index(void) {
    cylinder_profiles_init();
    return g_selected;
}

bool cylinder_profiles_get(uint8_t index, cylinder_profile_t* out) {
    if (!out || !valid_index(index)) {
        return false;
    }
    cylinder_profiles_init();
    *out = g_profiles[index];
    return true;
}

bool cylinder_profiles_get_selected(cylinder_profile_t* out) {
    return cylinder_profiles_get(cylinder_profiles_selected_index(), out);
}

esp_err_t cylinder_profiles_select(uint8_t index) {
    if (!valid_index(index)) {
        return ESP_ERR_INVALID_ARG;
    }
    cylinder_profiles_init();
    g_selected = index;
    save_to_nvs();
    return ESP_OK;
}

esp_err_t cylinder_profiles_select_next(void) {
    cylinder_profiles_init();
    g_selected = (g_selected + 1U) % CYLINDER_PROFILE_CAPACITY;
    save_to_nvs();
    return ESP_OK;
}

esp_err_t cylinder_profiles_set(uint8_t index, const cylinder_profile_t* profile) {
    if (!profile || !valid_index(index)) {
        return ESP_ERR_INVALID_ARG;
    }
    cylinder_profiles_init();
    g_profiles[index] = *profile;
    g_profiles[index].configured = true;
    normalize();
    save_to_nvs();
    return ESP_OK;
}

esp_err_t cylinder_profiles_update_selected_from_record(const analysis_history_record_t* record) {
    if (!record) {
        return ESP_ERR_INVALID_ARG;
    }
    cylinder_profiles_init();
    cylinder_profile_t& profile = g_profiles[g_selected];
    profile.configured = true;
    profile.needs_recheck = false;
    profile.oxygen_percent = record->oxygen_percent;
    profile.helium_percent = record->helium_percent;
    profile.planned_depth_m = record->planned_depth_m;
    profile.gas_mode = record->gas_mode;
    profile.last_analyzed_ms = record->timestamp_ms;
    normalize();
    save_to_nvs();
    return ESP_OK;
}

esp_err_t cylinder_profiles_mark_selected_recheck(bool needs_recheck) {
    cylinder_profiles_init();
    g_profiles[g_selected].needs_recheck = needs_recheck;
    save_to_nvs();
    return ESP_OK;
}

void cylinder_profiles_reset_defaults(void) {
    cylinder_profiles_init();
    load_defaults();
    save_to_nvs();
}

}  // extern "C"
