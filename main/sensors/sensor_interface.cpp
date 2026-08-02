#include "sensor_interface.h"
#include <esp_err.h>
#include <esp_log.h>
#include <cmath>

static const char *TAG = "SENSOR_IF";

namespace {

struct MockProfileSpec {
    const char* name;
    float oxygen_percent;
    float helium_percent;
    float co2_ppm;
    float temperature_c;
    float pressure_bar;
    float humidity_pct;
};

constexpr MockProfileSpec kProfiles[SENSOR_MOCK_PROFILE_COUNT] = {
    {"Air", 20.9f, 0.0f, 420.0f, 22.1f, 1.00f, 44.0f},
    {"EAN32", 32.0f, 0.0f, 430.0f, 22.4f, 1.01f, 42.0f},
    {"Trimix 18/45", 18.0f, 45.0f, 425.0f, 21.8f, 1.00f, 41.0f},
    {"High CO2", 20.8f, 0.0f, 900.0f, 23.0f, 1.02f, 48.0f},
    {"Unstable", 21.0f, 0.0f, 460.0f, 22.6f, 1.00f, 45.0f},
    {"Sensor Fault", 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f},
};

sensor_mock_profile_t g_profile = SENSOR_MOCK_PROFILE_AIR;
uint32_t g_sequence = 0;
uint32_t g_profile_start_sequence = 0;
uint32_t g_last_o2_calibration_sequence = 0;
uint32_t g_last_co2_calibration_sequence = 0;

float deterministic_noise(uint32_t sequence, uint32_t salt, float amplitude) {
    uint32_t v = (sequence * 37U + salt * 17U) % 101U;
    float centered = (static_cast<float>(v) - 50.0f) / 50.0f;
    return centered * amplitude;
}

float settle_to_target(float target, uint32_t local_sequence, float offset) {
    if (local_sequence < 3) {
        return target + offset;
    }
    if (local_sequence < 9) {
        float progress = static_cast<float>(local_sequence - 2U) / 6.0f;
        return target + offset * (1.0f - progress);
    }
    return target;
}

sensor_status_t status_for_profile(sensor_mock_profile_t profile, uint32_t local_sequence) {
    if (profile == SENSOR_MOCK_PROFILE_SENSOR_FAULT) {
        return SENSOR_STATUS_FAULT;
    }
    if (profile == SENSOR_MOCK_PROFILE_UNSTABLE && local_sequence >= 6) {
        return SENSOR_STATUS_UNSTABLE;
    }
    if (local_sequence < 3) {
        return SENSOR_STATUS_WARMING;
    }
    if (local_sequence < 9) {
        return SENSOR_STATUS_STABILIZING;
    }
    return SENSOR_STATUS_STABLE;
}

bool valid_profile(sensor_mock_profile_t profile) {
    return profile >= SENSOR_MOCK_PROFILE_AIR && profile < SENSOR_MOCK_PROFILE_COUNT;
}

}  // namespace

