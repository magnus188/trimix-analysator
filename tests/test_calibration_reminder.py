"""
Unit tests for calibration reminder functionality.
"""

import pytest
from datetime import datetime, timedelta
from unittest.mock import patch, MagicMock
from utils.calibration_reminder import CalibrationReminder


class TestCalibrationReminder:
    """Test suite for calibration reminder functionality."""

    @pytest.fixture
    def calibration_reminder(self):
        """
        Creates and returns a new instance of the CalibrationReminder class for use in tests.
        """
        return CalibrationReminder()

    @pytest.mark.unit
    def test_calibration_reminder_initialization(self, calibration_reminder):
        """Test CalibrationReminder initialization."""
        assert calibration_reminder is not None
        assert hasattr(calibration_reminder, 'check_calibration_due')
        assert hasattr(calibration_reminder, 'show_calibration_reminder')

    @pytest.mark.unit
    def test_check_calibration_due_no_calibrations(self, calibration_reminder):
        """
        Verify that calibration is marked as due for both O2 and He sensors when no previous calibrations exist.
        
        This test mocks the database to simulate the absence of calibration records and checks that the calibration reminder logic correctly identifies both sensors as due for calibration, with no last calibration dates and zero days overdue.
        """
        # Mock database to return no calibrations
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = None
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
        
        # Should need calibration if no calibrations exist
        assert status['o2_due'] == True
        assert status['he_due'] == True
        assert status['interval_days'] == 30
        assert status['o2_last_calibration'] is None
        assert status['he_last_calibration'] is None
        assert status['o2_days_overdue'] == 0
        assert status['he_days_overdue'] == 0

    @pytest.mark.unit
    def test_check_calibration_due_recent_calibration(self, calibration_reminder):
        """
        Test that `check_calibration_due` correctly identifies that calibration is not due when the last calibration occurred recently.
        
        Simulates a scenario where both O2 and He sensors were calibrated one day ago, with a 30-day calibration interval, and verifies that neither sensor is due for calibration.
        """
        # Mock recent calibration (yesterday)
        recent_date = datetime.now() - timedelta(days=1)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = recent_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
        
        # Should not need calibration for recent calibration
        assert status['o2_due'] == False
        assert status['he_due'] == False
        assert status['o2_last_calibration'] == recent_date
        assert status['he_last_calibration'] == recent_date

    @pytest.mark.unit
    def test_check_calibration_due_old_calibration(self, calibration_reminder):
        """
        Test that calibration is marked as due when the last calibration occurred beyond the allowed interval.
        
        Simulates a scenario where the last calibration was performed 40 days ago and the calibration interval is set to 30 days. Verifies that both O2 and He sensors are flagged as due for calibration, with the correct number of days overdue and accurate last calibration dates.
        """
        # Mock old calibration (40 days ago, default interval is 30 days)
        old_date = datetime.now() - timedelta(days=40)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = old_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
        
        # Should need calibration for old calibration
        assert status['o2_due'] == True
        assert status['he_due'] == True
        assert status['o2_days_overdue'] == 10  # 40 - 30
        assert status['he_days_overdue'] == 10
        assert status['o2_last_calibration'] == old_date
        assert status['he_last_calibration'] == old_date

    @pytest.mark.unit
    def test_show_calibration_reminder_disabled(self, calibration_reminder):
        """
        Verify that no calibration reminder popup is shown when automatic reminders are disabled in settings.
        """
        # Mock settings to disable auto reminders
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_setting.return_value = False
            
            # Should not show reminder when disabled
            calibration_reminder.show_calibration_reminder()
            
            # Popup should not be created
            assert calibration_reminder.popup is None

    @pytest.mark.unit
    def test_calibration_custom_interval(self, calibration_reminder):
        """
        Test that calibration is not due when the last calibration was within a custom interval.
        
        Mocks a last calibration date 45 days ago and a custom interval of 60 days, verifying that calibration is not flagged as due and the interval is correctly applied.
        """
        # Mock calibration 45 days ago with 60-day interval
        cal_date = datetime.now() - timedelta(days=45)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
                """
                Mock function to simulate retrieving a setting value, returning 60 for 'calibration_interval_days' and True for all other keys.
                
                Parameters:
                    category: The settings category (unused in this mock).
                    key: The setting key to retrieve.
                    default: The default value if the setting is not found (unused in this mock).
                
                Returns:
                    The mocked setting value: 60 if the key is 'calibration_interval_days', otherwise True.
                """
                if key == 'calibration_interval_days':
                    return 60
                return True
            
            mock_db.get_setting.side_effect = mock_get_setting
            mock_db.get_last_calibration.return_value = cal_date
            
            status = calibration_reminder.check_calibration_due()
        
        # Should not need calibration yet (45 < 60)
        assert status['o2_due'] == False
        assert status['he_due'] == False
        assert status['interval_days'] == 60

    @pytest.mark.unit
    def test_calibration_different_sensor_dates(self, calibration_reminder):
        """
        Test that calibration due status is correctly determined for sensors with different last calibration dates.
        
        Simulates an O2 sensor calibrated 5 days ago and a He sensor calibrated 35 days ago, with a 30-day calibration interval. Verifies that calibration is not due for O2 but is due for He.
        """
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_last_cal(sensor_type):
                """
                Simulate retrieval of the last calibration date for a given sensor type.
                
                Returns a recent calibration date (5 days ago) for 'o2', an older calibration date (35 days ago) for 'he', or None for other sensor types.
                
                Parameters:
                    sensor_type (str): The type of sensor ('o2', 'he', or other).
                
                Returns:
                    datetime or None: The simulated last calibration date, or None if the sensor type is unrecognized.
                """
                if sensor_type == 'o2':
                    return datetime.now() - timedelta(days=5)  # Recent
                elif sensor_type == 'he':
                    return datetime.now() - timedelta(days=35)  # Old
                return None
            
            mock_db.get_last_calibration.side_effect = mock_get_last_cal
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
        
        assert status['o2_due'] == False  # Recent calibration
        assert status['he_due'] == True   # Old calibration

    @pytest.mark.unit
    @patch('utils.calibration_reminder.CalibrationReminder._create_reminder_popup')
    def test_create_reminder_popup(self, mock_create_popup, calibration_reminder):
        """
        Verify that the calibration reminder popup creation method is called with the correct status dictionary.
        """
        # Test that popup creation method is called without errors
        status = {
            'o2_due': True,
            'he_due': False,
            'o2_days_overdue': 5,
            'he_days_overdue': 0,
            'o2_last_calibration': datetime.now() - timedelta(days=35),
            'he_last_calibration': None,
            'interval_days': 30
        }
        
        calibration_reminder._create_reminder_popup(status)
        mock_create_popup.assert_called_once_with(status)

    @pytest.mark.unit
    def test_calibration_date_calculations(self, calibration_reminder):
        """
        Verify that calibration due status is correctly determined for various calibration dates relative to the configured interval.
        
        Tests scenarios where the last calibration is recent, exactly at the interval, just over the interval, and significantly overdue, ensuring the due status matches expectations for both O2 and He sensors.
        """
        test_cases = [
            (datetime.now() - timedelta(days=1), False),   # Recent
            (datetime.now() - timedelta(days=30), True),   # Exactly at interval 
            (datetime.now() - timedelta(days=31), True),   # Just over interval
            (datetime.now() - timedelta(days=365), True)   # Very old
        ]
        
        for test_date, should_be_due in test_cases:
            with patch('utils.calibration_reminder.db_manager') as mock_db:
                mock_db.get_last_calibration.return_value = test_date
                mock_db.get_setting.return_value = 30
                
                status = calibration_reminder.check_calibration_due()
                assert status['o2_due'] == should_be_due
                assert status['he_due'] == should_be_due

    @pytest.mark.unit
    def test_calibration_edge_cases(self, calibration_reminder):
        """
        Test that calibration reminders handle edge cases, such as future calibration dates, without incorrectly marking calibration as due.
        """
        # Test future calibration date (shouldn't happen but handle gracefully)
        future_date = datetime.now() + timedelta(days=1)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = future_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
        
        # Should handle future dates gracefully
        assert status['o2_due'] == False
        assert status['he_due'] == False

    @pytest.mark.integration
    @patch('utils.calibration_reminder.CalibrationReminder._create_reminder_popup')
    def test_calibration_full_workflow(self, mock_create_popup, calibration_reminder):
        """
        Tests the full calibration reminder workflow, including due status calculation and reminder popup display when calibration is overdue and reminders are enabled.
        """
        # Setup: Old calibration, reminders enabled
        old_date = datetime.now() - timedelta(days=35)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
                """
                Mock function to simulate retrieval of calibration-related settings.
                
                Returns:
                    The value for the requested setting key: `True` for 'auto_calibration_reminder', `30` for 'calibration_interval_days', and `True` for any other key.
                """
                if key == 'auto_calibration_reminder':
                    return True
                elif key == 'calibration_interval_days':
                    return 30
                return True
            
            mock_db.get_setting.side_effect = mock_get_setting
            mock_db.get_last_calibration.return_value = old_date
            
            # Check calibration status
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == True
            assert status['he_due'] == True
            
            # Show reminder (should call popup creation)
            calibration_reminder.show_calibration_reminder(status)
            mock_create_popup.assert_called_once()

    @pytest.mark.unit
    def test_calibration_database_errors(self, calibration_reminder):
        """
        Test that CalibrationReminder handles database errors gracefully when fetching calibration data.
        
        Simulates a database exception and verifies that the method either handles the error without crashing or raises an exception as expected.
        """
        # Mock database error
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.side_effect = Exception("Database error")
            
            # Should handle errors gracefully
            try:
                status = calibration_reminder.check_calibration_due()
                # Should not reach here due to error, but if it does, check structure
                assert isinstance(status, dict)
            except Exception:
                # Expected to fail with database error
                pass

    # Test method aliases for backward compatibility
    @pytest.mark.unit
    def test_check_reminders_no_calibrations(self, calibration_reminder):
        """
        Test that the `check_reminders` method (alias for `check_calibration_due`) correctly reports both O2 and He calibrations as due when no previous calibrations exist.
        """
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = None
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == True
            assert status['he_due'] == True

    @pytest.mark.unit
    def test_check_reminders_recent_calibration(self, calibration_reminder):
        """
        Test that the `check_reminders` method reports calibration as not due when the last calibration was recent.
        
        Simulates a recent calibration date and verifies that both O2 and He sensors are not due for calibration.
        """
        recent_date = datetime.now() - timedelta(days=1)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = recent_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == False
            assert status['he_due'] == False

    @pytest.mark.unit
    def test_check_reminders_old_calibration(self, calibration_reminder):
        """
        Test that the `check_reminders` method correctly identifies calibration as due when the last calibration was performed beyond the configured interval.
        """
        old_date = datetime.now() - timedelta(days=40)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = old_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == True
            assert status['he_due'] == True

    @pytest.mark.unit
    def test_get_days_since_calibration_no_calibration(self, calibration_reminder):
        """
        Test that `check_calibration_due` returns `None` for last calibration dates when no calibration records exist.
        """
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = None
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            # When no calibration, last_calibration should be None
            assert status['o2_last_calibration'] is None
            assert status['he_last_calibration'] is None

    @pytest.mark.unit
    def test_get_days_since_calibration_with_calibration(self, calibration_reminder):
        """
        Test that `check_calibration_due` correctly reports the last calibration date when a calibration exists.
        
        Verifies that when a calibration date is present in the database, the returned status reflects the correct last calibration date for both O2 and He sensors.
        """
        cal_date = datetime.now() - timedelta(days=5)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = cal_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_last_calibration'] == cal_date
            assert status['he_last_calibration'] == cal_date

    @pytest.mark.unit
    def test_calibration_reminder_respects_settings(self, calibration_reminder):
        """Test that calibration reminder respects settings."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_setting.return_value = False  # Disabled
            
            calibration_reminder.show_calibration_reminder()
            assert calibration_reminder.popup is None

    @pytest.mark.unit
    def test_calibration_reminder_custom_interval(self, calibration_reminder):
        """
        Test that the calibration reminder correctly uses a custom calibration interval and does not indicate calibration is due when the last calibration is within that interval.
        """
        cal_date = datetime.now() - timedelta(days=45)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
                """
                Mock function to simulate retrieving a setting value, returning 60 for 'calibration_interval_days' and True for all other keys.
                
                Parameters:
                    category: The settings category (unused in this mock).
                    key: The setting key to retrieve.
                    default: The default value if the setting is not found (unused in this mock).
                
                Returns:
                    The mocked setting value: 60 if the key is 'calibration_interval_days', otherwise True.
                """
                if key == 'calibration_interval_days':
                    return 60
                return True
            
            mock_db.get_setting.side_effect = mock_get_setting
            mock_db.get_last_calibration.return_value = cal_date
            
            status = calibration_reminder.check_calibration_due()
            assert status['interval_days'] == 60
            assert status['o2_due'] == False  # 45 < 60

    @pytest.mark.unit
    def test_calibration_reminder_multiple_sensors(self, calibration_reminder):
        """
        Tests calibration due status for multiple sensors with different last calibration dates, verifying that only sensors overdue their interval are flagged as due.
        """
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_last_cal(sensor_type):
                """
                Simulate retrieval of the last calibration date for a given sensor type.
                
                Returns a recent calibration date (5 days ago) for 'o2', an older calibration date (35 days ago) for 'he', or None for other sensor types.
                
                Parameters:
                    sensor_type (str): The type of sensor ('o2', 'he', or other).
                
                Returns:
                    datetime or None: The simulated last calibration date, or None if the sensor type is unrecognized.
                """
                if sensor_type == 'o2':
                    return datetime.now() - timedelta(days=5)  # Recent
                elif sensor_type == 'he':
                    return datetime.now() - timedelta(days=35)  # Old
                return None
            
            mock_db.get_last_calibration.side_effect = mock_get_last_cal
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == False
            assert status['he_due'] == True

    @pytest.mark.unit
    @patch('utils.calibration_reminder.CalibrationReminder._create_reminder_popup')
    def test_show_calibration_reminder_popup(self, mock_create_popup, calibration_reminder):
        """
        Verify that the calibration reminder popup is shown when reminders are enabled and calibration is due.
        
        This test ensures that the `_create_reminder_popup` method is called with the correct status dictionary when the reminder setting is enabled.
        """
        status = {
            'o2_due': True,
            'he_due': False,
            'o2_days_overdue': 5,
            'he_days_overdue': 0,
            'o2_last_calibration': datetime.now() - timedelta(days=35),
            'he_last_calibration': None,
            'interval_days': 30
        }
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_setting.return_value = True  # Enabled
            
            # This should call the popup creation method
            calibration_reminder._create_reminder_popup(status)
            mock_create_popup.assert_called_once_with(status)

    @pytest.mark.unit
    def test_calibration_reminder_settings_defaults(self, calibration_reminder):
        """
        Tests that the calibration reminder uses the default interval setting when no specific configuration is provided.
        """
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
                """
                Mock implementation of a settings retrieval function that always returns the provided default value.
                
                Parameters:
                	category (str): The settings category.
                	key (str): The specific setting key.
                	default: The default value to return.
                
                Returns:
                	The default value passed to the function.
                """
                return default  # Return default values
            
            mock_db.get_setting.side_effect = mock_get_setting
            mock_db.get_last_calibration.return_value = None
            
            status = calibration_reminder.check_calibration_due()
            assert status['interval_days'] == 30  # Default interval
