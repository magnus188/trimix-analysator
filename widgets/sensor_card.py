#!/usr/bin/env python3
from kivy.uix.boxlayout import BoxLayout
from kivy.properties import StringProperty

class SensorCard(BoxLayout):
    # These properties must match the KV references root.title and root.value
    title = StringProperty("")  # e.g. "O₂"
    value = StringProperty("")  # e.g. "21.0 %"
