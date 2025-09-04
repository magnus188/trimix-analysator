idf_component_register(
    SRCS 
        "main.c"
        "sensor_interface.c" 
        "trimix_screens.c"
    INCLUDE_DIRS "."
    REQUIRES 
        esp_lcd
        esp_timer
        driver
        lvgl
        esp_lcd_touch_gt911
)