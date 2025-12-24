#include "keyboard.h"
#include "../components/ui_components.h"
#include "esp_log.h"
#include <string.h>
#include <stdlib.h>

static const char *TAG = "Keyboard";

// Keyboard layout definitions - optimized for portrait 480x800 display
// Each row is defined as a string with keys separated by spaces

// QWERTY lowercase layout (3 rows + function row)
static const char *qwerty_lower_rows[] = {
    "q w e r t y u i o p",           // Row 1 - 10 keys
    "a s d f g h j k l",             // Row 2 - 9 keys  
    "z x c v b n m",                 // Row 3 - 7 keys
    "123 Space Shift Back Enter"     // Function row
};

// QWERTY uppercase layout
static const char *qwerty_upper_rows[] = {
    "Q W E R T Y U I O P",
    "A S D F G H J K L",
    "Z X C V B N M", 
    "123 Space shift Back Enter"     // Note: "shift" means go back to lowercase
};

// Numbers and basic symbols layout
static const char *numbers_symbols_rows[] = {
    "1 2 3 4 5 6 7 8 9 0",
    "- + = ( ) [ ] { } \\",
    ": ; \" ' . , ? ! /",
    "ABC Space #$% Back Enter"
};

// Special symbols layout  
static const char *special_symbols_rows[] = {
    "~ ` @ # $ % ^ & * _",
    "| < > ¡ ¿ § ± ° © ®",
    "£ € ¥ ¢ † ‡ • ◦ ‰",
    "123 Space ABC Back Enter"
};

#define MAX_ROWS 4
#define MAX_KEYS_PER_ROW 10

typedef struct {
    lv_obj_t *keyboard_obj;
    lv_obj_t *key_buttons[MAX_ROWS][MAX_KEYS_PER_ROW];
    keyboard_layout_t current_layout;
    keyboard_event_cb_t event_callback;
    void *user_data;
    lv_coord_t keyboard_width;
    lv_coord_t keyboard_height;
    bool shift_pressed;
} keyboard_data_t;

// Forward declarations
static void keyboard_event_handler(lv_event_t *e);
static void keyboard_create_layout(keyboard_data_t *kb_data);
static const char **get_layout_rows(keyboard_layout_t layout);
static void send_keyboard_event(keyboard_data_t *kb_data, keyboard_event_type_t event_type, 
                               char key_char, keyboard_layout_t new_layout);

lv_obj_t *keyboard_create_compact(lv_obj_t *parent, lv_coord_t width, lv_coord_t height,
                                 keyboard_event_cb_t event_cb, void *user_data) {
    ESP_LOGI(TAG, "Creating compact keyboard %ldx%ld", (long)width, (long)height);
    
    // Create main keyboard container
    lv_obj_t *keyboard = lv_obj_create(parent);
    lv_obj_set_size(keyboard, width, height);
    lv_obj_set_style_bg_color(keyboard, lv_color_hex(0x2E2E2E), 0);
    lv_obj_set_style_radius(keyboard, 8, 0);
    lv_obj_set_style_pad_all(keyboard, 4, 0);
    lv_obj_clear_flag(keyboard, LV_OBJ_FLAG_SCROLLABLE);
    
    // Allocate keyboard data
    keyboard_data_t *kb_data = (keyboard_data_t*)malloc(sizeof(keyboard_data_t));
    if (!kb_data) {
        ESP_LOGE(TAG, "Failed to allocate keyboard data");
        lv_obj_del(keyboard);
        return NULL;
    }
    
    // Initialize keyboard data
    memset(kb_data, 0, sizeof(keyboard_data_t));
    kb_data->keyboard_obj = keyboard;
    kb_data->current_layout = KEYBOARD_LAYOUT_QWERTY_LOWER;
    kb_data->event_callback = event_cb;
    kb_data->user_data = user_data;
    kb_data->keyboard_width = width;
    kb_data->keyboard_height = height;
    kb_data->shift_pressed = false;
    
    // Store keyboard data in the object
    lv_obj_set_user_data(keyboard, kb_data);
    
    // Add cleanup event handler
    lv_obj_add_event_cb(keyboard, keyboard_event_handler, LV_EVENT_DELETE, NULL);
    
    // Create the initial layout
    keyboard_create_layout(kb_data);
    
    ESP_LOGI(TAG, "Compact keyboard created successfully");
    return keyboard;
}

