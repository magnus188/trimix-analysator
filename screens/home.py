from kivy.uix.screenmanager import Screen
from kivy.logger import Logger
from widgets.menu_card import MenuCard

class HomeScreen(Screen):
    def on_enter(self):
        """
        Handles actions to perform when the home screen is entered.
        """
        Logger.info("HomeScreen: Entered home screen")

    def navigate_to_screen(self, screen_name):
        """
        Switches to the specified screen by setting the screen manager's current screen.
        
        Parameters:
            screen_name (str): The name of the screen to navigate to.
        """
        try:
            self.manager.current = screen_name
            Logger.info(f"HomeScreen: Navigating to {screen_name}")
        except Exception as e:
            Logger.error(f"HomeScreen: Failed to navigate to {screen_name}: {e}")
    
    def show_power_options(self):
        """
        Displays options for powering off or restarting the application.
        
        Currently, this method only logs the request; the actual power options UI is not yet implemented.
        """
        Logger.info("HomeScreen: Power options requested")
        # TODO: Implement power options popup