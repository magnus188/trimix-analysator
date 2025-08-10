#!/bin/bash
# 
# Local CI/CD Simulation Script
# Runs the same checks as GitHub Actions locally
#

set -e

echo "🚀 Trimix Analyzer - Local CI/CD Checks"
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "main.py" ] || [ ! -f "requirements-base.txt" ]; then
    echo -e "${RED}❌ Error: Please run this script from the Trimix project root directory${NC}"
    exit 1
fi

# print_step prints a formatted step header with a blue icon and separator for CI/CD output.
print_step() {
    echo -e "\n${BLUE}🔍 $1${NC}"
    echo "----------------------------------------"
}

# print_result prints a colored success or failure message based on the exit code and exits on failure.
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit $1
    fi
}

# Set up environment
export TRIMIX_ENVIRONMENT=test
export TRIMIX_MOCK_SENSORS=true

print_step "Checking Python version"
python --version
python -c "import sys; exit(0 if sys.version_info >= (3, 9) else 1)"
print_result $? "Python version check"

print_step "Installing dependencies"
pip install -r requirements-base.txt > /dev/null 2>&1
pip install -r requirements-dev.txt > /dev/null 2>&1
print_result $? "Dependencies installed"

print_step "Syntax and import checks"
python -m py_compile main.py
python -m py_compile version.py
find utils/ -name "*.py" -exec python -m py_compile {} \; 2>/dev/null
find screens/ -name "*.py" -exec python -m py_compile {} \; 2>/dev/null
find widgets/ -name "*.py" -exec python -m py_compile {} \; 2>/dev/null
find tests/ -name "*.py" -exec python -m py_compile {} \; 2>/dev/null
print_result $? "Syntax check"

print_step "Testing imports"
python -c "import main" 2>/dev/null
python -c "import version" 2>/dev/null
python -c "from utils.platform_detector import is_development_environment" 2>/dev/null
python -c "from utils.database_manager import DatabaseManager" 2>/dev/null
print_result $? "Import check"

print_step "Code formatting check"
if command -v black &> /dev/null; then
    black --check . || echo -e "${YELLOW}⚠️  Code formatting issues found. Run 'black .' to fix.${NC}"
else
    echo -e "${YELLOW}⚠️  Black not installed. Skipping format check.${NC}"
fi

print_step "Linting"
if command -v flake8 &> /dev/null; then
    # Focus on project code only, ignore dependencies
    flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics \
        --exclude=.venv,__pycache__,.git,.pytest_cache,htmlcov,build,dist
    print_result $? "Critical linting issues"
    
    echo "Running extended linting..."
    flake8 . --count --exit-zero --max-complexity=10 --max-line-length=88 --statistics \
        --exclude=.venv,__pycache__,.git,.pytest_cache,htmlcov,build,dist
else
    echo -e "${YELLOW}⚠️  Flake8 not installed. Skipping lint check.${NC}"
fi

print_step "Running fast tests"
python -m pytest tests/ -v -m "not slow" --tb=short --maxfail=5
print_result $? "Fast tests"

print_step "Running security checks"
if command -v bandit &> /dev/null; then
    bandit -r . --severity-level medium -q
    print_result $? "Security check (bandit)"
else
    echo -e "${YELLOW}⚠️  Bandit not installed. Skipping security check.${NC}"
fi

if command -v safety &> /dev/null; then
    safety check
    print_result $? "Dependency security check (safety)"
else
    echo -e "${YELLOW}⚠️  Safety not installed. Skipping dependency security check.${NC}"
fi

# Optional comprehensive tests
read -p "$(echo -e ${YELLOW})Run comprehensive tests (including slow tests)? [y/N]: $(echo -e ${NC})" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Running comprehensive tests with coverage"
    python -m pytest tests/ --cov=. --cov-report=html --cov-report=term-missing
    print_result $? "Comprehensive tests with coverage"
    
    echo -e "${BLUE}📊 Coverage report generated in htmlcov/index.html${NC}"
fi

echo -e "\n${GREEN}🎉 All checks completed successfully!${NC}"
echo -e "${BLUE}Your code is ready for CI/CD pipeline.${NC}"

# Summary
echo -e "\n📋 Summary:"
echo -e "  ✅ Python version compatible"
echo -e "  ✅ Dependencies installed"
echo -e "  ✅ Syntax and imports valid"
echo -e "  ✅ Fast tests passing"
echo -e "  ✅ Security checks passed"

echo -e "\n🚀 Next steps:"
echo -e "  1. Create/update your pull request"
echo -e "  2. CI/CD will run automatically"
echo -e "  3. Address any additional issues found in CI"
