#ifndef PERFORMANCE_MONITOR_H
#define PERFORMANCE_MONITOR_H

#include <lvgl.h>
#include <Arduino.h>

class PerformanceMonitor {
private:
    static lv_obj_t* monitorLabel;
    static lv_timer_t* updateTimer;
    static unsigned long lastUpdate;
    static float avgCPU;
    static float avgMemory;
    static float avgFPS;
    static uint32_t frameCount;
    static unsigned long lastFrameTime;
    static bool enabled;
    
public:
    static void init();
    static void enable(bool enable = true);
    static void createWidget(lv_obj_t* parent);
    static void updateMetrics();
    static void logPerformance();
    static float getCPUUsage();
    static float getMemoryUsage();
    static float getFPS();
    static void optimizeSystem();
    
private:
    static void updateCallback(lv_timer_t* timer);
    static void updateDisplay();
};

#endif // PERFORMANCE_MONITOR_H
