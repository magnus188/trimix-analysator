#!/bin/bash

# Development Helper Script for RPi
# This script helps set up development access when RPi boots into Trimix Analyzer

echo "🔧 Setting up Raspberry Pi for development access..."

# Enable SSH if not already enabled
if ! systemctl is-enabled ssh >/dev/null 2>&1; then
    echo "📡 Enabling SSH..."
    sudo systemctl enable ssh
    sudo systemctl start ssh
    echo "✅ SSH enabled"
else
    echo "✅ SSH already enabled"
fi

# Create development user if needed
if ! id "dev" &>/dev/null; then
    echo "👤 Creating development user..."
    sudo useradd -m -G sudo,gpio,i2c,spi,video dev
    echo "dev:raspberry" | sudo chpasswd
    echo "✅ Development user 'dev' created (password: raspberry)"
fi

# Set up development shortcuts
echo "⌨️  Setting up development shortcuts..."

# Create script to stop Trimix service for development
cat > /home/pi/stop-trimix.sh << 'EOF'
#!/bin/bash
echo "🛑 Stopping Trimix Analyzer service..."
sudo systemctl stop trimix-analyzer
echo "✅ Service stopped. You can now run 'make dev' or 'make run'"
echo "💡 To restart service: sudo systemctl start trimix-analyzer"
EOF

# Create script to start Trimix service
cat > /home/pi/start-trimix.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Trimix Analyzer service..."
sudo systemctl start trimix-analyzer
echo "✅ Service started"
EOF

# Create development mode script
cat > /home/pi/dev-mode.sh << 'EOF'
#!/bin/bash
echo "🔧 Entering development mode..."
sudo systemctl stop trimix-analyzer
cd /opt/trimix-analyzer
echo "✅ Development mode active"
echo "💡 Run commands:"
echo "   make run    - Test production mode"
echo "   make dev    - Test with mock sensors"
echo "   make test   - Run tests"
echo ""
echo "To exit development mode: ./start-trimix.sh"
EOF

chmod +x /home/pi/*.sh

# Show current IP for SSH access
echo ""
echo "📋 Development Access Information:"
echo "=================================="
echo "🌐 SSH Access:"
echo "   IP Address: $(hostname -I | cut -d' ' -f1)"
echo "   Username: pi (or dev)"
echo "   Command: ssh pi@$(hostname -I | cut -d' ' -f1)"
echo ""
echo "🔧 Development Commands (via SSH):"
echo "   Stop service:  ./stop-trimix.sh"
echo "   Start service: ./start-trimix.sh"
echo "   Dev mode:      ./dev-mode.sh"
echo ""
echo "💡 Service Status:"
systemctl is-active trimix-analyzer && echo "   ✅ Trimix service is running" || echo "   ❌ Trimix service is stopped"
