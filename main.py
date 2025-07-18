import os
import subprocess

# Configure Kivy before any imports
from kivy.config import Config

# Set display configuration based on environment
environment = os.environ.get('TRIMIX_ENVIRONMENT', 'production')

# Configure for RPi display - portrait mode (rotate landscape to portrait)
Config.set('graphics', 'resizable', '0') 
Config.set('graphics', 'width', '480')   # Portrait width
Config.set('graphics', 'height', '800')  # Portrait height
Config.set('graphics', 'rotation', '270') # Rotate 90 degrees to get portrait from landscape

if environment == 'production':
    Config.set('graphics', 'fbo', 'hardware')
    Config.set('graphics', 'window', 'sdl2')  # Simplified - just use sdl2

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition, ScreenManagerException
from kivy.core.window import Window
from kivy.core.text import LabelBase
from kivy.uix.label import Label
from kivy.clock import Clock
from kivy.logger import Logger

# Set window properties based on environment
environment = os.environ.get('TRIMIX_ENVIRONMENT', 'production')

if environment == 'development':
    # Development mode: windowed for easier debugging
    Window.fullscreen = False
    from version import __version__
    Window.set_title(f'Trimix Analyzer v{__version__} - RPi Display Emulation (480x800)')
else:
    # Production mode: fullscreen on RPi display
    try:
        Window.fullscreen = 'auto'  # Use auto to let Kivy decide the best fullscreen mode
    except Exception as e:
        Logger.warning(f"Could not set fullscreen mode: {e}")
        # Fallback: try to set fullscreen to True
        try:
            Window.fullscreen = True
        except Exception as e2:
            Logger.warning(f"Could not set fullscreen fallback: {e2}")
            # Last resort: just continue without fullscreen

# Import version information
from version import __version__, get_build_info

# Import database manager directly - no need for adapter
from utils.database_manager import db_manager
from utils.calibration_reminder import calibration_reminder
from utils.kv_loader import create_kv_loader

# Import screen classes so they're available for KV files
from screens.analyze import AnalyzeScreen
from screens.sensor_detail import SensorDetail
from screens.home import HomeScreen
from screens.settings.settings import SettingsScreen
from screens.settings.calibrate_o2 import CalibrateO2Screen
from screens.settings.wifi_settings import WiFiSettingsScreen
from screens.settings.display_settings import DisplaySettingsScreen
from screens.settings.safety_settings import SafetySettingsScreen
from screens.settings.sensor_settings import SensorSettingsScreen
from screens.settings.update_settings import UpdateSettingsScreen

# Import widget classes so they're available for KV files
from widgets.sensor_card import SensorCard
from widgets.menu_card import MenuCard
from widgets.settings_button import SettingsButton
from widgets.navbar import NavBar

KV_DIR = os.path.dirname(__file__)

class TrimixScreenManager(ScreenManager):
    """Enhanced screen manager with better navigation tracking"""
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.previous_screen = 'home'  # Track previous screen for back navigation
    
    def transition_to(self, screen_name: str):
        """Navigate to screen while tracking history"""
        if hasattr(self, 'current') and self.current:
            self.previous_screen = self.current
        
        self.current = screen_name
        Logger.info(f"TrimixApp: Navigated to {screen_name}")

