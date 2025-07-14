#ifndef THEME_MANAGER_H
#define THEME_MANAGER_H

#include <lvgl.h>

class ThemeManager {
private:
    static lv_theme_t* currentTheme;
    static lv_style_t cardStyle;
    static lv_style_t buttonStyle;
    static lv_style_t labelStyle;
    static lv_style_t navBarStyle;
    static lv_style_t sensorCardStyle;
    static lv_style_t warningStyle;
    static lv_style_t dangerStyle;
    static lv_style_t successStyle;
    
public:
    // Theme colors
    static const lv_color_t PRIMARY_COLOR;
    static const lv_color_t SECONDARY_COLOR;
    static const lv_color_t BACKGROUND_COLOR;
    static const lv_color_t CARD_COLOR;
    static const lv_color_t TEXT_COLOR;
    static const lv_color_t SUCCESS_COLOR;
    static const lv_color_t WARNING_COLOR;
    static const lv_color_t DANGER_COLOR;
    static const lv_color_t ACCENT_COLOR;
    
    static void init();
    static void applyCardStyle(lv_obj_t* obj);
    static void applyButtonStyle(lv_obj_t* obj);
    static void applyLabelStyle(lv_obj_t* obj);
    static void applyNavBarStyle(lv_obj_t* obj);
    static void applySensorCardStyle(lv_obj_t* obj);
    static void applyWarningStyle(lv_obj_t* obj);
    static void applyDangerStyle(lv_obj_t* obj);
    static void applySuccessStyle(lv_obj_t* obj);
    
    static void createSmoothTransition(lv_obj_t* obj, lv_style_prop_t prop, 
                                     lv_style_value_t start, lv_style_value_t end);
    static void animateColorChange(lv_obj_t* obj, lv_color_t newColor);
    static void addHoverEffect(lv_obj_t* obj);
    static void addPressEffect(lv_obj_t* obj);
};

#endif // THEME_MANAGER_H
