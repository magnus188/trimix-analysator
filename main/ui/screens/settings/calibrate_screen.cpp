#include "calibrate_screen.h"
#include "sensors/sensor_interface.h"
#include "../screen_manager.h"
#include "../../components/navbar.h"
#include "../../styles/styles.h"
#include <esp_log.h>
#include <cstdio>

static const char* TAG = "CALIBRATE_SCREEN";

namespace {

constexpr int SCREEN_WIDTH = 480;
constexpr int SCREEN_HEIGHT = 800;
constexpr int NAVBAR_HEIGHT = 70;
constexpr int PAD = 16;

struct CalibrateState {
    lv_obj_t* screen = nullptr;
    lv_obj_t* sample_label = nullptr;
    lv_obj_t* guide_label = nullptr;
    lv_obj_t* status_label = nullptr;
    lv_obj_t* record_btn = nullptr;
    lv_timer_t* timer = nullptr;
    uint8_t stable_count = 0;
    uint8_t active_step = 0;
};

CalibrateState g_state;

void back_cb(lv_event_t*) {
    screen_manager_show(SCREEN_SETTINGS);
}

lv_obj_t* create_panel(lv_obj_t* parent, int y, int h) {
    lv_obj_t* panel = lv_obj_create(parent);
    lv_obj_set_size(panel, SCREEN_WIDTH - PAD * 2, h);
    lv_obj_set_pos(panel, PAD, y);
    lv_obj_set_style_bg_color(panel, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_radius(panel, 8, 0);
    lv_obj_set_style_border_width(panel, 1, 0);
    lv_obj_set_style_border_color(panel, lv_color_hex(STYLE_COLOR_BORDER), 0);
    lv_obj_set_style_pad_all(panel, 14, 0);
    lv_obj_clear_flag(panel, LV_OBJ_FLAG_SCROLLABLE);
    return panel;
}

lv_obj_t* create_action(lv_obj_t* parent, const char* label, int y, lv_event_cb_t cb, void* data = nullptr) {
    lv_obj_t* btn = lv_btn_create(parent);
    lv_obj_set_size(btn, SCREEN_WIDTH - PAD * 4, 50);
    lv_obj_set_pos(btn, PAD, y);
    lv_obj_set_style_bg_color(btn, lv_color_hex(STYLE_COLOR_BG_CARD), 0);
    lv_obj_set_style_bg_color(btn, lv_color_hex(STYLE_COLOR_PRIMARY), LV_STATE_PRESSED);
    lv_obj_set_style_radius(btn, 8, 0);
    lv_obj_set_style_shadow_width(btn, 0, 0);
    lv_obj_add_event_cb(btn, cb, LV_EVENT_CLICKED, data);
    lv_obj_t* btn_label = lv_label_create(btn);
    lv_label_set_text(btn_label, label);
    lv_obj_set_style_text_font(btn_label, &lv_font_montserrat_16, 0);
    lv_obj_center(btn_label);
    return btn;
}

void set_status(esp_err_t err, const char* ok_text, const char* fail_text) {
    if (err == ESP_OK) {
        lv_label_set_text(g_state.status_label, ok_text);
        lv_obj_set_style_text_color(g_state.status_label, lv_color_hex(STYLE_COLOR_SUCCESS), 0);
    } else {
        lv_label_set_text(g_state.status_label, fail_text);
        lv_obj_set_style_text_color(g_state.status_label, lv_color_hex(STYLE_COLOR_ERROR), 0);
    }
}

const char* step_title(uint8_t step) {
    switch (step) {
        case 0: return "Step 1: O2 ambient air";
        case 1: return "Step 2: CO2 zero";
        case 2: return "Step 3: CO2 400 ppm reference";
        default: return "Calibration";
    }
}

const char* step_instruction(uint8_t step) {
    switch (step) {
        case 0: return "Expose the oxygen sensor to clean ambient air and wait for three stable samples.";
        case 1: return "Apply zero gas or scrubbed sample flow and wait for three stable samples.";
        case 2: return "Apply the 400 ppm reference gas and wait for three stable samples.";
        default: return "Select a calibration step.";
    }
}

void update_guide() {
    char buf[192];
    std::snprintf(buf, sizeof(buf), "%s\n%s\nStable samples: %u/3",
                  step_title(g_state.active_step),
                  step_instruction(g_state.active_step),
                  static_cast<unsigned>(g_state.stable_count));
    lv_label_set_text(g_state.guide_label, buf);
    if (g_state.record_btn) {
        if (g_state.stable_count >= 3) {
            lv_obj_clear_state(g_state.record_btn, LV_STATE_DISABLED);
        } else {
            lv_obj_add_state(g_state.record_btn, LV_STATE_DISABLED);
        }
    }
}

void refresh_sample() {
    sensor_readings_t r = {};
    sensor_read_all(&r);
    char buf[160];
    std::snprintf(buf, sizeof(buf),
                  "%s | O2 %.1f%% | He %.1f%% | CO2 %.0f ppm | %.1f C | %.2f bar",
                  sensor_status_label(r.status), r.oxygen_percent, r.helium_percent,
                  r.co2_ppm, r.temperature_c, r.pressure_bar);
    lv_label_set_text(g_state.sample_label, buf);
    if (r.status == SENSOR_STATUS_STABLE) {
        if (g_state.stable_count < 3) {
            ++g_state.stable_count;
        }
    } else {
        g_state.stable_count = 0;
    }
    update_guide();
}

void timer_cb(lv_timer_t*) {
    refresh_sample();
}

void screen_visibility_cb(lv_event_t* event) {
    if (!g_state.timer) return;

    if (lv_event_get_code(event) == LV_EVENT_SCREEN_LOADED) {
        refresh_sample();
        lv_timer_resume(g_state.timer);
    } else {
        lv_timer_pause(g_state.timer);
    }
}

void select_step_cb(lv_event_t* e) {
    g_state.active_step = static_cast<uint8_t>(reinterpret_cast<intptr_t>(lv_event_get_user_data(e)));
    g_state.stable_count = 0;
    update_guide();
    lv_label_set_text(g_state.status_label, "Waiting for stable samples");
}

void record_step_cb(lv_event_t*) {
    if (g_state.stable_count < 3) {
        lv_label_set_text(g_state.status_label, "Wait for three stable samples before recording");
        lv_obj_set_style_text_color(g_state.status_label, lv_color_hex(STYLE_COLOR_WARNING), 0);
        return;
    }

    switch (g_state.active_step) {
        case 0:
            set_status(sensor_calibrate_oxygen_air(),
                       "O2 ambient-air calibration recorded",
                       "O2 calibration unavailable while the sensor is faulted");
            break;
        case 1:
            set_status(sensor_calibrate_co2_zero(),
                       "CO2 zero calibration recorded",
                       "CO2 zero calibration unavailable while the sensor is faulted");
            break;
        case 2:
            set_status(sensor_calibrate_co2_reference(400),
                       "CO2 400 ppm reference recorded",
                       "CO2 reference calibration unavailable while the sensor is faulted");
            break;
        default:
            break;
    }
}

}  // namespace

lv_obj_t* calibrate_screen_create(void) {
    ESP_LOGI(TAG, "Creating calibration screen");
    g_state = CalibrateState{};

    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BG_DARK), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    g_state.screen = screen;

