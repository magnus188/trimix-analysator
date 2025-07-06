"""
Pytest configuration and shared fixtures for Trimix Analyzer tests.
"""

import pytest
import os
import sys
import tempfile
import shutil
from unittest.mock import patch, MagicMock
from datetime import datetime, timedelta

# Add project root to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))


@pytest.fixture(scope="session", autouse=True)
def setup_test_environment():
    """Setup test environment for all tests."""
    # Force mock sensors for all tests
    os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    os.environ['TRIMIX_ENVIRONMENT'] = 'test'
    
    # Set test database path
    test_db_path = os.path.join(tempfile.gettempdir(), 'trimix_test.db')
    os.environ['TRIMIX_TEST_DB_PATH'] = test_db_path
    
    yield
    
    # Cleanup
    if os.path.exists(test_db_path):
        os.remove(test_db_path)


@pytest.fixture
def temp_database():
    """Create a temporary database for testing."""
    temp_db = tempfile.NamedTemporaryFile(suffix='.db', delete=False)
    temp_db.close()
    
    yield temp_db.name
    
    # Cleanup
    if os.path.exists(temp_db.name):
        os.remove(temp_db.name)


@pytest.fixture
def mock_database_manager(temp_database):
    """Create a database manager with temporary database."""
    from utils.database_manager import DatabaseManager
    from unittest.mock import patch
    
    # Create a fresh database manager with temp db
    db = DatabaseManager(temp_database)
    
    # Mock the event dispatching to avoid Kivy event errors in tests
    with patch.object(db, 'dispatch'):
        yield db
    
    # Cleanup
    db.close()


@pytest.fixture
def sample_sensor_data():
    """Sample sensor data for testing."""
    return {
        'o2_voltage': 1.5,
        'o2_percent': 21.0,
        'co2_voltage': 0.5,
        'co2_ppm': 400,
        'temperature': 25.0,
        'pressure': 1.013,  # in BAR
        'humidity': 45.0
    }


@pytest.fixture
def sample_settings():
    """Sample settings data for testing."""
    return {
        'app': {
            'first_run': False,
            'app_version': '1.0.0',
            'theme': 'dark'
        },
        'display': {
            'brightness': 75,
            'sleep_timeout': 10
        },
        'sensors': {
            'calibration_interval_days': 30,
            'auto_calibration_reminder': True,
            'o2_calibration_offset': 0.1
        }
    }


@pytest.fixture
def mock_kivy_app():
    """Mock Kivy app for UI testing."""
    with patch('kivy.app.App') as mock_app:
        mock_instance = MagicMock()
        mock_app.return_value = mock_instance
        yield mock_instance


@pytest.fixture
def mock_sensor_interface():
    """Mock sensor interface for testing without hardware."""
    from utils.sensor_interface import SensorInterface
    
    class MockSensorInterface(SensorInterface):
        def __init__(self):
            self.mock_data = {
                'o2_voltage': 1.5,
                'o2_percent': 21.0,
                'co2_voltage': 0.5,
                'co2_ppm': 400,
                'temperature': 25.0,
                'pressure': 1.013,
                'humidity': 45.0,
                'button_pressed': False
            }
        
        def read_oxygen_voltage(self) -> float:
            return self.mock_data['o2_voltage']
        
        def read_oxygen_percent(self) -> float:
            return self.mock_data['o2_percent']
        
        def read_co2_voltage(self) -> float:
            return self.mock_data['co2_voltage']
        
        def read_co2_ppm(self) -> float:
            return self.mock_data['co2_ppm']
        
        def read_temperature_c(self) -> float:
            return self.mock_data['temperature']
        
        def read_pressure_hpa(self) -> float:
            return self.mock_data['pressure']
        
        def read_humidity_pct(self) -> float:
            return self.mock_data['humidity']
        
        def is_power_button_pressed(self) -> bool:
            return self.mock_data['button_pressed']
        
        def set_mock_data(self, **kwargs):
            self.mock_data.update(kwargs)
    
    return MockSensorInterface()


@pytest.fixture
def calibration_data():
    """Sample calibration data for testing."""
    base_date = datetime.now()
    return [
        {
            'sensor_type': 'o2',
            'calibration_date': base_date - timedelta(days=10),
            'voltage_reading': 1.5,
            'temperature': 25.0,
            'notes': 'Test calibration'
        },
        {
            'sensor_type': 'he',
            'calibration_date': base_date - timedelta(days=5),
            'voltage_reading': 2.1,
            'temperature': 24.5,
            'notes': 'Another test calibration'
        }
    ]


@pytest.fixture
def clean_environment():
    """Clean environment variables after test."""
    original_env = os.environ.copy()
    
    yield
    
    # Restore original environment
    os.environ.clear()
    os.environ.update(original_env)


def pytest_configure(config):
    """Configure pytest with custom markers."""
    config.addinivalue_line(
        "markers", "unit: mark test as a unit test"
    )
    config.addinivalue_line(
        "markers", "integration: mark test as an integration test"
    )
    config.addinivalue_line(
        "markers", "ui: mark test as a UI test"
    )
    config.addinivalue_line(
        "markers", "hardware: mark test as requiring hardware"
    )
    config.addinivalue_line(
        "markers", "slow: mark test as slow running"
    )
