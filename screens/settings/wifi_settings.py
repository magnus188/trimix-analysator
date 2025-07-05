import subprocess
import threading
from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty, ListProperty
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.popup import Popup
from kivy.clock import Clock
from utils.settings_manager import settings_manager
import re

class WiFiNetwork(BoxLayout):
    """Custom widget for displaying a WiFi network"""
    ssid = StringProperty('')
    signal_strength = StringProperty('')
    security = StringProperty('')
    connected = StringProperty('')
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'horizontal'
        self.size_hint_y = None
        self.height = '60dp'
        self.spacing = '10dp'
        self.padding = ['10dp', '5dp']
    
    def on_button_press(self):
        """Handle connect/disconnect button press"""
        from kivy.app import App
        app = App.get_running_app()
        wifi_screen = app.root.get_screen('wifi_settings')
        
        if self.ssid == wifi_screen.connected_network:
            wifi_screen.disconnect_current()
        else:
            wifi_screen.connect_to_network(self.ssid, self.security)

class WiFiSettingsScreen(Screen):
    available_networks = ListProperty([])
    connected_network = StringProperty('')
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.scanning = False
        # Bind to settings changes
        settings_manager.bind(settings=self.on_settings_changed)
        
    def on_settings_changed(self, instance, settings):
        """Called when settings are updated externally"""
        # Update WiFi preferences when settings change
        pass
        
    def on_enter(self):
        """Called when entering the screen"""
        self.scan_networks()
        self.check_connection_status()
        
    def scan_networks(self):
        """Scan for available WiFi networks"""
        if self.scanning:
            return
            
        self.scanning = True
        
        # Run network scan in a separate thread to avoid blocking UI
        thread = threading.Thread(target=self._scan_networks_thread)
        thread.daemon = True
        thread.start()
        
    def _scan_networks_thread(self):
        """Thread function to scan for networks"""
        try:
            # Check if nmcli is available
            check_result = subprocess.run(['which', 'nmcli'], capture_output=True, text=True, timeout=5)
            if check_result.returncode != 0:
                Clock.schedule_once(lambda dt: self._show_nmcli_error())
                return

            # Use nmcli to scan for all visible networks and show which is active
            result = subprocess.run([
                'nmcli', '-t', '-f', 'SSID,ACTIVE,SIGNAL,SECURITY', 'dev', 'wifi', 'list'
            ], capture_output=True, text=True, timeout=10)

            connected_ssid = ''
            networks = []
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                for line in lines:
                    if line.strip():
                        parts = line.split(':')
                        if len(parts) >= 4 and parts[0].strip():
                            ssid = parts[0].strip()
                            active = parts[1].strip()
                            signal = parts[2].strip() + '%' if parts[2].strip() else 'Unknown'
                            security = parts[3].strip() if parts[3].strip() else 'Open'
                            if active == 'yes':
                                connected_ssid = ssid
                            networks.append({
                                'ssid': ssid,
                                'signal': signal,
                                'security': security
                            })
                # Update UI on main thread
                Clock.schedule_once(lambda dt: self._update_networks_and_status(networks, connected_ssid))
            else:
                print(f"Error scanning networks: {result.stderr}")
                Clock.schedule_once(lambda dt: self._scan_error())
        except subprocess.TimeoutExpired:
            print("Network scan timed out")
            Clock.schedule_once(lambda dt: self._scan_error())
        except FileNotFoundError:
            print("nmcli not found")
            Clock.schedule_once(lambda dt: self._show_nmcli_error())
        except Exception as e:
            print(f"Error scanning networks: {e}")
            Clock.schedule_once(lambda dt: self._scan_error())
        finally:
            self.scanning = False

    def _update_networks_and_status(self, networks, connected_ssid):
        """Update the networks list and connection status on the main thread"""
        self.available_networks = networks
        self.connected_network = connected_ssid
        print(f"Found {len(networks)} networks. Connected to: {connected_ssid}")
        # Clear existing network widgets
        container = self.ids.networks_container
        container.clear_widgets()
        # Add network widgets
        for network in networks:
            wifi_widget = WiFiNetwork(
                ssid=network['ssid'],
                signal_strength=network['signal'],
                security=network['security']
            )
            container.add_widget(wifi_widget)

    def _scan_error(self):
        """Handle scan error on main thread"""
        print("Failed to scan networks")
        
    def _show_nmcli_error(self):
        """Show error when nmcli is not available"""
        error_msg = "Network Manager (nmcli) not found.\nThis feature requires NetworkManager to be installed."
        content = Label(text=error_msg, text_size=(None, None), halign='center')
        
        popup = Popup(
            title='Network Tools Missing',
            content=content,
            size_hint=(0.8, 0.4),
            auto_dismiss=True
        )
        popup.open()
        
        # Show demo networks for testing
        demo_networks = [
            {'ssid': 'Demo Network 1', 'signal': '85%', 'security': 'WPA2'},
            {'ssid': 'Demo Network 2', 'signal': '60%', 'security': 'Open'},
            {'ssid': 'Demo Network 3', 'signal': '40%', 'security': 'WPA3'},
        ]
        self._update_networks(demo_networks)
        
    def check_connection_status(self):
        """Check current WiFi connection status by rescanning networks"""
        self.scan_networks()
            
    def connect_to_network(self, ssid, security):
        """Connect to a WiFi network"""
        if security == 'Open':
            # Connect to open network
            self._connect_open_network(ssid)
        else:
            # Show password input popup
            self._show_password_popup(ssid)
            
    def _connect_open_network(self, ssid):
        """Connect to an open WiFi network"""
        try:
            result = subprocess.run(['nmcli', 'dev', 'wifi', 'connect', ssid], 
                                  capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                self.connected_network = ssid
                self._show_connection_result(f"Connected to {ssid}", success=True)
            else:
                self._show_connection_result(f"Failed to connect to {ssid}", success=False)
                
        except Exception as e:
            self._show_connection_result(f"Error connecting to {ssid}", success=False)
            
    def _show_password_popup(self, ssid):
        """Show popup to enter WiFi password"""
        content = BoxLayout(orientation='vertical', spacing='10dp', padding='10dp')
        
        content.add_widget(Label(text=f'Enter password for {ssid}:', size_hint_y=None, height='40dp'))
        
        password_input = TextInput(
            multiline=False,
            password=True,
            size_hint_y=None,
            height='40dp',
            font_size='18sp'
        )
        content.add_widget(password_input)
        
        buttons = BoxLayout(orientation='horizontal', spacing='10dp', size_hint_y=None, height='50dp')
        
        cancel_btn = Button(text='Cancel', size_hint_x=0.5)
        connect_btn = Button(text='Connect', size_hint_x=0.5)
        
        buttons.add_widget(cancel_btn)
        buttons.add_widget(connect_btn)
        content.add_widget(buttons)
        
        popup = Popup(
            title=f'Connect to {ssid}',
            content=content,
            size_hint=(0.8, 0.4),
            auto_dismiss=False
        )
        
        cancel_btn.bind(on_press=popup.dismiss)
        connect_btn.bind(on_press=lambda x: self._connect_with_password(ssid, password_input.text, popup))
        
        popup.open()
        
    def _connect_with_password(self, ssid, password, popup):
        """Connect to WiFi network with password"""
        popup.dismiss()
        
        if not password.strip():
            self._show_connection_result("Password cannot be empty", success=False)
            return
            
        # Run connection in a separate thread
        thread = threading.Thread(target=self._connect_with_password_thread, args=(ssid, password))
        thread.daemon = True
        thread.start()
        
    def _connect_with_password_thread(self, ssid, password):
        """Thread function to connect with password"""
        try:
            result = subprocess.run(['nmcli', 'dev', 'wifi', 'connect', ssid, 'password', password], 
                                  capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                Clock.schedule_once(lambda dt: self._connection_success(ssid))
            else:
                error_msg = result.stderr.strip() if result.stderr else "Unknown error"
                Clock.schedule_once(lambda dt: self._connection_failed(ssid, error_msg))
                
        except Exception as e:
            Clock.schedule_once(lambda dt: self._connection_failed(ssid, str(e)))
            
    def _connection_success(self, ssid):
        """Handle successful connection on main thread"""
        self.connected_network = ssid
        
        # Save last connected network to settings
        settings_manager.set('wifi.last_network', ssid)
        
        self._show_connection_result(f"Connected to {ssid}", success=True)
        # Refresh the network list to update connection status
        self._refresh_network_widgets()
        
    def _connection_failed(self, ssid, error):
        """Handle failed connection on main thread"""
        self._show_connection_result(f"Failed to connect to {ssid}", success=False)
        
    def _show_connection_result(self, message, success=True):
        """Show connection result popup"""
        content = Label(text=message, text_size=(None, None))
        
        popup = Popup(
            title='Connection Result',
            content=content,
            size_hint=(0.7, 0.3),
            auto_dismiss=True
        )
        popup.open()
        
        # Auto-dismiss after 3 seconds
        Clock.schedule_once(lambda dt: popup.dismiss(), 3)
        
    def disconnect_current(self):
        """Disconnect from current WiFi network"""
        if not self.connected_network:
            return
            
        try:
            result = subprocess.run(['nmcli', 'connection', 'down', self.connected_network], 
                                  capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0:
                self.connected_network = ''
                print("Disconnected from WiFi")
                self._show_connection_result("Disconnected from WiFi", success=True)
                # Refresh the network list to update connection status
                self._refresh_network_widgets()
            else:
                print(f"Failed to disconnect: {result.stderr}")
                self._show_connection_result("Failed to disconnect", success=False)
                
        except Exception as e:
            print(f"Error disconnecting: {e}")
            self._show_connection_result("Error disconnecting", success=False)
    
    def _refresh_network_widgets(self):
        """Refresh the network widgets to update connection status"""
        if hasattr(self, 'ids') and 'networks_container' in self.ids:
            container = self.ids.networks_container
            # Update existing widgets or recreate them
            if self.available_networks:
                self._update_networks(self.available_networks)
            
    def navigate_back(self):
        """Navigate back to settings screen"""
        self.manager.current = 'settings'
        print("Navigating back to settings")
