#include "software_update.h"
#include "../screen_manager.h"
#include "../../components/ui_components.h"
#include "../../../version.h"
#include "../wifi/wifi_settings.h"
#include <esp_log.h>
#include <esp_http_client.h>
#include <esp_https_ota.h>
#include <esp_ota_ops.h>
#include <cJSON.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <freertos/semphr.h>

static const char *TAG = "SoftwareUpdate";

// GitHub API configuration
#define USER_AGENT "TrimixAnalyzer/1.0"
#define MAX_HTTP_RECV_BUFFER 4096
#define UPDATE_CHECK_TIMEOUT_MS 30000

// Static variables
static lv_obj_t *update_screen = NULL;
static lv_obj_t *current_version_label = NULL;
static lv_obj_t *latest_version_label = NULL;
static lv_obj_t *status_label = NULL;
static lv_obj_t *progress_bar = NULL;
static lv_obj_t *check_button = NULL;
static lv_obj_t *update_button = NULL;
static lv_obj_t *description_label = NULL;

static update_status_t current_status = UPDATE_STATUS_IDLE;
static software_update_info_t latest_update_info = {};
static char status_text[128] = "Ready to check for updates";
static float download_progress = 0.0f;
static SemaphoreHandle_t update_mutex = NULL;

// HTTP response data structure
typedef struct {
    char *data;
    size_t len;
    size_t max_len;
} http_response_t;

// Forward declarations
static void update_ui_elements(void);
static void check_for_updates_task(void *param);
static void download_and_install_task(void *param);
static esp_err_t parse_github_release_response(const char *json_string);

// HTTP event handler for JSON response
static esp_err_t http_event_handler(esp_http_client_event_t *evt) {
    http_response_t *response = (http_response_t*)evt->user_data;
    
    switch (evt->event_id) {
        case HTTP_EVENT_ON_DATA:
            if (response->len + evt->data_len < response->max_len) {
                memcpy(response->data + response->len, evt->data, evt->data_len);
                response->len += evt->data_len;
                response->data[response->len] = '\0';
            }
            break;
        default:
            break;
    }
    return ESP_OK;
}

// Event handlers
static void event_check_updates(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        ESP_LOGI(TAG, "Check for updates button clicked");
        
        // Check WiFi connection status
        wifi_connection_status_t wifi_status = wifi_manager_get_status();
        if (wifi_status != WIFI_STATUS_CONNECTED) {
            xSemaphoreTake(update_mutex, portMAX_DELAY);
            current_status = UPDATE_STATUS_ERROR;
            strncpy(status_text, "WiFi not connected. Please connect to WiFi first.", sizeof(status_text) - 1);
            xSemaphoreGive(update_mutex);
            ESP_LOGW(TAG, "WiFi not connected, cannot check for updates");
            return;
        }
        
        xTaskCreate(check_for_updates_task, "check_updates", 8192, NULL, 5, NULL);
    }
}

static void event_download_update(lv_event_t *e) {
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        ESP_LOGI(TAG, "Download update button clicked");
        
        // Check WiFi connection status
        wifi_connection_status_t wifi_status = wifi_manager_get_status();
        if (wifi_status != WIFI_STATUS_CONNECTED) {
            xSemaphoreTake(update_mutex, portMAX_DELAY);
            current_status = UPDATE_STATUS_ERROR;
            strncpy(status_text, "WiFi not connected. Please connect to WiFi first.", sizeof(status_text) - 1);
            xSemaphoreGive(update_mutex);
            ESP_LOGW(TAG, "WiFi not connected, cannot download update");
            return;
        }
        
        xTaskCreate(download_and_install_task, "download_update", 8192, NULL, 5, NULL);
    }
}

