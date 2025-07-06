from kivy.uix.screenmanager import Screen
from kivy.properties import NumericProperty, BooleanProperty
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from utils.simple_settings import settings_manager
from utils.calibration_reminder import calibration_reminder
from datetime import datetime
from kivy.logger import Logger

class SensorSettingsScreen(Screen):
    calibration_interval_days = NumericProperty(30)
    auto_calibration_reminder = BooleanProperty(True)
    o2_calibration_offset = NumericProperty(0.0)
    he_calibration_offset = NumericProperty(0.0)
    auto_calibrate = BooleanProperty(True)
    
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
        """Load current sensor settings from the settings manager"""
        self.calibration_interval_days = settings_manager.get('sensors.calibration_interval_days', 30)
        self.auto_calibration_reminder = settings_manager.get('sensors.auto_calibration_reminder', True)
        self.o2_calibration_offset = settings_manager.get('sensors.o2_calibration_offset', 0.0)
        self.he_calibration_offset = settings_manager.get('sensors.he_calibration_offset', 0.0)
        self.auto_calibrate = settings_manager.get('sensors.auto_calibrate', True)
    
    def on_calibration_interval_change(self, value):
        """Called when calibration interval changes"""
        try:
            int_value = int(value)
            if not (7 <= int_value <= 365):
                self.show_error("Invalid Value", "Calibration interval must be between 7-365 days")
                return
            
            self.calibration_interval_days = int_value
            settings_manager.set('sensors.calibration_interval_days', self.calibration_interval_days)
        except ValueError:
            self.show_error("Invalid Value", "Calibration interval must be a number")
    
    def on_auto_reminder_change(self, active):
        """Called when auto reminder toggle changes"""
        self.auto_calibration_reminder = active
        settings_manager.set('sensors.auto_calibration_reminder', self.auto_calibration_reminder)
    
    def on_o2_offset_change(self, value):
        """Called when O2 calibration offset changes"""
        try:
            float_value = float(value)
            if not (-5.0 <= float_value <= 5.0):
                self.show_error("Invalid Value", "O2 offset must be between -5.0 and 5.0")
                return
            
            self.o2_calibration_offset = round(float_value, 2)
            settings_manager.set('sensors.o2_calibration_offset', self.o2_calibration_offset)
        except ValueError:
            self.show_error("Invalid Value", "O2 offset must be a number")
    
    def on_he_offset_change(self, value):
        """Called when He calibration offset changes"""
        try:
            float_value = float(value)
            if not (-5.0 <= float_value <= 5.0):
                self.show_error("Invalid Value", "He offset must be between -5.0 and 5.0")
                return
            
            self.he_calibration_offset = round(float_value, 2)
            settings_manager.set('sensors.he_calibration_offset', self.he_calibration_offset)
        except ValueError:
            self.show_error("Invalid Value", "He offset must be a number")
    
    def on_auto_calibrate_change(self, active):
        """Called when auto calibrate toggle changes"""
        self.auto_calibrate = active
        settings_manager.set('sensors.auto_calibrate', self.auto_calibrate)
    
    def get_calibration_status_text(self):
        """Get text showing current calibration status"""
        o2_date_str = settings_manager.get('sensors.o2_calibration_date')
        he_date_str = settings_manager.get('sensors.he_calibration_date')
        
        status_lines = []
        
        # O2 status
        if o2_date_str:
            try:
                o2_date = datetime.fromisoformat(o2_date_str)
                days_ago = (datetime.now() - o2_date).days
                status_lines.append(f"O2: {days_ago} days ago")
            except ValueError:
                status_lines.append("O2: Invalid date")
        else:
            status_lines.append("O2: Never calibrated")
        
        # He status
        if he_date_str:
            try:
                he_date = datetime.fromisoformat(he_date_str)
                days_ago = (datetime.now() - he_date).days
                status_lines.append(f"He: {days_ago} days ago")
            except ValueError:
                status_lines.append("He: Invalid date")
        else:
            status_lines.append("He: Never calibrated")
        
        return "\n".join(status_lines)
    
    def reset_calibration_dates(self):
        """Reset calibration dates (clear calibration history)"""
        self.show_reset_calibration_confirmation()
    
    def show_reset_calibration_confirmation(self):
        """Show confirmation dialog for resetting calibration dates"""
        content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
        
        content.add_widget(Label(
            text='Reset Calibration History?',
            font_size='20sp',
            size_hint_y=None,
            height='40dp',
            color=[1, 0.8, 0, 1]
        ))
        
        content.add_widget(Label(
            text='This will clear all calibration dates and force\ncalibration reminders to appear immediately.\n\nThis action cannot be undone.',
            text_size=(350, None),
            halign='center',
            font_size='16sp'
        ))
        
        buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='50dp')
        
        cancel_btn = Button(text='Cancel', size_hint_x=0.5)
        reset_btn = Button(
            text='Reset History',
            size_hint_x=0.5,
            background_color=[0.8, 0.6, 0.2, 1]
        )
        
        buttons.add_widget(cancel_btn)
        buttons.add_widget(reset_btn)
        content.add_widget(buttons)
        
        popup = Popup(
            title='Reset Calibration History',
            content=content,
            size_hint=(0.8, 0.5),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        reset_btn.bind(on_press=lambda x: self._perform_calibration_reset(popup))
        
        popup.open()
    
    def _perform_calibration_reset(self, popup):
        """Perform the actual calibration history reset"""
        popup.dismiss()
        
        # Reset calibration dates
        settings_manager.set('sensors.o2_calibration_date', None)
        settings_manager.set('sensors.he_calibration_date', None)
        
        # Show success message
        self._show_reset_result("Calibration history cleared successfully!")
    
    def _show_reset_result(self, message: str):
        """Show reset result message"""
        content = Label(text=message, text_size=(None, None))
        
        popup = Popup(
            title='Reset Complete',
            content=content,
            size_hint=(0.6, 0.3),
            auto_dismiss=True
        )
        
        popup.open()
    
    def test_calibration_reminder(self):
        """Test the calibration reminder system"""
        calibration_reminder.show_calibration_reminder()
    
    def reset_to_defaults(self):
        """Reset all sensor settings to default values"""
        self.show_sensor_reset_confirmation()
    
    def show_sensor_reset_confirmation(self):
        """Show confirmation dialog for resetting sensor settings"""
        content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
        
        content.add_widget(Label(
            text='Reset all sensor settings to factory defaults?',
            text_size=(350, None),
            halign='center',
            font_size='18sp'
        ))
        
        content.add_widget(Label(
            text='This will restore:\n• Calibration interval: 30 days\n• Auto reminders: Enabled\n• Calibration offsets: 0.0\n• Auto calibrate: Enabled',
            text_size=(350, None),
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
            title='Reset Sensor Settings',
            content=content,
            size_hint=(0.8, 0.6),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        reset_btn.bind(on_press=lambda x: self._perform_sensor_reset(popup))
        
        popup.open()
    
    def _perform_sensor_reset(self, popup):
        """Perform the actual sensor settings reset"""
        popup.dismiss()
        
        # Reset to default values from settings manager
        defaults = settings_manager.default_settings['sensors']
        
        settings_manager.set('sensors.calibration_interval_days', defaults['calibration_interval_days'])
        settings_manager.set('sensors.auto_calibration_reminder', defaults['auto_calibration_reminder'])
        settings_manager.set('sensors.o2_calibration_offset', defaults['o2_calibration_offset'])
        settings_manager.set('sensors.he_calibration_offset', defaults['he_calibration_offset'])
        settings_manager.set('sensors.auto_calibrate', defaults['auto_calibrate'])
        
        # Reload from settings manager to update UI
        self.load_settings_from_manager()
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
    
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
        Logger.warning(f"SensorSettings: {title} - {message}")
