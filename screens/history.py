# screens/history.py
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.metrics import dp
from kivy.uix.scrollview import ScrollView
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from utils.database_manager import db_manager
from utils.sensor_meta import _SENSOR_META
from datetime import datetime

class HistoryScreen(Screen):
    def on_enter(self):
        """Load history when screen is entered"""
        self.load_history()
    
    def navigate_back(self):
        """Navigate back to home screen"""
        self.manager.current = 'home'
    
    def load_history(self):
        """Load gas mix history from database"""
        # Get history data
        history = db_manager.get_gas_mix_history(limit=100)
        
        # Get the scroll view container
        scroll_view = self.ids.history_scroll
        
        # Clear existing content
        scroll_view.clear_widgets()
        
        # Create main container
        main_layout = BoxLayout(orientation='vertical', size_hint_y=None, padding=dp(15), spacing=dp(15))
        main_layout.bind(minimum_height=main_layout.setter('height'))
        
        if not history:
            # Show empty state
            empty_label = Label(
                text='No gas mix history found.\nSave some gas mixes to see them here.',
                font_size='20sp',
                halign='center',
                valign='middle',
                size_hint_y=None,
                height=dp(200),
                text_size=(dp(400), None),
                color=(1, 1, 1, 1)  # White text
            )
            main_layout.add_widget(empty_label)
        else:
            # Add history items
            for item in history:
                history_item = self.create_history_item(item)
                main_layout.add_widget(history_item)
        
        # Add the layout to scroll view
        scroll_view.add_widget(main_layout)
    
    def create_history_item(self, item):
        """Create a history item widget"""
        # Main container for this history item
        item_layout = BoxLayout(
            orientation='vertical',
            size_hint_y=None,
            height=dp(120),
            padding=dp(15)
        )
        
        # Add background color (same as sensor cards)
        from kivy.uix.widget import Widget
        from kivy.graphics import Color, Rectangle, RoundedRectangle
        
        with item_layout.canvas.before:
            Color(0.15, 0.15, 0.15, 1)  # Same dark gray as sensor cards
            item_layout.bg_rect = RoundedRectangle(
                size=item_layout.size, 
                pos=item_layout.pos,
                radius=[8, 8, 8, 8]
            )
        
        def update_bg(instance, value):
            instance.bg_rect.pos = instance.pos
            instance.bg_rect.size = instance.size
        
        item_layout.bind(pos=update_bg, size=update_bg)
        
        # Date and time row
        date_time = datetime.fromisoformat(item['analysis_date'].replace('Z', '+00:00'))
        date_str = date_time.strftime('%Y-%m-%d')
        time_str = date_time.strftime('%H:%M:%S')
        
        date_time_label = Label(
            text=f'{date_str}  •  {time_str}',
            font_size='16sp',
            size_hint_y=None,
            height=dp(30),
            halign='left',
            valign='middle',
            color=(0.8, 0.8, 0.8, 1)  # Light gray text for visibility on dark background
        )
        date_time_label.bind(texture_size=date_time_label.setter('text_size'))
        
        # Gas composition row
        gas_layout = BoxLayout(
            orientation='horizontal',
            size_hint_y=None,
            height=dp(60),
            spacing=dp(15)
        )
        
        # O2 component
        o2_layout = self.create_gas_component(
            'O2', 
            item['o2_percentage'], 
            _SENSOR_META['o2']['color']
        )
        gas_layout.add_widget(o2_layout)
        
        # He component
        he_layout = self.create_gas_component(
            'He', 
            item['he_percentage'], 
            _SENSOR_META['he']['color']
        )
        gas_layout.add_widget(he_layout)
        
        # N2 component
        n2_layout = self.create_gas_component(
            'N2', 
            item['n2_percentage'], 
            _SENSOR_META['n2']['color']
        )
        gas_layout.add_widget(n2_layout)
        
        # Add everything to the item layout
        item_layout.add_widget(date_time_label)
        item_layout.add_widget(gas_layout)
        
        return item_layout
    
    def create_gas_component(self, gas_name, percentage, color):
        """Create a gas component display"""
        layout = BoxLayout(
            orientation='vertical',
            size_hint_x=1
        )
        
        # Gas name label
        name_label = Label(
            text=gas_name,
            font_size='16sp',
            size_hint_y=None,
            height=dp(20),
            halign='center',
            valign='middle',
            color=color
        )
        name_label.bind(texture_size=name_label.setter('text_size'))
        
        # Percentage label
        percent_label = Label(
            text=f'{percentage:.1f}%',
            font_size='24sp',
            size_hint_y=None,
            height=dp(40),
            halign='center',
            valign='middle',
            color=color,
            bold=True
        )
        percent_label.bind(texture_size=percent_label.setter('text_size'))
        
        layout.add_widget(name_label)
        layout.add_widget(percent_label)
        
        return layout
