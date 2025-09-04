#include "sensor_interface.h"
#include "hardware.h"
#include <esp_log.h>
#include <esp_adc/adc_oneshot.h>
#include <esp_adc/adc_cali.h>
#include <esp_adc/adc_cali_scheme.h>
#include <driver/i2c.h>
#include <driver/gpio.h>
#include <math.h>
#include <string.h>

static const char *TAG = "SENSOR";

// BME280 I2C address
#define BME280_I2C_ADDR 0x76

// BME280 registers
#define BME280_REG_ID 0xD0
#define BME280_REG_CTRL_MEAS 0xF4
#define BME280_REG_CTRL_HUM 0xF2
#define BME280_REG_CONFIG 0xF5
#define BME280_REG_PRESS_MSB 0xF7
#define BME280_REG_TEMP_MSB 0xFA
#define BME280_REG_HUM_MSB 0xFD

// BME280 calibration registers
#define BME280_REG_DIG_T1_LSB 0x88
#define BME280_REG_DIG_H1 0xA1
#define BME280_REG_DIG_H2_LSB 0xE1

// Global variables for sensor interface
static adc_oneshot_unit_handle_t adc1_handle;
static adc_cali_handle_t adc1_cali_handle;
static bool adc_calibrated = false;
static bool sensor_initialized = false;

// BME280 calibration data
typedef struct {
    uint16_t dig_T1;
    int16_t dig_T2;
    int16_t dig_T3;
    uint16_t dig_P1;
    int16_t dig_P2;
    int16_t dig_P3;
    int16_t dig_P4;
    int16_t dig_P5;
    int16_t dig_P6;
    int16_t dig_P7;
    int16_t dig_P8;
    int16_t dig_P9;
    uint8_t dig_H1;
    int16_t dig_H2;
    uint8_t dig_H3;
    int16_t dig_H4;
    int16_t dig_H5;
    int8_t dig_H6;
} bme280_calib_t;

static bme280_calib_t bme280_calib;
static sensor_calibration_t sensor_cal = {
    .o2_air_voltage = 0.0095f,    // Default O2 voltage in air
    .co2_zero_voltage = 0.0f,     // Default CO2 zero point
    .co2_span_voltage = 3.3f      // Default CO2 span
};

// I2C communication functions
static esp_err_t i2c_write_reg(uint8_t device_addr, uint8_t reg_addr, uint8_t data) {
    uint8_t write_buf[2] = {reg_addr, data};
    return i2c_master_write_to_device(SENSOR_I2C_PORT, device_addr, write_buf, sizeof(write_buf), 1000 / portTICK_PERIOD_MS);
}

static esp_err_t i2c_read_reg(uint8_t device_addr, uint8_t reg_addr, uint8_t *data, size_t len) {
    return i2c_master_write_read_device(SENSOR_I2C_PORT, device_addr, &reg_addr, 1, data, len, 1000 / portTICK_PERIOD_MS);
}

// Initialize I2C for sensors
static esp_err_t init_sensor_i2c(void) {
    i2c_config_t conf = {
        .mode = I2C_MODE_MASTER,
        .sda_io_num = SENSOR_PIN_SDA,
        .scl_io_num = SENSOR_PIN_SCL,
        .sda_pullup_en = GPIO_PULLUP_ENABLE,
        .scl_pullup_en = GPIO_PULLUP_ENABLE,
        .master.clk_speed = SENSOR_FREQ_HZ,
    };
    
    esp_err_t ret = i2c_param_config(SENSOR_I2C_PORT, &conf);
    if (ret != ESP_OK) return ret;
    
    return i2c_driver_install(SENSOR_I2C_PORT, conf.mode, 0, 0, 0);
}

