#include <freertos/FreeRTOS.h>
#include <freertos/semphr.h>
#include <freertos/task.h>

#include <esp_err.h>
#include <esp_lcd_panel_ops.h>
#include <esp_lcd_panel_rgb.h>
#include <esp_lcd_touch_gt911.h>
#include <esp_log.h>
#include <esp_timer.h>

#include <driver/gpio.h>
#include <driver/i2c.h>

#include <string.h>   // for memcpy
#include <assert.h>    // for assert

#include "sdkconfig.h"
#include "lvgl.h"
#include "hardware.h"
#include "trimix_screens.h"

#define TAG "main"

const i2c_port_t i2c_master_port = I2C_NUM_0;

// Simple map helper for touch raw->screen coordinate scaling
static uint16_t gt911_map(uint16_t n, uint16_t in_min, uint16_t in_max, uint16_t out_min, uint16_t out_max) { return (n - in_min) * (out_max - out_min) / (in_max - in_min) + out_min; }

// Portrait logical vs hardware landscape
#define LVGL_PORTRAIT_WIDTH  480
#define LVGL_PORTRAIT_HEIGHT 800

static esp_err_t gt911_init_i2c(void) {
    i2c_config_t conf = {
        .mode = I2C_MODE_MASTER,
        .sda_io_num = TOUCH_PIN_SDA,
        .scl_io_num = TOUCH_PIN_SCL,
        .sda_pullup_en = GPIO_PULLUP_ENABLE,
        .scl_pullup_en = GPIO_PULLUP_ENABLE,
        .master = { .clk_speed = TOUCH_FREQ_HZ },
        .clk_flags = I2C_SCLK_SRC_FLAG_FOR_NOMAL
    };
    ESP_ERROR_CHECK(i2c_param_config(i2c_master_port, &conf));
    ESP_ERROR_CHECK(i2c_driver_install(i2c_master_port, conf.mode, 0, 0, 0));
    return ESP_OK;
}

static void gt911_process_coordinates(esp_lcd_touch_handle_t tp, uint16_t *x, uint16_t *y, uint16_t *strength, uint8_t *point_num, uint8_t max_point_num) {
    uint16_t hw_x = gt911_map(*x, TOUCH_H_RES_MIN, TOUCH_H_RES_MAX, 0, LCD_H_RES);
    uint16_t hw_y = gt911_map(*y, TOUCH_V_RES_MIN, TOUCH_V_RES_MAX, 0, LCD_V_RES);
    *x = (LVGL_PORTRAIT_WIDTH - 1) - hw_y; // rotate
    *y = hw_x;
}

static void gt911_touch_init(esp_lcd_touch_handle_t *tp) {
    esp_lcd_panel_io_handle_t tp_io_handle = NULL;
    const esp_lcd_panel_io_i2c_config_t tp_io_config = {
        .dev_addr = ESP_LCD_TOUCH_IO_I2C_GT911_ADDRESS,
        .on_color_trans_done = NULL,
        .user_ctx = NULL,
        .control_phase_bytes = 1,
        .dc_bit_offset = 0,
        .lcd_cmd_bits = 16,
        .lcd_param_bits = 0,
        .flags = { .dc_low_on_data = 0, .disable_control_phase = 1 }
    };
    const esp_lcd_touch_config_t tp_cfg = {
        .x_max = LCD_H_RES,
        .y_max = LCD_V_RES,
        .rst_gpio_num = TOUCH_PIN_RESET,
        .int_gpio_num = TOUCH_PIN_INT,
        .levels = { .reset = 0, .interrupt = 0 },
        .flags = { .swap_xy = 0, .mirror_x = 0, .mirror_y = 0 },
        .process_coordinates = gt911_process_coordinates,
        .interrupt_callback = NULL
    };
    ESP_ERROR_CHECK(esp_lcd_new_panel_io_i2c((esp_lcd_i2c_bus_handle_t)i2c_master_port, &tp_io_config, &tp_io_handle));
    ESP_ERROR_CHECK(esp_lcd_touch_new_i2c_gt911(tp_io_handle, &tp_cfg, tp));
}

static void gt911_touchpad_read(lv_indev_t *indev_drv, lv_indev_data_t *data) {
    esp_lcd_touch_handle_t tp = (esp_lcd_touch_handle_t)lv_indev_get_user_data(indev_drv);
    uint16_t touchpad_x, touchpad_y; uint8_t touchpad_cnt = 0;
    esp_lcd_touch_read_data(tp);
    bool pressed = esp_lcd_touch_get_coordinates(tp, &touchpad_x, &touchpad_y, NULL, &touchpad_cnt, 1);
    if (pressed && touchpad_cnt) { data->point.x = touchpad_x; data->point.y = touchpad_y; data->state = LV_INDEV_STATE_PRESSED; }
    else { data->state = LV_INDEV_STATE_RELEASED; }
}

