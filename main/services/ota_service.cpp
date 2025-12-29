#include "ota_service.h"
#include "../version.h"
#include <esp_log.h>
#include <esp_http_client.h>
#include <esp_https_ota.h>
#include <esp_ota_ops.h>
#include <esp_system.h>
#include <esp_crt_bundle.h>
#include <esp_timer.h>
#include <freertos/FreeRTOS.h>
#include <freertos/task.h>
#include <cJSON.h>
#include <cstring>
#include <cstdlib>

static const char* TAG = "OTA_SERVICE";

namespace {

// State
ota_state_t g_state = OTA_STATE_IDLE;
ota_update_info_t g_update_info = {};
char g_error_message[128] = {0};
ota_progress_cb_t g_progress_cb = nullptr;
TaskHandle_t g_ota_task = nullptr;
volatile bool g_cancel_requested = false;

// HTTP response buffer
char* g_http_buffer = nullptr;
int g_http_buffer_len = 0;
constexpr int HTTP_BUFFER_SIZE = 4096;

// Compare version strings (returns >0 if v1 > v2)
int compare_versions(const char* v1, const char* v2) {
    int major1 = 0, minor1 = 0, patch1 = 0;
    int major2 = 0, minor2 = 0, patch2 = 0;
    
    // Skip 'v' prefix if present
    if (v1[0] == 'v' || v1[0] == 'V') v1++;
    if (v2[0] == 'v' || v2[0] == 'V') v2++;
    
    sscanf(v1, "%d.%d.%d", &major1, &minor1, &patch1);
    sscanf(v2, "%d.%d.%d", &major2, &minor2, &patch2);
    
    if (major1 != major2) return major1 - major2;
    if (minor1 != minor2) return minor1 - minor2;
    return patch1 - patch2;
}

// HTTP event handler for version check
esp_err_t http_event_handler(esp_http_client_event_t* evt) {
    switch (evt->event_id) {
        case HTTP_EVENT_ON_DATA:
            if (!esp_http_client_is_chunked_response(evt->client)) {
                if (g_http_buffer && g_http_buffer_len + evt->data_len < HTTP_BUFFER_SIZE - 1) {
                    memcpy(g_http_buffer + g_http_buffer_len, evt->data, evt->data_len);
                    g_http_buffer_len += evt->data_len;
                    g_http_buffer[g_http_buffer_len] = '\0';
                }
            }
            break;
        default:
            break;
    }
    return ESP_OK;
}

// Parse GitHub release JSON response
bool parse_release_json(const char* json_str) {
    cJSON* root = cJSON_Parse(json_str);
    if (!root) {
        ESP_LOGE(TAG, "Failed to parse JSON");
        return false;
    }
    
    bool success = false;
    
    // Get tag name (version)
    cJSON* tag_name = cJSON_GetObjectItem(root, "tag_name");
    if (tag_name && cJSON_IsString(tag_name)) {
        strncpy(g_update_info.version, tag_name->valuestring, sizeof(g_update_info.version) - 1);
    }
    
    // Get release notes (body)
    cJSON* body = cJSON_GetObjectItem(root, "body");
    if (body && cJSON_IsString(body)) {
        strncpy(g_update_info.release_notes, body->valuestring, sizeof(g_update_info.release_notes) - 1);
        // Truncate with ellipsis if too long
        if (strlen(body->valuestring) >= sizeof(g_update_info.release_notes) - 4) {
            strcpy(g_update_info.release_notes + sizeof(g_update_info.release_notes) - 4, "...");
        }
    }
    
    // Find firmware binary in assets
    cJSON* assets = cJSON_GetObjectItem(root, "assets");
    if (assets && cJSON_IsArray(assets)) {
        cJSON* asset = nullptr;
        cJSON_ArrayForEach(asset, assets) {
            cJSON* name = cJSON_GetObjectItem(asset, "name");
            if (name && cJSON_IsString(name)) {
                // Look for .bin file
                if (strstr(name->valuestring, ".bin") != nullptr) {
                    cJSON* url = cJSON_GetObjectItem(asset, "browser_download_url");
                    cJSON* size = cJSON_GetObjectItem(asset, "size");
                    
                    if (url && cJSON_IsString(url)) {
                        strncpy(g_update_info.download_url, url->valuestring, 
                                sizeof(g_update_info.download_url) - 1);
                    }
                    if (size && cJSON_IsNumber(size)) {
                        g_update_info.file_size = (uint32_t)size->valuedouble;
                    }
                    success = true;
                    break;
                }
            }
        }
    }
    
    cJSON_Delete(root);
    
    if (success) {
        // Check if newer than current version
        g_update_info.is_newer = compare_versions(g_update_info.version, TRIMIX_ANALYZER_VERSION) > 0;
        ESP_LOGI(TAG, "Found release: %s (current: %s, newer: %s)", 
                 g_update_info.version, TRIMIX_ANALYZER_VERSION,
                 g_update_info.is_newer ? "yes" : "no");
    }
    
    return success;
}

// Check for update task
void check_update_task(void* param) {
    ESP_LOGI(TAG, "Checking for updates...");
    g_state = OTA_STATE_CHECKING;
    
    // Allocate HTTP buffer
    g_http_buffer = (char*)malloc(HTTP_BUFFER_SIZE);
    if (!g_http_buffer) {
        strcpy(g_error_message, "Out of memory");
        g_state = OTA_STATE_ERROR;
        vTaskDelete(nullptr);
        return;
    }
    g_http_buffer_len = 0;
    
    // Configure HTTP client
    esp_http_client_config_t config = {};
    config.url = GITHUB_API_URL;
    config.event_handler = http_event_handler;
    config.crt_bundle_attach = esp_crt_bundle_attach;
    config.timeout_ms = 10000;
    
    esp_http_client_handle_t client = esp_http_client_init(&config);
    if (!client) {
        strcpy(g_error_message, "HTTP init failed");
        g_state = OTA_STATE_ERROR;
        free(g_http_buffer);
        g_http_buffer = nullptr;
        vTaskDelete(nullptr);
        return;
    }
    
    // Set GitHub API headers
    esp_http_client_set_header(client, "Accept", "application/vnd.github.v3+json");
    esp_http_client_set_header(client, "User-Agent", "Trimix-Analyzer");
    
    // Perform request
    esp_err_t err = esp_http_client_perform(client);
    int status_code = esp_http_client_get_status_code(client);
    
    if (err == ESP_OK && status_code == 200) {
        if (parse_release_json(g_http_buffer)) {
            if (g_update_info.is_newer && strlen(g_update_info.download_url) > 0) {
                g_state = OTA_STATE_UPDATE_AVAILABLE;
                ESP_LOGI(TAG, "Update available: %s", g_update_info.version);
            } else {
                g_state = OTA_STATE_NO_UPDATE;
                ESP_LOGI(TAG, "No update available");
            }
        } else {
            strcpy(g_error_message, "No firmware in release");
            g_state = OTA_STATE_ERROR;
        }
    } else {
        snprintf(g_error_message, sizeof(g_error_message), 
                 "HTTP error: %d (code %d)", err, status_code);
        g_state = OTA_STATE_ERROR;
        ESP_LOGE(TAG, "%s", g_error_message);
    }
    
    esp_http_client_cleanup(client);
    free(g_http_buffer);
    g_http_buffer = nullptr;
    
    g_ota_task = nullptr;
    vTaskDelete(nullptr);
}

// OTA update task
void ota_update_task(void* param) {
    ESP_LOGI(TAG, "Starting OTA update from: %s", g_update_info.download_url);
    g_state = OTA_STATE_DOWNLOADING;
    
    if (g_progress_cb) {
        g_progress_cb(0, "Connecting...");
    }
    
    // Configure HTTPS OTA with larger buffer for GitHub redirects
    esp_http_client_config_t http_config = {};
    http_config.url = g_update_info.download_url;
    http_config.crt_bundle_attach = esp_crt_bundle_attach;
    http_config.timeout_ms = 30000;
    http_config.keep_alive_enable = true;
    http_config.buffer_size = 1024;           // Receive buffer
    http_config.buffer_size_tx = 1024;        // Transmit buffer  
    http_config.max_redirection_count = 10;   // GitHub uses redirects to CDN
    
    esp_https_ota_config_t ota_config = {};
    ota_config.http_config = &http_config;
    ota_config.bulk_flash_erase = false;      // Use sector erase for progress tracking
    
    esp_https_ota_handle_t ota_handle = nullptr;
    esp_err_t err = esp_https_ota_begin(&ota_config, &ota_handle);
    
    if (err != ESP_OK) {
        snprintf(g_error_message, sizeof(g_error_message), "OTA begin failed: %s", esp_err_to_name(err));
        g_state = OTA_STATE_ERROR;
        ESP_LOGE(TAG, "%s", g_error_message);
        g_ota_task = nullptr;
        vTaskDelete(nullptr);
        return;
    }
    
    // Get total image size
    int image_size = esp_https_ota_get_image_size(ota_handle);
    int bytes_read = 0;
    int last_progress = -1;
    
    // Time tracking for ETA calculation
    int64_t start_time = esp_timer_get_time();
    int64_t last_update_time = start_time;
    int last_bytes_read = 0;
    float avg_speed = 0;  // bytes per second
    
    ESP_LOGI(TAG, "Image size: %d bytes", image_size);
    
    // Download and write in chunks
    while (!g_cancel_requested) {
        err = esp_https_ota_perform(ota_handle);
        
        if (err == ESP_ERR_HTTPS_OTA_IN_PROGRESS) {
            bytes_read = esp_https_ota_get_image_len_read(ota_handle);
            int progress = (image_size > 0) ? (bytes_read * 100 / image_size) : 0;
            
            // Update every 1% or every 500ms for smoother feedback
            int64_t now = esp_timer_get_time();
            int64_t elapsed_us = now - last_update_time;
            
            if (progress != last_progress || elapsed_us > 500000) {
                last_progress = progress;
                
                // Calculate speed (exponential moving average for smoothness)
                if (elapsed_us > 100000) {  // At least 100ms between calculations
                    int bytes_delta = bytes_read - last_bytes_read;
                    float current_speed = (float)bytes_delta * 1000000.0f / (float)elapsed_us;
                    
                    if (avg_speed == 0) {
                        avg_speed = current_speed;
                    } else {
                        avg_speed = avg_speed * 0.7f + current_speed * 0.3f;  // Smooth the speed
                    }
                    
                    last_bytes_read = bytes_read;
                    last_update_time = now;
                }
                
                // Calculate ETA
                char status[96];
                int remaining_bytes = image_size - bytes_read;
                
                if (avg_speed > 100 && remaining_bytes > 0) {
                    int eta_seconds = (int)(remaining_bytes / avg_speed);
                    int speed_kbps = (int)(avg_speed / 1024);
                    
                    if (eta_seconds < 60) {
                        snprintf(status, sizeof(status), "%d%% • %d KB/s • %ds left", 
                                 progress, speed_kbps, eta_seconds);
                    } else {
                        int eta_minutes = eta_seconds / 60;
                        int eta_secs = eta_seconds % 60;
                        snprintf(status, sizeof(status), "%d%% • %d KB/s • %dm %ds left", 
                                 progress, speed_kbps, eta_minutes, eta_secs);
                    }
                } else {
                    snprintf(status, sizeof(status), "Downloading... %d%%", progress);
                }
                
                if (g_progress_cb) {
                    g_progress_cb(progress, status);
                }
                ESP_LOGD(TAG, "Progress: %d%% (%d/%d) Speed: %.0f B/s", 
                         progress, bytes_read, image_size, avg_speed);
            }
            continue;
        }
        
        if (err == ESP_OK) {
            break;  // Download complete
        }
        
        // Error occurred
        snprintf(g_error_message, sizeof(g_error_message), "OTA failed: %s", esp_err_to_name(err));
        g_state = OTA_STATE_ERROR;
        ESP_LOGE(TAG, "%s", g_error_message);
        esp_https_ota_abort(ota_handle);
        g_ota_task = nullptr;
        vTaskDelete(nullptr);
        return;
    }
    
    // Check if cancelled
    if (g_cancel_requested) {
        ESP_LOGI(TAG, "OTA cancelled by user");
        strcpy(g_error_message, "Update cancelled");
        g_state = OTA_STATE_ERROR;
        esp_https_ota_abort(ota_handle);
        g_cancel_requested = false;
        g_ota_task = nullptr;
        vTaskDelete(nullptr);
        return;
    }
    
    // Verify and finish
    g_state = OTA_STATE_INSTALLING;
    if (g_progress_cb) {
        g_progress_cb(100, "Verifying...");
    }
    
    if (!esp_https_ota_is_complete_data_received(ota_handle)) {
        strcpy(g_error_message, "Incomplete download");
        g_state = OTA_STATE_ERROR;
        esp_https_ota_abort(ota_handle);
        g_ota_task = nullptr;
        vTaskDelete(nullptr);
        return;
    }
    
    err = esp_https_ota_finish(ota_handle);
    if (err == ESP_OK) {
        g_state = OTA_STATE_SUCCESS;
        ESP_LOGI(TAG, "OTA update successful! Reboot to apply.");
        if (g_progress_cb) {
            g_progress_cb(100, "Update complete!");
        }
    } else {
        snprintf(g_error_message, sizeof(g_error_message), "OTA finish failed: %s", esp_err_to_name(err));
        g_state = OTA_STATE_ERROR;
        ESP_LOGE(TAG, "%s", g_error_message);
    }
    
    g_ota_task = nullptr;
    vTaskDelete(nullptr);
}

}  // namespace

