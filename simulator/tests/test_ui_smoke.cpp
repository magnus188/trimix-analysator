#include <lvgl.h>

#include "services/battery_service.h"
#include "services/ota_service.h"
#include "services/settings_service.h"
#include "services/wifi_service.h"
#include "ui/screens/screen_manager.h"

#include <cstdio>

namespace {

uint8_t g_draw_buffer[480 * 40 * 2];

void flush_cb(lv_display_t* display, const lv_area_t*, uint8_t*) {
    lv_display_flush_ready(display);
}

void pump_lvgl(int frames = 3) {
    for (int i = 0; i < frames; ++i) {
        lv_tick_inc(16);
        lv_timer_handler();
    }
}

bool show_and_check(screen_id_t screen) {
    screen_manager_show(screen);
    pump_lvgl();
    if (screen_manager_current() != screen) {
        std::fprintf(stderr, "Expected current screen %d, got %d\n", screen, screen_manager_current());
        return false;
    }
    if (screen == SCREEN_ANALYSE) {
        pump_lvgl(8);
    }
    return true;
}

}  // namespace

int main() {
    lv_init();
    lv_display_t* display = lv_display_create(480, 800);
    lv_display_set_flush_cb(display, flush_cb);
    lv_display_set_buffers(display, g_draw_buffer, nullptr, sizeof(g_draw_buffer), LV_DISPLAY_RENDER_MODE_PARTIAL);

    settings_init();
    wifi_service_init();
    battery_service_init();
    ota_service_init();

    screen_manager_init();
    battery_start_monitoring();
    pump_lvgl();

    bool ok = true;
    ok = show_and_check(SCREEN_HOME) && ok;
    ok = show_and_check(SCREEN_ANALYSE) && ok;
    ok = show_and_check(SCREEN_DIVE_PLANNER) && ok;
    ok = show_and_check(SCREEN_HISTORY) && ok;
    ok = show_and_check(SCREEN_CYLINDERS) && ok;
    ok = show_and_check(SCREEN_SETTINGS) && ok;
    ok = show_and_check(SCREEN_WIFI) && ok;
    ok = show_and_check(SCREEN_UPDATE) && ok;
    ok = show_and_check(SCREEN_CALIBRATE) && ok;
    ok = show_and_check(SCREEN_SAFETY) && ok;
    ok = show_and_check(SCREEN_DEVICE) && ok;

    return ok ? 0 : 1;
}