class TrimixApp(App):
    def build(self):
        # Log version information
        """
        Initializes and configures the application, returning the root screen manager.
        
        Sets up logging, registers custom fonts, loads KV files, creates the screen manager with a fade transition, and schedules initialization tasks before returning the main screen manager as the app's root widget.
        """
        Logger.info(f"TrimixApp: Starting Trimix Analyzer v{__version__}")
        build_info = get_build_info()
        Logger.info(f"TrimixApp: Platform: {build_info['platform']}")
        Logger.info(f"TrimixApp: Architecture: {build_info['architecture']}")
        
        # Register fonts
        self._register_fonts()
        
        # Load all KV files automatically
        self._load_kv_files()
        
        # Create screen manager
        screen_manager = TrimixScreenManager(transition=FadeTransition())
        screen_manager.current = 'home'
        
        # Schedule initialization tasks
        self._schedule_initialization_tasks()
        
        return screen_manager
    
    def _register_fonts(self):
        """Register custom fonts"""
        try:
            LabelBase.register(name="LightFont", fn_regular="assets/fonts/light.ttf")
            LabelBase.register(name="NormalFont", fn_regular="assets/fonts/normal.ttf")
            LabelBase.register(name="BoldFont", fn_regular="assets/fonts/bold.ttf")
            Label.font_name = "BoldFont"
        except Exception as e:
            Logger.warning(f"TrimixApp: Failed to register fonts: {e}")
    
    def _load_kv_files(self):
        """Automatically load all KV files using the KV loader"""
        kv_loader = create_kv_loader(KV_DIR)
        results = kv_loader.load_all_kv_files()
        
        # Log summary
        successful_count = sum(1 for success in results.values() if success)
        total_count = len(results)
        Logger.info(f"TrimixApp: KV loading complete - {successful_count}/{total_count} files loaded")
    
    def _schedule_initialization_tasks(self):
        """
        Schedules initial application initialization tasks, including first-run handling, settings migration, calibration reminders, and a startup update check.
        """
        Clock.schedule_once(self.handle_first_run, 2)
        Clock.schedule_once(self.migrate_json_settings, 1)
        
        # Start calibration reminder system
        calibration_reminder.schedule_periodic_check()
        # Delay the calibration reminder check to avoid startup congestion
        Clock.schedule_once(lambda dt: calibration_reminder.show_calibration_reminder(), 10)
        
        # Check for updates on startup (if auto-updates enabled) - TEMPORARILY DISABLED
        # Clock.schedule_once(self.startup_update_check, 3)
    
    def open_detail(self, sensor_key: str, screen_name: str):
            """
            Switches to a detail screen and sets the specified sensor for display.
            
            Parameters:
                sensor_key (str): The key identifying the sensor to display details for.
                screen_name (str): The name of the screen to navigate to.
            """
            detail = self.root.get_screen(screen_name)
            detail.set_sensor(sensor_key)
            self.root.current = screen_name
    
    def handle_first_run(self, dt):
        """Handle first run setup tasks"""
        if db_manager.get_setting('app', 'first_run', True):
            # Run the brightness permissions setup script
            self.setup_brightness_permissions()
            
            # Mark first run as complete
            db_manager.set_setting('app', 'first_run', False)
    
    def setup_brightness_permissions(self):
        """Run the brightness permissions setup script"""
        try:
            script_path = os.path.join(os.path.dirname(__file__), 'utils', 'setup_brightness_permissions.sh')
            
            if os.path.exists(script_path):
                # Make script executable
                os.chmod(script_path, 0o755)  # nosec B103 - intentional script permissions
                
                # Run the script
                result = subprocess.run(['bash', script_path], 
                                      capture_output=True, text=True, timeout=30)
                
                if result.returncode != 0:
                    Logger.warning(f"TrimixApp: Brightness setup script failed: {result.stderr}")
                else:
                    Logger.info("TrimixApp: Brightness permissions setup completed")
            else:
                Logger.warning(f"TrimixApp: Brightness setup script not found at {script_path}")
                
        except subprocess.TimeoutExpired:
            Logger.error("TrimixApp: Brightness setup script timed out")
        except Exception as e:
            Logger.error(f"TrimixApp: Error in brightness setup: {e}")
    
    def migrate_json_settings(self, dt):
        """
        Migrates legacy JSON settings to the database if a settings file is present.
        
        If a `trimix_settings.json` file exists in the `utils` directory, attempts to migrate its contents to the database using a migration utility. Logs the outcome of the migration or the absence of the JSON file. Any exceptions during migration are caught and logged.
        """
        try:
            json_path = os.path.join(os.path.dirname(__file__), 'utils', 'trimix_settings.json')
            
            if os.path.exists(json_path):
                # Import migration utility
                from utils.migrate_to_database import migrate_json_to_database
                
                # Run migration
                success = migrate_json_to_database()
                if success:
                    Logger.info("TrimixApp: JSON settings migration completed successfully")
                else:
                    Logger.warning("TrimixApp: JSON settings migration failed")
            else:
                Logger.info("TrimixApp: No JSON settings file found, starting with clean database")
                
        except Exception as e:
            Logger.error(f"TrimixApp: Migration failed: {e}")
    
    def startup_update_check(self, dt):
        """
        Checks for available application updates at startup if auto-update is enabled in settings.
        
        This method queries the database to determine if automatic update checks are enabled. If so, it initializes the update manager, binds event handlers for update availability and completion, and initiates an update check. Logs the process and handles exceptions gracefully.
        """
        try:
            # Check if auto-updates are enabled
            auto_check_enabled = db_manager.get_setting('updates', 'auto_check', True)
            
            if auto_check_enabled:
                Logger.info("TrimixApp: Auto-updates enabled, checking for updates on startup")
                
                # Import and initialize update manager
                from utils.update_manager import get_update_manager
                update_manager = get_update_manager()
                
                # Bind to update events to handle results
                update_manager.bind(on_update_available=self.on_startup_update_available)
                update_manager.bind(on_update_check_complete=self.on_startup_update_check_complete)
                
                # Perform a simple update check (disabled for now to test performance)
                # update_manager.check_for_updates()
            else:
                Logger.info("TrimixApp: Auto-updates disabled, skipping startup update check")
                
        except Exception as e:
            Logger.error(f"TrimixApp: Startup update check failed: {e}")
    
    def on_startup_update_available(self, update_manager, update_info):
        """
        Handles notification when an application update is available during startup.
        
        Logs the available update version and provides a non-intrusive notification for the user to check update details in the settings.
        """
        version = update_info.get('version', 'Unknown')
        Logger.info(f"TrimixApp: Update available on startup: {version}")
        
        # Show a notification in the logs - the user can check updates manually in settings
        # We don't want to interrupt the startup flow with popups
        Logger.info("TrimixApp: Update available! Check Settings → Update Settings for details")
    
    def on_startup_update_check_complete(self, update_manager, update_available, update_info):
        """
        Handles the completion of the startup update check by logging the result and unbinding temporary event handlers to prevent memory leaks.
        
        Parameters:
            update_manager: The update manager instance used for checking updates.
            update_available (bool): Indicates whether a new update is available.
            update_info: Additional information about the update, if available.
        """
        if update_available:
            Logger.info("TrimixApp: Startup update check found new version available")
        else:
            Logger.info("TrimixApp: Startup update check - no updates available")
        
        # Unbind the temporary event handlers to avoid memory leaks
        try:
            update_manager.unbind(on_update_available=self.on_startup_update_available)
            update_manager.unbind(on_update_check_complete=self.on_startup_update_check_complete)
        except:
            pass  # In case unbind fails, just continue


if __name__ == "__main__":
    TrimixApp().run()