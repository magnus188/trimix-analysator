#include "battery_service.h"
#include "../ui/components/status_icons.h"
#include <esp_log.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <esp_timer.h>

static const char* TAG = "BATTERY_SVC";

namespace {

// Battery configuration - adjust these for your specific battery and ADC setup
constexpr uint32_t BATTERY_FULL_MV = 4200;      // 4.2V for LiPo
constexpr uint32_t BATTERY_EMPTY_MV = 3300;     // 3.3V cutoff
constexpr uint32_t BATTERY_READ_INTERVAL_MS = 30000;  // Read every 30 seconds

// State
TaskHandle_t g_monitoring_task = nullptr;
volatile bool g_monitoring_active = false;
uint32_t g_last_voltage_mv = BATTERY_FULL_MV;
bool g_is_charging = false;

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
    return false;
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
    ESP_LOGI(TAG, "Battery monitoring task started");
    
    while (g_monitoring_active) {
        // Read battery
        g_last_voltage_mv = read_battery_adc();
        g_is_charging = read_charge_status();
        
        uint8_t percentage = voltage_to_percentage(g_last_voltage_mv);
        
        // Update status display
        status_set_battery(percentage, g_is_charging);
        
        ESP_LOGD(TAG, "Battery: %lumV (%d%%), charging: %s", 
            g_last_voltage_mv, percentage, g_is_charging ? "yes" : "no");
        
        vTaskDelay(pdMS_TO_TICKS(BATTERY_READ_INTERVAL_MS));
    }
    
    ESP_LOGI(TAG, "Battery monitoring task stopped");
    g_monitoring_task = nullptr;
    vTaskDelete(nullptr);
}

}  // namespace

void battery_service_init(void) {
    ESP_LOGI(TAG, "Initializing battery service");
    
    // TODO: Initialize ADC for battery reading
    // adc1_config_width(ADC_WIDTH_BIT_12);
    // adc1_config_channel_atten(BATTERY_ADC_CHANNEL, ADC_ATTEN_DB_11);
    
    // TODO: Initialize GPIO for charge status
    // gpio_set_direction(CHARGE_STATUS_GPIO, GPIO_MODE_INPUT);
    
    // Initial read
    g_last_voltage_mv = read_battery_adc();
    g_is_charging = read_charge_status();
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
