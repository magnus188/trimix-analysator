#!/usr/bin/env python3
from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty, ListProperty
from kivy.clock import Clock
from kivy_garden.graph import LinePlot
from utils.sensors import get_history, get_readings, record_readings
from utils.sensor_meta import _SENSOR_META


class SensorDetail(Screen):
    sensor_key   = StringProperty('')
    sensor_label = StringProperty('')
    theme_color  = ListProperty([1,1,1,1])
    live_value   = StringProperty('--')
    sign       = StringProperty('')

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.plot = None
        self._refresh_event = None

    def set_sensor(self, key: str):
        meta = _SENSOR_META.get(key, {})
        self.sensor_key   = key
        self.sensor_label = meta.get('label', '')
        self.theme_color  = meta.get('color', [1, 1, 1, 1])  # Default to white if not found
        self.sign = meta.get('sign', '')


    def on_pre_enter(self):
        graph = self.ids.graph
        graph.xmin, graph.xmax = 0, 60
        graph.ymin, graph.ymax = 0, 1

        self.refresh_plot()

        if not self.plot:
            print("Creating new plot")
            print(self.theme_color)
            self.plot = LinePlot(color=self.theme_color, line_width=2)
            graph.add_plot(self.plot)
            print('Added new plot:', self.plot)
        else:
            print('Using existing plot:', self.plot)


        # Ensure at least one sample, then start the timed updates
        record_readings()

        # Delay the first call to refresh_plot
        if not self._refresh_event:
            self._refresh_event = Clock.schedule_interval(self._tick, 1)


    def on_leave(self):
        if self._refresh_event:
            self._refresh_event.cancel()
            self._refresh_event = None

        if self.plot:
            print("Clearing the plot.")
            self.ids.graph.remove_plot(self.plot)  # Remove the plot from the graph widget
            self.plot = None  # Reset the plot variable to None

    def _tick(self, dt):
        # 1) update live reading
        val = get_readings()['o2']
        self.live_value = f"{val:.2f}" if val is not None else "--"
        # 2) redraw ONLY from buffer
        self.refresh_plot()

    def refresh_plot(self):
        if not self.plot:
            print("Plot is None. Exiting refresh.")
            return  # Exit early if plot is None

        # grab history and keep only the last 60s
        pts = get_history(self.sensor_key)
        pts = [(s, v) for s, v in pts if 0 <= s <= 60]

        # update the live label
        if pts:
            _, latest = pts[-1]
            self.live_value = f"{latest:.2f}{self.sign}"
        else:
            self.live_value = "--"

        # feed points into the LinePlot
        self.plot.points = [(60 - s, v) for s, v in pts]

        # gentle autoscale Y each tick
        values = [v for _, v in pts]
        if values:
            mn, mx = min(values), max(values)
            margin = (mx - mn) * 0.1 if mx > mn else mx * 0.1
            self.ids.graph.ymin = mn - margin
            self.ids.graph.ymax = mx + margin
        else:
            self.ids.graph.ymin, self.ids.graph.ymax = 0, 1

