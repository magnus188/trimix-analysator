#include "dive_planner_screen.h"
#include "gas_calculator.h"
#include "../../styles/styles.h"
#include "../../components/navbar.h"
#include "../screen_manager.h"
#include <esp_log.h>
#include <cstdio>

static const char* TAG = "DIVE_PLANNER";

namespace {

// Layout constants
constexpr int SCREEN_WIDTH = 480;
constexpr int SCREEN_HEIGHT = 800;
constexpr int NAVBAR_HEIGHT = 70;
constexpr int CONTENT_PAD = 16;
constexpr int SLIDER_ROW_HEIGHT = 90;
constexpr int SLIDER_HEIGHT = 20;
constexpr int CARD_RADIUS = 12;
constexpr int RESULT_CARD_HEIGHT = 100;

// Slider ranges
constexpr int DEPTH_MIN = 0;
constexpr int DEPTH_MAX = 150;
constexpr int PPO2_MIN = 100;  // 1.00 bar * 100
constexpr int PPO2_MAX = 200;  // 2.00 bar * 100
constexpr int O2_MIN = 0;
constexpr int O2_MAX = 100;
constexpr int EAD_MIN = 0;
constexpr int EAD_MAX = 60;
constexpr int HELIUM_MIN = 0;
constexpr int HELIUM_MAX = 100;

// Which parameter can be locked
enum class LockTarget {
    NONE,
    DEPTH,
    PPO2,
    O2,
    EAD,
    HELIUM
};

// Screen state
struct DivePlannerState {
    lv_obj_t* screen = nullptr;
    
    // Sliders
    lv_obj_t* depth_slider = nullptr;
    lv_obj_t* ppo2_slider = nullptr;
    lv_obj_t* o2_slider = nullptr;
    lv_obj_t* ead_slider = nullptr;
    lv_obj_t* helium_slider = nullptr;
    
    // Value labels
    lv_obj_t* depth_value = nullptr;
    lv_obj_t* ppo2_value = nullptr;
    lv_obj_t* o2_value = nullptr;
    lv_obj_t* ead_value = nullptr;
    lv_obj_t* helium_value = nullptr;
    
    // Lock buttons
    lv_obj_t* depth_lock = nullptr;
    lv_obj_t* ppo2_lock = nullptr;
    lv_obj_t* o2_lock = nullptr;
    lv_obj_t* ead_lock = nullptr;
    lv_obj_t* helium_lock = nullptr;
    
    // Trimix section
    lv_obj_t* trimix_toggle = nullptr;
    lv_obj_t* trimix_section = nullptr;
    
    // Result display
    lv_obj_t* result_o2 = nullptr;
    lv_obj_t* result_mod = nullptr;
    lv_obj_t* result_mix = nullptr;
    lv_obj_t* result_density = nullptr;
    
    // Current values
    float depth = 30.0f;      // meters
    float ppo2 = 1.40f;       // bar
    float o2 = 21.0f;         // percent
    float ead = 30.0f;        // meters
    float helium = 0.0f;      // percent
    
