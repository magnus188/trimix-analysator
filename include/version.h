#ifndef VERSION_H
#define VERSION_H

#define FIRMWARE_VERSION "1.0.0"
#define BUILD_DATE __DATE__
#define BUILD_TIME __TIME__

// Version history
#define VERSION_HISTORY \
    "v1.0.0 - Initial release\n" \
    "- Full LVGL implementation\n" \
    "- Persistent storage with SPIFFS\n" \
    "- WiFi settings and OTA updates\n" \
    "- Safety settings with persistent storage\n" \
    "- Analysis history with export functionality\n" \
    "- Premium UI with animations\n" \
    "- Optimized for ESP32 performance\n"

#endif // VERSION_H
