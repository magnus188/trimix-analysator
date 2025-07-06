"""
Basic tests for Trimix Analyzer.
These tests run in CI/CD pipeline with mock sensors.
"""

import pytest
import os
import sys

# Add project root to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

@pytest.fixture(autouse=True)
def mock_environment():
    """Ensure tests run with mock sensors."""
    os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    os.environ['TRIMIX_ENVIRONMENT'] = 'test'


def test_platform_detection():
    """Test platform detection functionality."""
    from utils.platform_detector import is_development_environment, get_platform_info
    
    # Should detect development environment
    assert is_development_environment() == True
    
    # Should return platform info
    info = get_platform_info()
    assert 'system' in info
    assert 'is_development' in info
    assert info['is_development'] == True


def test_mock_sensors():
    """Test mock sensor functionality."""
    from utils.sensor_interface import get_sensors
    
    sensors = get_sensors()
    
    # Test all sensor readings
    o2_voltage = sensors.read_oxygen_voltage()
    o2_percent = sensors.read_oxygen_percent()
    co2_voltage = sensors.read_co2_voltage()
    co2_ppm = sensors.read_co2_ppm()
    temperature = sensors.read_temperature_c()
    pressure = sensors.read_pressure_hpa()
    humidity = sensors.read_humidity_pct()
    button = sensors.is_power_button_pressed()
    
    # Basic sanity checks
    assert 0 <= o2_voltage <= 5.0
    assert 0 <= o2_percent <= 100
    assert 0 <= co2_voltage <= 5.0
    assert 0 <= co2_ppm <= 10000
    assert -50 <= temperature <= 100
    assert 0.8 <= pressure <= 1.2  # Pressure is now in BAR (around 1.0)
    assert 0 <= humidity <= 100
    assert isinstance(button, bool)


def test_database_manager():
    """Test database manager functionality."""
    from utils.database_manager import db_manager
    
    # Test setting and getting values
    db_manager.set_setting('test', 'key', 'value')
    result = db_manager.get_setting('test', 'key')
    assert result == 'value'
    
    # Test default values
    default_result = db_manager.get_setting('test', 'nonexistent', 'default')
    assert default_result == 'default'


def test_sensor_meta():
    """Test sensor metadata."""
    from utils.sensor_meta import _SENSOR_META
    
    required_sensors = ['o2', 'temp', 'press', 'hum']
    
    for sensor in required_sensors:
        assert sensor in _SENSOR_META
        assert 'label' in _SENSOR_META[sensor]
        assert 'sign' in _SENSOR_META[sensor]
        assert 'color' in _SENSOR_META[sensor]


def test_app_imports():
    """Test that main app can be imported without errors."""
    # This tests that all imports work with mock sensors
    try:
        from main import TrimixApp
        app = TrimixApp()
        assert app is not None
    except Exception as e:
        pytest.fail(f"Failed to import main app: {e}")


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
