#!/bin/bash
# Quick setup verification for Docker GUI development

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Trimix Analyzer - Docker GUI Setup Verification${NC}"
echo ""

# Detect platform
PLATFORM=$(uname -s)
echo -e "${YELLOW}Platform detected: $PLATFORM${NC}"

# Check Docker
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker is installed${NC}"
    if docker info &> /dev/null; then
        echo -e "${GREEN}✅ Docker daemon is running${NC}"
    else
        echo -e "${RED}❌ Docker daemon is not running${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null || docker compose version &> /dev/null; then
    echo -e "${GREEN}✅ Docker Compose is available${NC}"
else
    echo -e "${RED}❌ Docker Compose is not available${NC}"
    exit 1
fi

# Platform-specific checks
if [[ "$PLATFORM" == "Darwin" ]]; then
    echo -e "${YELLOW}Mac detected - checking XQuartz setup...${NC}"
    
    # Check if XQuartz is installed
    if [[ -d "/Applications/Utilities/XQuartz.app" ]] || command -v xquartz &> /dev/null; then
        echo -e "${GREEN}✅ XQuartz is installed${NC}"
    else
        echo -e "${RED}❌ XQuartz is not installed${NC}"
        echo -e "${YELLOW}Install with: brew install --cask xquartz${NC}"
        exit 1
    fi
    
    # Check if XQuartz is running
    if pgrep -x "XQuartz" > /dev/null; then
        echo -e "${GREEN}✅ XQuartz is running${NC}"
    else
        echo -e "${YELLOW}⚠️  XQuartz is not running${NC}"
        echo -e "${YELLOW}Please start XQuartz before running Docker GUI apps${NC}"
    fi
    
    # Check if xhost is available
    if command -v xhost &> /dev/null; then
        echo -e "${GREEN}✅ xhost command is available${NC}"
    else
        echo -e "${RED}❌ xhost command not found${NC}"
        echo -e "${YELLOW}This usually comes with XQuartz${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}Recommended command for Mac: make run-dev-mac${NC}"
    
elif [[ "$PLATFORM" == "Linux" ]]; then
    echo -e "${YELLOW}Linux detected - checking X11 setup...${NC}"
    
    # Check if DISPLAY is set
    if [[ -n "$DISPLAY" ]]; then
        echo -e "${GREEN}✅ DISPLAY environment variable is set: $DISPLAY${NC}"
    else
        echo -e "${RED}❌ DISPLAY environment variable is not set${NC}"
        echo -e "${YELLOW}You might be in a headless environment${NC}"
        exit 1
    fi
    
    # Check if xhost is available
    if command -v xhost &> /dev/null; then
        echo -e "${GREEN}✅ xhost command is available${NC}"
    else
        echo -e "${RED}❌ xhost command not found${NC}"
        echo -e "${YELLOW}Install with: apt-get install x11-xserver-utils${NC}"
    fi
    
    # Check if X11 socket exists
    if [[ -S "/tmp/.X11-unix/X0" ]]; then
        echo -e "${GREEN}✅ X11 socket exists${NC}"
    else
        echo -e "${YELLOW}⚠️  X11 socket not found at expected location${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}Recommended command for Linux: make run-dev-linux${NC}"
else
    echo -e "${YELLOW}Unknown platform: $PLATFORM${NC}"
    echo -e "${YELLOW}Try: make run-simple${NC}"
fi

echo ""
echo -e "${GREEN}✅ Setup verification complete!${NC}"
echo ""
echo -e "${YELLOW}Quick start commands:${NC}"
echo -e "  ${GREEN}make dev${NC}           - Native Python development (fastest)"
echo -e "  ${GREEN}make run-dev-mac${NC}   - Docker GUI on Mac"
echo -e "  ${GREEN}make run-dev-linux${NC} - Docker GUI on Linux" 
echo -e "  ${GREEN}make run-simple${NC}    - Quick Docker GUI test"
echo ""
echo -e "${YELLOW}For full setup instructions, see: DOCKER_GUI_SETUP.md${NC}"
