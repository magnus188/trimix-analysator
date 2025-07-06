"""
SQLite database manager for the Trimix app.
Provides robust, persistent storage for all application data including settings,
calibration history, and system state.
"""

import sqlite3
import json
import os
from datetime import datetime
from typing import Any, Dict, Optional, List, Tuple
from kivy.event import EventDispatcher
from kivy.logger import Logger

from version import __version__


class DatabaseManager(EventDispatcher):
    """
    SQLite-based database manager for persistent storage of all app data.
    Provides atomic transactions, data integrity, and robust storage.
    """
    
    def __init__(self, db_path: str = None):
        super().__init__()
        
        # Default database location in user's home directory
        if db_path is None:
            db_path = os.path.join(os.path.expanduser('~'), '.trimix_data.db')
        
        self.db_path = db_path
        self.connection = None
        
        # Initialize database
        self.init_database()
        
        # Register events
        self.register_event_type('on_data_changed')
    
    def init_database(self):
        """Initialize the database with required tables"""
        try:
            self.connection = sqlite3.connect(self.db_path, check_same_thread=False)
            self.connection.row_factory = sqlite3.Row  # Enable column access by name
            
            cursor = self.connection.cursor()
            
            # Settings table for all application settings
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS settings (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    category TEXT NOT NULL,
                    key TEXT NOT NULL,
                    value TEXT NOT NULL,
                    data_type TEXT NOT NULL,  -- 'str', 'int', 'float', 'bool', 'json'
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    UNIQUE(category, key)
                )
            ''')
            
            # Calibration history table
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS calibration_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    sensor_type TEXT NOT NULL,  -- 'o2' or 'he'
                    calibration_date TIMESTAMP NOT NULL,
                    voltage_reading REAL,
                    temperature REAL,
                    notes TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')
            
            # System events table for audit trail
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS system_events (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    event_type TEXT NOT NULL,  -- 'startup', 'calibration', 'factory_reset', etc.
                    event_data TEXT,  -- JSON data
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            ''')
            
            # Gas analysis history
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS gas_analysis (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    o2_percentage REAL NOT NULL,
                    he_percentage REAL NOT NULL,
                    n2_percentage REAL NOT NULL,
                    analysis_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    notes TEXT
                )
            ''')
            
            # Create indexes for performance
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_settings_category_key ON settings(category, key)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_calibration_sensor_date ON calibration_history(sensor_type, calibration_date)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_system_events_type ON system_events(event_type)')
            cursor.execute('CREATE INDEX IF NOT EXISTS idx_gas_analysis_date ON gas_analysis(analysis_date)')
            
            self.connection.commit()
            
            # Initialize default settings if this is first run
            self._initialize_default_settings()
            
            Logger.info(f"DatabaseManager: Database initialized at {self.db_path}")
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error initializing database: {e}")
            raise
    
    def _initialize_default_settings(self):
        """
        Insert default application settings into the database if no settings exist.
        
        This method checks if the settings table is empty and, if so, populates it with a predefined set of default settings for all categories. It also logs a 'first_run' system event with the current timestamp.
        """
        cursor = self.connection.cursor()
        
        # Check if settings exist
        cursor.execute('SELECT COUNT(*) FROM settings')
        count = cursor.fetchone()[0]
        
        if count == 0:
            # First run - initialize with defaults
            default_settings = {
                'app': {
                    'first_run': True,
                    'app_version': __version__,
                    'theme': 'dark',
                    'language': 'en',
                    'debug_mode': False,
                    'last_screen': 'home'
                },
                'display': {
                    'brightness': 50,
                    'sleep_timeout': 5,
                    'auto_brightness': False
                },
                'wifi': {
                    'auto_connect': True,
                    'remember_networks': True,
                    'scan_interval': 30,
                    'last_network': None
                },
                'sensors': {
                    'calibration_interval_days': 30,
                    'auto_calibration_reminder': True,
                    'o2_calibration_offset': 0.0,
                    'he_calibration_offset': 0.0,
                    'auto_calibrate': True
                },
                'safety': {
                    'max_o2_percentage': 100,
                    'max_he_percentage': 100,
                    'warning_thresholds': {
                        'high_o2': 23.0,
                        'low_o2': 19.0,
                        'high_he': 50.0
                    }
                },
                'units': {
                    'pressure': 'bar',
                    'temperature': 'celsius',
                    'depth': 'meters'
                }
            }
            
            # Insert default settings
            for category, settings in default_settings.items():
                for key, value in settings.items():
                    self.set_setting(category, key, value)
            
            # Log first run
            self.log_system_event('first_run', {'timestamp': datetime.now().isoformat()})
    
    def set_setting(self, category: str, key: str, value: Any) -> bool:
        """Set a setting value"""
        try:
            cursor = self.connection.cursor()
            
            # Determine data type and serialize value
            if isinstance(value, bool):
                data_type = 'bool'
                value_str = str(value)
            elif isinstance(value, int):
                data_type = 'int'
                value_str = str(value)
            elif isinstance(value, float):
                data_type = 'float'
                value_str = str(value)
            elif isinstance(value, (dict, list)):
                data_type = 'json'
                value_str = json.dumps(value)
            else:
                data_type = 'str'
                value_str = str(value)
            
            # Upsert setting
            cursor.execute('''
                INSERT OR REPLACE INTO settings (category, key, value, data_type, updated_at)
                VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
            ''', (category, key, value_str, data_type))
            
            self.connection.commit()
            
            # Dispatch change event
            self.dispatch('on_data_changed', 'setting', f"{category}.{key}", value)
            
            return True
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error setting {category}.{key}: {e}")
            return False
    
    def get_setting(self, category: str, key: str, default: Any = None) -> Any:
        """Get a setting value"""
        try:
            cursor = self.connection.cursor()
            
            cursor.execute('''
                SELECT value, data_type FROM settings 
                WHERE category = ? AND key = ?
            ''', (category, key))
            
            result = cursor.fetchone()
            
            if result is None:
                return default
            
            value_str, data_type = result
            
            # Deserialize based on data type
            if data_type == 'bool':
                return value_str.lower() == 'true'
            elif data_type == 'int':
                return int(value_str)
            elif data_type == 'float':
                return float(value_str)
            elif data_type == 'json':
                return json.loads(value_str)
            else:
                return value_str
                
        except Exception as e:
            Logger.error(f"DatabaseManager: Error getting {category}.{key}: {e}")
            return default
    
    def get_settings_category(self, category: str) -> Dict[str, Any]:
        """Get all settings in a category"""
        try:
            cursor = self.connection.cursor()
            
            cursor.execute('''
                SELECT key, value, data_type FROM settings 
                WHERE category = ?
                ORDER BY key
            ''', (category,))
            
            settings = {}
            for row in cursor.fetchall():
                key, value_str, data_type = row
                
                # Deserialize based on data type
                if data_type == 'bool':
                    value = value_str.lower() == 'true'
                elif data_type == 'int':
                    value = int(value_str)
                elif data_type == 'float':
                    value = float(value_str)
                elif data_type == 'json':
                    value = json.loads(value_str)
                else:
                    value = value_str
                
                settings[key] = value
            
            return settings
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error getting category {category}: {e}")
            return {}
    
    def record_calibration(self, sensor_type: str, voltage_reading: float = None, 
                          temperature: float = None, notes: str = None) -> bool:
        """Record a sensor calibration"""
        try:
            cursor = self.connection.cursor()
            
            # Insert calibration record
            cursor.execute('''
                INSERT INTO calibration_history 
                (sensor_type, calibration_date, voltage_reading, temperature, notes)
                VALUES (?, ?, ?, ?, ?)
            ''', (sensor_type, datetime.now(), voltage_reading, temperature, notes))
            
            self.connection.commit()
            
            # Log system event
            self.log_system_event('calibration', {
                'sensor_type': sensor_type,
                'voltage_reading': voltage_reading,
                'temperature': temperature
            })
            
            # Dispatch change event
            self.dispatch('on_data_changed', 'calibration', sensor_type, datetime.now())
            
            return True
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error recording calibration: {e}")
            return False
    
    def get_last_calibration(self, sensor_type: str) -> Optional[datetime]:
        """Get the date of the last calibration for a sensor"""
        try:
            cursor = self.connection.cursor()
            
            cursor.execute('''
                SELECT calibration_date FROM calibration_history 
                WHERE sensor_type = ? 
                ORDER BY calibration_date DESC 
                LIMIT 1
            ''', (sensor_type,))
            
            result = cursor.fetchone()
            
            if result:
                return datetime.fromisoformat(result[0])
            
            return None
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error getting last calibration: {e}")
            return None
    
    def get_calibration_history(self, sensor_type: str = None, limit: int = 100) -> List[Dict]:
        """Get calibration history"""
        try:
            cursor = self.connection.cursor()
            
            if sensor_type:
                cursor.execute('''
                    SELECT * FROM calibration_history 
                    WHERE sensor_type = ? 
                    ORDER BY calibration_date DESC 
                    LIMIT ?
                ''', (sensor_type, limit))
            else:
                cursor.execute('''
                    SELECT * FROM calibration_history 
                    ORDER BY calibration_date DESC 
                    LIMIT ?
                ''', (limit,))
            
            history = []
            for row in cursor.fetchall():
                history.append({
                    'id': row['id'],
                    'sensor_type': row['sensor_type'],
                    'calibration_date': row['calibration_date'],
                    'voltage_reading': row['voltage_reading'],
                    'temperature': row['temperature'],
                    'notes': row['notes'],
                    'created_at': row['created_at']
                })
            
            return history
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error getting calibration history: {e}")
            return []
    
    def log_system_event(self, event_type: str, event_data: Dict = None) -> bool:
        """Log a system event"""
        try:
            cursor = self.connection.cursor()
            
            event_data_json = json.dumps(event_data) if event_data else None
            
            cursor.execute('''
                INSERT INTO system_events (event_type, event_data)
                VALUES (?, ?)
            ''', (event_type, event_data_json))
            
            self.connection.commit()
            return True
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error logging system event: {e}")
            return False
    
    def factory_reset(self) -> bool:
        """Perform factory reset - clear all data and reinitialize"""
        try:
            cursor = self.connection.cursor()
            
            # Log factory reset before clearing data
            self.log_system_event('factory_reset', {'timestamp': datetime.now().isoformat()})
            
            # Clear all tables
            cursor.execute('DELETE FROM settings')
            cursor.execute('DELETE FROM calibration_history')
            cursor.execute('DELETE FROM gas_analysis')
            # Keep system_events for audit trail
            
            self.connection.commit()
            
            # Reinitialize default settings
            self._initialize_default_settings()
            
            # Dispatch change event
            self.dispatch('on_data_changed', 'factory_reset', None, None)
            
            return True
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error during factory reset: {e}")
            return False
    
    def backup_database(self, backup_path: str) -> bool:
        """Create a backup of the database"""
        try:
            import shutil
            shutil.copy2(self.db_path, backup_path)
            
            self.log_system_event('backup_created', {'backup_path': backup_path})
            
            return True
            
        except Exception as e:
            Logger.error(f"DatabaseManager: Error creating backup: {e}")
            return False
    
    def close(self):
        """Close database connection"""
        if self.connection:
            self.connection.close()
            self.connection = None
    
    def on_data_changed(self, data_type: str, key: str, value: Any):
        """Event handler for data changes. Override in subclasses."""
        pass
    
    def __del__(self):
        """Cleanup on deletion"""
        self.close()

    def get_default_settings(self) -> Dict[str, Any]:
        """
        Return the default settings dictionary used to initialize the application's configuration.
        
        Returns:
            Dict[str, Any]: A nested dictionary containing default values for app, display, wifi, sensors, safety, and units settings.
        """
        return {
            'app': {
                'first_run': True,
                'app_version': __version__,
                'theme': 'dark',
                'language': 'en',
                'debug_mode': False,
                'last_screen': 'home'
            },
            'display': {
                'brightness': 50,
                'sleep_timeout': 5,
                'auto_brightness': False
            },
            'wifi': {
                'auto_connect': True,
                'remember_networks': True,
                'scan_interval': 30,
                'last_network': None
            },
            'sensors': {
                'calibration_interval_days': 30,
                'auto_calibration_reminder': True,
                'o2_calibration_offset': 0.0,
                'he_calibration_offset': 0.0,
                'auto_calibrate': True
            },
            'safety': {
                'max_o2_percentage': 100,
                'max_he_percentage': 100,
                'warning_thresholds': {
                    'high_o2': 23.0,
                    'low_o2': 19.0,
                    'high_he': 50.0
                }
            },
            'units': {
                'pressure': 'bar',
                'temperature': 'celsius',
                'depth': 'meters'
            }
        }


# Global database manager instance
db_manager = DatabaseManager()
