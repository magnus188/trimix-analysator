# WiFi settings component sources
set(WIFI_SOURCES
    wifi/wifi_settings.cpp
    wifi/wifi_manager.cpp
)

# Add to parent component sources
list(APPEND COMPONENT_SRCS ${WIFI_SOURCES})
