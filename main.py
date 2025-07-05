import os

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.window import Window
from kivy.core.text import LabelBase
from kivy.uix.label import Label

# Ensure your screen classes are imported so Builder knows about them
from screens.analyze import AnalyzeScreen
from widgets.sensor_card import SensorCard
from screens.sensor_detail import SensorDetail
from screens.home import HomeScreen
from screens.settings import SettingsScreen
from widgets.menu_card import MenuCard
from widgets.settings_button import SettingsButton
# etc.

Window.fullscreen = 'auto'
Window.rotation = 270


KV_DIR = os.path.dirname(__file__)

class TrimixScreenManager(ScreenManager):
    pass

class TrimixApp(App):
    def build(self):

        LabelBase.register(name="LightFont", fn_regular="assets/fonts/light.ttf")
        LabelBase.register(name="NormalFont", fn_regular="assets/fonts/normal.ttf")
        LabelBase.register(name="BoldFont", fn_regular="assets/fonts/bold.ttf")
       
        Label.font_name = "BoldFont"

        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'sensor_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'menu_card.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'widgets', 'settings_button.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'home.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'analyze.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'sensor_detail.kv'))
        Builder.load_file(os.path.join(KV_DIR, 'screens', 'settings.kv'))
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