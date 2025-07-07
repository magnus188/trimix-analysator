#!/usr/bin/env python3
from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty, ListProperty
from kivy.clock import Clock
from kivy_garden.graph import LinePlot
from utils.sensor_interface import get_history, get_readings, record_readings
from utils.sensor_meta import _SENSOR_META


class SensorDetail(Screen):
    sensor_key   = StringProperty('')
    sensor_label = StringProperty('')
    theme_color  = ListProperty([1,1,1,1])
    live_value   = StringProperty('--')
    sign       = StringProperty('')
    y_axis_label = StringProperty('Value')
    y_label_format = StringProperty('%.1f')

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.plot = None
        self._refresh_event = None
    
    def navigate_back(self):
        """Navigate back to analyze screen"""
        self.manager.current = 'analyze'

    def set_sensor(self, key: str):
        meta = _SENSOR_META.get(key, {})
        self.sensor_key   = key
        self.sensor_label = meta.get('label', '')
        self.theme_color  = meta.get('color', [1, 1, 1, 1])  # Default to white if not found
        self.sign = meta.get('sign', '')
        self.y_axis_label = meta.get('y_label', 'Value')
        # Keep simple numeric format for graph widget compatibility
        self.y_label_format = '%.1f'


    def on_pre_enter(self):
        graph = self.ids.graph
        graph.xmin, graph.xmax = -60, 0  # X-axis from -60 to 0 (right to left: 0, -15, -30, -45, -60)
        
        # Set initial Y range based on sensor type - all with 4 major grid lines
        meta = _SENSOR_META.get(self.sensor_key, {})
        if self.sensor_key == 'o2':
            graph.ymin, graph.ymax = 0, 40  # 0, 10, 20, 30, 40 (5 lines total, 4 intervals)
            graph.y_ticks_major = 10  # 4 intervals of 10%
            graph.y_ticks_minor = 0   # No minor ticks
        elif self.sensor_key == 'temp':
            graph.ymin, graph.ymax = 10, 30  # 10, 15, 20, 25, 30 (5 lines total, 4 intervals)
            graph.y_ticks_major = 5   # 4 intervals of 5°C
            graph.y_ticks_minor = 0   # No minor ticks
        elif self.sensor_key == 'press':
            graph.ymin, graph.ymax = 0, 2  # 0, 0.5, 1.0, 1.5, 2.0 (5 lines total, 4 intervals)
            graph.y_ticks_major = 0.5  # 4 intervals of 0.5 Bar
            graph.y_ticks_minor = 0    # No minor ticks
            print(f"Pressure sensor: ymin={graph.ymin}, ymax={graph.ymax}, major={graph.y_ticks_major}, minor={graph.y_ticks_minor}")
        elif self.sensor_key == 'hum':
            graph.ymin, graph.ymax = 20, 80  # 20, 35, 50, 65, 80 (5 lines total, 4 intervals)
            graph.y_ticks_major = 15  # 4 intervals of 15%
            graph.y_ticks_minor = 0   # No minor ticks
        elif self.sensor_key == 'he':
            graph.ymin, graph.ymax = 0, 40  # 0, 10, 20, 30, 40 (5 lines total, 4 intervals)
            graph.y_ticks_major = 10  # 4 intervals of 10%
            graph.y_ticks_minor = 0   # No minor ticks
        elif self.sensor_key == 'n2':
            graph.ymin, graph.ymax = 40, 80  # 40, 50, 60, 70, 80 (5 lines total, 4 intervals)
            graph.y_ticks_major = 10  # 4 intervals of 10%
            graph.y_ticks_minor = 0   # No minor ticks
        elif self.sensor_key == 'co2':
            graph.ymin, graph.ymax = 0, 4000  # 0, 1000, 2000, 3000, 4000 (5 lines total, 4 intervals)
            graph.y_ticks_major = 1000  # 4 intervals of 1000 PPM
            graph.y_ticks_minor = 0     # No minor ticks
        elif self.sensor_key == 'co':
            graph.ymin, graph.ymax = 0, 80  # 0, 20, 40, 60, 80 (5 lines total, 4 intervals)
            graph.y_ticks_major = 20  # 4 intervals of 20 PPM
            graph.y_ticks_minor = 0   # No minor ticks
        else:
            graph.ymin, graph.ymax = 0, 80  # Default: 0, 20, 40, 60, 80 (5 lines total, 4 intervals)
            graph.y_ticks_major = 20  # 4 intervals of 20 units
            graph.y_ticks_minor = 0   # No minor ticks

        # Ensure tick labels are enabled and visible
        graph.precision = '%.1f'  # Simple numeric format for compatibility
        graph.label_options = {'color': [1, 1, 1, 1], 'bold': True}
        graph.x_grid_label = True
        graph.y_grid_label = True
        
        print(f"Graph configured for {self.sensor_key}: Y-range {graph.ymin}-{graph.ymax}, ticks major={graph.y_ticks_major}, minor={graph.y_ticks_minor}")
        
        # Create the plot BEFORE trying to refresh it
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
        
        # Do initial plot refresh
        self.refresh_plot()

        # Start the timed updates with reduced frequency
        if not self._refresh_event:
            self._refresh_event = Clock.schedule_interval(self._tick, 2)  # Reduced frequency to 2 seconds


    def on_leave(self):
        if self._refresh_event:
            self._refresh_event.cancel()
            self._refresh_event = None

        if self.plot:
            print("Clearing the plot.")
            self.ids.graph.remove_plot(self.plot)  # Remove the plot from the graph widget
            self.plot = None  # Reset the plot variable to None

    def _tick(self, dt):
        # 1) Record current reading to ensure we have live data
        record_readings()
        
        # 2) update live reading - use the actual sensor key, not hardcoded 'o2'
        readings = get_readings()
        val = readings.get(self.sensor_key)
        
        # Format the live value based on sensor type
        if self.sensor_key in ['co2', 'co']:
            self.live_value = f"{val:.0f} ppm" if val is not None else "--"
        else:
            self.live_value = f"{val:.2f}{self.sign}" if val is not None else "--"
        
        # 3) redraw plot with updated data
        self.refresh_plot()

    def refresh_plot(self):
        if not self.plot:
            print("Plot is None. Exiting refresh.")
            return  # Exit early if plot is None

        # grab history and keep only the last 60s
        pts = get_history(self.sensor_key)
        pts = [(s, v) for s, v in pts if 0 <= s <= 60]

        # Add current live reading at x=0 to ensure it's always visible
        current_readings = get_readings()
        current_val = current_readings.get(self.sensor_key)
        if current_val is not None:
            # Add/update the current reading at x=0
            pts.insert(0, (0, current_val))

        # Sort points by time to ensure proper line drawing (oldest to newest)
        pts.sort(key=lambda x: x[0], reverse=True)  # Sort by time, newest first (0 to 60)

        # update the live label
        if pts:
            _, latest = pts[0]  # Use the first point (current reading)
            # Format the live value based on sensor type
            if self.sensor_key in ['co2', 'co']:
                self.live_value = f"{latest:.0f} ppm"
            else:
                self.live_value = f"{latest:.2f}{self.sign}"
        else:
            self.live_value = "--"

        # feed points into the LinePlot with corrected X-axis (negative time values)
        # Sort by x-coordinate to ensure proper line drawing
        plot_points = [(-s, v) for s, v in pts]
        plot_points.sort(key=lambda x: x[0])  # Sort by x-coordinate (left to right)
        self.plot.points = plot_points

        # TEMPORARILY DISABLE AUTOSCALING to prevent crashes
        # The kivy_garden.graph widget has issues with dynamic Y-axis changes
        # We'll use fixed ranges for now to ensure stability

