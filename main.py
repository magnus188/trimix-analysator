import os
import subprocess

# Configure Kivy before any imports
from kivy.config import Config

# Set display configuration based on environment
environment = os.environ.get('TRIMIX_ENVIRONMENT', 'production')

if environment == 'production':
    Config.set('graphics', 'fbo', 'hardware')
    Config.set('graphics', 'window', 'sdl2')
    
# Enable virtual keyboard for both environments
Config.set('kivy', 'keyboard_mode', 'systemandmulti')
Config.set('kivy', 'keyboard_layout', 'numeric')  # Try to use numeric layout by default

# Kivy imports
from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.window import Window
from kivy.core.text import LabelBase
from kivy.uix.label import Label
from kivy.clock import Clock
from kivy.logger import Logger

# Set window properties for development
if environment == 'development':
    Window.fullscreen = False  # Disable fullscreen for development
    Window.size = (480, 800)   # Exact RPi display resolution
    from version import __version__
    Window.set_title(f'Trimix Analyzer v{__version__} - Development')
else:
    Window.fullscreen = 'auto'
    Window.rotation = 270

# App imports
from version import __version__, get_build_info
from utils.database_manager import db_manager
from utils.calibration_reminder import calibration_reminder
from utils.kv_loader import create_kv_loader

# Screen imports
from screens.analyze import AnalyzeScreen
from screens.sensor_detail import SensorDetail
from screens.home import HomeScreen
from screens.history import HistoryScreen
from screens.settings.settings import SettingsScreen
from screens.settings.calibrate_o2 import CalibrateO2Screen
from screens.settings.wifi_settings import WiFiSettingsScreen
from screens.settings.display_settings import DisplaySettingsScreen
from screens.settings.safety_settings import SafetySettingsScreen
from screens.settings.sensor_settings import SensorSettingsScreen
from screens.settings.update_settings import UpdateSettingsScreen

# Widget imports
from widgets.sensor_card import SensorCard
from widgets.menu_card import MenuCard
from widgets.settings_button import SettingsButton
from widgets.navbar import NavBar

KV_DIR = os.path.dirname(__file__)

Window.fullscreen = False  # Disable fullscreen for development
Window.size = (480, 800)   # Exact RPi display resolution
Window.minimum_width = 480  # Lock to exact display width
Window.minimum_height = 800  # Lock to exact display height  

class TrimixApp(App):
    def build(self):
        """Initialize the application"""
        Logger.info(f"Starting Trimix Analyzer v{__version__}")
        
# Set window constraints for development
        # if environment == 'development':
        #     Window.fullscreen = False  # Disable fullscreen for development
        #     Window.size = (480, 800)   # Exact RPi display resolution
        #     Window.minimum_width = 480  # Lock to exact display width
        #     Window.minimum_height = 800  # Lock to exact display height       
        # else:
        #     Window.fullscreen = 'auto'
        #     Window.rotation = 270
        # Register fonts and load KV files
        self._register_fonts()
        self._load_kv_files()
        
        # Create screen manager
        screen_manager = ScreenManager(transition=FadeTransition())
        
        # Add screens manually to ensure they exist
        self._add_screens(screen_manager)
        
        # Now set the current screen
        screen_manager.current = 'home'
        
        # Schedule initialization tasks
        Clock.schedule_once(self._initialize_app, 1)
        
        return screen_manager
    
    def _register_fonts(self):
        """Register custom fonts"""
        try:
            LabelBase.register(name="LightFont", fn_regular="assets/fonts/light.ttf")
            LabelBase.register(name="NormalFont", fn_regular="assets/fonts/normal.ttf")
            LabelBase.register(name="BoldFont", fn_regular="assets/fonts/bold.ttf")
            Label.font_name = "BoldFont"
        except Exception as e:
            Logger.warning(f"Failed to register fonts: {e}")
    
    def _load_kv_files(self):
        """Load all KV files"""
        kv_loader = create_kv_loader(os.path.dirname(__file__))
        results = kv_loader.load_all_kv_files()
        
        successful = sum(1 for success in results.values() if success)
        Logger.info(f"KV loading complete - {successful}/{len(results)} files loaded")
    
    def _add_screens(self, screen_manager):
        """Add all screens to the screen manager"""
        screens = [
            HomeScreen(name='home'),
            AnalyzeScreen(name='analyze'),
            SensorDetail(name='sensor_detail'),
            HistoryScreen(name='history'),
            SettingsScreen(name='settings'),
            CalibrateO2Screen(name='calibrate_o2'),
            WiFiSettingsScreen(name='wifi_settings'),
            DisplaySettingsScreen(name='display_settings'),
            SafetySettingsScreen(name='safety_settings'),
            SensorSettingsScreen(name='sensor_settings'),
            UpdateSettingsScreen(name='update_settings'),
        ]
        
        for screen in screens:
            screen_manager.add_widget(screen)
    
    def _initialize_app(self, dt):
        """Initialize app components"""
        # Handle first run setup
        if db_manager.get_setting('app', 'first_run', True):
            self._setup_brightness_permissions()
            db_manager.set_setting('app', 'first_run', False)
        
        # Migrate JSON settings if needed
        self._migrate_json_settings()
        
        # Start calibration reminder system
        calibration_reminder.schedule_periodic_check()
        Clock.schedule_once(lambda dt: calibration_reminder.show_calibration_reminder(), 10)
    
    def open_detail(self, sensor_key: str, screen_name: str):
        """Switch to detail screen for a sensor"""
        detail = self.root.get_screen(screen_name)
        detail.set_sensor(sensor_key)
        self.root.current = screen_name
    
    def _setup_brightness_permissions(self):
        """Setup brightness permissions on first run"""
        try:
            script_path = os.path.join(os.path.dirname(__file__), 'utils', 'setup_brightness_permissions.sh')
            
            if os.path.exists(script_path):
                os.chmod(script_path, 0o755)
                result = subprocess.run(['bash', script_path], 
                                      capture_output=True, text=True, timeout=30)
                
                if result.returncode == 0:
                    Logger.info("Brightness permissions setup completed")
                else:
                    Logger.warning(f"Brightness setup failed: {result.stderr}")
            else:
                Logger.warning("Brightness setup script not found")
                
        except Exception as e:
            Logger.error(f"Error in brightness setup: {e}")
    
    def _migrate_json_settings(self):
        """Migrate legacy JSON settings to database"""
        try:
            json_path = os.path.join(os.path.dirname(__file__), 'utils', 'trimix_settings.json')
            
            if os.path.exists(json_path):
                Logger.info("JSON settings file found but migration module removed. Please migrate manually if needed.")
                Logger.info("JSON settings migration skipped")
            else:
                Logger.info("No JSON settings file found")
                
        except Exception as e:
            Logger.error(f"Migration check failed: {e}")


if __name__ == "__main__":
    TrimixApp().run()