// Task to check for updates
static void check_for_updates_task(void *param) {
    (void)param;
    
    xSemaphoreTake(update_mutex, portMAX_DELAY);
    current_status = UPDATE_STATUS_CHECKING;
    strncpy(status_text, "Checking for updates...", sizeof(status_text) - 1);
    xSemaphoreGive(update_mutex);
    
    // Allocate response buffer
    http_response_t response = {
        .data = (char*)malloc(8192),
        .len = 0,
        .max_len = 8192
    };
    
    if (!response.data) {
        ESP_LOGE(TAG, "Failed to allocate response buffer");
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        strncpy(status_text, "Memory allocation failed", sizeof(status_text) - 1);
        xSemaphoreGive(update_mutex);
        vTaskDelete(NULL);
        return;
    }
    
    // Configure HTTP client
    esp_http_client_config_t config = {};
    config.url = GITHUB_API_URL;
    config.event_handler = http_event_handler;
    config.user_data = &response;
    config.user_agent = USER_AGENT;
    config.timeout_ms = UPDATE_CHECK_TIMEOUT_MS;
    
    esp_http_client_handle_t client = esp_http_client_init(&config);
    if (!client) {
        ESP_LOGE(TAG, "Failed to initialize HTTP client");
        free(response.data);
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        strncpy(status_text, "Network initialization failed", sizeof(status_text) - 1);
        xSemaphoreGive(update_mutex);
        vTaskDelete(NULL);
        return;
    }
    
    // Perform HTTP request
    esp_err_t err = esp_http_client_perform(client);
    int status_code = esp_http_client_get_status_code(client);
    
    esp_http_client_cleanup(client);
    
    if (err != ESP_OK || status_code != 200) {
        ESP_LOGE(TAG, "HTTP request failed: %s, status: %d", esp_err_to_name(err), status_code);
        free(response.data);
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        snprintf(status_text, sizeof(status_text), "Network error: %d", status_code);
        xSemaphoreGive(update_mutex);
        vTaskDelete(NULL);
        return;
    }
    
    // Parse the response
    err = parse_github_release_response(response.data);
    free(response.data);
    
    if (err != ESP_OK) {
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        strncpy(status_text, "Failed to parse update information", sizeof(status_text) - 1);
        xSemaphoreGive(update_mutex);
        vTaskDelete(NULL);
        return;
    }
    
    // Check if update is available
    xSemaphoreTake(update_mutex, portMAX_DELAY);
    if (strcmp(latest_update_info.version, TRIMIX_ANALYZER_VERSION) != 0) {
        current_status = UPDATE_STATUS_AVAILABLE;
        snprintf(status_text, sizeof(status_text), "Update available: %s", latest_update_info.version);
    } else {
        current_status = UPDATE_STATUS_IDLE;
        strncpy(status_text, "You have the latest version", sizeof(status_text) - 1);
    }
    xSemaphoreGive(update_mutex);
    
    ESP_LOGI(TAG, "Update check completed");
    vTaskDelete(NULL);
}

// Task to download and install update
static void download_and_install_task(void *param) {
    (void)param;
    
    if (strlen(latest_update_info.download_url) == 0) {
        ESP_LOGE(TAG, "No download URL available");
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        strncpy(status_text, "No download URL available", sizeof(status_text) - 1);
        xSemaphoreGive(update_mutex);
        vTaskDelete(NULL);
        return;
    }
    
    xSemaphoreTake(update_mutex, portMAX_DELAY);
    current_status = UPDATE_STATUS_DOWNLOADING;
    strncpy(status_text, "Downloading update...", sizeof(status_text) - 1);
    download_progress = 0.0f;
    xSemaphoreGive(update_mutex);
    
    // Configure OTA
    esp_http_client_config_t ota_http_config = {};
    ota_http_config.url = latest_update_info.download_url;
    ota_http_config.user_agent = USER_AGENT;
    ota_http_config.timeout_ms = 30000;
    
    esp_https_ota_config_t ota_config = {};
    ota_config.http_config = &ota_http_config;
    
    ESP_LOGI(TAG, "Starting OTA update from: %s", latest_update_info.download_url);
    
    esp_err_t err = esp_https_ota(&ota_config);
    
    if (err == ESP_OK) {
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_SUCCESS;
        strncpy(status_text, "Update installed successfully! Restarting...", sizeof(status_text) - 1);
        xSemaphoreGive(update_mutex);
        
        ESP_LOGI(TAG, "OTA update successful, restarting...");
        vTaskDelay(pdMS_TO_TICKS(2000));
        esp_restart();
    } else {
        ESP_LOGE(TAG, "OTA update failed: %s", esp_err_to_name(err));
        xSemaphoreTake(update_mutex, portMAX_DELAY);
        current_status = UPDATE_STATUS_ERROR;
        snprintf(status_text, sizeof(status_text), "Update failed: %s", esp_err_to_name(err));
        xSemaphoreGive(update_mutex);
    }
    
    vTaskDelete(NULL);
}