extern "C" {
esp_err_t sensor_read_all(sensor_readings_t *out) {
    if (!out) return ESP_ERR_INVALID_ARG;

    const sensor_mock_profile_t profile = valid_profile(g_profile) ? g_profile : SENSOR_MOCK_PROFILE_AIR;
    const MockProfileSpec& spec = kProfiles[profile];
    const uint32_t sequence = ++g_sequence;
    const uint32_t local_sequence = sequence - g_profile_start_sequence;
    const sensor_status_t status = status_for_profile(profile, local_sequence);

    out->timestamp_ms = sequence * 1000U;
    out->sequence = sequence;
    out->status = status;
    out->source = SENSOR_SOURCE_SIMULATED;

    if (status == SENSOR_STATUS_FAULT) {
        out->oxygen_percent = -1.0f;
        out->helium_percent = -1.0f;
        out->co2_ppm = -1.0f;
        out->temperature_c = 0.0f;
        out->pressure_bar = 0.0f;
        out->humidity_pct = 0.0f;
        return ESP_OK;
    }

    float oxygen = settle_to_target(spec.oxygen_percent, local_sequence, -1.6f);
    float helium = settle_to_target(spec.helium_percent, local_sequence, 1.2f);
    float co2 = settle_to_target(spec.co2_ppm, local_sequence, 70.0f);
    float temp = settle_to_target(spec.temperature_c, local_sequence, -0.7f);
    float pressure = settle_to_target(spec.pressure_bar, local_sequence, -0.02f);
    float humidity = settle_to_target(spec.humidity_pct, local_sequence, 4.0f);

    if (profile == SENSOR_MOCK_PROFILE_UNSTABLE) {
        oxygen += std::sin(static_cast<float>(local_sequence) * 0.9f) * 1.8f;
        helium += std::cos(static_cast<float>(local_sequence) * 0.5f) * 1.2f;
        co2 += std::cos(static_cast<float>(local_sequence) * 0.7f) * 160.0f;
    } else {
        oxygen += deterministic_noise(sequence, 1, 0.05f);
        helium += deterministic_noise(sequence, 6, 0.08f);
        co2 += deterministic_noise(sequence, 2, 5.0f);
    }

    out->oxygen_percent = oxygen;
    out->helium_percent = helium < 0.0f ? 0.0f : helium;
    out->co2_ppm = co2;
    out->temperature_c = temp + deterministic_noise(sequence, 3, 0.08f);
    out->pressure_bar = pressure + deterministic_noise(sequence, 4, 0.003f);
    out->humidity_pct = humidity + deterministic_noise(sequence, 5, 0.3f);
    return ESP_OK;
}

esp_err_t sensor_calibrate_oxygen_air(void) {
    if (g_profile == SENSOR_MOCK_PROFILE_SENSOR_FAULT) {
        ESP_LOGW(TAG, "O2 calibration rejected while sensor fault profile is active");
        return ESP_ERR_INVALID_STATE;
    }
    g_last_o2_calibration_sequence = g_sequence;
    ESP_LOGI(TAG, "Calibrating O2 sensor to ambient air (20.9%%)");
    return ESP_OK;
}

esp_err_t sensor_calibrate_co2_zero(void) {
    if (g_profile == SENSOR_MOCK_PROFILE_SENSOR_FAULT) {
        ESP_LOGW(TAG, "CO2 zero calibration rejected while sensor fault profile is active");
        return ESP_ERR_INVALID_STATE;
    }
    g_last_co2_calibration_sequence = g_sequence;
    ESP_LOGI(TAG, "Recording CO2 zero calibration in simulation");
    return ESP_OK;
}

esp_err_t sensor_calibrate_co2_reference(uint16_t reference_ppm) {
    if (reference_ppm < 300 || reference_ppm > 2000) {
        return ESP_ERR_INVALID_ARG;
    }
    if (g_profile == SENSOR_MOCK_PROFILE_SENSOR_FAULT) {
        ESP_LOGW(TAG, "CO2 reference calibration rejected while sensor fault profile is active");
        return ESP_ERR_INVALID_STATE;
    }
    g_last_co2_calibration_sequence = g_sequence;
    ESP_LOGI(TAG, "Recording CO2 reference calibration at %u ppm in simulation", reference_ppm);
    return ESP_OK;
}

void sensor_set_mock_profile(sensor_mock_profile_t profile) {
    if (!valid_profile(profile)) {
        return;
    }
    g_profile = profile;
    g_profile_start_sequence = g_sequence;
    ESP_LOGI(TAG, "Mock sensor profile: %s", sensor_mock_profile_name(profile));
}

sensor_mock_profile_t sensor_get_mock_profile(void) {
    return valid_profile(g_profile) ? g_profile : SENSOR_MOCK_PROFILE_AIR;
}

const char* sensor_mock_profile_name(sensor_mock_profile_t profile) {
    if (!valid_profile(profile)) {
        return "Unknown";
    }
    return kProfiles[profile].name;
}

const char* sensor_status_label(sensor_status_t status) {
    switch (status) {
        case SENSOR_STATUS_WARMING:
            return "Warming";
        case SENSOR_STATUS_STABILIZING:
            return "Stabilizing";
        case SENSOR_STATUS_STABLE:
            return "Stable";
        case SENSOR_STATUS_UNSTABLE:
            return "Unstable";
        case SENSOR_STATUS_FAULT:
            return "Fault";
        default:
            return "Unknown";
    }
}

const char* sensor_source_label(sensor_source_t source) {
    switch (source) {
        case SENSOR_SOURCE_SIMULATED:
            return "Simulated";
        case SENSOR_SOURCE_HARDWARE:
            return "Hardware";
        default:
            return "Unknown";
    }
}
}
