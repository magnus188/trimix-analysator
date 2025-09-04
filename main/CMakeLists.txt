idf_component_register(
    SRCS 
        "lvgl9.c"          # Contains app_main()
        "trimix_screens.c"  # UI screens
        "sensor_interface.c" # Mock sensor implementation
        "lvgl_demo_ui.c"    # LVGL demo animation
        "esp_logo.c"        # LVGL image asset
        "esp_text.c"        # LVGL image asset
    INCLUDE_DIRS "."
    REQUIRES 
        esp_lcd
        esp_timer
        driver
        lvgl
        esp_lcd_touch_gt911
)