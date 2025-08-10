# ESP32-8048S043 Build and Setup Guide

## Recent Fixes (Latest Update)

✅ **Fixed LVGL v9.0.0 Configuration Issues**:
- Updated `lv_conf.h` for LVGL v9.2.0 compatibility
- Removed deprecated features (`LV_USE_SHADOW`, `LV_USE_GAUGE`) 
- Fixed buffer size calculations
- Updated resolution constants (`LV_HOR_RES`, `LV_VER_RES`)

✅ **Fixed Pin Conflicts**:
- Changed I2C pins from SDA=8, SCL=9 to SDA=19, SCL=20 (avoid TFT data line conflicts)
- Fixed touch interrupt pin conflict (TOUCH_INT moved from 40 to 0)
- Updated platformio.ini and main.cpp accordingly

✅ **Updated Library Versions**:
- LVGL updated to v9.2.0 (more stable)
- ArduinoJson updated to v7.0.4
- TFT_eSPI updated to v2.5.43
- Updated Adafruit libraries to latest versions

## Current Status

The ESP32-S3 Trimix Analyzer has been converted and configured for the ESP32-8048S043 development board with the latest fixes for build compatibility. **IMPORTANT UPDATE**: The project has been migrated from TFT_eSPI to Arduino_GFX library to resolve GPIO_DIR_MASK compilation errors on ESP32-S3.

## Recent Major Fix: TFT_eSPI → Arduino_GFX Migration

✅ **Fixed ESP32-S3 GPIO_DIR_MASK Compilation Error**:
- **Root Cause**: TFT_eSPI library has compatibility issues with ESP32-S3 GPIO register definitions
- **Solution**: Migrated to Arduino_GFX library (GFX Library for Arduino v1.4.7) which is specifically designed for ESP32-S3 RGB displays
- **Hardware Support**: Arduino_GFX provides native support for ESP32-8048S043's parallel RGB LCD interface
- **Performance**: Better performance and stability for 800×480 RGB displays

✅ **Updated Library Configuration**:
- Removed `bodmer/TFT_eSPI@^2.5.43` (causing GPIO_DIR_MASK errors)
- Added `moononournation/GFX Library for Arduino@^1.4.7` (ESP32-S3 compatible)
- Updated DisplayManager to use Arduino_GFX native RGB panel support
- Removed User_Setup.h (TFT_eSPI specific configuration)

✅ **ESP32-8048S043 Specific Optimizations**:
- Native RGB panel initialization with correct pin assignments
- Proper timing configuration for 800×480 display
- Arduino_GFX optimized for ESP32-S3 with PSRAM
- Backlight control via GPIO 2

## Build Issues

### GPIO_DIR_MASK Compilation Error (RESOLVED)

**If you see errors like:**
```
error: 'GPIO_DIR_MASK' was not declared in this scope
.pio/libdeps/esp32-s3-devkitc-1/TFT_eSPI/Processors/TFT_eSPI_ESP32_S3.h:398:34
```

**This has been FIXED** by migrating from TFT_eSPI to Arduino_GFX library. The latest code uses:
- `moononournation/GFX Library for Arduino@^1.4.7` instead of TFT_eSPI
- Native ESP32-S3 RGB panel support for ESP32-8048S043
- No more GPIO register compatibility issues

### PlatformIO Platform Download

If you're experiencing build failures due to network issues downloading the ESP32 platform, try:

```bash
# Clean install with alternative registry
pio platform uninstall espressif32
export PLATFORMIO_REGISTRY_URL=https://registry.platformio.org
pio platform install espressif32@latest

# Or use offline mode if you have the platform cached
pio run --offline
```

### Display Configuration

The ESP32-8048S043 uses a parallel RGB LCD interface, not SPI. **The latest version uses Arduino_GFX library** which provides native support for this hardware:

✅ **Arduino_GFX Configuration** (Current):
- Native ESP32-S3 RGB panel support
- Optimized for 800×480 parallel RGB displays  
- No GPIO register conflicts
- Better performance and stability

❌ **Previous TFT_eSPI Configuration** (Removed):
- Had GPIO_DIR_MASK compilation errors on ESP32-S3
- Required complex parallel mode configuration
- Compatibility issues with ESP32-S3 register definitions

Alternative approaches for reference:
1. **ESP32-S3-LCD library** (specialized for ESP32-S3 LCD controllers)
2. **Direct ESP-IDF LCD APIs** (lower level, more complex)
3. **Other Arduino_GFX variants** (already implemented)

## Hardware Setup

### ESP32-8048S043 Specifications
- **Display**: 4.3" 800×480 RGB LCD (parallel interface)
- **Touch**: I2C capacitive touch controller (GT911 or similar)
- **MCU**: ESP32-S3 with PSRAM
- **Interface**: USB-C for programming and power

### Pin Configuration (Updated)
The board uses these pin assignments:
- **Display**: Parallel RGB interface (16-bit)
- **Touch I2C**: SDA=19, SCL=20, INT=0, RST=38
- **Sensor I2C**: SDA=19, SCL=20 (shared with touch)

## Development Mode

The current build includes development mode with:
- Robust initialization (continues on errors)
- Mock sensor fallback
- Extended debugging output
- Touch controller auto-detection

## Testing Steps

1. **Build the project**:
   ```bash
   make build
   # or
   ./debug_helper.sh
   ```

2. **Upload and monitor**:
   ```bash
   make dev
   ```

3. **Check serial output** for initialization messages and any errors

## Troubleshooting

### Display Not Working
- Check if parallel RGB LCD drivers are properly configured
- Verify pin assignments match your specific board variant
- Consider using ESP-IDF LCD examples as reference

### Touch Not Working
- Touch controller detection happens at runtime
- Check I2C wiring and addresses
- Monitor serial output for touch initialization messages

### Build Failures
- Network connectivity for downloading ESP32 platform
- PlatformIO installation and updates
- Library dependency resolution

## Next Steps

For full ESP32-8048S043 compatibility, consider:
1. Migrating to ESP-IDF LCD APIs for better parallel display support
2. Using board-specific libraries designed for this hardware
3. Testing with simpler examples first (like ESP-IDF LCD demos)

The current implementation provides a good starting point but may need hardware-specific adjustments for your exact board variant.