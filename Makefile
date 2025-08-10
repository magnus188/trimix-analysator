# ESP32-S3 Trimix Analyzer - Development Commands

.PHONY: build upload monitor clean dev test flash erase help

help:
	@echo "🚀 ESP32-S3 Trimix Analyzer Development Commands"
	@echo ""
	@echo "Build Commands:"
	@echo "  build         🔨 Build the ESP32 firmware"
	@echo "  upload        � Upload firmware to ESP32"
	@echo "  monitor       � Monitor serial output"
	@echo "  flash         ⚡ Build and upload firmware"
	@echo "  dev           💻 Build, upload and monitor (development)"
	@echo "  clean         🧹 Clean build files"
	@echo "  erase         💥 Erase ESP32 flash memory"
	@echo "  test          🧪 Run firmware tests"
	@echo "  help          ❓ Show this help"

build:
	@echo "🔨 Building ESP32-S3 Trimix Analyzer..."
	@pio run

upload:
	@echo "📤 Uploading firmware to ESP32-S3..."
	@pio run --target upload

monitor:
	@echo "� Monitoring ESP32-S3 serial output..."
	@pio device monitor

flash: build upload
	@echo "⚡ Firmware flashed successfully!"

dev: build upload monitor
	@echo "💻 Development mode: build, upload, and monitor"

clean:
	@echo "🧹 Cleaning build files..."
	@pio run --target clean
	@rm -rf .pio/build

erase:
	@echo "💥 Erasing ESP32-S3 flash memory..."
	@pio run --target erase

test:
	@echo "🧪 Running ESP32 firmware tests..."
	@pio test
