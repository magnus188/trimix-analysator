// LVGL hardware/display/touch initialization (extracted from main.cpp)
#include "lvgl_port.h"
#include "board/hardware.h"
#include <driver/gpio.h>
#include <driver/i2c.h>
#include <esp_lcd_panel_ops.h>
#include <esp_lcd_panel_rgb.h>
#include <esp_lcd_touch_gt911.h>
#include <esp_heap_caps.h>
#include <esp_timer.h>
#include <cstring>
#include <cassert>

namespace {
constexpr uint16_t PORTRAIT_W = 480;
constexpr uint16_t PORTRAIT_H = 800;
constexpr i2c_port_t I2C_PORT = I2C_NUM_0;
constexpr uint32_t LV_TICK_MS = 5; // tick period to reduce timer load

// Reusable rotation buffer to avoid per-flush heap churn
uint8_t *g_rot_buf = nullptr;
size_t g_rot_buf_size = 0;

uint16_t map_u16(uint16_t n, uint16_t in_min, uint16_t in_max, uint16_t out_min, uint16_t out_max){ return (n - in_min) * (out_max - out_min) / (in_max - in_min) + out_min; }

bool ensure_rot_buf(size_t required){
    if(g_rot_buf_size >= required) return true;
    auto *buf = static_cast<uint8_t*>(heap_caps_malloc(required, MALLOC_CAP_SPIRAM | MALLOC_CAP_8BIT));
    if(!buf) return false;
    if(g_rot_buf) heap_caps_free(g_rot_buf);
    g_rot_buf = buf;
    g_rot_buf_size = required;
    return true;
}

void process_coords(esp_lcd_touch_handle_t, uint16_t *x, uint16_t *y, uint16_t*, uint8_t*, uint8_t){
    uint16_t hw_x = map_u16(*x, TOUCH_H_RES_MIN, TOUCH_H_RES_MAX, 0, LCD_H_RES);
    uint16_t hw_y = map_u16(*y, TOUCH_V_RES_MIN, TOUCH_V_RES_MAX, 0, LCD_V_RES);
    *x = (PORTRAIT_W - 1) - hw_y; *y = hw_x;
}

esp_err_t init_i2c(){ i2c_config_t conf = { .mode=I2C_MODE_MASTER, .sda_io_num=TOUCH_PIN_SDA, .scl_io_num=TOUCH_PIN_SCL, .sda_pullup_en=GPIO_PULLUP_ENABLE, .scl_pullup_en=GPIO_PULLUP_ENABLE, .master={ .clk_speed = TOUCH_FREQ_HZ }, .clk_flags=I2C_SCLK_SRC_FLAG_FOR_NOMAL }; ESP_ERROR_CHECK(i2c_param_config(I2C_PORT,&conf)); ESP_ERROR_CHECK(i2c_driver_install(I2C_PORT, conf.mode,0,0,0)); return ESP_OK; }

void touchpad_read(lv_indev_t *drv, lv_indev_data_t *data){ auto tp = static_cast<esp_lcd_touch_handle_t>(lv_indev_get_user_data(drv)); uint16_t x=0,y=0; uint8_t cnt=0; esp_lcd_touch_read_data(tp); bool pressed = esp_lcd_touch_get_coordinates(tp, &x,&y,nullptr,&cnt,1); if(pressed && cnt){ data->point.x = x; data->point.y = y; data->state = LV_INDEV_STATE_PRESSED;} else data->state = LV_INDEV_STATE_RELEASED; }

void flush_cb(lv_display_t *disp, const lv_area_t *area, unsigned char *color_map){
    auto panel = static_cast<esp_lcd_panel_handle_t>(lv_display_get_user_data(disp));
    int lv_x1=area->x1, lv_y1=area->y1, lv_x2=area->x2, lv_y2=area->y2;
    int w=lv_x2-lv_x1+1, h=lv_y2-lv_y1+1;
    int hw_x1=lv_y1, hw_x2=lv_y2;
    int hw_y1=(PORTRAIT_W-1)-lv_x2; int hw_y2=(PORTRAIT_W-1)-lv_x1;
    int rotated_w=hw_x2-hw_x1+1, rotated_h=hw_y2-hw_y1+1;
    int bpp = LV_COLOR_DEPTH/8;
    size_t buf_size = rotated_w*rotated_h*bpp;
    if(!ensure_rot_buf(buf_size)){ lv_disp_flush_ready(disp); return; }
    auto *dst = static_cast<uint8_t*>(g_rot_buf);
    auto *src = reinterpret_cast<const uint8_t*>(color_map);
    for(int y=0;y<h;++y){
        for(int x=0;x<w;++x){
            int si=(y*w + x)*bpp;
            int dx=y;
            int dy=(w-1)-x;
            int di=(dy*rotated_w + dx)*bpp;
            std::memcpy(dst+di, src+si, bpp);
        }
    }
    esp_lcd_panel_draw_bitmap(panel, hw_x1, hw_y1, hw_x2+1, hw_y2+1, g_rot_buf);
    lv_disp_flush_ready(disp);
}

void tick_cb(void*){ lv_tick_inc(LV_TICK_MS); }
} // namespace

