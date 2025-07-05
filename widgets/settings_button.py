# widgets/settings_button.py
from kivy.uix.button import Button
from kivy.properties import StringProperty, ListProperty

class SettingsButton(Button):
    title = StringProperty('')
    background_color_custom = ListProperty([0.15, 0.15, 0.15, 1])
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Set default properties
        self.font_size = '24sp'
        self.size_hint_y = None
        self.height = '80dp'
        self.color = [1, 1, 1, 1]
