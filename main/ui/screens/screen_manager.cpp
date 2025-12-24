#include "screen_manager.h"
#include "home/home_screen.h"
#include "settings/settings_screen.h"
#include "settings/wifi_screen.h"
#include "../styles/styles.h"
#include "../components/navbar.h"
#include <array>
#include <esp_log.h>

namespace {
static const char *TAG = "SCREEN_MANAGER";

lv_obj_t* create_placeholder_screen(const char* name) {
    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BG_DARK), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);

    // Navbar with back button
    navbar_create_with_back(screen, name, nullptr);

    // Coming soon label
    lv_obj_t* label = lv_label_create(screen);
    lv_label_set_text(label, "Coming Soon");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_align(label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_align(label, LV_ALIGN_CENTER, 0, 0);

    return screen;
}

class ScreenManager {
public:
    static ScreenManager& instance() {
        static ScreenManager mgr;
        return mgr;
    }

    void init() {
        ESP_LOGI(TAG, "Initializing screen manager");
        
        // Initialize styles first
        styles_init();
        
        // Create screens
        screens_[SCREEN_HOME] = home_screen_create();
        screens_[SCREEN_ANALYSE] = create_placeholder_screen("Analyse");
        screens_[SCREEN_DIVE_PLANNER] = create_placeholder_screen("Dive Planner");
        screens_[SCREEN_HISTORY] = create_placeholder_screen("History");
        screens_[SCREEN_SETTINGS] = settings_screen_create();
        screens_[SCREEN_WIFI] = wifi_screen_create();
        screens_[SCREEN_CALIBRATE] = create_placeholder_screen("Calibrate Sensors");
        screens_[SCREEN_SAFETY] = create_placeholder_screen("Safety Settings");
        screens_[SCREEN_DEVICE] = create_placeholder_screen("Device Settings");
        
        show(SCREEN_HOME);
    }

    void show(screen_id_t id) {
        if (id >= SCREEN_COUNT) {
            ESP_LOGE(TAG, "Invalid screen %d", id);
            return;
        }

        current_screen_ = id;
        lv_scr_load(screens_[id]);
    }

    screen_id_t current() const {
        return current_screen_;
    }

private:
    std::array<lv_obj_t*, SCREEN_COUNT> screens_{};
    screen_id_t current_screen_ = SCREEN_HOME;
};

static ScreenManager& mgr() {
    return ScreenManager::instance();
}

}  // namespace

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

void screens_init(void) {
    screen_manager_init();
}

}
