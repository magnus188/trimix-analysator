"""
Performance and benchmark tests for the Trimix Analyzer.
These tests measure performance characteristics of critical components.
"""

import pytest
import time
from utils.sensor_interface import get_readings, record_readings
from utils.database_manager import db_manager


class TestPerformance:
    """Performance test suite."""

    @pytest.mark.slow
    @pytest.mark.performance
    def test_sensor_reading_performance(self, benchmark):
        """
        Benchmarks the performance of the sensor reading operation using `get_readings()`.
        
        Asserts that the result is a non-empty dictionary to verify correct sensor data retrieval.
        """
        
        def read_sensors():
            """
            Retrieve the latest sensor readings as a dictionary.
            
            Returns:
                dict: A dictionary containing the most recent sensor readings.
            """
            return get_readings()
        
        # Benchmark the sensor reading function
        result = benchmark(read_sensors)
        
        # Verify result is valid
        assert isinstance(result, dict)
        assert len(result) > 0

    @pytest.mark.slow
    @pytest.mark.performance
    def test_database_write_performance(self, benchmark, mock_database_manager):
        """
        Benchmarks the performance of writing a setting to the database.
        
        Asserts that the write operation completes successfully.
        """
        
        def write_to_database():
            """
            Writes a test key-value pair to the 'performance' category in the database.
            
            Returns:
                bool: True if the write operation was performed.
            """
            db_manager.set_setting('performance', 'test_key', 'test_value')
            return True
        
        # Benchmark the database write function
        result = benchmark(write_to_database)
        assert result == True

    @pytest.mark.slow
    @pytest.mark.performance
    def test_database_read_performance(self, benchmark, mock_database_manager):
        """
        Benchmarks the performance of reading a setting from the database and verifies the retrieved value matches the expected result.
        """
        
        # Setup test data
        db_manager.set_setting('performance', 'read_test', 'read_value')
        
        def read_from_database():
            """
            Retrieve the value of the 'read_test' setting from the 'performance' category in the database.
            
            Returns:
                The value associated with the 'read_test' key in the 'performance' category.
            """
            return db_manager.get_setting('performance', 'read_test')
        
        # Benchmark the database read function
        result = benchmark(read_from_database)
        assert result == 'read_value'

    @pytest.mark.slow
    @pytest.mark.performance
    def test_sensor_recording_batch_performance(self, benchmark):
        """
        Benchmarks the performance of recording sensor readings in batches.
        
        This test measures the time taken to perform 10 consecutive sensor reading recordings as a batch operation and asserts that the batch completes successfully.
        """
        
        def record_batch():
            """
            Record sensor readings in a batch by invoking the reading function 10 times.
            
            Returns:
                bool: True after all readings have been recorded.
            """
            for _ in range(10):
                record_readings()
            return True
        
        # Benchmark batch recording
        result = benchmark(record_batch)
        assert result == True

    @pytest.mark.slow
    @pytest.mark.performance
    def test_settings_access_performance(self, benchmark, mock_database_manager):
        """
        Benchmarks the performance of sequentially accessing 10 settings from the database.
        
        Asserts that all 10 settings are successfully retrieved.
        """
        
        # Setup test settings
        for i in range(10):
            db_manager.set_setting('perf_test', f'key_{i}', f'value_{i}')
        
        def access_settings():
            """
            Retrieve a list of 10 settings from the 'perf_test' category in the database.
            
            Returns:
                list: The values of settings 'key_0' through 'key_9' from the 'perf_test' category.
            """
            results = []
            for i in range(10):
                value = db_manager.get_setting('perf_test', f'key_{i}')
                results.append(value)
            return results
        
        # Benchmark settings access
        result = benchmark(access_settings)
        assert len(result) == 10

    @pytest.mark.slow
    @pytest.mark.performance
    def test_calibration_history_performance(self, benchmark, mock_database_manager):
        """
        Benchmarks the performance of retrieving the last 20 calibration history records for the 'o2' sensor after recording 50 calibration entries.
        
        Asserts that the number of records retrieved does not exceed 20.
        """
        
        # Setup test calibration data
        for i in range(50):
            db_manager.record_calibration(
                'o2',
                voltage_reading=1.5 + (i * 0.01),
                temperature=25.0,
                notes=f'Test calibration {i}'
            )
        
        def get_calibration_history():
            """
            Retrieve the most recent 20 calibration history records for the 'o2' sensor.
            
            Returns:
                list: A list of calibration record entries for the 'o2' sensor, limited to 20 most recent records.
            """
            return db_manager.get_calibration_history('o2', limit=20)
        
        # Benchmark calibration history retrieval
        result = benchmark(get_calibration_history)
        assert len(result) <= 20

    @pytest.mark.slow
    @pytest.mark.performance
    def test_memory_usage_sensor_readings(self):
        """
        Measures memory usage before and after performing 1000 consecutive sensor readings to ensure that memory consumption does not increase excessively.
        """
        import psutil
        import os
        
        process = psutil.Process(os.getpid())
        initial_memory = process.memory_info().rss
        
        # Perform many sensor readings
        for _ in range(1000):
            readings = get_readings()
            assert isinstance(readings, dict)
        
        final_memory = process.memory_info().rss
        memory_increase = final_memory - initial_memory
        
        # Memory increase should be reasonable (less than 10MB)
        assert memory_increase < 10 * 1024 * 1024, f"Memory increased by {memory_increase / 1024 / 1024:.2f}MB"

    @pytest.mark.slow
    @pytest.mark.performance
    def test_database_transaction_performance(self, benchmark, mock_database_manager):
        """
        Benchmarks the performance of a simulated complex database transaction involving multiple setting writes.
        
        Asserts that the transaction completes successfully.
        """
        
        def perform_transaction():
            # Simulate a complex transaction
            """
            Performs a simulated complex database transaction by writing multiple settings in sequence.
            
            Returns:
                bool: True if the transaction completes successfully.
            """
            db_manager.set_setting('transaction', 'start', 'begin')
            
            for i in range(5):
                db_manager.set_setting('transaction', f'item_{i}', f'value_{i}')
            
            db_manager.set_setting('transaction', 'end', 'complete')
            return True
        
        # Benchmark the transaction
        result = benchmark(perform_transaction)
        assert result == True

    @pytest.mark.slow
    @pytest.mark.performance
    @pytest.mark.stress
    def test_concurrent_sensor_access(self):
        """
        Tests sensor reading performance and correctness under concurrent access by running multiple threads, each performing repeated sensor readings. Asserts that all readings complete without errors, the expected number of results is collected, and total execution time remains within acceptable limits.
        """
        import threading
        import time
        
        results = []
        errors = []
        
        def read_sensors_repeatedly():
            """
            Performs 100 consecutive sensor readings, appending each result to the global `results` list with a short delay between readings. Any exceptions encountered are appended to the global `errors` list.
            """
            try:
                for _ in range(100):
                    readings = get_readings()
                    results.append(readings)
                    time.sleep(0.001)  # Small delay
            except Exception as e:
                errors.append(e)
        
        # Create multiple threads
        threads = []
        for _ in range(5):
            thread = threading.Thread(target=read_sensors_repeatedly)
            threads.append(thread)
        
        # Start all threads
        start_time = time.time()
        for thread in threads:
            thread.start()
        
        # Wait for all threads to complete
        for thread in threads:
            thread.join()
        
        end_time = time.time()
        total_time = end_time - start_time
        
        # Verify results
        assert len(errors) == 0, f"Errors occurred: {errors}"
        assert len(results) == 500  # 5 threads * 100 readings each
        assert total_time < 30, f"Concurrent access took too long: {total_time:.2f}s"

    @pytest.mark.slow
    @pytest.mark.performance
    def test_large_dataset_performance(self, mock_database_manager):
        """
        Benchmark database write and read performance with a large dataset of 500 key-value pairs.
        
        Writes 500 settings to the database under a specific category, measures the time taken for both writing and reading all settings, and asserts that performance and data integrity meet expected thresholds.
        """
        
        # Create a smaller dataset for CI (500 instead of 1000)
        num_items = 500
        start_time = time.time()
        
        for i in range(num_items):
            db_manager.set_setting('large_test', f'key_{i}', f'value_{i}')
        
        write_time = time.time() - start_time
        
        # Read back all settings
        start_time = time.time()
        
        category_settings = db_manager.get_settings_category('large_test')
        
        read_time = time.time() - start_time
        
        # Verify results
        assert len(category_settings) == num_items
        
        # More relaxed performance assertions (adjusted for CI environments)
        assert write_time < 15.0, f"Writing {num_items} settings took too long: {write_time:.2f}s"
        assert read_time < 2.0, f"Reading {num_items} settings took too long: {read_time:.2f}s"

    @pytest.mark.slow
    @pytest.mark.performance
    def test_startup_performance(self):
        """
        Measures the time required to perform a simulated application startup sequence and verifies that initialization of platform detection, database settings retrieval, and sensor interface completes within 2 seconds.
        
        Asserts that all components are initialized correctly and that startup performance meets the specified threshold.
        """
        
        start_time = time.time()
        
        # Simulate app startup sequence
        from utils.platform_detector import get_platform_info
        from utils.database_manager import db_manager
        from utils.sensor_interface import get_sensors
        
        # Platform detection
        platform_info = get_platform_info()
        
        # Database initialization (already done, but measure access)
        settings = db_manager.get_settings_category('app')
        
        # Sensor interface initialization
        sensors = get_sensors()
        
        startup_time = time.time() - start_time
        
        # Verify components are working
        assert isinstance(platform_info, dict)
        assert isinstance(settings, dict)
        assert sensors is not None
        
        # Startup should be fast (less than 2 seconds)
        assert startup_time < 2.0, f"Startup took too long: {startup_time:.2f}s"
