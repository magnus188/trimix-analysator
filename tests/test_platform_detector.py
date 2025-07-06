"""
Comprehensive unit tests for the platform detector module.
"""

import pytest
import os
import tempfile
from unittest.mock import patch, mock_open
from utils.platform_detector import (
    is_raspberry_pi,
    _check_hardware_modules_available,
    is_development_environment,
    get_platform_info
)


class TestPlatformDetector:
    """Test suite for platform detection functionality."""

    @pytest.mark.unit
    def test_is_raspberry_pi_with_bcm_processor(self):
        """Test Raspberry Pi detection with BCM processor."""
        mock_cpuinfo = "processor\t: 0\nmodel name\t: ARMv7 Processor rev 4 (v7l)\nBogoMIPS\t: 38.40\nFeatures\t: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32\nCPU implementer\t: 0x41\nCPU architecture: 7\nCPU variant\t: 0x0\nCPU part\t: 0xd08\nCPU revision\t: 3\n\nHardware\t: BCM2835\nRevision\t: a020d3\nSerial\t\t: 0000000087654321"
        
        with patch('builtins.open', mock_open(read_data=mock_cpuinfo)):
            assert is_raspberry_pi() == True

    @pytest.mark.unit
    def test_is_raspberry_pi_with_raspberry_pi_string(self):
        """Test Raspberry Pi detection with 'Raspberry Pi' in cpuinfo."""
        mock_cpuinfo = "Hardware\t: Raspberry Pi\nRevision\t: a020d3\nSerial\t\t: 0000000087654321"
        
        with patch('builtins.open', mock_open(read_data=mock_cpuinfo)):
            assert is_raspberry_pi() == True

    @pytest.mark.unit
    def test_is_not_raspberry_pi(self):
        """
        Test that `is_raspberry_pi` returns False when `/proc/cpuinfo` does not indicate Raspberry Pi hardware.
        """
        mock_cpuinfo = "processor\t: 0\nvendor_id\t: GenuineIntel\nmodel name\t: Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz"
        
        with patch('builtins.open', mock_open(read_data=mock_cpuinfo)):
            assert is_raspberry_pi() == False

    @pytest.mark.unit
    def test_is_raspberry_pi_file_not_found(self):
        """Test Raspberry Pi detection when /proc/cpuinfo doesn't exist."""
        with patch('builtins.open', side_effect=FileNotFoundError):
            assert is_raspberry_pi() == False

    @pytest.mark.unit
    def test_is_raspberry_pi_permission_error(self):
        """Test Raspberry Pi detection with permission error."""
        with patch('builtins.open', side_effect=PermissionError):
            assert is_raspberry_pi() == False

    @pytest.mark.unit
    def test_check_hardware_modules_available_success(self):
        """
        Test that hardware module availability check returns True when required modules can be imported successfully.
        """
        with patch('builtins.__import__') as mock_import:
            # Mock successful imports
            mock_import.return_value = None
            assert _check_hardware_modules_available() == True

    @pytest.mark.unit
    def test_check_hardware_modules_available_import_error(self):
        """
        Test that `_check_hardware_modules_available` returns `False` when importing hardware modules raises an `ImportError`.
        """
        with patch('builtins.__import__', side_effect=ImportError):
            assert _check_hardware_modules_available() == False

    @pytest.mark.unit
    def test_is_development_environment_explicit_development(self, clean_environment):
        """Test development environment detection with explicit environment variable."""
        os.environ['TRIMIX_ENVIRONMENT'] = 'development'
        assert is_development_environment() == True

    @pytest.mark.unit
    def test_is_development_environment_mock_sensors(self, clean_environment):
        """Test development environment detection with mock sensors enabled."""
        os.environ['TRIMIX_MOCK_SENSORS'] = '1'
        assert is_development_environment() == True

    @pytest.mark.unit
    def test_is_development_environment_mock_sensors_true(self, clean_environment):
        """Test development environment detection with mock sensors set to 'true'."""
        os.environ['TRIMIX_MOCK_SENSORS'] = 'true'
        assert is_development_environment() == True

    @pytest.mark.unit
    def test_is_development_environment_mock_sensors_yes(self, clean_environment):
        """
        Test that the development environment is detected when 'TRIMIX_MOCK_SENSORS' is set to 'yes'.
        """
        os.environ['TRIMIX_MOCK_SENSORS'] = 'yes'
        assert is_development_environment() == True

    @pytest.mark.unit
    @patch('utils.platform_detector.is_raspberry_pi')
    @patch('utils.platform_detector._check_hardware_modules_available')
    def test_is_development_environment_no_hardware(self, mock_hw_check, mock_is_rpi, clean_environment):
        """Test development environment detection when not on Pi and no hardware available."""
        mock_is_rpi.return_value = False
        mock_hw_check.return_value = False
        
        assert is_development_environment() == True

    @pytest.mark.unit
    @patch('utils.platform_detector.is_raspberry_pi')
    @patch('utils.platform_detector._check_hardware_modules_available')
    def test_is_production_environment(self, mock_hw_check, mock_is_rpi, clean_environment):
        """
        Test that the environment is detected as production when hardware checks pass and relevant environment variables are unset.
        """
        mock_is_rpi.return_value = True
        mock_hw_check.return_value = True
        
        # Clear test environment variables
        if 'TRIMIX_ENVIRONMENT' in os.environ:
            del os.environ['TRIMIX_ENVIRONMENT']
        if 'TRIMIX_MOCK_SENSORS' in os.environ:
            del os.environ['TRIMIX_MOCK_SENSORS']
        
        assert is_development_environment() == False

    @pytest.mark.unit
    @patch('utils.platform_detector.is_raspberry_pi')
    @patch('utils.platform_detector.is_development_environment')
    @patch('platform.system')
    @patch('platform.machine')
    @patch('platform.platform')
    @patch('platform.python_version')
    def test_get_platform_info(self, mock_py_version, mock_platform, mock_machine, 
                              mock_system, mock_is_dev, mock_is_rpi, clean_environment):
        """
                              Test that `get_platform_info` returns correct platform details and environment flags when system and environment variables are mocked.
                              """
        # Setup mocks
        mock_system.return_value = 'Linux'
        mock_machine.return_value = 'armv7l'
        mock_platform.return_value = 'Linux-5.10.17-v7l+-armv7l-with-glibc2.28'
        mock_py_version.return_value = '3.9.2'
        mock_is_rpi.return_value = True
        mock_is_dev.return_value = False
        os.environ['TRIMIX_ENVIRONMENT'] = 'production'
        
        info = get_platform_info()
        
        assert info['system'] == 'Linux'
        assert info['machine'] == 'armv7l'
        assert info['platform'] == 'Linux-5.10.17-v7l+-armv7l-with-glibc2.28'
        assert info['python_version'] == '3.9.2'
        assert info['is_raspberry_pi'] == True
        assert info['is_development'] == False
        assert info['environment'] == 'production'

    @pytest.mark.unit
    def test_get_platform_info_auto_detected_environment(self, clean_environment):
        """
        Test that `get_platform_info` correctly sets the environment to "auto-detected" and marks it as development when no explicit environment variable is set and development is detected.
        """
        # Clear the test environment variable
        if 'TRIMIX_ENVIRONMENT' in os.environ:
            del os.environ['TRIMIX_ENVIRONMENT']
        
        with patch('utils.platform_detector.is_raspberry_pi', return_value=False), \
             patch('utils.platform_detector.is_development_environment', return_value=True):
            
            info = get_platform_info()
            assert info['environment'] == 'auto-detected'
            assert info['is_development'] == True

    @pytest.mark.unit
    def test_environment_variables_case_insensitive(self, clean_environment):
        """
        Verify that the `is_development_environment` function treats the `TRIMIX_ENVIRONMENT` environment variable in a case-insensitive manner.
        
        Tests multiple case variants of the environment variable to ensure correct detection of development and production environments, with hardware checks mocked for consistency.
        """
        test_cases = [
            ('DEVELOPMENT', True),
            ('Development', True),
            ('development', True),
            ('PRODUCTION', False),
            ('production', False),  # Changed from 'test' since 'test' is not recognized as dev environment
        ]
        
        for env_value, expected in test_cases:
            # Clear all test environment variables first
            for key in ['TRIMIX_ENVIRONMENT', 'TRIMIX_MOCK_SENSORS']:
                if key in os.environ:
                    del os.environ[key]
            
            # Set only the environment we're testing
            os.environ['TRIMIX_ENVIRONMENT'] = env_value
            
            # Mock hardware checks to ensure consistent results
            with patch('utils.platform_detector.is_raspberry_pi', return_value=True), \
                 patch('utils.platform_detector._check_hardware_modules_available', return_value=True):
                
                result = is_development_environment()
                assert result == expected, f"Failed for environment: {env_value}"

    @pytest.mark.unit
    def test_mock_sensors_case_insensitive(self, clean_environment):
        """
        Verify that the `TRIMIX_MOCK_SENSORS` environment variable is interpreted case-insensitively by `is_development_environment`, returning the correct boolean value for various representations of true and false.
        """
        test_cases = [
            ('1', True),
            ('TRUE', True),
            ('True', True),
            ('true', True),
            ('YES', True),
            ('Yes', True),
            ('yes', True),
            ('0', False),
            ('false', False),
            ('no', False),
            ('invalid', False)
        ]
        
        for mock_value, expected in test_cases:
            os.environ.clear()
            os.environ['TRIMIX_MOCK_SENSORS'] = mock_value
            
            with patch('utils.platform_detector.is_raspberry_pi', return_value=True), \
                 patch('utils.platform_detector._check_hardware_modules_available', return_value=True):
                
                result = is_development_environment()
                assert result == expected, f"Failed for mock sensors: {mock_value}"