void ota_service_init(void) {
    ESP_LOGI(TAG, "OTA service initialized (current version: %s)", TRIMIX_ANALYZER_VERSION);
    g_state = OTA_STATE_IDLE;
}

void ota_check_for_update(void) {
    if (g_ota_task != nullptr) {
        ESP_LOGW(TAG, "OTA operation already in progress");
        return;
    }
    
    memset(&g_update_info, 0, sizeof(g_update_info));
    memset(g_error_message, 0, sizeof(g_error_message));
    
    xTaskCreate(check_update_task, "ota_check", 8192, nullptr, 5, &g_ota_task);
}

void ota_start_update(ota_progress_cb_t progress_cb) {
    if (g_state != OTA_STATE_UPDATE_AVAILABLE) {
        ESP_LOGE(TAG, "No update available to install");
        return;
    }
    
    if (g_ota_task != nullptr) {
        ESP_LOGW(TAG, "OTA operation already in progress");
        return;
    }
    
    g_progress_cb = progress_cb;
    g_cancel_requested = false;
    
    xTaskCreate(ota_update_task, "ota_update", 8192, nullptr, 5, &g_ota_task);
}

ota_state_t ota_get_state(void) {
    return g_state;
}

const ota_update_info_t* ota_get_update_info(void) {
    return &g_update_info;
}

const char* ota_get_error_message(void) {
    return g_error_message;
}

const char* ota_get_current_version(void) {
    return TRIMIX_ANALYZER_VERSION;
}

void ota_cancel(void) {
    if (g_state == OTA_STATE_DOWNLOADING) {
        g_cancel_requested = true;
    }
}

void ota_reboot(void) {
    ESP_LOGI(TAG, "Rebooting...");
    vTaskDelay(pdMS_TO_TICKS(500));
    esp_restart();
}