// Parse GitHub release JSON response
static esp_err_t parse_github_release_response(const char *json_string) {
    cJSON *json = cJSON_Parse(json_string);
    if (!json) {
        ESP_LOGE(TAG, "Failed to parse JSON response");
        return ESP_FAIL;
    }
    
    // Extract version tag
    cJSON *tag_name = cJSON_GetObjectItem(json, "tag_name");
    if (cJSON_IsString(tag_name) && tag_name->valuestring) {
        strncpy(latest_update_info.version, tag_name->valuestring, sizeof(latest_update_info.version) - 1);
    }
    
    // Extract release name
    cJSON *name = cJSON_GetObjectItem(json, "name");
    if (cJSON_IsString(name) && name->valuestring) {
        strncpy(latest_update_info.release_name, name->valuestring, sizeof(latest_update_info.release_name) - 1);
    }
    
    // Extract description
    cJSON *body = cJSON_GetObjectItem(json, "body");
    if (cJSON_IsString(body) && body->valuestring) {
        strncpy(latest_update_info.description, body->valuestring, sizeof(latest_update_info.description) - 1);
    }
    
    // Extract prerelease flag
    cJSON *prerelease = cJSON_GetObjectItem(json, "prerelease");
    if (cJSON_IsBool(prerelease)) {
        latest_update_info.prerelease = cJSON_IsTrue(prerelease);
    }
    
    // Extract assets for firmware binary
    cJSON *assets = cJSON_GetObjectItem(json, "assets");
    if (cJSON_IsArray(assets)) {
        cJSON *asset = NULL;
        cJSON_ArrayForEach(asset, assets) {
            cJSON *asset_name = cJSON_GetObjectItem(asset, "name");
            if (cJSON_IsString(asset_name) && asset_name->valuestring) {
                // Look for firmware binary (usually .bin file)
                if (strstr(asset_name->valuestring, ".bin") != NULL || 
                    strstr(asset_name->valuestring, "firmware") != NULL) {
                    
                    cJSON *download_url = cJSON_GetObjectItem(asset, "browser_download_url");
                    if (cJSON_IsString(download_url) && download_url->valuestring) {
                        strncpy(latest_update_info.download_url, download_url->valuestring, 
                               sizeof(latest_update_info.download_url) - 1);
                    }
                    
                    cJSON *size = cJSON_GetObjectItem(asset, "size");
                    if (cJSON_IsNumber(size)) {
                        latest_update_info.size_bytes = (size_t)size->valuedouble;
                    }
                    break;
                }
            }
        }
    }
    
    cJSON_Delete(json);
    
    ESP_LOGI(TAG, "Parsed release info: version=%s, name=%s, size=%zu", 
             latest_update_info.version, latest_update_info.release_name, latest_update_info.size_bytes);
    
    return ESP_OK;
}

// UI update timer callback
static void ui_update_timer_cb(lv_timer_t *timer) {
    (void)timer;
    update_ui_elements();
}

