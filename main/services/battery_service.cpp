#include "battery_service.h"
#include "../ui/components/status_icons.h"
#include <esp_log.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <esp_timer.h>
// TODO: Uncomment when implementing I2C for MAX17048G
// #include <driver/i2c.h>

static const char* TAG = "BATTERY_SVC";

namespace {

// Battery configuration - adjust these for your specific battery and ADC setup
constexpr uint32_t BATTERY_FULL_MV = 4200;      // 4.2V for LiPo
constexpr uint32_t BATTERY_EMPTY_MV = 3300;     // 3.3V cutoff
constexpr uint32_t BATTERY_READ_INTERVAL_MS = 30000;  // Read every 30 seconds

// MAX17048G I2C Fuel Gauge Configuration
constexpr uint8_t MAX17048_I2C_ADDR = 0x36;     // 7-bit I2C address
constexpr uint8_t MAX17048_REG_VCELL   = 0x02;  // Voltage register
constexpr uint8_t MAX17048_REG_SOC     = 0x04;  // State of Charge register
constexpr uint8_t MAX17048_REG_MODE    = 0x06;  // Mode register
constexpr uint8_t MAX17048_REG_VERSION = 0x08;  // IC version register
constexpr uint8_t MAX17048_REG_CONFIG  = 0x0C;  // Configuration register
constexpr uint8_t MAX17048_REG_CRATE   = 0x16;  // Charge rate register

// State
TaskHandle_t g_monitoring_task = nullptr;
volatile bool g_monitoring_active = false;
uint32_t g_last_voltage_mv = BATTERY_FULL_MV;
bool g_is_charging = false;
battery_hw_type_t g_hw_type = BATTERY_HW_MOCK;
float g_soc = 100.0f;           // State of charge (fuel gauge)
float g_charge_rate = 0.0f;     // Charge rate in %/hour

// TODO: Replace with actual ADC reading
uint32_t read_battery_adc() {
    // Placeholder: Return a mock voltage
    // In real implementation:
    // 1. Configure ADC channel connected to battery voltage divider
    // 2. Read ADC value
    // 3. Convert to voltage considering divider ratio
    
    // For now, simulate a slowly discharging battery
    static uint32_t mock_mv = 4100;
    static int64_t last_update = 0;
    
    int64_t now = esp_timer_get_time() / 1000;  // ms
    if (now - last_update > 60000) {  // Every minute
        if (mock_mv > BATTERY_EMPTY_MV + 100) {
            mock_mv -= 10;  // Slow discharge simulation
        }
        last_update = now;
    }
    
    return mock_mv;
}

// TODO: Replace with actual charge detection
bool read_charge_status() {
    // Placeholder: Check charging status
    // In real implementation:
    // 1. Read GPIO connected to charge controller status pin
    // 2. Or check if voltage is rising
    // 3. Or use charge rate from fuel gauge (positive = charging)
    if (g_hw_type == BATTERY_HW_MAX17048) {
        return g_charge_rate > 0.5f;  // Charging if rate > 0.5%/hr
    }
    return false;
}

// ============================================================================
// MAX17048G Fuel Gauge Functions (to be implemented with I2C)
// ============================================================================

bool max17048_detect() {
    // TODO: Check if MAX17048G responds on I2C
    // Read version register (0x08) to verify device presence
    // Expected version: 0x001x for MAX17048
    ESP_LOGI(TAG, "MAX17048G detection not yet implemented");
    return false;
}

uint32_t max17048_read_voltage() {
    // TODO: Read VCELL register (0x02)
    // Voltage = (Register value >> 4) * 1.25mV
    // Register is 16-bit, upper 12 bits are voltage
    return 0;
}

float max17048_read_soc() {
    // TODO: Read SOC register (0x04)
    // SOC% = Register value / 256
    // Gives percentage with 1/256% resolution (0.00390625%)
    return 0.0f;
}

float max17048_read_charge_rate() {
    // TODO: Read CRATE register (0x16)
    // Rate = (int16_t)Register value * 0.208 %/hour
    // Positive = charging, Negative = discharging
    return 0.0f;
}

void max17048_init() {
    // TODO: Initialize MAX17048G
    // 1. Check version register
    // 2. Configure alert thresholds if needed
    // 3. Quick start if needed for recalibration
    ESP_LOGI(TAG, "MAX17048G init not yet implemented");
}

uint8_t voltage_to_percentage(uint32_t voltage_mv) {
    if (voltage_mv >= BATTERY_FULL_MV) return 100;
    if (voltage_mv <= BATTERY_EMPTY_MV) return 0;
    
    // Linear interpolation (can be improved with discharge curve)
    uint32_t range = BATTERY_FULL_MV - BATTERY_EMPTY_MV;
    uint32_t level = voltage_mv - BATTERY_EMPTY_MV;
    return (uint8_t)((level * 100) / range);
}

void monitoring_task(void* param) {
    ESP_LOGI(TAG, "Battery monitoring task started (hw_type=%d)", g_hw_type);
    
    while (g_monitoring_active) {
        uint8_t percentage;
        
        if (g_hw_type == BATTERY_HW_MAX17048) {
            // Use fuel gauge for accurate readings
            g_soc = max17048_read_soc();
            g_charge_rate = max17048_read_charge_rate();
            g_last_voltage_mv = max17048_read_voltage();
            g_is_charging = (g_charge_rate > 0.5f);
            percentage = (uint8_t)(g_soc + 0.5f);  // Round to nearest
            
            ESP_LOGD(TAG, "Fuel gauge: %.2f%% SOC, %.1f%%/hr, %lumV",
                g_soc, g_charge_rate, g_last_voltage_mv);
        } else {
            // Fallback to ADC/mock reading
            g_last_voltage_mv = read_battery_adc();
            g_is_charging = read_charge_status();
            percentage = voltage_to_percentage(g_last_voltage_mv);
            g_soc = (float)percentage;
            
            ESP_LOGD(TAG, "Battery: %lumV (%d%%), charging: %s", 
                g_last_voltage_mv, percentage, g_is_charging ? "yes" : "no");
        }
        
        // Update status display
        status_set_battery(percentage, g_is_charging);
        
        vTaskDelay(pdMS_TO_TICKS(BATTERY_READ_INTERVAL_MS));
    }
    
    ESP_LOGI(TAG, "Battery monitoring task stopped");
    g_monitoring_task = nullptr;
    vTaskDelete(nullptr);
}

}  // namespace

