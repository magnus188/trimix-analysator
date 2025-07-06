#!/bin/bash
# Simple development launcher for Trimix Analyzer

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Trimix Analyzer - RPi Display Emulation${NC}"
echo -e "${YELLOW}📱 Emulating 4.3\" 480x800 portrait display${NC}"

# Check if virtual environment exists
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}📦 Setting up virtual environment...${NC}"
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r requirements-base.txt
    pip install https://github.com/kivy-garden/graph/archive/master.zip
    echo -e "${GREEN}✅ Environment setup complete!${NC}"
else
    source .venv/bin/activate
fi

# Set development environment variables
export TRIMIX_ENVIRONMENT=development
export TRIMIX_MOCK_SENSORS=1

echo -e "${GREEN}🎮 Launching GUI...${NC}"
python main.py
