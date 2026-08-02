#include "services/analysis_history.h"

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

analysis_history_record_t make_record(uint32_t sequence) {
    analysis_history_record_t record = {};
    record.timestamp_ms = sequence * 1000U;
    record.sequence = sequence;
    std::snprintf(record.mix_label, sizeof(record.mix_label), "Mix %u", sequence);
    record.oxygen_percent = 20.0f + static_cast<float>(sequence % 10);
    record.helium_percent = static_cast<float>(sequence % 50);
    record.nitrogen_percent = 100.0f - record.oxygen_percent - record.helium_percent;
    record.co2_ppm = 400.0f + static_cast<float>(sequence);
    record.planned_depth_m = 30.0f;
    record.mod_working_m = 50.0f;
    record.mod_secondary_m = 66.0f;
    record.ppo2_at_depth = 1.1f;
    record.ead_m = 24.0f;
    record.end_m = 18.0f;
    record.gas_density_g_l = 4.2f;
    record.severity = ANALYSIS_SEVERITY_NORMAL;
    return record;
}

}  // namespace

int main() {
    std::printf("Analysis History Tests\n");
    std::printf("======================\n\n");

    analysis_history_init();
    analysis_history_clear();
    expect_true(analysis_history_count() == 0, "History starts empty after clear");

    analysis_history_record_t first = make_record(1);
    expect_true(analysis_history_add(&first) == ESP_OK, "Add first record");
    expect_true(analysis_history_count() == 1, "Count increments");

    analysis_history_record_t out = {};
    expect_true(analysis_history_get(0, &out), "Read latest record");
    expect_true(out.sequence == 1, "Latest record sequence matches");

    for (uint32_t i = 2; i <= ANALYSIS_HISTORY_CAPACITY + 5; ++i) {
        analysis_history_record_t record = make_record(i);
        analysis_history_add(&record);
    }
    expect_true(analysis_history_count() == ANALYSIS_HISTORY_CAPACITY, "History caps at capacity");
    expect_true(analysis_history_get(0, &out), "Read newest capped record");
    expect_true(out.sequence == ANALYSIS_HISTORY_CAPACITY + 5, "Newest record is first");
    expect_true(analysis_history_get(ANALYSIS_HISTORY_CAPACITY - 1, &out), "Read oldest capped record");
    expect_true(out.sequence == 6, "Old records are evicted");
    expect_true(!analysis_history_get(ANALYSIS_HISTORY_CAPACITY, &out), "Out-of-range read fails");
    expect_true(analysis_history_add(nullptr) == ESP_ERR_INVALID_ARG, "Null add validates argument");

    analysis_history_clear();
    expect_true(analysis_history_count() == 0, "Clear removes records");

    std::printf("\nResults: %d passed, %d failed\n", tests_passed, tests_failed);
    return tests_failed > 0 ? 1 : 0;
}
