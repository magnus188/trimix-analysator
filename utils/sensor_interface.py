"""
Sensor interface abstraction for Trimix Analyzer.
Provides both real hardware and mock implementations.
"""

from abc import ABC, abstractmethod
from typing import Dict, Optional
import time
import random
import math
from utils.platform_detector import is_development_environment


class SensorInterface(ABC):
    """Abstract base class for sensor implementations."""
    
    @abstractmethod
    def read_oxygen_voltage(self) -> float:
        """Read raw O2 voltage."""
        pass
    
    @abstractmethod
    def read_oxygen_percent(self) -> float:
        """Read O2 percentage."""
        pass
    
    @abstractmethod
    def read_co2_voltage(self) -> float:
        """Read raw CO2 voltage."""
        pass
    
    @abstractmethod
    def read_co2_ppm(self) -> float:
        """Read CO2 in PPM."""
        pass
    
    @abstractmethod
    def read_temperature_c(self) -> float:
        """Read temperature in Celsius."""
        pass
    
    @abstractmethod
    def read_pressure_hpa(self) -> float:
        """Read pressure in hPa."""
        pass
    
    @abstractmethod
    def read_humidity_pct(self) -> float:
        """Read humidity percentage."""
        pass
    
    @abstractmethod
    def is_power_button_pressed(self) -> bool:
        """Check if power button is pressed."""
        pass


class MockSensors(SensorInterface):
    """Mock sensor implementation for development."""
    
    def __init__(self):
        self.start_time = time.time()
        self._power_button_state = False
    
    def read_oxygen_voltage(self) -> float:
        # Simulate realistic O2 voltage with some noise
        base = 0.0095  # ~20.9% O2 in air
        noise = random.uniform(-0.0002, 0.0002)
        return base + noise
    
    def read_oxygen_percent(self) -> float:
        voltage = self.read_oxygen_voltage()
        return (voltage / 0.0095) * 20.9
    
    def read_co2_voltage(self) -> float:
        # Simulate CO2 sensor voltage (0-3.3V for 0-5000ppm)
        base = 0.4  # ~400ppm ambient CO2
        variation = 0.1 * random.uniform(-1, 1)
        return base + variation
    
    def read_co2_ppm(self) -> float:
        voltage = self.read_co2_voltage()
        # Convert voltage to PPM (example calibration)
        return (voltage / 3.3) * 5000
    
    def read_temperature_c(self) -> float:
        # Simulate room temperature with daily variation
        elapsed = time.time() - self.start_time
        daily_cycle = 2 + 1.5 * (math.sin(elapsed / 86400 * 2 * math.pi))
        noise = random.uniform(-0.5, 0.5)
        return 20.0 + daily_cycle + noise
    
    def read_pressure_hpa(self) -> float:
        # Simulate atmospheric pressure in BAR (consistent with real sensors)
        base = 1.01325  # 1 atmosphere in BAR
        variation = random.uniform(-0.002, 0.002)  # Small variation in BAR
        return base + variation
    
    def read_humidity_pct(self) -> float:
        # Simulate humidity
        base = 45.0
        variation = random.uniform(-5, 5)
        return max(0, min(100, base + variation))
    
    def is_power_button_pressed(self) -> bool:
        # Simulate random button presses for testing
        if random.random() < 0.001:  # Very rare random press
            self._power_button_state = not self._power_button_state
        return self._power_button_state


