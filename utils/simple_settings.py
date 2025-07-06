"""
Simplified settings manager that provides a clean interface to the database manager.
This replaces the complex settings_adapter and provides backward compatibility.
"""

from utils.database_manager import db_manager
from typing import Any


class SimpleSettings:
    """Simplified settings interface that maps to database manager"""
    
    def get(self, key_path: str, default: Any = None) -> Any:
        """Get a setting using dot notation (e.g., 'display.brightness')"""
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.get_setting(category, key, default)
        else:
            # Return entire category
            return db_manager.get_settings_category(key_path)
    
    def set(self, key_path: str, value: Any) -> bool:
        """Set a setting using dot notation (e.g., 'display.brightness')"""
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.set_setting(category, key, value)
        else:
            raise ValueError("Setting key must include category (e.g., 'display.brightness')")
    
    def bind(self, **kwargs):
        """Bind to settings changes (compatibility method)"""
        # Map to database manager events
        if 'settings' in kwargs:
            callback = kwargs['settings']
            # Create a wrapper that adapts the database callback to the old format
            def adapted_callback(instance, data_type, key, value):
                if data_type == 'setting':
                    # Call the old callback with a fake settings dict
                    callback(instance, {})
            db_manager.bind(on_data_changed=adapted_callback)
    
    def factory_reset(self) -> bool:
        """Factory reset all settings"""
        return db_manager.factory_reset()
    
    @property 
    def default_settings(self):
        """Get default settings (compatibility property)"""
        return db_manager.get_default_settings()


# Create a global instance for backward compatibility
settings_manager = SimpleSettings()
