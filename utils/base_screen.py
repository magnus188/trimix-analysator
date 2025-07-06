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
        """
        Initializes the base screen with references to the database and settings managers.
        """
        super().__init__(**kwargs)
        self.db_manager = db_manager
        self.settings_manager = settings_manager
    
    def navigate_back(self):
        """
        Navigates to the previous screen if available; otherwise, returns to the 'home' screen.
        
        Override this method in subclasses to customize back navigation behavior.
        """
        if hasattr(self.manager, 'previous_screen'):
            self.manager.current = self.manager.previous_screen
        else:
            self.manager.current = 'home'
    
    def navigate_to(self, screen_name: str):
        """
        Navigates to the specified screen and stores the current screen for back navigation.
        
        If navigation fails, logs the error and displays an error popup to the user.
        """
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
        """
        Retrieve a setting value from the database manager, returning a default if retrieval fails.
        
        Parameters:
            category (str): The category under which the setting is stored.
            key (str): The specific setting key.
            default: The value to return if the setting cannot be retrieved.
        
        Returns:
            The setting value if found; otherwise, the provided default.
        """
        try:
            return self.db_manager.get_setting(category, key, default)
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to get setting {category}.{key}: {e}")
            return default
    
    def set_setting(self, category: str, key: str, value):
        """
        Update a setting in the specified category, displaying an error popup and returning False if the operation fails.
        
        Returns:
            bool: True if the setting was updated successfully, False otherwise.
        """
        try:
            return self.db_manager.set_setting(category, key, value)
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to set setting {category}.{key}: {e}")
            self.show_error("Settings Error", f"Failed to save {key} setting")
            return False
    
    def show_error(self, title: str, message: str):
        """
        Displays a standardized error popup dialog with a given title and message.
        
        The popup includes an OK button to dismiss it. Logs the error message as a warning. If popup creation fails, logs the exception.
        """
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
        """
        Display a confirmation dialog with customizable title and message, and optional callbacks for confirm and cancel actions.
        
        Parameters:
            title (str): The title of the confirmation dialog.
            message (str): The message displayed in the dialog.
            on_confirm (callable, optional): Function to call if the user confirms.
            on_cancel (callable, optional): Function to call if the user cancels.
        """
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
                """
                Handles the cancel action in a confirmation dialog by dismissing the popup and invoking the optional cancel callback.
                """
                popup.dismiss()
                if on_cancel:
                    on_cancel()
            
            def _on_confirm(instance):
                """
                Handles the confirm action in a confirmation dialog by dismissing the popup and invoking the confirmation callback if provided.
                """
                popup.dismiss()
                if on_confirm:
                    on_confirm()
            
            cancel_btn.bind(on_press=_on_cancel)
            confirm_btn.bind(on_press=_on_confirm)
            
            popup.open()
            
        except Exception as e:
            Logger.error(f"BaseScreen: Failed to show confirmation dialog: {e}")
    
    def validate_numeric_input(self, value, min_val=None, max_val=None, input_type=int):
        """
        Validates and converts input to a numeric type, enforcing optional minimum and maximum bounds.
        
        If the input is invalid or out of range, displays an error popup and returns None. Otherwise, returns the converted numeric value.
        
        Parameters:
            value: The input value to validate and convert.
            min_val: Optional minimum allowed value.
            max_val: Optional maximum allowed value.
            input_type: The numeric type to convert to (default is int).
        
        Returns:
            The converted numeric value if valid; otherwise, None.
        """
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
        """
        Initializes the settings screen and binds to external settings changes to enable automatic updates when settings are modified elsewhere.
        """
        super().__init__(**kwargs)
        # Bind to settings changes
        settings_manager.bind(settings=self.on_settings_changed)
    
    def on_enter(self):
        """
        Triggered when the screen is entered; initiates loading of settings for the screen.
        """
        self.load_settings()
    
    def on_settings_changed(self, instance, settings):
        """
        Handles external updates to settings by reloading the current settings.
        
        This method is triggered when the settings manager signals that settings have changed elsewhere, ensuring the screen reflects the latest values.
        """
        self.load_settings()
    
    def load_settings(self):
        """
        Placeholder method to load settings for the screen.
        
        Intended to be overridden in subclasses to implement loading of specific settings when the screen is entered.
        """
        Logger.info(f"{self.__class__.__name__}: Loading settings")
    
    def navigate_back(self):
        """
        Navigates back to the main settings screen by setting the current screen to 'settings'.
        """
        self.manager.current = 'settings'
    
    def show_reset_confirmation(self, settings_category: str, reset_callback=None):
        """
        Display a confirmation dialog to reset all settings in the specified category to factory defaults.
        
        Parameters:
            settings_category (str): The category of settings to reset.
            reset_callback (callable, optional): A function to execute if the user confirms the reset. If not provided, calls `reset_to_defaults()`.
        
        This method presents a warning dialog to the user. If confirmed, it executes the provided reset callback or defaults to the class's reset logic.
        """
        message = f"Reset all {settings_category} settings to factory defaults?\n\nThis action cannot be undone."
        
        def perform_reset():
            """
            Executes the provided reset callback if available; otherwise, calls the default reset-to-defaults method.
            """
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
        """
        Stub method for resetting settings to factory defaults; should be overridden in subclasses to implement specific reset logic.
        """
        Logger.warning(f"{self.__class__.__name__}: reset_to_defaults not implemented")