static void lcd_lvgl_flush_cb(lv_display_t *drv, const lv_area_t *area, unsigned char *color_map) {
    esp_lcd_panel_handle_t panel_handle = (esp_lcd_panel_handle_t)lv_display_get_user_data(drv);
    int lv_x1 = area->x1, lv_y1 = area->y1, lv_x2 = area->x2, lv_y2 = area->y2;
    int w = lv_x2 - lv_x1 + 1, h = lv_y2 - lv_y1 + 1;
    int hw_x1 = lv_y1, hw_x2 = lv_y2;
    int hw_y1 = (LVGL_PORTRAIT_WIDTH - 1) - lv_x2;
    int hw_y2 = (LVGL_PORTRAIT_WIDTH - 1) - lv_x1;
    int rotated_w = hw_x2 - hw_x1 + 1, rotated_h = hw_y2 - hw_y1 + 1;
    int bpp = LV_COLOR_DEPTH / 8;
    size_t buf_size = rotated_w * rotated_h * bpp;
    void *rot_buf = heap_caps_malloc(buf_size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    if(!rot_buf){ lv_disp_flush_ready(drv); return; }
    uint8_t *dst = (uint8_t*)rot_buf; const uint8_t *src = (const uint8_t*)color_map;
    for(int y=0;y<h;++y){ for(int x=0;x<w;++x){ int si=(y*w + x)*bpp; int dx=y; int dy=(w-1)-x; int di=(dy*rotated_w + dx)*bpp; memcpy(dst+di, src+si, bpp);} }
    esp_lcd_panel_draw_bitmap(panel_handle, hw_x1, hw_y1, hw_x2+1, hw_y2+1, rot_buf);
    heap_caps_free(rot_buf);
    lv_disp_flush_ready(drv);
}

static void tick(void *arg){ lv_tick_inc(2); }

static void lcd_init(void *ignored) {
    static lv_display_t *disp; static lv_indev_t *indev; static esp_lcd_touch_handle_t tp; static esp_lcd_panel_handle_t panel=NULL;
    gpio_config_t bk_gpio_config = { .pin_bit_mask = 1ULL << LCD_PIN_BK_LIGHT, .mode = GPIO_MODE_OUTPUT, .pull_up_en = 0, .pull_down_en = 0, .intr_type = GPIO_INTR_DISABLE};
    esp_lcd_rgb_panel_config_t panel_config = {
        .clk_src = LCD_CLK_SRC_DEFAULT,
        .timings = { .pclk_hz = LCD_PIXEL_CLOCK_HZ, .h_res = LCD_H_RES, .v_res = LCD_V_RES,
            .hsync_pulse_width = 4, .hsync_back_porch = 8, .hsync_front_porch = 8,
            .vsync_pulse_width = 4, .vsync_back_porch = 8, .vsync_front_porch = 8,
            .flags = { .hsync_idle_low = false, .vsync_idle_low = false, .de_idle_high = false, .pclk_active_neg = true, .pclk_idle_high = false } },
        .data_width = 16, .bits_per_pixel = 0, .num_fbs = 2, .bounce_buffer_size_px = 0, .sram_trans_align = 0, .psram_trans_align = 64,
        .hsync_gpio_num = LCD_PIN_HSYNC, .vsync_gpio_num = LCD_PIN_VSYNC, .de_gpio_num = LCD_PIN_DE, .pclk_gpio_num = LCD_PIN_PCLK, .disp_gpio_num = LCD_PIN_DISP_EN,
        .data_gpio_nums = { LCD_PIN_DATA0, LCD_PIN_DATA1, LCD_PIN_DATA2, LCD_PIN_DATA3, LCD_PIN_DATA4, LCD_PIN_DATA5, LCD_PIN_DATA6, LCD_PIN_DATA7,
                            LCD_PIN_DATA8, LCD_PIN_DATA9, LCD_PIN_DATA10, LCD_PIN_DATA11, LCD_PIN_DATA12, LCD_PIN_DATA13, LCD_PIN_DATA14, LCD_PIN_DATA15 },
        .flags = { .disp_active_low = 0, .refresh_on_demand = 0, .fb_in_psram = true, .double_fb = true, .no_fb = 0, .bb_invalidate_cache = 0 }
    };
    gpio_config(&bk_gpio_config);
    esp_lcd_new_rgb_panel(&panel_config, &panel);
    esp_lcd_panel_reset(panel);
    esp_lcd_panel_init(panel);
    lv_init();
    void *buf1 = heap_caps_malloc(LVGL_PORTRAIT_WIDTH * LVGL_PORTRAIT_HEIGHT / 10, MALLOC_CAP_SPIRAM); assert(buf1);
    void *buf2 = heap_caps_malloc(LVGL_PORTRAIT_WIDTH * LVGL_PORTRAIT_HEIGHT / 10, MALLOC_CAP_SPIRAM); assert(buf2);
    disp = lv_display_create(LVGL_PORTRAIT_WIDTH, LVGL_PORTRAIT_HEIGHT);
    lv_display_set_buffers(disp, buf1, buf2, LVGL_PORTRAIT_WIDTH * LVGL_PORTRAIT_HEIGHT / 10, LV_DISPLAY_RENDER_MODE_PARTIAL);
    lv_display_set_user_data(disp, panel);
    lv_display_set_flush_cb(disp, lcd_lvgl_flush_cb);
    gt911_init_i2c();
    gt911_touch_init(&tp);
    indev = lv_indev_create();
    lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
    lv_indev_set_user_data(indev, tp);
    lv_indev_set_read_cb(indev, gt911_touchpad_read);
    lv_indev_enable(indev, true);
    lv_indev_set_display(indev, disp);
    const esp_timer_create_args_t tick_args = { .callback = tick, .arg = NULL, .dispatch_method = ESP_TIMER_TASK, .name = "lvgl_tick", .skip_unhandled_events = true };
    esp_timer_handle_t tick_timer; esp_timer_create(&tick_args, &tick_timer); esp_timer_start_periodic(tick_timer, 2000);
    gpio_set_level(LCD_PIN_BK_LIGHT, LCD_BK_LIGHT_ON_LEVEL);
    screens_init();
    while(1){ vTaskDelay(20 / portTICK_PERIOD_MS); lv_timer_handler(); }
}

void app_main(void) { xTaskCreatePinnedToCore(lcd_init, "lcd_init", 8192, NULL, 1, NULL, 1); vTaskDelay(portMAX_DELAY); }
