#!/bin/bash
# Docker development launcher for Linux with GUI support

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Trimix Analyzer - Docker Development (Linux)${NC}"
echo -e "${YELLOW}📱 Emulating 4.3\" 480x800 portrait display${NC}"

# Allow X11 forwarding from Docker
echo -e "${YELLOW}🔐 Setting up X11 forwarding...${NC}"
xhost +local:docker

echo -e "${GREEN}🐳 Starting Docker container with GUI...${NC}"
docker compose -f docker-compose.dev.yml --profile linux up --build trimix-dev-gui-linux

# Clean up X11 permissions when done
echo -e "${YELLOW}🧹 Cleaning up X11 permissions...${NC}"
xhost -local:docker
