# screens/home.py
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from utils.sensors import record_readings, get_readings
from utils.sensor_meta import _SENSOR_META

class AnalyzeScreen(Screen):
    _record_ev = None
    _update_ev = None

    def on_enter(self):
        if not self._record_ev:
            record_readings()
            self._record_ev = Clock.schedule_interval(lambda dt: record_readings(), 1)

        Clock.schedule_once(self._deferred_update, 0)
        self._update_ev = Clock.schedule_interval(self._update_sensors, 1)

    def on_leave(self):
        if self._update_ev:
            Clock.unschedule(self._update_ev)
    
    def navigate_back(self):
        """Navigate back to home screen"""
        self.manager.current = 'home'

    def _deferred_update(self, dt):
        self._update_sensors(dt)

    def _update_sensors(self, dt):
        data = get_readings()
        # pull the same signs from _SENSOR_META
        self.ids.o2_card.value   = f"{data['o2']:.2f}{_SENSOR_META['o2']['sign']}"
        self.ids.temp_card.value = f"{data['temp']:.2f}{_SENSOR_META['temp']['sign']}"
        self.ids.pres_card.value = f"{data['press']:.2f}{_SENSOR_META['press']['sign']}"
        self.ids.hum_card.value  = f"{data['hum']:.2f}{_SENSOR_META['hum']['sign']}"

        # if your SensorCard widget supports a theme color, set it here too:
        self.ids.o2_card.theme_color   = _SENSOR_META['o2']['color']
        self.ids.temp_card.theme_color = _SENSOR_META['temp']['color']
        self.ids.pres_card.theme_color = _SENSOR_META['press']['color']
        self.ids.hum_card.theme_color  = _SENSOR_META['hum']['color']
