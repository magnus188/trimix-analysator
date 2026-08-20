# Trimix Analyzer ESP32 Firmware

ESP32-P4/LVGL firmware for the Trimix Analyzer on the native-portrait Guition JC4880P443C_I_W (JC-ESP32P4-M3). The application includes WiFi settings, revision-safe OTA updates, NVS-backed settings, and mock sensor readings while the analyzer hardware drivers are completed.

## Quick Start with ESP-IDF

### Prerequisites
- [ESP-IDF v5.5.4](https://github.com/espressif/esp-idf/releases/tag/v5.5.4); `make setup-idf` installs the pinned environment
- Python 3.13
- Guition JC4880P443C_I_W: ESP32-P4 rev v1.3, 16 MB flash, 32 MB PSRAM, and ESP32-C6 coprocessor
- `g++`, CMake, pkg-config, and SDL2 development headers for full host validation

### Build and Upload
```bash
# See all common development commands
make help

# Run host-side validation
make test

# Install/check the exact ESP-IDF toolchain
make setup-idf
make doctor

# Identify whether the attached P4 is pre-v3 or v3+
make board-info PORT=/dev/cu.usbserial-110

# Build and flash; the port is required so the revision can be verified safely
make push PORT=/dev/cu.usbserial-110

# Build, flash, and monitor serial output
make push-monitor PORT=/dev/cu.usbserial-110

# Build and run the LVGL/SDL desktop simulator
make sim ZOOM=0.75
```

The first ESP32-P4 installation must be flashed over USB. An ESP32-S3 cannot
install this firmware through OTA because the chips and images are incompatible.

Run `make devices` to find likely serial ports. Firmware commands always source the pinned ESP-IDF v5.5.4 installation under `~/esp/v5.5.4/esp-idf`; an unrelated `idf.py` in `PATH` is never used. Override the installation location with `ESP_IDF_DIR=/path/to/esp-idf`.

The equivalent raw ESP-IDF commands remain available:

```bash
idf.py -B build/esp32p4-pre3 -D SDKCONFIG_DEFAULTS="sdkconfig.defaults;sdkconfig.defaults.esp32p4;sdkconfig.defaults.esp32p4.pre3" set-target esp32p4
idf.py -B build/esp32p4-pre3 build
idf.py -B build/esp32p4-pre3 -p /dev/cu.usbserial-110 flash monitor
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
│   ├── main.cpp            # Application entry point and service startup
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

The current hardware reference is the project BOM at `../BOM.md`. The BOM describes the full analyzer electronics, while the firmware target is the Guition JC4880P443 board.

### Controller and Display
- **ESP32-P4NRW32** application processor with 32 MB in-package PSRAM. Original pre-v3 boards are configured for their detected 16 MB flash; the v3 profile retains the 32 MB layout used by newer hardware.
- Onboard **ESP32-C6** WiFi 6/BLE coprocessor connected over SDIO.
- Native **480x800 MIPI-DSI IPS display** with ST7701 controller and GT911 capacitive touch.

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
Board I2C         | GPIO8 SCL / GPIO7 SDA; GT911 and future sensor devices share the bus
```

Final sensor connector and ADS1115 channel mapping should be documented in a dedicated sensor-board configuration when the analyzer schematic is locked. Display pins, timings, and the manual ST7701S initialization table live in `main/board/`.

## Software Architecture

### Key Components

#### 1. Main Application (`main/main.cpp`)
- Persistent service startup
- Native display and screen initialization under the LVGL adapter lock
- Background service startup after the UI is ready

#### 2. LVGL Port (`main/ui/lvgl/lvgl_port.cpp`)
- Guition MIPI-DSI/ST7701S manual startup sequence
- Native GT911 touch registration
- Triple-buffered tear avoidance and LVGL adapter locking

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

#### 6. Board Support
- In-tree Guition JC4880P443 display, backlight, and touch layer
- Separate pre-v3 and v3+ ESP32-P4 build profiles
- Native backlight, display, touch, and onboard ESP32-C6 integration

## Display Configuration

### ESP32-P4 Display
- **Panel**: 480x800 native portrait
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
- **ESP-IDF v5.5.4** installed with `make setup-idf`
- **ESP32-P4** toolchain and Python 3.13
- **Host validation tools**: `g++`, CMake, pkg-config, SDL2 development headers
- USB-C cable for programming

### Build Steps
```bash
# Inspect the attached chip and select the safe image family
make board-info PORT=/dev/cu.usbserial-110

# Run host tests
./scripts/run_tests.sh

# Build both incompatible P4 revision profiles
make build-all

# Validate firmware size against partitions.csv
make size-check P4_REV=pre3
make size-check P4_REV=v3

# Flash to device
make push PORT=/dev/cu.usbserial-110

# Monitor output
make monitor PORT=/dev/cu.usbserial-110
```

### Dependencies
The project uses ESP-IDF component manager for dependencies (defined in `main/idf_component.yml`):
- `lvgl/lvgl` 9.4.0 - Graphics library
- `espressif/esp_lcd_touch_gt911` 1.2.x - capacitive touch controller
- `espressif/esp_lvgl_adapter` 0.1.4 - task, input, and tear-safe display integration
- `espressif/esp_wifi_remote` 1.6.0 and `espressif/esp_hosted` 2.12.9 - onboard C6 networking

Dependencies are automatically downloaded during the build process.

## Sensor Hardware and Calibration Status

Sensor readings are currently provided by deterministic simulator profiles while the hardware-backed ADS1115, BMP280, MAX17048, R17JJ-CCR O2, and MD62 He support is completed. The sensor boundary exposes timestamped O2, He, CO2, pressure, temperature, humidity, status, and source fields so the Analyse workflow can run against simulated streams now and hardware streams later.

The Analyse, History, Calibrate Sensors, and Safety Settings screens are functional in the host/simulator path. Calibration actions are simulation-safe state changes until hardware driver support is added.

## Performance Characteristics

### Display Pipeline
- **Panel**: native 480x800 RGB565 over two-lane MIPI-DSI
- **Tear avoidance**: three full panel framebuffers with partial LVGL rendering
- **LVGL refresh period**: 15 ms
- **Rotation**: none; pixels and touch coordinates stay in native portrait orientation

### Power Consumption
- **Active display**: ~300mA @ 5V
- **Idle**: ~150mA @ 5V
- **Sleep mode**: <1mA @ 5V (future enhancement)

## Differences from Original

### Enhanced Features
1. **480x800 portrait touch display**
2. **Capacitive touch**
3. **Tear-safe MIPI-DSI output** with no full-frame software rotation
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
- Board-level display and touch details are implemented in `main/board/guition_jc4880p443.c`.

### Testing Strategy
- `./scripts/run_tests.sh` runs static safety checks, production gas calculator tests, version consistency tests, and the host LVGL simulator smoke test when SDL2 is available.
- `./scripts/check_firmware_size.sh` validates the built app binary against the configured factory/OTA app partition.
- Hardware acceptance covers touch corners and drag axes, 100 navigation operations, a one-hour active UI/WiFi soak, an eight-hour idle soak, and two consecutive OTA upgrades.

## Troubleshooting

### Common Issues

1. **Display not working**
   - Check power supply (5V, 2A minimum)
   - Verify display cable connections
   - Confirm the PCB/module markings read `Guition JC4880P443` / `JC-ESP32P4-M3`
   - Confirm `make board-info` and the selected build profile agree

2. **Touch not responding**
   - Check the GT911 I2C bus on GPIO7 SDA / GPIO8 SCL
   - Confirm the board is physically mounted in native portrait orientation
   - Ensure proper grounding

3. **Sensors not reading**
   - Check I2C bus connections
   - Verify sensor addresses (i2cdetect)
   - Check power supply to sensors

4. **Build errors**
   - Run `make doctor` and confirm ESP-IDF v5.5.4 with Python 3.13
   - Run `make clean`, then rebuild the correct P4 revision profile
   - Check that Git dependencies and `dependencies.lock` are available

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
2. Keep display/touch changes inside the board-port boundary; do not add manual rotation
3. Add screen navigation in `main/ui/screens/screen_manager.cpp`
4. Test with both real and mock sensors
5. Update documentation

## License

Same as original Trimix Analyzer project.
