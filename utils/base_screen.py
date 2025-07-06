"""
Base screen class with common functionality for all Trimix screens.
Provides standard navigation, settings access, and error handling.
"""

from kivy.uix.screenmanager import Screen
from kivy.logger import Logger
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from utils.database_manager import db_manager
from utils.simple_settings import settings_manager


class BaseScreen(Screen):
    """
    Base class for all Trimix screens.
    Provides common functionality like navigation, settings access, and error handling.
    """
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.db_manager = db_manager
        self.settings_manager = settings_manager
    
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
            self.show_error("Navigation Error", f"Failed to navigate to {screen_name}")
    
    def get_setting(self, category: str, key: str, default=None):
        """Convenient settings access"""
        try:
            return self.db_manager.get_setting(category, key, default)
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to get setting {category}.{key}: {e}")
            return default
    
    def set_setting(self, category: str, key: str, value):
        """Convenient settings update"""
        try:
            return self.db_manager.set_setting(category, key, value)
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to set setting {category}.{key}: {e}")
            self.show_error("Settings Error", f"Failed to save {key} setting")
            return False
    
    def show_error(self, title: str, message: str):
        """Show standardized error popup"""
        try:
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
            Logger.warning(f"{self.__class__.__name__}: {title} - {message}")
            
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to show error popup: {e}")
    
    def show_confirmation(self, title: str, message: str, on_confirm=None, on_cancel=None):
        """Show standardized confirmation dialog"""
        try:
            content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
            
            content.add_widget(Label(
                text=message,
                text_size=(None, None),
                halign='center'
            ))
            
            buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='50dp')
            
            cancel_btn = Button(text='Cancel', size_hint_x=0.5)
            confirm_btn = Button(text='Confirm', size_hint_x=0.5, background_color=[0.2, 0.6, 0.2, 1])
            
            buttons.add_widget(cancel_btn)
            buttons.add_widget(confirm_btn)
            content.add_widget(buttons)
            
            popup = Popup(
                title=title,
                content=content,
                size_hint=(0.8, 0.5),
                auto_dismiss=False
            )
            
            def _on_cancel(instance):
                popup.dismiss()
                if on_cancel:
                    on_cancel()
            
            def _on_confirm(instance):
                popup.dismiss()
                if on_confirm:
                    on_confirm()
            
            cancel_btn.bind(on_press=_on_cancel)
            confirm_btn.bind(on_press=_on_confirm)
            
            popup.open()
            
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to show confirmation dialog: {e}")
    
    def validate_numeric_input(self, value, min_val=None, max_val=None, input_type=int):
        """Validate numeric input with standardized error handling"""
        try:
            converted_value = input_type(value)
            
            if min_val is not None and converted_value < min_val:
                self.show_error("Invalid Value", f"Value must be at least {min_val}")
                return None
                
            if max_val is not None and converted_value > max_val:
                self.show_error("Invalid Value", f"Value must be at most {max_val}")
                return None
                
            return converted_value
            
        except (ValueError, TypeError):
            self.show_error("Invalid Input", f"Please enter a valid {input_type.__name__}")
            return None


class BaseSettingsScreen(BaseScreen):
    """
    Enhanced base class specifically for settings screens.
    Provides settings loading/saving patterns and reset functionality.
    """
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Bind to settings changes
        settings_manager.bind(settings=self.on_settings_changed)
    
    def on_enter(self):
        """Called when entering the screen - load settings"""
        self.load_settings()
    
    def on_settings_changed(self, instance, settings):
        """Called when settings are updated externally"""
        self.load_settings()
    
    def load_settings(self):
        """Override in subclasses to load specific settings"""
        Logger.info(f"{self.__class__.__name__}: Loading settings")
    
    def navigate_back(self):
        """Navigate back to main settings screen"""
        self.manager.current = 'settings'
    
    def show_reset_confirmation(self, settings_category: str, reset_callback=None):
        """Show standardized reset confirmation for settings"""
        message = f"Reset all {settings_category} settings to factory defaults?\n\nThis action cannot be undone."
        
        def perform_reset():
            if reset_callback:
                reset_callback()
            else:
                self.reset_to_defaults()
        
        self.show_confirmation(
            f"Reset {settings_category.title()} Settings",
            message,
            on_confirm=perform_reset
        )
    
    def reset_to_defaults(self):
        """Override in subclasses to implement specific reset logic"""
        Logger.warning(f"{self.__class__.__name__}: reset_to_defaults not implemented")
