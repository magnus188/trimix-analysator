#pragma once

//
// Hardware configuration for ESP32-8048S043 board (Trimix Analyzer)
//

// Display resolution (portrait mode)
#define LCD_H_RES 480
#define LCD_V_RES 800

// Touch screen calibration (portrait orientation)
#define TOUCH_H_RES_MIN 0
#define TOUCH_H_RES_MAX 269
#define TOUCH_V_RES_MIN 0
#define TOUCH_V_RES_MAX 477

// LCD timing
#define LCD_PIXEL_CLOCK_HZ (18 * 1000 * 1000)

// Backlight control
#define LCD_BK_LIGHT_ON_LEVEL 1
#define LCD_BK_LIGHT_OFF_LEVEL !LCD_BK_LIGHT_ON_LEVEL
#define LCD_PIN_BK_LIGHT (gpio_num_t) GPIO_NUM_2

// LCD parallel interface pins
#define LCD_PIN_HSYNC   (gpio_num_t) GPIO_NUM_39
#define LCD_PIN_VSYNC   (gpio_num_t) GPIO_NUM_41
#define LCD_PIN_DE      (gpio_num_t) GPIO_NUM_40
#define LCD_PIN_PCLK    (gpio_num_t) GPIO_NUM_42
#define LCD_PIN_DATA0   (gpio_num_t) GPIO_NUM_8
#define LCD_PIN_DATA1   (gpio_num_t) GPIO_NUM_3
#define LCD_PIN_DATA2   (gpio_num_t) GPIO_NUM_46
#define LCD_PIN_DATA3   (gpio_num_t) GPIO_NUM_9
#define LCD_PIN_DATA4   (gpio_num_t) GPIO_NUM_1
#define LCD_PIN_DATA5   (gpio_num_t) GPIO_NUM_5
#define LCD_PIN_DATA6   (gpio_num_t) GPIO_NUM_6
#define LCD_PIN_DATA7   (gpio_num_t) GPIO_NUM_7
#define LCD_PIN_DATA8   (gpio_num_t) GPIO_NUM_15
#define LCD_PIN_DATA9   (gpio_num_t) GPIO_NUM_16
#define LCD_PIN_DATA10  (gpio_num_t) GPIO_NUM_4
#define LCD_PIN_DATA11  (gpio_num_t) GPIO_NUM_45
#define LCD_PIN_DATA12  (gpio_num_t) GPIO_NUM_48
#define LCD_PIN_DATA13  (gpio_num_t) GPIO_NUM_47
#define LCD_PIN_DATA14  (gpio_num_t) GPIO_NUM_21
#define LCD_PIN_DATA15  (gpio_num_t) GPIO_NUM_14
#define LCD_PIN_DISP_EN (gpio_num_t) GPIO_NUM_NC

// Touch screen pins (GT911)
#define TOUCH_PIN_RESET (gpio_num_t) GPIO_NUM_38
#define TOUCH_PIN_SCL   (gpio_num_t) GPIO_NUM_20
#define TOUCH_PIN_SDA   (gpio_num_t) GPIO_NUM_19
#define TOUCH_PIN_INT   (gpio_num_t) GPIO_NUM_18
#define TOUCH_FREQ_HZ   (400000)

// Sensor I2C pins (separate from touch I2C)
#define SENSOR_I2C_PORT I2C_NUM_1
#define SENSOR_PIN_SDA  (gpio_num_t) GPIO_NUM_11
#define SENSOR_PIN_SCL  (gpio_num_t) GPIO_NUM_12
#define SENSOR_FREQ_HZ  (100000)

// ADC pins for analog sensors
#define O2_SENSOR_ADC_CHANNEL ADC1_CHANNEL_0  // GPIO_NUM_36
#define CO2_SENSOR_ADC_CHANNEL ADC1_CHANNEL_3 // GPIO_NUM_37