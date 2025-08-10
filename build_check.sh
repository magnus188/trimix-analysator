#!/bin/bash

# ESP32-S3 Trimix Analyzer Build Check Script
# Validates configuration files for common build issues

echo "🔍 ESP32-S3 Trimix Analyzer Build Check"
echo "========================================"

# Check if required files exist
echo "📁 Checking project structure..."
required_files=(
    "platformio.ini"
    "include/lv_conf.h"
    "include/User_Setup.h"
    "src/main.cpp"
    "include/TrimixApp.h"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file - Found"
    else
        echo "❌ $file - Missing"
        exit 1
    fi
done

# Check for pin conflicts
echo ""
echo "🔌 Checking pin configuration..."

# Extract I2C pins from platformio.ini
i2c_sda=$(grep -o "I2C_SDA=[0-9]*" platformio.ini | cut -d'=' -f2)
i2c_scl=$(grep -o "I2C_SCL=[0-9]*" platformio.ini | cut -d'=' -f2)

echo "I2C Configuration: SDA=$i2c_sda, SCL=$i2c_scl"

# Check TFT data pins from User_Setup.h
tft_pins=$(grep "^#define TFT_D" include/User_Setup.h | awk '{print $3}' | sort -n)
echo "TFT Data Pins: $tft_pins"

# Check for conflicts
if echo "$tft_pins" | grep -q "^$i2c_sda\$"; then
    echo "⚠️  WARNING: I2C SDA pin $i2c_sda conflicts with TFT data pin"
fi

if echo "$tft_pins" | grep -q "^$i2c_scl\$"; then
    echo "⚠️  WARNING: I2C SCL pin $i2c_scl conflicts with TFT data pin"
fi

# Check LVGL configuration
echo ""
echo "🎨 Checking LVGL configuration..."

if grep -q "LV_HOR_RES 800" include/lv_conf.h; then
    echo "✅ Display resolution configured correctly (800x480)"
else
    echo "❌ Display resolution not configured correctly"
fi

if grep -q "LV_USE_GAUGE" include/lv_conf.h; then
    echo "⚠️  WARNING: LV_USE_GAUGE is deprecated in LVGL v9.0+"
fi

if grep -q "LV_USE_SHADOW" include/lv_conf.h; then
    echo "⚠️  WARNING: LV_USE_SHADOW is deprecated in LVGL v9.0+"
fi

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

echo ""
echo "🚀 Build check complete!"
echo ""
echo "To build the project:"
echo "  make clean && make build"
echo ""
echo "To upload and monitor:"
echo "  make dev"