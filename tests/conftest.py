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
    """
    Configures environment variables for testing, enabling mock sensors and specifying a test database path for all tests.
    
    This fixture ensures a consistent test environment by setting relevant environment variables before tests run and removing the test database file after tests complete.
    """
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
    """
    Creates and yields the filename of a temporary database file for testing, ensuring the file is deleted after the test completes.
    
    Yields:
        str: The path to the temporary database file.
    """
    temp_db = tempfile.NamedTemporaryFile(suffix='.db', delete=False)
    temp_db.close()
    
    yield temp_db.name
    
    # Cleanup
    if os.path.exists(temp_db.name):
        os.remove(temp_db.name)


@pytest.fixture
def mock_database_manager(temp_database):
    """
    Yield a DatabaseManager instance using a temporary database, with event dispatching patched for testing.
    
    Yields:
        DatabaseManager: An instance connected to a temporary database, with its event dispatch method mocked to prevent Kivy-related errors during tests.
    """
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
    """
    Provides a dictionary of representative sensor readings for use in tests.
    
    Returns:
        dict: Sample sensor data including oxygen voltage and percent, CO2 voltage and ppm, temperature, pressure (BAR), and humidity.
    """
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
    """
    Provides a dictionary of sample application settings for use in tests.
    
    Returns:
        dict: Sample settings including app metadata, display configuration, and sensor calibration parameters.
    """
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
    """
    Provides a MagicMock instance in place of the Kivy App class for UI testing.
    
    Yields:
        MagicMock: A mock Kivy App instance for use in tests.
    """
    with patch('kivy.app.App') as mock_app:
        mock_instance = MagicMock()
        mock_app.return_value = mock_instance
        yield mock_instance


@pytest.fixture
def mock_sensor_interface():
    """
    Provides a mock implementation of the SensorInterface for testing without hardware.
    
    Returns:
        MockSensorInterface: An instance with methods returning predefined sensor values, allowing tests to simulate sensor readings and update mock data dynamically.
    """
    from utils.sensor_interface import SensorInterface
    
    class MockSensorInterface(SensorInterface):
        def __init__(self):
            """
            Initialize the mock sensor interface with default sensor readings for testing purposes.
            """
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
            """
            Return the current mock oxygen sensor voltage value.
            """
            return self.mock_data['o2_voltage']
        
        def read_oxygen_percent(self) -> float:
            """
            Return the current mock oxygen concentration as a percentage.
            """
            return self.mock_data['o2_percent']
        
        def read_co2_voltage(self) -> float:
            """
            Return the mock CO2 sensor voltage value.
            """
            return self.mock_data['co2_voltage']
        
        def read_co2_ppm(self) -> float:
            """
            Return the current mock CO2 concentration in parts per million (ppm).
            """
            return self.mock_data['co2_ppm']
        
        def read_temperature_c(self) -> float:
            """
            Returns the current mock temperature value in degrees Celsius.
            """
            return self.mock_data['temperature']
        
        def read_pressure_hpa(self) -> float:
            """
            Return the current mock pressure value in hectopascals (hPa).
            """
            return self.mock_data['pressure']
        
        def read_humidity_pct(self) -> float:
            """
            Return the current mock humidity value as a percentage.
            """
            return self.mock_data['humidity']
        
        def is_power_button_pressed(self) -> bool:
            """
            Return whether the mock power button is currently pressed.
            
            Returns:
                bool: True if the mock power button is pressed, False otherwise.
            """
            return self.mock_data['button_pressed']
        
        def set_mock_data(self, **kwargs):
            """
            Update the mock sensor data with new values.
            
            Parameters:
            	**kwargs: Key-value pairs representing sensor data fields to update.
            """
            self.mock_data.update(kwargs)
    
    return MockSensorInterface()


@pytest.fixture
def calibration_data():
    """
    Return a list of sample calibration records for oxygen and helium sensors, each containing sensor type, calibration date, voltage reading, temperature, and notes.
    """
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
    """
    Temporarily saves and restores environment variables for the duration of a test.
    
    Ensures that any changes to environment variables during a test do not persist beyond the test's scope.
    """
    original_env = os.environ.copy()
    
    yield
    
    # Restore original environment
    os.environ.clear()
    os.environ.update(original_env)


def pytest_configure(config):
    """
    Registers custom test markers for unit, integration, UI, hardware-dependent, and slow tests in the pytest configuration.
    """
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
