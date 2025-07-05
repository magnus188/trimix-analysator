#!/usr/bin/env python3
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from utils.sensors import get_readings

class HomeScreen(Screen):
    """Home screen displaying live sensor data in a 2×3 grid."""

    def on_enter(self):
        # Schedule the first update on the next frame, after ids exist
        Clock.schedule_once(self._deferred_update, 0)
        # Then schedule regular updates every second
        Clock.schedule_interval(self._update_sensors, 1)

    def on_leave(self):
        # Stop the periodic updates
        Clock.unschedule(self._update_sensors)

    def _deferred_update(self, dt):
        # One-off, first update
        self._update_sensors(dt)

    def _update_sensors(self, dt):
        data = get_readings()
        # Now self.ids.* are guaranteed to exist
        self.ids.o2_card.value = f"{data['o2']:.2f} %"
        self.ids.temp_card.value = f"{data['temp']:.2f} °C"
        self.ids.pres_card.value = f"{data['press']:.2f} hPa"
        self.ids.hum_card.value = f"{data['hum']:.2f} %"
        # Placeholders for future cards:
        # self.ids.mix_card.value = ...
        # self.ids.depth_card.value = ...
