# Trimix Analyzer - Development Commands

.PHONY: dev run install clean test test-fast test-slow test-coverage ci-check help

help:
	@echo "🚀 Trimix Analyzer Development Commands"
	@echo ""
	@echo "Development Commands:"
	@echo "  run           🥧 Run on Raspberry Pi (native, production-like)"
	@echo "  dev           💻 Run on Mac/Linux (development with GUI)"
	@echo "  install       📦 Install dependencies"
	@echo "  clean         🧹 Clean up virtual environment"
	@echo "  test          🧪 Run all tests"
	@echo "  test-fast     🚀 Run fast tests only"
	@echo "  test-slow     ⏳ Run slow tests only"
	@echo "  test-coverage 📊 Run tests with coverage"
	@echo "  ci-check      🔍 Run CI/CD checks"
	@echo "  help          ❓ Show this help"

run:
	@echo "🥧 Running Trimix Analyzer on Raspberry Pi (native)..."
	@if [ ! -d ".venv" ]; then echo "❌ Run 'make install' first."; exit 1; fi
	@export TRIMIX_ENVIRONMENT=production && export TRIMIX_MOCK_SENSORS=0 && .venv/bin/python main.py

dev:
	@./scripts/dev.sh

install:
	@echo "📦 Setting up virtual environment..."
	@python3 -m venv .venv
	@.venv/bin/pip install -r requirements-base.txt
	@.venv/bin/pip install https://github.com/kivy-garden/graph/archive/master.zip
	@echo "✅ Installation complete!"

clean:
	@echo "🧹 Cleaning up..."
	@rm -rf .venv
	@find . -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete 2>/dev/null || true

test:
	@python -m pytest tests/ -v

test-fast:
	@python -m pytest tests/ -v -m "not slow"

test-slow:
	@python -m pytest tests/ -v -m "slow"

test-coverage:
	@python -m pytest tests/ -v --cov=. --cov-report=html:htmlcov --cov-report=term-missing

ci-check:
	@./scripts/run-ci-checks.sh
