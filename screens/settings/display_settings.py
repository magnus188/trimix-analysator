import subprocess
import os
from kivy.uix.screenmanager import Screen
from kivy.properties import NumericProperty
from kivy.clock import Clock
from utils.settings_manager import settings_manager

class DisplaySettingsScreen(Screen):
    brightness = NumericProperty(50)  # Default brightness percentage
    sleep_timeout = NumericProperty(5)  # Default sleep timeout in minutes
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        # Bind to settings changes
        settings_manager.bind(settings=self.on_settings_changed)
        
    def on_settings_changed(self, instance, settings):
        """Called when settings are updated externally"""
        # Update UI when settings change from other sources
        self.brightness = settings_manager.get('display.brightness', 50)
        self.sleep_timeout = settings_manager.get('display.sleep_timeout', 5)
        
    def on_enter(self):
        """Called when entering the screen"""
        # Load settings from the settings manager first
        self.brightness = settings_manager.get('display.brightness', 50)
        self.sleep_timeout = settings_manager.get('display.sleep_timeout', 5)
        
        # Also try to read current system state for verification
        self.load_current_brightness()
        self.load_current_sleep_timeout()
        
    def load_current_brightness(self):
        """Load the current screen brightness from the system"""
        try:
            # Try to read brightness from common backlight paths on Raspberry Pi
            brightness_paths = [
                '/sys/class/backlight/11-0045/brightness',  # Current system backlight
                '/sys/class/backlight/rpi_backlight/brightness',
                '/sys/class/backlight/10-0045/brightness',  # Official 7" touchscreen
                '/sys/class/backlight/backlight/brightness'
            ]
            
            max_brightness_paths = [
                '/sys/class/backlight/11-0045/max_brightness',
                '/sys/class/backlight/rpi_backlight/max_brightness',
                '/sys/class/backlight/10-0045/max_brightness',
                '/sys/class/backlight/backlight/max_brightness'
            ]
            
            current_brightness = None
            max_brightness = None
            
            for i, brightness_path in enumerate(brightness_paths):
                if os.path.exists(brightness_path):
                    try:
                        with open(brightness_path, 'r') as f:
                            current_brightness = int(f.read().strip())
                        with open(max_brightness_paths[i], 'r') as f:
                            max_brightness = int(f.read().strip())
                        break
                    except (IOError, ValueError):
                        continue
            
            if current_brightness is not None and max_brightness is not None:
                # Convert to percentage
                self.brightness = int((current_brightness / max_brightness) * 100)
            else:
                self.brightness = 50
                
        except Exception as e:
            self.brightness = 50
    
    def load_current_sleep_timeout(self):
        """Load the current sleep timeout setting"""
        try:
            # Try to read current screen timeout setting
            result = subprocess.run(['xset', 'q'], capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                # Parse xset output for screen saver timeout
                lines = result.stdout.split('\n')
                for line in lines:
                    if 'timeout:' in line.lower():
                        # Extract timeout value (in seconds)
                        parts = line.split()
                        for i, part in enumerate(parts):
                            if part == 'timeout:' and i + 1 < len(parts):
                                timeout_seconds = int(parts[i + 1])
                                # Convert to minutes
                                self.sleep_timeout = max(1, timeout_seconds // 60)
                                return
            
            # Default if we can't read the setting
            self.sleep_timeout = 5
            
        except Exception as e:
            self.sleep_timeout = 5
    
    def on_brightness_change(self, value):
        """Called when brightness slider changes"""
        self.brightness = int(value)
        
        # Save to settings manager
        settings_manager.set('display.brightness', self.brightness)
        
        # Apply brightness change with a small delay to avoid too many rapid changes
        Clock.unschedule(self._apply_brightness)
        Clock.schedule_once(lambda dt: self._apply_brightness(), 0.2)
    
    def on_sleep_timeout_change(self, minutes):
        """Called when sleep timeout changes"""
        self.sleep_timeout = int(minutes)
        
        # Save to settings manager
        settings_manager.set('display.sleep_timeout', self.sleep_timeout)
        
        self._apply_sleep_timeout()
    
    def _apply_sleep_timeout(self):
        """Apply the sleep timeout setting to the system"""
        try:
            if self.sleep_timeout == 0:
                # Disable screen saver and DPMS
                subprocess.run(['xset', 's', 'off'], capture_output=True, text=True, timeout=5)
                subprocess.run(['xset', '-dpms'], capture_output=True, text=True, timeout=5)
            else:
                timeout_seconds = int(self.sleep_timeout * 60)
                
                # Use xset to set screen timeout
                result = subprocess.run([
                    'xset', 's', str(timeout_seconds), str(timeout_seconds)
                ], capture_output=True, text=True, timeout=5)
                
                if result.returncode == 0:
                    # Also set DPMS (Display Power Management Signaling) timeouts
                    subprocess.run([
                        'xset', 'dpms', str(timeout_seconds), str(timeout_seconds + 60), str(timeout_seconds + 120)
                    ], capture_output=True, text=True, timeout=5)
                else:
                    pass
                
        except Exception as e:
            pass
    
    def _apply_brightness(self):
        """Apply the brightness change to the system"""
        try:
            # Try to write to common backlight paths on Raspberry Pi
            brightness_paths = [
                '/sys/class/backlight/11-0045/brightness',  # Current system backlight
                '/sys/class/backlight/rpi_backlight/brightness',
                '/sys/class/backlight/10-0045/brightness',  # Official 7" touchscreen
                '/sys/class/backlight/backlight/brightness'
            ]
            
            max_brightness_paths = [
                '/sys/class/backlight/11-0045/max_brightness',
                '/sys/class/backlight/rpi_backlight/max_brightness',
                '/sys/class/backlight/10-0045/max_brightness',
                '/sys/class/backlight/backlight/max_brightness'
            ]
            
            for i, brightness_path in enumerate(brightness_paths):
                if os.path.exists(brightness_path):
                    try:
                        # Read max brightness
                        with open(max_brightness_paths[i], 'r') as f:
                            max_brightness = int(f.read().strip())
                        
                        # Calculate actual brightness value
                        actual_brightness = int((self.brightness / 100) * max_brightness)                        # Try to write directly first
                        try:
                            with open(brightness_path, 'w') as f:
                                f.write(str(actual_brightness))
                            return
                        except PermissionError:
                            # If direct write fails, try with sudo
                            result = subprocess.run([
                                'sudo', 'sh', '-c', 
                                f'echo {actual_brightness} > {brightness_path}'
                            ], capture_output=True, text=True, timeout=5)
                            
                            if result.returncode == 0:
                                return
                            else:
                                pass
                                
                    except (IOError, ValueError, subprocess.TimeoutExpired) as e:
                        continue
            
            # If all backlight methods fail, try xrandr (for X11 displays)
            try:
                brightness_decimal = self.brightness / 100.0
                result = subprocess.run([
                    'xrandr', '--output', 'HDMI-1', '--brightness', str(brightness_decimal)
                ], capture_output=True, text=True, timeout=5)
                
                if result.returncode == 0:
                    return
                else:
                    # Try other common display names
                    for display in ['HDMI-2', 'HDMI-A-1', 'eDP-1', 'LVDS-1']:
                        result = subprocess.run([
                            'xrandr', '--output', display, '--brightness', str(brightness_decimal)
                        ], capture_output=True, text=True, timeout=5)
                        if result.returncode == 0:
                            return
                            
            except (subprocess.TimeoutExpired, FileNotFoundError):
                pass
            
        except Exception as e:
            pass
    
    def reset_brightness(self):
        """Reset brightness to default value from settings manager"""
        default_brightness = settings_manager.default_settings['display']['brightness']
        self.brightness = default_brightness
        settings_manager.set('display.brightness', default_brightness)
        self._apply_brightness()
    
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
