// LVGL hardware/display/touch initialization (extracted from main.cpp)
#include "lvgl_port.h"
#include "board/hardware.h"
#include "services/backlight_service.h"
#include <driver/gpio.h>
#include <driver/i2c.h>
#include <esp_lcd_panel_ops.h>
#include <esp_lcd_panel_rgb.h>
#include <esp_lcd_touch_gt911.h>
#include <esp_heap_caps.h>
#include <esp_log.h>
#include <esp_timer.h>

namespace {
const char *TAG = "LVGL_PORT";
constexpr uint16_t PORTRAIT_W = 480;
constexpr uint16_t PORTRAIT_H = 800;
constexpr i2c_port_t I2C_PORT = I2C_NUM_0;
constexpr uint32_t LV_TICK_MS = 5; // tick period to reduce timer load
// Two small internal-RAM buffers keep RGB DMA from reading the frame directly
// from slower PSRAM. The driver allocates two buffers of this size.
constexpr size_t LCD_BOUNCE_BUFFER_LINES = 10;

uint16_t map_u16(uint16_t n, uint16_t in_min, uint16_t in_max, uint16_t out_min, uint16_t out_max){ return (n - in_min) * (out_max - out_min) / (in_max - in_min) + out_min; }

void process_coords(esp_lcd_touch_handle_t, uint16_t *x, uint16_t *y, uint16_t*, uint8_t*, uint8_t){
    uint16_t hw_x = map_u16(*x, TOUCH_H_RES_MIN, TOUCH_H_RES_MAX, 0, LCD_H_RES);
    uint16_t hw_y = map_u16(*y, TOUCH_V_RES_MIN, TOUCH_V_RES_MAX, 0, LCD_V_RES);
    *x = (PORTRAIT_W - 1) - hw_y; *y = hw_x;
}

esp_err_t init_i2c(){ i2c_config_t conf = { .mode=I2C_MODE_MASTER, .sda_io_num=TOUCH_PIN_SDA, .scl_io_num=TOUCH_PIN_SCL, .sda_pullup_en=GPIO_PULLUP_ENABLE, .scl_pullup_en=GPIO_PULLUP_ENABLE, .master={ .clk_speed = TOUCH_FREQ_HZ }, .clk_flags=I2C_SCLK_SRC_FLAG_FOR_NOMAL }; ESP_ERROR_CHECK(i2c_param_config(I2C_PORT,&conf)); ESP_ERROR_CHECK(i2c_driver_install(I2C_PORT, conf.mode,0,0,0)); return ESP_OK; }

// Track last valid touch point to prevent coordinate jumps
static int16_t g_last_x = 0;
static int16_t g_last_y = 0;

void touchpad_read(lv_indev_t *drv, lv_indev_data_t *data){
    auto tp = static_cast<esp_lcd_touch_handle_t>(lv_indev_get_user_data(drv));
    uint16_t x = 0, y = 0;
    uint8_t cnt = 0;
    esp_lcd_touch_read_data(tp);
    bool pressed = esp_lcd_touch_get_coordinates(tp, &x, &y, nullptr, &cnt, 1);
    if (pressed && cnt > 0) {
        // Validate coordinates are within screen bounds
        if (x < PORTRAIT_W && y < PORTRAIT_H) {
            g_last_x = x;
            g_last_y = y;
            data->point.x = x;
            data->point.y = y;
            data->state = LV_INDEV_STATE_PRESSED;
        } else {
            // Invalid coordinates - treat as released
            data->point.x = g_last_x;
            data->point.y = g_last_y;
            data->state = LV_INDEV_STATE_RELEASED;
        }
    } else {
        // Released - use last known good position
        data->point.x = g_last_x;
        data->point.y = g_last_y;
        data->state = LV_INDEV_STATE_RELEASED;
    }
}

void flush_cb(lv_display_t *disp, const lv_area_t *area, unsigned char *color_map){
    auto panel = static_cast<esp_lcd_panel_handle_t>(lv_display_get_user_data(disp));
    // The RGB panel driver performs the portrait-to-landscape mapping directly
    // into its framebuffer. This removes the previous full-area software
    // rotation buffer and the second copy that followed it.
    esp_err_t err = esp_lcd_panel_draw_bitmap(panel,
                                               area->x1, area->y1,
                                               area->x2 + 1, area->y2 + 1,
                                               color_map);
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Display flush failed: %s", esp_err_to_name(err));
    }
    lv_disp_flush_ready(disp);
}

void tick_cb(void*){ lv_tick_inc(LV_TICK_MS); }
} // namespace

