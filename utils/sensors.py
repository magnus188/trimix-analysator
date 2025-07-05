import board
import time
import busio
from adafruit_ads1x15.ads1115 import ADS1115
from adafruit_ads1x15.analog_in import AnalogIn
from adafruit_bme280.basic import Adafruit_BME280_I2C
from collections import deque

_history = {
    'o2':   deque(maxlen=60),
    'temp': deque(maxlen=60),
    'press': deque(maxlen=60),
    'hum':  deque(maxlen=60),
}


# ——— Sensor Initialization ———

# I2C bus (shared by ADS1115 & BME280)
_i2c = busio.I2C(board.SCL, board.SDA)

# ADS1115 for O₂:
_ads = ADS1115(_i2c, address=0x48)
_ads.gain = 1
# TODO: create calibration routine to find the right voltage in air
_V_AIR = 0.0095  # calibrated voltage in air

# BME280 for T/P/H:
try:
    _bme = Adafruit_BME280_I2C(_i2c, address=0x76)
except ValueError:
    _bme = Adafruit_BME280_I2C(_i2c, address=0x77)


# ——— Public API ———

def read_oxygen_voltage() -> float:
    """
    Read raw O2 voltage from ADS1115 channel 0.
    """
    chan = AnalogIn(_ads, 0)
    return chan.voltage


def read_oxygen_percent() -> float:
    """
    Read O2 voltage from ADS1115 channel 0, convert to percent.
    """
    volt = read_oxygen_voltage()
    return (volt / _V_AIR) * 20.9


def read_temperature_c() -> float:
    """
    Read temperature in °C from BME280.
    """
    return _bme.temperature


def read_pressure_hpa() -> float:
    """
    Read pressure from BME280, return in bar.
    """
    return _bme.pressure / 1000.0


def read_humidity_pct() -> float:
    """
    Read relative humidity from BME280 in %.
    """
    return _bme.humidity


def get_readings() -> dict:
    """
    Return a dict of all current sensor values:
      {
        'o2': float,     # %
        'temp': float,   # °C
        'press': float,  # Bar
        'hum': float     # %RH
      }
    """
    return {
        'o2':     round(read_oxygen_percent(), 2),
        'temp':   round(read_temperature_c(), 2),
        'press':  round(read_pressure_hpa(), 2),
        'hum':    round(read_humidity_pct(), 2),
    }

def record_readings():
    t = time.time()
    _history['o2'].append((t, read_oxygen_percent()))
    _history['temp'].append((t, read_temperature_c()))
    _history['press'].append((t, read_pressure_hpa()))
    _history['hum'].append((t, read_humidity_pct()))


def get_history(key: str):
    now = time.time()
    return [(now - ts, val) for ts, val in _history[key]]


def update_v_air_calibration(new_v_air: float):
    """
    Update the V_AIR calibration value.
    
    Args:
        new_v_air: The new voltage reading in air (should be around 20.9% O2)
    """
    global _V_AIR
    old_v_air = _V_AIR
    _V_AIR = new_v_air
    print(f"O2 calibration updated: {old_v_air:.6f}V -> {new_v_air:.6f}V")
    
    # TODO: Save to persistent storage (config file, etc.)
    # For now, this will reset on restart


def get_v_air_calibration() -> float:
    """
    Get the current V_AIR calibration value.
    """
    return _V_AIR