// Initialize ADC for analog sensors
static esp_err_t init_adc(void) {
    adc_oneshot_unit_init_cfg_t init_config1 = {
        .unit_id = ADC_UNIT_1,
    };
    esp_err_t ret = adc_oneshot_new_unit(&init_config1, &adc1_handle);
    if (ret != ESP_OK) return ret;

    adc_oneshot_chan_cfg_t config = {
        .bitwidth = ADC_BITWIDTH_12,
        .atten = ADC_ATTEN_DB_11,
    };
    
    ret = adc_oneshot_config_channel(adc1_handle, O2_SENSOR_ADC_CHANNEL, &config);
    if (ret != ESP_OK) return ret;
    
    ret = adc_oneshot_config_channel(adc1_handle, CO2_SENSOR_ADC_CHANNEL, &config);
    if (ret != ESP_OK) return ret;

    // Initialize ADC calibration
    adc_cali_curve_fitting_config_t cali_config = {
        .unit_id = ADC_UNIT_1,
        .atten = ADC_ATTEN_DB_11,
        .bitwidth = ADC_BITWIDTH_12,
    };
    ret = adc_cali_create_scheme_curve_fitting(&cali_config, &adc1_cali_handle);
    if (ret == ESP_OK) {
        adc_calibrated = true;
        ESP_LOGI(TAG, "ADC calibration successful");
    } else {
        ESP_LOGW(TAG, "ADC calibration failed, using raw values");
    }

    return ESP_OK;
}

// Initialize BME280 sensor
static esp_err_t init_bme280(void) {
    uint8_t chip_id;
    esp_err_t ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_ID, &chip_id, 1);
    if (ret != ESP_OK) return ret;
    
    if (chip_id != 0x60) {
        ESP_LOGE(TAG, "BME280 not found, chip ID: 0x%02X", chip_id);
        return ESP_ERR_NOT_FOUND;
    }
    
    ESP_LOGI(TAG, "BME280 found, chip ID: 0x%02X", chip_id);
    
    // Configure humidity control
    ret = i2c_write_reg(BME280_I2C_ADDR, BME280_REG_CTRL_HUM, 0x01); // Humidity oversampling x1
    if (ret != ESP_OK) return ret;
    
    // Configure measurement control
    ret = i2c_write_reg(BME280_I2C_ADDR, BME280_REG_CTRL_MEAS, 0x25); // Temp x1, Press x1, Normal mode
    if (ret != ESP_OK) return ret;
    
    // Configure config
    ret = i2c_write_reg(BME280_I2C_ADDR, BME280_REG_CONFIG, 0xA0); // Standby 1000ms, filter off
    if (ret != ESP_OK) return ret;
    
    // Read calibration data
    uint8_t calib_data[26];
    ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_DIG_T1_LSB, calib_data, 26);
    if (ret != ESP_OK) return ret;
    
    // Parse temperature and pressure calibration
    bme280_calib.dig_T1 = (calib_data[1] << 8) | calib_data[0];
    bme280_calib.dig_T2 = (calib_data[3] << 8) | calib_data[2];
    bme280_calib.dig_T3 = (calib_data[5] << 8) | calib_data[4];
    bme280_calib.dig_P1 = (calib_data[7] << 8) | calib_data[6];
    bme280_calib.dig_P2 = (calib_data[9] << 8) | calib_data[8];
    bme280_calib.dig_P3 = (calib_data[11] << 8) | calib_data[10];
    bme280_calib.dig_P4 = (calib_data[13] << 8) | calib_data[12];
    bme280_calib.dig_P5 = (calib_data[15] << 8) | calib_data[14];
    bme280_calib.dig_P6 = (calib_data[17] << 8) | calib_data[16];
    bme280_calib.dig_P7 = (calib_data[19] << 8) | calib_data[18];
    bme280_calib.dig_P8 = (calib_data[21] << 8) | calib_data[20];
    bme280_calib.dig_P9 = (calib_data[23] << 8) | calib_data[22];
    
    // Read humidity calibration
    ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_DIG_H1, &bme280_calib.dig_H1, 1);
    if (ret != ESP_OK) return ret;
    
    uint8_t hum_calib[7];
    ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_DIG_H2_LSB, hum_calib, 7);
    if (ret != ESP_OK) return ret;
    
    bme280_calib.dig_H2 = (hum_calib[1] << 8) | hum_calib[0];
    bme280_calib.dig_H3 = hum_calib[2];
    bme280_calib.dig_H4 = (hum_calib[3] << 4) | (hum_calib[4] & 0x0F);
    bme280_calib.dig_H5 = (hum_calib[5] << 4) | (hum_calib[4] >> 4);
    bme280_calib.dig_H6 = hum_calib[6];
    
    return ESP_OK;
}

