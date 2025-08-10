/*
 * TFT_eSPI User Setup for ESP32-8048S043
 * 4.3" 800x480 IPS Touch LCD Display Module with ESP32-S3
 * Updated with correct pin assignments for ESP32-8048S043
 */

#ifndef USER_SETUP_H
#define USER_SETUP_H

// Driver selection for RGB LCD (parallel interface)
#define ESP32_PARALLEL

// Display resolution
#define TFT_WIDTH  800
#define TFT_HEIGHT 480

// ESP32-S3 RGB LCD pin configuration for ESP32-8048S043
// Data pins
#define TFT_D0   8   // Data bit 0
#define TFT_D1   3   // Data bit 1  
#define TFT_D2   46  // Data bit 2
#define TFT_D3   9   // Data bit 3
#define TFT_D4   1   // Data bit 4
#define TFT_D5   5   // Data bit 5
#define TFT_D6   6   // Data bit 6
#define TFT_D7   7   // Data bit 7
#define TFT_D8   15  // Data bit 8
#define TFT_D9   16  // Data bit 9
#define TFT_D10  4   // Data bit 10
#define TFT_D11  45  // Data bit 11
#define TFT_D12  48  // Data bit 12
#define TFT_D13  47  // Data bit 13
#define TFT_D14  21  // Data bit 14
#define TFT_D15  14  // Data bit 15

// Control pins
#define TFT_WR   18  // Write strobe
#define TFT_RD   -1  // Read strobe (not used)
#define TFT_CS   -1  // Chip select (not used for parallel)
#define TFT_DC   -1  // Data/Command (not used for RGB)
#define TFT_RST  -1  // Reset (connected to EN)
#define TFT_BL   2   // Backlight control

// RGB LCD control pins
#define TFT_DE   40  // Data Enable
#define TFT_VSYNC 41 // Vertical Sync
#define TFT_HSYNC 39 // Horizontal Sync
#define TFT_PCLK  42 // Pixel Clock

// Touch controller pins (I2C)
#define TOUCH_SDA 19
#define TOUCH_SCL 20
#define TOUCH_INT 40
#define TOUCH_RST 38

// RGB interface settings
#define TFT_RGB_ORDER TFT_RGB

// Parallel interface timing
#define TFT_WR_DELAY 0
#define TFT_RD_DELAY 0

#endif // USER_SETUP_H