# Trimix Analyzer Makefile
# Essential commands for building and running the project

# Environments
ESP32_ENV = esp32dev
NATIVE_ENV = native
NATIVE_EXECUTABLE = .pio/build/$(NATIVE_ENV)/program

# Default target
.PHONY: help
help:
	@echo "Trimix Analyzer Build System"
	@echo "============================="
	@echo ""
	@echo "Available commands:"
	@echo "  dev            - Build and run Mac simulator"
	@echo "  upload-esp32   - Build and upload to ESP32"
	@echo "  monitor        - Monitor ESP32 serial output"
	@echo "  clean          - Clean build artifacts"
	@echo ""
	@echo "Usage:"
	@echo "  make dev           # Run on Mac"
	@echo "  make upload-esp32  # Upload to ESP32"
	@echo "  make monitor       # Monitor ESP32"

# Run on Mac simulator
.PHONY: dev
dev:
	@echo "Building and running native simulator..."
	pio run -e $(NATIVE_ENV)
	$(NATIVE_EXECUTABLE)

# Upload to ESP32
.PHONY: upload-esp32
upload-esp32:
	@echo "Building and uploading to ESP32..."
	pio run -e $(ESP32_ENV) --target upload

# Monitor ESP32 serial output
.PHONY: monitor
monitor:
	@echo "Starting serial monitor..."
	pio device monitor -e $(ESP32_ENV)

# Clean build artifacts
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	pio run --target clean
