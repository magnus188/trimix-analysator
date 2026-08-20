#include <esp_err.h>
#include <esp_log.h>
#include <esp_ota_ops.h>
#include <stdint.h>

#include "ui/lvgl/lvgl_port.h"
#include "ui/screens/screen_manager.h"
#include "services/settings_service.h"
#include "services/wifi_service.h"
#include "services/c6_update_service.h"
#include "services/battery_service.h"
#include "services/analysis_history.h"
#include "services/cylinder_profiles.h"

extern "C" void app_main(void) {
    // Initialize persistent, non-UI state before creating screens.
    settings_init();
    analysis_history_init();
    cylinder_profiles_init();

    // esp_lvgl_adapter owns the LVGL tick and worker task. Screen creation is
    // the only application-side LVGL work performed outside its callbacks.
    ESP_ERROR_CHECK(lvgl_port_init());
    ESP_ERROR_CHECK(lvgl_port_lock(UINT32_MAX));
    screens_init();
    lvgl_port_unlock();

    // Start asynchronous services only after the UI exists. Their callbacks
    // publish plain state; they never call LVGL directly.
#if CONFIG_TRIMIX_ENABLE_WIFI
    wifi_service_init();
#elif CONFIG_TRIMIX_UPDATE_C6_ON_BOOT
    c6_update_service_run();
#endif
    battery_service_init();
    battery_start_monitoring();
#if CONFIG_TRIMIX_ENABLE_WIFI
    wifi_service_auto_connect();
#else
    ESP_LOGW("MAIN", "Wi-Fi is disabled in this recovery build");
#endif

    // Keep rollback armed until the native display, all screens, and the
    // background services have initialized. A crash before this point leaves
    // the image pending so the bootloader can return to the previous OTA slot.
    const esp_partition_t* running_partition = esp_ota_get_running_partition();
    esp_ota_img_states_t ota_state;
    if (esp_ota_get_state_partition(running_partition, &ota_state) == ESP_OK &&
        ota_state == ESP_OTA_IMG_PENDING_VERIFY) {
        ESP_ERROR_CHECK(esp_ota_mark_app_valid_cancel_rollback());
    }
}