static void keyboard_create_layout(keyboard_data_t *kb_data) {
    const char **layout_rows = get_layout_rows(kb_data->current_layout);
    lv_coord_t row_height = (kb_data->keyboard_height - 16) / MAX_ROWS; // Account for padding
    lv_coord_t key_spacing = 2;
    
    for (int row = 0; row < MAX_ROWS; row++) {
        // Parse keys in this row
        char row_copy[200];
        strncpy(row_copy, layout_rows[row], sizeof(row_copy) - 1);
        row_copy[sizeof(row_copy) - 1] = '\0';
        
        // Count keys in row
        int key_count = 0;
        char *token = strtok(row_copy, " ");
        char keys[MAX_KEYS_PER_ROW][20];
        
        while (token && key_count < MAX_KEYS_PER_ROW) {
            strncpy(keys[key_count], token, sizeof(keys[key_count]) - 1);
            keys[key_count][sizeof(keys[key_count]) - 1] = '\0';
            key_count++;
            token = strtok(NULL, " ");
        }
        
        if (key_count == 0) continue;
        
        // Calculate key width for this row
        lv_coord_t total_spacing = (key_count - 1) * key_spacing;
        lv_coord_t available_width = kb_data->keyboard_width - 8; // Account for container padding
        lv_coord_t key_width = (available_width - total_spacing) / key_count;
        
        // Create keys for this row
        for (int key = 0; key < key_count; key++) {
            lv_obj_t *btn = lv_btn_create(kb_data->keyboard_obj);
            
            // Special handling for function keys
            if (strcmp(keys[key], "Space") == 0) {
                // Space key should be wider
                lv_coord_t space_width = key_width * 2;
                if (key_count <= 5) space_width = key_width * 1.5; // Adjust for function row
                lv_obj_set_size(btn, space_width, row_height - 2);
            } else if (strcmp(keys[key], "Back") == 0 || strcmp(keys[key], "Enter") == 0) {
                // Backspace and Enter slightly wider
                lv_obj_set_size(btn, key_width * 1.2, row_height - 2);
            } else {
                lv_obj_set_size(btn, key_width, row_height - 2);
            }
            
            // Position the button
            lv_coord_t x_pos = 4 + key * (key_width + key_spacing);
            lv_coord_t y_pos = 4 + row * row_height;
            lv_obj_set_pos(btn, x_pos, y_pos);
            
            // Style the button
            lv_obj_set_style_bg_color(btn, lv_color_hex(0x404040), 0);
            lv_obj_set_style_bg_color(btn, lv_color_hex(0x505050), LV_STATE_PRESSED);
            lv_obj_set_style_radius(btn, 4, 0);
            lv_obj_set_style_border_width(btn, 1, 0);
            lv_obj_set_style_border_color(btn, lv_color_hex(0x606060), 0);
            
            // Create label
            lv_obj_t *label = lv_label_create(btn);
            
            // Set label text and handle special keys
            if (strcmp(keys[key], "Space") == 0) {
                lv_label_set_text(label, "Space");
                lv_obj_set_style_text_font(label, FONT_SMALL, 0);
            } else if (strcmp(keys[key], "Back") == 0) {
                lv_label_set_text(label, "⌫");
                lv_obj_set_style_text_font(label, FONT_NORMAL, 0);
            } else if (strcmp(keys[key], "Enter") == 0) {
                lv_label_set_text(label, "↵");
                lv_obj_set_style_text_font(label, FONT_NORMAL, 0);
            } else if (strcmp(keys[key], "Shift") == 0 || strcmp(keys[key], "shift") == 0) {
                lv_label_set_text(label, "⇧");
                lv_obj_set_style_text_font(label, FONT_NORMAL, 0);
            } else if (strcmp(keys[key], "123") == 0 || strcmp(keys[key], "ABC") == 0 || 
                      strcmp(keys[key], "#$%") == 0) {
                lv_label_set_text(label, keys[key]);
                lv_obj_set_style_text_font(label, FONT_SMALL, 0);
            } else {
                lv_label_set_text(label, keys[key]);
                lv_obj_set_style_text_font(label, FONT_NORMAL, 0);
            }
            
            lv_obj_set_style_text_color(label, lv_color_hex(0xFFFFFF), 0);
            lv_obj_center(label);
            
            // Store key data and add event handler
            lv_obj_set_user_data(btn, kb_data);
            lv_obj_add_event_cb(btn, keyboard_event_handler, LV_EVENT_CLICKED, NULL);
            
            // Store button reference
            kb_data->key_buttons[row][key] = btn;
        }
        
        // Clear remaining button slots for this row
        for (int key = key_count; key < MAX_KEYS_PER_ROW; key++) {
            kb_data->key_buttons[row][key] = NULL;
        }
    }
}

