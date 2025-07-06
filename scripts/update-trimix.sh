#!/bin/bash
# Manual update script for Trimix Analyzer
# Usage: sudo ./update-trimix.sh [version]

set -e

REPO_OWNER="magnus188"
REPO_NAME="trimix-analysator"
INSTALL_DIR="/opt/trimix-analyzer"
VERSION=${1:-latest}

echo "🔄 Updating Trimix Analyzer to version: $VERSION"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (sudo)"
    exit 1
fi

# Stop the service
echo "🛑 Stopping Trimix Analyzer service..."
systemctl stop trimix-analyzer || true

# Navigate to install directory
cd "$INSTALL_DIR"

# Pull the new Docker image
echo "📥 Pulling new Docker image..."
if [ "$VERSION" = "latest" ]; then
    docker pull "ghcr.io/${REPO_OWNER,,}/${REPO_NAME,,}:latest"
else
    docker pull "ghcr.io/${REPO_OWNER,,}/${REPO_NAME,,}:${VERSION}"
    
    # Update docker-compose.yml to use specific version
    sed -i "s|image: ghcr.io/${REPO_OWNER,,}/${REPO_NAME,,}:.*|image: ghcr.io/${REPO_OWNER,,}/${REPO_NAME,,}:${VERSION}|" docker-compose.yml
fi

# Remove old containers
echo "🧹 Cleaning up old containers..."
docker-compose down || true
docker system prune -f || true

# Start with new image
echo "🚀 Starting updated service..."
docker-compose up -d

# Start the systemd service
systemctl start trimix-analyzer

# Check status
echo "✅ Update complete!"
echo "📊 Service status:"
systemctl status trimix-analyzer --no-pager -l

echo ""
echo "🎉 Trimix Analyzer has been updated successfully!"
echo "   Version: $VERSION"
echo "   Check the display to verify the update."
