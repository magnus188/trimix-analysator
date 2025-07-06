#!/bin/bash
# Production setup script for Trimix Analyzer on Raspberry Pi
# Run with: sudo bash scripts/setup-production.sh

set -e

echo "🚀 Setting up Trimix Analyzer for production..."

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo; then
    echo "❌ This script should only run on Raspberry Pi"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
apt-get update && apt-get upgrade -y

# Install Docker and Docker Compose
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker pi

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
apt-get install -y docker-compose-plugin

# Enable I2C
echo "🔧 Enabling I2C..."
raspi-config nonint do_i2c 0

# Create application directory
echo "📁 Setting up application directory..."
mkdir -p /opt/trimix-analyzer
cp -r . /opt/trimix-analyzer/
chown -R pi:pi /opt/trimix-analyzer

# Create data directory
mkdir -p /opt/trimix-analyzer/data
chown pi:pi /opt/trimix-analyzer/data

# Make update script executable
chmod +x /opt/trimix-analyzer/scripts/update-trimix.sh

# Create symlink for easy updates
ln -sf /opt/trimix-analyzer/scripts/update-trimix.sh /usr/local/bin/update-trimix

# Install systemd service
echo "⚙️ Installing systemd service..."
cp scripts/trimix-analyzer.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable trimix-analyzer.service

# Setup auto-login (optional)
echo "🔑 Setting up auto-login..."
systemctl set-default multi-user.target
systemctl enable getty@tty1.service

# Configure boot options
echo "🚀 Configuring boot to application..."
cat >> /boot/config.txt << EOF

# Trimix Analyzer Configuration
# Disable splash screen for faster boot
disable_splash=1

# Enable I2C
dtparam=i2c_arm=on

# GPU memory split (minimal for headless)
gpu_mem=64

# Disable unnecessary services for faster boot
dtoverlay=disable-wifi
dtoverlay=disable-bt
EOF

# Disable unnecessary services
echo "⚡ Optimizing boot time..."
systemctl disable bluetooth.service
systemctl disable avahi-daemon.service
systemctl disable triggerhappy.service
systemctl disable dphys-swapfile.service

echo "✅ Production setup complete!"
echo ""
echo "🔄 Please reboot to start Trimix Analyzer:"
echo "   sudo reboot"
echo ""
echo "📊 After reboot, check status with:"
echo "   sudo systemctl status trimix-analyzer"
echo "   docker-compose -f /opt/trimix-analyzer/docker-compose.yml logs -f"
echo ""
echo "🚀 For updates, the system will automatically pull new images when available."
echo "   Manual update: cd /opt/trimix-analyzer && docker-compose pull && docker-compose up -d"
echo ""
echo "📋 CI/CD Integration:"
echo "   - Staging deployments: Push to 'develop' branch"
echo "   - Production deployments: Create git tags like 'v1.0.0'"
echo "   - Images available at: ghcr.io/magnustrandokken/trimix-analysator"
