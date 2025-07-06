#!/usr/bin/env python3
"""
Health check script for Trimix Analyzer Docker container.
Verifies that the application is running and sensors are accessible.
"""

import sys
import os
import time
import subprocess

def check_app_process():
    """Check if main.py process is running."""
    try:
        result = subprocess.run(['pgrep', '-f', 'python.*main.py'], 
                              capture_output=True, text=True)
        return result.returncode == 0
    except Exception:
        return False

def check_sensor_access():
    """Check if sensors are accessible."""
    try:
        # Try to import and initialize sensors
        sys.path.append('/app')
        from utils.sensor_interface import get_sensors
        
        sensors = get_sensors()
        
        # Try to read one sensor value
        temp = sensors.read_temperature_c()
        
        # Basic sanity check
        return -50 <= temp <= 100  # Reasonable temperature range
        
    except Exception as e:
        print(f"Sensor check failed: {e}")
        return False

def check_i2c_devices():
    """Check if I2C devices are accessible (production only)."""
    mock_sensors = os.getenv('TRIMIX_MOCK_SENSORS', '0').lower()
    
    if mock_sensors in ('1', 'true', 'yes'):
        return True  # Skip I2C check in development
    
    try:
        # Check if I2C devices are detected
        result = subprocess.run(['i2cdetect', '-y', '1'], 
                              capture_output=True, text=True)
        
        # Look for expected I2C addresses (0x48 for ADS1115, 0x76/0x77 for BME280)
        output = result.stdout
        return '48' in output and ('76' in output or '77' in output)
        
    except Exception:
        return True  # Don't fail health check if i2cdetect not available

def main():
    """Run all health checks."""
    checks = [
        ("Application Process", check_app_process),
        ("Sensor Access", check_sensor_access),
        ("I2C Devices", check_i2c_devices),
    ]
    
    failed_checks = []
    
    for name, check_func in checks:
        try:
            if not check_func():
                failed_checks.append(name)
                print(f"❌ {name} check failed")
            else:
                print(f"✅ {name} check passed")
        except Exception as e:
            failed_checks.append(name)
            print(f"❌ {name} check error: {e}")
    
    if failed_checks:
        print(f"Health check failed: {', '.join(failed_checks)}")
        sys.exit(1)
    else:
        print("🟢 All health checks passed")
        sys.exit(0)

if __name__ == "__main__":
    main()
