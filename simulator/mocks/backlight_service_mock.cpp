#include "services/backlight_service.h"

namespace {

uint8_t g_brightness = 100;

}  // namespace

void backlight_init(void) {
    g_brightness = 100;
}

void backlight_set(uint8_t percent) {
    g_brightness = percent > 100 ? 100 : percent;
}

uint8_t backlight_get(void) {
    return g_brightness;
}
