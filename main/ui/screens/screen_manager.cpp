#include "screen_manager.h"
#include "sensors/sensor_interface.h"
#include "home/home.h"
#include "analyze/analyze.h"
#include "dive_planner/dive_planner.h"
#include "history/history.h"
#include "settings/settings.h"
#include "calibrate_o2/calibrate_o2.h"
#include "wifi/wifi_settings.h"
#include <esp_log.h>
#include <esp_timer.h>
#include <array>

namespace {
static const char *TAG = "SCREEN_MANAGER";

class ScreenManager {
public:
    static ScreenManager &instance() {
        static ScreenManager mgr;
        return mgr;
    }
    
    void init() {
        ESP_LOGI(TAG, "Initializing screen manager");
        screens_[SCREEN_HOME] = screen_home_create();
        screens_[SCREEN_ANALYZE] = screen_analyze_create();
        screens_[SCREEN_DIVE_PLANNER] = screen_dive_planner_create();
        screens_[SCREEN_HISTORY] = screen_history_create();
        screens_[SCREEN_SETTINGS] = screen_settings_create();
        screens_[SCREEN_CALIBRATE_O2] = screen_calibrate_o2_create();
        screens_[SCREEN_WIFI_SETTINGS] = screen_wifi_settings_create();
        
        show(SCREEN_HOME);
        
        // Start sensor update timer
        const esp_timer_create_args_t timer_args = {
            .callback = &sensor_update_callback,
            .arg = nullptr,
            .dispatch_method = ESP_TIMER_TASK,
            .name = "sensor_update",
            .skip_unhandled_events = true
        };
        esp_timer_create(&timer_args, &sensor_update_timer_);
        esp_timer_start_periodic(sensor_update_timer_, 2000000); // 2 seconds
    }
    
    void show(screen_id_t id) {
        if (id >= SCREEN_COUNT) {
            ESP_LOGE(TAG, "Invalid screen %d", id);
            return;
        }
        
        // Cleanup previous screen if needed
        if (current_screen_ == SCREEN_WIFI_SETTINGS && id != SCREEN_WIFI_SETTINGS) {
            ESP_LOGI(TAG, "Cleaning up WiFi settings screen");
            screen_wifi_settings_cleanup();
        }
        
        current_screen_ = id;
        lv_scr_load(screens_[id]);
    }
    
    screen_id_t current() const {
        return current_screen_;
    }
    
    void set_analyze_labels(lv_obj_t *o2, lv_obj_t *co2, lv_obj_t *temp, lv_obj_t *pressure, lv_obj_t *humidity) {
        label_o2_ = o2;
        label_co2_ = co2;
        label_temp_ = temp;
        label_pressure_ = pressure;
        label_humidity_ = humidity;
    }
    
    void update_analyze() {
        if (!label_o2_ || !label_co2_ || !label_temp_ || !label_pressure_ || !label_humidity_) {
            return;
        }
        
        sensor_readings_t readings{};
        if (sensor_read_all(&readings) == ESP_OK) {
            lv_label_set_text_fmt(label_o2_, "%.1f %%", readings.oxygen_percent);
            lv_label_set_text_fmt(label_co2_, "%.0f ppm", readings.co2_ppm);
            lv_label_set_text_fmt(label_temp_, "%.1f °C", readings.temperature_c);
            lv_label_set_text_fmt(label_pressure_, "%.2f bar", readings.pressure_bar);
            lv_label_set_text_fmt(label_humidity_, "%.1f %%", readings.humidity_pct);
        }
    }
    
    bool analyze_active() const {
        return current_screen_ == SCREEN_ANALYZE;
    }
    
private:
    std::array<lv_obj_t*, SCREEN_COUNT> screens_{};
    screen_id_t current_screen_ = SCREEN_HOME;
    lv_obj_t *label_o2_ = nullptr;
    lv_obj_t *label_co2_ = nullptr;
    lv_obj_t *label_temp_ = nullptr;
    lv_obj_t *label_pressure_ = nullptr;
    lv_obj_t *label_humidity_ = nullptr;
    esp_timer_handle_t sensor_update_timer_{};
    
    static void sensor_update_callback(void * /*arg*/) {
        if (instance().analyze_active()) {
            instance().update_analyze();
        }
    }
};

static inline ScreenManager &mgr() {
    return ScreenManager::instance();
}

} // namespace

// C interface implementation
extern "C" {

void screen_manager_init(void) {
    mgr().init();
}

void screen_manager_show(screen_id_t screen) {
    mgr().show(screen);
}

screen_id_t screen_manager_current(void) {
    return mgr().current();
}

void screen_manager_set_analyze_labels(lv_obj_t *o2, lv_obj_t *co2, lv_obj_t *temp, lv_obj_t *pressure, lv_obj_t *humidity) {
    mgr().set_analyze_labels(o2, co2, temp, pressure, humidity);
}

void screen_manager_update_analyze(void) {
    mgr().update_analyze();
}

// Legacy compatibility functions
void screens_init(void) {
    screen_manager_init();
}

void update_analyze_screen(void) {
    screen_manager_update_analyze();
}

void navigate_to_home(void) {
    screen_manager_show(SCREEN_HOME);
}

void navigate_to_analyze(void) {
    screen_manager_show(SCREEN_ANALYZE);
}

void navigate_to_dive_planner(void) {
    screen_manager_show(SCREEN_DIVE_PLANNER);
}

void navigate_to_history(void) {
    screen_manager_show(SCREEN_HISTORY);
}

void navigate_to_settings(void) {
    screen_manager_show(SCREEN_SETTINGS);
}

void navigate_to_calibrate_o2(void) {
    screen_manager_show(SCREEN_CALIBRATE_O2);
}

}
