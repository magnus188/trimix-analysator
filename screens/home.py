from kivy.uix.screenmanager import Screen
from kivy.logger import Logger
from widgets.menu_card import MenuCard

class HomeScreen(Screen):
    def on_enter(self):
        """Called when entering the home screen"""
        Logger.info("HomeScreen: Entered home screen")

    def navigate_to_screen(self, screen_name):
        """Navigate to another screen"""
        try:
            self.manager.current = screen_name
            Logger.info(f"HomeScreen: Navigating to {screen_name}")
        except Exception as e:
            Logger.error(f"HomeScreen: Failed to navigate to {screen_name}: {e}")
    
    def show_power_options(self):
        """Show power off/restart options"""
        Logger.info("HomeScreen: Power options requested")
        # TODO: Implement power options popup