// Temperature compensation calculation
static int32_t compensate_temperature(int32_t adc_T) {
    int32_t var1, var2, T;
    var1 = ((((adc_T >> 3) - ((int32_t)bme280_calib.dig_T1 << 1))) * ((int32_t)bme280_calib.dig_T2)) >> 11;
    var2 = (((((adc_T >> 4) - ((int32_t)bme280_calib.dig_T1)) * ((adc_T >> 4) - ((int32_t)bme280_calib.dig_T1))) >> 12) * ((int32_t)bme280_calib.dig_T3)) >> 14;
    return var1 + var2;
}

// Pressure compensation calculation
static uint32_t compensate_pressure(int32_t adc_P, int32_t t_fine) {
    int64_t var1, var2, p;
    var1 = ((int64_t)t_fine) - 128000;
    var2 = var1 * var1 * (int64_t)bme280_calib.dig_P6;
    var2 = var2 + ((var1 * (int64_t)bme280_calib.dig_P5) << 17);
    var2 = var2 + (((int64_t)bme280_calib.dig_P4) << 35);
    var1 = ((var1 * var1 * (int64_t)bme280_calib.dig_P3) >> 8) + ((var1 * (int64_t)bme280_calib.dig_P2) << 12);
    var1 = (((((int64_t)1) << 47) + var1)) * ((int64_t)bme280_calib.dig_P1) >> 33;
    if (var1 == 0) return 0;
    p = 1048576 - adc_P;
    p = (((p << 31) - var2) * 3125) / var1;
    var1 = (((int64_t)bme280_calib.dig_P9) * (p >> 13) * (p >> 13)) >> 25;
    var2 = (((int64_t)bme280_calib.dig_P8) * p) >> 19;
    p = ((p + var1 + var2) >> 8) + (((int64_t)bme280_calib.dig_P7) << 4);
    return (uint32_t)p;
}

// Humidity compensation calculation
static uint32_t compensate_humidity(int32_t adc_H, int32_t t_fine) {
    int32_t v_x1_u32r;
    v_x1_u32r = (t_fine - ((int32_t)76800));
    v_x1_u32r = (((((adc_H << 14) - (((int32_t)bme280_calib.dig_H4) << 20) - (((int32_t)bme280_calib.dig_H5) * v_x1_u32r)) +
                   ((int32_t)16384)) >> 15) * (((((((v_x1_u32r * ((int32_t)bme280_calib.dig_H6)) >> 10) * (((v_x1_u32r *
                   ((int32_t)bme280_calib.dig_H3)) >> 11) + ((int32_t)32768))) >> 10) + ((int32_t)2097152)) *
                   ((int32_t)bme280_calib.dig_H2) + 8192) >> 14));
    v_x1_u32r = (v_x1_u32r - (((((v_x1_u32r >> 15) * (v_x1_u32r >> 15)) >> 7) * ((int32_t)bme280_calib.dig_H1)) >> 4));
    v_x1_u32r = (v_x1_u32r < 0 ? 0 : v_x1_u32r);
    v_x1_u32r = (v_x1_u32r > 419430400 ? 419430400 : v_x1_u32r);
    return (uint32_t)(v_x1_u32r >> 12);
}

// Public functions implementation

