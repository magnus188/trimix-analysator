# Trimix Analyzer - Testing Guide

This document provides comprehensive information about the testing framework implemented for the Trimix Analyzer application.

## Overview

The testing framework includes:
- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **Performance Tests**: Measure performance characteristics
- **UI Tests**: Test user interface components (where applicable)
- **Smoke Tests**: Basic functionality verification
- **CI/CD Integration**: Automated testing on pull requests

## Test Structure

```
tests/
├── conftest.py                 # Pytest configuration and fixtures
├── test_basic.py              # Original basic tests (maintained for compatibility)
├── test_platform_detector.py  # Platform detection tests
├── test_database_manager.py   # Database functionality tests
├── test_sensor_interface.py   # Sensor interface tests
├── test_settings.py           # Settings management tests
├── test_calibration_reminder.py # Calibration reminder tests
├── test_integration.py        # Integration tests
├── test_performance.py        # Performance and benchmark tests
└── test_utils.py              # Test utilities and helpers
```

## Quick Start

### For Development

```bash
# Quick test (recommended during development)
./dev_test.sh quick

# Run unit tests only
./dev_test.sh unit

# Run all tests with coverage
./dev_test.sh all

# Fix code style issues
./dev_test.sh fix
```

### Using Python Test Runner

```bash
# Comprehensive test runner with many options
python test_runner.py --help

# Run smoke tests + unit tests (default)
python test_runner.py

# Run in CI mode (all checks)
python test_runner.py --ci

# Run with coverage
python test_runner.py --all --coverage

# Quick development tests
python test_runner.py --quick
```

### Using Pytest Directly

```bash
# Run all tests
pytest tests/

# Run only unit tests
pytest tests/ -m "unit"

# Run with coverage
pytest tests/ --cov=. --cov-report=html

# Run specific test file
pytest tests/test_database_manager.py -v

# Run tests matching a pattern
pytest tests/ -k "test_sensor"
```

## Test Categories

Tests are organized using pytest markers:

- `@pytest.mark.unit` - Unit tests (fast, isolated)
- `@pytest.mark.integration` - Integration tests (slower, multiple components)
- `@pytest.mark.ui` - User interface tests
- `@pytest.mark.database` - Database-related tests
- `@pytest.mark.sensor` - Sensor-related tests
- `@pytest.mark.slow` - Performance tests (slow running)
- `@pytest.mark.hardware` - Tests requiring hardware (skipped in CI)

### Running Specific Test Categories

```bash
# Run only unit tests, excluding slow ones
pytest tests/ -m "unit and not slow"

# Run integration tests
pytest tests/ -m "integration"

# Run database tests
pytest tests/ -m "database"

# Run everything except hardware tests
pytest tests/ -m "not hardware"
```

## Environment Setup

Tests automatically configure the environment for mock sensors:

```bash
# These are set automatically by test runners
export TRIMIX_MOCK_SENSORS=1
export TRIMIX_ENVIRONMENT=test
```

### Manual Environment Setup

If running tests manually without the test runners:

```python
import os
os.environ['TRIMIX_MOCK_SENSORS'] = '1'
os.environ['TRIMIX_ENVIRONMENT'] = 'test'
```

## Mock Components

The testing framework provides comprehensive mocking:

### Sensor Interface Mocking
- Mock sensor readings with configurable values
- Realistic sensor data within expected ranges
- Test different sensor failure scenarios

### Database Mocking
- Temporary databases for each test
- Isolated test data
- Transaction testing

### UI Component Mocking
- Mock Kivy components for UI testing
- Widget interaction testing
- Screen navigation testing

## Test Fixtures

Common fixtures available in all tests (defined in `conftest.py`):

- `mock_database_manager` - Temporary database manager
- `sample_sensor_data` - Realistic sensor data
- `sample_settings` - Complete settings data
- `mock_sensor_interface` - Configurable mock sensors
- `calibration_data` - Sample calibration history
- `temp_database` - Temporary database file

### Using Fixtures

```python
def test_example(mock_database_manager, sample_sensor_data):
    """Example test using fixtures."""
    db = mock_database_manager
    
    # Test database operation
    db.set_setting('test', 'key', 'value')
    result = db.get_setting('test', 'key')
    assert result == 'value'
    
    # Use sample data
    assert sample_sensor_data['o2_percent'] == 21.0
```

## Performance Testing

Performance tests measure critical operations:

```python
@pytest.mark.slow
@pytest.mark.performance
def test_sensor_reading_performance(benchmark):
    """Benchmark sensor reading performance."""
    
    def read_sensors():
        return get_readings()
    
    result = benchmark(read_sensors)
    assert isinstance(result, dict)
```

Run performance tests:

```bash
# Run performance tests only
pytest tests/ -m "slow"

# Run with benchmark output
pytest tests/ -m "slow" --benchmark-only
```

## Coverage Reports

Generate detailed coverage reports:

```bash
# HTML coverage report
pytest tests/ --cov=. --cov-report=html
# Open htmlcov/index.html in browser

# Terminal coverage report
pytest tests/ --cov=. --cov-report=term-missing

# XML coverage for CI
pytest tests/ --cov=. --cov-report=xml
```

## CI/CD Integration

### GitHub Actions

The project includes a comprehensive GitHub Actions workflow (`.github/workflows/tests.yml`):

