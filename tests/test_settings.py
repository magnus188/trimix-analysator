"""
Tests for SimpleSettings management system.
"""

import pytest
from unittest.mock import patch, MagicMock
import threading
import time


class TestSettingsManagement:
    """Test SimpleSettings functionality."""

    @pytest.mark.unit
    def test_simple_settings_get_with_dot_notation(self, mock_database_manager):
        """
        Verify that SimpleSettings.get() retrieves a setting value using dot notation (category.key) from the database.
        """
        from utils.simple_settings import SimpleSettings
        
        # Patch the global db_manager used by SimpleSettings
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            db = mock_database_manager
            settings = SimpleSettings()
            
            # Set a test value in database
            db.set_setting('display', 'brightness', 75)
            
            # Get value using dot notation
            value = settings.get('display.brightness')
            assert value == 75

    @pytest.mark.unit
    def test_simple_settings_get_default_value(self, mock_database_manager):
        """
        Test that SimpleSettings.get() returns the provided default value when a setting does not exist.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            settings = SimpleSettings()
            
            # Get non-existent setting with default
            value = settings.get('nonexistent.setting', 'default_value')
            assert value == 'default_value'

    @pytest.mark.unit
    def test_simple_settings_set_with_dot_notation(self, mock_database_manager):
        """
        Test that the SimpleSettings.set() method correctly stores a value using dot notation and updates the underlying database.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            db = mock_database_manager
            settings = SimpleSettings()
            
            # Set value using dot notation
            success = settings.set('display.brightness', 80)
            assert success == True
            
            # Verify value was set in database
            value = db.get_setting('display', 'brightness')
            assert value == 80

    @pytest.mark.unit
    def test_simple_settings_set_invalid_key(self, mock_database_manager):
        """
        Test that SimpleSettings.set() raises a ValueError when given a key without a category.
        
        Verifies that attempting to set a value with an invalid key format (missing category) results in a ValueError.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            settings = SimpleSettings()
            
            # Should raise ValueError for key without category
            with pytest.raises(ValueError):
                settings.set('invalid_key', 'value')

    @pytest.mark.unit
    def test_simple_settings_get_category(self, mock_database_manager):
        """
        Tests that SimpleSettings.get() returns all key-value pairs for a given category as a dictionary.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            db = mock_database_manager
            settings = SimpleSettings()
            
            # Set multiple values in a category
            db.set_setting('display', 'brightness', 75)
            db.set_setting('display', 'sleep_timeout', 10)
            
            # Get entire category
            category_settings = settings.get('display')
            
            assert isinstance(category_settings, dict)
            assert category_settings['brightness'] == 75
            assert category_settings['sleep_timeout'] == 10

    @pytest.mark.unit
    def test_simple_settings_factory_reset(self, mock_database_manager):
        """
        Tests that the SimpleSettings.factory_reset() method restores settings to their default values and removes any custom values not present in the defaults.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            db = mock_database_manager
            settings = SimpleSettings()
            
            # Set some custom values
            db.set_setting('test', 'custom_value', 'test')
            
            # Perform factory reset
            success = settings.factory_reset()
            assert success == True
            
            # Custom value should be gone (since it's not in defaults)
            value = db.get_setting('test', 'custom_value')
            assert value is None

    @pytest.mark.unit
    def test_simple_settings_default_settings_property(self, mock_database_manager):
        """
        Verify that the SimpleSettings.default_settings property returns a dictionary containing expected categories.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            settings = SimpleSettings()
            
            defaults = settings.default_settings
            assert isinstance(defaults, dict)
            assert 'display' in defaults
            assert 'app' in defaults

    @pytest.mark.unit
    def test_settings_data_type_preservation(self, mock_database_manager):
        """
        Verify that various data types are correctly preserved when storing and retrieving settings using SimpleSettings.
        
        This test sets and retrieves boolean, integer, float, string, dictionary, and list values, asserting that both the value and its type remain unchanged.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            db = mock_database_manager
            settings = SimpleSettings()
            
            # Test different data types
            test_values = {
                'bool_value': True,
                'int_value': 42,
                'float_value': 3.14,
                'str_value': 'hello',
                'dict_value': {'key': 'value'},
                'list_value': [1, 2, 3]
            }
            
            # Set values
            for key, value in test_values.items():
                success = settings.set(f'test.{key}', value)
                assert success == True
            
            # Verify types are preserved
            for key, expected_value in test_values.items():
                retrieved_value = settings.get(f'test.{key}')
                assert retrieved_value == expected_value
                assert type(retrieved_value) == type(expected_value)

    @pytest.mark.unit
    def test_settings_dot_notation_edge_cases(self, mock_database_manager):
        """
        Test that setting and getting keys with multiple dots in dot notation only splits on the first dot.
        
        Verifies that the SimpleSettings class correctly interprets keys with multiple dots by treating only the first dot as the separator between category and key.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            settings = SimpleSettings()
            
            # Test multiple dots (should only split on first)
            success = settings.set('category.sub.key', 'value')
            assert success == True
            
            value = settings.get('category.sub.key')
            assert value == 'value'

    @pytest.mark.unit  
    def test_settings_concurrent_access(self, mock_database_manager):
        """
        Verifies that concurrent threads can safely set and get settings values without data corruption or race conditions.
        """
        from utils.simple_settings import SimpleSettings
        
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            settings = SimpleSettings()
            
            def worker(thread_id):
                """
                Performs repeated set and get operations on a thread-specific settings key to test concurrent access.
                
                Parameters:
                    thread_id (int): Identifier for the thread, used to create a unique settings key.
                """
                for i in range(10):
                    settings.set(f'test.thread_{thread_id}', i)
                    value = settings.get(f'test.thread_{thread_id}')
                    assert value == i
            
            threads = []
            for i in range(3):
                t = threading.Thread(target=worker, args=(i,))
                threads.append(t)
                t.start()
            
            for t in threads:
                t.join()

    @pytest.mark.unit
    def test_settings_global_instance(self, mock_database_manager):
        """
        Verify that the global settings_manager instance can set and retrieve values correctly using the mock database manager.
        """
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            from utils.simple_settings import settings_manager
            
            # Test that global instance works
            success = settings_manager.set('global.test', 'value')
            assert success == True
            
            value = settings_manager.get('global.test')
            assert value == 'value'

    @pytest.mark.integration
    def test_settings_database_integration(self, mock_database_manager):
        """
        Verifies that the settings manager correctly interacts with the database manager by storing values in the database during integration.
        """
        with patch('utils.simple_settings.db_manager', mock_database_manager):
            from utils.simple_settings import settings_manager
            
            # Test that settings manager uses the database
            settings_manager.set('integration.test', 'database_value')
            
            # Should be stored in database
            db_value = mock_database_manager.get_setting('integration', 'test')
            assert db_value == 'database_value'
