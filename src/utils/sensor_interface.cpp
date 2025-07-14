#include "sensor_interface.h"
#include <Arduino.h>

SensorInterface::SensorInterface() 
    : o2_calibration_factor(1.0f), he_calibration_factor(1.0f), 
      co2_calibration_factor(1.0f), co_calibration_factor(1.0f),
      buffer_index(0), lastReadTime(0) {
    
    // Initialize buffers
    for (int i = 0; i < BUFFER_SIZE; i++) {
        o2_buffer[i] = 0.0f;
        he_buffer[i] = 0.0f;
        co2_buffer[i] = 0.0f;
        co_buffer[i] = 0.0f;
    }
    
    // Initialize last readings
    lastReadings.o2 = 0.0f;
    lastReadings.he = 0.0f;
    lastReadings.n2 = 0.0f;
    lastReadings.co2 = 0.0f;
    lastReadings.co = 0.0f;
    lastReadings.isValid = false;
}

SensorInterface::~SensorInterface() {
    // Nothing to clean up
}

void SensorInterface::init() {
    // Initialize ADC with optimized settings
    analogReadResolution(12); // 12-bit resolution (0-4095)
    analogSetAttenuation(ADC_11db); // Full range: 0-3.3V
    analogSetCycles(8); // Reduce cycles for faster reading
    analogSetSamples(1); // Single sample for speed
    analogSetClockDiv(1); // Fastest clock
    
    // Set pin modes (ADC pins are input by default)
    pinMode(O2_SENSOR_PIN, INPUT);
    pinMode(HE_SENSOR_PIN, INPUT);
    pinMode(CO2_SENSOR_PIN, INPUT);
    pinMode(CO_SENSOR_PIN, INPUT);
    
    // Pre-warm the ADC
    for (int i = 0; i < 10; i++) {
        analogRead(O2_SENSOR_PIN);
        analogRead(HE_SENSOR_PIN);
        analogRead(CO2_SENSOR_PIN);
        analogRead(CO_SENSOR_PIN);
        delayMicroseconds(100);
    }
    
    Serial.println("Sensor interface initialized with optimizations");
    
    // Take initial readings to populate buffers
    for (int i = 0; i < BUFFER_SIZE; i++) {
        updateReadings();
        delay(10);
    }
}

SensorReadings SensorInterface::getReadings(bool forceUpdate) {
    unsigned long currentTime = millis();
    
    if (forceUpdate || (currentTime - lastReadTime) >= READ_INTERVAL) {
        updateReadings();
        lastReadTime = currentTime;
    }
    
    return lastReadings;
}

void SensorInterface::updateReadings() {
    // Batch read all sensors for better performance
    uint16_t rawValues[4];
    rawValues[0] = analogRead(O2_SENSOR_PIN);
    rawValues[1] = analogRead(HE_SENSOR_PIN);
    rawValues[2] = analogRead(CO2_SENSOR_PIN);
    rawValues[3] = analogRead(CO_SENSOR_PIN);
    
    // Convert to voltages
    float voltages[4];
    for (int i = 0; i < 4; i++) {
        voltages[i] = (rawValues[i] / 4095.0f) * 3.3f;
    }
    
    // Process sensor readings with optimized calculations
    float o2 = mapVoltageToPercentage(voltages[0], 0.0f, 3.3f) * o2_calibration_factor;
    float he = mapVoltageToPercentage(voltages[1], 0.0f, 3.3f) * he_calibration_factor;
    float co2 = mapVoltageToPPM(voltages[2], 0.4f) * co2_calibration_factor;
    float co = mapVoltageToPPM(voltages[3], 0.1f) * co_calibration_factor;
    
    // Apply moving average filtering with optimized algorithm
    o2 = calculateMovingAverage(o2_buffer, o2);
    he = calculateMovingAverage(he_buffer, he);
    co2 = calculateMovingAverage(co2_buffer, co2);
    co = calculateMovingAverage(co_buffer, co);
    
    // Apply range limits with fast clamping
    o2 = constrain(o2, 0.0f, 100.0f);
    he = constrain(he, 0.0f, 100.0f);
    co2 = constrain(co2, 0.0f, 10000.0f);
    co = constrain(co, 0.0f, 1000.0f);
    
    // Calculate N2 (assuming air balance)
    float n2 = 100.0f - o2 - he;
    n2 = constrain(n2, 0.0f, 100.0f);
    
    // Update last readings atomically
    lastReadings.o2 = o2;
    lastReadings.he = he;
    lastReadings.n2 = n2;
    lastReadings.co2 = co2;
    lastReadings.co = co;
    lastReadings.isValid = true;
    
    // Optimized debug output (only when values change significantly)
    static float lastO2 = 0, lastHe = 0, lastN2 = 0, lastCO2 = 0, lastCO = 0;
    if (abs(o2 - lastO2) > 0.1f || abs(he - lastHe) > 0.1f || 
        abs(n2 - lastN2) > 0.1f || abs(co2 - lastCO2) > 10.0f || abs(co - lastCO) > 1.0f) {
        Serial.printf("Sensors: O2=%.1f%% He=%.1f%% N2=%.1f%% CO2=%.0fppm CO=%.0fppm\n", 
                      o2, he, n2, co2, co);
        lastO2 = o2; lastHe = he; lastN2 = n2; lastCO2 = co2; lastCO = co;
    }
}

