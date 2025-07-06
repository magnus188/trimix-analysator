"""
Simplified settings manager that provides a clean interface to the database manager.
This replaces the complex settings_adapter and provides backward compatibility.
"""

from utils.database_manager import db_manager
from typing import Any


class SimpleSettings:
    """Simplified settings interface that maps to database manager"""
    
    def get(self, key_path: str, default: Any = None) -> Any:
        """
        Retrieve a setting value or an entire settings category using a dot notation key.
        
        If `key_path` contains a dot (e.g., "category.key"), returns the value for the specified key within the category. If no dot is present, returns all settings within the specified category.
        
        Parameters:
            key_path (str): Dot notation key specifying the category and optionally the key (e.g., "category.key" or "category").
            default (Any, optional): Value to return if the specified setting is not found.
        
        Returns:
            Any: The requested setting value, the entire category dictionary, or the default value if the key is not found.
        """
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.get_setting(category, key, default)
        else:
            # Return entire category
            return db_manager.get_settings_category(key_path)
    
    def set(self, key_path: str, value: Any) -> bool:
        """
        Set the value of a specific setting using a dot notation key.
        
        Parameters:
            key_path (str): The setting key in 'category.key' format.
            value (Any): The value to assign to the setting.
        
        Returns:
            bool: True if the setting was updated successfully, False otherwise.
        
        Raises:
            ValueError: If the key_path does not include a category (i.e., lacks a dot).
        """
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.set_setting(category, key, value)
        else:
            raise ValueError("Setting key must include category (e.g., 'display.brightness')")
    
    def bind(self, **kwargs):
        """
        Registers a callback for settings changes, adapting the callback signature for backward compatibility.
        
        If a 'settings' callback is provided, it is invoked when a setting changes, using the legacy callback format.
        """
        # Map to database manager events
        if 'settings' in kwargs:
            callback = kwargs['settings']
            # Create a wrapper that adapts the database callback to the old format
            def adapted_callback(instance, data_type, key, value):
                """
                Adapts a settings change event to the legacy callback signature.
                
                Calls the provided callback with an empty settings dictionary when the data type is 'setting'.
                """
                if data_type == 'setting':
                    # Call the old callback with a fake settings dict
                    callback(instance, {})
            db_manager.bind(on_data_changed=adapted_callback)
    
    def factory_reset(self) -> bool:
        """
        Reset all application settings to their factory default values.
        
        Returns:
            bool: True if the reset was successful, False otherwise.
        """
        return db_manager.factory_reset()
    
    @property 
    def default_settings(self):
        """
        Returns the application's default settings from the underlying database manager.
        """
        return db_manager.get_default_settings()


# Create a global instance for backward compatibility
settings_manager = SimpleSettings()
