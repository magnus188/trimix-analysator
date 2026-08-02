idf_component_register(
    SRCS
        "main.cpp"                           # app_main
        "version.cpp"                        # version information
        "analysis/analysis_calculator.cpp"   # analysis calculations
        "sensors/sensor_interface.cpp"       # sensors (mock)
        "services/analysis_history.cpp"      # captured analysis history
        "services/cylinder_profiles.cpp"     # cylinder profile storage
        "services/mix_label_service.cpp"     # export-ready mix labels
        "services/wifi_service.cpp"          # WiFi management
        "services/battery_service.cpp"       # Battery monitoring
        "services/ota_service.cpp"           # OTA update service
        "services/settings_service.cpp"      # Settings management
        "services/backlight_service.cpp"     # Backlight PWM control
        "ui/screens/screen_manager.cpp"      # screen manager
        "ui/screens/home/home_screen.cpp"    # home screen (main menu)
        "ui/screens/analyse/analyse_screen.cpp"  # gas analysis screen
        "ui/screens/history/history_screen.cpp"  # captured analysis history screen
        "ui/screens/cylinders/cylinders_screen.cpp"  # cylinder profile screen
        "ui/screens/settings/settings_screen.cpp"  # settings screen
        "ui/screens/settings/wifi_screen.cpp"      # WiFi settings screen
        "ui/screens/settings/update_screen.cpp"    # software update screen
        "ui/screens/settings/device_screen.cpp"    # device settings screen
        "ui/screens/settings/calibrate_screen.cpp" # sensor calibration screen
        "ui/screens/settings/safety_screen.cpp"    # analysis advisory limits screen
        "ui/screens/dive_planner/dive_planner_screen.cpp"  # dive planner screen
        "ui/screens/dive_planner/gas_calculator.cpp"       # gas calculations
        "ui/styles/styles.cpp"               # global styles
        "ui/components/navbar.cpp"           # reusable navbar
        "ui/components/status_icons.cpp"     # status bar icons (WiFi/battery)
        "ui/lvgl/lvgl_port.cpp"              # lvgl port/hw layer
        # Custom fonts
        "ui/fonts/custom_font_normal_16.c"
        "ui/fonts/custom_font_bold_20.c"
        "ui/fonts/custom_font_bold_24.c"
    INCLUDE_DIRS
        .
        ui/screens
        ui/lvgl
        ui/fonts
        ui/styles
        ui/components
        ui/config
        analysis
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
