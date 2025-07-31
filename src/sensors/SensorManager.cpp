/*
 * SensorManager.cpp
 * Implementation of sensor management for ESP32-S3 Trimix Analyzer
 */

#include "sensors/SensorManager.h"
#include <math.h>

SensorManager::SensorManager() :
    ads_available(false),
    bme_available(false),
    use_mock_sensors(false),
    o2_air_voltage(0.0095f),  // Default calibration for air
    co2_zero_voltage(0.0f),
    co2_span_voltage(3.3f),
    mock_start_time(0),
    mock_base_temp(22.0f)
{
    // Initialize current reading
    currentReading = {0};
    currentReading.valid = false;
}

SensorManager::~SensorManager() {
    // Cleanup if needed
}

bool SensorManager::begin() {
    Serial.println("SensorManager: Initializing sensors...");
    
    mock_start_time = millis();
    
    // Scan for I2C devices first
    scanI2CDevices();
    
    // Initialize hardware sensors
    initializeHardware();
    
    // If no hardware available, enable mock sensors
    if (!ads_available && !bme_available) {
        Serial.println("SensorManager: No hardware sensors found, enabling mock sensors");
        use_mock_sensors = true;
    }
    
    // Take initial reading
    update();
    
    Serial.printf("SensorManager: Initialized - ADS1115: %s, BME280: %s, Mock: %s\n",
                  ads_available ? "OK" : "FAIL",
                  bme_available ? "OK" : "FAIL", 
                  use_mock_sensors ? "ENABLED" : "DISABLED");
    
    return true; // Always return true, fallback to mock sensors
}

void SensorManager::update() {
    if (use_mock_sensors) {
        readMockSensors();
    } else {
        readRealSensors();
    }
    
    currentReading.timestamp = millis();
    currentReading.valid = true;
}

void SensorManager::readRealSensors() {
    // Read ADS1115 (O2 and CO2 sensors)
    if (ads_available) {
        // O2 sensor on channel 0
        int16_t adc0 = ads.readADC_SingleEnded(0);
        currentReading.o2_voltage = ads.computeVolts(adc0);
        currentReading.o2_percent = (currentReading.o2_voltage / o2_air_voltage) * 20.9f;
        
        // CO2 sensor on channel 1  
        int16_t adc1 = ads.readADC_SingleEnded(1);
        currentReading.co2_voltage = ads.computeVolts(adc1);
        
        // Convert CO2 voltage to PPM (sensor-specific calibration)
        float voltage_range = co2_span_voltage - co2_zero_voltage;
        float voltage_normalized = (currentReading.co2_voltage - co2_zero_voltage) / voltage_range;
        currentReading.co2_ppm = voltage_normalized * 5000.0f; // 0-5000ppm range
        
        // Clamp values
        currentReading.o2_percent = max(0.0f, min(100.0f, currentReading.o2_percent));
        currentReading.co2_ppm = max(0.0f, min(10000.0f, currentReading.co2_ppm));
    } else {
        // Use mock values for analog sensors if ADS1115 not available
        currentReading.o2_voltage = 0.0095f + (random(-20, 20) / 100000.0f);
        currentReading.o2_percent = 20.9f + (random(-5, 5) / 10.0f);
        currentReading.co2_voltage = 0.4f + (random(-10, 10) / 100.0f);
        currentReading.co2_ppm = 400.0f + random(-50, 50);
    }
    
    // Read BME280 (temperature, pressure, humidity)
    if (bme_available) {
        currentReading.temperature_c = bme.readTemperature();
        currentReading.pressure_bar = bme.readPressure() / 100000.0f; // Convert Pa to bar
        currentReading.humidity_pct = bme.readHumidity();
    } else {
        // Use mock values for environmental sensors
        float elapsed = (millis() - mock_start_time) / 1000.0f;
        currentReading.temperature_c = mock_base_temp + 2.0f * sin(elapsed / 3600.0f) + (random(-10, 10) / 20.0f);
        currentReading.pressure_bar = 1.01325f + (random(-200, 200) / 100000.0f);
        currentReading.humidity_pct = 45.0f + (random(-500, 500) / 100.0f);
    }
}

