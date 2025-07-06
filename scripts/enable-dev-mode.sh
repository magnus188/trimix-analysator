#!/bin/bash

# Enable Development Mode - Prevents Trimix Analyzer from auto-starting

echo "🔧 Enabling development mode..."

# Check if service exists and handle accordingly
if systemctl list-unit-files | grep -q "trimix-analyzer.service"; then
    echo "📦 Service found - stopping and disabling..."
    sudo systemctl stop trimix-analyzer 2>/dev/null || true
    sudo systemctl disable trimix-analyzer
    echo "✅ Service disabled"
else
    echo "📝 Service not installed yet - development mode ready"
fi

echo "✅ Development mode enabled!"
echo ""
echo "📋 What this does:"
echo "   • Prevents Trimix Analyzer from auto-starting on boot"
echo "   • Stops the current service if running"
echo "   • Allows you to run 'make dev' or 'make run' manually"
echo ""
echo "💡 To disable development mode:"
echo "   sudo ./disable-dev-mode.sh"
echo ""
echo "🚀 You can now run:"
echo "   make run    - Test production mode"
echo "   make dev    - Test with mock sensors"
