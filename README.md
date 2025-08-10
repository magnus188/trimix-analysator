# ESP32-S3 Trimix Analyzer

A professional diving gas analyzer built for ESP32-S3 with LVGL GUI.

## Hardware

- **ESP32-8048S043** (4.3" 800x480 IPS Touch Display)
- **ADS1115** ADC for precise analog sensor readings
- **BME280** environmental sensor (temperature, humidity, pressure)
- **O2/CO2 analog sensors** for gas analysis

## Features

- Real-time gas composition analysis (O2, CO2, He)
- Touch-based LVGL GUI optimized for 800x480 display
- Environmental monitoring (temperature, humidity, pressure)
- Calibration management system
- Settings persistence using ESP32 Preferences
- WiFi connectivity for updates and data logging

## Development

### Prerequisites

- PlatformIO Core or PlatformIO IDE extension for VS Code
- ESP32-S3 development environment

### Building

```bash
# Build the project
pio run

# Upload to ESP32
pio run --target upload

# Monitor serial output
pio device monitor
```

### Project Structure

```
├── src/                    # Main C++ source files
│   ├── main.cpp           # Application entry point
│   ├── TrimixApp.cpp      # Main application class
│   ├── config/            # Configuration management
│   ├── display/           # LVGL display management
│   ├── sensors/           # Sensor interfacing
│   └── ui/                # UI screens and components
├── include/               # Header files
├── components/            # ESP-IDF components (LVGL)
├── main/                  # ESP-IDF main component
├── platformio.ini         # PlatformIO configuration
└── CMakeLists.txt         # CMake configuration
```

## Configuration

The project is configured for:
- **Display**: 800x480 portrait mode
- **Touch**: I2C touch controller
- **Sensors**: I2C on pins SDA=8, SCL=9
- **Build**: Arduino framework with ESP-IDF components

## License

[Add your license information here]
