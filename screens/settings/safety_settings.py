from kivy.uix.screenmanager import Screen
from kivy.properties import NumericProperty, BooleanProperty
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.logger import Logger
from utils.simple_settings import settings_manager

class SafetySettingsScreen(Screen):
    co2_alert_threshold = NumericProperty(1000)  # PPM
    co_alert_threshold = NumericProperty(35)     # PPM
    co2_alert_enabled = BooleanProperty(True)
    co_alert_enabled = BooleanProperty(True)
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Bind to settings changes
        settings_manager.bind(settings=self.on_settings_changed)
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
        
    def on_settings_changed(self, instance, settings):
        """Called when settings are updated externally"""
        self.load_settings_from_manager()
        
    def on_enter(self):
        """
        Loads and applies the latest safety settings when the screen becomes active.
        """
        self.load_settings_from_manager()
        
    def load_settings_from_manager(self):
        """
        Load the current safety settings from persistent storage and update the screen's properties.
        
        Retrieves CO2 and CO alert thresholds and enabled states from the settings manager, applying default values if not set.
        """
        self.co2_alert_threshold = settings_manager.get('safety.co2_alert_threshold', 1000)
        self.co_alert_threshold = settings_manager.get('safety.co_alert_threshold', 35)
        self.co2_alert_enabled = settings_manager.get('safety.co2_alert_enabled', True)
        self.co_alert_enabled = settings_manager.get('safety.co_alert_enabled', True)
    
    def on_co2_threshold_change(self, value):
        """
        Handles changes to the CO2 alert threshold setting, validating input and updating the property.
        
        If the input is not an integer between 400 and 5000 PPM, an error popup is shown and the value is not saved.
        """
        try:
            int_value = int(value)
            if not (400 <= int_value <= 5000):
                self.show_error("Invalid Value", "CO2 alert threshold must be between 400-5000 PPM")
                return
            
            self.co2_alert_threshold = int_value
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_co_threshold_change(self, value):
        """
        Handles changes to the CO alert threshold setting, validating input and updating the property.
        
        If the input is not an integer between 1 and 100 PPM, an error popup is shown and the value is not saved.
        """
        try:
            int_value = int(value)
            if not (1 <= int_value <= 100):
                self.show_error("Invalid Value", "CO alert threshold must be between 1-100 PPM")
                return
            
            self.co_alert_threshold = int_value
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_co2_alert_enabled_change(self, enabled):
        """
        Handles changes to the CO2 alert enabled state.
        """
        self.co2_alert_enabled = enabled
        success = settings_manager.set('safety.co2_alert_enabled', self.co2_alert_enabled)
        if not success:
            Logger.error("SafetySettings: Failed to save CO2 alert enabled state")
            self.show_error("Save Error", "Failed to save setting")
    
    def on_co_alert_enabled_change(self, enabled):
        """
        Handles changes to the CO alert enabled state.
        """
        self.co_alert_enabled = enabled
        success = settings_manager.set('safety.co_alert_enabled', self.co_alert_enabled)
        if not success:
            Logger.error("SafetySettings: Failed to save CO alert enabled state")
            self.show_error("Save Error", "Failed to save setting")
    
    def reset_to_defaults(self):
        """Reset all safety settings to default values"""
        self.show_reset_confirmation()
    
    def show_reset_confirmation(self):
        """Show confirmation dialog for resetting safety settings"""
        content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
        
        content.add_widget(Label(
            text='Reset all safety settings to factory defaults?',
            text_size=(None, None),
            halign='center'
        ))
        
        content.add_widget(Label(
            text='This will restore:\n• CO2 Alert: 1000 PPM (Enabled)\n• CO Alert: 35 PPM (Enabled)',
            text_size=(None, None),
            halign='center',
            font_size='14sp'
        ))
        
        buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='50dp')
        
        cancel_btn = Button(text='Cancel', size_hint_x=0.5)
        reset_btn = Button(
            text='Reset',
            size_hint_x=0.5,
            background_color=[0.8, 0.2, 0.2, 1]
        )
        
        buttons.add_widget(cancel_btn)
        buttons.add_widget(reset_btn)
        content.add_widget(buttons)
        
        popup = Popup(
            title='Reset Safety Settings',
            content=content,
            size_hint=(0.8, 0.6),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        reset_btn.bind(on_press=lambda x: self._perform_reset(popup))
        
        popup.open()
    
    def _perform_reset(self, popup):
        """
        Resets all safety settings to their factory default values and updates the UI.
        
        Parameters:
            popup: The confirmation popup to be dismissed after the reset is performed.
        """
        popup.dismiss()
        
        # Reset to default values
        settings_manager.set('safety.co2_alert_threshold', 1000)
        settings_manager.set('safety.co_alert_threshold', 35)
        settings_manager.set('safety.co2_alert_enabled', True)
        settings_manager.set('safety.co_alert_enabled', True)
        
        # Reload to update UI
        self.load_settings_from_manager()
    
    def show_error(self, title: str, message: str):
        """
        Displays an error popup with the specified title and message, and logs the warning.
        
        Parameters:
            title (str): The title of the error popup.
            message (str): The error message to display.
        """
        content = BoxLayout(orientation='vertical', spacing='10dp', padding='20dp')
        
        content.add_widget(Label(
            text=message,
            text_size=(400, None),
            halign='center',
            valign='middle'
        ))
        
        close_btn = Button(
            text='OK',
            size_hint_y=None,
            height='40dp'
        )
        
        popup = Popup(
            title=title,
            content=content,
            size_hint=(0.8, 0.4),
            auto_dismiss=False
        )
        
        close_btn.bind(on_press=popup.dismiss)
        content.add_widget(close_btn)
        
        popup.open()
        Logger.warning(f"SafetySettings: {title} - {message}")
