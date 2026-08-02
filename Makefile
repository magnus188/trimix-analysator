# Trimix Analyzer developer commands

SHELL := /bin/bash
.DEFAULT_GOAL := help

TARGET ?= esp32s3
PORT ?=
FLASH_BAUD ?= 460800
ZOOM ?= 1.0
BUILD_TYPE ?= Debug

FIRMWARE_BUILD_DIR ?= build/esp32
SIM_BUILD_DIR ?= simulator/build

# Override ESP_IDF_DIR when ESP-IDF is installed elsewhere. If idf.py is
# already on PATH, that installation is used instead.
ESP_IDF_VERSION ?= v5.1.6
ESP_IDF_SERIES ?= 5.1
ESP_IDF_DIR ?= $(HOME)/esp/$(ESP_IDF_VERSION)/esp-idf
IDF_EXPORT ?= $(ESP_IDF_DIR)/export.sh
IDF_PY ?= idf.py
# ESP-IDF names its virtual environments after the Python version. Reuse an
# existing environment when the system Python has been upgraded since setup.
IDF_PYTHON_ENV_PATH ?= $(firstword $(wildcard $(HOME)/.espressif/python_env/idf$(ESP_IDF_SERIES)_py*_env))

PORT_ARG = $(if $(strip $(PORT)),-p "$(PORT)",)
FLASH_ARGS = $(PORT_ARG) $(if $(strip $(FLASH_BAUD)),-b "$(FLASH_BAUD)",)

define run_idf
	@set -e; \
	if command -v "$(IDF_PY)" >/dev/null 2>&1; then \
		"$(IDF_PY)" $(1); \
	elif [ -f "$(IDF_EXPORT)" ]; then \
		if [ -n "$(IDF_PYTHON_ENV_PATH)" ]; then export IDF_PYTHON_ENV_PATH="$(IDF_PYTHON_ENV_PATH)"; fi; \
		. "$(IDF_EXPORT)" >/dev/null; \
		"$(IDF_PY)" $(1); \
	else \
		printf 'ESP-IDF was not found. Source export.sh or run make with ESP_IDF_DIR=/path/to/esp-idf.\n' >&2; \
		exit 1; \
	fi
endef

.PHONY: help doctor devices configure menuconfig build firmware push upload flash \
	push-monitor monitor size size-check test check sim-deps sim-configure sim-build \
	sim emulator run sim-test clean clean-sim clean-all

help: ## Show available commands
	@printf 'Trimix Analyzer development commands\n\n'
	@printf 'Usage: make <target> [PORT=/dev/...] [ZOOM=0.75]\n\n'
	@awk 'BEGIN { FS = ":.*##" } /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-18s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@printf '\nExamples:\n'
	@printf '  make push PORT=/dev/cu.usbserial-110\n'
	@printf '  make push-monitor PORT=/dev/cu.usbserial-110\n'
	@printf '  make sim ZOOM=0.75\n'

doctor: ## Check firmware and simulator prerequisites
	@set -e; \
	printf 'ESP-IDF: '; \
	if command -v "$(IDF_PY)" >/dev/null 2>&1; then \
		"$(IDF_PY)" --version; \
	elif [ -f "$(IDF_EXPORT)" ]; then \
		if [ -n "$(IDF_PYTHON_ENV_PATH)" ]; then export IDF_PYTHON_ENV_PATH="$(IDF_PYTHON_ENV_PATH)"; fi; \
		. "$(IDF_EXPORT)" >/dev/null; \
		"$(IDF_PY)" --version; \
	else \
		printf 'missing (expected %s)\n' "$(IDF_EXPORT)"; \
		exit 1; \
	fi; \
	printf 'CMake:   '; cmake --version | sed -n '1p'; \
	printf 'C++:     '; "$(CXX)" --version | sed -n '1p'; \
	printf 'SDL2:    '; pkg-config --modversion sdl2; \
	printf 'LVGL:    '; test -f managed_components/lvgl__lvgl/CMakeLists.txt && printf 'available\n'

devices: ## List likely ESP32 serial ports
	@ports="$$(find /dev -maxdepth 1 \( -name 'cu.usb*' -o -name 'tty.usb*' -o -name 'ttyUSB*' -o -name 'ttyACM*' \) -print 2>/dev/null | sort)"; \
	if [ -n "$$ports" ]; then printf '%s\n' "$$ports"; else printf 'No likely ESP32 serial ports found.\n'; fi

configure: ## Set the ESP-IDF target (clears the firmware build configuration)
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" set-target "$(TARGET)")

menuconfig: ## Open the ESP-IDF configuration UI
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" menuconfig)

build: ## Build the ESP32 firmware
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" build)

firmware: build ## Alias for build

push: ## Build and flash the ESP32 (set PORT=... to select a device)
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" $(FLASH_ARGS) build flash)

upload: push ## Alias for push

flash: push ## Alias for push

push-monitor: ## Build, flash, and open the serial monitor (exit with Ctrl+])
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" $(FLASH_ARGS) build flash monitor)

monitor: ## Open the ESP32 serial monitor (exit with Ctrl+])
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" $(PORT_ARG) monitor)

size: ## Show ESP-IDF firmware size details
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" size)

size-check: build ## Build and verify the app fits its partition
	@BUILD_DIR="$(abspath $(FIRMWARE_BUILD_DIR))" ./scripts/check_firmware_size.sh

test: ## Run host-side validation and tests
	@./scripts/run_tests.sh

check: test size-check ## Run host tests, firmware build, and partition-size check

sim-deps: ## Check dependencies required by the desktop simulator
	@command -v cmake >/dev/null 2>&1 || { printf 'cmake is required.\n' >&2; exit 1; }
	@command -v pkg-config >/dev/null 2>&1 || { printf 'pkg-config is required.\n' >&2; exit 1; }
	@pkg-config --exists sdl2 || { printf 'SDL2 development files are required (macOS: brew install sdl2 pkg-config).\n' >&2; exit 1; }
	@test -f managed_components/lvgl__lvgl/CMakeLists.txt || { printf 'LVGL is missing; run make build once to download managed components.\n' >&2; exit 1; }

sim-configure: sim-deps ## Configure the desktop simulator
	@cmake -S simulator -B "$(SIM_BUILD_DIR)" -DCMAKE_BUILD_TYPE="$(BUILD_TYPE)"

sim-build: sim-configure ## Build the desktop simulator
	@cmake --build "$(SIM_BUILD_DIR)" --target trimix_simulator

sim: sim-build ## Build and run the desktop simulator
	@"$(SIM_BUILD_DIR)/trimix_simulator" --zoom "$(ZOOM)"

emulator: sim ## Alias for sim

run: sim ## Alias for sim

sim-test: sim-configure ## Build and run the simulator test suite
	@cmake --build "$(SIM_BUILD_DIR)"
	@ctest --test-dir "$(SIM_BUILD_DIR)" --output-on-failure

clean: ## Clean ESP-IDF firmware build outputs
	$(call run_idf,-B "$(FIRMWARE_BUILD_DIR)" fullclean)

clean-sim: ## Remove desktop simulator build outputs
	@cmake -E remove_directory "$(SIM_BUILD_DIR)"

clean-all: clean clean-sim ## Clean firmware and simulator build outputs
