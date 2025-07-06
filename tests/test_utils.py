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
        """Update mock data for testing specific scenarios."""
        self.mock_data.update(kwargs)


class TestDataGenerator:
    """Generate test data for various scenarios."""
    
    @staticmethod
    def generate_sensor_readings(count: int = 10) -> List[Dict[str, Any]]:
        """Generate a series of sensor readings."""
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
        """Generate calibration history data."""
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
        """Generate comprehensive settings data."""
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
        """Create a temporary database file."""
        temp_db = tempfile.NamedTemporaryFile(suffix='.db', delete=False)
        temp_db.close()
        return temp_db.name
    
    @staticmethod
    def cleanup_temp_database(db_path: str):
        """Clean up temporary database file."""
        if os.path.exists(db_path):
            os.remove(db_path)
    
    @staticmethod
    def populate_test_data(db_manager, test_data: Dict[str, Any]):
        """Populate database with test data."""
        for category, settings in test_data.items():
            for key, value in settings.items():
                db_manager.set_setting(category, key, value)
    
    @staticmethod
    def verify_database_integrity(db_manager) -> bool:
        """Verify database integrity."""
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
        self.original_env = {}
    
    def setup_test_environment(self):
        """Setup environment for testing."""
        # Store original environment
        test_vars = ['TRIMIX_ENVIRONMENT', 'TRIMIX_MOCK_SENSORS', 'TRIMIX_TEST_DB_PATH']
        for var in test_vars:
            if var in os.environ:
                self.original_env[var] = os.environ[var]
        
        # Set test environment
        os.environ['TRIMIX_ENVIRONMENT'] = 'test'
        os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    
    def cleanup_test_environment(self):
        """Restore original environment."""
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
        """Assert that a sensor reading is valid."""
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
        """Assert that calibration data is valid."""
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
        """Assert that settings structure is valid."""
        expected_categories = ['app', 'display', 'wifi', 'sensors', 'safety', 'units']
        
        for category in expected_categories:
            assert category in settings, f"Missing settings category: {category}"
            assert isinstance(settings[category], dict), f"Invalid type for category {category}"


class MockKivyComponents:
    """Mock Kivy components for testing."""
    
    @staticmethod
    def mock_app():
        """Create a mock Kivy app."""
        app = MagicMock()
        app.build.return_value = MagicMock()
        app.on_start.return_value = None
        return app
    
    @staticmethod
    def mock_screen():
        """Create a mock Kivy screen."""
        screen = MagicMock()
        screen.manager = MagicMock()
        return screen
    
    @staticmethod
    def mock_widget():
        """Create a mock Kivy widget."""
        widget = MagicMock()
        widget.bind = MagicMock()
        return widget


def create_test_file_structure(base_path: str) -> Dict[str, str]:
    """Create a test file structure for testing file operations."""
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
    """Clean up test file structure."""
    if os.path.exists(base_path):
        shutil.rmtree(base_path)
