from kivy.uix.screenmanager import Screen

class SettingsScreen(Screen):
    def on_enter(self):
        # Initialization when entering the screen
        pass

    def on_setting_press(self, setting_name):
        # Function to handle setting button presses
        print(f"Setting pressed: {setting_name}")
        
        # Handle specific settings
        if setting_name == 'calibrate_o2':
            self.manager.current = 'calibrate_o2'
        elif setting_name == 'wifi_settings':
            self.manager.current = 'wifi_settings'
        elif setting_name == 'display_settings':
            self.manager.current = 'display_settings'
        else:
            # TODO: Implement functionality for other settings
            pass

    def navigate_back(self):
        # Function to navigate back to home screen
        self.manager.current = 'home'
        print("Navigating back to home")
