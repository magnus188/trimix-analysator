// LVGL port abstraction (initialization of display, input, tick) - edit with care.
#pragma once
#include <lvgl.h>
#ifdef __cplusplus
extern "C" {
#endif
void lvgl_port_init(void); // initializes display, input devices, timers
#ifdef __cplusplus
}
#endif
