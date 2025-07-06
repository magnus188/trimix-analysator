"""
Integration tests for main application functionality.
"""

import pytest
import os
from unittest.mock import patch, MagicMock


class TestMainAppIntegration:
    """Integration tests for the main Trimix application."""

    @pytest.mark.integration
    @pytest.mark.ui
    def test_app_import_and_instantiation(self):
        """Test that the main app can be imported and instantiated."""
        from main import TrimixApp
        
        app = TrimixApp()
        assert app is not None
        assert hasattr(app, 'build')
        assert hasattr(app, 'on_start')

    @pytest.mark.integration
    @pytest.mark.ui
    @patch('kivy.app.App.run')
    def test_app_can_be_built(self, mock_run):
        """Test that the app can be built without errors."""
        from main import TrimixApp
        
        app = TrimixApp()
        
        # Build the app (this loads all KV files and creates widgets)
        try:
            root = app.build()
            assert root is not None
        except Exception as e:
            pytest.fail(f"App build failed: {e}")

    @pytest.mark.integration
    @pytest.mark.database
    def test_app_database_integration(self):
        """Test that app correctly integrates with database."""
        from main import TrimixApp
        from utils.database_manager import db_manager
        
        # Ensure database is available
        assert db_manager.connection is not None
        
        # Test that app can access settings through database
        test_value = db_manager.get_setting('app', 'first_run', True)
        assert isinstance(test_value, bool)

    @pytest.mark.integration
    @pytest.mark.sensor
    def test_app_sensor_integration(self):
        """Test that app correctly integrates with sensor interface."""
        from main import TrimixApp
        from utils.sensor_interface import get_sensors, get_readings
        
        # Get sensor interface
        sensors = get_sensors()
        assert sensors is not None
        
        # Test sensor readings
        readings = get_readings()
        assert isinstance(readings, dict)
        assert len(readings) > 0

    @pytest.mark.integration
    def test_screen_navigation_setup(self):
        """Test that screen manager and navigation is properly set up."""
        from main import TrimixApp, TrimixScreenManager
        
        app = TrimixApp()
        
        # Build app to create screen manager
        root = app.build()
        
        # Should have a screen manager
        assert isinstance(root, TrimixScreenManager)

    @pytest.mark.integration
    @pytest.mark.ui
    def test_all_screens_can_be_imported(self):
        """Test that all screen classes can be imported without errors."""
        try:
            from screens.home import HomeScreen
            from screens.analyze import AnalyzeScreen
            from screens.sensor_detail import SensorDetail
            from screens.settings.settings import SettingsScreen
            from screens.settings.calibrate_o2 import CalibrateO2Screen
            from screens.settings.wifi_settings import WiFiSettingsScreen
            from screens.settings.display_settings import DisplaySettingsScreen
            from screens.settings.safety_settings import SafetySettingsScreen
            from screens.settings.sensor_settings import SensorSettingsScreen
            from screens.settings.update_settings import UpdateSettingsScreen
            
            # Verify classes exist
            assert HomeScreen is not None
            assert AnalyzeScreen is not None
            assert SensorDetail is not None
            assert SettingsScreen is not None
            
        except ImportError as e:
            pytest.fail(f"Failed to import screen: {e}")

    @pytest.mark.integration
    @pytest.mark.ui
    def test_all_widgets_can_be_imported(self):
        """Test that all widget classes can be imported without errors."""
        try:
            from widgets.sensor_card import SensorCard
            from widgets.menu_card import MenuCard
            from widgets.settings_button import SettingsButton
            from widgets.navbar import NavBar
            
            # Verify classes exist
            assert SensorCard is not None
            assert MenuCard is not None
            assert SettingsButton is not None
            assert NavBar is not None
            
        except ImportError as e:
            pytest.fail(f"Failed to import widget: {e}")

    @pytest.mark.integration
    def test_kv_files_can_be_loaded(self):
        """Test that KV files can be loaded without syntax errors."""
        from utils.kv_loader import create_kv_loader
        import os
        
        try:
            # Get the project root directory (one level up from tests)
            base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            kv_loader = create_kv_loader(base_path)
            # If this doesn't raise an exception, KV files are valid
            assert kv_loader is not None
        except Exception as e:
            pytest.fail(f"KV loading failed: {e}")

    @pytest.mark.integration
    def test_version_consistency(self):
        """Test that version information is consistent across the app."""
        from version import __version__
        from utils.database_manager import db_manager
        
        # Version should be available
        assert __version__ is not None
        assert len(__version__) > 0
        
        # Database should store version information
        app_version = db_manager.get_setting('app', 'app_version')
        # Might be None on first run, but should be string if set
        if app_version is not None:
            assert isinstance(app_version, str)

    @pytest.mark.integration
    @pytest.mark.slow
    def test_calibration_reminder_integration(self):
        """Test calibration reminder system integration."""
        from utils.calibration_reminder import calibration_reminder
        from utils.database_manager import db_manager
        
        # Test calibration reminder functionality
        assert calibration_reminder is not None
        
        # Test reminder check (should not crash)
        try:
            status = calibration_reminder.check_calibration_due()
            assert isinstance(status, dict)
            assert 'o2_due' in status
            assert 'he_due' in status
        except Exception as e:
            pytest.fail(f"Calibration reminder check failed: {e}")

    @pytest.mark.integration
    def test_settings_migration_compatibility(self):
        """Test that settings migration works correctly."""
        from utils.database_manager import db_manager
        
        # Test that we can access all expected setting categories
        categories = ['app', 'display', 'wifi', 'sensors', 'safety', 'units']
        
        for category in categories:
            settings = db_manager.get_settings_category(category)
            assert isinstance(settings, dict)

    @pytest.mark.integration
    def test_environment_detection_integration(self):
        """Test that environment detection works with app startup."""
        from utils.platform_detector import get_platform_info, is_development_environment
        
        # Platform info should be available
        platform_info = get_platform_info()
        assert isinstance(platform_info, dict)
        assert 'system' in platform_info
        assert 'is_development' in platform_info
        
        # Development environment should be True in tests
        assert is_development_environment() == True

    @pytest.mark.integration
    def test_app_configuration_for_test_environment(self):
        """Test that app is properly configured for test environment."""
        # Environment variables should be set for testing
        assert os.environ.get('TRIMIX_MOCK_SENSORS') == '1'
        assert os.environ.get('TRIMIX_ENVIRONMENT') == 'test'
        
        # This should force development/mock mode
        from utils.platform_detector import is_development_environment
        assert is_development_environment() == True

    @pytest.mark.integration
    @pytest.mark.ui
    @patch('kivy.clock.Clock.schedule_interval')
    @patch('kivy.clock.Clock.schedule_once')
    def test_app_startup_sequence(self, mock_schedule_once, mock_schedule_interval):
        """Test the complete app startup sequence."""
        from main import TrimixApp
        
        app = TrimixApp()
        
        # Build the app
        root = app.build()
        assert root is not None
        
        # Simulate on_start
        try:
            app.on_start()
            # If this completes without exception, startup sequence is working
        except Exception as e:
            pytest.fail(f"App startup sequence failed: {e}")

    @pytest.mark.integration
    def test_font_loading_integration(self):
        """Test that custom fonts can be loaded."""
        import os
        
        # Check that font files exist
        font_dir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'fonts')
        
        if os.path.exists(font_dir):
            # Look for font files
            font_files = [f for f in os.listdir(font_dir) if f.endswith('.ttf')]
            
            # If fonts exist, they should be loadable
            for font_file in font_files:
                font_path = os.path.join(font_dir, font_file)
                assert os.path.exists(font_path)
                assert os.path.getsize(font_path) > 0  # File should not be empty
