#!/bin/bash
# Host-side validation for Trimix Analyzer firmware.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEST_DIR="$PROJECT_DIR/tests"
BUILD_ROOT="$TEST_DIR/build"
mkdir -p "$BUILD_ROOT"
BUILD_DIR="$(mktemp -d "$BUILD_ROOT/run.XXXXXX")"
MATCH_FILE="$BUILD_DIR/pattern-match.txt"
CREDS_MATCH_FILE="$BUILD_DIR/credential-match.txt"
CXX="${CXX:-g++}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

cleanup() {
    rm -rf "$BUILD_DIR"
}
trap cleanup EXIT

pass() {
    echo -e "${GREEN}PASS${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "${RED}FAIL${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

warn() {
    echo -e "${YELLOW}WARN${NC} $1"
}

contains_pattern() {
    local pattern="$1"
    shift

    if command -v rg >/dev/null 2>&1; then
        rg -n "$pattern" "$@" >"$MATCH_FILE" 2>/dev/null
    else
        grep -RInE "$pattern" "$@" >"$MATCH_FILE" 2>/dev/null
    fi
}

assert_no_pattern() {
    local label="$1"
    local pattern="$2"
    shift 2

    if contains_pattern "$pattern" "$@"; then
        fail "$label"
        sed -n '1,20p' "$MATCH_FILE"
    else
        pass "$label"
    fi
}

assert_pattern() {
    local label="$1"
    local pattern="$2"
    shift 2

    if contains_pattern "$pattern" "$@"; then
        pass "$label"
    else
        fail "$label"
    fi
}

run_binary_test() {
    local label="$1"
    local output="$2"
    shift 2

    if "$CXX" -std=c++17 -Wall -Wextra -Werror "$@" -o "$output"; then
        if "$output"; then
            pass "$label"
        else
            fail "$label"
        fi
    else
        fail "Failed to compile $label"
    fi
}

echo "=========================================="
echo "  Trimix Analyzer Test Suite"
echo "=========================================="

echo ""
echo "1. Source file validation"
echo "-------------------------"

KEY_FILES=(
    "main/main.cpp"
    "main/version.h"
    "main/version.cpp"
    "main/services/ota_service.cpp"
    "main/services/wifi_service.cpp"
    "main/services/analysis_history.cpp"
    "main/services/cylinder_profiles.cpp"
    "main/services/mix_label_service.cpp"
    "main/sensors/sensor_interface.cpp"
    "main/analysis/analysis_calculator.cpp"
    "main/ui/screens/analyse/analyse_screen.cpp"
    "main/ui/screens/history/history_screen.cpp"
    "main/ui/screens/cylinders/cylinders_screen.cpp"
    "main/ui/screens/settings/calibrate_screen.cpp"
    "main/ui/screens/settings/safety_screen.cpp"
    "main/ui/screens/dive_planner/gas_calculator.cpp"
    "main/ui/lvgl/lvgl_port.cpp"
    "main/ui/lvgl/lvgl_port.h"
    "main/ui/components/status_icons.cpp"
    "main/idf_component.yml"
    "sdkconfig.defaults.esp32p4"
    "sdkconfig.defaults.esp32p4.pre3"
    "sdkconfig.defaults.esp32p4.v3"
    "partitions.esp32p4.pre3.csv"
    "partitions.csv"
    "dependencies.lock"
    "scripts/detect_p4_revision.sh"
    "scripts/set_version.sh"
    "tests/test_analysis_calculator.cpp"
    "tests/test_sensor_interface.cpp"
    "tests/test_analysis_history.cpp"
    "tests/test_cylinder_profiles.cpp"
    "tests/test_gas_calculator.cpp"
    "tests/test_version.cpp"
    "simulator/CMakeLists.txt"
    "simulator/src/main.cpp"
    "simulator/tests/test_ui_smoke.cpp"
)

for file in "${KEY_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        pass "Found $file"
    else
        fail "Missing $file"
    fi
done

echo ""
echo "2. Static safety checks"
echo "-----------------------"

assert_no_pattern \
    "No runtime scroll debug hook remains" \
    "debug_log_screen_state|SCROLL CHANGED" \
    "$PROJECT_DIR/main"

assert_no_pattern \
    "No unsafe strcpy/sprintf calls in firmware sources" \
    "\\b(strcpy|sprintf)\\s*\\(" \
    "$PROJECT_DIR/main"

assert_no_pattern \
    "No unchecked direct task creation calls" \
    "^[[:space:]]*xTaskCreate(PinnedToCore)?\\s*\\(" \
    "$PROJECT_DIR/main"

assert_no_pattern \
    "Background services do not schedule LVGL work" \
    "lv_async_call" \
    "$PROJECT_DIR/main"

assert_no_pattern \
    "Application no longer runs a custom LVGL timer loop" \
    "lv_timer_handler\\s*\\(" \
    "$PROJECT_DIR/main/main.cpp"

assert_no_pattern \
    "Removed ESP32-S3 display backend is not referenced by firmware" \
    "esp32s3|ESP32S3|ESP32-S3|ESP32-8048S043" \
    "$PROJECT_DIR/main" \
    "$PROJECT_DIR/Makefile" \
    "$PROJECT_DIR/sdkconfig.defaults" \
    "$PROJECT_DIR/sdkconfig.defaults.esp32p4" \
    "$PROJECT_DIR/sdkconfig.defaults.esp32p4.pre3" \
    "$PROJECT_DIR/sdkconfig.defaults.esp32p4.v3"

assert_pattern \
    "Display backend uses native rotation without PPA" \
    "ESP_LV_ADAPTER_ROTATE_0" \
    "$PROJECT_DIR/main/ui/lvgl/lvgl_port.cpp"

assert_pattern \
    "Display backend uses triple-partial tear avoidance" \
    "ESP_LV_ADAPTER_TEAR_AVOID_MODE_TRIPLE_PARTIAL" \
    "$PROJECT_DIR/main/ui/lvgl/lvgl_port.cpp"

assert_pattern \
    "Firmware target is ESP32-P4" \
    'TARGET := esp32p4' \
    "$PROJECT_DIR/Makefile"

assert_pattern \
    "Dependency lock targets ESP32-P4" \
    '^target: esp32p4$' \
    "$PROJECT_DIR/dependencies.lock"

assert_pattern \
    "Dependency lock pins ESP-IDF 5.5.4" \
    'version: 5\.5\.4' \
    "$PROJECT_DIR/dependencies.lock"

assert_pattern \
    "Dependency lock pins LVGL 9.4.0" \
    'version: 9\.4\.0' \
    "$PROJECT_DIR/dependencies.lock"

assert_pattern \
    "OTA rollback remains enabled" \
    'CONFIG_BOOTLOADER_APP_ROLLBACK_ENABLE=y' \
    "$PROJECT_DIR/sdkconfig.defaults"

assert_pattern \
    "New OTA images are validated after application startup" \
    'esp_ota_mark_app_valid_cancel_rollback' \
    "$PROJECT_DIR/main/main.cpp"

assert_no_pattern \
    "WiFi scan results do not use heap churn" \
    "g_scan_results.*malloc|malloc\\(sizeof\\(wifi_ap_record_t\\)|free\\(g_scan_results\\)" \
    "$PROJECT_DIR/main/services/wifi_service.cpp"

assert_no_pattern \
    "Host tests do not copy gas calculator implementation" \
    "Copy gas calculator functions|namespace gas_calc" \
    "$PROJECT_DIR/tests"

if contains_pattern "(password|secret|api_key)[[:space:]]*=[[:space:]]*\\\"[^\\\"]+\\\"" "$PROJECT_DIR/main"; then
    if grep -Ev "example|placeholder|<" "$MATCH_FILE" >"$CREDS_MATCH_FILE"; then
        fail "Potential hardcoded credentials found"
        sed -n '1,20p' "$CREDS_MATCH_FILE"
    else
        pass "No hardcoded credentials detected"
    fi
else
    pass "No hardcoded credentials detected"
fi

TODO_COUNT=0
if contains_pattern "TODO|FIXME|XXX|HACK" "$PROJECT_DIR/main"; then
    TODO_COUNT="$(wc -l <"$MATCH_FILE" | tr -d ' ')"
fi
if [ "$TODO_COUNT" -le 10 ]; then
    pass "Debug/TODO marker count within current baseline ($TODO_COUNT found)"
else
    warn "Found $TODO_COUNT TODO/FIXME/HACK markers"
fi

echo ""
echo "3. Production unit tests"
echo "------------------------"

if command -v "$CXX" >/dev/null 2>&1; then
    run_binary_test \
        "Gas calculator production tests passed" \
        "$BUILD_DIR/test_gas_calculator" \
        -I"$PROJECT_DIR/main/ui/screens/dive_planner" \
        "$TEST_DIR/test_gas_calculator.cpp" \
        "$PROJECT_DIR/main/ui/screens/dive_planner/gas_calculator.cpp"

    run_binary_test \
        "Analysis calculator tests passed" \
        "$BUILD_DIR/test_analysis_calculator" \
        -I"$PROJECT_DIR/main" \
        -I"$PROJECT_DIR/simulator/stubs" \
        "$TEST_DIR/test_analysis_calculator.cpp" \
        "$PROJECT_DIR/main/analysis/analysis_calculator.cpp"

    run_binary_test \
        "Sensor simulation tests passed" \
        "$BUILD_DIR/test_sensor_interface" \
        -I"$PROJECT_DIR/main" \
        -I"$PROJECT_DIR/simulator/stubs" \
        "$TEST_DIR/test_sensor_interface.cpp" \
        "$PROJECT_DIR/main/sensors/sensor_interface.cpp"

    run_binary_test \
        "Analysis history tests passed" \
        "$BUILD_DIR/test_analysis_history" \
        -DTRIMIX_SIMULATOR=1 \
        -I"$PROJECT_DIR/main" \
        -I"$PROJECT_DIR/simulator/stubs" \
        "$TEST_DIR/test_analysis_history.cpp" \
        "$PROJECT_DIR/main/services/analysis_history.cpp"

    run_binary_test \
        "Cylinder profile and label tests passed" \
        "$BUILD_DIR/test_cylinder_profiles" \
        -DTRIMIX_SIMULATOR=1 \
        -I"$PROJECT_DIR/main" \
        -I"$PROJECT_DIR/simulator/stubs" \
        "$TEST_DIR/test_cylinder_profiles.cpp" \
        "$PROJECT_DIR/main/services/cylinder_profiles.cpp" \
        "$PROJECT_DIR/main/services/mix_label_service.cpp" \
        "$PROJECT_DIR/main/analysis/analysis_calculator.cpp" \
        "$PROJECT_DIR/main/services/analysis_history.cpp"

    run_binary_test \
        "Version consistency tests passed" \
        "$BUILD_DIR/test_version" \
        -I"$PROJECT_DIR/main" \
        "$TEST_DIR/test_version.cpp" \
        "$PROJECT_DIR/main/version.cpp"
else
    warn "$CXX not found, skipping host unit tests"
fi

echo ""
echo "4. Simulator CMake tests"
echo "------------------------"

HOST_BUILD_DIR="$BUILD_DIR/simulator"
HOST_CONFIG_LOG="$BUILD_DIR/simulator-configure.log"
HOST_BUILD_LOG="$BUILD_DIR/simulator-build.log"
SIMULATOR_LVGL_CMAKE="$PROJECT_DIR/managed_components/lvgl__lvgl/CMakeLists.txt"

if command -v cmake >/dev/null 2>&1 && command -v pkg-config >/dev/null 2>&1 && pkg-config --exists sdl2 && [ -f "$SIMULATOR_LVGL_CMAKE" ]; then
    if cmake -S "$PROJECT_DIR/simulator" -B "$HOST_BUILD_DIR" >"$HOST_CONFIG_LOG" 2>&1; then
        pass "Configured simulator CMake build"
    else
        fail "Failed to configure simulator CMake build"
        sed -n '1,120p' "$HOST_CONFIG_LOG"
    fi

    if cmake --build "$HOST_BUILD_DIR" >"$HOST_BUILD_LOG" 2>&1; then
        pass "Built simulator and CMake tests"
    else
        fail "Failed to build simulator and CMake tests"
        sed -n '1,160p' "$HOST_BUILD_LOG"
    fi

    if ctest --test-dir "$HOST_BUILD_DIR" --output-on-failure; then
        pass "Simulator CMake tests passed"
    else
        fail "Simulator CMake tests failed"
    fi
else
    if [ "${TRIMIX_REQUIRE_SIMULATOR:-0}" = "1" ]; then
        fail "Simulator dependencies unavailable"
    else
        warn "cmake/pkg-config/SDL2/LVGL managed component not available, skipping simulator CMake tests"
    fi
fi

echo ""
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"
echo "=========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
    echo -e "\n${RED}Tests failed.${NC}"
    exit 1
fi

echo -e "\n${GREEN}All tests passed.${NC}"
