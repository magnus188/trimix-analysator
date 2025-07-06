"""
Platform detection and environment configuration for Trimix Analyzer.
Automatically detects whether to use real hardware or mock sensors.
"""

import os
import platform
from typing import Optional


def is_raspberry_pi() -> bool:
    """
    Detect if running on a Raspberry Pi.
    
    Returns:
        bool: True if running on Raspberry Pi, False otherwise
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
    Check if required hardware modules are available.
    
    Returns:
        bool: True if hardware modules can be imported
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
    Check if running in development mode.
    
    Returns:
        bool: True if in development mode
    """
    env = os.getenv('TRIMIX_ENVIRONMENT', '').lower()
    mock_sensors = os.getenv('TRIMIX_MOCK_SENSORS', '').lower()
    
    # Check if hardware modules are available
    hardware_available = _check_hardware_modules_available()
    
    return (
        env == 'development' or 
        mock_sensors in ('1', 'true', 'yes') or
        (not is_raspberry_pi() and not hardware_available)
    )


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
