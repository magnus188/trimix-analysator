/*
 * SensorManager.h
 * Manages all sensor operations for ESP32-S3 Trimix Analyzer
 */

#ifndef SENSOR_MANAGER_H
#define SENSOR_MANAGER_H

#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_ADS1X15.h>
#include <Adafruit_BME280.h>

struct SensorReading {
    float o2_percent;
    float co2_ppm;
    float temperature_c;
    float pressure_bar;
    float humidity_pct;
    float o2_voltage;
    float co2_voltage;
    bool valid;
    unsigned long timestamp;
};

class SensorManager {
public:
    SensorManager();
    ~SensorManager();
    
    bool begin();
    void update();
    
    // Get current readings
    SensorReading getCurrentReading() const { return currentReading; }
    
    // Individual sensor readings
    float getO2Percent() const { return currentReading.o2_percent; }
    float getCO2PPM() const { return currentReading.co2_ppm; }
    float getTemperature() const { return currentReading.temperature_c; }
    float getPressure() const { return currentReading.pressure_bar; }
    float getHumidity() const { return currentReading.humidity_pct; }
    float getO2Voltage() const { return currentReading.o2_voltage; }
    float getCO2Voltage() const { return currentReading.co2_voltage; }
    
    // Calibration
    void setO2Calibration(float airVoltage);
    float getO2Calibration() const { return o2_air_voltage; }
    void setCO2Calibration(float zeroVoltage, float spanVoltage);
    
    // Hardware status
    bool isADS1115Available() const { return ads_available; }
    bool isBME280Available() const { return bme_available; }
    bool isUsingMockSensors() const { return use_mock_sensors; }
    
    // Mock sensor control (for testing)
    void enableMockSensors(bool enable) { use_mock_sensors = enable; }

private:
    // Hardware interfaces
    Adafruit_ADS1115 ads;
    Adafruit_BME280 bme;
    
    // Hardware availability flags
    bool ads_available;
    bool bme_available;
    bool use_mock_sensors;
    
    // Current sensor reading
    SensorReading currentReading;
    
    // Calibration values
    float o2_air_voltage;          // Voltage when reading air (20.9% O2)
    float co2_zero_voltage;        // CO2 sensor zero point voltage
    float co2_span_voltage;        // CO2 sensor span voltage (5000ppm)
    
    // Private methods
    void readRealSensors();
    void readMockSensors();
    void initializeHardware();
    bool scanI2CDevices();
    
    // Mock sensor state
    unsigned long mock_start_time;
    float mock_base_temp;
};

#endif // SENSOR_MANAGER_H