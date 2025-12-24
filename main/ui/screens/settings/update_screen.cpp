#include "update_screen.h"
#include "../../styles/styles.h"
#include "../../components/navbar.h"
#include "../../../services/ota_service.h"
#include "../../../services/wifi_service.h"
#include "../screen_manager.h"
#include <esp_log.h>
#include <cstring>
#include <cstdio>

static const char* TAG = "UPDATE_SCREEN";

namespace {

constexpr int SCREEN_WIDTH = 480;
constexpr int SCREEN_HEIGHT = 800;
constexpr int NAVBAR_HEIGHT = 70;
constexpr int CONTENT_START_Y = NAVBAR_HEIGHT;

// Screen state
struct UpdateScreenState {
    lv_obj_t* screen = nullptr;
    lv_obj_t* current_version_label = nullptr;
    lv_obj_t* status_label = nullptr;
    lv_obj_t* new_version_label = nullptr;
    lv_obj_t* release_notes = nullptr;
    lv_obj_t* progress_bar = nullptr;
    lv_obj_t* progress_label = nullptr;
    lv_obj_t* check_btn = nullptr;
    lv_obj_t* update_btn = nullptr;
    lv_obj_t* reboot_btn = nullptr;
    lv_obj_t* update_panel = nullptr;
    lv_timer_t* state_timer = nullptr;
};

UpdateScreenState g_state;

// Forward declarations
void on_check_click(lv_event_t* e);
void on_update_click(lv_event_t* e);
void on_reboot_click(lv_event_t* e);
void update_ui_state();
void ota_progress_callback(int progress, const char* status);

// Back button callback
void update_back_cb(lv_event_t* e) {
    screen_manager_show(SCREEN_SETTINGS);
}

// Timer to poll OTA state
void state_timer_cb(lv_timer_t* timer) {
    update_ui_state();
}

// Progress callback from OTA service
void ota_progress_callback(int progress, const char* status) {
    if (g_state.progress_bar) {
        lv_bar_set_value(g_state.progress_bar, progress, LV_ANIM_ON);
    }
    if (g_state.progress_label) {
        lv_label_set_text(g_state.progress_label, status);
    }
}

void update_ui_state() {
    ota_state_t state = ota_get_state();
    const ota_update_info_t* info = ota_get_update_info();
    
    // Hide all dynamic elements first
    lv_obj_add_flag(g_state.update_panel, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(g_state.progress_bar, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(g_state.progress_label, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(g_state.update_btn, LV_OBJ_FLAG_HIDDEN);
    lv_obj_add_flag(g_state.reboot_btn, LV_OBJ_FLAG_HIDDEN);
    
    switch (state) {
        case OTA_STATE_IDLE:
            lv_label_set_text(g_state.status_label, "Tap 'Check for Updates' to begin");
            lv_obj_clear_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_state(g_state.check_btn, LV_STATE_DISABLED);
            break;
            
        case OTA_STATE_CHECKING:
            lv_label_set_text(g_state.status_label, "Checking for updates...");
            lv_obj_add_state(g_state.check_btn, LV_STATE_DISABLED);
            break;
            
        case OTA_STATE_NO_UPDATE:
            lv_label_set_text(g_state.status_label, "You're up to date!");
            lv_obj_set_style_text_color(g_state.status_label, 
                lv_color_hex(STYLE_COLOR_SUCCESS), 0);
            lv_obj_clear_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_state(g_state.check_btn, LV_STATE_DISABLED);
            break;
            
        case OTA_STATE_UPDATE_AVAILABLE:
            lv_label_set_text(g_state.status_label, "Update available!");
            lv_obj_set_style_text_color(g_state.status_label, 
                lv_color_hex(STYLE_COLOR_PRIMARY), 0);
            
            // Show update panel with info
            lv_obj_clear_flag(g_state.update_panel, LV_OBJ_FLAG_HIDDEN);
            
            char version_text[64];
            snprintf(version_text, sizeof(version_text), "Version %s", info->version);
            lv_label_set_text(g_state.new_version_label, version_text);
            
            if (strlen(info->release_notes) > 0) {
                lv_label_set_text(g_state.release_notes, info->release_notes);
            } else {
                lv_label_set_text(g_state.release_notes, "No release notes");
            }
            
            lv_obj_clear_flag(g_state.update_btn, LV_OBJ_FLAG_HIDDEN);
            lv_obj_add_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            break;
            
        case OTA_STATE_DOWNLOADING:
        case OTA_STATE_INSTALLING:
            lv_label_set_text(g_state.status_label, 
                state == OTA_STATE_DOWNLOADING ? "Downloading update..." : "Installing...");
            lv_obj_clear_flag(g_state.progress_bar, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_flag(g_state.progress_label, LV_OBJ_FLAG_HIDDEN);
            lv_obj_add_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            break;
            
        case OTA_STATE_SUCCESS:
            lv_label_set_text(g_state.status_label, "Update complete!");
            lv_obj_set_style_text_color(g_state.status_label, 
                lv_color_hex(STYLE_COLOR_SUCCESS), 0);
            lv_obj_clear_flag(g_state.reboot_btn, LV_OBJ_FLAG_HIDDEN);
            lv_obj_add_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            lv_label_set_text(g_state.progress_label, "Restart to apply update");
            lv_obj_clear_flag(g_state.progress_label, LV_OBJ_FLAG_HIDDEN);
            break;
            
        case OTA_STATE_ERROR:
            lv_label_set_text(g_state.status_label, ota_get_error_message());
            lv_obj_set_style_text_color(g_state.status_label, 
                lv_color_hex(STYLE_COLOR_ERROR), 0);
            lv_obj_clear_flag(g_state.check_btn, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_state(g_state.check_btn, LV_STATE_DISABLED);
            break;
    }
}

void on_check_click(lv_event_t* e) {
    // Check WiFi connection first
    if (!wifi_service_is_connected()) {
        lv_label_set_text(g_state.status_label, "Please connect to WiFi first");
        lv_obj_set_style_text_color(g_state.status_label, 
            lv_color_hex(STYLE_COLOR_WARNING), 0);
        return;
    }
    
    ESP_LOGI(TAG, "Checking for updates...");
    lv_obj_set_style_text_color(g_state.status_label, 
        lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    ota_check_for_update();
}

void on_update_click(lv_event_t* e) {
    ESP_LOGI(TAG, "Starting update...");
    lv_bar_set_value(g_state.progress_bar, 0, LV_ANIM_OFF);
    ota_start_update(ota_progress_callback);
}

void on_reboot_click(lv_event_t* e) {
    ESP_LOGI(TAG, "Rebooting...");
    ota_reboot();
}

lv_obj_t* create_button(lv_obj_t* parent, const char* text, uint32_t color, 
                        lv_event_cb_t cb, int width = 200, int height = 50) {
    lv_obj_t* btn = lv_btn_create(parent);
    lv_obj_set_size(btn, width, height);
    lv_obj_set_style_bg_color(btn, lv_color_hex(color), 0);
    lv_obj_set_style_bg_color(btn, lv_color_darken(lv_color_hex(color), 30), LV_STATE_PRESSED);
    lv_obj_set_style_radius(btn, 25, 0);
    lv_obj_set_style_shadow_width(btn, 8, 0);
    lv_obj_set_style_shadow_opa(btn, LV_OPA_30, 0);
    lv_obj_add_event_cb(btn, cb, LV_EVENT_CLICKED, nullptr);
    
    lv_obj_t* label = lv_label_create(btn);
    lv_label_set_text(label, text);
    lv_obj_set_style_text_font(label, &lv_font_montserrat_18, 0);
    lv_obj_center(label);
    
    return btn;
}

}  // namespace

lv_obj_t* update_screen_create(void) {
    ESP_LOGI(TAG, "Creating update screen");
    
    // Initialize OTA service
    ota_service_init();
    
    // Create screen
    lv_obj_t* screen = lv_obj_create(nullptr);
    lv_obj_set_style_bg_color(screen, lv_color_hex(STYLE_COLOR_BACKGROUND), 0);
    g_state.screen = screen;
    
    // Navbar
    navbar_create_with_back(screen, "Software Update", update_back_cb);
    
    // Content container
    lv_obj_t* content = lv_obj_create(screen);
    lv_obj_remove_style_all(content);
    lv_obj_set_size(content, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
    lv_obj_set_pos(content, 0, CONTENT_START_Y);
    lv_obj_set_style_pad_all(content, 24, 0);
    lv_obj_clear_flag(content, LV_OBJ_FLAG_SCROLLABLE);
    
    // Current version card
    lv_obj_t* version_card = lv_obj_create(content);
    lv_obj_set_size(version_card, SCREEN_WIDTH - 48, 100);
    lv_obj_align(version_card, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_set_style_bg_color(version_card, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_radius(version_card, 16, 0);
    lv_obj_set_style_border_width(version_card, 0, 0);
    lv_obj_clear_flag(version_card, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* version_title = lv_label_create(version_card);
    lv_label_set_text(version_title, "Current Version");
    lv_obj_set_style_text_font(version_title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(version_title, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_align(version_title, LV_ALIGN_TOP_LEFT, 16, 16);
    
    g_state.current_version_label = lv_label_create(version_card);
    char ver_text[32];
    snprintf(ver_text, sizeof(ver_text), "v%s", ota_get_current_version());
    lv_label_set_text(g_state.current_version_label, ver_text);
    lv_obj_set_style_text_font(g_state.current_version_label, &lv_font_montserrat_28, 0);
    lv_obj_set_style_text_color(g_state.current_version_label, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(g_state.current_version_label, LV_ALIGN_LEFT_MID, 16, 10);
    
    // Status label
    g_state.status_label = lv_label_create(content);
    lv_label_set_text(g_state.status_label, "Tap 'Check for Updates' to begin");
    lv_obj_set_style_text_font(g_state.status_label, &lv_font_montserrat_16, 0);
    lv_obj_set_style_text_color(g_state.status_label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_set_style_text_align(g_state.status_label, LV_TEXT_ALIGN_CENTER, 0);
    lv_obj_set_width(g_state.status_label, SCREEN_WIDTH - 64);
    lv_obj_align(g_state.status_label, LV_ALIGN_TOP_MID, 0, 120);
    
    // Update available panel (hidden by default)
    g_state.update_panel = lv_obj_create(content);
    lv_obj_set_size(g_state.update_panel, SCREEN_WIDTH - 48, 200);
    lv_obj_align(g_state.update_panel, LV_ALIGN_TOP_MID, 0, 160);
    lv_obj_set_style_bg_color(g_state.update_panel, lv_color_hex(STYLE_COLOR_SURFACE), 0);
    lv_obj_set_style_radius(g_state.update_panel, 16, 0);
    lv_obj_set_style_border_width(g_state.update_panel, 2, 0);
    lv_obj_set_style_border_color(g_state.update_panel, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_add_flag(g_state.update_panel, LV_OBJ_FLAG_HIDDEN);
    lv_obj_clear_flag(g_state.update_panel, LV_OBJ_FLAG_SCROLLABLE);
    
    lv_obj_t* new_title = lv_label_create(g_state.update_panel);
    lv_label_set_text(new_title, "New Version Available");
    lv_obj_set_style_text_font(new_title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(new_title, lv_color_hex(STYLE_COLOR_PRIMARY), 0);
    lv_obj_align(new_title, LV_ALIGN_TOP_LEFT, 16, 12);
    
    g_state.new_version_label = lv_label_create(g_state.update_panel);
    lv_label_set_text(g_state.new_version_label, "Version X.X.X");
    lv_obj_set_style_text_font(g_state.new_version_label, &lv_font_montserrat_24, 0);
    lv_obj_set_style_text_color(g_state.new_version_label, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_align(g_state.new_version_label, LV_ALIGN_TOP_LEFT, 16, 36);
    
    lv_obj_t* notes_title = lv_label_create(g_state.update_panel);
    lv_label_set_text(notes_title, "What's New:");
    lv_obj_set_style_text_font(notes_title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(notes_title, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_align(notes_title, LV_ALIGN_TOP_LEFT, 16, 70);
    
    g_state.release_notes = lv_label_create(g_state.update_panel);
    lv_label_set_text(g_state.release_notes, "");
    lv_obj_set_style_text_font(g_state.release_notes, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(g_state.release_notes, lv_color_hex(STYLE_COLOR_TEXT_LIGHT), 0);
    lv_obj_set_width(g_state.release_notes, SCREEN_WIDTH - 96);
    lv_label_set_long_mode(g_state.release_notes, LV_LABEL_LONG_WRAP);
    lv_obj_align(g_state.release_notes, LV_ALIGN_TOP_LEFT, 16, 90);
    
    // Progress bar (hidden by default)
    g_state.progress_bar = lv_bar_create(content);
    lv_obj_set_size(g_state.progress_bar, SCREEN_WIDTH - 80, 20);
    lv_obj_align(g_state.progress_bar, LV_ALIGN_TOP_MID, 0, 380);
    lv_bar_set_range(g_state.progress_bar, 0, 100);
    lv_bar_set_value(g_state.progress_bar, 0, LV_ANIM_OFF);
    lv_obj_set_style_bg_color(g_state.progress_bar, lv_color_hex(0x333333), 0);
    lv_obj_set_style_bg_color(g_state.progress_bar, lv_color_hex(STYLE_COLOR_PRIMARY), LV_PART_INDICATOR);
    lv_obj_set_style_radius(g_state.progress_bar, 10, 0);
    lv_obj_set_style_radius(g_state.progress_bar, 10, LV_PART_INDICATOR);
    lv_obj_add_flag(g_state.progress_bar, LV_OBJ_FLAG_HIDDEN);
    
    g_state.progress_label = lv_label_create(content);
    lv_label_set_text(g_state.progress_label, "");
    lv_obj_set_style_text_font(g_state.progress_label, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(g_state.progress_label, lv_color_hex(STYLE_COLOR_TEXT_DIM), 0);
    lv_obj_align(g_state.progress_label, LV_ALIGN_TOP_MID, 0, 410);
    lv_obj_add_flag(g_state.progress_label, LV_OBJ_FLAG_HIDDEN);
    
    // Buttons
    g_state.check_btn = create_button(content, "Check for Updates", STYLE_COLOR_PRIMARY, on_check_click, 240, 56);
    lv_obj_align(g_state.check_btn, LV_ALIGN_BOTTOM_MID, 0, -80);
    
    g_state.update_btn = create_button(content, "Install Update", STYLE_COLOR_SUCCESS, on_update_click, 240, 56);
    lv_obj_align(g_state.update_btn, LV_ALIGN_BOTTOM_MID, 0, -80);
    lv_obj_add_flag(g_state.update_btn, LV_OBJ_FLAG_HIDDEN);
    
    g_state.reboot_btn = create_button(content, "Restart Now", STYLE_COLOR_WARNING, on_reboot_click, 240, 56);
    lv_obj_align(g_state.reboot_btn, LV_ALIGN_BOTTOM_MID, 0, -80);
    lv_obj_add_flag(g_state.reboot_btn, LV_OBJ_FLAG_HIDDEN);
    
    // Start state polling timer
    g_state.state_timer = lv_timer_create(state_timer_cb, 500, nullptr);
    
    return screen;
}

void update_screen_refresh(void) {
    if (wifi_service_is_connected()) {
        ota_check_for_update();
    }
}
