# NavBar Widget Documentation

The NavBar widget provides a standardized navigation bar for the Trimix app, ensuring consistent look and behavior across all screens.

## Features

- **Title Display**: Centered title text with bold font
- **Optional Left Button**: Usually used for "Back" navigation
- **Optional Right Button**: For actions like "Scan", "Save", "Power Off", etc.
- **Consistent Styling**: Dark background with border and styled buttons
- **Event Handling**: Customizable callbacks for button presses

## Properties

- `title` (StringProperty): Text displayed in the center
- `left_button_text` (StringProperty): Text for the left button (default: "Back")
- `right_button_text` (StringProperty): Text for the right button
- `show_left_button` (BooleanProperty): Whether to show the left button (default: True)
- `show_right_button` (BooleanProperty): Whether to show the right button (default: False)
- `left_button_callback` (ObjectProperty): Callback function for left button
- `right_button_callback` (ObjectProperty): Callback function for right button

## Usage Examples

### Basic Navigation Bar with Back Button

```kv
NavBar:
    title: 'Settings'
    show_left_button: True
    left_button_text: '← Back'
    show_right_button: False
    left_button_callback: root.navigate_back
```

### Navigation Bar with Both Buttons

```kv
NavBar:
    title: 'Scan Sensors'
    show_left_button: True
    left_button_text: '← Back'
    show_right_button: True
    right_button_text: 'Scan'
    left_button_callback: root.go_back
    right_button_callback: root.start_scan
```

### Navigation Bar with Only Right Button

```kv
NavBar:
    title: 'Home'
    show_left_button: False
    show_right_button: True
    right_button_text: 'Power Off'
    right_button_callback: root.power_off
```

### Navigation Bar with Title Only

```kv
NavBar:
    title: 'Status'
    show_left_button: False
    show_right_button: False
```

## Python Integration

### Method 1: Using Callbacks (Recommended)

```python
class MyScreen(Screen):
    def navigate_back(self):
        self.manager.current = 'home'
    
    def save_settings(self):
        # Save logic here
        pass
```

Then in KV file:
```kv
NavBar:
    title: 'My Screen'
    left_button_callback: root.navigate_back
    right_button_callback: root.save_settings
```

### Method 2: Using Events

```python
class MyScreen(Screen):
    def on_enter(self):
        navbar = self.ids.navbar
        navbar.bind(on_left_button_press=self.on_back_pressed)
        navbar.bind(on_right_button_press=self.on_action_pressed)
    
    def on_back_pressed(self, navbar):
        self.manager.current = 'home'
    
    def on_action_pressed(self, navbar):
        # Action logic here
        pass
```

### Method 3: Programmatic Setup

```python
class MyScreen(Screen):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        
        # Create navbar programmatically
        navbar = NavBar(
            title="Dynamic Title",
            show_left_button=True,
            show_right_button=True,
            right_button_text="Action"
        )
        navbar.set_left_button_callback(self.go_back)
        navbar.set_right_button_callback(self.perform_action)
        
        # Add to layout
        layout = BoxLayout(orientation='vertical')
        layout.add_widget(navbar)
        # Add other widgets...
        self.add_widget(layout)
```

## Common Use Cases

### 1. Settings Screens
- Left button: "← Back" to return to previous screen
- Right button: Not needed or "Save" for settings that need confirmation

### 2. Detail/Info Screens
- Left button: "← Back" to return to list
- Right button: "Edit", "Delete", or other actions

### 3. Action Screens
- Left button: "← Cancel" to abort action
- Right button: "Start", "Scan", "Connect", etc.

### 4. Main/Home Screens
- Left button: Hidden
- Right button: "Settings", "Power Off", or main action

## Styling

The NavBar uses the app's standard fonts:
- Title: BoldFont, 18sp
- Buttons: NormalFont, 14sp

Colors are consistent with the app theme:
- Background: Dark gray (0.1, 0.1, 0.1, 1)
- Border: Medium gray (0.3, 0.3, 0.3, 1)
- Buttons: Blue theme with hover effects

## Tips

1. **Consistent Button Text**: Use "← Back" for back navigation to maintain consistency
2. **Button Width**: Buttons are fixed at 80dp width for consistent layout
3. **Title Length**: Keep titles reasonably short to prevent overflow
4. **Action Buttons**: Use clear, action-oriented text like "Scan", "Save", "Connect"
5. **Spacing**: The navbar automatically handles spacing and padding
