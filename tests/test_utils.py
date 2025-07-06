"""
Test utilities and helpers for the Trimix Analyzer test suite.
"""

import os
import tempfile
import shutil
from datetime import datetime, timedelta
from typing import Dict, Any, List
from unittest.mock import MagicMock


class MockSensorInterface:
    """Mock sensor interface for testing."""
    
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
        Return the current mock oxygen percentage value.
        """
        return self.mock_data['o2_percent']
    
    def read_co2_voltage(self) -> float:
        """
        Return the current mock CO2 sensor voltage value.
        """
        return self.mock_data['co2_voltage']
    
    def read_co2_ppm(self) -> float:
        """
        Return the current mock CO2 concentration in parts per million (ppm).
        """
        return self.mock_data['co2_ppm']
    
    def read_temperature_c(self) -> float:
        """
        Return the current mock temperature value in degrees Celsius.
        """
        return self.mock_data['temperature']
    
    def read_pressure_hpa(self) -> float:
        """
        Returns the current mock pressure value in hectopascals (hPa).
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
        Update the mock sensor data with new values for testing scenarios.
        
        Parameters:
        	**kwargs: Key-value pairs representing mock sensor data fields to update.
        """
        self.mock_data.update(kwargs)


class TestDataGenerator:
    """Generate test data for various scenarios."""
    
    @staticmethod
    def generate_sensor_readings(count: int = 10) -> List[Dict[str, Any]]:
        """
        Generate a list of synthetic sensor reading dictionaries with randomized values for O2, temperature, pressure, and humidity.
        
        Parameters:
            count (int): Number of sensor readings to generate.
        
        Returns:
            List[Dict[str, Any]]: List of sensor readings, each containing a timestamp and randomized sensor values.
        """
        import random
        
        readings = []
        base_time = datetime.now()
        
        for i in range(count):
            reading = {
                'timestamp': base_time - timedelta(minutes=i),
                'o2': 20.9 + random.uniform(-0.5, 0.5),
                'temp': 25.0 + random.uniform(-2.0, 2.0),
                'press': 1.013 + random.uniform(-0.05, 0.05),
                'hum': 45.0 + random.uniform(-5.0, 5.0)
            }
            readings.append(reading)
        
        return readings
    
    @staticmethod
    def generate_calibration_history(sensor_type: str, count: int = 5) -> List[Dict[str, Any]]:
        """
        Generate a list of synthetic calibration history records for a specified sensor type.
        
        Parameters:
        	sensor_type (str): The type of sensor for which to generate calibration records.
        	count (int, optional): The number of calibration records to generate. Defaults to 5.
        
        Returns:
        	List[Dict[str, Any]]: A list of calibration records, each containing sensor type, calibration date, voltage reading, temperature, and notes.
        """
        import random
        
        history = []
        base_time = datetime.now()
        
        for i in range(count):
            calibration = {
                'sensor_type': sensor_type,
                'calibration_date': base_time - timedelta(days=i * 30),
                'voltage_reading': 1.5 + random.uniform(-0.2, 0.2),
                'temperature': 25.0 + random.uniform(-3.0, 3.0),
                'notes': f'Test calibration {i + 1}'
            }
            history.append(calibration)
        
        return history
    
    @staticmethod
    def generate_settings_data() -> Dict[str, Dict[str, Any]]:
        """
        Return a nested dictionary representing comprehensive application settings for testing purposes.
        
        The returned settings include categories for app configuration, display, Wi-Fi, sensors, safety, and measurement units, each populated with representative values.
         
        Returns:
            settings (Dict[str, Dict[str, Any]]): Nested dictionary containing mock settings data for all major configuration categories.
        """
        return {
            'app': {
                'first_run': False,
                'app_version': '1.0.0',
                'theme': 'dark',
                'language': 'en',
                'debug_mode': False,
                'last_screen': 'home'
            },
            'display': {
                'brightness': 75,
                'sleep_timeout': 10,
                'auto_brightness': True
            },
            'wifi': {
                'auto_connect': True,
                'remember_networks': True,
                'scan_interval': 30,
                'last_network': 'TestNetwork'
            },
            'sensors': {
                'calibration_interval_days': 30,
                'auto_calibration_reminder': True,
                'o2_calibration_offset': 0.1,
                'he_calibration_offset': -0.05,
                'auto_calibrate': True
            },
            'safety': {
                'max_o2_percentage': 100,
                'max_he_percentage': 85,
                'warning_thresholds': {
                    'high_o2': 23.0,
                    'low_o2': 19.0,
                    'high_he': 50.0
                }
            },
            'units': {
                'pressure': 'bar',
                'temperature': 'celsius',
                'depth': 'meters'
            }
        }


class DatabaseTestHelper:
    """Helper class for database testing."""
    
    @staticmethod
    def create_temp_database():
        """
        Create and return the file path of a temporary database file.
        
        Returns:
            str: The file path to the created temporary database file.
        """
        temp_db = tempfile.NamedTemporaryFile(suffix='.db', delete=False)
        temp_db.close()
        return temp_db.name
    
    @staticmethod
    def cleanup_temp_database(db_path: str):
        """
        Delete the temporary database file at the specified path if it exists.
        
        Parameters:
            db_path (str): Path to the temporary database file to be deleted.
        """
        if os.path.exists(db_path):
            os.remove(db_path)
    
    @staticmethod
    def populate_test_data(db_manager, test_data: Dict[str, Any]):
        """
        Inserts test settings data into the database using the provided database manager.
        
        Parameters:
            test_data (Dict[str, Any]): A dictionary mapping categories to their respective settings and values.
        """
        for category, settings in test_data.items():
            for key, value in settings.items():
                db_manager.set_setting(category, key, value)
    
    @staticmethod
    def verify_database_integrity(db_manager) -> bool:
        """
        Checks whether the database manager supports basic set, get, and category retrieval operations.
        
        Returns:
            bool: True if all operations succeed and return expected results; False otherwise.
        """
        try:
            # Test basic operations
            test_key = 'integrity_test'
            test_value = 'test_value'
            
            # Set and get a value
            success = db_manager.set_setting('test', test_key, test_value)
            if not success:
                return False
            
            retrieved_value = db_manager.get_setting('test', test_key)
            if retrieved_value != test_value:
                return False
            
            # Test category retrieval
            category = db_manager.get_settings_category('test')
            if not isinstance(category, dict):
                return False
            
            return True
        
        except Exception:
            return False


class EnvironmentManager:
    """Manage test environment setup and cleanup."""
    
    def __init__(self):
        """
        Initialize the EnvironmentManager and store a dictionary for original environment variables.
        """
        self.original_env = {}
    
    def setup_test_environment(self):
        """
        Sets up environment variables required for testing, saving original values for later restoration.
        
        This method sets specific environment variables to enable test mode and mock sensors, while preserving any existing values so they can be restored after tests.
        """
        # Store original environment
        test_vars = ['TRIMIX_ENVIRONMENT', 'TRIMIX_MOCK_SENSORS', 'TRIMIX_TEST_DB_PATH']
        for var in test_vars:
            if var in os.environ:
                self.original_env[var] = os.environ[var]
        
        # Set test environment
        os.environ['TRIMIX_ENVIRONMENT'] = 'test'
        os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    
    def cleanup_test_environment(self):
        """
        Restores the original environment variables after test modifications by removing test-specific variables and resetting any previously saved values.
        """
        # Remove test variables
        test_vars = ['TRIMIX_ENVIRONMENT', 'TRIMIX_MOCK_SENSORS', 'TRIMIX_TEST_DB_PATH']
        for var in test_vars:
            if var in os.environ:
                del os.environ[var]
        
        # Restore original values
        for var, value in self.original_env.items():
            os.environ[var] = value


class TestAssertions:
    """Custom assertions for Trimix tests."""
    
    @staticmethod
    def assert_sensor_reading_valid(reading: Dict[str, Any]):
        """
        Asserts that a sensor reading dictionary contains required keys with valid types and value ranges for O2, temperature, pressure, and humidity.
        
        Raises an AssertionError if any key is missing, has an invalid type, or its value falls outside the expected range.
        """
        required_keys = ['o2', 'temp', 'press', 'hum']
        
        for key in required_keys:
            assert key in reading, f"Missing key: {key}"
            assert isinstance(reading[key], (int, float)), f"Invalid type for {key}: {type(reading[key])}"
        
        # Check value ranges
        assert 0 <= reading['o2'] <= 100, f"O2 out of range: {reading['o2']}"
        assert -50 <= reading['temp'] <= 100, f"Temperature out of range: {reading['temp']}"
        assert 0.5 <= reading['press'] <= 2.0, f"Pressure out of range: {reading['press']}"
        assert 0 <= reading['hum'] <= 100, f"Humidity out of range: {reading['hum']}"
    
    @staticmethod
    def assert_calibration_data_valid(calibration: Dict[str, Any]):
        """
        Assert that the provided calibration data dictionary contains valid keys, types, and value ranges.
        
        Raises an AssertionError if required keys are missing, sensor type is invalid, calibration date is not a datetime, or if optional voltage and temperature values are out of expected ranges.
        """
        required_keys = ['sensor_type', 'calibration_date']
        
        for key in required_keys:
            assert key in calibration, f"Missing key: {key}"
        
        assert calibration['sensor_type'] in ['o2', 'he'], f"Invalid sensor type: {calibration['sensor_type']}"
        assert isinstance(calibration['calibration_date'], datetime), "Invalid calibration date type"
        
        if 'voltage_reading' in calibration:
            assert 0 <= calibration['voltage_reading'] <= 5.0, "Voltage reading out of range"
        
        if 'temperature' in calibration:
            assert -50 <= calibration['temperature'] <= 100, "Temperature out of range"
    
    @staticmethod
    def assert_settings_structure_valid(settings: Dict[str, Any]):
        """
        Assert that the provided settings dictionary contains all required categories with dictionary values.
        
        Raises an AssertionError if any expected category is missing or not a dictionary.
        """
        expected_categories = ['app', 'display', 'wifi', 'sensors', 'safety', 'units']
        
        for category in expected_categories:
            assert category in settings, f"Missing settings category: {category}"
            assert isinstance(settings[category], dict), f"Invalid type for category {category}"


class MockKivyComponents:
    """Mock Kivy components for testing."""
    
    @staticmethod
    def mock_app():
        """
        Return a mock Kivy App instance with stubbed `build` and `on_start` methods for UI testing.
        """
        app = MagicMock()
        app.build.return_value = MagicMock()
        app.on_start.return_value = None
        return app
    
    @staticmethod
    def mock_screen():
        """
        Return a mocked Kivy screen object with a mock manager attribute for use in UI-related tests.
        
        Returns:
            MagicMock: A mock screen object with a mocked 'manager' attribute.
        """
        screen = MagicMock()
        screen.manager = MagicMock()
        return screen
    
    @staticmethod
    def mock_widget():
        """
        Return a mock Kivy widget object with a mocked `bind` method for use in UI-related tests.
        
        Returns:
            MagicMock: A mock widget instance with a mocked `bind` method.
        """
        widget = MagicMock()
        widget.bind = MagicMock()
        return widget


def create_test_file_structure(base_path: str) -> Dict[str, str]:
    """
    Create a directory structure with sample files for testing file operations.
    
    Creates 'config', 'data', 'logs', and 'backups' subdirectories under the specified base path, and generates sample files in the 'config', 'data', and 'logs' folders. Returns a dictionary mapping folder and file names to their full paths.
    
    Parameters:
        base_path (str): The root directory where the test structure will be created.
    
    Returns:
        Dict[str, str]: A dictionary with keys for each folder and sample file, mapping to their respective paths.
    """
    structure = {
        'config': os.path.join(base_path, 'config'),
        'data': os.path.join(base_path, 'data'),
        'logs': os.path.join(base_path, 'logs'),
        'backups': os.path.join(base_path, 'backups')
    }
    
    # Create directories
    for path in structure.values():
        os.makedirs(path, exist_ok=True)
    
    # Create some test files
    test_files = {
        'config_file': os.path.join(structure['config'], 'test.conf'),
        'data_file': os.path.join(structure['data'], 'test.dat'),
        'log_file': os.path.join(structure['logs'], 'test.log')
    }
    
    for file_path in test_files.values():
        with open(file_path, 'w') as f:
            f.write('test content')
    
    structure.update(test_files)
    return structure


def cleanup_test_file_structure(base_path: str):
    """
    Recursively deletes the test file structure at the specified base path if it exists.
    
    Parameters:
        base_path (str): The root directory of the test file structure to remove.
    """
    if os.path.exists(base_path):
        shutil.rmtree(base_path)
