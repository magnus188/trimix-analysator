from kivy.uix.screenmanager import Screen
from kivy.properties import NumericProperty
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.logger import Logger
from utils.settings_adapter import settings_manager

class SafetySettingsScreen(Screen):
    max_o2_percentage = NumericProperty(100)
    max_he_percentage = NumericProperty(100)
    high_o2_threshold = NumericProperty(23.0)
    low_o2_threshold = NumericProperty(19.0)
    high_he_threshold = NumericProperty(50.0)
    
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
        """Called when entering the screen"""
        self.load_settings_from_manager()
        
    def load_settings_from_manager(self):
        """Load current safety settings from the settings manager"""
        self.max_o2_percentage = settings_manager.get('safety.max_o2_percentage', 100)
        self.max_he_percentage = settings_manager.get('safety.max_he_percentage', 100)
        self.high_o2_threshold = settings_manager.get('safety.warning_thresholds.high_o2', 23.0)
        self.low_o2_threshold = settings_manager.get('safety.warning_thresholds.low_o2', 19.0)
        self.high_he_threshold = settings_manager.get('safety.warning_thresholds.high_he', 50.0)
    
    def on_max_o2_change(self, value):
        """Called when max O2 percentage changes"""
        try:
            int_value = int(value)
            if not (10 <= int_value <= 100):
                self.show_error("Invalid Value", "Maximum O2 percentage must be between 10-100%")
                return
            
            self.max_o2_percentage = int_value
            success = settings_manager.set('safety.max_o2_percentage', self.max_o2_percentage)
            if not success:
                Logger.error("SafetySettings: Failed to save max O2 setting")
                self.show_error("Save Error", "Failed to save setting")
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_max_he_change(self, value):
        """Called when max He percentage changes"""
        try:
            int_value = int(value)
            if not (0 <= int_value <= 100):
                self.show_error("Invalid Value", "Maximum He percentage must be between 0-100%")
                return
            
            self.max_he_percentage = int_value
            success = settings_manager.set('safety.max_he_percentage', self.max_he_percentage)
            if not success:
                Logger.error("SafetySettings: Failed to save max He setting")
                self.show_error("Save Error", "Failed to save setting")
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_high_o2_threshold_change(self, value):
        """Called when high O2 threshold changes"""
        try:
            float_value = round(float(value), 1)
            if not (19.0 <= float_value <= 25.0):
                self.show_error("Invalid Value", "High O2 threshold must be between 19.0-25.0%")
                return
            
            # Ensure high threshold is above low threshold
            if hasattr(self, 'low_o2_threshold') and float_value <= self.low_o2_threshold:
                self.show_error("Invalid Value", "High O2 threshold must be greater than low threshold")
                return
            
            self.high_o2_threshold = float_value
            success = settings_manager.set('safety.warning_thresholds.high_o2', self.high_o2_threshold)
            if not success:
                Logger.error("SafetySettings: Failed to save high O2 threshold")
                self.show_error("Save Error", "Failed to save setting")
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_low_o2_threshold_change(self, value):
        """Called when low O2 threshold changes"""
        try:
            float_value = round(float(value), 1)
            if not (15.0 <= float_value <= 22.0):
                self.show_error("Invalid Value", "Low O2 threshold must be between 15.0-22.0%")
                return
            
            # Ensure low threshold is below high threshold
            if hasattr(self, 'high_o2_threshold') and float_value >= self.high_o2_threshold:
                self.show_error("Invalid Value", "Low O2 threshold must be less than high threshold")
                return
            
            self.low_o2_threshold = float_value
            success = settings_manager.set('safety.warning_thresholds.low_o2', self.low_o2_threshold)
            if not success:
                Logger.error("SafetySettings: Failed to save low O2 threshold")
                self.show_error("Save Error", "Failed to save setting")
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
    def on_high_he_threshold_change(self, value):
        """Called when high He threshold changes"""
        try:
            float_value = round(float(value), 1)
            if not (30.0 <= float_value <= 80.0):
                self.show_error("Invalid Value", "High He threshold must be between 30.0-80.0%")
                return
            
            self.high_he_threshold = float_value
            success = settings_manager.set('safety.warning_thresholds.high_he', self.high_he_threshold)
            if not success:
                Logger.error("SafetySettings: Failed to save high He threshold")
                self.show_error("Save Error", "Failed to save setting")
                
        except (ValueError, TypeError):
            self.show_error("Invalid Input", "Please enter a valid number")
    
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
            text='This will restore:\n• Max O2: 100%\n• Max He: 100%\n• High O2 warning: 23.0%\n• Low O2 warning: 19.0%\n• High He warning: 50.0%',
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
        """Perform the actual safety settings reset"""
        popup.dismiss()
        
        # Reset to default values from database manager
        from utils.database_manager import db_manager
        defaults = db_manager.get_default_settings()['safety']
        
        settings_manager.set('safety.max_o2_percentage', defaults['max_o2_percentage'])
        settings_manager.set('safety.max_he_percentage', defaults['max_he_percentage'])
        settings_manager.set('safety.warning_thresholds.high_o2', defaults['warning_thresholds']['high_o2'])
        settings_manager.set('safety.warning_thresholds.low_o2', defaults['warning_thresholds']['low_o2'])
        settings_manager.set('safety.warning_thresholds.high_he', defaults['warning_thresholds']['high_he'])
        
        # Reload from settings manager to update UI
        self.load_settings_from_manager()
    
    def show_error(self, title: str, message: str):
        """Show error popup to user"""
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
