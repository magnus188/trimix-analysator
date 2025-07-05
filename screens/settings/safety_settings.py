from kivy.uix.screenmanager import Screen
from kivy.properties import NumericProperty
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from utils.settings_manager import settings_manager

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
        self.max_o2_percentage = int(value)
        settings_manager.set('safety.max_o2_percentage', self.max_o2_percentage)
    
    def on_max_he_change(self, value):
        """Called when max He percentage changes"""
        self.max_he_percentage = int(value)
        settings_manager.set('safety.max_he_percentage', self.max_he_percentage)
    
    def on_high_o2_threshold_change(self, value):
        """Called when high O2 threshold changes"""
        self.high_o2_threshold = round(float(value), 1)
        settings_manager.set('safety.warning_thresholds.high_o2', self.high_o2_threshold)
    
    def on_low_o2_threshold_change(self, value):
        """Called when low O2 threshold changes"""
        self.low_o2_threshold = round(float(value), 1)
        settings_manager.set('safety.warning_thresholds.low_o2', self.low_o2_threshold)
    
    def on_high_he_threshold_change(self, value):
        """Called when high He threshold changes"""
        self.high_he_threshold = round(float(value), 1)
        settings_manager.set('safety.warning_thresholds.high_he', self.high_he_threshold)
    
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
        
        # Reset to default values from settings manager
        defaults = settings_manager.default_settings['safety']
        
        settings_manager.set('safety.max_o2_percentage', defaults['max_o2_percentage'])
        settings_manager.set('safety.max_he_percentage', defaults['max_he_percentage'])
        settings_manager.set('safety.warning_thresholds.high_o2', defaults['warning_thresholds']['high_o2'])
        settings_manager.set('safety.warning_thresholds.low_o2', defaults['warning_thresholds']['low_o2'])
        settings_manager.set('safety.warning_thresholds.high_he', defaults['warning_thresholds']['high_he'])
        
        # Reload from settings manager to update UI
        self.load_settings_from_manager()
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
