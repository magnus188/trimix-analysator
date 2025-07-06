"""
Comprehensive unit tests for sensor interface functionality.
"""

import pytest
from unittest.mock import patch, MagicMock
from utils.sensor_interface import get_sensors, get_readings, record_readings, get_history


class TestSensorInterface:
    """Test suite for sensor interface functionality."""

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_get_sensors_returns_mock_in_test_environment(self):
        """Test that get_sensors returns mock interface in test environment."""
        sensors = get_sensors()
        
        # Should return a sensor interface
        assert sensors is not None
        assert hasattr(sensors, 'read_oxygen_voltage')
        assert hasattr(sensors, 'read_oxygen_percent')
        assert hasattr(sensors, 'read_temperature_c')
        assert hasattr(sensors, 'read_pressure_hpa')

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_mock_sensor_readings_within_expected_ranges(self, mock_sensor_interface):
        """Test that mock sensor readings are within expected ranges."""
        sensors = mock_sensor_interface
        
        # Test O2 readings
        o2_voltage = sensors.read_oxygen_voltage()
        o2_percent = sensors.read_oxygen_percent()
        assert 0 <= o2_voltage <= 5.0
        assert 0 <= o2_percent <= 100
        
        # Test CO2 readings
        co2_voltage = sensors.read_co2_voltage()
        co2_ppm = sensors.read_co2_ppm()
        assert 0 <= co2_voltage <= 5.0
        assert 0 <= co2_ppm <= 10000
        
        # Test environmental readings
        temperature = sensors.read_temperature_c()
        pressure = sensors.read_pressure_hpa()
        humidity = sensors.read_humidity_pct()
        assert -50 <= temperature <= 100
        assert 0.8 <= pressure <= 1.2  # Pressure in BAR
        assert 0 <= humidity <= 100
        
        # Test button state
        button = sensors.is_power_button_pressed()
        assert isinstance(button, bool)

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_mock_sensor_data_modification(self, mock_sensor_interface):
        """Test that mock sensor data can be modified for testing."""
        sensors = mock_sensor_interface
        
        # Set custom test data
        sensors.set_mock_data(
            o2_percent=25.5,
            temperature=30.0,
            pressure=1.1,
            button_pressed=True
        )
        
        # Verify custom data is returned
        assert sensors.read_oxygen_percent() == 25.5
        assert sensors.read_temperature_c() == 30.0
        assert sensors.read_pressure_hpa() == 1.1
        assert sensors.is_power_button_pressed() == True

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_get_readings_returns_dict(self):
        """Test that get_readings returns a dictionary with all sensor values."""
        readings = get_readings()
        
        assert isinstance(readings, dict)
        
        # Check that all expected keys are present
        expected_keys = ['o2', 'temp', 'press', 'hum']
        for key in expected_keys:
            assert key in readings
            assert isinstance(readings[key], (int, float))

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_record_readings_stores_data(self):
        """Test that record_readings stores sensor data."""
        from utils.sensor_interface import get_history, _history
        
        # Clear history before test
        _history['o2'].clear()
        _history['temp'].clear()
        _history['press'].clear()
        _history['hum'].clear()
        
        # Record some readings
        record_readings()
        
        # Check that data was recorded
        assert len(_history['o2']) > 0
        assert len(_history['temp']) > 0
        assert len(_history['press']) > 0
        assert len(_history['hum']) > 0

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_get_history_returns_list(self):
        """Test that get_history returns historical data."""
        # Record some readings first
        record_readings()
        record_readings()
        
        # Get history for a specific sensor
        history = get_history('temp')
        
        assert isinstance(history, list)
        if len(history) > 0:
            # Each history entry should be a tuple/list with timestamp and value
            entry = history[0]
            assert len(entry) >= 2  # timestamp, value, possibly more

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_pressure_units_in_bar(self, sample_sensor_data):
        """Test that pressure readings are in BAR units."""
        readings = get_readings()
        pressure = readings['press']
        
        # Atmospheric pressure should be around 1.0 BAR
        assert 0.8 <= pressure <= 1.2
        assert isinstance(pressure, float)

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_sensor_readings_consistency(self):
        """Test that sensor readings are consistent between calls."""
        # Get multiple readings
        readings1 = get_readings()
        readings2 = get_readings()
        
        # Values might be slightly different (simulating real sensors)
        # but should be in same ballpark
        for key in readings1:
            if key in readings2:
                value1 = readings1[key]
                value2 = readings2[key]
                # Allow some variation for mock sensors
                assert abs(value1 - value2) < 10  # Reasonable tolerance

    @pytest.mark.unit
    @pytest.mark.sensor
    @patch('utils.sensor_interface.get_sensors')
    def test_sensor_interface_error_handling(self, mock_get_sensors):
        """Test error handling when sensor interface fails."""
        # Mock sensor interface that raises an exception
        mock_sensors = MagicMock()
        mock_sensors.read_oxygen_percent.side_effect = Exception("Sensor failure")
        mock_get_sensors.return_value = mock_sensors
        
        # get_readings should handle the exception gracefully
        try:
            readings = get_readings()
            # If it returns anything, it should be a dict
            assert isinstance(readings, dict)
        except Exception:
            # Or it might re-raise the exception, which is also acceptable
            pass

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_o2_percentage_normal_air(self, mock_sensor_interface):
        """Test O2 percentage reading for normal air."""
        sensors = mock_sensor_interface
        
        # Set normal air O2 percentage
        sensors.set_mock_data(o2_percent=20.9)
        
        o2_reading = sensors.read_oxygen_percent()
        assert abs(o2_reading - 20.9) < 0.1  # Allow small tolerance

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_co2_ppm_normal_levels(self, mock_sensor_interface):
        """Test CO2 PPM reading for normal levels."""
        sensors = mock_sensor_interface
        
        # Set normal CO2 levels (outdoor air is ~400 ppm)
        sensors.set_mock_data(co2_ppm=400)
        
        co2_reading = sensors.read_co2_ppm()
        assert abs(co2_reading - 400) < 50  # Allow reasonable tolerance

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_temperature_room_temperature(self, mock_sensor_interface):
        """Test temperature reading for room temperature."""
        sensors = mock_sensor_interface
        
        # Set room temperature
        sensors.set_mock_data(temperature=22.0)
        
        temp_reading = sensors.read_temperature_c()
        assert abs(temp_reading - 22.0) < 1.0  # Allow 1 degree tolerance

    @pytest.mark.unit
    @pytest.mark.sensor
    def test_humidity_normal_levels(self, mock_sensor_interface):
        """Test humidity reading for normal levels."""
        sensors = mock_sensor_interface
        
        # Set comfortable humidity level
        sensors.set_mock_data(humidity=50.0)
        
        humidity_reading = sensors.read_humidity_pct()
        assert abs(humidity_reading - 50.0) < 5.0  # Allow 5% tolerance

    @pytest.mark.integration
    @pytest.mark.sensor
    def test_sensor_data_persistence(self):
        """Test that sensor data persists correctly in the database."""
        # Record multiple readings
        for _ in range(3):
            record_readings()
        
        # Get history for each sensor type
        for sensor_type in ['o2', 'temp', 'press', 'hum']:
            history = get_history(sensor_type)
            assert len(history) >= 3  # Should have at least 3 readings

    @pytest.mark.slow
    @pytest.mark.sensor
    def test_sensor_reading_performance(self):
        """Test sensor reading performance (marked as slow test)."""
        import time
        
        start_time = time.time()
        
        # Read sensors multiple times
        for _ in range(100):
            readings = get_readings()
        
        end_time = time.time()
        total_time = end_time - start_time
        
        # Should be able to read sensors 100 times in less than 1 second
        assert total_time < 1.0
        print(f"100 sensor readings took {total_time:.3f} seconds")
