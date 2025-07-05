from kivy.uix.screenmanager import Screen
from widgets.menu_card import MenuCard  # Import MenuCard

class HomeScreen(Screen):
    def on_enter(self):
        # Initialization when entering the screen
        pass

    def navigate_to_screen(self, screen_name):
        # Function to navigate to another screen
        self.manager.current = screen_name
        print(f"Navigating to {screen_name}")
