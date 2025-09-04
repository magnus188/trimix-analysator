idf_component_register(
    SRCS
        "main.cpp"                      # app_main
        "sensors/sensor_interface.cpp"  # sensors (mock)
        "ui/screens/trimix_screens.cpp" # screen manager
        "ui/lvgl/lvgl_port.cpp"         # lvgl port/hw layer
    INCLUDE_DIRS
        .
        ui/screens
        ui/lvgl
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