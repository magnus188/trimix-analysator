#include "services/battery_service.h"
#include "ui/components/status_icons.h"

namespace {

uint8_t g_percentage = 86;
bool g_charging = false;
uint32_t g_voltage_mv = 4030;

}  // namespace

void battery_service_init(void) {
    status_set_battery(g_percentage, g_charging);
}

uint8_t battery_get_percentage(void) {
    return g_percentage;
}

bool battery_is_charging(void) {
    return g_charging;
}

uint32_t battery_get_voltage_mv(void) {
    return g_voltage_mv;
}

void battery_start_monitoring(void) {
    status_set_battery(g_percentage, g_charging);
}

void battery_stop_monitoring(void) {}

battery_hw_type_t battery_get_hw_type(void) {
    return BATTERY_HW_MOCK;
}

bool battery_has_fuel_gauge(void) {
    return false;
}

float battery_get_soc(void) {
    return static_cast<float>(g_percentage);
}

float battery_get_charge_rate(void) {
    return g_charging ? 18.0f : -2.0f;
}
