# screens/analyze.py
from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.metrics import dp
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from utils.sensor_interface import record_readings, get_readings
from utils.sensor_meta import _SENSOR_META
from utils.database_manager import db_manager

class AnalyzeScreen(Screen):
    _record_ev = None
    _update_ev = None

    def on_enter(self):
        if not self._record_ev:
            record_readings()
            self._record_ev = Clock.schedule_interval(lambda dt: record_readings(), 2)  # Reduced frequency to 2 seconds

        Clock.schedule_once(self._deferred_update, 0)
        self._update_ev = Clock.schedule_interval(self._update_sensors, 2)  # Reduced frequency to 2 seconds

    def on_leave(self):
        if self._update_ev:
            Clock.unschedule(self._update_ev)
            self._update_ev = None
        if self._record_ev:
            Clock.unschedule(self._record_ev)
            self._record_ev = None
    
    def navigate_back(self):
        """Navigate back to home screen"""
        self.manager.current = 'home'

    def _deferred_update(self, dt):
        self._update_sensors(dt)

    def _update_sensors(self, dt):
        data = get_readings()
        # Use actual sensor readings for all sensors
        o2_percentage = data['o2']
        he_percentage = data['he']  # Now using actual He sensor reading
        n2_percentage = data['n2']  # Now using actual N2 calculation
        co2_ppm = data['co2']       # CO2 in PPM
        co_ppm = data['co']         # CO in PPM
        
        # Update all sensor cards with proper formatting
        self.ids.o2_card.value   = f"{data['o2']:.1f}{_SENSOR_META['o2']['sign']}"
        self.ids.he_card.value   = f"{he_percentage:.1f}{_SENSOR_META['he']['sign']}"
        self.ids.n2_card.value   = f"{n2_percentage:.1f}{_SENSOR_META['n2']['sign']}"
        self.ids.co2_card.value  = f"{co2_ppm:.0f} ppm"  # CO2 in PPM, not percentage
        self.ids.co_card.value   = f"{co_ppm:.0f} ppm"   # CO in PPM, not percentage
        self.ids.hum_card.value  = f"{data['hum']:.1f}{_SENSOR_META['hum']['sign']}"
        self.ids.temp_card.value = f"{data['temp']:.1f}{_SENSOR_META['temp']['sign']}"
        self.ids.pres_card.value = f"{data['press']:.1f}{_SENSOR_META['press']['sign']}"

        # Set theme colors for all cards
        self.ids.o2_card.theme_color   = _SENSOR_META['o2']['color']
        self.ids.temp_card.theme_color = _SENSOR_META['temp']['color']
        self.ids.pres_card.theme_color = _SENSOR_META['press']['color']
        self.ids.hum_card.theme_color  = _SENSOR_META['hum']['color']
        
        # Set colors for gas mix cards (you can customize these)
        self.ids.he_card.theme_color  = [0.8, 0.8, 0.2, 1]  # Yellow for He
        self.ids.n2_card.theme_color  = [0.2, 0.8, 0.8, 1]  # Cyan for N2
        self.ids.co2_card.theme_color = [0.8, 0.2, 0.2, 1]  # Red for CO2
        self.ids.co_card.theme_color  = [0.8, 0.4, 0.2, 1]  # Orange for CO

    def save_mix(self):
        """Show confirmation dialog to save current gas mix"""
        # Get current readings
        data = get_readings()
        o2_percentage = data['o2']
        he_percentage = data['he']  # Now using actual He sensor reading
        n2_percentage = data['n2']  # Now using actual N2 calculation
        
        # Debug logging to verify all values are present
        print(f"DEBUG: Gas mix values - O2: {o2_percentage:.1f}%, He: {he_percentage:.1f}%, N2: {n2_percentage:.1f}%")
        
        # Create confirmation popup with minimal padding
        content = BoxLayout(orientation='vertical', spacing=dp(20), padding=dp(20))
        
        # Gas mix display (read-only) - ensure N2 is always visible
        dialog_text = f'Gas Mix to Save:\n\nO2: {o2_percentage:.1f}%\nHe: {he_percentage:.1f}%\nN2: {n2_percentage:.1f}%'
        
        gas_display = Label(
            text=dialog_text,
            font_size='20sp',  # Slightly smaller to ensure all text fits
            halign='center',
            valign='middle',
            size_hint_y=None,
            height=dp(180),  # Increased height to accommodate all text
            text_size=(dp(350), None)  # Set explicit width for text wrapping
        )
        
        # Buttons
        button_layout = BoxLayout(orientation='horizontal', spacing=dp(20), size_hint_y=None, height=dp(70))
        
        cancel_button = Button(
            text='Cancel',
            background_color=(0.6, 0.2, 0.2, 1),
            font_size='24sp'
        )
        
        save_button = Button(
            text='Save Mix',
            background_color=(0.2, 0.6, 0.2, 1),
            font_size='24sp'
        )
        
        button_layout.add_widget(cancel_button)
        button_layout.add_widget(save_button)
        
        content.add_widget(gas_display)
        content.add_widget(button_layout)
        
        # Create popup with better sizing to ensure all content is visible
        popup = Popup(
            title='Save Gas Mix',
            content=content,
            size_hint=(0.9, 0.5),  # Increased size to show all content
            title_size='22sp',
            auto_dismiss=False
        )
        
        def save_confirmed(instance):
            # Save to database
            success = db_manager.save_gas_mix(
                o2_percentage=o2_percentage,
                he_percentage=he_percentage,
                n2_percentage=n2_percentage
            )
            
            popup.dismiss()
            
            if success:
                self.show_success_popup('Gas mix saved successfully!')
            else:
                self.show_error_popup('Failed to save gas mix. Please try again.')
        
        def cancel_save(instance):
            popup.dismiss()
        
        save_button.bind(on_press=save_confirmed)
        cancel_button.bind(on_press=cancel_save)
        
        popup.open()
    
    def show_success_popup(self, message):
        """Show success message popup"""
        content = BoxLayout(orientation='vertical', spacing=dp(20), padding=dp(20))
        
        label = Label(
            text=message,
            font_size='24sp',
            halign='center',
            valign='middle',
            size_hint_y=None,
            height=dp(60)
        )
        label.bind(texture_size=label.setter('text_size'))
        
        ok_button = Button(
            text='OK',
            background_color=(0.2, 0.6, 0.2, 1),
            font_size='24sp',
            size_hint_y=None,
            height=dp(60)
        )
        
        content.add_widget(label)
        content.add_widget(ok_button)
        
        popup = Popup(
            title='Success',
            content=content,
            size_hint=(0.7, 0.3),
            title_size='20sp',
            auto_dismiss=False
        )
        
        ok_button.bind(on_press=popup.dismiss)
        popup.open()
    
    def show_error_popup(self, message):
        """Show error message popup"""
        content = BoxLayout(orientation='vertical', spacing=dp(20), padding=dp(20))
        
        label = Label(
            text=message,
            font_size='24sp',
            halign='center',
            valign='middle',
            size_hint_y=None,
            height=dp(60)
        )
        label.bind(texture_size=label.setter('text_size'))
        
        ok_button = Button(
            text='OK',
            background_color=(0.6, 0.2, 0.2, 1),
            font_size='24sp',
            size_hint_y=None,
            height=dp(60)
        )
        
        content.add_widget(label)
        content.add_widget(ok_button)
        
        popup = Popup(
            title='Error',
            content=content,
            size_hint=(0.7, 0.3),
            title_size='20sp',
            auto_dismiss=False
        )
        
        ok_button.bind(on_press=popup.dismiss)
        popup.open()