// Update UI elements based on current state
static void update_ui_elements(void) {
    if (!update_screen || !lv_obj_is_valid(update_screen)) {
        return;
    }
    
    // Check if we're still on the update screen
    if (lv_scr_act() != update_screen) {
        return;
    }
    
    xSemaphoreTake(update_mutex, portMAX_DELAY);
    update_status_t status = current_status;
    char status_str[128];
    strncpy(status_str, status_text, sizeof(status_str) - 1);
    float progress = download_progress;
    xSemaphoreGive(update_mutex);
    
    // Check WiFi status and update accordingly
    wifi_connection_status_t wifi_status = wifi_manager_get_status();
    bool wifi_connected = (wifi_status == WIFI_STATUS_CONNECTED);
    
    // Update status label
    if (status_label && lv_obj_is_valid(status_label)) {
        if (!wifi_connected && status == UPDATE_STATUS_IDLE) {
            lv_label_set_text(status_label, "WiFi not connected. Connect to WiFi to check for updates.");
            lv_obj_set_style_text_color(status_label, UI_COLOR_WARNING, 0);
        } else {
            lv_label_set_text(status_label, status_str);
            // Set color based on status
            if (status == UPDATE_STATUS_ERROR) {
                lv_obj_set_style_text_color(status_label, UI_COLOR_DANGER, 0);
            } else if (status == UPDATE_STATUS_AVAILABLE) {
                lv_obj_set_style_text_color(status_label, UI_COLOR_SECONDARY, 0);
            } else {
                lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_SECONDARY, 0);
            }
        }
    }
    
    // Update latest version label
    if (latest_version_label && lv_obj_is_valid(latest_version_label)) {
        if (strlen(latest_update_info.version) > 0) {
            lv_label_set_text_fmt(latest_version_label, "Latest: %s", latest_update_info.version);
        } else {
            lv_label_set_text(latest_version_label, "Latest: Unknown");
        }
    }
    
    // Update description label
    if (description_label && lv_obj_is_valid(description_label)) {
        if (strlen(latest_update_info.description) > 0) {
            lv_label_set_text(description_label, latest_update_info.description);
        } else {
            lv_label_set_text(description_label, "No description available");
        }
    }
    
    // Update progress bar
    if (progress_bar && lv_obj_is_valid(progress_bar)) {
        if (status == UPDATE_STATUS_DOWNLOADING) {
            lv_obj_clear_flag(progress_bar, LV_OBJ_FLAG_HIDDEN);
            lv_bar_set_value(progress_bar, (int32_t)progress, LV_ANIM_ON);
        } else {
            lv_obj_add_flag(progress_bar, LV_OBJ_FLAG_HIDDEN);
        }
    }
    
    // Update button states
    if (check_button && lv_obj_is_valid(check_button)) {
        if (status == UPDATE_STATUS_CHECKING || status == UPDATE_STATUS_DOWNLOADING || !wifi_connected) {
            lv_obj_add_state(check_button, LV_STATE_DISABLED);
        } else {
            lv_obj_clear_state(check_button, LV_STATE_DISABLED);
        }
    }
    
    if (update_button && lv_obj_is_valid(update_button)) {
        if (status == UPDATE_STATUS_AVAILABLE && wifi_connected) {
            lv_obj_clear_flag(update_button, LV_OBJ_FLAG_HIDDEN);
            lv_obj_clear_state(update_button, LV_STATE_DISABLED);
        } else if (status == UPDATE_STATUS_DOWNLOADING) {
            lv_obj_clear_flag(update_button, LV_OBJ_FLAG_HIDDEN);
            lv_obj_add_state(update_button, LV_STATE_DISABLED);
        } else {
            lv_obj_add_flag(update_button, LV_OBJ_FLAG_HIDDEN);
        }
    }
}

