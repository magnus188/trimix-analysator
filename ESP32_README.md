# ESP32-S3 Trimix Analyzer

This is the ESP32-S3 version of the Trimix Analyzer, converted from the original Python/Raspberry Pi implementation. The ESP32 version provides the same functionality in a more compact, embedded form factor with a modern LVGL-based touch interface.

## Hardware Requirements

### Target Development Board
- **ESP32-8048S043** - 4.3" 800×480 IPS Touch LCD Display Module
- ESP32-S3 Wroom chip with PSRAM
- Built-in display controller and touch interface

### Sensors (Same as original)
- **ADS1115** 16-bit ADC (I2C address: 0x48) for analog sensor readings
- **BME280** environmental sensor (I2C address: 0x76/0x77) for temperature, pressure, humidity
- **O2 sensor** - Analog oxygen sensor connected to ADS1115 channel 0
- **CO2 sensor** - Analog carbon dioxide sensor connected to ADS1115 channel 1

### Wiring
```
ESP32-S3 <-> Sensors
GPIO 8 (SDA) <-> ADS1115 SDA, BME280 SDA
GPIO 9 (SCL) <-> ADS1115 SCL, BME280 SCL  
3.3V         <-> Sensor VCC
GND          <-> Sensor GND
```

## Software Features

### Core Functionality
- **Real-time Sensor Monitoring**: O2, CO2, temperature, pressure, humidity
- **Touch Interface**: Modern LVGL-based UI optimized for 800×480 displays
- **Calibration**: O2 and CO2 sensor calibration with persistent storage
- **Alarms**: Configurable O2 and CO2 alarm thresholds with visual indicators
- **Settings**: Comprehensive settings management with tabbed interface

### ESP32-Specific Features
- **WiFi Support**: Configurable wireless connectivity
- **Persistent Storage**: Settings saved to ESP32 flash using Preferences library
- **Power Management**: Display brightness control and auto-sleep functionality
- **Mock Sensors**: Intelligent fallback to simulated sensors for development
- **Hardware Detection**: Automatic I2C device scanning and sensor initialization

## Getting Started

