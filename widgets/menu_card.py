# widgets/menu_card.py
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.behaviors.button import ButtonBehavior
from kivy.properties import StringProperty, ListProperty
from kivy.uix.label import Label
from kivy.metrics import dp

class MenuCard(ButtonBehavior, BoxLayout):
    title = StringProperty('')

   