esp_err_t sensor_interface_init(void) {
    if (sensor_initialized) {
        return ESP_OK;
    }
    
    ESP_LOGI(TAG, "Initializing sensor interface");
    
    // Initialize I2C for sensors
    esp_err_t ret = init_sensor_i2c();
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize sensor I2C: %s", esp_err_to_name(ret));
        return ret;
    }
    
    // Initialize ADC for analog sensors
    ret = init_adc();
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize ADC: %s", esp_err_to_name(ret));
        return ret;
    }
    
    // Initialize BME280
    ret = init_bme280();
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize BME280: %s", esp_err_to_name(ret));
        return ret;
    }
    
    sensor_initialized = true;
    ESP_LOGI(TAG, "Sensor interface initialized successfully");
    return ESP_OK;
}

esp_err_t sensor_read_oxygen_voltage(float *voltage) {
    if (!sensor_initialized) return ESP_ERR_INVALID_STATE;
    
    int adc_raw;
    esp_err_t ret = adc_oneshot_read(adc1_handle, O2_SENSOR_ADC_CHANNEL, &adc_raw);
    if (ret != ESP_OK) return ret;
    
    if (adc_calibrated) {
        int voltage_mv;
        ret = adc_cali_raw_to_voltage(adc1_cali_handle, adc_raw, &voltage_mv);
        if (ret == ESP_OK) {
            *voltage = voltage_mv / 1000.0f;
        } else {
            // Fallback to calculation
            *voltage = (adc_raw / 4095.0f) * 3.3f;
        }
    } else {
        *voltage = (adc_raw / 4095.0f) * 3.3f;
    }
    
    return ESP_OK;
}

esp_err_t sensor_read_oxygen_percent(float *percent) {
    float voltage;
    esp_err_t ret = sensor_read_oxygen_voltage(&voltage);
    if (ret != ESP_OK) return ret;
    
    *percent = (voltage / sensor_cal.o2_air_voltage) * 20.9f;
    return ESP_OK;
}

esp_err_t sensor_read_co2_voltage(float *voltage) {
    if (!sensor_initialized) return ESP_ERR_INVALID_STATE;
    
    int adc_raw;
    esp_err_t ret = adc_oneshot_read(adc1_handle, CO2_SENSOR_ADC_CHANNEL, &adc_raw);
    if (ret != ESP_OK) return ret;
    
    if (adc_calibrated) {
        int voltage_mv;
        ret = adc_cali_raw_to_voltage(adc1_cali_handle, adc_raw, &voltage_mv);
        if (ret == ESP_OK) {
            *voltage = voltage_mv / 1000.0f;
        } else {
            *voltage = (adc_raw / 4095.0f) * 3.3f;
        }
    } else {
        *voltage = (adc_raw / 4095.0f) * 3.3f;
    }
    
    return ESP_OK;
}

esp_err_t sensor_read_co2_ppm(float *ppm) {
    float voltage;
    esp_err_t ret = sensor_read_co2_voltage(&voltage);
    if (ret != ESP_OK) return ret;
    
    float voltage_range = sensor_cal.co2_span_voltage - sensor_cal.co2_zero_voltage;
    float voltage_normalized = (voltage - sensor_cal.co2_zero_voltage) / voltage_range;
    *ppm = voltage_normalized * 5000.0f; // Assuming 0-5000ppm range
    
    return ESP_OK;
}

esp_err_t sensor_read_temperature(float *temperature) {
    if (!sensor_initialized) return ESP_ERR_INVALID_STATE;
    
    uint8_t data[3];
    esp_err_t ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_TEMP_MSB, data, 3);
    if (ret != ESP_OK) return ret;
    
    int32_t adc_T = ((int32_t)data[0] << 12) | ((int32_t)data[1] << 4) | ((int32_t)data[2] >> 4);
    int32_t t_fine = compensate_temperature(adc_T);
    *temperature = (t_fine * 5 + 128) >> 8;
    *temperature /= 100.0f;
    
    return ESP_OK;
}

