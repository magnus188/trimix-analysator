#include "backlight_service.h"
#include "board/hardware.h"
#include <driver/ledc.h>
#include <esp_log.h>

static const char* TAG = "BACKLIGHT";

// LEDC configuration
#define LEDC_TIMER          LEDC_TIMER_0
#define LEDC_MODE           LEDC_LOW_SPEED_MODE
#define LEDC_CHANNEL        LEDC_CHANNEL_0
#define LEDC_DUTY_RES       LEDC_TIMER_10_BIT   // 0-1023
#define LEDC_FREQUENCY      5000                 // 5kHz PWM

static uint8_t s_brightness = 100;
static bool s_initialized = false;

void backlight_init(void) {
    if (s_initialized) return;
    
    // Configure LEDC timer
    ledc_timer_config_t timer_conf = {
        .speed_mode      = LEDC_MODE,
        .duty_resolution = LEDC_DUTY_RES,
        .timer_num       = LEDC_TIMER,
        .freq_hz         = LEDC_FREQUENCY,
        .clk_cfg         = LEDC_AUTO_CLK
    };
    ESP_ERROR_CHECK(ledc_timer_config(&timer_conf));
    
    // Configure LEDC channel
    ledc_channel_config_t channel_conf = {
        .gpio_num       = LCD_PIN_BK_LIGHT,
        .speed_mode     = LEDC_MODE,
        .channel        = LEDC_CHANNEL,
        .intr_type      = LEDC_INTR_DISABLE,
        .timer_sel      = LEDC_TIMER,
        .duty           = 1023,  // Start at full brightness
        .hpoint         = 0,
        .flags          = { .output_invert = 0 }
    };
    ESP_ERROR_CHECK(ledc_channel_config(&channel_conf));
    
    s_initialized = true;
    s_brightness = 100;
    
    ESP_LOGI(TAG, "Backlight PWM initialized on GPIO %d", LCD_PIN_BK_LIGHT);
}

void backlight_set(uint8_t percent) {
    if (!s_initialized) {
        ESP_LOGW(TAG, "Backlight not initialized, initializing now");
        backlight_init();
        if (!s_initialized) {
            ESP_LOGE(TAG, "Failed to initialize backlight");
            return;
        }
    }
    
    // Enforce safe brightness limits (10-100%)
    if (percent < 10) percent = 10;
    if (percent > 100) percent = 100;
    s_brightness = percent;
    
    // Convert percent to duty cycle (0-1023)
    // LCD_BK_LIGHT_ON_LEVEL = 1 means high = on
    // Minimum duty of ~102 (10%) ensures screen is always visible
    uint32_t duty = (percent * 1023) / 100;
    ESP_LOGI(TAG, "Setting brightness to %d%% (duty: %lu)", percent, duty);
    
    esp_err_t err = ledc_set_duty(LEDC_MODE, LEDC_CHANNEL, duty);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "ledc_set_duty failed: %s", esp_err_to_name(err));
        return;
    }
    err = ledc_update_duty(LEDC_MODE, LEDC_CHANNEL);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "ledc_update_duty failed: %s", esp_err_to_name(err));
        return;
    }
    
    ESP_LOGD(TAG, "Backlight set to %d%% (duty: %lu)", percent, duty);
}

uint8_t backlight_get(void) {
    return s_brightness;
}
