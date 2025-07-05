import os
from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.window import Window

# Ensure your screen classes are imported so Builder knows about them
from screens.home import HomeScreen
from widgets.sensor_card import SensorCard
# from screens.settings import SettingsScreen
# etc.

Window.size = (800, 480)
Window.rotation = 270

KV_DIR = os.path.dirname(__file__)

class TrimixScreenManager(ScreenManager):
    pass

class TrimixApp(App):
    def build(self):
        # 1) Load widget definitions (SensorCard)
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'sensor_card.kv'))
        # 2) Load screen layouts (HomeScreen)
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'home.kv'))
        # 3) Load the root manager definition
        Builder.load_file(os.path.join(KV_DIR, 'app.kv'))
        # 4) Instantiate and return the manager
        return TrimixScreenManager(transition=FadeTransition())

if __name__ == '__main__':
    TrimixApp().run()