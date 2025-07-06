"""
Platform detection and environment configuration for Trimix Analyzer.
Automatically detects whether to use real hardware or mock sensors.
"""

import os
import platform
from typing import Optional


def is_raspberry_pi() -> bool:
    """
    Detects if the current system is a Raspberry Pi by examining the contents of `/proc/cpuinfo`.
    
    Returns:
        bool: True if the system is identified as a Raspberry Pi, otherwise False.
    """
    try:
        # Check /proc/cpuinfo for BCM (Broadcom) processor
        with open('/proc/cpuinfo', 'r') as f:
            cpuinfo = f.read()
            return 'BCM' in cpuinfo or 'Raspberry Pi' in cpuinfo
    except (FileNotFoundError, PermissionError):
        return False


def _check_hardware_modules_available() -> bool:
    """
    Determine if required hardware modules for hardware access are available for import.
    
    Returns:
        True if the modules `board`, `busio`, and `digitalio` can be successfully imported; otherwise, False.
    """
    try:
        import board
        import busio
        import digitalio
        return True
    except ImportError:
        return False


def is_development_environment() -> bool:
    """
    Determine whether the current environment should be considered development mode.
    
    Returns:
        bool: True if the environment variable `TRIMIX_ENVIRONMENT` is set to "development", if `TRIMIX_MOCK_SENSORS` is set to "1", "true", or "yes", or if running on a non-Raspberry Pi platform without required hardware modules; otherwise, False.
    """
    env = os.getenv('TRIMIX_ENVIRONMENT', '').lower()
    mock_sensors = os.getenv('TRIMIX_MOCK_SENSORS', '').lower()
    
    # Explicit environment variables take priority
    if env == 'development':
        return True
    if env == 'production':
        return False
    if mock_sensors in ('1', 'true', 'yes'):
        return True
    if mock_sensors in ('0', 'false', 'no'):
        return False
    
    # Fall back to hardware detection only if no explicit environment is set
    hardware_available = _check_hardware_modules_available()
    return not is_raspberry_pi() and not hardware_available


def get_platform_info() -> dict:
    """
    Get detailed platform information.
    
    Returns:
        dict: Platform details
    """
    return {
        'system': platform.system(),
        'machine': platform.machine(),
        'platform': platform.platform(),
        'is_raspberry_pi': is_raspberry_pi(),
        'is_development': is_development_environment(),
        'python_version': platform.python_version(),
        'environment': os.getenv('TRIMIX_ENVIRONMENT', 'auto-detected'),
    }
