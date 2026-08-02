cmake_minimum_required(VERSION 3.20)

project(trimix_host_tools LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(TRIMIX_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")

find_package(PkgConfig REQUIRED)
pkg_check_modules(SDL2 REQUIRED sdl2)

set(LV_BUILD_CONF_PATH "${CMAKE_CURRENT_LIST_DIR}/lv_conf/lv_conf.h" CACHE PATH "" FORCE)
set(CONFIG_LV_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(CONFIG_LV_BUILD_DEMOS OFF CACHE BOOL "" FORCE)
set(CONFIG_LV_USE_THORVG_INTERNAL OFF CACHE BOOL "" FORCE)

set_source_files_properties(
    "${TRIMIX_ROOT}/managed_components/lvgl__lvgl/src/draw/sw/blend/helium/lv_blend_helium.S"
    "${TRIMIX_ROOT}/managed_components/lvgl__lvgl/src/draw/sw/blend/neon/lv_blend_neon.S"
    PROPERTIES HEADER_FILE_ONLY TRUE
)

add_subdirectory("${TRIMIX_ROOT}/managed_components/lvgl__lvgl" "${CMAKE_BINARY_DIR}/lvgl")
get_target_property(LVGL_SOURCES lvgl SOURCES)
list(FILTER LVGL_SOURCES EXCLUDE REGEX ".*lv_blend_(helium|neon)\\.S$")
set_target_properties(lvgl PROPERTIES SOURCES "${LVGL_SOURCES}")
target_include_directories(lvgl PUBLIC ${SDL2_INCLUDE_DIRS})
target_link_directories(lvgl PUBLIC ${SDL2_LIBRARY_DIRS})
target_compile_options(lvgl PUBLIC ${SDL2_CFLAGS_OTHER})
target_link_libraries(lvgl PUBLIC ${SDL2_LIBRARIES})

set(TRIMIX_COMMON_INCLUDE_DIRS
    "${TRIMIX_ROOT}/main"
    "${TRIMIX_ROOT}/main/ui/screens"
    "${TRIMIX_ROOT}/main/ui/lvgl"
    "${TRIMIX_ROOT}/main/ui/fonts"
    "${TRIMIX_ROOT}/main/ui/styles"
    "${TRIMIX_ROOT}/main/ui/components"
    "${TRIMIX_ROOT}/main/ui/config"
    "${TRIMIX_ROOT}/main/analysis"
    "${TRIMIX_ROOT}/main/sensors"
    "${TRIMIX_ROOT}/main/services"
    "${TRIMIX_ROOT}/main/board"
)

set(TRIMIX_UI_SOURCES
    "${TRIMIX_ROOT}/main/version.cpp"
    "${TRIMIX_ROOT}/main/analysis/analysis_calculator.cpp"
    "${TRIMIX_ROOT}/main/sensors/sensor_interface.cpp"
    "${TRIMIX_ROOT}/main/services/analysis_history.cpp"
    "${TRIMIX_ROOT}/main/services/cylinder_profiles.cpp"
    "${TRIMIX_ROOT}/main/services/mix_label_service.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/screen_manager.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/home/home_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/analyse/analyse_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/history/history_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/cylinders/cylinders_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/settings_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/wifi_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/update_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/device_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/calibrate_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/settings/safety_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/dive_planner/dive_planner_screen.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/dive_planner/gas_calculator.cpp"
    "${TRIMIX_ROOT}/main/ui/styles/styles.cpp"
    "${TRIMIX_ROOT}/main/ui/components/navbar.cpp"
    "${TRIMIX_ROOT}/main/ui/components/status_icons.cpp"
    "${TRIMIX_ROOT}/main/ui/fonts/custom_font_normal_16.c"
    "${TRIMIX_ROOT}/main/ui/fonts/custom_font_bold_20.c"
    "${TRIMIX_ROOT}/main/ui/fonts/custom_font_bold_24.c"
    "${CMAKE_CURRENT_LIST_DIR}/mocks/settings_service_mock.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mocks/wifi_service_mock.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mocks/battery_service_mock.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mocks/backlight_service_mock.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/mocks/ota_service_mock.cpp"
)

add_library(trimix_host_app STATIC ${TRIMIX_UI_SOURCES})
target_compile_definitions(trimix_host_app PUBLIC TRIMIX_SIMULATOR=1)
target_include_directories(trimix_host_app PUBLIC
    "${CMAKE_CURRENT_LIST_DIR}/stubs"
    ${TRIMIX_COMMON_INCLUDE_DIRS}
)
target_link_libraries(trimix_host_app PUBLIC lvgl)

add_executable(trimix_simulator "${CMAKE_CURRENT_LIST_DIR}/src/main.cpp")
target_link_libraries(trimix_simulator PRIVATE trimix_host_app)

enable_testing()

add_executable(test_gas_calculator
    "${CMAKE_CURRENT_LIST_DIR}/tests/test_gas_calculator.cpp"
    "${TRIMIX_ROOT}/main/ui/screens/dive_planner/gas_calculator.cpp"
)
target_include_directories(test_gas_calculator PRIVATE
    "${TRIMIX_ROOT}/main/ui/screens/dive_planner"
)
add_test(NAME gas_calculator COMMAND test_gas_calculator)

add_executable(test_analysis_calculator
    "${TRIMIX_ROOT}/tests/test_analysis_calculator.cpp"
    "${TRIMIX_ROOT}/main/analysis/analysis_calculator.cpp"
)
target_include_directories(test_analysis_calculator PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/stubs"
    ${TRIMIX_COMMON_INCLUDE_DIRS}
)
add_test(NAME analysis_calculator COMMAND test_analysis_calculator)

add_executable(test_sensor_interface
    "${TRIMIX_ROOT}/tests/test_sensor_interface.cpp"
    "${TRIMIX_ROOT}/main/sensors/sensor_interface.cpp"
)
target_include_directories(test_sensor_interface PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/stubs"
    ${TRIMIX_COMMON_INCLUDE_DIRS}
)
add_test(NAME sensor_interface COMMAND test_sensor_interface)

add_executable(test_analysis_history
    "${TRIMIX_ROOT}/tests/test_analysis_history.cpp"
    "${TRIMIX_ROOT}/main/services/analysis_history.cpp"
)
target_compile_definitions(test_analysis_history PRIVATE TRIMIX_SIMULATOR=1)
target_include_directories(test_analysis_history PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/stubs"
    ${TRIMIX_COMMON_INCLUDE_DIRS}
)
add_test(NAME analysis_history COMMAND test_analysis_history)

add_executable(test_cylinder_profiles
    "${TRIMIX_ROOT}/tests/test_cylinder_profiles.cpp"
    "${TRIMIX_ROOT}/main/services/cylinder_profiles.cpp"
    "${TRIMIX_ROOT}/main/services/mix_label_service.cpp"
    "${TRIMIX_ROOT}/main/analysis/analysis_calculator.cpp"
)
target_compile_definitions(test_cylinder_profiles PRIVATE TRIMIX_SIMULATOR=1)
target_include_directories(test_cylinder_profiles PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/stubs"
    ${TRIMIX_COMMON_INCLUDE_DIRS}
)
add_test(NAME cylinder_profiles COMMAND test_cylinder_profiles)

add_executable(test_ui_smoke "${CMAKE_CURRENT_LIST_DIR}/tests/test_ui_smoke.cpp")
target_link_libraries(test_ui_smoke PRIVATE trimix_host_app)
add_test(NAME ui_smoke COMMAND test_ui_smoke)
