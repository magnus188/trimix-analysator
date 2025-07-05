import board
import busio
from adafruit_ads1x15.ads1115 import ADS1115
from adafruit_ads1x15.analog_in import AnalogIn
from adafruit_bme280.basic import Adafruit_BME280_I2C

# ——— Sensor Initialization ———

# I2C bus (shared by ADS1115 & BME280)
_i2c = busio.I2C(board.SCL, board.SDA)

# ADS1115 for O₂:
_ads = ADS1115(_i2c, address=0x48)
_ads.gain = 1
_V_AIR = 0.0095  # calibrated voltage in air

# BME280 for T/P/H:
try:
    _bme = Adafruit_BME280_I2C(_i2c, address=0x76)
except ValueError:
    _bme = Adafruit_BME280_I2C(_i2c, address=0x77)


# ——— Public API ———

def read_oxygen_percent() -> float:
    """
    Read O2 voltage from ADS1115 channel 0, convert to percent.
    """
    chan = AnalogIn(_ads, 0)
    volt = chan.voltage
    return (volt / _V_AIR) * 20.9


def read_temperature_c() -> float:
    """
    Read temperature in °C from BME280.
    """
    return _bme.temperature


def read_pressure_hpa() -> float:
    """
    Read pressure from BME280, return in hPa.
    """
    return _bme.pressure / 100.0


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
        'press': float,  # hPa
        'hum': float     # %RH
      }
    """
    return {
        'o2':     round(read_oxygen_percent(), 2),
        'temp':   round(read_temperature_c(), 2),
        'press':  round(read_pressure_hpa(), 2),
        'hum':    round(read_humidity_pct(), 2),
    }