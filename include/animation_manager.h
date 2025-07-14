#ifndef ANIMATION_MANAGER_H
#define ANIMATION_MANAGER_H

#include <lvgl.h>

class AnimationManager {
private:
    static lv_anim_timeline_t* screenTransition;
    static lv_anim_timeline_t* sensorUpdate;
    
public:
    static void init();
    static void slideInFromRight(lv_obj_t* obj, uint32_t duration = 300);
    static void slideInFromLeft(lv_obj_t* obj, uint32_t duration = 300);
    static void slideOutToRight(lv_obj_t* obj, uint32_t duration = 300);
    static void slideOutToLeft(lv_obj_t* obj, uint32_t duration = 300);
    static void fadeIn(lv_obj_t* obj, uint32_t duration = 300);
    static void fadeOut(lv_obj_t* obj, uint32_t duration = 300);
    static void scaleIn(lv_obj_t* obj, uint32_t duration = 300);
    static void scaleOut(lv_obj_t* obj, uint32_t duration = 300);
    static void bounceIn(lv_obj_t* obj, uint32_t duration = 400);
    static void pulseEffect(lv_obj_t* obj, uint32_t duration = 1000);
    static void smoothScreenTransition(lv_obj_t* outObj, lv_obj_t* inObj);
    static void animateValueChange(lv_obj_t* label, float oldValue, float newValue, const char* format);
    static void createLoadingAnimation(lv_obj_t* obj);
    static void stopAllAnimations(lv_obj_t* obj);
    
    // Easing functions
    static int32_t easeInOutCubic(const lv_anim_t* a);
    static int32_t easeInOutQuart(const lv_anim_t* a);
    static int32_t easeOutBounce(const lv_anim_t* a);
    static int32_t easeInOutBack(const lv_anim_t* a);
};

#endif // ANIMATION_MANAGER_H
