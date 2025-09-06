idf_component_register(
    SRCS
        "main.cpp"                           # app_main
        "version.cpp"                        # version information
        "sensors/sensor_interface.cpp"       # sensors (mock)
        "ui/screens/screen_manager.cpp"      # main screen manager
        "ui/components/ui_components.cpp"    # reusable UI components
        "ui/screens/home/home.cpp"           # home screen
        "ui/screens/analyze/analyze.cpp"     # analyze screen
        "ui/screens/dive_planner/dive_planner.cpp" # dive planner screen
        "ui/screens/history/history.cpp"     # history screen  
        "ui/screens/settings/settings.cpp"   # settings screen
        "ui/screens/calibrate_o2/calibrate_o2.cpp" # calibration screen
        "ui/screens/wifi/wifi_settings.cpp"  # wifi settings screen
        "ui/screens/wifi/wifi_manager.cpp"   # wifi manager
        "ui/screens/software_update/software_update.cpp" # software update screen
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
        ui/components
        ui/lvgl
        ui/fonts
        sensors
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
)

# Ensure C++ standard (ESP-IDF sets default; enforce at least C++17 for future needs)
set_target_properties(${COMPONENT_LIB} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED YES)