esp_err_t sensor_read_pressure(float *pressure) {
    if (!sensor_initialized) return ESP_ERR_INVALID_STATE;
    
    uint8_t temp_data[3], press_data[3];
    esp_err_t ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_TEMP_MSB, temp_data, 3);
    if (ret != ESP_OK) return ret;
    
    ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_PRESS_MSB, press_data, 3);
    if (ret != ESP_OK) return ret;
    
    int32_t adc_T = ((int32_t)temp_data[0] << 12) | ((int32_t)temp_data[1] << 4) | ((int32_t)temp_data[2] >> 4);
    int32_t adc_P = ((int32_t)press_data[0] << 12) | ((int32_t)press_data[1] << 4) | ((int32_t)press_data[2] >> 4);
    
    int32_t t_fine = compensate_temperature(adc_T);
    uint32_t p = compensate_pressure(adc_P, t_fine);
    
    *pressure = p / 256.0f / 100000.0f; // Convert to bar
    
    return ESP_OK;
}

esp_err_t sensor_read_humidity(float *humidity) {
    if (!sensor_initialized) return ESP_ERR_INVALID_STATE;
    
    uint8_t temp_data[3], hum_data[2];
    esp_err_t ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_TEMP_MSB, temp_data, 3);
    if (ret != ESP_OK) return ret;
    
    ret = i2c_read_reg(BME280_I2C_ADDR, BME280_REG_HUM_MSB, hum_data, 2);
    if (ret != ESP_OK) return ret;
    
    int32_t adc_T = ((int32_t)temp_data[0] << 12) | ((int32_t)temp_data[1] << 4) | ((int32_t)temp_data[2] >> 4);
    int32_t adc_H = ((int32_t)hum_data[0] << 8) | (int32_t)hum_data[1];
    
    int32_t t_fine = compensate_temperature(adc_T);
    uint32_t h = compensate_humidity(adc_H, t_fine);
    
    *humidity = h / 1024.0f;
    
    return ESP_OK;
}

bool sensor_read_power_button(void) {
    // TODO: Implement power button reading if connected
    return false;
}

esp_err_t sensor_read_all(sensor_readings_t *readings) {
    if (!readings) return ESP_ERR_INVALID_ARG;
    
    esp_err_t ret;
    
    ret = sensor_read_oxygen_percent(&readings->oxygen_percent);
    if (ret != ESP_OK) return ret;
    
    ret = sensor_read_co2_ppm(&readings->co2_ppm);
    if (ret != ESP_OK) return ret;
    
    ret = sensor_read_temperature(&readings->temperature_c);
    if (ret != ESP_OK) return ret;
    
    ret = sensor_read_pressure(&readings->pressure_bar);
    if (ret != ESP_OK) return ret;
    
    ret = sensor_read_humidity(&readings->humidity_pct);
    if (ret != ESP_OK) return ret;
    
    readings->power_button_pressed = sensor_read_power_button();
    
    return ESP_OK;
}

esp_err_t sensor_calibrate_oxygen_air(void) {
    float voltage;
    esp_err_t ret = sensor_read_oxygen_voltage(&voltage);
    if (ret != ESP_OK) return ret;
    
    sensor_cal.o2_air_voltage = voltage;
    ESP_LOGI(TAG, "O2 calibration updated: %.6f V", voltage);
    
    // TODO: Save calibration to NVS
    return ESP_OK;
}

esp_err_t sensor_set_calibration(const sensor_calibration_t *cal) {
    if (!cal) return ESP_ERR_INVALID_ARG;
    
    memcpy(&sensor_cal, cal, sizeof(sensor_calibration_t));
    ESP_LOGI(TAG, "Sensor calibration updated");
    
    // TODO: Save calibration to NVS
    return ESP_OK;
}

esp_err_t sensor_get_calibration(sensor_calibration_t *cal) {
    if (!cal) return ESP_ERR_INVALID_ARG;
    
    memcpy(cal, &sensor_cal, sizeof(sensor_calibration_t));
    return ESP_OK;
}