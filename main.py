import os
import subprocess
import json

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.window import Window
from kivy.core.text import LabelBase
from kivy.uix.label import Label
from kivy.clock import Clock

# Import database manager and settings adapter
from utils.database_manager import db_manager
from utils.settings_adapter import settings_manager
from utils.calibration_reminder import calibration_reminder

# Ensure your screen classes are imported so Builder knows about them
from screens.analyze import AnalyzeScreen
from widgets.sensor_card import SensorCard
from screens.sensor_detail import SensorDetail
from screens.home import HomeScreen
from screens.settings.settings import SettingsScreen
from screens.settings.calibrate_o2 import CalibrateO2Screen
from screens.settings.wifi_settings import WiFiSettingsScreen
from screens.settings.display_settings import DisplaySettingsScreen
from screens.settings.safety_settings import SafetySettingsScreen
from screens.settings.sensor_settings import SensorSettingsScreen
from widgets.menu_card import MenuCard
from widgets.settings_button import SettingsButton
from widgets.navbar import NavBar
# etc.

Window.fullscreen = 'auto'
Window.rotation = 270


KV_DIR = os.path.dirname(__file__)

class TrimixScreenManager(ScreenManager):
    pass

class TrimixApp(App):
    def build(self):

        LabelBase.register(name="LightFont", fn_regular="assets/fonts/light.ttf")
        LabelBase.register(name="NormalFont", fn_regular="assets/fonts/normal.ttf")
        LabelBase.register(name="BoldFont", fn_regular="assets/fonts/bold.ttf")
       
        Label.font_name = "BoldFont"

        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'sensor_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'menu_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'settings_button.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'navbar.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'home.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'analyze.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'sensor_detail.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'settings.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'calibrate_o2.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'wifi_settings.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'display_settings.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'safety_settings.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings', 'sensor_settings.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'app.kv'))
        # 4) Instantiate and return the manager
        screen_manager = TrimixScreenManager(transition=FadeTransition())
        screen_manager.current = 'home'  # Set the initial screen
        
        # Handle first run setup
        Clock.schedule_once(self.handle_first_run, 2)  # Delay to ensure UI is loaded
        
        # Run migration from JSON to database if needed
        Clock.schedule_once(self.migrate_json_settings, 1)
        
        # Start calibration reminder system
        calibration_reminder.schedule_periodic_check()
        
        # Check for immediate calibration reminders
        Clock.schedule_once(lambda dt: calibration_reminder.show_calibration_reminder(), 5)
        
        return screen_manager
    
    def open_detail(self, sensor_key: str, screen_name: str):
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
            script_path = os.path.join(os.path.dirname(__file__), 'setup_brightness_permissions.sh')
            
            if os.path.exists(script_path):
                # Make script executable
                os.chmod(script_path, 0o755)
                
                # Run the script
                result = subprocess.run(['bash', script_path], 
                                      capture_output=True, text=True, timeout=30)
                
                if result.returncode != 0:
                    pass  # Script failed, but we continue
            else:
                pass  # Script not found, but we continue
                
        except Exception as e:
            pass  # Any error, but we continue without breaking the app
    
    def migrate_json_settings(self, dt):
        """Migrate JSON settings to database if they exist"""
        try:
            json_path = os.path.join(os.path.dirname(__file__), 'utils', 'trimix_settings.json')
            
            if os.path.exists(json_path):
                # Import migration utility
                from utils.migrate_to_database import migrate_json_to_database
                
                # Run migration
                migrate_json_to_database()
                
        except Exception as e:
            pass  # Migration failed, but continue with app startup

if __name__ == '__main__':
    TrimixApp().run()