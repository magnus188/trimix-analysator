# widgets/sensor_card.py
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.behaviors.button import ButtonBehavior
from kivy.properties import StringProperty, ListProperty

class SensorCard(ButtonBehavior, BoxLayout):
    title = StringProperty('')
    value = StringProperty('')
    theme_color = ListProperty([1, 1, 1, 1])  # default