- **Multi-Python Version Testing**: Python 3.9, 3.10, 3.11
- **Automated Testing**: Runs on push to main/develop and pull requests
- **Code Quality**: Black, flake8, isort checks
- **Security Scanning**: Safety and bandit checks
- **Coverage Reporting**: Codecov integration
- **Performance Testing**: Benchmark results on develop branch

### Local CI Simulation

Run the same checks as CI locally:

```bash
# Run all CI checks
python test_runner.py --ci

# Individual checks
python test_runner.py --lint
python test_runner.py --security
```

## Writing New Tests

### Test Naming Conventions

- Test files: `test_*.py`
- Test classes: `Test*`
- Test methods: `test_*`

### Example Test

```python
import pytest
from utils.your_module import YourClass

class TestYourClass:
    """Test suite for YourClass."""

    @pytest.mark.unit
    def test_basic_functionality(self, mock_database_manager):
        """Test basic functionality."""
        instance = YourClass()
        result = instance.do_something()
        assert result is not None

    @pytest.mark.integration
    def test_integration_with_database(self, mock_database_manager):
        """Test integration with database."""
        db = mock_database_manager
        instance = YourClass(db)
        
        # Test the integration
        instance.save_data('key', 'value')
        result = db.get_setting('category', 'key')
        assert result == 'value'
```

### Test Guidelines

1. **Use descriptive test names** that explain what is being tested
2. **Use appropriate markers** (`@pytest.mark.unit`, etc.)
3. **Test both success and failure cases**
4. **Use fixtures for common setup**
5. **Keep tests independent** (no dependencies between tests)
6. **Mock external dependencies** (hardware, network, etc.)
7. **Assert meaningful conditions** (not just "no exception")

## Debugging Tests

### Running Single Tests

```bash
# Run specific test method
pytest tests/test_database_manager.py::TestDatabaseManager::test_set_and_get_setting_string -v

# Run with debugger on failure
pytest tests/test_database_manager.py --pdb

# Print output from tests
pytest tests/test_database_manager.py -s
```

### Test Output

```bash
# Verbose output
pytest tests/ -v

# Show local variables on failure
pytest tests/ -l

# Show full traceback
pytest tests/ --tb=long

# Show only short traceback
pytest tests/ --tb=short
```

## Common Issues and Solutions

### Import Errors
```bash
# Ensure project root is in Python path
export PYTHONPATH=/home/magnus/trimix:$PYTHONPATH

# Or use the test runners which handle this automatically
./dev_test.sh quick
```

### Mock Sensor Issues
```bash
# Ensure mock environment is set
export TRIMIX_MOCK_SENSORS=1
export TRIMIX_ENVIRONMENT=test
```

### Database Lock Issues
```bash
# Clean up any lock files
rm -f /tmp/trimix_test.db*
```

### Performance Test Timeouts
```bash
# Run performance tests with longer timeout
pytest tests/ -m "slow" --timeout=300
```

## Test Data

### Sample Data Generation

The `test_utils.py` module provides utilities for generating test data:

```python
from tests.test_utils import TestDataGenerator

# Generate sensor readings
readings = TestDataGenerator.generate_sensor_readings(count=10)

# Generate calibration history
history = TestDataGenerator.generate_calibration_history('o2', count=5)

# Generate settings data
settings = TestDataGenerator.generate_settings_data()
```

### Test Assertions

Custom assertions for Trimix-specific data:

```python
from tests.test_utils import TestAssertions

# Validate sensor reading
TestAssertions.assert_sensor_reading_valid(reading)

# Validate calibration data
TestAssertions.assert_calibration_data_valid(calibration)

# Validate settings structure
TestAssertions.assert_settings_structure_valid(settings)
```

## Continuous Testing During Development

### Watch Mode (Manual)

For continuous testing during development, you can set up a simple watch loop:

```bash
# Watch for file changes and run tests
while inotifywait -e modify -r .; do
    ./dev_test.sh quick
done
```

### IDE Integration

Most IDEs support pytest integration:

- **VS Code**: Python extension with pytest support
- **PyCharm**: Built-in pytest runner
- **Vim/Neovim**: vim-test plugin

## Maintenance

### Updating Test Dependencies

```bash
# Update development dependencies
pip install --upgrade -r requirements-dev.txt

# Check for security vulnerabilities
safety check

# Update and freeze dependencies
pip-compile requirements-dev.in
```

### Test Database Cleanup

```bash
# Clean up test databases and artifacts
./dev_test.sh clean

# Or manually
rm -rf .pytest_cache htmlcov .coverage coverage.xml
find . -name "*.pyc" -delete
find . -name "__pycache__" -type d -exec rm -rf {} +
```

## Advanced Testing Features

### Parametrized Tests

```python
@pytest.mark.parametrize("input_value,expected", [
    (20.9, "normal"),
    (16.0, "low"),
    (25.0, "high"),
])
def test_o2_level_classification(input_value, expected):
    result = classify_o2_level(input_value)
    assert result == expected
```

### Test Fixtures with Scope

```python
@pytest.fixture(scope="session")
def expensive_resource():
    """Fixture that's created once per test session."""
    resource = create_expensive_resource()
    yield resource
    cleanup_expensive_resource(resource)
```

### Conditional Test Skipping

```python
@pytest.mark.skipif(not hardware_available(), reason="Hardware not available")
def test_hardware_function():
    """Test that requires actual hardware."""
    pass
```

This testing framework provides comprehensive coverage for the Trimix Analyzer application, ensuring reliability and maintainability throughout development and in production.
