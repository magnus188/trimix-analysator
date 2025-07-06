from kivy.uix.screenmanager import Screen
from kivy.clock import Clock
from kivy.properties import NumericProperty, StringProperty, BooleanProperty, ListProperty
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from utils.sensors import read_oxygen_voltage, update_v_air_calibration
from utils.calibration_reminder import calibration_reminder
import time

class CalibrateO2Screen(Screen):
    progress = NumericProperty(0)  # Progress from 0 to 100
    countdown_text = StringProperty("30")
    is_calibrating = BooleanProperty(False)
    progress_color = ListProperty([0.5, 0.5, 0.5, 1])  # Default gray color
    calibrate_button_color = ListProperty([0.2, 0.7, 0.2, 1])  # Default green color
    calibrate_button_text = StringProperty("Start Calibration")
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.calibration_duration = 30  # seconds
        self.start_time = 0
        self.voltage_readings = []
        self.clock_event = None
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
    
    def on_enter(self):
        # Reset state when entering the screen
        self.reset_calibration()
    
    def reset_calibration(self):
        """Reset calibration state"""
        self.progress = 0
        self.countdown_text = str(self.calibration_duration)
        self.is_calibrating = False
        self.progress_color = [0.5, 0.5, 0.5, 1]  # Gray
        self.calibrate_button_color = [0.2, 0.7, 0.2, 1]  # Green
        self.calibrate_button_text = "Start Calibration"
        self.voltage_readings = []
        if self.clock_event:
            self.clock_event.cancel()
            self.clock_event = None
    
    def start_calibration(self):
        """Start the O2 calibration process"""
        print("Starting O2 calibration...")
        self.is_calibrating = True
        self.progress_color = [0.2, 0.7, 0.2, 1]  # Green
        self.calibrate_button_color = [0.8, 0.2, 0.2, 1]  # Red (cancel)
        self.calibrate_button_text = "Cancel"
        self.start_time = time.time()
        self.voltage_readings = []
        
        # Start the clock to update progress every 0.5 seconds (reduced frequency)
        self.clock_event = Clock.schedule_interval(self.update_calibration, 0.5)
    
    def update_calibration(self, dt):
        """Update calibration progress and collect readings"""
        elapsed_time = time.time() - self.start_time
        
        # Read voltage and store it
        try:
            voltage = read_oxygen_voltage()
            self.voltage_readings.append(voltage)
        except Exception as e:
            print(f"Error reading voltage: {e}")
        
        # Update progress (0-100)
        self.progress = min((elapsed_time / self.calibration_duration) * 100, 100)
        
        # Update countdown text
        remaining_time = max(0, self.calibration_duration - elapsed_time)
        self.countdown_text = str(int(remaining_time))
        
        # Check if calibration is complete
        if elapsed_time >= self.calibration_duration:
            self.complete_calibration()
            return False  # Stop the clock
        
        return True  # Continue the clock
    
    def complete_calibration(self):
        """Complete the calibration and update the V_AIR value"""
        print(f"Calibration complete! Collected {len(self.voltage_readings)} readings")
        
        if self.voltage_readings:
            # Calculate average voltage
            average_voltage = sum(self.voltage_readings) / len(self.voltage_readings)
            print(f"Average voltage during calibration: {average_voltage:.6f}V")
            
            # Update the calibration in the sensors module
            update_v_air_calibration(average_voltage)
            
            # Record calibration date
            calibration_reminder.record_calibration('o2')
            
            # Show completion message
            self.countdown_text = "✓"
            print("O2 sensor calibrated successfully!")
            
            # Show success popup
            self.show_success_popup(average_voltage)
        else:
            print("No readings collected during calibration!")
            self.countdown_text = "✗"
            self.show_error_popup()
        
        self.is_calibrating = False
        if self.clock_event:
            self.clock_event.cancel()
            self.clock_event = None
    
    def show_success_popup(self, voltage):
        """Show success popup with calibration results"""
        content = BoxLayout(orientation='vertical', spacing=10, padding=20)
        
        # Success message
        success_label = Label(
            text=f'Calibration Successful!\n\nNew calibration voltage: {voltage:.6f}V\n\nThe O2 sensor has been calibrated to fresh air (20.9% O2).',
            font_size='18sp',
            text_size=(400, None),
            halign='center',
            valign='middle'
        )
        content.add_widget(success_label)
        
        # OK button
        ok_button = Button(
            text='OK',
            size_hint_y=None,
            height=50,
            font_size='20sp'
        )
        content.add_widget(ok_button)
        
        # Create and show popup
        popup = Popup(
            title='Calibration Complete',
            content=content,
            size_hint=(0.8, 0.6),
            auto_dismiss=False
        )
        
        ok_button.bind(on_press=lambda x: self.close_popup_and_reset(popup))
        popup.open()
    
    def show_error_popup(self):
        """Show error popup when calibration fails"""
        content = BoxLayout(orientation='vertical', spacing=10, padding=20)
        
        # Error message
        error_label = Label(
            text='Calibration Failed!\n\nNo sensor readings were collected during calibration. Please check the sensor connection and try again.',
            font_size='18sp',
            text_size=(400, None),
            halign='center',
            valign='middle'
        )
        content.add_widget(error_label)
        
        # OK button
        ok_button = Button(
            text='OK',
            size_hint_y=None,
            height=50,
            font_size='20sp'
        )
        content.add_widget(ok_button)
        
        # Create and show popup
        popup = Popup(
            title='Calibration Error',
            content=content,
            size_hint=(0.8, 0.5),
            auto_dismiss=False
        )
        
        ok_button.bind(on_press=lambda x: self.close_popup_and_reset(popup))
        popup.open()
    
    def close_popup_and_reset(self, popup):
        """Close popup and reset calibration state"""
        popup.dismiss()
        self.reset_calibration()
    
    def cancel_calibration(self):
        """Cancel the ongoing calibration"""
        if self.is_calibrating:
            print("Calibration cancelled")
            if self.clock_event:
                self.clock_event.cancel()
                self.clock_event = None
            self.reset_calibration()
    
    def on_button_press(self):
        """Handle button press - either start or cancel calibration"""
        if self.is_calibrating:
            self.cancel_calibration()
        else:
            self.start_calibration()
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.cancel_calibration()  # Cancel any ongoing calibration
        self.manager.current = 'settings'
        print("Navigating back to settings")
