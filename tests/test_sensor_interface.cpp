#include "sensors/sensor_interface.h"

#include <cmath>
#include <cstdio>
#include <cstring>

namespace {

int tests_passed = 0;
int tests_failed = 0;

void expect_true(bool condition, const char* name) {
    if (condition) {
        std::printf("  PASS %s\n", name);
        ++tests_passed;
    } else {
        std::printf("  FAIL %s\n", name);
        ++tests_failed;
    }
}

void expect_near(float actual, float expected, float tolerance, const char* name) {
    if (std::fabs(actual - expected) <= tolerance) {
        std::printf("  PASS %s (%.2f ~= %.2f)\n", name, actual, expected);
        ++tests_passed;
    } else {
        std::printf("  FAIL %s (got %.2f, expected %.2f)\n", name, actual, expected);
        ++tests_failed;
    }
}

sensor_readings_t read_many(int count) {
    sensor_readings_t r = {};
    for (int i = 0; i < count; ++i) {
        sensor_read_all(&r);
    }
    return r;
}

}  // namespace

int main() {
    std::printf("Sensor Interface Tests\n");
    std::printf("======================\n\n");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_AIR);
    sensor_readings_t air = read_many(10);
    expect_true(air.status == SENSOR_STATUS_STABLE, "Air profile stabilizes");
    expect_near(air.oxygen_percent, 20.9f, 0.2f, "Air O2 target");
    expect_near(air.helium_percent, 0.0f, 0.2f, "Air He target");
    expect_near(air.co2_ppm, 420.0f, 10.0f, "Air CO2 target");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_TRIMIX_18_45);
    sensor_readings_t trimix = read_many(10);
    expect_true(trimix.status == SENSOR_STATUS_STABLE, "Trimix profile stabilizes");
    expect_near(trimix.oxygen_percent, 18.0f, 0.2f, "Trimix O2 target");
    expect_near(trimix.helium_percent, 45.0f, 0.3f, "Trimix He target");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_HIGH_CO2);
    sensor_readings_t high_co2 = read_many(10);
    expect_true(high_co2.co2_ppm > 800.0f, "High CO2 profile exceeds advisory value");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_UNSTABLE);
    sensor_readings_t unstable = read_many(10);
    expect_true(unstable.status == SENSOR_STATUS_UNSTABLE, "Unstable profile reports unstable");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_SENSOR_FAULT);
    sensor_readings_t fault = {};
    sensor_read_all(&fault);
    expect_true(fault.status == SENSOR_STATUS_FAULT, "Fault profile reports fault");
    expect_true(sensor_calibrate_oxygen_air() == ESP_ERR_INVALID_STATE, "Fault blocks O2 calibration");

    sensor_set_mock_profile(SENSOR_MOCK_PROFILE_AIR);
    expect_true(sensor_calibrate_oxygen_air() == ESP_OK, "O2 calibration succeeds in simulation");
    expect_true(sensor_calibrate_co2_zero() == ESP_OK, "CO2 zero calibration succeeds in simulation");
    expect_true(sensor_calibrate_co2_reference(400) == ESP_OK, "CO2 reference calibration succeeds in simulation");
    expect_true(sensor_calibrate_co2_reference(100) == ESP_ERR_INVALID_ARG, "CO2 reference validates range");
    expect_true(std::strcmp(sensor_mock_profile_name(SENSOR_MOCK_PROFILE_EAN32), "EAN32") == 0,
                "Profile names are stable");

    std::printf("\nResults: %d passed, %d failed\n", tests_passed, tests_failed);
    return tests_failed > 0 ? 1 : 0;
}