static void keyboard_event_handler(lv_event_t *e) {
    lv_event_code_t code = lv_event_get_code(e);
    lv_obj_t *target = (lv_obj_t*)lv_event_get_target(e);
    
    if (code == LV_EVENT_DELETE) {
        // Cleanup keyboard data
        keyboard_data_t *kb_data = (keyboard_data_t*)lv_obj_get_user_data(target);
        if (kb_data) {
            ESP_LOGI(TAG, "Cleaning up keyboard data");
            free(kb_data);
        }
        return;
    }
    
    if (code != LV_EVENT_CLICKED) return;
    
    keyboard_data_t *kb_data = (keyboard_data_t*)lv_obj_get_user_data(target);
    if (!kb_data || !kb_data->event_callback) return;
    
    // Get the button label to determine what key was pressed
    lv_obj_t *label = lv_obj_get_child(target, 0);
    if (!label) return;
    
    const char *key_text = lv_label_get_text(label);
    if (!key_text) return;
    
    ESP_LOGD(TAG, "Key pressed: %s", key_text);
    
    // Handle different key types
    if (strcmp(key_text, "Space") == 0) {
        send_keyboard_event(kb_data, KEYBOARD_EVENT_SPACE, ' ', kb_data->current_layout);
    } else if (strcmp(key_text, "⌫") == 0) {
        send_keyboard_event(kb_data, KEYBOARD_EVENT_BACKSPACE, 0, kb_data->current_layout);
    } else if (strcmp(key_text, "↵") == 0) {
        send_keyboard_event(kb_data, KEYBOARD_EVENT_ENTER, '\n', kb_data->current_layout);
    } else if (strcmp(key_text, "⇧") == 0) {
        // Toggle between upper and lower case
        keyboard_layout_t new_layout = (kb_data->current_layout == KEYBOARD_LAYOUT_QWERTY_LOWER) ?
                                      KEYBOARD_LAYOUT_QWERTY_UPPER : KEYBOARD_LAYOUT_QWERTY_LOWER;
        keyboard_set_layout(kb_data->keyboard_obj, new_layout);
        send_keyboard_event(kb_data, KEYBOARD_EVENT_SHIFT, 0, new_layout);
    } else if (strcmp(key_text, "123") == 0) {
        keyboard_set_layout(kb_data->keyboard_obj, KEYBOARD_LAYOUT_NUMBERS_SYMBOLS);
        send_keyboard_event(kb_data, KEYBOARD_EVENT_LAYOUT_CHANGE, 0, KEYBOARD_LAYOUT_NUMBERS_SYMBOLS);
    } else if (strcmp(key_text, "ABC") == 0) {
        keyboard_set_layout(kb_data->keyboard_obj, KEYBOARD_LAYOUT_QWERTY_LOWER);
        send_keyboard_event(kb_data, KEYBOARD_EVENT_LAYOUT_CHANGE, 0, KEYBOARD_LAYOUT_QWERTY_LOWER);
    } else if (strcmp(key_text, "#$%") == 0) {
        keyboard_set_layout(kb_data->keyboard_obj, KEYBOARD_LAYOUT_SPECIAL_SYMBOLS);
        send_keyboard_event(kb_data, KEYBOARD_EVENT_LAYOUT_CHANGE, 0, KEYBOARD_LAYOUT_SPECIAL_SYMBOLS);
    } else if (strlen(key_text) == 1) {
        // Regular character key
        send_keyboard_event(kb_data, KEYBOARD_EVENT_KEY_PRESSED, key_text[0], kb_data->current_layout);
    }
}

static void send_keyboard_event(keyboard_data_t *kb_data, keyboard_event_type_t event_type,
                               char key_char, keyboard_layout_t new_layout) {
    if (!kb_data->event_callback) return;
    
    keyboard_event_data_t event_data = {
        .event_type = event_type,
        .key_char = key_char,
        .new_layout = new_layout
    };
    
    kb_data->event_callback(&event_data, kb_data->user_data);
}

static const char **get_layout_rows(keyboard_layout_t layout) {
    switch (layout) {
        case KEYBOARD_LAYOUT_QWERTY_UPPER:
            return qwerty_upper_rows;
        case KEYBOARD_LAYOUT_NUMBERS_SYMBOLS:
            return numbers_symbols_rows;
        case KEYBOARD_LAYOUT_SPECIAL_SYMBOLS:
            return special_symbols_rows;
        case KEYBOARD_LAYOUT_QWERTY_LOWER:
        default:
            return qwerty_lower_rows;
    }
}

void keyboard_set_layout(lv_obj_t *keyboard, keyboard_layout_t layout) {
    keyboard_data_t *kb_data = (keyboard_data_t*)lv_obj_get_user_data(keyboard);
    if (!kb_data) return;
    
    ESP_LOGI(TAG, "Changing keyboard layout to %d", layout);
    
    kb_data->current_layout = layout;
    
    // Clear existing buttons
    lv_obj_clean(keyboard);
    
    // Create new layout
    keyboard_create_layout(kb_data);
}

keyboard_layout_t keyboard_get_layout(lv_obj_t *keyboard) {
    keyboard_data_t *kb_data = (keyboard_data_t*)lv_obj_get_user_data(keyboard);
    return kb_data ? kb_data->current_layout : KEYBOARD_LAYOUT_QWERTY_LOWER;
}

void keyboard_destroy(lv_obj_t *keyboard) {
    if (keyboard) {
        lv_obj_del(keyboard);
    }
}

void keyboard_set_visible(lv_obj_t *keyboard, bool visible) {
    if (keyboard) {
        if (visible) {
            lv_obj_clear_flag(keyboard, LV_OBJ_FLAG_HIDDEN);
        } else {
            lv_obj_add_flag(keyboard, LV_OBJ_FLAG_HIDDEN);
        }
    }
}