### Prerequisites
- [PlatformIO](https://platformio.org/) installed
- ESP32-8048S043 development board or compatible ESP32-S3 with display
- USB-C cable for programming

### Building and Uploading

1. **Clone the repository**:
   ```bash
   git clone https://github.com/magnus188/trimix-analysator.git
   cd trimix-analysator
   ```

2. **Open in PlatformIO**:
   ```bash
   pio init --ide vscode
   ```
   Or open the project folder in PlatformIO IDE

3. **Build the project**:
   ```bash
   pio run
   ```

4. **Upload to ESP32**:
   ```bash
   pio run --target upload
   ```

5. **Monitor serial output**:
   ```bash
   pio device monitor
   ```

### Configuration

The project is pre-configured for the ESP32-8048S043 board. If using different hardware, adjust these settings in `platformio.ini`:

```ini
; Display configuration
-DDISPLAY_WIDTH=800
-DDISPLAY_HEIGHT=480

; I2C pins
-DI2C_SDA=8
-DI2C_SCL=9

; Sensor addresses
-DADS1115_ADDR=0x48
-DBME280_ADDR=0x76
```

## User Interface

### Home Screen
- **Menu Cards**: Large touch-friendly buttons for navigation
- **Quick Display**: Live O2 and temperature readings
- **Status Indicator**: Shows sensor status and demo mode
- **Navigation**: Access to Analyze, Settings, Calibration, and About

### Analyze Screen
- **Large O2 Display**: Prominent oxygen percentage with color-coded alarms
- **Sensor Grid**: Temperature, pressure, humidity, and CO2 in organized cards
- **Real-time Updates**: Live sensor readings updated every 500ms
- **Alarm States**: Visual feedback with color changes for alarm conditions

### Settings Screen (Tabbed Interface)
- **Display Tab**: Brightness control, auto-sleep settings
- **Sensors Tab**: Calibration controls, update interval settings
- **WiFi Tab**: Network configuration and connection status
- **Alarms Tab**: O2/CO2 alarm threshold configuration

## Development

### Project Structure
```
├── platformio.ini              # PlatformIO configuration
├── include/
│   ├── lv_conf.h               # LVGL configuration
│   ├── TrimixApp.h             # Main application
│   ├── sensors/SensorManager.h # Sensor interface
│   ├── display/DisplayManager.h # Display and touch
│   ├── config/SettingsManager.h # Settings storage
│   └── ui/                     # UI screen headers
├── src/
│   ├── main.cpp                # Application entry point
│   ├── TrimixApp.cpp           # Main application logic
│   ├── sensors/SensorManager.cpp # Sensor implementation
│   ├── display/DisplayManager.cpp # Display implementation
│   ├── config/SettingsManager.cpp # Settings implementation
│   └── ui/                     # UI screen implementations
└── lib/                        # Custom libraries
```

### Key Libraries Used
- **LVGL 9.0+**: Modern embedded graphics library
- **TFT_eSPI**: ESP32 display driver
- **Adafruit Sensor Libraries**: ADS1115 and BME280 support
- **WiFi**: ESP32 wireless connectivity
- **Preferences**: ESP32 flash storage
- **ArduinoJson**: Configuration and data serialization

### Mock Sensors
The system automatically enables mock sensors when real hardware is not detected:
- Simulates realistic O2, CO2, temperature, pressure, and humidity values
- Includes variations and daily cycles for testing
- Useful for UI development and testing without hardware

### Adding New Features
1. **New Screens**: Create header/source files in `include/ui/` and `src/ui/`
2. **Sensor Types**: Extend `SensorManager` class with new interfaces
3. **Settings**: Add new parameters to `SettingsManager`
4. **UI Elements**: Use LVGL widgets and follow existing patterns

## Calibration

### O2 Sensor Calibration
1. Expose O2 sensor to ambient air (20.9% O2)
2. Navigate to Settings → Sensors → O2 Calibration
3. Press "CALIBRATE" button to capture current voltage as 20.9% reference
4. Calibration value is automatically saved to flash

### CO2 Sensor Calibration
CO2 calibration requires specialized equipment and is not yet implemented in the UI.

## Troubleshooting

### Display Issues
- Verify display connector is properly seated
- Check `lv_conf.h` resolution settings match your display
- Monitor serial output for LVGL initialization messages

### Sensor Issues
- Use `i2cdetect` equivalent in serial monitor to scan I2C devices
- Expected addresses: 0x48 (ADS1115), 0x76/0x77 (BME280)
- System automatically falls back to mock sensors if hardware not found

### WiFi Issues  
- Verify SSID and password in Settings → WiFi
- Check WiFi signal strength and 2.4GHz compatibility
- Monitor serial output for connection status

### Memory Issues
- ESP32-S3 with PSRAM required for LVGL buffers
- Monitor free heap in serial output
- Reduce display buffer size if needed

## Performance

### Optimizations
- **Display**: Partial refresh enabled for smooth 60fps UI
- **Sensors**: Configurable update rates (500ms - 5s)
- **Memory**: DMA-capable buffers for display operations
- **Power**: Auto-sleep and brightness control

### Resource Usage
- **RAM**: ~200KB for LVGL buffers and application
- **Flash**: ~1.5MB for application code and LVGL assets
- **CPU**: ~20% for UI updates and sensor processing

## Migration from Python Version

### Preserved Features
- All sensor reading functionality
- Calibration capabilities  
- Settings and configuration
- Visual design language
- Safety alarms

### Improvements
- **Performance**: Native C++ vs interpreted Python
- **Memory**: Embedded-optimized vs full Linux stack
- **Power**: ESP32 power management vs always-on Pi
- **Size**: Compact single-board solution
- **Touch**: Optimized for direct touch interaction

### Configuration Migration
Settings from the Python version can be manually transferred:
- O2 calibration values
- Alarm thresholds
- WiFi credentials
- Display preferences

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test on actual hardware when possible
4. Submit pull request with detailed description

## License

Same license as the original Python version.

---

**Hardware Recommendation**: ESP32-8048S043 provides the best out-of-box experience with integrated display, touch, and ESP32-S3 with PSRAM. Other ESP32-S3 boards can be used with external displays by adjusting the configuration.