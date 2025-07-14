#ifndef SENSOR_INTERFACE_H
#define SENSOR_INTERFACE_H

#include "arduino_compat.h"

struct SensorReadings {
    float o2;
    float he;
    float n2;
    float co2;
    float co;
    bool isValid;
};

class SensorInterface {
private:
    // Sensor pins
    static const int O2_SENSOR_PIN = 34;
    static const int HE_SENSOR_PIN = 35;
    static const int CO2_SENSOR_PIN = 32;
    static const int CO_SENSOR_PIN = 33;
    
    // Calibration values
    float o2_calibration_factor;
    float he_calibration_factor;
    float co2_calibration_factor;
    float co_calibration_factor;
    
    // Moving average buffers
    static const int BUFFER_SIZE = 5;
    float o2_buffer[BUFFER_SIZE];
    float he_buffer[BUFFER_SIZE];
    float co2_buffer[BUFFER_SIZE];
    float co_buffer[BUFFER_SIZE];
    int buffer_index;
    
    SensorReadings lastReadings;
    unsigned long lastReadTime;
    static const unsigned long READ_INTERVAL = 1000; // 1 second
    
public:
    SensorInterface();
    ~SensorInterface();
    
    void init();
    SensorReadings getReadings(bool forceUpdate = false);
    void calibrateO2(float knownO2Value);
    void calibrateHe(float knownHeValue);
    void resetCalibration();
    
private:
    void updateReadings();
    float readO2();
    float readHe();
    float readCO2();
    float readCO();
    float calculateMovingAverage(float* buffer, float newValue);
    float mapVoltageToPercentage(float voltage, float min_voltage, float max_voltage);
    float mapVoltageToPPM(float voltage, float sensitivity);
};

#endif // SENSOR_INTERFACE_H
