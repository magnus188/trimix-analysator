#!/bin/bash

# Disable Development Mode - Re-enables Trimix Analyzer auto-start

echo "🚀 Disabling development mode..."

# Enable and start the service
sudo systemctl enable trimix-analyzer
sudo systemctl start trimix-analyzer

echo "✅ Development mode disabled!"
echo ""
echo "📋 What this does:"
echo "   • Re-enables Trimix Analyzer auto-start on boot"
echo "   • Starts the service immediately"
echo ""
echo "💡 Service status:"
if systemctl is-active --quiet trimix-analyzer; then
    echo "   ✅ Trimix Analyzer is now running"
else
    echo "   ❌ Failed to start service - check logs: journalctl -u trimix-analyzer"
fi
