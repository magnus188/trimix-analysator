# Trimix Analyzer ESP32 Conversion

This directory contains the ESP32 version of the Trimix Analyzer, converted from the original Raspberry Pi/Kivy implementation to ESP32/LVGL with capacitive touch screen.

## Hardware Requirements

### ESP32 Board
- **ESP32-S3** microcontroller (recommended for PSRAM support)
- **Sunton ESP32-8048S043** development board or compatible
- **800x480 pixel capacitive touch display** with GT911 touch controller

### Sensors
- **ADS1115** 16-bit ADC for analog sensors (I2C address: 0x48)
- **BME280** environmental sensor for temperature, pressure, humidity (I2C address: 0x76/0x77)
- **O2 sensor** (analog output connected to ADS1115 channel 0)
- **CO2 sensor** (analog output connected to ADS1115 channel 1)

### Wiring Diagram
```
ESP32-S3 Pin    │ Connection
─────────────────┼─────────────────────────────
GPIO 11         │ Sensor I2C SDA
GPIO 12         │ Sensor I2C SCL  
GPIO 36         │ O2 sensor analog (via ADS1115)
GPIO 37         │ CO2 sensor analog (via ADS1115)
GPIO 19         │ Touch I2C SDA (GT911)
GPIO 20         │ Touch I2C SCL (GT911)
GPIO 18         │ Touch interrupt (GT911)
GPIO 38         │ Touch reset (GT911)
3.3V            │ Sensor VCC, Touch VCC
GND             │ Sensor GND, Touch GND
```

## Software Architecture

### Framework Migration
- **From**: Python + Kivy framework
- **To**: C/C++ + LVGL (Light and Versatile Graphics Library)
- **RTOS**: FreeRTOS (ESP-IDF)

### Key Components

#### 1. Main Application (`main.c`)
- Hardware initialization (LCD, touch, I2C)
- LVGL setup and configuration
- Touch screen calibration and input handling
- Main application loop

#### 2. Sensor Interface (`sensor_interface.c/h`)
- Abstracted sensor reading functions
- BME280 driver implementation
- ADC reading for analog sensors (O2, CO2)
- Sensor calibration management

#### 3. Screen Management (`trimix_screens.c/h`)
- LVGL-based UI screens matching original Kivy design
- Navigation between screens
- Real-time sensor data display
- Settings and calibration interfaces

#### 4. Hardware Configuration (`hardware.h`)
- GPIO pin definitions
- Display timing parameters
- I2C bus configuration
- Touch screen settings

## Display Configuration

### Original vs ESP32
- **Original**: 480x800 portrait (Raspberry Pi)
- **ESP32**: 800x480 landscape (ESP32-8048S043)
- **Framework**: Kivy → LVGL
- **Touch**: Resistive → Capacitive (GT911)

### Screen Adaptation
All original Kivy screens have been recreated in LVGL:

1. **Home Screen**
   - Main menu with navigation buttons
   - System status display
   - Version information

2. **Analyze Screen**
   - Real-time sensor readings in grid layout
   - Color-coded sensor cards
   - Auto-updating values (2-second intervals)

3. **Settings Screen**
   - Sensor calibration options
   - System configuration
   - About information

4. **Calibration Screen**
   - O2 sensor calibration workflow
   - Real-time readings during calibration
   - Calibration confirmation

## Building and Flashing

### Prerequisites
- **ESP-IDF v5.1+** installed and configured
- **ESP32-S3** toolchain
- USB-C cable for programming

### Build Steps
```bash
# Navigate to ESP32 directory
cd esp32/

# Set target (if not set globally)
idf.py set-target esp32s3

# Configure project (optional)
idf.py menuconfig

# Build project
idf.py build

# Flash to device
idf.py flash

# Monitor output
idf.py monitor
```

### Dependencies
The project uses ESP-IDF component manager for dependencies:
- `lvgl/lvgl` v9.x - Graphics library
- `espressif/esp_lcd_touch_gt911` - Touch controller driver

Dependencies are automatically downloaded during build.

## Sensor Calibration

### O2 Sensor Calibration
1. Navigate to Settings → O2 Calibration
2. Ensure sensor is exposed to normal air (20.9% O2)
3. Wait for readings to stabilize
4. Press "Calibrate Now" button
5. Calibration data is stored in flash memory

### CO2 Sensor Setup
- Default range: 0-5000 ppm
- Voltage range: 0-3.3V
- Calibration: Adjustable zero and span points

## Performance Characteristics

### Memory Usage
- **Flash**: ~2MB (application + LVGL)
- **RAM**: ~500KB (display buffers + application)
- **PSRAM**: ~384KB (LVGL buffers)

### Update Rates
- **Sensor readings**: 2 seconds
- **Display refresh**: 30 FPS
- **Touch response**: <50ms

### Power Consumption
- **Active display**: ~300mA @ 5V
- **Idle**: ~150mA @ 5V
- **Sleep mode**: <1mA @ 5V (future enhancement)

## Differences from Original

### Enhanced Features
1. **Higher resolution display** (800x480 vs 480x800)
2. **Capacitive touch** (more responsive than resistive)
3. **Hardware acceleration** (RGB parallel interface)
4. **Lower power consumption** (compared to Raspberry Pi)
5. **Faster boot time** (<5 seconds vs ~30 seconds)

### Limitations
1. **No WiFi implementation** (yet - planned for future)
2. **No update manager** (OTA updates planned)
3. **Simplified settings** (core functionality only)
4. **No file system** (settings stored in NVS)

## Development Notes

### Code Organization
- Maintains similar structure to original Python code
- Sensor interface abstraction allows easy testing
- Modular screen design for easy extension
- Hardware abstraction for different ESP32 boards

### Testing Strategy
- Hardware-in-the-loop testing with real sensors
- Mock sensor data for development
- LVGL simulator support (future)
- Unit tests for sensor calculations

### Future Enhancements
1. **WiFi connectivity** - Remote monitoring and updates
2. **Data logging** - Store sensor history in flash
3. **Bluetooth** - Mobile app connectivity
4. **OTA updates** - Over-the-air firmware updates
5. **Power management** - Sleep modes and battery operation
6. **Additional sensors** - Helium, Nitrogen, etc.

## Troubleshooting

### Common Issues

1. **Display not working**
   - Check power supply (5V, 2A minimum)
   - Verify display cable connections
   - Check GPIO pin assignments

2. **Touch not responding**
   - Verify GT911 I2C connections
   - Check touch calibration in code
   - Ensure proper grounding

3. **Sensors not reading**
   - Check I2C bus connections
   - Verify sensor addresses (i2cdetect)
   - Check power supply to sensors

4. **Build errors**
   - Update ESP-IDF to v5.1+
   - Clean build directory
   - Check component dependencies

### Debug Commands
```bash
# Check I2C devices
idf.py monitor
# In ESP32 console, use I2C scan functionality

# Memory usage
idf.py size

# Real-time monitoring
idf.py monitor --decode-crashes
```

## Contributing

When adding new features:
1. Follow ESP-IDF coding standards
2. Update hardware.h for new GPIO assignments
3. Add screen navigation in trimix_screens.c
4. Test with both real and mock sensors
5. Update documentation

## License

Same as original Trimix Analyzer project.