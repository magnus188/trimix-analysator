#include "animation_manager.h"
#include <Arduino.h>

// Initialize static members
lv_anim_timeline_t* AnimationManager::screenTransition = nullptr;
lv_anim_timeline_t* AnimationManager::sensorUpdate = nullptr;

void AnimationManager::init() {
    // Initialize animation timelines
    screenTransition = lv_anim_timeline_create();
    sensorUpdate = lv_anim_timeline_create();
    
    Serial.println("Animation manager initialized");
}

void AnimationManager::slideInFromRight(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_x((lv_obj_t*)var, val);
    });
    lv_anim_set_values(&a, LV_HOR_RES, 0);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_out);
    lv_anim_start(&a);
}

void AnimationManager::slideInFromLeft(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_x((lv_obj_t*)var, val);
    });
    lv_anim_set_values(&a, -LV_HOR_RES, 0);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_out);
    lv_anim_start(&a);
}

void AnimationManager::slideOutToRight(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_x((lv_obj_t*)var, val);
    });
    lv_anim_set_values(&a, 0, LV_HOR_RES);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in);
    lv_anim_start(&a);
}

void AnimationManager::slideOutToLeft(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_x((lv_obj_t*)var, val);
    });
    lv_anim_set_values(&a, 0, -LV_HOR_RES);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in);
    lv_anim_start(&a);
}

void AnimationManager::fadeIn(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_opa((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, LV_OPA_TRANSP, LV_OPA_COVER);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in_out);
    lv_anim_start(&a);
}

void AnimationManager::fadeOut(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_opa((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, LV_OPA_COVER, LV_OPA_TRANSP);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in_out);
    lv_anim_start(&a);
}

void AnimationManager::scaleIn(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_transform_zoom((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, 0, 256);
    lv_anim_set_path_cb(&a, easeOutBounce);
    lv_anim_start(&a);
}

void AnimationManager::scaleOut(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_transform_zoom((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, 256, 0);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in);
    lv_anim_start(&a);
}

void AnimationManager::bounceIn(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_transform_zoom((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, 0, 256);
    lv_anim_set_path_cb(&a, easeOutBounce);
    lv_anim_start(&a);
}

void AnimationManager::pulseEffect(lv_obj_t* obj, uint32_t duration) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, duration);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_transform_zoom((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, 256, 280);
    lv_anim_set_path_cb(&a, lv_anim_path_ease_in_out);
    lv_anim_set_playback_time(&a, duration);
    lv_anim_set_repeat_count(&a, LV_ANIM_REPEAT_INFINITE);
    lv_anim_start(&a);
}

void AnimationManager::smoothScreenTransition(lv_obj_t* outObj, lv_obj_t* inObj) {
    // Fade out current screen
    fadeOut(outObj, 200);
    
    // Slide in new screen after a short delay
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, inObj);
    lv_anim_set_time(&a, 0);
    lv_anim_set_delay(&a, 100);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        slideInFromRight((lv_obj_t*)var, 250);
    });
    lv_anim_set_values(&a, 0, 1);
    lv_anim_start(&a);
}

void AnimationManager::animateValueChange(lv_obj_t* label, float oldValue, float newValue, const char* format) {
    typedef struct {
        lv_obj_t* label;
        float startValue;
        float endValue;
        char format[32];
    } value_anim_t;
    
    value_anim_t* anim_data = (value_anim_t*)malloc(sizeof(value_anim_t));
    anim_data->label = label;
    anim_data->startValue = oldValue;
    anim_data->endValue = newValue;
    strncpy(anim_data->format, format, sizeof(anim_data->format) - 1);
    
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, anim_data);
    lv_anim_set_time(&a, 500);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        value_anim_t* data = (value_anim_t*)var;
        float currentValue = data->startValue + (data->endValue - data->startValue) * (val / 100.0f);
        lv_label_set_text_fmt(data->label, data->format, currentValue);
    });
    lv_anim_set_values(&a, 0, 100);
    lv_anim_set_path_cb(&a, easeInOutCubic);
    lv_anim_set_deleted_cb(&a, [](lv_anim_t* a) {
        free(a->var);
    });
    lv_anim_start(&a);
}

void AnimationManager::createLoadingAnimation(lv_obj_t* obj) {
    lv_anim_t a;
    lv_anim_init(&a);
    lv_anim_set_var(&a, obj);
    lv_anim_set_time(&a, 1000);
    lv_anim_set_exec_cb(&a, [](void* var, int32_t val) {
        lv_obj_set_style_transform_angle((lv_obj_t*)var, val, LV_PART_MAIN);
    });
    lv_anim_set_values(&a, 0, 3600);
    lv_anim_set_repeat_count(&a, LV_ANIM_REPEAT_INFINITE);
    lv_anim_set_path_cb(&a, lv_anim_path_linear);
    lv_anim_start(&a);
}

void AnimationManager::stopAllAnimations(lv_obj_t* obj) {
    lv_anim_del(obj, NULL);
}

// Custom easing functions
int32_t AnimationManager::easeInOutCubic(const lv_anim_t* a) {
    int32_t t = lv_anim_path_ease_in_out(a);
    return t * t * t / (LV_ANIM_RESOLUTION * LV_ANIM_RESOLUTION);
}

int32_t AnimationManager::easeInOutQuart(const lv_anim_t* a) {
    int32_t t = lv_anim_path_ease_in_out(a);
    return t * t * t * t / (LV_ANIM_RESOLUTION * LV_ANIM_RESOLUTION * LV_ANIM_RESOLUTION);
}

int32_t AnimationManager::easeOutBounce(const lv_anim_t* a) {
    int32_t t = lv_anim_get_playtime(a);
    int32_t total = a->time;
    float progress = (float)t / total;
    
    if (progress < 0.363636f) {
        progress = 7.5625f * progress * progress;
    } else if (progress < 0.727272f) {
        progress = 7.5625f * (progress - 0.545454f) * (progress - 0.545454f) + 0.75f;
    } else if (progress < 0.909090f) {
        progress = 7.5625f * (progress - 0.818181f) * (progress - 0.818181f) + 0.9375f;
    } else {
        progress = 7.5625f * (progress - 0.954545f) * (progress - 0.954545f) + 0.984375f;
    }
    
    return (int32_t)(progress * LV_ANIM_RESOLUTION);
}

int32_t AnimationManager::easeInOutBack(const lv_anim_t* a) {
    int32_t t = lv_anim_get_playtime(a);
    int32_t total = a->time;
    float progress = (float)t / total;
    
    const float c1 = 1.70158f;
    const float c2 = c1 * 1.525f;
    
    if (progress < 0.5f) {
        progress = (pow(2 * progress, 2) * ((c2 + 1) * 2 * progress - c2)) / 2;
    } else {
        progress = (pow(2 * progress - 2, 2) * ((c2 + 1) * (progress * 2 - 2) + c2) + 2) / 2;
    }
    
    return (int32_t)(progress * LV_ANIM_RESOLUTION);
}
