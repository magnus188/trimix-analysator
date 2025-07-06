"""
Legacy sensor interface - now redirects to the new sensor_interface module.
This maintains backward compatibility while using the new hardware abstraction.
"""

# Import everything from the new sensor interface
from utils.sensor_interface import (
    get_readings,
    record_readings, 
    get_history,
    read_oxygen_voltage,
    read_oxygen_percent,
    read_temperature_c,
    read_pressure_hpa,
    read_humidity_pct,
    update_v_air_calibration,
    get_v_air_calibration
)