// Screen creation
lv_obj_t *screen_software_update_create(void) {
    if (update_screen) {
        return update_screen;
    }
    
    update_screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(update_screen, UI_COLOR_BACKGROUND, 0);
    
    // Add top navigation bar
    ui_create_topbar(update_screen, "Software Update");
    
    // Create main container
    lv_obj_t *container = lv_obj_create(update_screen);
    lv_obj_set_size(container, LV_PCT(90), lv_disp_get_ver_res(lv_disp_get_default()) - UI_TOPBAR_HEIGHT - 40);
    lv_obj_align(container, LV_ALIGN_TOP_MID, 0, UI_TOPBAR_HEIGHT + 20);
    lv_obj_set_style_bg_opa(container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(container, 0, 0);
    lv_obj_set_style_pad_all(container, 20, 0);
    
    // Create content container
    lv_obj_t *content = lv_obj_create(container);
    lv_obj_set_size(content, LV_PCT(100), LV_PCT(100));
    lv_obj_set_style_bg_opa(content, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(content, 0, 0);
    lv_obj_set_style_pad_all(content, 0, 0);
    lv_obj_set_flex_flow(content, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(content, 15, 0);
    
    // Current version label
    current_version_label = lv_label_create(content);
    lv_label_set_text_fmt(current_version_label, "Current Version: %s", TRIMIX_ANALYZER_VERSION);
    lv_obj_set_style_text_font(current_version_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(current_version_label, UI_COLOR_TEXT_PRIMARY, 0);
    
    // Latest version label
    latest_version_label = lv_label_create(content);
    lv_label_set_text(latest_version_label, "Latest: Unknown");
    lv_obj_set_style_text_font(latest_version_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(latest_version_label, UI_COLOR_TEXT_PRIMARY, 0);
    
    // Status label
    status_label = lv_label_create(content);
    lv_label_set_text(status_label, status_text);
    lv_obj_set_style_text_font(status_label, FONT_NORMAL, 0);
    lv_obj_set_style_text_color(status_label, UI_COLOR_TEXT_SECONDARY, 0);
    lv_label_set_long_mode(status_label, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(status_label, LV_PCT(100));
    
    // Progress bar (initially hidden)
    progress_bar = lv_bar_create(content);
    lv_obj_set_size(progress_bar, LV_PCT(100), 8);
    lv_bar_set_range(progress_bar, 0, 100);
    lv_obj_add_flag(progress_bar, LV_OBJ_FLAG_HIDDEN);
    
    // Description label
    description_label = lv_label_create(content);
    lv_label_set_text(description_label, "No description available");
    lv_obj_set_style_text_font(description_label, FONT_SMALL, 0);
    lv_obj_set_style_text_color(description_label, UI_COLOR_TEXT_SECONDARY, 0);
    lv_label_set_long_mode(description_label, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(description_label, LV_PCT(100));
    lv_obj_set_height(description_label, 60);
    
    // Buttons container
    lv_obj_t *buttons_container = lv_obj_create(content);
    lv_obj_set_size(buttons_container, LV_PCT(100), LV_SIZE_CONTENT);
    lv_obj_set_style_bg_opa(buttons_container, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(buttons_container, 0, 0);
    lv_obj_set_style_pad_all(buttons_container, 0, 0);
    lv_obj_set_flex_flow(buttons_container, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_style_pad_gap(buttons_container, 15, 0);
    
    // Check for updates button
    check_button = ui_create_large_button(buttons_container, "Check for Updates", UI_COLOR_PRIMARY, event_check_updates);
    
    // Download update button (initially hidden)
    update_button = ui_create_large_button(buttons_container, "Download & Install", UI_COLOR_SECONDARY, event_download_update);
    lv_obj_add_flag(update_button, LV_OBJ_FLAG_HIDDEN);
    
    // Start UI update timer
    lv_timer_create(ui_update_timer_cb, 500, NULL);
    
    return update_screen;
}

// Cleanup function
void software_update_cleanup(void) {
    if (update_screen) {
        lv_obj_del(update_screen);
        update_screen = NULL;
        current_version_label = NULL;
        latest_version_label = NULL;
        status_label = NULL;
        progress_bar = NULL;
        check_button = NULL;
        update_button = NULL;
        description_label = NULL;
    }
}

// Update manager API implementation
esp_err_t update_manager_init(void) {
    if (!update_mutex) {
        update_mutex = xSemaphoreCreateMutex();
        if (!update_mutex) {
            ESP_LOGE(TAG, "Failed to create update mutex");
            return ESP_FAIL;
        }
    }
    
    // Clear update info
    memset(&latest_update_info, 0, sizeof(latest_update_info));
    current_status = UPDATE_STATUS_IDLE;
    strncpy(status_text, "Ready to check for updates", sizeof(status_text) - 1);
    download_progress = 0.0f;
    
    ESP_LOGI(TAG, "Update manager initialized");
    return ESP_OK;
}

esp_err_t update_manager_check_for_updates(void) {
    if (current_status == UPDATE_STATUS_CHECKING || current_status == UPDATE_STATUS_DOWNLOADING) {
        return ESP_ERR_INVALID_STATE;
    }
    
    xTaskCreate(check_for_updates_task, "check_updates", 8192, NULL, 5, NULL);
    return ESP_OK;
}

esp_err_t update_manager_download_and_install(void) {
    if (current_status != UPDATE_STATUS_AVAILABLE) {
        return ESP_ERR_INVALID_STATE;
    }
    
    xTaskCreate(download_and_install_task, "download_update", 8192, NULL, 5, NULL);
    return ESP_OK;
}

update_status_t update_manager_get_status(void) {
    return current_status;
}

const software_update_info_t* update_manager_get_latest_info(void) {
    return &latest_update_info;
}

const char* update_manager_get_current_version(void) {
    return TRIMIX_ANALYZER_VERSION;
}

const char* update_manager_get_status_text(void) {
    return status_text;
}

float update_manager_get_progress(void) {
    return download_progress;
}
