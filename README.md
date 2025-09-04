# Trimix Analyzer - ESP32

A modern ESP32-based gas analyzer for trimix diving gas mixtures, featuring real-time O2, CO2, temperature, pressure, and humidity monitoring with a capacitive touch screen interface.

## 🎯 Overview

This ESP32 implementation provides a compact, efficient, and cost-effective solution for analyzing diving gas mixtures. Built with the ESP32-S3 microcontroller and LVGL GUI framework, it delivers professional-grade performance in a portable package.

## ✨ Features

- **Real-time Monitoring**: O2, CO2, temperature, pressure, and humidity sensors
- **Touch Interface**: 480x800 capacitive touch screen (portrait orientation)
- **Fast Performance**: <5 second boot time, responsive touch interface
- **Low Power**: ~300mA @ 5V power consumption
- **Compact Design**: Embedded microcontroller solution
- **Professional GUI**: Modern LVGL-based interface with smooth animations

## 🛠️ Hardware Requirements

### Core Components
- **ESP32-S3 Development Board** (ESP32-8048S043 recommended)
- **4.3" Capacitive Touch Display** (480x800, GT911 touch controller)
- **Sensors:**
  - ADS1115 16-bit ADC (I2C address: 0x48)
  - BME280 temperature/pressure/humidity sensor (I2C address: 0x76/0x77)
  - O2 sensor (analog, connected to ADS1115 channel 0)
  - CO2 sensor (analog, connected to ADS1115 channel 1)

### Wiring Diagram
```
ESP32-S3 <-> Sensors
GPIO 8 (SDA)  <-> ADS1115 SDA, BME280 SDA
GPIO 9 (SCL)  <-> ADS1115 SCL, BME280 SCL
3.3V          <-> Sensor VCC
GND           <-> Sensor GND
```

## 🚀 Quick Start

### Prerequisites
- ESP-IDF v5.0 or later
- ESP32-S3 development board
- USB-C cable for programming and power

### Build and Flash

```bash
# Clone the repository
git clone https://github.com/magnus188/trimix-analysator.git
cd trimix-analysator/esp32

# Set target and configure
idf.py set-target esp32s3
idf.py menuconfig  # Optional: customize configuration

# Build and flash
idf.py build flash monitor
```

### First Boot
1. Connect your ESP32-S3 board via USB-C
2. Flash the firmware using the commands above
3. The device will boot and display the main screen
4. Navigate through the interface using touch gestures

## 📱 User Interface

The ESP32 implementation features three main screens optimized for portrait mode:

### Home Screen
- Navigation buttons for Analyze and Settings
- System status indicators
- Quick access to core functions

### Analyze Screen
- Real-time sensor readings in a 2x3 grid layout
- Large, easy-to-read values with units
- Color-coded status indicators
- Automatic refresh every second

### Settings Screen
- Sensor calibration options
- Display configuration
- System information
- Calibration workflows

## 🏗️ Architecture

### Software Stack
- **Framework**: ESP-IDF + LVGL
- **Language**: C/C++
- **Display**: LVGL graphics library
- **Sensors**: I2C communication
- **Touch**: Capacitive touch with gesture support

### Project Structure
```
esp32/
├── main/
│   ├── main.c                 # Application entry point
│   ├── trimix_screens.c       # GUI screens implementation
│   ├── sensor_interface.c     # Hardware abstraction layer
│   ├── hardware.h             # Hardware pin definitions
│   └── lv_conf.h             # LVGL configuration
├── CMakeLists.txt            # Build configuration
├── sdkconfig.defaults        # ESP32 configuration
└── README.md                 # Detailed documentation
```

## ⚙️ Configuration

### Display Settings
- **Resolution**: 480x800 (portrait)
- **Touch Controller**: GT911 capacitive
- **Interface**: RGB parallel
- **Backlight**: PWM controlled

### Sensor Configuration
- **I2C Frequency**: 100kHz
- **Sampling Rate**: 1Hz (configurable)
- **Calibration**: Built-in calibration workflows
- **Accuracy**: 16-bit ADC resolution

## 🧪 Development

### Debugging
```bash
# View real-time logs
idf.py monitor

# Flash and monitor in one command
idf.py flash monitor

# Clean build
idf.py fullclean
```

### Customization
- Modify `hardware.h` for different pin configurations
- Adjust `lv_conf.h` for LVGL customization
- Update sensor parameters in `sensor_interface.c`

## 🔧 Troubleshooting

### Common Issues

#### Display Not Working
- Check RGB parallel interface connections
- Verify 3.3V and 5V power supplies
- Ensure backlight is enabled

#### Touch Not Responding
- Verify GT911 I2C connections (SDA/SCL)
- Check touch controller I2C address
- Ensure proper grounding

#### Sensor Reading Issues
- Use `i2cdetect` equivalent to scan I2C devices
- Check ADS1115 address (default 0x48)
- Verify BME280 address (0x76 or 0x77)

### Log Analysis
```bash
# Enable verbose logging
idf.py menuconfig
# Component Config → Log Output → Default log verbosity → Verbose

# View component-specific logs
idf.py monitor --print-filter="trimix_*"
```

## 📊 Performance

### Specifications
- **Boot Time**: <5 seconds
- **Touch Response**: <50ms
- **Sensor Update Rate**: 1Hz
- **Power Consumption**: ~300mA @ 5V
- **Memory Usage**: ~2MB flash, ~200KB RAM

### Compared to Raspberry Pi Version
| Feature | ESP32 | Raspberry Pi |
|---------|-------|--------------|
| Boot Time | <5s | ~30s |
| Power | 300mA | 2A |
| Cost | ~$50 | ~$150 |
| Size | Compact | Larger |
| Reliability | High | Medium |

## 🔄 Auto-Release System

This project features automatic release creation when Pull Requests are merged into `main`:

- **Smart Version Bumping**: Analyzes commit messages for version bump type
- **Automated Testing**: Runs comprehensive tests before release creation  
- **GitHub Releases**: Automatically creates releases with changelogs

### Version Bump Examples
```bash
# Patch release (1.0.0 → 1.0.1)
git commit -m "fix: resolve sensor calibration issue"

# Minor release (1.0.0 → 1.1.0)
git commit -m "feat: add new temperature sensor support" 

# Major release (1.0.0 → 2.0.0)
git commit -m "BREAKING CHANGE: new sensor interface API"
```

## 📄 License

[Add your license here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/magnus188/trimix-analysator/issues)
- **Discussions**: [GitHub Discussions](https://github.com/magnus188/trimix-analysator/discussions)
- **Documentation**: [ESP32 README](esp32/README.md)

---

Built with ❤️ for the diving community
