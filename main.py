import os

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.window import Window

# Ensure your screen classes are imported so Builder knows about them
from screens.analyze import AnalyzeScreen
from widgets.sensor_card import SensorCard
from screens.sensor_detail import SensorDetail
from screens.home import HomeScreen
from widgets.menu_card import MenuCard
# from screens.settings import SettingsScreen
# etc.

Window.fullscreen = 'auto'
Window.rotation = 270


KV_DIR = os.path.dirname(__file__)

class TrimixScreenManager(ScreenManager):
    pass

class TrimixApp(App):
    def build(self):
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'sensor_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'menu_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'home.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'analyze.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'sensor_detail.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'app.kv'))
        # 4) Instantiate and return the manager
        return TrimixScreenManager(transition=FadeTransition())
    
    def open_detail(self, sensor_key: str, screen_name: str):
            detail = self.root.get_screen(screen_name)
            print('Opening detail for sensor:', sensor_key, 'on screen:', screen_name)
            detail.set_sensor(sensor_key)
            self.root.current = screen_name

if __name__ == '__main__':
    TrimixApp().run()