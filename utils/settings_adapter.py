"""
Settings adapter that provides compatibility between the old JSON-based settings
and the new database-based storage system.
"""

from utils.database_manager import db_manager
from kivy.event import EventDispatcher
from kivy.properties import DictProperty


class SettingsAdapter(EventDispatcher):
    """
    Adapter that provides the same interface as the old settings manager
    but uses the new database backend.
    """
    
    # Kivy property for backwards compatibility
    settings = DictProperty({})
    
    def __init__(self):
        super().__init__()
        # Bind to database changes
        db_manager.bind(on_data_changed=self.on_database_changed)
        self.refresh_settings()
    
    def on_database_changed(self, instance, data_type, key, value):
        """Called when database changes"""
        if data_type in ['setting', 'factory_reset']:
            self.refresh_settings()
    
    def refresh_settings(self):
        """Refresh the settings dictionary from database"""
        # Get all categories
        categories = ['app', 'display', 'wifi', 'sensors', 'safety', 'units']
        
        new_settings = {}
        for category in categories:
            new_settings[category] = db_manager.get_settings_category(category)
        
        self.settings = new_settings
    
    def get(self, key_path: str, default=None):
        """Get a setting using dot notation (e.g., 'display.brightness')"""
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.get_setting(category, key, default)
        else:
            # Return entire category
            return db_manager.get_settings_category(key_path)
    
    def set(self, key_path: str, value, save: bool = True):
        """Set a setting using dot notation"""
        if '.' in key_path:
            category, key = key_path.split('.', 1)
            return db_manager.set_setting(category, key, value)
        else:
            # Cannot set entire category with this method
            return False
    
    def factory_reset(self, save: bool = True):
        """Perform factory reset"""
        return db_manager.factory_reset()
    
    def get_category(self, category: str):
        """Get all settings for a category"""
        return db_manager.get_settings_category(category)
    
    def set_category(self, category: str, values: dict, save: bool = True):
        """Set multiple values for a category"""
        success = True
        for key, value in values.items():
            if not db_manager.set_setting(category, key, value):
                success = False
        return success
    
    def backup_settings(self, backup_path: str):
        """Create a backup"""
        return db_manager.backup_database(backup_path)
    
    @property
    def default_settings(self):
        """Default settings - delegates to database manager to avoid duplication"""
        # Get defaults from database manager to maintain single source of truth
        return db_manager.get_default_settings()


# Global instance for backwards compatibility
settings_manager = SettingsAdapter()
