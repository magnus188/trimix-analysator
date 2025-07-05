"""
Base screen class with common functionality for all Trimix screens.
Provides standard navigation, settings access, and error handling.
"""

from kivy.uix.screenmanager import Screen
from kivy.logger import Logger
from utils.database_manager import db_manager


class BaseScreen(Screen):
    """
    Base class for all Trimix screens.
    Provides common functionality like navigation, settings access.
    """
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.db_manager = db_manager
    
    def navigate_back(self):
        """Standard back navigation - override in subclasses if needed"""
        if hasattr(self.manager, 'previous_screen'):
            self.manager.current = self.manager.previous_screen
        else:
            self.manager.current = 'home'
    
    def navigate_to(self, screen_name: str):
        """Navigate to a specific screen"""
        try:
            # Store current screen as previous for back navigation
            if hasattr(self.manager, 'current'):
                self.manager.previous_screen = self.manager.current
            
            self.manager.current = screen_name
            Logger.info(f"BaseScreen: Navigated to {screen_name}")
            
        except Exception as e:
            Logger.error(f"BaseScreen: Navigation to {screen_name} failed: {e}")
    
    def get_setting(self, category: str, key: str, default=None):
        """Convenient settings access"""
        return self.db_manager.get_setting(category, key, default)
    
    def set_setting(self, category: str, key: str, value):
        """Convenient settings update"""
        return self.db_manager.set_setting(category, key, value)
    
    def show_error(self, title: str, message: str):
        """Show error popup - can be overridden for custom styling"""
        from kivy.uix.popup import Popup
        from kivy.uix.label import Label
        from kivy.uix.button import Button
        from kivy.uix.boxlayout import BoxLayout
        
        content = BoxLayout(orientation='vertical', spacing='10dp', padding='20dp')
        
        content.add_widget(Label(
            text=message,
            text_size=(None, None),
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
            size_hint=(0.8, 0.4)
        )
        
        close_btn.bind(on_press=popup.dismiss)
        content.add_widget(close_btn)
        
        popup.open()
    
    def show_confirmation(self, title: str, message: str, callback=None):
        """Show confirmation dialog"""
        from kivy.uix.popup import Popup
        from kivy.uix.label import Label
        from kivy.uix.button import Button
        from kivy.uix.boxlayout import BoxLayout
        
        content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
        
        content.add_widget(Label(
            text=message,
            text_size=(None, None),
            halign='center',
            valign='middle'
        ))
        
        button_layout = BoxLayout(
            orientation='horizontal',
            size_hint_y=None,
            height='40dp',
            spacing='10dp'
        )
        
        popup = Popup(
            title=title,
            content=content,
            size_hint=(0.8, 0.4)
        )
        
        cancel_btn = Button(text='Cancel')
        confirm_btn = Button(text='Confirm')
        
        cancel_btn.bind(on_press=popup.dismiss)
        
        def on_confirm(instance):
            popup.dismiss()
            if callback:
                callback()
        
        confirm_btn.bind(on_press=on_confirm)
        
        button_layout.add_widget(cancel_btn)
        button_layout.add_widget(confirm_btn)
        content.add_widget(button_layout)
        
        popup.open()


class BaseSettingsScreen(BaseScreen):
    """
    Base class for settings screens with common settings functionality.
    """
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.settings_category = None  # Should be set by subclasses
    
    def load_settings_from_manager(self):
        """Load settings from database - override in subclasses"""
        pass
    
    def reset_to_defaults(self):
        """Reset settings to defaults - override in subclasses"""
        if not self.settings_category:
            self.show_error("Error", "Settings category not defined")
            return
        
        def confirm_reset():
            try:
                # Get default settings for this category
                defaults = self.db_manager.get_settings_category('defaults')
                if self.settings_category in defaults:
                    category_defaults = defaults[self.settings_category]
                    for key, value in category_defaults.items():
                        self.set_setting(self.settings_category, key, value)
                    
                    # Reload settings in UI
                    self.load_settings_from_manager()
                    self.show_error("Success", "Settings reset to defaults")
                else:
                    self.show_error("Error", "No defaults found for this category")
                    
            except Exception as e:
                Logger.error(f"BaseSettingsScreen: Reset failed: {e}")
                self.show_error("Error", f"Reset failed: {str(e)}")
        
        self.show_confirmation(
            "Reset Settings", 
            f"Reset all {self.settings_category} settings to defaults?",
            confirm_reset
        )
