#!/bin/bash

# ESP32-S3 Trimix Analyzer Development and Testing Script
# Helps diagnose build and runtime issues

echo "🔧 ESP32-S3 Trimix Analyzer Development Helper"
echo "=============================================="

# Check if PlatformIO is installed
if ! command -v pio &> /dev/null; then
    echo "❌ PlatformIO not found. Installing..."
    pip install platformio
    export PATH="$PATH:$HOME/.local/bin"
fi

echo "✅ PlatformIO found: $(pio --version)"

# Check for connected ESP32 devices
echo ""
echo "🔌 Checking for connected ESP32 devices..."
pio device list

# Clean previous build
echo ""
echo "🧹 Cleaning previous build..."
pio run --target clean

# Check dependencies
echo ""
echo "📦 Installing/updating dependencies..."
pio pkg install

# Try to build
echo ""
echo "🔨 Building ESP32-S3 Trimix Analyzer..."
if pio run --environment esp32-s3-devkitc-1; then
    echo "✅ Build successful!"
    
    # Ask if user wants to upload
    read -p "🚀 Build successful! Upload to device? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📤 Uploading firmware..."
        pio run --target upload
        
        echo "📊 Starting serial monitor..."
        echo "Press Ctrl+C to stop monitoring"
        pio device monitor
    fi
else
    echo "❌ Build failed!"
    echo ""
    echo "📝 Common troubleshooting steps:"
    echo "1. Check that ESP32-S3 platform can be downloaded"
    echo "2. Verify USB connection to ESP32-8048S043 board" 
    echo "3. Try different USB cable or port"
    echo "4. Hold BOOT button while uploading if needed"
    echo "5. Check that drivers are installed for your board"
    echo ""
    echo "🔗 For ESP32-8048S043 setup help:"
    echo "https://github.com/espressif/esp-idf/tree/master/examples/peripherals/lcd"
fi