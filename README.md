# Trimix Analyzer ESP32 Firmware

ESP32-S3/LVGL firmware for the Trimix Analyzer with a 480x800 capacitive touch display, WiFi settings, OTA update support, NVS-backed settings, and mock sensor readings while hardware sensor drivers are completed.

## Quick Start with ESP-IDF

### Prerequisites
- [ESP-IDF v5.1+](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/) installed and configured
- ESP32-S3 development board with 480x800 touch display
- `g++`, CMake, pkg-config, and SDL2 development headers for full host validation

### Build and Upload
```bash
# See all common development commands
make help

# Run host-side validation
make test

# Build and flash (PORT is optional when only one device is connected)
make push PORT=/dev/cu.usbserial-110

# Build, flash, and monitor serial output
make push-monitor PORT=/dev/cu.usbserial-110

# Build and run the LVGL/SDL desktop simulator
make sim ZOOM=0.75
```

Run `make devices` to find likely serial ports and `make doctor` to check ESP-IDF, CMake, the C++ compiler, SDL2, and LVGL. The Makefile uses `idf.py` from `PATH`; otherwise it looks for ESP-IDF v5.1.6 under `~/esp/v5.1.6/esp-idf`. Override that location with `ESP_IDF_DIR=/path/to/esp-idf`.

The equivalent raw ESP-IDF commands remain available:

```bash
idf.py set-target esp32s3
idf.py build
idf.py flash
idf.py monitor
```

## Browser Demo

The production LVGL interface can also run in a browser through WebAssembly. The browser build uses the same screens, calculator logic, and deterministic simulator services as the native SDL simulator; hardware sensors, WiFi, battery state, NVS, and OTA installation remain simulated.

### Build locally

