#!/bin/bash
# Docker development launcher for Mac with GUI support

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Trimix Analyzer - Docker Development (Mac)${NC}"
echo -e "${YELLOW}📱 Emulating 4.3\" 480x800 portrait display${NC}"

# Check if XQuartz is running
if ! pgrep -x "XQuartz" > /dev/null; then
    echo -e "${RED}❌ XQuartz is not running!${NC}"
    echo -e "${YELLOW}Please start XQuartz first:${NC}"
    echo "1. Install XQuartz: brew install --cask xquartz"
    echo "2. Start XQuartz"
    echo "3. In XQuartz preferences, enable 'Allow connections from network clients'"
    echo "4. Run this command again"
    exit 1
fi

# Allow X11 forwarding from Docker
echo -e "${YELLOW}🔐 Setting up X11 forwarding...${NC}"
xhost +localhost

# Set the DISPLAY variable for Docker
export DISPLAY=host.docker.internal:0

echo -e "${GREEN}🐳 Starting Docker container with GUI...${NC}"
docker compose -f docker-compose.dev.yml --profile mac up --build trimix-dev-gui-mac

# Clean up X11 permissions when done
echo -e "${YELLOW}🧹 Cleaning up X11 permissions...${NC}"
xhost -localhost
