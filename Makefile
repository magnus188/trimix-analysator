# Trimix Analyzer - Development Commands
# Usage: make <command>

.PHONY: dev run run-docker stop install clean test test-fast test-slow test-coverage ci-check help ci-check

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
	@echo "  test          🧪 Run all tests"
	@echo "  test-fast     🚀 Run fast tests (excluding slow tests)"
	@echo "  test-slow     ⏳ Run slow tests only"
	@echo "  test-coverage 📊 Run tests with coverage report"
	@echo "  ci-check      🔍 Run local CI/CD checks"
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

# Run tests excluding slow tests
test-fast:
	@echo "🚀 Running fast tests..."
	@python -m pytest tests/ -v -m "not slow"

# Run only slow tests
test-slow:
	@echo "⏳ Running slow tests..."
	@python -m pytest tests/ -v -m "slow"

# Run tests with coverage
test-coverage:
	@echo "🧪 Running tests with coverage..."
	@python -m pytest tests/ -v --cov=. --cov-report=html:htmlcov --cov-report=term-missing

# CI/CD simulation
ci-check:
	@echo "🔍 Running local CI/CD checks..."
	@./scripts/run-ci-checks.sh
