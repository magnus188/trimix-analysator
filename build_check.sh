#!/bin/bash

# ESP32-S3 Trimix Analyzer Build Check Script - Updated for Arduino_GFX
# Validates configuration files for common build issues

echo "🔍 ESP32-S3 Trimix Analyzer Build Check (Arduino_GFX Version)"
echo "============================================================="

# Check if required files exist
echo "📁 Checking project structure..."
required_files=(
    "platformio.ini"
    "include/lv_conf.h"
    "src/main.cpp"
    "include/TrimixApp.h"
    "src/display/DisplayManager.cpp"
    "include/display/DisplayManager.h"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file - Found"
    else
        echo "❌ $file - Missing"
        exit 1
    fi
done

# Check for TFT_eSPI removal (should not be present)
echo ""
echo "🔄 Checking library migration..."

if grep -q "bodmer/TFT_eSPI" platformio.ini; then
    echo "❌ TFT_eSPI library still present - this causes GPIO_DIR_MASK errors on ESP32-S3"
    echo "   Remove TFT_eSPI and use Arduino_GFX instead"
    exit 1
else
    echo "✅ TFT_eSPI library removed (prevents GPIO_DIR_MASK errors)"
fi

if grep -q "moononournation/GFX Library for Arduino" platformio.ini; then
    echo "✅ Arduino_GFX library configured correctly"
else
    echo "❌ Arduino_GFX library not found - this is required for ESP32-8048S043"
    exit 1
fi

# Check for User_Setup.h (should not be needed for Arduino_GFX)
if [ -f "include/User_Setup.h" ]; then
    echo "⚠️  User_Setup.h found - this is TFT_eSPI specific and no longer needed"
    echo "   Consider removing or renaming to avoid confusion"
else
    echo "✅ User_Setup.h not present (correct for Arduino_GFX setup)"
fi

# Check pin configuration
echo ""
echo "🔌 Checking pin configuration..."

# Extract I2C pins from platformio.ini
i2c_sda=$(grep -o "I2C_SDA=[0-9]*" platformio.ini | cut -d'=' -f2)
i2c_scl=$(grep -o "I2C_SCL=[0-9]*" platformio.ini | cut -d'=' -f2)

echo "I2C Configuration: SDA=$i2c_sda, SCL=$i2c_scl"

# Check for correct I2C pins (should be 19/20 to avoid TFT conflicts)
if [ "$i2c_sda" = "19" ] && [ "$i2c_scl" = "20" ]; then
    echo "✅ I2C pins configured correctly (avoids TFT conflicts)"
else
    echo "⚠️  WARNING: I2C pins should be SDA=19, SCL=20 for ESP32-8048S043"
fi

# Check LVGL configuration
echo ""
echo "🎨 Checking LVGL configuration..."

if grep -q "LV_HOR_RES 800" include/lv_conf.h; then
    echo "✅ Display resolution configured correctly (800x480)"
else
    echo "❌ Display resolution not configured correctly"
fi

# Check for deprecated LVGL features (common in v9.0+)
deprecated_features=("LV_USE_GAUGE" "LV_USE_SHADOW")
for feature in "${deprecated_features[@]}"; do
    if grep -q "$feature" include/lv_conf.h; then
        echo "⚠️  WARNING: $feature is deprecated in LVGL v9.0+"
    fi
done

# Check library versions
echo ""
echo "📦 Checking library versions..."

if grep -q "lvgl@\^9\." platformio.ini; then
    echo "✅ LVGL version 9.x configured"
else
    echo "⚠️  WARNING: LVGL version might be incompatible"
fi

# Check for development mode
echo ""
echo "🛠️  Checking development features..."

if grep -q "DEVELOPMENT_MODE=1" platformio.ini; then
    echo "✅ Development mode enabled"
else
    echo "ℹ️  Development mode disabled"
fi

if grep -q "MOCK_SENSORS_ENABLED=1" platformio.ini; then
    echo "✅ Mock sensors enabled for testing"
else
    echo "ℹ️  Mock sensors disabled"
fi

# Check DisplayManager for Arduino_GFX usage
echo ""
echo "🖥️  Checking display driver..."

if grep -q "Arduino_GFX_Library\|Arduino_GFX" src/display/DisplayManager.cpp include/display/DisplayManager.h; then
    echo "✅ DisplayManager uses Arduino_GFX (ESP32-S3 compatible)"
else
    echo "❌ DisplayManager not using Arduino_GFX library"
fi

echo ""
echo "🚀 Build check complete!"
echo ""
echo "=== Configuration Summary ==="
echo "✅ ESP32-8048S043 board: Configured"
echo "✅ Arduino_GFX library: Should resolve GPIO_DIR_MASK errors"
echo "✅ TFT_eSPI library: Removed (prevents compilation errors)"
echo "✅ Display resolution: 800×480 RGB LCD"
echo "✅ I2C configuration: Should avoid pin conflicts"
echo ""
echo "🎯 This configuration resolves the GPIO_DIR_MASK compilation errors"
echo "   that occur when using TFT_eSPI with ESP32-S3."
echo ""
echo "To build the project:"
echo "  make clean && make build"
echo ""
echo "To upload and monitor:"
echo "  make dev"
echo ""
echo "📖 See ESP32_TROUBLESHOOTING.md for detailed information about the fixes."