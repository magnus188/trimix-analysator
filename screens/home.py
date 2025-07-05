from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from utils.sensors import record_readings, get_readings

class HomeScreen(Screen):
    _record_ev = None
    _update_ev = None

    def on_enter(self):
        # 1) Start recording once (and keep it running)
        if not self._record_ev:
            record_readings()
            self._record_ev = Clock.schedule_interval(lambda dt: record_readings(), 1)

        # 2) Defer the first UI update until IDs exist
        Clock.schedule_once(self._deferred_update, 0)
        # 3) Schedule UI updates every second
        self._update_ev = Clock.schedule_interval(self._update_sensors, 1)

    def on_leave(self):
        # Only stop the UI updates—leave recording alive
        if self._update_ev:
            Clock.unschedule(self._update_ev)

    def _deferred_update(self, dt):
        self._update_sensors(dt)

    def _update_sensors(self, dt):
        data = get_readings()
        self.ids.o2_card.value   = f"{data['o2']:.2f} %"
        self.ids.temp_card.value = f"{data['temp']:.2f} °C"
        self.ids.pres_card.value = f"{data['press']:.2f} hPa"
        self.ids.hum_card.value  = f"{data['hum']:.2f} %"