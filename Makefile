# Trimix Analyzer - Development Commands
# Usage: make <command>

.PHONY: dev run run-docker stop install clean test help

# Default target
help:
	@echo "🚀 Trimix Analyzer Development Commands"
	@echo ""
	@echo "Usage: make <command>"
	@echo ""
	@echo "Commands:"
	@echo "  dev           🎮 Start development server (native Python)"
	@echo "  run           🏃 Run the app with Docker (production with real sensors)"
	@echo "  run-docker    🐳 Run with Docker GUI (development with mock sensors)"
	@echo "  run-dev       🔧 Docker development shell (debug/test)"
	@echo "  stop          🛑 Stop Docker containers"
	@echo "  install       📦 Install dependencies in virtual environment"
	@echo "  clean         🧹 Clean up virtual environment and cache"
	@echo "  test          🧪 Run tests"
	@echo "  help          ❓ Show this help message"

# Development server with full setup (native Python)
dev:
	@./scripts/dev.sh

# Quick run with Docker (production setup)
run:
	@echo "🏃 Running Trimix Analyzer with Docker (production)..."
	@echo "Note: Running in foreground to see output. Press Ctrl+C to stop."
	@docker compose up --build

# Docker with GUI support
run-docker:
	@echo "🐳 Running Trimix Analyzer with Docker GUI..."
	@echo "Note: On Mac, make sure XQuartz is running with 'Allow connections from network clients' enabled"
	@echo "Note: On Linux, run 'xhost +local:docker' if you get permission errors"
	@docker compose -f docker-compose.dev.yml up --build trimix-dev

# Stop the Docker containers
stop:
	@echo "🛑 Stopping Trimix Analyzer..."
	@docker compose down

# Docker development shell for debugging
run-dev:
	@echo "🔧 Running Trimix Analyzer with Docker (development shell)..."
	@docker compose -f docker-compose.dev.yml up --build trimix-shell

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
