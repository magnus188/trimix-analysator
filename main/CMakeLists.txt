idf_component_register(
    SRCS 
        "main.c"          # Contains app_main()
        "trimix_screens.c"  # UI screens
        "sensor_interface.c" # Mock sensor implementation
    INCLUDE_DIRS "."
    REQUIRES 
        esp_lcd
        esp_timer
        driver
        lvgl
        esp_lcd_touch_gt911
)