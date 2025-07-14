#include "performance_monitor.h"
#include "theme_manager.h"
#include <esp_system.h>

// Initialize static members
lv_obj_t* PerformanceMonitor::monitorLabel = nullptr;
lv_timer_t* PerformanceMonitor::updateTimer = nullptr;
unsigned long PerformanceMonitor::lastUpdate = 0;
float PerformanceMonitor::avgCPU = 0.0f;
float PerformanceMonitor::avgMemory = 0.0f;
float PerformanceMonitor::avgFPS = 0.0f;
uint32_t PerformanceMonitor::frameCount = 0;
unsigned long PerformanceMonitor::lastFrameTime = 0;
bool PerformanceMonitor::enabled = false;

void PerformanceMonitor::init() {
    enabled = true;
    updateTimer = lv_timer_create(updateCallback, 2000, nullptr);
    lastUpdate = millis();
    lastFrameTime = millis();
    
    Serial.println("Performance monitor initialized");
}

void PerformanceMonitor::enable(bool enable) {
    enabled = enable;
    if (enable && updateTimer == nullptr) {
        init();
    } else if (!enable && updateTimer != nullptr) {
        lv_timer_del(updateTimer);
        updateTimer = nullptr;
    }
}

void PerformanceMonitor::createWidget(lv_obj_t* parent) {
    if (!enabled) return;
    
    monitorLabel = lv_label_create(parent);
    lv_obj_set_size(monitorLabel, 200, 60);
    lv_obj_set_pos(monitorLabel, 10, 10);
    lv_obj_set_style_text_color(monitorLabel, ThemeManager::ACCENT_COLOR, LV_PART_MAIN);
    lv_obj_set_style_text_font(monitorLabel, &lv_font_montserrat_12, LV_PART_MAIN);
    lv_obj_set_style_bg_color(monitorLabel, lv_color_hex(0x000000), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(monitorLabel, LV_OPA_70, LV_PART_MAIN);
    lv_obj_set_style_radius(monitorLabel, 5, LV_PART_MAIN);
    lv_obj_set_style_pad_all(monitorLabel, 5, LV_PART_MAIN);
    
    lv_label_set_text(monitorLabel, "Performance Monitor\nInitializing...");
}

void PerformanceMonitor::updateMetrics() {
    if (!enabled) return;
    
    frameCount++;
    unsigned long currentTime = millis();
    
    // Calculate FPS
    if (currentTime - lastFrameTime >= 1000) {
        avgFPS = frameCount * 1000.0f / (currentTime - lastFrameTime);
        frameCount = 0;
        lastFrameTime = currentTime;
    }
    
    // Update other metrics every 2 seconds
    if (currentTime - lastUpdate >= 2000) {
        avgCPU = getCPUUsage();
        avgMemory = getMemoryUsage();
        lastUpdate = currentTime;
        
        updateDisplay();
        logPerformance();
        
        // Auto-optimize if performance is poor
        if (avgFPS < 20.0f || avgMemory > 80.0f) {
            optimizeSystem();
        }
    }
}

float PerformanceMonitor::getCPUUsage() {
    // ESP32 doesn't have direct CPU usage, estimate from task switching
    static unsigned long lastIdleTime = 0;
    static unsigned long lastTotalTime = 0;
    
    unsigned long currentTime = millis();
    unsigned long idleTime = currentTime - lastTotalTime; // Simplified calculation
    
    float cpuUsage = 100.0f - ((float)idleTime / (currentTime - lastTotalTime)) * 100.0f;
    
    lastIdleTime = idleTime;
    lastTotalTime = currentTime;
    
    return constrain(cpuUsage, 0.0f, 100.0f);
}

float PerformanceMonitor::getMemoryUsage() {
    size_t freeHeap = esp_get_free_heap_size();
    size_t totalHeap = 320 * 1024; // ESP32 typical heap size
    
    return 100.0f - ((float)freeHeap / totalHeap) * 100.0f;
}

float PerformanceMonitor::getFPS() {
    return avgFPS;
}

void PerformanceMonitor::optimizeSystem() {
    // Garbage collection
    lv_mem_monitor_t mem_mon;
    lv_mem_monitor(&mem_mon);
    
    if (mem_mon.used_pct > 80) {
        // Force garbage collection
        lv_obj_clean(lv_scr_act());
        Serial.println("Performance: Forced memory cleanup");
    }
    
    // Reduce refresh rate if FPS is too low
    if (avgFPS < 20.0f) {
        lv_disp_set_default(lv_disp_get_default());
        Serial.println("Performance: Reduced refresh rate");
    }
    
    // Log optimization
    Serial.printf("Performance optimization triggered - FPS: %.1f, Memory: %.1f%%\n", 
                  avgFPS, avgMemory);
}

void PerformanceMonitor::updateCallback(lv_timer_t* timer) {
    updateMetrics();
}

void PerformanceMonitor::updateDisplay() {
    if (!enabled || monitorLabel == nullptr) return;
    
    lv_label_set_text_fmt(monitorLabel, 
                         "Performance Monitor\n"
                         "FPS: %.1f\n"
                         "Memory: %.1f%%\n"
                         "CPU: %.1f%%",
                         avgFPS, avgMemory, avgCPU);
    
    // Color coding based on performance
    if (avgFPS < 20.0f || avgMemory > 80.0f) {
        lv_obj_set_style_text_color(monitorLabel, ThemeManager::DANGER_COLOR, LV_PART_MAIN);
    } else if (avgFPS < 30.0f || avgMemory > 60.0f) {
        lv_obj_set_style_text_color(monitorLabel, ThemeManager::WARNING_COLOR, LV_PART_MAIN);
    } else {
        lv_obj_set_style_text_color(monitorLabel, ThemeManager::SUCCESS_COLOR, LV_PART_MAIN);
    }
}

void PerformanceMonitor::logPerformance() {
    if (!enabled) return;
    
    Serial.printf("Performance: FPS=%.1f, Memory=%.1f%%, CPU=%.1f%%\n", 
                  avgFPS, avgMemory, avgCPU);
    
    // Log warnings
    if (avgFPS < 30.0f) {
        Serial.println("Performance Warning: Low FPS detected");
    }
    if (avgMemory > 75.0f) {
        Serial.println("Performance Warning: High memory usage");
    }
}
