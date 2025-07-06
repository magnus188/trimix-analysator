# Trimix Analyzer - Development Commands
# Usage: make <command>

.PHONY: dev run install clean test help

# Default target
help:
	@echo "🚀 Trimix Analyzer Development Commands"
	@echo ""
	@echo "Usage: make <command>"
	@echo ""
	@echo "Commands:"
	@echo "  dev        🎮 Start development server (RPi emulation)"
	@echo "  run        🏃 Run the app directly (no env setup)"
	@echo "  install    📦 Install dependencies in virtual environment"
	@echo "  clean      🧹 Clean up virtual environment and cache"
	@echo "  test       🧪 Run tests"
	@echo "  help       ❓ Show this help message"

# Development server with full setup
dev:
	@./scripts/dev.sh

# Quick run without environment setup
run:
	@echo "🏃 Running Trimix Analyzer..."
	@python main.py

# Install dependencies
install:
	@echo "📦 Setting up virtual environment and installing dependencies..."
	@python3 -m venv .venv
	@.venv/bin/pip install -r requirements-base.txt
	@.venv/bin/pip install https://github.com/kivy-garden/graph/archive/master.zip
	@echo "✅ Installation complete! Use 'make dev' to start the app."

# Clean up
clean:
	@echo "🧹 Cleaning up..."
	@rm -rf .venv
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@echo "✅ Cleanup complete!"

# Run tests
test:
	@echo "🧪 Running tests..."
	@python -m pytest tests/ -v
