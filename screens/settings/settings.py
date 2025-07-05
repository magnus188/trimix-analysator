from kivy.uix.screenmanager import Screen
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from utils.settings_manager import settings_manager

class SettingsScreen(Screen):
    def on_enter(self):
        # Initialization when entering the screen
        pass
    
    def navigate_back(self):
        """Navigate back to home screen"""
        self.manager.current = 'home'

    def on_setting_press(self, setting_name):
        # Function to handle setting button presses
        
        # Handle specific settings
        if setting_name == 'calibrate_o2':
            self.manager.current = 'calibrate_o2'
        elif setting_name == 'wifi_settings':
            self.manager.current = 'wifi_settings'
        elif setting_name == 'display_settings':
            self.manager.current = 'display_settings'
        elif setting_name == 'safety_settings':
            self.manager.current = 'safety_settings'
        elif setting_name == 'sensor_settings':
            self.manager.current = 'sensor_settings'
        elif setting_name == 'factory_reset':
            self.show_factory_reset_confirmation()
        else:
            # TODO: Implement functionality for other settings
            pass
    
    def navigate_back(self):
        # Function to navigate back to home screen
        self.manager.current = 'home'

    def show_factory_reset_confirmation(self):
        """Show factory reset confirmation dialog"""
        content = BoxLayout(orientation='vertical', spacing='20dp', padding='20dp')
        
        content.add_widget(Label(
            text='Factory Reset',
            font_size='24sp',
            size_hint_y=None,
            height='40dp',
            color=[1, 0.2, 0.2, 1]
        ))
        
        content.add_widget(Label(
            text='This will reset ALL settings to factory defaults:\\n\\n• Display settings\\n• WiFi settings\\n• Safety limits\\n• Calibration data\\n• All preferences\\n\\nThis action cannot be undone!',
            text_size=(None, None),
            halign='center',
            font_size='16sp'
        ))
        
        buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='60dp')
        
        cancel_btn = Button(text='Cancel', size_hint_x=0.5)
        reset_btn = Button(
            text='FACTORY RESET',
            size_hint_x=0.5,
            background_color=[0.8, 0.2, 0.2, 1],
            color=[1, 1, 1, 1]
        )
        
        buttons.add_widget(cancel_btn)
        buttons.add_widget(reset_btn)
        content.add_widget(buttons)
        
        popup = Popup(
            title='WARNING: Factory Reset',
            content=content,
            size_hint=(0.8, 0.7),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        reset_btn.bind(on_press=lambda x: self._perform_factory_reset(popup))
        
        popup.open()
    
    def _perform_factory_reset(self, popup):
        """Perform the actual factory reset"""
        popup.dismiss()
        
        # Perform factory reset
        success = settings_manager.factory_reset()
        
        if success:
            # Show success message
            self._show_factory_reset_result("Factory reset completed successfully!", True)
        else:
            # Show error message
            self._show_factory_reset_result("Factory reset failed. Please try again.", False)
    
    def _show_factory_reset_result(self, message: str, success: bool):
        """Show factory reset result"""
        content = Label(text=message, text_size=(None, None))
        
        popup = Popup(
            title='Factory Reset Result',
            content=content,
            size_hint=(0.6, 0.3),
            auto_dismiss=True
        )
        
        popup.open()
