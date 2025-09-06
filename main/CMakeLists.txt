idf_component_register(
    SRCS
        "main.cpp"                           # app_main
        "sensors/sensor_interface.cpp"       # sensors (mock)
        "ui/screens/screen_manager.cpp"      # main screen manager
        "ui/screens/ui_common.cpp"           # shared UI components
        "ui/screens/screen_home.cpp"         # home screen
        "ui/screens/screen_analyze.cpp"      # analyze screen
        "ui/screens/screen_dive_planner.cpp" # dive planner screen
        "ui/screens/screen_history.cpp"      # history screen  
        "ui/screens/screen_settings.cpp"     # settings screen
        "ui/screens/screen_calibrate_o2.cpp" # calibration screen
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
        sensors
        board
    REQUIRES
        esp_lcd
        esp_timer
        driver
        lvgl
        esp_lcd_touch_gt911
)

# Ensure C++ standard (ESP-IDF sets default; enforce at least C++17 for future needs)
set_target_properties(${COMPONENT_LIB} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED YES)