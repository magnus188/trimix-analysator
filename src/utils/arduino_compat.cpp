#include "arduino_compat.h"
#include "main.h"

#ifdef NATIVE_BUILD
// Define the Serial object for native build
SerialClass Serial;

// Define SPIFFS object for native build
SPIFFSClass SPIFFS;

// Define TFT_eSPI object for native build
TFT_eSPI tft;

// Define WiFi object for native build
WiFiClass WiFi;
#endif
