#!/bin/bash
# Simple test script for Trimix Analyzer
# Runs compile checks and unit tests

set -e

echo "=========================================="
echo "  Trimix Analyzer Test Suite"
echo "=========================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEST_DIR="$PROJECT_DIR/tests"
BUILD_DIR="$TEST_DIR/build"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

pass() {
    echo -e "${GREEN}✓ $1${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "${RED}✗ $1${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

warn() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Create build directory
mkdir -p "$BUILD_DIR"

echo ""
echo "1. Source file validation"
echo "--------------------------"

# Check that key source files exist
KEY_FILES=(
    "main/main.cpp"
    "main/version.h"
    "main/version.cpp"
    "main/services/ota_service.cpp"
    "main/services/wifi_service.cpp"
)

for file in "${KEY_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        pass "Found $file"
    else
        fail "Missing $file"
    fi
done

echo ""
echo "2. Code quality checks"
echo "----------------------"

# Check for debug leftovers
DEBUG_PATTERNS="TODO|FIXME|XXX|HACK|printf.*debug|ESP_LOG[IWED].*test"
DEBUG_COUNT=$(grep -rE "$DEBUG_PATTERNS" "$PROJECT_DIR/main" --include="*.cpp" --include="*.h" 2>/dev/null | wc -l || echo "0")
if [ "$DEBUG_COUNT" -lt 10 ]; then
    pass "Debug markers within acceptable range ($DEBUG_COUNT found)"
else
    warn "Found $DEBUG_COUNT debug markers (TODO/FIXME/etc)"
fi

# Check for hardcoded credentials (security)
if grep -rE "(password|secret|api_key)\s*=\s*\"[^\"]+\"" "$PROJECT_DIR/main" --include="*.cpp" --include="*.h" 2>/dev/null | grep -v "example\|placeholder\|<" > /dev/null; then
    fail "Potential hardcoded credentials found"
else
    pass "No hardcoded credentials detected"
fi

echo ""
echo "3. Gas calculator unit tests"
echo "----------------------------"

# Create and compile gas calculator test
cat > "$BUILD_DIR/test_gas_calc.cpp" << 'TESTCODE'
#include <cstdio>
#include <cmath>
#include <cstdlib>

// Copy gas calculator functions for host testing
namespace gas_calc {
    float calc_mod(float o2_percent, float ppo2_max) {
        if (o2_percent <= 0) return 0;
        return ((ppo2_max / (o2_percent / 100.0f)) - 1.0f) * 10.0f;
    }
    
    float calc_ppo2(float depth_m, float o2_percent) {
        float pressure_ata = 1.0f + (depth_m / 10.0f);
        return pressure_ata * (o2_percent / 100.0f);
    }
    
    float calc_o2_for_depth_ppo2(float depth_m, float ppo2) {
        float pressure_ata = 1.0f + (depth_m / 10.0f);
        return (ppo2 / pressure_ata) * 100.0f;
    }
    
    float calc_ead(float depth_m, float o2_percent, float he_percent) {
        float n2_percent = 100.0f - o2_percent - he_percent;
        if (n2_percent <= 0) return 0;
        float depth_ata = 1.0f + (depth_m / 10.0f);
        float n2_partial = depth_ata * (n2_percent / 100.0f);
        return ((n2_partial / 0.79f) - 1.0f) * 10.0f;
    }
    
    float calc_gas_density(float depth_m, float o2_percent, float he_percent) {
        float pressure_ata = 1.0f + (depth_m / 10.0f);
        float n2_percent = 100.0f - o2_percent - he_percent;
        // Densities at STP in g/L: O2=1.429, N2=1.251, He=0.179
        float density = pressure_ata * (
            (o2_percent / 100.0f) * 1.429f +
            (n2_percent / 100.0f) * 1.251f +
            (he_percent / 100.0f) * 0.179f
        );
        return density;
    }
}

int tests_passed = 0;
int tests_failed = 0;

void assert_near(float actual, float expected, float tolerance, const char* test_name) {
    if (fabs(actual - expected) <= tolerance) {
        printf("  ✓ %s (%.2f ≈ %.2f)\n", test_name, actual, expected);
        tests_passed++;
    } else {
        printf("  ✗ %s (got %.2f, expected %.2f)\n", test_name, actual, expected);
        tests_failed++;
    }
}

int main() {
    printf("Gas Calculator Tests\n");
    printf("====================\n\n");
    
    // MOD tests
    printf("MOD calculations:\n");
    assert_near(gas_calc::calc_mod(100, 1.6), 6.0, 0.1, "100% O2 @ 1.6 PPO2 = 6m");
    assert_near(gas_calc::calc_mod(32, 1.4), 33.75, 0.5, "32% O2 @ 1.4 PPO2 = 33.75m");
    assert_near(gas_calc::calc_mod(21, 1.4), 56.67, 0.5, "21% O2 @ 1.4 PPO2 = 56.67m");
    
    // PPO2 tests
    printf("\nPPO2 calculations:\n");
    assert_near(gas_calc::calc_ppo2(30, 32), 1.28, 0.01, "32% O2 @ 30m = 1.28 PPO2");
    assert_near(gas_calc::calc_ppo2(0, 21), 0.21, 0.01, "21% O2 @ surface = 0.21 PPO2");
    assert_near(gas_calc::calc_ppo2(40, 21), 1.05, 0.01, "Air @ 40m = 1.05 PPO2");
    
    // O2 for depth/PPO2 tests
    printf("\nO2 percent for depth/PPO2:\n");
    assert_near(gas_calc::calc_o2_for_depth_ppo2(30, 1.4), 35.0, 0.5, "1.4 PPO2 @ 30m = 35% O2");
    assert_near(gas_calc::calc_o2_for_depth_ppo2(60, 1.4), 20.0, 0.5, "1.4 PPO2 @ 60m = 20% O2");
    
    // EAD tests
    printf("\nEAD calculations:\n");
    assert_near(gas_calc::calc_ead(40, 32, 0), 33.0, 1.0, "EAN32 @ 40m = ~33m EAD");
    assert_near(gas_calc::calc_ead(60, 21, 35), 29.0, 1.0, "21/35 @ 60m = ~29m EAD");
    assert_near(gas_calc::calc_ead(40, 21, 0), 40.0, 0.5, "Air @ 40m = 40m EAD");
    
    // Gas density tests
    printf("\nGas density calculations:\n");
    assert_near(gas_calc::calc_gas_density(0, 21, 0), 1.29, 0.05, "Air at surface = ~1.29 g/L");
    assert_near(gas_calc::calc_gas_density(40, 21, 0), 6.45, 0.2, "Air at 40m = ~6.45 g/L");
    assert_near(gas_calc::calc_gas_density(60, 18, 45), 5.6, 0.3, "18/45 at 60m = ~5.6 g/L");
    
    printf("\n====================\n");
    printf("Results: %d passed, %d failed\n", tests_passed, tests_failed);
    
    return tests_failed > 0 ? 1 : 0;
}
TESTCODE

# Compile and run test
if command -v g++ &> /dev/null; then
    if g++ -std=c++11 -o "$BUILD_DIR/test_gas_calc" "$BUILD_DIR/test_gas_calc.cpp" 2>/dev/null; then
        if "$BUILD_DIR/test_gas_calc"; then
            pass "Gas calculator tests passed"
        else
            fail "Gas calculator tests failed"
        fi
    else
        fail "Failed to compile gas calculator tests"
    fi
else
    warn "g++ not found, skipping unit tests"
fi

echo ""
echo "4. Version consistency check"
echo "----------------------------"

# Check version.h has valid version
if grep -q 'TRIMIX_ANALYZER_VERSION "' "$PROJECT_DIR/main/version.h"; then
    VERSION=$(grep 'TRIMIX_ANALYZER_VERSION "' "$PROJECT_DIR/main/version.h" | sed 's/.*"\(.*\)".*/\1/')
    if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        pass "Valid version format: $VERSION"
    else
        fail "Invalid version format: $VERSION"
    fi
else
    fail "Version not found in version.h"
fi

# Check GitHub repo is configured
if grep -q 'GITHUB_OWNER "magnus188"' "$PROJECT_DIR/main/version.h"; then
    pass "GitHub owner configured"
else
    fail "GitHub owner not configured"
fi

echo ""
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"
echo "=========================================="

# Cleanup
rm -rf "$BUILD_DIR"

if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "\n${RED}Tests failed!${NC}"
    exit 1
else
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
fi
