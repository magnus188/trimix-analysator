"""
Calibration reminder system for sensor maintenance.
Tracks calibration dates and shows reminders based on intervals.
"""

import os
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from kivy.uix.popup import Popup
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.clock import Clock
from utils.settings_manager import settings_manager

class CalibrationReminder:
    """
    Manages calibration reminders for sensors.
    Checks if calibration is due and shows reminders.
    """
    
    def __init__(self):
        self.popup = None
        
    def check_calibration_due(self) -> Dict[str, Any]:
        """
        Check if any sensors need calibration.
        
        Returns:
            Dict with calibration status information
        """
        result = {
            'o2_due': False,
            'he_due': False,
            'o2_days_overdue': 0,
            'he_days_overdue': 0,
            'o2_last_calibration': None,
            'he_last_calibration': None,
            'interval_days': settings_manager.get('sensors.calibration_interval_days', 30)
        }
        
        # Get calibration dates
        o2_date_str = settings_manager.get('sensors.o2_calibration_date')
        he_date_str = settings_manager.get('sensors.he_calibration_date')
        
        current_date = datetime.now()
        interval_days = result['interval_days']
        
        # Check O2 calibration
        if o2_date_str:
            try:
                o2_date = datetime.fromisoformat(o2_date_str)
                result['o2_last_calibration'] = o2_date
                days_since_o2 = (current_date - o2_date).days
                
                if days_since_o2 >= interval_days:
                    result['o2_due'] = True
                    result['o2_days_overdue'] = days_since_o2 - interval_days
            except ValueError:
                # Invalid date format, treat as never calibrated
                result['o2_due'] = True
        else:
            # Never calibrated
            result['o2_due'] = True
        
        # Check He calibration
        if he_date_str:
            try:
                he_date = datetime.fromisoformat(he_date_str)
                result['he_last_calibration'] = he_date
                days_since_he = (current_date - he_date).days
                
                if days_since_he >= interval_days:
                    result['he_due'] = True
                    result['he_days_overdue'] = days_since_he - interval_days
            except ValueError:
                # Invalid date format, treat as never calibrated
                result['he_due'] = True
        else:
            # Never calibrated
            result['he_due'] = True
            
        return result
    
    def show_calibration_reminder(self, calibration_status: Dict[str, Any] = None):
        """Show calibration reminder popup if needed"""
        if not settings_manager.get('sensors.auto_calibration_reminder', True):
            return
            
        if calibration_status is None:
            calibration_status = self.check_calibration_due()
        
        # Only show if something is due
        if not (calibration_status['o2_due'] or calibration_status['he_due']):
            return
            
        # Don't show multiple popups
        if self.popup:
            return
            
        self._create_reminder_popup(calibration_status)
    
    def _create_reminder_popup(self, status: Dict[str, Any]):
        """Create and show the calibration reminder popup"""
        content = BoxLayout(orientation='vertical', spacing='15dp', padding='20dp')
        
        # Title
        title_label = Label(
            text='Sensor Calibration Reminder',
            font_size='24sp',
            size_hint_y=None,
            height='40dp',
            color=[1, 0.8, 0, 1]  # Orange color for warning
        )
        content.add_widget(title_label)
        
        # Message content
        message_parts = []
        
        if status['o2_due']:
            if status['o2_last_calibration']:
                days_overdue = status['o2_days_overdue']
                if days_overdue > 0:
                    message_parts.append(f"O2 sensor calibration is {days_overdue} days overdue")
                else:
                    message_parts.append("O2 sensor calibration is due")
            else:
                message_parts.append("O2 sensor has never been calibrated")
        
        if status['he_due']:
            if status['he_last_calibration']:
                days_overdue = status['he_days_overdue']
                if days_overdue > 0:
                    message_parts.append(f"He sensor calibration is {days_overdue} days overdue")
                else:
                    message_parts.append("He sensor calibration is due")
            else:
                message_parts.append("He sensor has never been calibrated")
        
        message_text = "\n\n".join(message_parts)
        message_text += f"\n\nRecommended calibration interval: {status['interval_days']} days"
        
        message_label = Label(
            text=message_text,
            font_size='16sp',
            text_size=(400, None),
            halign='center',
            valign='middle'
        )
        content.add_widget(message_label)
        
        # Buttons
        buttons = BoxLayout(
            orientation='horizontal',
            spacing='10dp',
            size_hint_y=None,
            height='60dp'
        )
        
        remind_later_btn = Button(
            text='Remind Later',
            size_hint_x=0.33,
            background_color=[0.4, 0.4, 0.4, 1]
        )
        
        disable_btn = Button(
            text='Disable Reminders',
            size_hint_x=0.33,
            background_color=[0.6, 0.2, 0.2, 1]
        )
        
        calibrate_btn = Button(
            text='Calibrate Now',
            size_hint_x=0.34,
            background_color=[0.2, 0.6, 0.2, 1]
        )
        
        buttons.add_widget(remind_later_btn)
        buttons.add_widget(disable_btn)
        buttons.add_widget(calibrate_btn)
        content.add_widget(buttons)
        
        # Create popup
        self.popup = Popup(
            title='Calibration Required',
            content=content,
            size_hint=(0.9, 0.7),
            auto_dismiss=False
        )
        
        # Bind button events
        remind_later_btn.bind(on_press=self._remind_later)
        disable_btn.bind(on_press=self._disable_reminders)
        calibrate_btn.bind(on_press=self._go_to_calibration)
        
        self.popup.open()
    
    def _remind_later(self, button):
        """Close popup and remind later"""
        if self.popup:
            self.popup.dismiss()
            self.popup = None
    
    def _disable_reminders(self, button):
        """Disable calibration reminders"""
        settings_manager.set('sensors.auto_calibration_reminder', False)
        if self.popup:
            self.popup.dismiss()
            self.popup = None
    
    def _go_to_calibration(self, button):
        """Navigate to calibration screen"""
        from kivy.app import App
        app = App.get_running_app()
        
        if self.popup:
            self.popup.dismiss()
            self.popup = None
            
        # Navigate to settings screen first, then calibration
        if hasattr(app.root, 'current'):
            app.root.current = 'settings'
            # Could add logic here to automatically open calibration sub-screen
    
    def record_calibration(self, sensor_type: str):
        """
        Record that a sensor was calibrated today.
        
        Args:
            sensor_type: 'o2' or 'he'
        """
        current_date = datetime.now().isoformat()
        
        if sensor_type.lower() == 'o2':
            settings_manager.set('sensors.o2_calibration_date', current_date)
        elif sensor_type.lower() == 'he':
            settings_manager.set('sensors.he_calibration_date', current_date)
    
    def get_next_calibration_date(self, sensor_type: str) -> Optional[datetime]:
        """
        Get the next calibration due date for a sensor.
        
        Args:
            sensor_type: 'o2' or 'he'
            
        Returns:
            Next calibration date or None if never calibrated
        """
        date_key = f'sensors.{sensor_type.lower()}_calibration_date'
        date_str = settings_manager.get(date_key)
        
        if not date_str:
            return None
            
        try:
            last_calibration = datetime.fromisoformat(date_str)
            interval_days = settings_manager.get('sensors.calibration_interval_days', 30)
            return last_calibration + timedelta(days=interval_days)
        except ValueError:
            return None
    
    def schedule_periodic_check(self):
        """Schedule periodic calibration checks"""
        # Check every hour for calibration reminders
        Clock.schedule_interval(self._periodic_check, 3600)  # 3600 seconds = 1 hour
    
    def _periodic_check(self, dt):
        """Periodic check for calibration reminders"""
        calibration_status = self.check_calibration_due()
        
        # Only show reminder if something is overdue (not just due)
        show_reminder = False
        if calibration_status['o2_due'] and calibration_status['o2_days_overdue'] > 0:
            show_reminder = True
        if calibration_status['he_due'] and calibration_status['he_days_overdue'] > 0:
            show_reminder = True
        
        if show_reminder:
            self.show_calibration_reminder(calibration_status)


# Global calibration reminder instance
calibration_reminder = CalibrationReminder()
