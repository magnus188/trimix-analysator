from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.properties import StringProperty, ObjectProperty, BooleanProperty, NumericProperty
from kivy.event import EventDispatcher


class NavBar(BoxLayout):
    """
    Standardized navigation bar widget for the Trimix app.
    
    Properties:
    - title: Text displayed in the center
    - left_button_text: Text for the left button (usually "Back")
    - right_button_text: Text for the right button
    - show_left_button: Whether to show the left button
    - show_right_button: Whether to show the right button
    - navbar_height: Height of the navbar in dp (default: 100)
    - title_font_size: Font size of the title in sp (default: 32)
    
    Events:
    - on_left_button_press: Called when left button is pressed
    - on_right_button_press: Called when right button is pressed
    """
    
    title = StringProperty("")
    left_button_text = StringProperty("Back")
    right_button_text = StringProperty("")
    show_left_button = BooleanProperty(True)
    show_right_button = BooleanProperty(False)
    navbar_height = NumericProperty(100)  # Default height in dp
    title_font_size = NumericProperty(32)  # Default font size in sp
    
    # Event callbacks
    left_button_callback = ObjectProperty(None, allownone=True)
    right_button_callback = ObjectProperty(None, allownone=True)
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'horizontal'
        self.size_hint_y = None
        self.height = f'{self.navbar_height}dp'
        self.spacing = '8dp'
        self.padding = ['16dp', '8dp', '16dp', '8dp']
        
        # Register custom events
        self.register_event_type('on_left_button_press')
        self.register_event_type('on_right_button_press')
        
        self.build_navbar()
    
    def build_navbar(self):
        """Build the navbar layout"""
        self.clear_widgets()
        
        # Left button or spacer
        if self.show_left_button:
            self.left_button = Button(
                text=self.left_button_text,
                size_hint_x=None,
                width='80dp',
                font_name='NormalFont'
            )
            self.left_button.bind(on_press=self.on_left_button_pressed)
            self.add_widget(self.left_button)
        else:
            # Add spacer
            spacer = Label(size_hint_x=None, width='80dp')
            self.add_widget(spacer)
        
        # Title in center
        self.title_label = Label(
            text=self.title,
            font_name='BoldFont',
            font_size=f'{self.title_font_size}sp',
            halign='center',
            valign='middle'
        )
        self.title_label.bind(size=self.title_label.setter('text_size'))
        self.add_widget(self.title_label)
        
        # Right button or spacer
        if self.show_right_button:
            self.right_button = Button(
                text=self.right_button_text,
                size_hint_x=None,
                width='80dp',
                font_name='NormalFont'
            )
            self.right_button.bind(on_press=self.on_right_button_pressed)
            self.add_widget(self.right_button)
        else:
            # Add spacer
            spacer = Label(size_hint_x=None, width='80dp')
            self.add_widget(spacer)
    
    def on_left_button_pressed(self, instance):
        """Handle left button press"""
        if self.left_button_callback:
            self.left_button_callback()
        self.dispatch('on_left_button_press')
    
    def on_right_button_pressed(self, instance):
        """Handle right button press"""
        if self.right_button_callback:
            self.right_button_callback()
        self.dispatch('on_right_button_press')
    
    def on_left_button_press(self):
        """Event handler for left button press - override in subclasses or bind to"""
        pass
    
    def on_right_button_press(self):
        """Event handler for right button press - override in subclasses or bind to"""
        pass
    
    def on_title(self, instance, value):
        """Update title when property changes"""
        if hasattr(self, 'title_label'):
            self.title_label.text = value
    
    def on_left_button_text(self, instance, value):
        """Update left button text when property changes"""
        if hasattr(self, 'left_button') and self.show_left_button:
            self.left_button.text = value
    
    def on_right_button_text(self, instance, value):
        """Update right button text when property changes"""
        if hasattr(self, 'right_button') and self.show_right_button:
            self.right_button.text = value
    
    def on_show_left_button(self, instance, value):
        """Rebuild navbar when left button visibility changes"""
        self.build_navbar()
    
    def on_show_right_button(self, instance, value):
        """Rebuild navbar when right button visibility changes"""
        self.build_navbar()
    
    def on_navbar_height(self, instance, value):
        """Update navbar height when property changes"""
        self.height = f'{value}dp'
    
    def on_title_font_size(self, instance, value):
        """Update title font size when property changes"""
        if hasattr(self, 'title_label'):
            self.title_label.font_size = f'{value}sp'
    
    def set_left_button_callback(self, callback):
        """Set callback for left button"""
        self.left_button_callback = callback
    
    def set_right_button_callback(self, callback):
        """Set callback for right button"""
        self.right_button_callback = callback