class RealSensors(SensorInterface):
    """Real hardware sensor implementation."""
    
    def __init__(self):
        # Import hardware libraries only when needed
        import board
        import busio
        import digitalio
        from adafruit_ads1x15.ads1115 import ADS1115
        from adafruit_ads1x15.analog_in import AnalogIn
        from adafruit_bme280.basic import Adafruit_BME280_I2C
        
        # I2C setup
        self._i2c = busio.I2C(board.SCL, board.SDA)
        
        # ADS1115 for analog sensors (O2 and CO2)
        self._ads = ADS1115(self._i2c, address=0x48)
        self._ads.gain = 1
        
        # BME280 for environmental sensors
        try:
            self._bme = Adafruit_BME280_I2C(self._i2c, address=0x76)
        except ValueError:
            self._bme = Adafruit_BME280_I2C(self._i2c, address=0x77)
        
        # Power button GPIO setup
        self._power_button = digitalio.DigitalInOut(board.D18)  # GPIO 18
        self._power_button.direction = digitalio.Direction.INPUT
        self._power_button.pull = digitalio.Pull.UP
        
        # Calibration values
        self._v_air = 0.0095  # O2 voltage in air
        self._co2_zero_voltage = 0.0  # CO2 sensor zero point
        self._co2_span_voltage = 3.3  # CO2 sensor span
    
    def read_oxygen_voltage(self) -> float:
        chan = AnalogIn(self._ads, 0)  # O2 on channel 0
        return chan.voltage
    
    def read_oxygen_percent(self) -> float:
        voltage = self.read_oxygen_voltage()
        return (voltage / self._v_air) * 20.9
    
    def read_co2_voltage(self) -> float:
        chan = AnalogIn(self._ads, 1)  # CO2 on channel 1
        return chan.voltage
    
    def read_co2_ppm(self) -> float:
        voltage = self.read_co2_voltage()
        # Convert voltage to PPM based on sensor specs
        # This will need calibration for your specific CO2 sensor
        voltage_range = self._co2_span_voltage - self._co2_zero_voltage
        voltage_normalized = (voltage - self._co2_zero_voltage) / voltage_range
        return voltage_normalized * 5000  # Assuming 0-5000ppm range
    
    def read_temperature_c(self) -> float:
        return self._bme.temperature
    
    def read_pressure_hpa(self) -> float:
        return self._bme.pressure / 1000.0  # Convert to bar
    
    def read_humidity_pct(self) -> float:
        return self._bme.humidity
    
    def is_power_button_pressed(self) -> bool:
        return not self._power_button.value  # Active low (pressed = False)


# Global sensor instance and history
_sensor_instance: Optional[SensorInterface] = None

# History storage for sensor readings
from collections import deque
_history = {
    'o2': deque(maxlen=60),
    'temp': deque(maxlen=60),
    'press': deque(maxlen=60),
    'hum': deque(maxlen=60),
}

# Calibration value
_V_AIR = 0.0095  # Default calibrated voltage in air


def get_sensors() -> SensorInterface:
    """Get the appropriate sensor implementation."""
    global _sensor_instance
    
    if _sensor_instance is None:
        if is_development_environment():
            print("🔧 Using mock sensors for development")
            _sensor_instance = MockSensors()
        else:
            print("🔌 Using real hardware sensors")
            _sensor_instance = RealSensors()
    
    return _sensor_instance


# Compatibility functions for existing code
def get_readings() -> dict:
    """Return a dict of all current sensor values."""
    sensors = get_sensors()
    return {
        'o2': round(sensors.read_oxygen_percent(), 2),
        'temp': round(sensors.read_temperature_c(), 2),
        'press': round(sensors.read_pressure_hpa(), 2),
        'hum': round(sensors.read_humidity_pct(), 2),
    }


def record_readings():
    """Record current sensor readings to history."""
    sensors = get_sensors()
    t = time.time()
    _history['o2'].append((t, sensors.read_oxygen_percent()))
    _history['temp'].append((t, sensors.read_temperature_c()))
    _history['press'].append((t, sensors.read_pressure_hpa()))
    _history['hum'].append((t, sensors.read_humidity_pct()))


def get_history(key: str):
    """Get history for a specific sensor type."""
    now = time.time()
    return [(now - ts, val) for ts, val in _history[key]]


def read_oxygen_voltage() -> float:
    """Read raw O2 voltage."""
    return get_sensors().read_oxygen_voltage()


def read_oxygen_percent() -> float:
    """Read O2 percentage."""
    return get_sensors().read_oxygen_percent()


def read_temperature_c() -> float:
    """Read temperature in Celsius."""
    return get_sensors().read_temperature_c()


def read_pressure_hpa() -> float:
    """Read pressure in BAR (despite the function name, this returns BAR for consistency)."""
    return get_sensors().read_pressure_hpa()


def read_humidity_pct() -> float:
    """Read humidity percentage."""
    return get_sensors().read_humidity_pct()


def update_v_air_calibration(new_v_air: float):
    """Update the V_AIR calibration value."""
    global _V_AIR
    old_v_air = _V_AIR
    _V_AIR = new_v_air
    print(f"O2 calibration updated: {old_v_air:.6f}V -> {new_v_air:.6f}V")
    # TODO: Save to persistent storage


def get_v_air_calibration() -> float:
    """Get the current V_AIR calibration value."""
    return _V_AIR
