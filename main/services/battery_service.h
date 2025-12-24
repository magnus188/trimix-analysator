#pragma once
#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Initialize battery monitoring
 * Call this once during system startup
 */
void battery_service_init(void);

/**
 * Read current battery voltage and calculate percentage
 * @return Battery percentage (0-100)
 */
uint8_t battery_get_percentage(void);

/**
 * Check if battery is currently charging
 * @return true if charging
 */
bool battery_is_charging(void);

/**
 * Get raw battery voltage in millivolts
 * @return Voltage in mV
 */
uint32_t battery_get_voltage_mv(void);

/**
 * Start periodic battery monitoring task
 * Updates the status icons automatically
 */
void battery_start_monitoring(void);

/**
 * Stop battery monitoring task
 */
void battery_stop_monitoring(void);

#ifdef __cplusplus
}
#endif
