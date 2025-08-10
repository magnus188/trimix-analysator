# ESP32-8048S043 Build and Setup Guide

## Current Status

The ESP32-S3 Trimix Analyzer has been converted and configured for the ESP32-8048S043 development board. However, there are some configuration challenges specific to this board that need to be addressed.

## Build Issues

### PlatformIO Platform Download
If you're experiencing build failures, it's likely due to network issues downloading the ESP32 platform. Try:

```bash
# Clean install
pio platform uninstall espressif32
pio platform install espressif32@latest
```

### Display Configuration
The ESP32-8048S043 uses a parallel RGB LCD interface, not SPI. The current TFT_eSPI configuration may need adjustment. Alternative approaches:

1. **ESP32-S3-LCD library** (recommended for this board)
2. **Direct ESP-IDF LCD APIs**
3. **LVGL with custom display drivers**

## Hardware Setup

### ESP32-8048S043 Specifications
- **Display**: 4.3" 800×480 RGB LCD (parallel interface)
- **Touch**: I2C capacitive touch controller (GT911 or similar)
- **MCU**: ESP32-S3 with PSRAM
- **Interface**: USB-C for programming and power

### Pin Configuration
The board uses these approximate pin assignments:
- **Display**: Parallel RGB interface (16-bit)
- **Touch I2C**: SDA=19, SCL=20, INT=40, RST=38
- **Sensor I2C**: SDA=8, SCL=9 (configurable)

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