    navbar_create_with_back(screen, "Calibrate Sensors", back_cb);

    lv_obj_t* intro = create_panel(screen, NAVBAR_HEIGHT + 16, 132);
    lv_obj_t* title = lv_label_create(intro);
    lv_label_set_text(title, "Sensor calibration");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_22, 0);
    lv_obj_set_style_text_color(title, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(title, LV_ALIGN_TOP_LEFT, 0, 0);

    lv_obj_t* body = lv_label_create(intro);
    lv_label_set_text(body, "Simulation mode records calibration actions. Hardware calibration remains disabled until ADS1115, BMP280, R17JJ-CCR, and MD62 drivers are installed.");
    lv_obj_set_style_text_font(body, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(body, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_width(body, SCREEN_WIDTH - PAD * 4);
    lv_label_set_long_mode(body, LV_LABEL_LONG_WRAP);
    lv_obj_align(body, LV_ALIGN_TOP_LEFT, 0, 42);

    lv_obj_t* sample = create_panel(screen, NAVBAR_HEIGHT + 164, 92);
    g_state.sample_label = lv_label_create(sample);
    lv_label_set_text(g_state.sample_label, "--");
    lv_obj_set_style_text_font(g_state.sample_label, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(g_state.sample_label, lv_color_hex(STYLE_COLOR_DATA), 0);
    lv_obj_set_width(g_state.sample_label, SCREEN_WIDTH - PAD * 4);
    lv_label_set_long_mode(g_state.sample_label, LV_LABEL_LONG_WRAP);
    lv_obj_align(g_state.sample_label, LV_ALIGN_CENTER, 0, 0);

    lv_obj_t* actions = create_panel(screen, NAVBAR_HEIGHT + 272, 244);
    g_state.guide_label = lv_label_create(actions);
    lv_label_set_text(g_state.guide_label, "--");
    lv_obj_set_style_text_font(g_state.guide_label, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(g_state.guide_label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_width(g_state.guide_label, SCREEN_WIDTH - PAD * 4);
    lv_label_set_long_mode(g_state.guide_label, LV_LABEL_LONG_WRAP);
    lv_obj_set_pos(g_state.guide_label, PAD, 8);

    lv_obj_t* o2_btn = create_action(actions, "O2 Air", 96, select_step_cb,
                                     reinterpret_cast<void*>(static_cast<intptr_t>(0)));
    lv_obj_set_width(o2_btn, 120);
    lv_obj_t* zero_btn = create_action(actions, "CO2 Zero", 96, select_step_cb,
                                       reinterpret_cast<void*>(static_cast<intptr_t>(1)));
    lv_obj_set_width(zero_btn, 130);
    lv_obj_set_x(zero_btn, 148);
    lv_obj_t* ref_btn = create_action(actions, "CO2 Ref", 96, select_step_cb,
                                      reinterpret_cast<void*>(static_cast<intptr_t>(2)));
    lv_obj_set_width(ref_btn, 130);
    lv_obj_set_x(ref_btn, 292);

    g_state.record_btn = create_action(actions, "Record Current Step", 164, record_step_cb);

    lv_obj_t* status = create_panel(screen, NAVBAR_HEIGHT + 532, 116);
    g_state.status_label = lv_label_create(status);
    lv_label_set_text(g_state.status_label, "Select a step and wait for stable samples");
    lv_obj_set_style_text_font(g_state.status_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_state.status_label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_width(g_state.status_label, SCREEN_WIDTH - PAD * 4);
    lv_label_set_long_mode(g_state.status_label, LV_LABEL_LONG_WRAP);
    lv_obj_align(g_state.status_label, LV_ALIGN_CENTER, 0, 0);

    update_guide();
    refresh_sample();
    g_state.timer = lv_timer_create(timer_cb, 1500, nullptr);
    lv_timer_pause(g_state.timer);
    lv_obj_add_event_cb(screen, screen_visibility_cb, LV_EVENT_SCREEN_LOADED, nullptr);
    lv_obj_add_event_cb(screen, screen_visibility_cb, LV_EVENT_SCREEN_UNLOADED, nullptr);
    return screen;
}
