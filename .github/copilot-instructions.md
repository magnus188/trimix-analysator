# Trimix Analyzer - Repository Instructions

Trimix Analyzer is an ESP32-S3 firmware project built with ESP-IDF and LVGL. The target device is a 480x800 portrait touch display with GT911 touch, WiFi, OTA update support, settings in NVS, and mock sensor readings while hardware drivers are still being completed.

## Working Effectively

### Prerequisites
- ESP-IDF v5.1.6 or compatible v5.1.x environment.
- ESP32-S3 toolchain.
- `g++` for host-side unit tests.

### Core Commands
```bash
./scripts/run_tests.sh
idf.py set-target esp32s3
idf.py build
./scripts/check_firmware_size.sh
```

If `idf.py` is not on PATH, source the local ESP-IDF export script before building:
```bash
. "$IDF_PATH/export.sh"
```

## Validation Rules
- Always run `./scripts/run_tests.sh` after code changes.
- For firmware changes, run `idf.py build` and `./scripts/check_firmware_size.sh`.
- Do not use copied production logic in tests; host tests should compile production `.cpp` files directly where possible.
- Do not add UI changes or new user-facing features when the task is under-the-hood hardening.
- Keep public C APIs stable unless a task explicitly requests a breaking change.

## Project Structure
```text
main/
  main.cpp                         # app_main and UI task
  services/                        # WiFi, OTA, settings, battery, backlight
  sensors/                         # sensor abstraction and mock readings
  ui/
    lvgl/                          # display/touch port
    screens/                       # LVGL screens
    components/                    # navbar and status icons
    styles/                        # colors and font selectors
    fonts/                         # generated LVGL custom fonts
tests/                             # host-side C++ tests
scripts/run_tests.sh               # host validation
scripts/check_firmware_size.sh     # app partition budget check
.github/workflows/                 # CI and release automation
```

## CI/CD
- Pull requests and non-main pushes run host tests, ESP-IDF build, firmware size check, and artifact upload.
- Pushes to `main` keep the current automatic release behavior after version bumping, duplicate-tag checks, tests, ESP-IDF build, and size validation.
- The app partition budget is defined by `partitions.csv`; firmware must fit in the configured factory/OTA app partition.

## Hardware Smoke Test
After firmware-level changes, test on the ESP32-S3 device:
1. Boot to Home.
2. Navigate Home, Settings, WiFi, Software Update, and Dive Planner.
3. Run WiFi scan twice.
4. Open and close the WiFi password modal.
5. Verify WiFi and battery status icons update.
6. Leave the device idle for at least 5 minutes and check for crashes, UI stalls, or obvious heap instability.
