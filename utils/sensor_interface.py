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
    
    def read_helium_pct(self) -> float:
        # Simulate helium sensor (0-30% for trimix)
        base = 15.0  # Example trimix with 15% He
        variation = random.uniform(-2, 2)
        return max(0, min(50, base + variation))
    
    def read_co_ppm(self) -> float:
        # Simulate CO sensor (0-100 ppm, should be very low)
        base = 5.0  # Low CO level
        variation = random.uniform(-2, 2)
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
        """
        Initializes hardware interfaces and sensor devices for real sensor readings.
        
        Sets up I2C communication, configures the ADS1115 ADC for analog O2 and CO2 sensors, initializes the BME280 sensor for temperature, pressure, and humidity, and configures the GPIO pin for the power button. Stores calibration constants for O2 and CO2 sensors.
        """
        import board
        import busio
        import digitalio
        from adafruit_ads1x15.ads1115 import ADS1115
        from adafruit_ads1x15.analog_in import AnalogIn
        from adafruit_bme280.basic import Adafruit_BME280_I2C
        
        # Store imported classes for use in methods
        self._AnalogIn = AnalogIn
        self._digitalio = digitalio
        
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
        self._power_button.direction = self._digitalio.Direction.INPUT
        self._power_button.pull = self._digitalio.Pull.UP
        
        # Calibration values
        self._v_air = 0.0095  # O2 voltage in air
        self._co2_zero_voltage = 0.0  # CO2 sensor zero point
        self._co2_span_voltage = 3.3  # CO2 sensor span
    
    def read_oxygen_voltage(self) -> float:
        """
        Reads the current oxygen sensor voltage from analog channel 0.
        
        Returns:
            float: The measured voltage from the oxygen sensor in volts.
        """
        chan = self._AnalogIn(self._ads, 0)  # O2 on channel 0
        return chan.voltage
    
    def read_oxygen_percent(self) -> float:
        """
        Calculates and returns the oxygen concentration percentage based on the current sensor voltage and calibration value.
        
        Returns:
            float: The calculated oxygen percentage.
        """
        voltage = self.read_oxygen_voltage()
        return (voltage / self._v_air) * 20.9
    
    def read_co2_voltage(self) -> float:
        """
        Reads the raw voltage from the CO2 sensor analog channel.
        
        Returns:
            float: The voltage reading from the CO2 sensor input.
        """
        chan = self._AnalogIn(self._ads, 1)  # CO2 on channel 1
        return chan.voltage
    
    def read_co2_ppm(self) -> float:
        """
        Return the current CO2 concentration in parts per million (ppm) based on the sensor's voltage reading.
        
        The value is calculated by normalizing the measured voltage using the sensor's zero and span calibration voltages, then scaling to a 0–5000 ppm range.
        Returns:
            float: The calculated CO2 concentration in ppm.
        """
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
    'he': deque(maxlen=60),
    'n2': deque(maxlen=60),
    'co2': deque(maxlen=60),
    'co': deque(maxlen=60),
}

# Calibration value
_V_AIR = 0.0095  # Default calibrated voltage in air


def get_sensors() -> SensorInterface:
    """
    Return the singleton sensor interface instance, selecting either real hardware sensors or mock sensors based on environment and hardware availability.
    
    Returns:
        SensorInterface: An instance of either RealSensors or MockSensors, depending on the execution environment and hardware initialization success.
    """
    global _sensor_instance
    
    if _sensor_instance is None:
        if is_development_environment():
            print("🔧 Using mock sensors for development")
            _sensor_instance = MockSensors()
        else:
            # Try to use real sensors, but fall back to mock if hardware isn't available
            try:
                print("🔌 Using real hardware sensors")
                _sensor_instance = RealSensors()
            except ImportError as e:
                print(f"⚠️  Hardware modules not available ({e}), falling back to mock sensors")
                _sensor_instance = MockSensors()
            except Exception as e:
                print(f"⚠️  Hardware initialization failed ({e}), falling back to mock sensors")
                _sensor_instance = MockSensors()
    
    return _sensor_instance


# Compatibility functions for existing code
def get_readings() -> dict:
    """Return a dict of all current sensor values."""
    sensors = get_sensors()
    o2_pct = round(sensors.read_oxygen_percent(), 2)
    
    # Get He reading from sensor if available, otherwise use placeholder
    if hasattr(sensors, 'read_helium_pct'):
        he_pct = round(sensors.read_helium_pct(), 2)
    else:
        he_pct = 0.0
    
    # Calculate N2 from O2 and He
    n2_pct = round(100.0 - o2_pct - he_pct, 2)
    
    # Get CO2 reading in PPM
    co2_ppm = round(sensors.read_co2_ppm(), 2)
    
    # Get CO reading from sensor if available, otherwise use placeholder
    if hasattr(sensors, 'read_co_ppm'):
        co_ppm = round(sensors.read_co_ppm(), 2)
    else:
        co_ppm = 0.0
    
    return {
        'o2': o2_pct,
        'temp': round(sensors.read_temperature_c(), 2),
        'press': round(sensors.read_pressure_hpa(), 2),
        'hum': round(sensors.read_humidity_pct(), 2),
        'he': he_pct,
        'n2': n2_pct,
        'co2': co2_ppm,
        'co': co_ppm,
    }


def record_readings():
    """Record current sensor readings to history."""
    sensors = get_sensors()
    t = time.time()
    
    # Read base sensor values
    o2_pct = sensors.read_oxygen_percent()
    
    # Get He reading from sensor if available, otherwise use placeholder
    if hasattr(sensors, 'read_helium_pct'):
        he_pct = sensors.read_helium_pct()
    else:
        he_pct = 0.0
    
    # Calculate N2 from O2 and He
    n2_pct = 100.0 - o2_pct - he_pct
    
    # Get CO2 reading in PPM
    co2_ppm = sensors.read_co2_ppm()
    
    # Get CO reading from sensor if available, otherwise use placeholder
    if hasattr(sensors, 'read_co_ppm'):
        co_ppm = sensors.read_co_ppm()
    else:
        co_ppm = 0.0
    
    # Record all sensor data
    _history['o2'].append((t, o2_pct))
    _history['temp'].append((t, sensors.read_temperature_c()))
    _history['press'].append((t, sensors.read_pressure_hpa()))
    _history['hum'].append((t, sensors.read_humidity_pct()))
    _history['he'].append((t, he_pct))
    _history['n2'].append((t, n2_pct))
    _history['co2'].append((t, co2_ppm))
    _history['co'].append((t, co_ppm))


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
