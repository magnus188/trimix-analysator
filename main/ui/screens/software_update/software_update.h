#pragma once
#include <lvgl.h>
#include <esp_err.h>

#ifdef __cplusplus
extern "C" {
#endif

// Software update screen interface
lv_obj_t *screen_software_update_create(void);
void software_update_cleanup(void);

// Software update functionality
typedef enum {
    UPDATE_STATUS_IDLE = 0,
    UPDATE_STATUS_CHECKING,
    UPDATE_STATUS_AVAILABLE,
    UPDATE_STATUS_DOWNLOADING,
    UPDATE_STATUS_INSTALLING,
    UPDATE_STATUS_SUCCESS,
    UPDATE_STATUS_ERROR
} update_status_t;

typedef struct {
    char version[32];
    char release_name[64];
    char description[256];
    char download_url[256];
    size_t size_bytes;
    bool prerelease;
} software_update_info_t;

// Update manager functions
esp_err_t update_manager_init(void);
esp_err_t update_manager_check_for_updates(void);
esp_err_t update_manager_download_and_install(void);
update_status_t update_manager_get_status(void);
const software_update_info_t* update_manager_get_latest_info(void);
const char* update_manager_get_current_version(void);
const char* update_manager_get_status_text(void);
float update_manager_get_progress(void);

#ifdef __cplusplus
}
#endif
