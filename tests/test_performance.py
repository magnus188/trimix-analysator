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
        """Benchmark sensor reading performance."""
        
        def read_sensors():
            return get_readings()
        
        # Benchmark the sensor reading function
        result = benchmark(read_sensors)
        
        # Verify result is valid
        assert isinstance(result, dict)
        assert len(result) > 0

    @pytest.mark.slow
    @pytest.mark.performance
    def test_database_write_performance(self, benchmark, mock_database_manager):
        """Benchmark database write performance."""
        
        def write_to_database():
            db_manager.set_setting('performance', 'test_key', 'test_value')
            return True
        
        # Benchmark the database write function
        result = benchmark(write_to_database)
        assert result == True

    @pytest.mark.slow
    @pytest.mark.performance
    def test_database_read_performance(self, benchmark, mock_database_manager):
        """Benchmark database read performance."""
        
        # Setup test data
        db_manager.set_setting('performance', 'read_test', 'read_value')
        
        def read_from_database():
            return db_manager.get_setting('performance', 'read_test')
        
        # Benchmark the database read function
        result = benchmark(read_from_database)
        assert result == 'read_value'

    @pytest.mark.slow
    @pytest.mark.performance
    def test_sensor_recording_batch_performance(self, benchmark):
        """Benchmark batch sensor recording performance."""
        
        def record_batch():
            for _ in range(10):
                record_readings()
            return True
        
        # Benchmark batch recording
        result = benchmark(record_batch)
        assert result == True

    @pytest.mark.slow
    @pytest.mark.performance
    def test_settings_access_performance(self, benchmark, mock_database_manager):
        """Benchmark settings access performance."""
        
        # Setup test settings
        for i in range(10):
            db_manager.set_setting('perf_test', f'key_{i}', f'value_{i}')
        
        def access_settings():
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
        """Benchmark calibration history retrieval performance."""
        
        # Setup test calibration data
        for i in range(50):
            db_manager.record_calibration(
                'o2',
                voltage_reading=1.5 + (i * 0.01),
                temperature=25.0,
                notes=f'Test calibration {i}'
            )
        
        def get_calibration_history():
            return db_manager.get_calibration_history('o2', limit=20)
        
        # Benchmark calibration history retrieval
        result = benchmark(get_calibration_history)
        assert len(result) <= 20

    @pytest.mark.slow
    @pytest.mark.performance
    def test_memory_usage_sensor_readings(self):
        """Test memory usage during continuous sensor readings."""
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
        """Benchmark database transaction performance."""
        
        def perform_transaction():
            # Simulate a complex transaction
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
        """Test performance under concurrent sensor access."""
        import threading
        import time
        
        results = []
        errors = []
        
        def read_sensors_repeatedly():
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
        """Test performance with large datasets."""
        
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
        """Test application startup performance."""
        
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