Activate an [Emscripten SDK](https://emscripten.org/docs/getting_started/downloads.html), then run:

```bash
bash scripts/build_web_demo.sh
python3 -m http.server 8080 --directory web/build
```

Open `http://localhost:8080`. The generated site must be served over HTTP rather than opened directly from disk so the browser can load its WebAssembly module.

### Automatic GitHub Pages deployment

`.github/workflows/pages.yml` builds and deploys the demo after every push to `main`, and can also be run manually. Before the first deployment, select **GitHub Actions** under **Repository settings → Pages → Build and deployment → Source**. The project site will then be available at `https://magnus188.github.io/trimix-analysator/`.

### ESP-IDF Project Structure
```
├── CMakeLists.txt           # Main CMake configuration
├── sdkconfig.defaults       # ESP-IDF configuration defaults
├── main/                    # Main component source files
│   ├── main.cpp            # Application entry point and UI task
│   ├── services/           # WiFi, OTA, settings, battery, backlight
│   ├── sensors/            # Sensor abstraction and mock readings
│   ├── ui/                 # LVGL port, screens, styles, components
│   ├── idf_component.yml  # Component dependencies
│   └── CMakeLists.txt     # Component CMake file
├── tests/                  # Host-side C++ tests
├── scripts/                # Test and firmware size scripts
└── README.md               # This file
```

## Hardware Requirements

The current hardware reference is the project BOM at `../BOM.md`. Keep this README in sync with that file when hardware choices change. The BOM describes the full analyzer electronics, while the firmware currently targets the ESP32-S3/Sunton display-board pinout in `main/board/hardware.h`.

### Controller and Display
- **ESP32** main MCU in the BOM; firmware target is currently **ESP32-S3**.
- **Sunton ESP32-8048S043** development board or compatible display target while the custom board is finalized.
- **480x800 pixel capacitive touch display** with GT911 touch controller.

### Power, Charging, and Battery
- **USB-C 5 V sink input** with CC1/CC2 5.1 kOhm pulldowns, 1.5 A PPTC fuse, SMAJ5.0A VBUS TVS diode, and 10 uF VBUS bulk capacitance.
- **BQ24074** 1S Li-ion charger with power path, configured for about 500 mA charge current and about 1.0 A USB input current limit.
- **DW01A + 8205A** 1S battery protection for overcharge, overdischarge, and overcurrent switching.
- **TPS63020 fixed 3.3 V buck-boost** for the main regulated rail.
- **SPX3819M5-L-3-0TR 3.0 V LDO** for the MD62 helium sensor rail.
- **AP22802AW5-7 load switch** and **LTC2954CTS8-1 push-button power controller** are BOM options for rail control and soft power.
- **MAX17048** 1S I2C fuel gauge.
- **2x 18650 cells in 1S2P** using a parallel battery holder.
- **Waterproof metal push button**, 1NO momentary or latching.

### Sensors and Analog Front End
- **ADS1115** 16-bit ADC for analog gas sensor readings.
- **BMP280** pressure and temperature sensor.
- **MD62 He sensor** for helium measurement, powered from the dedicated 3.0 V rail.
- **R17JJ-CCR oxygen sensor** for oxygen measurement.
- **SMB PCB connector** for coax sensor connection.
- **I2C pullups** on SDA/SCL if they are not already present on the board.

### Wiring Notes
```
Signal/Rail       | Current hardware expectation
------------------|------------------------------------------------
Sensor I2C        | ADS1115, BMP280, and MAX17048 on shared I2C
Analog gas inputs | R17JJ-CCR O2 and MD62 He routed through ADS1115
3.3 V rail        | ESP32, ADS1115, BMP280, MAX17048, display/touch logic
3.0 V rail        | MD62 helium sensor through SPX3819M5-L-3-0TR
USB-C VBUS        | BQ24074 input through PPTC and TVS protection
Touch I2C         | GT911 pins defined in main/board/hardware.h
```

Final custom-board GPIO and ADS1115 channel mapping should be documented in `main/board/hardware.h` when the schematic is locked.

## Software Architecture

### Key Components

#### 1. Main Application (`main/main.cpp`)
- Service startup
- LVGL task loop
- Screen manager initialization

#### 2. LVGL Port (`main/ui/lvgl/lvgl_port.cpp`)
- RGB LCD panel initialization
- GT911 touch setup
- LVGL display flush and tick integration

#### 3. Sensor Interface (`main/sensors/sensor_interface.cpp/h`)
- Abstracted sensor reading functions
- Mock readings for development
- Calibration entrypoints for future hardware-backed implementation

#### 4. Screen Management (`main/ui/screens/screen_manager.cpp/h`)
- LVGL-based UI screens
- Navigation between screens
- Settings, WiFi, update, and dive planner screens

#### 5. Services (`main/services/`)
- WiFi scanning/connection and saved credentials
- OTA update checks and firmware installation
- Settings, battery status, and backlight control
- Analysis history, persistent cylinder profiles, and export-ready gas label payloads

#### 6. Hardware Configuration (`main/board/hardware.h`)
- GPIO pin definitions
- Display timing parameters
- I2C bus configuration
- Touch screen settings

## Display Configuration

### ESP32 Display
- **ESP32**: 480x800 portrait
- **Framework**: LVGL
- **Touch**: Capacitive (GT911)

### Screens

1. **Home Screen**
   - Main menu with navigation buttons
   - System status display
   - Version information

2. **Analyse Screen**
   - Professional gas analysis panel with deterministic simulator streams
   - Live O2, He, CO2, environmental readings, stability state, trend chart, planned depth, MOD, density, gas-use mode, and averaged capture controls
   - Captures require stable samples and save an averaged analysis result to history
   - Stable averaged readings can update the selected cylinder profile and prepare an export-ready label payload

3. **Dive Planner Screen**
   - Gas planning calculator views
   - Partial-pressure top-up calculator for O2, helium, and air additions
   - Production calculator logic covered by host tests

4. **History Screen**
   - Captured analysis records only, with gas-use mode, mix fractions, CO2, planned depth, MOD, density, and advisory state

5. **Cylinder Profiles Screen**
   - Persistent cylinder slots with selected cylinder, recheck state, stored mix, gas-use mode, planned depth, and label preview
   - Label text and CSV payloads are generated in firmware so later WiFi, QR, BLE, or phone handoff export can reuse the same data model

6. **Settings Screen**
   - Device settings navigation
   - Cylinder profiles, WiFi, software update, safety settings, calibration, and device information entrypoints

7. **WiFi Screen**
   - Network scanning, connection, password modal, and disconnect controls

8. **Software Update Screen**
   - GitHub release check and OTA install flow

9. **Calibrate Sensors Screen**
   - Guided O2 ambient-air, CO2 zero, and CO2 reference calibration flow with stable-sample gating while hardware driver support is completed

10. **Safety Settings Screen**
   - User-configured PPO2, density, and CO2 advisory limits used by Analyse

11. **Device Screen**
   - Device information and configuration controls

## Building and Flashing

### Prerequisites
- **ESP-IDF v5.1+** installed and configured
- **ESP32-S3** toolchain
- **Host validation tools**: `g++`, CMake, pkg-config, SDL2 development headers
- USB-C cable for programming

### Build Steps
```bash
# Set target (if not set globally)
idf.py set-target esp32s3

# Run host tests
./scripts/run_tests.sh

# Configure project (optional)
idf.py menuconfig

# Build project
idf.py build

# Validate firmware size against partitions.csv
./scripts/check_firmware_size.sh

# Flash to device
idf.py flash

# Monitor output
idf.py monitor
```

### Dependencies
The project uses ESP-IDF component manager for dependencies (defined in `main/idf_component.yml`):
- `lvgl/lvgl` 9.3.0 - Graphics library
- `espressif/esp_lcd_touch_gt911` 1.1.3 - Touch controller driver

Dependencies are automatically downloaded during the build process.

## Sensor Hardware and Calibration Status

Sensor readings are currently provided by deterministic simulator profiles while the hardware-backed ADS1115, BMP280, MAX17048, R17JJ-CCR O2, and MD62 He support is completed. The sensor boundary exposes timestamped O2, He, CO2, pressure, temperature, humidity, status, and source fields so the Analyse workflow can run against simulated streams now and hardware streams later.

The Analyse, History, Calibrate Sensors, and Safety Settings screens are functional in the host/simulator path. Calibration actions are simulation-safe state changes until hardware driver support is added.

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
1. **480x800 portrait touch display**
2. **Capacitive touch**
3. **Hardware acceleration** (RGB parallel interface)
4. **Lower power consumption** (compared to the prior full-computer platform)
5. **Faster boot time** (<5 seconds vs ~30 seconds)

### Current Limitations
1. Sensor drivers are still mocked until hardware-backed ADS1115, BMP280, MAX17048, R17JJ-CCR O2, and MD62 He support is completed.
2. Simulator streams are deterministic and intended for UI/UX validation until hardware drivers land.
3. Settings are intentionally stored in NVS; no general file system is required for current behavior.

## Development Notes

### Code Organization
- Sensor interface abstraction allows host tests and later hardware drivers.
- Modular screen design keeps LVGL screens separated by workflow.
- Services isolate WiFi, OTA, settings, battery, and backlight behavior.
- Hardware definitions live in `main/board/hardware.h`.

### Testing Strategy
- `./scripts/run_tests.sh` runs static safety checks, production gas calculator tests, version consistency tests, and the host LVGL simulator smoke test when SDL2 is available.
- `./scripts/check_firmware_size.sh` validates the built app binary against the configured factory/OTA app partition.
- Hardware smoke testing should cover boot, Home/Settings/WiFi/Software Update/Dive Planner navigation, two WiFi scans, password modal open/close, status icon updates, and at least 5 minutes of heap-stable idle time.

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
3. Add screen navigation in `main/ui/screens/screen_manager.cpp`
4. Test with both real and mock sensors
5. Update documentation

## License

Same as original Trimix Analyzer project.
