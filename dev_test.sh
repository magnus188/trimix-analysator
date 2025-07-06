#!/bin/bash

# Development test script for quick testing during development
# Usage: ./dev_test.sh [unit|integration|all|quick|fix]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Set up environment
export TRIMIX_MOCK_SENSORS=1
export TRIMIX_ENVIRONMENT=test

# Check if we're in the right directory
if [ ! -f "main.py" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ] && [ -z "$CONDA_DEFAULT_ENV" ]; then
    print_warning "No virtual environment detected. Consider activating one."
fi

# Install dependencies if needed
if [ ! -f ".deps_installed" ]; then
    print_status "Installing development dependencies..."
    pip install -r requirements-dev.txt
    touch .deps_installed
    print_success "Dependencies installed"
fi

# Default action
action="${1:-quick}"

case "$action" in
    "unit")
        print_status "Running unit tests..."
        python -m pytest tests/ -m "unit and not slow" -v
        ;;
    "integration")
        print_status "Running integration tests..."
        python -m pytest tests/ -m "integration" -v
        ;;
    "all")
        print_status "Running all tests..."
        python -m pytest tests/ -v --cov=. --cov-report=html --cov-report=term-missing
        print_success "Coverage report generated in htmlcov/"
        ;;
    "quick")
        print_status "Running quick test suite..."
        # Smoke test first
        print_status "Running smoke tests..."
        python -c "
import sys
sys.path.insert(0, '.')

# Test basic imports
try:
    from main import TrimixApp
    from utils.database_manager import db_manager
    from utils.sensor_interface import get_sensors
    print('✅ All imports successful')
except Exception as e:
    print(f'❌ Import failed: {e}')
    sys.exit(1)

# Test basic functionality
try:
    sensors = get_sensors()
    readings = {'o2': 21.0, 'temp': 25.0, 'press': 1.013, 'hum': 45.0}
    print('✅ Basic functionality test passed')
except Exception as e:
    print(f'❌ Basic functionality test failed: {e}')
    sys.exit(1)
"
        # Run unit tests (fast ones only)
        print_status "Running fast unit tests..."
        python -m pytest tests/ -m "unit and not slow" --tb=short -q
        ;;
    "performance")
        print_status "Running performance tests..."
        python -m pytest tests/ -m "slow" -v
        ;;
    "fix")
        print_status "Fixing code style..."
        black .
        isort .
        print_success "Code style fixed"
        ;;
    "lint")
        print_status "Running linting checks..."
        black --check --diff .
        flake8 .
        isort --check-only --diff .
        print_success "Linting checks passed"
        ;;
    "clean")
        print_status "Cleaning up test artifacts..."
        rm -rf .pytest_cache
        rm -rf htmlcov
        rm -rf .coverage
        rm -f coverage.xml
        rm -rf __pycache__
        find . -name "*.pyc" -delete
        find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
        rm -f .deps_installed
        print_success "Clean up completed"
        ;;
    "help"|"-h"|"--help")
        echo "Development Test Script"
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  quick       Run quick test suite (default)"
        echo "  unit        Run unit tests only"
        echo "  integration Run integration tests only"
        echo "  all         Run all tests with coverage"
        echo "  performance Run performance tests"
        echo "  fix         Fix code style with black and isort"
        echo "  lint        Run linting checks"
        echo "  clean       Clean up test artifacts"
        echo "  help        Show this help message"
        ;;
    *)
        print_error "Unknown command: $action"
        print_status "Run '$0 help' for available commands"
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    print_success "Test suite completed successfully!"
else
    print_error "Test suite failed!"
    exit 1
fi
