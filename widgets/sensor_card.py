# widgets/sensor_card.py
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.behaviors.button import ButtonBehavior
from kivy.properties import StringProperty

class SensorCard(ButtonBehavior, BoxLayout):
    title = StringProperty('')
    value = StringProperty('')
