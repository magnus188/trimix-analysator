from kivy.uix.screenmanager import Screen

class SettingsScreen(Screen):
    def on_enter(self):
        # Initialization when entering the screen
        pass

    def on_setting_press(self, setting_name):
        # Function to handle setting button presses
        print(f"Setting pressed: {setting_name}")
        # TODO: Implement functionality for each setting

    def navigate_back(self):
        # Function to navigate back to home screen
        self.manager.current = 'home'
        print("Navigating back to home")