void battery_service_init(void) {
    ESP_LOGI(TAG, "Initializing battery service");
    
    // Try to detect MAX17048G fuel gauge first
    if (max17048_detect()) {
        ESP_LOGI(TAG, "MAX17048G fuel gauge detected!");
        g_hw_type = BATTERY_HW_MAX17048;
        max17048_init();
        g_soc = max17048_read_soc();
        g_last_voltage_mv = max17048_read_voltage();
        g_charge_rate = max17048_read_charge_rate();
        g_is_charging = (g_charge_rate > 0.5f);
    } else {
        ESP_LOGI(TAG, "No fuel gauge found, using mock/ADC mode");
        g_hw_type = BATTERY_HW_MOCK;  // Change to BATTERY_HW_ADC when ADC configured
        
        // TODO: Initialize ADC for battery reading
        // adc1_config_width(ADC_WIDTH_BIT_12);
        // adc1_config_channel_atten(BATTERY_ADC_CHANNEL, ADC_ATTEN_DB_11);
        
        // TODO: Initialize GPIO for charge status
        // gpio_set_direction(CHARGE_STATUS_GPIO, GPIO_MODE_INPUT);
        
        // Initial read
        g_last_voltage_mv = read_battery_adc();
        g_is_charging = read_charge_status();
        g_soc = (float)voltage_to_percentage(g_last_voltage_mv);
    }
}

uint8_t battery_get_percentage(void) {
    return voltage_to_percentage(g_last_voltage_mv);
}

bool battery_is_charging(void) {
    return g_is_charging;
}

uint32_t battery_get_voltage_mv(void) {
    return g_last_voltage_mv;
}

void battery_start_monitoring(void) {
    if (g_monitoring_task != nullptr) {
        ESP_LOGW(TAG, "Monitoring already active");
        return;
    }
    
    g_monitoring_active = true;
    xTaskCreate(
        monitoring_task,
        "battery_mon",
        2048,
        nullptr,
        1,  // Low priority
        &g_monitoring_task
    );
}

void battery_stop_monitoring(void) {
    g_monitoring_active = false;
    // Task will self-terminate
}

battery_hw_type_t battery_get_hw_type(void) {
    return g_hw_type;
}

bool battery_has_fuel_gauge(void) {
    return g_hw_type == BATTERY_HW_MAX17048;
}

float battery_get_soc(void) {
    return g_soc;
}

float battery_get_charge_rate(void) {
    return g_charge_rate;
}
