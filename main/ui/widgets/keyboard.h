#pragma once
#include <lvgl.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Keyboard layout types for different input modes
 */
typedef enum {
    KEYBOARD_LAYOUT_QWERTY_LOWER,     /**< QWERTY lowercase letters */
    KEYBOARD_LAYOUT_QWERTY_UPPER,     /**< QWERTY uppercase letters */
    KEYBOARD_LAYOUT_NUMBERS_SYMBOLS,  /**< Numbers and basic symbols */
    KEYBOARD_LAYOUT_SPECIAL_SYMBOLS   /**< Special symbols and punctuation */
} keyboard_layout_t;

/**
 * @brief Keyboard event types
 */
typedef enum {
    KEYBOARD_EVENT_KEY_PRESSED,       /**< A key was pressed */
    KEYBOARD_EVENT_BACKSPACE,         /**< Backspace key pressed */
    KEYBOARD_EVENT_ENTER,             /**< Enter key pressed */
    KEYBOARD_EVENT_SPACE,             /**< Space key pressed */
    KEYBOARD_EVENT_SHIFT,             /**< Shift key pressed (layout change) */
    KEYBOARD_EVENT_LAYOUT_CHANGE      /**< Layout change requested */
} keyboard_event_type_t;

/**
 * @brief Keyboard event data structure
 */
typedef struct {
    keyboard_event_type_t event_type;
    char key_char;                    /**< Character for KEY_PRESSED events */
    keyboard_layout_t new_layout;     /**< New layout for LAYOUT_CHANGE events */
} keyboard_event_data_t;

/**
 * @brief Callback function type for keyboard events
 * @param event_data Keyboard event information
 * @param user_data User data passed during keyboard creation
 */
typedef void (*keyboard_event_cb_t)(const keyboard_event_data_t *event_data, void *user_data);

/**
 * @brief Create a compact keyboard widget suitable for portrait mode
 * @param parent Parent object to attach the keyboard to
 * @param width Width of the keyboard (recommend 460 for 480px screen)
 * @param height Height of the keyboard (recommend 200-240 for portrait)
 * @param event_cb Callback function for keyboard events
 * @param user_data User data to pass to the callback
 * @return Pointer to the created keyboard object
 */
lv_obj_t *keyboard_create_compact(lv_obj_t *parent, lv_coord_t width, lv_coord_t height, 
                                 keyboard_event_cb_t event_cb, void *user_data);

/**
 * @brief Change the keyboard layout
 * @param keyboard Keyboard object
 * @param layout New layout to set
 */
void keyboard_set_layout(lv_obj_t *keyboard, keyboard_layout_t layout);

/**
 * @brief Get the current keyboard layout
 * @param keyboard Keyboard object
 * @return Current layout
 */
keyboard_layout_t keyboard_get_layout(lv_obj_t *keyboard);

/**
 * @brief Destroy the keyboard and free resources
 * @param keyboard Keyboard object to destroy
 */
void keyboard_destroy(lv_obj_t *keyboard);

/**
 * @brief Show/hide the keyboard
 * @param keyboard Keyboard object
 * @param visible True to show, false to hide
 */
void keyboard_set_visible(lv_obj_t *keyboard, bool visible);

#ifdef __cplusplus
}
#endif
