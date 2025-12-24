idf_component_register(
    SRCS
        "main.cpp"                           # app_main
        "version.cpp"                        # version information
        "sensors/sensor_interface.cpp"       # sensors (mock)
        "services/wifi_service.cpp"          # WiFi management
        "services/battery_service.cpp"       # Battery monitoring
        "services/ota_service.cpp"           # OTA update service
        "ui/screens/screen_manager.cpp"      # screen manager
        "ui/screens/home/home_screen.cpp"    # home screen (main menu)
        "ui/screens/settings/settings_screen.cpp"  # settings screen
        "ui/screens/settings/wifi_screen.cpp"      # WiFi settings screen
        "ui/screens/settings/update_screen.cpp"    # software update screen
        "ui/screens/dive_planner/dive_planner_screen.cpp"  # dive planner screen
        "ui/screens/dive_planner/gas_calculator.cpp"       # gas calculations
        "ui/styles/styles.cpp"               # global styles
        "ui/components/navbar.cpp"           # reusable navbar
        "ui/components/status_icons.cpp"     # status bar icons (WiFi/battery)
        "ui/lvgl/lvgl_port.cpp"              # lvgl port/hw layer
        # Custom fonts
        "ui/fonts/custom_font_normal_16.c"
        "ui/fonts/custom_font_normal_20.c"
        "ui/fonts/custom_font_normal_24.c"
        "ui/fonts/custom_font_bold_16.c"
        "ui/fonts/custom_font_bold_20.c"
        "ui/fonts/custom_font_bold_24.c"
        "ui/fonts/custom_font_light_14.c"
        "ui/fonts/custom_font_light_16.c"
    INCLUDE_DIRS
        .
        ui/screens
        ui/lvgl
        ui/fonts
        ui/styles
        ui/components
        ui/config
        sensors
        services
        board
    REQUIRES
        esp_lcd
        esp_timer
        driver
        lvgl
        esp_lcd_touch_gt911
        esp_wifi
        nvs_flash
        esp_netif
        esp_http_client
        esp_https_ota
        app_update
        json
        esp_event
        mbedtls
)

# Ensure C++ standard (ESP-IDF sets default; enforce at least C++17 for future needs)
set_target_properties(${COMPONENT_LIB} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED YES)