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

    def on_setting_press(self, setting_name):
        # Function to handle setting button presses
        
        # Handle specific settings
        if setting_name == 'calibrate_o2':
            self.manager.current = 'calibrate_o2'
        elif setting_name == 'wifi_settings':
            self.manager.current = 'wifi_settings'
        elif setting_name == 'display_settings':
            self.manager.current = 'display_settings'
        elif setting_name == 'factory_reset':
            self.show_factory_reset_confirmation()
        else:
            # TODO: Implement functionality for other settings
            pass

    def navigate_back(self):
        # Function to navigate back to home screen
        self.manager.current = 'home'

    def show_factory_reset_confirmation(self):
        """Show confirmation dialog for factory reset"""
        content = BoxLayout(orientation='vertical', spacing='10dp', padding='10dp')
        
        content.add_widget(Label(
            text='This will reset all settings to their default values.\n\nAre you sure you want to continue?',
            text_size=(300, None),
            halign='center',
            size_hint_y=None,
            height='80dp'
        ))
        
        buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='50dp')
        
        cancel_btn = Button(text='Cancel', size_hint_x=0.5)
        reset_btn = Button(text='Factory Reset', size_hint_x=0.5)
        
        buttons.add_widget(cancel_btn)
        buttons.add_widget(reset_btn)
        content.add_widget(buttons)
        
        popup = Popup(
            title='Factory Reset',
            content=content,
            size_hint=(0.8, 0.4),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        reset_btn.bind(on_press=lambda x: self._perform_factory_reset(popup))
        
        popup.open()
    
    def _perform_factory_reset(self, popup):
        """Perform the actual factory reset"""
        popup.dismiss()
        
        # Reset all settings to defaults
        success = settings_manager.factory_reset()
        
        if success:
            self._show_reset_result("Factory reset completed successfully!", success=True)
        else:
            self._show_reset_result("Factory reset failed. Please try again.", success=False)
    
    def _show_reset_result(self, message, success=True):
        """Show factory reset result"""
        content = Label(text=message, text_size=(None, None))
        
        popup = Popup(
            title='Factory Reset Result',
            content=content,
            size_hint=(0.7, 0.3),
            auto_dismiss=True
        )
        
        popup.open()