float SensorInterface::readO2() {
    int rawValue = analogRead(O2_SENSOR_PIN);
    float voltage = (rawValue / 4095.0f) * 3.3f;
    
    // Convert voltage to O2 percentage
    // This is a placeholder - actual calibration depends on sensor type
    // Common O2 sensors output 0-3.3V for 0-100% O2
    float percentage = mapVoltageToPercentage(voltage, 0.0f, 3.3f) * o2_calibration_factor;
    
    // Reasonable limits for O2
    if (percentage < 0.0f) percentage = 0.0f;
    if (percentage > 100.0f) percentage = 100.0f;
    
    return percentage;
}

float SensorInterface::readHe() {
    int rawValue = analogRead(HE_SENSOR_PIN);
    float voltage = (rawValue / 4095.0f) * 3.3f;
    
    // Convert voltage to He percentage
    // This is a placeholder - actual calibration depends on sensor type
    float percentage = mapVoltageToPercentage(voltage, 0.0f, 3.3f) * he_calibration_factor;
    
    // Reasonable limits for He
    if (percentage < 0.0f) percentage = 0.0f;
    if (percentage > 100.0f) percentage = 100.0f;
    
    return percentage;
}

float SensorInterface::readCO2() {
    int rawValue = analogRead(CO2_SENSOR_PIN);
    float voltage = (rawValue / 4095.0f) * 3.3f;
    
    // Convert voltage to CO2 PPM
    // This is a placeholder - actual calibration depends on sensor type
    // Common CO2 sensors output 0.4-2.0V for 0-5000ppm
    float ppm = mapVoltageToPPM(voltage, 0.4f) * co2_calibration_factor;
    
    // Reasonable limits for CO2
    if (ppm < 0.0f) ppm = 0.0f;
    if (ppm > 10000.0f) ppm = 10000.0f;
    
    return ppm;
}

float SensorInterface::readCO() {
    int rawValue = analogRead(CO_SENSOR_PIN);
    float voltage = (rawValue / 4095.0f) * 3.3f;
    
    // Convert voltage to CO PPM
    // This is a placeholder - actual calibration depends on sensor type
    float ppm = mapVoltageToPPM(voltage, 0.1f) * co_calibration_factor;
    
    // Reasonable limits for CO
    if (ppm < 0.0f) ppm = 0.0f;
    if (ppm > 1000.0f) ppm = 1000.0f;
    
    return ppm;
}

float SensorInterface::calculateMovingAverage(float* buffer, float newValue) {
    // Add new value to buffer
    buffer[buffer_index] = newValue;
    buffer_index = (buffer_index + 1) % BUFFER_SIZE;
    
    // Calculate average
    float sum = 0.0f;
    for (int i = 0; i < BUFFER_SIZE; i++) {
        sum += buffer[i];
    }
    
    return sum / BUFFER_SIZE;
}

float SensorInterface::mapVoltageToPercentage(float voltage, float min_voltage, float max_voltage) {
    if (voltage < min_voltage) voltage = min_voltage;
    if (voltage > max_voltage) voltage = max_voltage;
    
    return ((voltage - min_voltage) / (max_voltage - min_voltage)) * 100.0f;
}

float SensorInterface::mapVoltageToPPM(float voltage, float sensitivity) {
    // Generic voltage to PPM conversion
    // This is a simplified conversion - actual sensors may have different characteristics
    return voltage * sensitivity * 1000.0f;
}

void SensorInterface::calibrateO2(float knownO2Value) {
    // Get current raw reading
    float currentReading = readO2() / o2_calibration_factor; // Remove current calibration
    
    if (currentReading > 0.0f) {
        o2_calibration_factor = knownO2Value / currentReading;
        Serial.printf("O2 calibrated: factor = %.3f\n", o2_calibration_factor);
    }
}

void SensorInterface::calibrateHe(float knownHeValue) {
    // Get current raw reading
    float currentReading = readHe() / he_calibration_factor; // Remove current calibration
    
    if (currentReading > 0.0f) {
        he_calibration_factor = knownHeValue / currentReading;
        Serial.printf("He calibrated: factor = %.3f\n", he_calibration_factor);
    }
}

void SensorInterface::resetCalibration() {
    o2_calibration_factor = 1.0f;
    he_calibration_factor = 1.0f;
    co2_calibration_factor = 1.0f;
    co_calibration_factor = 1.0f;
    
    Serial.println("Calibration reset to defaults");
}