    // Lock state
    LockTarget locked = LockTarget::NONE;
    bool trimix_enabled = false;
    bool updating = false;  // Prevent recursive updates
};

DivePlannerState g_state;

// Forward declarations
void update_all_displays();
void recalculate_from_depth();
void recalculate_from_ppo2();
void recalculate_from_ead();
void recalculate_from_helium();
void update_lock_button_styles();

// Update value label text
void update_value_label(lv_obj_t* label, const char* format, float value) {
    char buf[32];
    snprintf(buf, sizeof(buf), format, value);
    lv_label_set_text(label, buf);
}

// Set lock button appearance
void set_lock_button_style(lv_obj_t* btn, bool is_locked) {
    if (is_locked) {
        lv_obj_set_style_bg_color(btn, lv_color_hex(STYLE_COLOR_WARNING), 0);
        lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
        lv_label_set_text(lv_obj_get_child(btn, 0), LV_SYMBOL_OK);
    } else {
        lv_obj_set_style_bg_color(btn, lv_color_hex(STYLE_COLOR_SURFACE), 0);
        lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
        lv_label_set_text(lv_obj_get_child(btn, 0), LV_SYMBOL_MINUS);
    }
}

void update_lock_button_styles() {
    set_lock_button_style(g_state.depth_lock, g_state.locked == LockTarget::DEPTH);
    set_lock_button_style(g_state.ppo2_lock, g_state.locked == LockTarget::PPO2);
    set_lock_button_style(g_state.o2_lock, g_state.locked == LockTarget::O2);
    if (g_state.ead_lock) {
        set_lock_button_style(g_state.ead_lock, g_state.locked == LockTarget::EAD);
    }
    if (g_state.helium_lock) {
        set_lock_button_style(g_state.helium_lock, g_state.locked == LockTarget::HELIUM);
    }
}

// Update result card
void update_results() {
    // Calculate MOD based on user's O2 setting
    float mod = calc_mod(g_state.o2, g_state.ppo2);
    
    // Calculate gas density at depth (g/L)
    // Density = (FO2 * 1.429 + FN2 * 1.251 + FHe * 0.179) * P_abs
    // where P_abs = depth/10 + 1 (in bar)
    float p_abs = (g_state.depth / 10.0f) + 1.0f;
    float fo2 = g_state.o2 / 100.0f;
    float fhe = g_state.helium / 100.0f;
    float fn2 = 1.0f - fo2 - fhe;
    if (fn2 < 0) fn2 = 0;
    float density = (fo2 * 1.429f + fn2 * 1.251f + fhe * 0.179f) * p_abs;
    
    // Calculate PPO2 at depth for the current O2%
    float ppo2_at_depth = calc_ppo2(g_state.depth, g_state.o2);
    
    char buf[64];
    snprintf(buf, sizeof(buf), "PPO2: %.2f", ppo2_at_depth);
    lv_label_set_text(g_state.result_o2, buf);
    
    snprintf(buf, sizeof(buf), "MOD: %.0fm", mod);
    lv_label_set_text(g_state.result_mod, buf);
    
    // Show mix recommendation
    if (g_state.trimix_enabled && g_state.helium > 0) {
        float n2 = 100.0f - g_state.o2 - g_state.helium;
        if (n2 < 0) n2 = 0;
        snprintf(buf, sizeof(buf), "Mix: %.0f/%.0f (O2/He)", g_state.o2, g_state.helium);
    } else {
        if (g_state.o2 > 21.5f) {
            snprintf(buf, sizeof(buf), "EAN%.0f (Nitrox)", g_state.o2);
        } else {
            snprintf(buf, sizeof(buf), "Air (21%% O2)");
        }
    }
    lv_label_set_text(g_state.result_mix, buf);
    
    // Update density with color warning
    snprintf(buf, sizeof(buf), "%.1f g/L", density);
    lv_label_set_text(g_state.result_density, buf);
    // Color code: green < 5.2, yellow 5.2-6.0, red > 6.0
    if (density > 6.0f) {
        lv_obj_set_style_text_color(g_state.result_density, lv_color_hex(STYLE_COLOR_ERROR), 0);
    } else if (density > 5.2f) {
        lv_obj_set_style_text_color(g_state.result_density, lv_color_hex(STYLE_COLOR_WARNING), 0);
    } else {
        lv_obj_set_style_text_color(g_state.result_density, lv_color_hex(STYLE_COLOR_SUCCESS), 0);
    }
}

void update_all_displays() {
    update_value_label(g_state.depth_value, "%.0f m", g_state.depth);
    update_value_label(g_state.ppo2_value, "%.2f bar", g_state.ppo2);
    update_value_label(g_state.o2_value, "%.0f %%", g_state.o2);
    
    if (g_state.ead_value) {
        update_value_label(g_state.ead_value, "%.0f m", g_state.ead);
    }
    if (g_state.helium_value) {
        update_value_label(g_state.helium_value, "%.0f %%", g_state.helium);
    }
    
    // Update slider positions
    lv_slider_set_value(g_state.depth_slider, (int)g_state.depth, LV_ANIM_OFF);
    lv_slider_set_value(g_state.ppo2_slider, (int)(g_state.ppo2 * 100), LV_ANIM_OFF);
    lv_slider_set_value(g_state.o2_slider, (int)g_state.o2, LV_ANIM_OFF);
    
    if (g_state.ead_slider) {
        lv_slider_set_value(g_state.ead_slider, (int)g_state.ead, LV_ANIM_OFF);
    }
    if (g_state.helium_slider) {
        lv_slider_set_value(g_state.helium_slider, (int)g_state.helium, LV_ANIM_OFF);
    }
    
    update_results();
}

// Recalculation functions based on which slider changed
void recalculate_from_depth() {
    if (g_state.updating) return;
    g_state.updating = true;
    
    if (g_state.trimix_enabled) {
        switch (g_state.locked) {
            case LockTarget::EAD:
                // Depth changed, EAD locked -> adjust helium
                g_state.helium = calc_helium_for_ead(g_state.depth, g_state.ead);
                break;
            case LockTarget::HELIUM:
                // Depth changed, He locked -> adjust EAD
                g_state.ead = calc_ead(g_state.depth, g_state.helium);
                break;
            default:
                // No trimix lock, just update EAD
                g_state.ead = calc_ead(g_state.depth, g_state.helium);
                break;
        }
    }
    
    update_all_displays();
    g_state.updating = false;
}

void recalculate_from_ppo2() {
    if (g_state.updating) return;
    g_state.updating = true;
    
    // PPO2 change affects recommended O2%, shown in results
    update_all_displays();
    g_state.updating = false;
}

void recalculate_from_ead() {
    if (g_state.updating) return;
    g_state.updating = true;
    
    switch (g_state.locked) {
        case LockTarget::DEPTH:
            // EAD changed, depth locked -> adjust helium
            g_state.helium = calc_helium_for_ead(g_state.depth, g_state.ead);
            break;
        case LockTarget::HELIUM:
            // EAD changed, helium locked -> adjust depth
            g_state.depth = calc_depth_for_ead(g_state.ead, g_state.helium);
            g_state.depth = clamp_float(g_state.depth, DEPTH_MIN, DEPTH_MAX);
            break;
        default:
            // No lock, adjust helium by default
            g_state.helium = calc_helium_for_ead(g_state.depth, g_state.ead);
            break;
    }
    
    update_all_displays();
    g_state.updating = false;
}

void recalculate_from_helium() {
    if (g_state.updating) return;
    g_state.updating = true;
    
    switch (g_state.locked) {
        case LockTarget::DEPTH:
            // Helium changed, depth locked -> adjust EAD
            g_state.ead = calc_ead(g_state.depth, g_state.helium);
            break;
        case LockTarget::EAD:
            // Helium changed, EAD locked -> adjust depth
            g_state.depth = calc_depth_for_ead(g_state.ead, g_state.helium);
            g_state.depth = clamp_float(g_state.depth, DEPTH_MIN, DEPTH_MAX);
            break;
        default:
            // No lock, adjust EAD by default
            g_state.ead = calc_ead(g_state.depth, g_state.helium);
            break;
    }
    
    update_all_displays();
    g_state.updating = false;
}

// Event handlers
void depth_slider_event_cb(lv_event_t* e) {
    if (g_state.locked == LockTarget::DEPTH) return;  // Can't change locked slider
    
    g_state.depth = (float)lv_slider_get_value(g_state.depth_slider);
    recalculate_from_depth();
}

void ppo2_slider_event_cb(lv_event_t* e) {
    if (g_state.locked == LockTarget::PPO2) return;
    
    g_state.ppo2 = lv_slider_get_value(g_state.ppo2_slider) / 100.0f;
    recalculate_from_ppo2();
}

void ead_slider_event_cb(lv_event_t* e) {
    if (g_state.locked == LockTarget::EAD) return;
    
    g_state.ead = (float)lv_slider_get_value(g_state.ead_slider);
    recalculate_from_ead();
}

void helium_slider_event_cb(lv_event_t* e) {
    if (g_state.locked == LockTarget::HELIUM) return;
    
    g_state.helium = (float)lv_slider_get_value(g_state.helium_slider);
    recalculate_from_helium();
}

void o2_slider_event_cb(lv_event_t* e) {
    if (g_state.locked == LockTarget::O2) return;
    
    g_state.o2 = (float)lv_slider_get_value(g_state.o2_slider);
    // O2 affects density calculation, just update displays
    update_all_displays();
}

void lock_button_event_cb(lv_event_t* e) {
    LockTarget target = (LockTarget)(intptr_t)lv_event_get_user_data(e);
    
    // Toggle lock
    if (g_state.locked == target) {
        g_state.locked = LockTarget::NONE;
    } else {
        g_state.locked = target;
    }
    
    update_lock_button_styles();
    ESP_LOGI(TAG, "Lock changed to: %d", (int)g_state.locked);
}

void trimix_toggle_event_cb(lv_event_t* e) {
    g_state.trimix_enabled = lv_obj_has_state(g_state.trimix_toggle, LV_STATE_CHECKED);
    
    if (g_state.trimix_section) {
        if (g_state.trimix_enabled) {
            lv_obj_clear_flag(g_state.trimix_section, LV_OBJ_FLAG_HIDDEN);
            // Reset trimix lock if was set
            if (g_state.locked == LockTarget::EAD || g_state.locked == LockTarget::HELIUM) {
                // Keep the lock
            }
        } else {
            lv_obj_add_flag(g_state.trimix_section, LV_OBJ_FLAG_HIDDEN);
            // Clear trimix-related lock
            if (g_state.locked == LockTarget::EAD || g_state.locked == LockTarget::HELIUM) {
                g_state.locked = LockTarget::NONE;
                update_lock_button_styles();
            }
            g_state.helium = 0;
            g_state.ead = g_state.depth;  // EAD equals depth with no helium
        }
    }
    
    update_all_displays();
    ESP_LOGI(TAG, "Trimix mode: %s", g_state.trimix_enabled ? "enabled" : "disabled");
}

// Create a slider row with label, value, slider, and lock button
lv_obj_t* create_slider_row(lv_obj_t* parent, const char* label_text, 
                            int min_val, int max_val, int initial_val,
                            lv_obj_t** out_slider, lv_obj_t** out_value, lv_obj_t** out_lock,
                            lv_event_cb_t slider_cb, LockTarget lock_target) {
    // Card container
    lv_obj_t* card = lv_obj_create(parent);
    lv_obj_set_size(card, SCREEN_WIDTH - 2 * CONTENT_PAD, SLIDER_ROW_HEIGHT);
    lv_obj_set_style_bg_color(card, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(card, CARD_RADIUS, 0);
    lv_obj_set_style_border_width(card, 0, 0);
    lv_obj_set_style_pad_all(card, 12, 0);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    
    // Top row: Label + Value + Lock button
    lv_obj_t* top_row = lv_obj_create(card);
    lv_obj_remove_style_all(top_row);
    lv_obj_set_size(top_row, lv_pct(100), 30);
    lv_obj_set_flex_flow(top_row, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(top_row, LV_FLEX_ALIGN_SPACE_BETWEEN, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_align(top_row, LV_ALIGN_TOP_MID, 0, 0);
    
    // Label
    lv_obj_t* label = lv_label_create(top_row);
    lv_label_set_text(label, label_text);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    
    // Value label
    lv_obj_t* value = lv_label_create(top_row);
    lv_obj_set_style_text_font(value, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(value, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    *out_value = value;
    
    // Lock button
    lv_obj_t* lock_btn = lv_btn_create(top_row);
    lv_obj_set_size(lock_btn, 36, 28);
    lv_obj_set_style_bg_color(lock_btn, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_radius(lock_btn, 6, 0);
    lv_obj_set_style_border_width(lock_btn, 1, 0);
    lv_obj_set_style_border_color(lock_btn, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_style_shadow_width(lock_btn, 0, 0);
    
    lv_obj_t* lock_icon = lv_label_create(lock_btn);
    lv_label_set_text(lock_icon, LV_SYMBOL_MINUS);
    lv_obj_set_style_text_font(lock_icon, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(lock_icon, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_center(lock_icon);
    
    lv_obj_add_event_cb(lock_btn, lock_button_event_cb, LV_EVENT_CLICKED, (void*)(intptr_t)lock_target);
    *out_lock = lock_btn;
    
    // Slider
    lv_obj_t* slider = lv_slider_create(card);
    lv_obj_set_size(slider, lv_pct(100), SLIDER_HEIGHT);
    lv_obj_align(slider, LV_ALIGN_BOTTOM_MID, 0, -4);
    lv_slider_set_range(slider, min_val, max_val);
    lv_slider_set_value(slider, initial_val, LV_ANIM_OFF);
    
    // Slider styling
    lv_obj_set_style_bg_color(slider, lv_color_hex(0x404040), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(slider, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_radius(slider, SLIDER_HEIGHT / 2, LV_PART_MAIN);
    
    lv_obj_set_style_bg_color(slider, lv_color_hex(STYLE_COLOR_DIVE_PLAN), LV_PART_INDICATOR);
    lv_obj_set_style_bg_opa(slider, LV_OPA_COVER, LV_PART_INDICATOR);
    lv_obj_set_style_radius(slider, SLIDER_HEIGHT / 2, LV_PART_INDICATOR);
    
    lv_obj_set_style_bg_color(slider, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), LV_PART_KNOB);
    lv_obj_set_style_bg_opa(slider, LV_OPA_COVER, LV_PART_KNOB);
    lv_obj_set_style_pad_all(slider, 6, LV_PART_KNOB);  // Knob size
    
    lv_obj_add_event_cb(slider, slider_cb, LV_EVENT_VALUE_CHANGED, nullptr);
    *out_slider = slider;
    
    return card;
}

// Create trimix toggle row
lv_obj_t* create_trimix_toggle(lv_obj_t* parent) {
    lv_obj_t* card = lv_obj_create(parent);
    lv_obj_set_size(card, SCREEN_WIDTH - 2 * CONTENT_PAD, 60);
    lv_obj_set_style_bg_color(card, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(card, CARD_RADIUS, 0);
    lv_obj_set_style_border_width(card, 0, 0);
    lv_obj_set_style_pad_hor(card, 16, 0);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    
    // Label
    lv_obj_t* label = lv_label_create(card);
    lv_label_set_text(label, "Enable Trimix");
    lv_obj_set_style_text_font(label, &lv_font_montserrat_18, 0);
    lv_obj_set_style_text_color(label, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(label, LV_ALIGN_LEFT_MID, 0, 0);
    
    // Toggle switch
    lv_obj_t* sw = lv_switch_create(card);
    lv_obj_set_size(sw, 50, 26);
    lv_obj_align(sw, LV_ALIGN_RIGHT_MID, 0, 0);
    
    // Switch styling
    lv_obj_set_style_bg_color(sw, lv_color_hex(0x404040), LV_PART_MAIN);
    lv_obj_set_style_bg_color(sw, lv_color_hex(STYLE_COLOR_DIVE_PLAN), LV_PART_INDICATOR);
    lv_obj_add_state(sw, LV_STATE_DEFAULT);  // Set default state style
    lv_obj_set_style_bg_color(sw, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), LV_PART_KNOB);
    
    lv_obj_add_event_cb(sw, trimix_toggle_event_cb, LV_EVENT_VALUE_CHANGED, nullptr);
    g_state.trimix_toggle = sw;
    
    return card;
}

// Create result card
lv_obj_t* create_result_card(lv_obj_t* parent) {
    lv_obj_t* card = lv_obj_create(parent);
    lv_obj_set_size(card, SCREEN_WIDTH - 2 * CONTENT_PAD, RESULT_CARD_HEIGHT);
    lv_obj_set_style_bg_color(card, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_set_style_bg_opa(card, LV_OPA_COVER, 0);
    lv_obj_set_style_radius(card, CARD_RADIUS, 0);
    lv_obj_set_style_border_width(card, 0, 0);
    lv_obj_set_style_pad_all(card, 16, 0);
    lv_obj_clear_flag(card, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_flex_flow(card, LV_FLEX_FLOW_ROW);
    lv_obj_set_flex_align(card, LV_FLEX_ALIGN_SPACE_EVENLY, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    
    // O2 result
    g_state.result_o2 = lv_label_create(card);
    lv_obj_set_style_text_font(g_state.result_o2, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(g_state.result_o2, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // MOD result
    g_state.result_mod = lv_label_create(card);
    lv_obj_set_style_text_font(g_state.result_mod, &lv_font_montserrat_20, 0);
    lv_obj_set_style_text_color(g_state.result_mod, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Mix recommendation (full width below)
    g_state.result_mix = lv_label_create(card);
    lv_obj_set_style_text_font(g_state.result_mix, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_state.result_mix, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    
    // Gas density
    g_state.result_density = lv_label_create(card);
    lv_obj_set_style_text_font(g_state.result_density, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_state.result_density, lv_color_hex(STYLE_COLOR_SUCCESS), 0);
    
    return card;
}

}  // namespace

lv_obj_t* dive_planner_screen_create(void) {
    ESP_LOGI(TAG, "Creating dive planner screen");
    
    // Reset state
    g_state = DivePlannerState{};
    
    // Create screen
    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BG_DARK), 0);
    lv_obj_set_style_bg_opa(screen, LV_OPA_COVER, 0);
    lv_obj_clear_flag(screen, LV_OBJ_FLAG_SCROLLABLE);
    g_state.screen = screen;
    
    // Navbar with back button
    navbar_create_with_back(screen, "Dive Planner", nullptr);
    
    // Scrollable content area
    lv_obj_t* content = lv_obj_create(screen);
    lv_obj_remove_style_all(content);
    lv_obj_set_size(content, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
    lv_obj_set_pos(content, 0, NAVBAR_HEIGHT);
    lv_obj_set_style_pad_all(content, CONTENT_PAD, 0);
    lv_obj_set_style_pad_row(content, 12, 0);
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(content, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_scroll_dir(content, LV_DIR_VER);
    lv_obj_set_scrollbar_mode(content, LV_SCROLLBAR_MODE_AUTO);
    
    // Result card at top
    create_result_card(content);
    
    // Depth slider
    create_slider_row(content, "Depth", DEPTH_MIN, DEPTH_MAX, (int)g_state.depth,
                      &g_state.depth_slider, &g_state.depth_value, &g_state.depth_lock,
                      depth_slider_event_cb, LockTarget::DEPTH);
    
    // PPO2 slider
    create_slider_row(content, "PPO2", PPO2_MIN, PPO2_MAX, (int)(g_state.ppo2 * 100),
                      &g_state.ppo2_slider, &g_state.ppo2_value, &g_state.ppo2_lock,
                      ppo2_slider_event_cb, LockTarget::PPO2);
    
    // O2 slider
    create_slider_row(content, "O2", O2_MIN, O2_MAX, (int)g_state.o2,
                      &g_state.o2_slider, &g_state.o2_value, &g_state.o2_lock,
                      o2_slider_event_cb, LockTarget::O2);
    
    // Trimix toggle
    create_trimix_toggle(content);
    
    // Trimix section (hidden by default)
    g_state.trimix_section = lv_obj_create(content);
    lv_obj_remove_style_all(g_state.trimix_section);
    lv_obj_set_size(g_state.trimix_section, SCREEN_WIDTH - 2 * CONTENT_PAD, LV_SIZE_CONTENT);
    lv_obj_set_style_pad_row(g_state.trimix_section, 12, 0);
    lv_obj_set_flex_flow(g_state.trimix_section, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(g_state.trimix_section, LV_FLEX_ALIGN_START, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_add_flag(g_state.trimix_section, LV_OBJ_FLAG_HIDDEN);  // Hidden initially
    
    // EAD slider (in trimix section)
    create_slider_row(g_state.trimix_section, "EAD (Target)", EAD_MIN, EAD_MAX, (int)g_state.ead,
                      &g_state.ead_slider, &g_state.ead_value, &g_state.ead_lock,
                      ead_slider_event_cb, LockTarget::EAD);
    
    // Helium slider (in trimix section)
    create_slider_row(g_state.trimix_section, "Helium", HELIUM_MIN, HELIUM_MAX, (int)g_state.helium,
                      &g_state.helium_slider, &g_state.helium_value, &g_state.helium_lock,
                      helium_slider_event_cb, LockTarget::HELIUM);
    
    // Initial display update
    update_all_displays();
    update_lock_button_styles();
    
    ESP_LOGI(TAG, "Dive planner screen created");
    return screen;
}
