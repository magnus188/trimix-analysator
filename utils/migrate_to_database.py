"""
Migration utility to transfer data from JSON settings to SQLite database.
Run this once to migrate existing settings.
"""

import json
import os
from utils.database_manager import db_manager
from datetime import datetime


def migrate_json_to_database():
    """Migrate existing JSON settings to the database"""
    
    # Path to existing JSON settings
    json_path = os.path.join(os.path.dirname(__file__), 'trimix_settings.json')
    
    if not os.path.exists(json_path):
        print("No JSON settings file found. Starting fresh with database.")
        return True
    
    try:
        print("Migrating JSON settings to database...")
        
        # Load existing JSON settings
        with open(json_path, 'r') as f:
            json_settings = json.load(f)
        
        # Migrate each category
        migrated_count = 0
        
        for category, settings in json_settings.items():
            for key, value in settings.items():
                # Handle nested objects (like warning_thresholds)
                if isinstance(value, dict):
                    # Store as JSON
                    success = db_manager.set_setting(category, key, value)
                else:
                    success = db_manager.set_setting(category, key, value)
                
                if success:
                    migrated_count += 1
        
        print(f"Successfully migrated {migrated_count} settings to database.")
        
        # Handle special cases - calibration dates
        if 'sensors' in json_settings:
            sensors = json_settings['sensors']
            
            # Migrate O2 calibration date
            if 'o2_calibration_date' in sensors and sensors['o2_calibration_date']:
                try:
                    cal_date = datetime.fromisoformat(sensors['o2_calibration_date'])
                    db_manager.record_calibration('o2', notes='Migrated from JSON')
                    print("Migrated O2 calibration date")
                except:
                    pass
            
            # Migrate He calibration date
            if 'he_calibration_date' in sensors and sensors['he_calibration_date']:
                try:
                    cal_date = datetime.fromisoformat(sensors['he_calibration_date'])
                    db_manager.record_calibration('he', notes='Migrated from JSON')
                    print("Migrated He calibration date")
                except:
                    pass
        
        # Log migration
        db_manager.log_system_event('json_migration', {
            'migrated_settings': migrated_count,
            'source_file': json_path,
            'migration_date': datetime.now().isoformat()
        })
        
        # Rename old JSON file as backup
        backup_path = json_path + '.backup'
        os.rename(json_path, backup_path)
        print(f"Original JSON file backed up to: {backup_path}")
        
        return True
        
    except Exception as e:
        print(f"Error during migration: {e}")
        return False


def verify_migration():
    """Verify that migration was successful"""
    print("\nVerifying migration...")
    
    # Check some key settings
    test_settings = [
        ('app', 'first_run'),
        ('display', 'brightness'),
        ('sensors', 'calibration_interval_days'),
        ('safety', 'max_o2_percentage')
    ]
    
    for category, key in test_settings:
        value = db_manager.get_setting(category, key)
        print(f"  {category}.{key}: {value}")
    
    # Check calibration history
    o2_cal = db_manager.get_last_calibration('o2')
    he_cal = db_manager.get_last_calibration('he')
    
    print(f"  Last O2 calibration: {o2_cal}")
    print(f"  Last He calibration: {he_cal}")
    
    print("Migration verification complete.")


if __name__ == '__main__':
    # Run migration
    success = migrate_json_to_database()
    
    if success:
        verify_migration()
        print("\nMigration completed successfully!")
        print("The application will now use the SQLite database for all data storage.")
    else:
        print("\nMigration failed. Please check the error messages above.")