extern "C" void lvgl_port_init(void){
    static lv_display_t *disp; static lv_indev_t *indev; static esp_lcd_touch_handle_t tp; static esp_lcd_panel_handle_t panel=nullptr;
    gpio_config_t bk_gpio_config = { .pin_bit_mask = 1ULL << LCD_PIN_BK_LIGHT, .mode = GPIO_MODE_OUTPUT, .pull_up_en = GPIO_PULLUP_DISABLE, .pull_down_en = GPIO_PULLDOWN_DISABLE, .intr_type = GPIO_INTR_DISABLE};
    esp_lcd_rgb_panel_config_t panel_config = { .clk_src = LCD_CLK_SRC_DEFAULT, .timings = { .pclk_hz = LCD_PIXEL_CLOCK_HZ, .h_res = LCD_H_RES, .v_res = LCD_V_RES, .hsync_pulse_width = 4, .hsync_back_porch = 8, .hsync_front_porch = 8, .vsync_pulse_width = 4, .vsync_back_porch = 8, .vsync_front_porch = 8, .flags = { .hsync_idle_low=false, .vsync_idle_low=false, .de_idle_high=false, .pclk_active_neg=true, .pclk_idle_high=false } }, .data_width = 16, .bits_per_pixel = 0, .num_fbs = 1, .bounce_buffer_size_px = 0, .sram_trans_align = 0, .psram_trans_align = 64, .hsync_gpio_num = LCD_PIN_HSYNC, .vsync_gpio_num = LCD_PIN_VSYNC, .de_gpio_num = LCD_PIN_DE, .pclk_gpio_num = LCD_PIN_PCLK, .disp_gpio_num = LCD_PIN_DISP_EN, .data_gpio_nums = { LCD_PIN_DATA0, LCD_PIN_DATA1, LCD_PIN_DATA2, LCD_PIN_DATA3, LCD_PIN_DATA4, LCD_PIN_DATA5, LCD_PIN_DATA6, LCD_PIN_DATA7, LCD_PIN_DATA8, LCD_PIN_DATA9, LCD_PIN_DATA10, LCD_PIN_DATA11, LCD_PIN_DATA12, LCD_PIN_DATA13, LCD_PIN_DATA14, LCD_PIN_DATA15 }, .flags = { .disp_active_low=0, .refresh_on_demand=0, .fb_in_psram=true, .double_fb=false, .no_fb=0, .bb_invalidate_cache=0 } };
    gpio_config(&bk_gpio_config);
    esp_lcd_new_rgb_panel(&panel_config, &panel); esp_lcd_panel_reset(panel); esp_lcd_panel_init(panel);
    lv_init();
    // Larger draw buffer = fewer flushes = better performance (1/4 screen instead of 1/6)
    size_t buf_size = PORTRAIT_W * PORTRAIT_H / 4 * 2;
    void *buf1 = heap_caps_malloc(buf_size, MALLOC_CAP_SPIRAM); assert(buf1);
    disp = lv_display_create(PORTRAIT_W, PORTRAIT_H);
    lv_display_set_buffers(disp, buf1, nullptr, buf_size, LV_DISPLAY_RENDER_MODE_PARTIAL);
    lv_display_set_user_data(disp, panel);
    lv_display_set_flush_cb(disp, flush_cb);
    init_i2c();
    // Touch
    esp_lcd_panel_io_handle_t tp_io_handle=nullptr; const esp_lcd_panel_io_i2c_config_t tp_io_config = { .dev_addr = ESP_LCD_TOUCH_IO_I2C_GT911_ADDRESS, .on_color_trans_done=NULL, .user_ctx=NULL, .control_phase_bytes=1, .dc_bit_offset=0, .lcd_cmd_bits=16, .lcd_param_bits=0, .flags = { .dc_low_on_data=0, .disable_control_phase=1 } }; const esp_lcd_touch_config_t tp_cfg = { .x_max=LCD_H_RES, .y_max=LCD_V_RES, .rst_gpio_num=TOUCH_PIN_RESET, .int_gpio_num=TOUCH_PIN_INT, .levels={ .reset=0, .interrupt=0 }, .flags={ .swap_xy=0, .mirror_x=0, .mirror_y=0 }, .process_coordinates=process_coords, .interrupt_callback=NULL}; esp_lcd_new_panel_io_i2c((esp_lcd_i2c_bus_handle_t)I2C_PORT, &tp_io_config, &tp_io_handle); esp_lcd_touch_new_i2c_gt911(tp_io_handle, &tp_cfg, &tp);
    indev = lv_indev_create(); lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER); lv_indev_set_user_data(indev, tp); lv_indev_set_read_cb(indev, touchpad_read); lv_indev_enable(indev, true); lv_indev_set_display(indev, disp);
    const esp_timer_create_args_t tick_args = { .callback = tick_cb, .arg = nullptr, .dispatch_method = ESP_TIMER_TASK, .name = "lvgl_tick", .skip_unhandled_events = true }; esp_timer_handle_t tick_timer; esp_timer_create(&tick_args, &tick_timer); esp_timer_start_periodic(tick_timer, LV_TICK_MS * 1000);
    gpio_set_level(LCD_PIN_BK_LIGHT, LCD_BK_LIGHT_ON_LEVEL);
}
