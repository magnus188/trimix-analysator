import json
import os
from typing import Any, Dict, Optional
from kivy.event import EventDispatcher
from kivy.properties import DictProperty

class SettingsManager(EventDispatcher):
    """
    Centralized settings manager for the Trimix app.
    Handles loading, saving, and managing all application settings.
    """
    
    # Kivy property to automatically trigger updates when settings change
    settings = DictProperty({})
    
    def __init__(self, settings_file: str = 'trimix_settings.json'):
        super().__init__()
        self.settings_file = settings_file
        self.settings_path = os.path.join(os.path.dirname(__file__), self.settings_file)
        
        # Default settings - this is your "factory reset" state
        self.default_settings = {
            'display': {
                'brightness': 50,
                'sleep_timeout': 5,  # minutes
                'auto_brightness': False,
            },
            'wifi': {
                'auto_connect': True,
                'remember_networks': True,
                'scan_interval': 30,  # seconds
            },
            'sensors': {
                'o2_calibration_date': None,
                'he_calibration_date': None,
                'auto_calibration_reminder': True,
                'calibration_interval_days': 30,
            },
            'app': {
                'first_run': True,
                'theme': 'dark',
                'language': 'en',
                'debug_mode': False,
                'last_screen': 'home',
            },
            'units': {
                'pressure': 'bar',  # bar, psi, kpa
                'temperature': 'celsius',  # celsius, fahrenheit
                'depth': 'meters',  # meters, feet
            },
            'safety': {
                'max_o2_percentage': 100,
                'max_he_percentage': 100,
                'warning_thresholds': {
                    'high_o2': 23.0,
                    'low_o2': 19.0,
                    'high_he': 50.0,
                }
            }
        }
        
        # Load settings on initialization
        self.load_settings()
    
    def load_settings(self) -> bool:
        """
        Load settings from file. If file doesn't exist or is corrupted,
        use default settings.
        """
        try:
            if os.path.exists(self.settings_path):
                with open(self.settings_path, 'r') as f:
                    loaded_settings = json.load(f)
                
                # Merge with defaults (in case new settings were added)
                self.settings = self._merge_settings(self.default_settings, loaded_settings)
                return True
            else:
                self.settings = self.default_settings.copy()
                self.save_settings()  # Create the file with defaults
                return False
                
        except (json.JSONDecodeError, IOError) as e:
            self.settings = self.default_settings.copy()
            return False
    
    def save_settings(self) -> bool:
        """Save current settings to file."""
        try:
            # Create directory if it doesn't exist
            os.makedirs(os.path.dirname(self.settings_path), exist_ok=True)
            
            with open(self.settings_path, 'w') as f:
                json.dump(self.settings, f, indent=2, default=str)
            
            return True
            
        except IOError as e:
            return False
    
    def get(self, key_path: str, default: Any = None) -> Any:
        """
        Get a setting value using dot notation.
        Example: get('display.brightness') returns settings['display']['brightness']
        """
        keys = key_path.split('.')
        value = self.settings
        
        try:
            for key in keys:
                value = value[key]
            return value
        except (KeyError, TypeError):
            return default
    
    def set(self, key_path: str, value: Any, save: bool = True) -> bool:
        """
        Set a setting value using dot notation and optionally save to file.
        Example: set('display.brightness', 75) sets settings['display']['brightness'] = 75
        """
        keys = key_path.split('.')
        settings_dict = dict(self.settings)  # Create a copy
        
        # Navigate to the parent of the target key
        current = settings_dict
        for key in keys[:-1]:
            if key not in current:
                current[key] = {}
            current = current[key]
        
        # Set the value
        current[keys[-1]] = value
        
        # Update the settings property (this triggers Kivy events)
        self.settings = settings_dict
        
        if save:
            return self.save_settings()
        return True
    
    def factory_reset(self, save: bool = True) -> bool:
        """Reset all settings to factory defaults."""
        self.settings = self.default_settings.copy()
        
        if save:
            return self.save_settings()
        return True
    
    def backup_settings(self, backup_path: str) -> bool:
        """Create a backup of current settings."""
        try:
            import shutil
            shutil.copy2(self.settings_path, backup_path)
            return True
        except IOError as e:
            return False
    
    def restore_settings(self, backup_path: str) -> bool:
        """Restore settings from a backup file."""
        try:
            import shutil
            shutil.copy2(backup_path, self.settings_path)
            self.load_settings()
            return True
        except IOError as e:
            return False
    
    def export_settings(self, export_path: str) -> bool:
        """Export settings to a JSON file for sharing or backup."""
        try:
            with open(export_path, 'w') as f:
                json.dump(self.settings, f, indent=2, default=str)
            return True
        except IOError as e:
            return False
    
    def import_settings(self, import_path: str, merge: bool = True) -> bool:
        """Import settings from a JSON file."""
        try:
            with open(import_path, 'r') as f:
                imported_settings = json.load(f)
            
            if merge:
                # Merge with current settings
                self.settings = self._merge_settings(self.settings, imported_settings)
            else:
                # Replace all settings
                self.settings = imported_settings
            
            self.save_settings()
            return True
            
        except (json.JSONDecodeError, IOError) as e:
            return False
    
    def _merge_settings(self, base: Dict, override: Dict) -> Dict:
        """Recursively merge two settings dictionaries."""
        result = base.copy()
        
        for key, value in override.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = self._merge_settings(result[key], value)
            else:
                result[key] = value
        
        return result
    
    def get_category(self, category: str) -> Dict[str, Any]:
        """Get all settings for a specific category."""
        return self.settings.get(category, {})
    
    def set_category(self, category: str, values: Dict[str, Any], save: bool = True) -> bool:
        """Set multiple values for a category at once."""
        settings_dict = dict(self.settings)
        settings_dict[category] = values
        self.settings = settings_dict
        
        if save:
            return self.save_settings()
        return True
    
    def reset_category(self, category: str, save: bool = True) -> bool:
        """Reset a specific category to its default values."""
        if category in self.default_settings:
            return self.set_category(category, self.default_settings[category], save)
        return False


# Global settings manager instance
settings_manager = SettingsManager()
