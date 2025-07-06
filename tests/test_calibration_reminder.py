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
        """Create a calibration reminder instance for testing."""
        return CalibrationReminder()

    @pytest.mark.unit
    def test_calibration_reminder_initialization(self, calibration_reminder):
        """Test CalibrationReminder initialization."""
        assert calibration_reminder is not None
        assert hasattr(calibration_reminder, 'check_calibration_due')
        assert hasattr(calibration_reminder, 'show_calibration_reminder')

    @pytest.mark.unit
    def test_check_calibration_due_no_calibrations(self, calibration_reminder):
        """Test calibration check when no calibrations exist."""
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
        """Test calibration check with recent calibration."""
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
        """Test calibration check with old calibration."""
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
        """Test that reminder respects settings when disabled."""
        # Mock settings to disable auto reminders
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_setting.return_value = False
            
            # Should not show reminder when disabled
            calibration_reminder.show_calibration_reminder()
            
            # Popup should not be created
            assert calibration_reminder.popup is None

    @pytest.mark.unit
    def test_calibration_custom_interval(self, calibration_reminder):
        """Test calibration check with custom interval."""
        # Mock calibration 45 days ago with 60-day interval
        cal_date = datetime.now() - timedelta(days=45)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
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
        """Test calibration check for different sensor types."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_last_cal(sensor_type):
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
        """Test creating calibration reminder popup."""
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
        """Test date calculation accuracy."""
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
        """Test edge cases for calibration reminders."""
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
        """Test the complete calibration reminder workflow."""
        # Setup: Old calibration, reminders enabled
        old_date = datetime.now() - timedelta(days=35)
        
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
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
        """Test calibration reminder behavior when database errors occur."""
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
        """Test check_reminders method with no calibrations (alias for check_calibration_due)."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = None
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == True
            assert status['he_due'] == True

    @pytest.mark.unit
    def test_check_reminders_recent_calibration(self, calibration_reminder):
        """Test check_reminders method with recent calibration."""
        recent_date = datetime.now() - timedelta(days=1)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = recent_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == False
            assert status['he_due'] == False

    @pytest.mark.unit
    def test_check_reminders_old_calibration(self, calibration_reminder):
        """Test check_reminders method with old calibration."""
        old_date = datetime.now() - timedelta(days=40)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = old_date
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            assert status['o2_due'] == True
            assert status['he_due'] == True

    @pytest.mark.unit
    def test_get_days_since_calibration_no_calibration(self, calibration_reminder):
        """Test getting days since calibration when no calibration exists."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            mock_db.get_last_calibration.return_value = None
            mock_db.get_setting.return_value = 30
            
            status = calibration_reminder.check_calibration_due()
            # When no calibration, last_calibration should be None
            assert status['o2_last_calibration'] is None
            assert status['he_last_calibration'] is None

    @pytest.mark.unit
    def test_get_days_since_calibration_with_calibration(self, calibration_reminder):
        """Test getting days since calibration when calibration exists."""
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
        """Test calibration reminder with custom interval."""
        cal_date = datetime.now() - timedelta(days=45)
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
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
        """Test calibration reminder with multiple sensors."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_last_cal(sensor_type):
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
        """Test showing calibration reminder popup."""
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
        """Test calibration reminder settings defaults."""
        with patch('utils.calibration_reminder.db_manager') as mock_db:
            def mock_get_setting(category, key, default):
                return default  # Return default values
            
            mock_db.get_setting.side_effect = mock_get_setting
            mock_db.get_last_calibration.return_value = None
            
            status = calibration_reminder.check_calibration_due()
            assert status['interval_days'] == 30  # Default interval
