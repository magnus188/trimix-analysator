#!/usr/bin/env python3
"""
Quick test to verify pressure units are in BAR.
"""

import os
os.environ['TRIMIX_MOCK_SENSORS'] = '1'

from utils.sensor_interface import get_readings, record_readings, get_history

def test_pressure_units():
    """Test that pressure is returned in BAR units"""
    # Record some readings
    for i in range(5):
        record_readings()
    
    # Get current readings
    readings = get_readings()
    pressure = readings['press']
    
    print(f"Current pressure reading: {pressure} BAR")
    
    # Pressure should be around 1.0 BAR (atmospheric pressure) for mock sensors
    if 0.8 <= pressure <= 1.2:
        print("✅ Pressure is correctly in BAR units")
    else:
        print(f"❌ Pressure seems wrong: {pressure} (expected ~1.0 BAR)")
        
    # Test history
    history = get_history('press')
    if history:
        print(f"Pressure history has {len(history)} entries")
        print(f"Latest pressure in history: {history[-1][1]:.3f} BAR")
        print("✅ Graph data is available")
    else:
        print("❌ No pressure history available")

if __name__ == '__main__':
    test_pressure_units()