void SensorManager::readMockSensors() {
    float elapsed = (millis() - mock_start_time) / 1000.0f;
    
    // Simulate realistic sensor values
    currentReading.o2_voltage = 0.0095f + (sin(elapsed / 60.0f) * 0.0002f) + (random(-20, 20) / 100000.0f);
    currentReading.o2_percent = (currentReading.o2_voltage / o2_air_voltage) * 20.9f;
    
    currentReading.co2_voltage = 0.4f + (sin(elapsed / 30.0f) * 0.1f) + (random(-10, 10) / 1000.0f);
    currentReading.co2_ppm = (currentReading.co2_voltage / 3.3f) * 5000.0f;
    
    // Daily temperature cycle
    currentReading.temperature_c = mock_base_temp + 3.0f * sin(elapsed / 3600.0f) + (random(-10, 10) / 20.0f);
    
    // Atmospheric pressure with small variations
    currentReading.pressure_bar = 1.01325f + (sin(elapsed / 1800.0f) * 0.002f) + (random(-100, 100) / 100000.0f);
    
    // Humidity variations
    currentReading.humidity_pct = 45.0f + 10.0f * sin(elapsed / 900.0f) + (random(-200, 200) / 100.0f);
    
    // Clamp all values to realistic ranges
    currentReading.o2_percent = max(15.0f, min(25.0f, currentReading.o2_percent));
    currentReading.co2_ppm = max(300.0f, min(800.0f, currentReading.co2_ppm));
    currentReading.temperature_c = max(15.0f, min(35.0f, currentReading.temperature_c));
    currentReading.pressure_bar = max(0.98f, min(1.05f, currentReading.pressure_bar));
    currentReading.humidity_pct = max(20.0f, min(80.0f, currentReading.humidity_pct));
}

void SensorManager::initializeHardware() {
    // Try to initialize ADS1115
    if (ads.begin(ADS1115_ADDR)) {
        ads.setGain(GAIN_ONE); // +/- 4.096V range
        ads_available = true;
        Serial.printf("SensorManager: ADS1115 initialized at 0x%02X\n", ADS1115_ADDR);
    } else {
        Serial.printf("SensorManager: Failed to initialize ADS1115 at 0x%02X\n", ADS1115_ADDR);
    }
    
    // Try to initialize BME280
    if (bme.begin(BME280_ADDR)) {
        bme_available = true;
        Serial.printf("SensorManager: BME280 initialized at 0x%02X\n", BME280_ADDR);
        
        // Configure BME280 for forced mode (power efficient)
        bme.setSampling(Adafruit_BME280::MODE_FORCED,
                       Adafruit_BME280::SAMPLING_X1,  // temperature
                       Adafruit_BME280::SAMPLING_X1,  // pressure
                       Adafruit_BME280::SAMPLING_X1,  // humidity
                       Adafruit_BME280::FILTER_OFF);
    } else {
        Serial.printf("SensorManager: Failed to initialize BME280 at 0x%02X\n", BME280_ADDR);
        
        // Try alternate address
        if (bme.begin(0x77)) {
            bme_available = true;
            Serial.println("SensorManager: BME280 initialized at 0x77");
        }
    }
}

bool SensorManager::scanI2CDevices() {
    Serial.println("SensorManager: Scanning I2C bus...");
    
    int deviceCount = 0;
    for (byte address = 1; address < 127; address++) {
        Wire.beginTransmission(address);
        byte error = Wire.endTransmission();
        
        if (error == 0) {
            Serial.printf("I2C device found at 0x%02X\n", address);
            deviceCount++;
        }
    }
    
    if (deviceCount == 0) {
        Serial.println("No I2C devices found");
    } else {
        Serial.printf("Found %d I2C device(s)\n", deviceCount);
    }
    
    return deviceCount > 0;
}

void SensorManager::setO2Calibration(float airVoltage) {
    o2_air_voltage = airVoltage;
    Serial.printf("SensorManager: O2 calibration updated to %.6f V\n", airVoltage);
}

void SensorManager::setCO2Calibration(float zeroVoltage, float spanVoltage) {
    co2_zero_voltage = zeroVoltage;
    co2_span_voltage = spanVoltage;
    Serial.printf("SensorManager: CO2 calibration updated - Zero: %.3f V, Span: %.3f V\n", 
                  zeroVoltage, spanVoltage);
}