extern "C" void lvgl_port_init(void){
    static lv_display_t *disp; static lv_indev_t *indev; static esp_lcd_touch_handle_t tp; static esp_lcd_panel_handle_t panel=nullptr;
    
    // RGB panel configuration
    esp_lcd_rgb_panel_config_t panel_config = {
        .clk_src = LCD_CLK_SRC_DEFAULT,
        .timings = {
            .pclk_hz = LCD_PIXEL_CLOCK_HZ,
            .h_res = LCD_H_RES,
            .v_res = LCD_V_RES,
            .hsync_pulse_width = 4,
            .hsync_back_porch = 8,
            .hsync_front_porch = 8,
            .vsync_pulse_width = 4,
            .vsync_back_porch = 8,
            .vsync_front_porch = 8,
            .flags = {
                .hsync_idle_low = false,
                .vsync_idle_low = false,
                .de_idle_high = false,
                .pclk_active_neg = true,
                .pclk_idle_high = false
            }
        },
        .data_width = 16,
        .bits_per_pixel = 0,
        // draw_bitmap() copies LVGL's partial buffer into the driver's active
        // framebuffer, so additional full framebuffers would never be swapped.
        .num_fbs = 1,
        .bounce_buffer_size_px = LCD_H_RES * LCD_BOUNCE_BUFFER_LINES,
        .sram_trans_align = 4,
        .psram_trans_align = 64,
        .hsync_gpio_num = LCD_PIN_HSYNC,
        .vsync_gpio_num = LCD_PIN_VSYNC,
        .de_gpio_num = LCD_PIN_DE,
        .pclk_gpio_num = LCD_PIN_PCLK,
        .disp_gpio_num = LCD_PIN_DISP_EN,
        .data_gpio_nums = {
            LCD_PIN_DATA0, LCD_PIN_DATA1, LCD_PIN_DATA2, LCD_PIN_DATA3,
            LCD_PIN_DATA4, LCD_PIN_DATA5, LCD_PIN_DATA6, LCD_PIN_DATA7,
            LCD_PIN_DATA8, LCD_PIN_DATA9, LCD_PIN_DATA10, LCD_PIN_DATA11,
            LCD_PIN_DATA12, LCD_PIN_DATA13, LCD_PIN_DATA14, LCD_PIN_DATA15
        },
        .flags = {
            .disp_active_low = 0,
            .refresh_on_demand = 0,
            .fb_in_psram = true,
            .double_fb = false,
            .no_fb = 0,
            .bb_invalidate_cache = 0
        }
    };
    
    ESP_ERROR_CHECK(esp_lcd_new_rgb_panel(&panel_config, &panel));
    ESP_ERROR_CHECK(esp_lcd_panel_reset(panel));
    ESP_ERROR_CHECK(esp_lcd_panel_init(panel));
    // Match the existing portrait mapping: (x, y) -> (y, 479 - x).
    ESP_ERROR_CHECK(esp_lcd_panel_swap_xy(panel, true));
    ESP_ERROR_CHECK(esp_lcd_panel_mirror(panel, false, true));
    
    lv_init();
    // Larger draw buffer = fewer flushes = better performance (1/4 screen instead of 1/6)
    size_t buf_size = PORTRAIT_W * PORTRAIT_H / 4 * 2;
    void *buf1 = heap_caps_malloc(buf_size, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT);
    if (!buf1) {
        ESP_LOGE(TAG, "Failed to allocate LVGL draw buffer (%u bytes)", (unsigned)buf_size);
        ESP_ERROR_CHECK(ESP_ERR_NO_MEM);
    }
    disp = lv_display_create(PORTRAIT_W, PORTRAIT_H);
    if (!disp) {
        ESP_LOGE(TAG, "Failed to create LVGL display");
        ESP_ERROR_CHECK(ESP_ERR_NO_MEM);
    }
    lv_display_set_buffers(disp, buf1, nullptr, buf_size, LV_DISPLAY_RENDER_MODE_PARTIAL);
    lv_display_set_user_data(disp, panel);
    lv_display_set_flush_cb(disp, flush_cb);
    init_i2c();
    // Touch
    esp_lcd_panel_io_handle_t tp_io_handle=nullptr; const esp_lcd_panel_io_i2c_config_t tp_io_config = { .dev_addr = ESP_LCD_TOUCH_IO_I2C_GT911_ADDRESS, .on_color_trans_done=NULL, .user_ctx=NULL, .control_phase_bytes=1, .dc_bit_offset=0, .lcd_cmd_bits=16, .lcd_param_bits=0, .flags = { .dc_low_on_data=0, .disable_control_phase=1 } }; const esp_lcd_touch_config_t tp_cfg = { .x_max=LCD_H_RES, .y_max=LCD_V_RES, .rst_gpio_num=TOUCH_PIN_RESET, .int_gpio_num=TOUCH_PIN_INT, .levels={ .reset=0, .interrupt=0 }, .flags={ .swap_xy=0, .mirror_x=0, .mirror_y=0 }, .process_coordinates=process_coords, .interrupt_callback=NULL}; ESP_ERROR_CHECK(esp_lcd_new_panel_io_i2c((esp_lcd_i2c_bus_handle_t)I2C_PORT, &tp_io_config, &tp_io_handle)); ESP_ERROR_CHECK(esp_lcd_touch_new_i2c_gt911(tp_io_handle, &tp_cfg, &tp));
    indev = lv_indev_create(); lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER); lv_indev_set_user_data(indev, tp); lv_indev_set_read_cb(indev, touchpad_read); lv_indev_enable(indev, true); lv_indev_set_display(indev, disp);
    const esp_timer_create_args_t tick_args = { .callback = tick_cb, .arg = nullptr, .dispatch_method = ESP_TIMER_TASK, .name = "lvgl_tick", .skip_unhandled_events = true }; esp_timer_handle_t tick_timer; ESP_ERROR_CHECK(esp_timer_create(&tick_args, &tick_timer)); ESP_ERROR_CHECK(esp_timer_start_periodic(tick_timer, LV_TICK_MS * 1000));
    // Initialize backlight with PWM for brightness control
    backlight_init();
    backlight_set(100);
}
