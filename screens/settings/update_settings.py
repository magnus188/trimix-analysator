"""
Update settings screen for managing application updates.
"""

from kivy.uix.boxlayout import BoxLayout
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.progressbar import ProgressBar
from kivy.clock import Clock
from kivy.logger import Logger

from utils.base_screen import BaseScreen
from utils.database_manager import db_manager
from utils.update_manager import get_update_manager
from version import __version__, VERSION_HISTORY


class UpdateSettingsScreen(BaseScreen):
    """Screen for managing application updates."""
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.update_manager = get_update_manager()
        self.update_popup = None
        self.progress_popup = None
        
        # Bind to update manager events
        self.update_manager.bind(on_update_available=self.on_update_available)
        self.update_manager.bind(on_update_check_complete=self.on_update_check_complete)
        self.update_manager.bind(on_update_progress=self.on_update_progress)
        self.update_manager.bind(on_update_complete=self.on_update_complete)
        self.update_manager.bind(on_update_error=self.on_update_error)
    
    def on_enter(self):
        """Called when screen is entered."""
        super().on_enter()
        self.update_version_info()
    
    def update_version_info(self):
        """Update the version information display."""
        if hasattr(self.ids, 'current_version_label'):
            self.ids.current_version_label.text = f"Current Version: {__version__}"
        
        if hasattr(self.ids, 'last_check_label'):
            last_check = self.update_manager.last_check_time
            if last_check:
                self.ids.last_check_label.text = f"Last checked: {last_check.strftime('%Y-%m-%d %H:%M')}"
            else:
                self.ids.last_check_label.text = "Never checked for updates"
    
    def check_for_updates(self):
        """Manually check for updates."""
        Logger.info("UpdateSettingsScreen: Manually checking for updates")
        
        # Disable the check button temporarily
        if hasattr(self.ids, 'check_button'):
            self.ids.check_button.disabled = True
            self.ids.check_button.text = "Checking..."
        
        # Run update check in background
        Clock.schedule_once(self._perform_update_check, 0.1)
    
    def _perform_update_check(self, dt):
        """Perform the actual update check."""
        self.update_manager.check_for_updates()
    
    def on_update_check_complete(self, update_manager, update_available, update_info):
        """Called when update check is complete."""
        # Re-enable the check button
        if hasattr(self.ids, 'check_button'):
            self.ids.check_button.disabled = False
            self.ids.check_button.text = "Check for Updates"
        
        # Update the last check time
        self.update_version_info()
        
        if not update_available:
            self.show_info_popup("No Updates", "You are running the latest version.")
    
    def on_update_available(self, update_manager, update_info):
        """Called when an update is available."""
        self.show_update_popup(update_info)
    
    def show_update_popup(self, update_info):
        """Show popup with update information."""
        content = BoxLayout(orientation='vertical', spacing=10, padding=10)
        
        # Update information
        content.add_widget(Label(
            text=f"Update Available!",
            font_size='18sp',
            size_hint_y=None,
            height=40
        ))
        
        content.add_widget(Label(
            text=f"Version: {update_info['version']}",
            size_hint_y=None,
            height=30
        ))
        
        if update_info.get('notes'):
            notes_label = Label(
                text=f"Release Notes:\n{update_info['notes'][:200]}...",
                text_size=(400, None),
                valign='top',
                size_hint_y=None
            )
            notes_label.bind(texture_size=notes_label.setter('size'))
            content.add_widget(notes_label)
        
        # Buttons
        button_layout = BoxLayout(orientation='horizontal', size_hint_y=None, height=50, spacing=10)
        
        update_button = Button(text="Update Now", size_hint_x=0.5)
        update_button.bind(on_press=lambda x: self.start_update(update_info))
        
        cancel_button = Button(text="Later", size_hint_x=0.5)
        cancel_button.bind(on_press=lambda x: self.update_popup.dismiss())
        
        button_layout.add_widget(update_button)
        button_layout.add_widget(cancel_button)
        content.add_widget(button_layout)
        
        self.update_popup = Popup(
            title="Update Available",
            content=content,
            size_hint=(0.8, 0.7),
            auto_dismiss=False
        )
        self.update_popup.open()
    
    def start_update(self, update_info):
        """Start the update process."""
        if self.update_popup:
            self.update_popup.dismiss()
        
        # Show progress popup
        self.show_progress_popup()
        
        # Start the update
        version = update_info['version']
        Clock.schedule_once(lambda dt: self.update_manager.start_update(version), 0.1)
    
    def show_progress_popup(self):
        """Show update progress popup."""
        content = BoxLayout(orientation='vertical', spacing=10, padding=10)
        
        content.add_widget(Label(
            text="Updating Application...",
            font_size='18sp',
            size_hint_y=None,
            height=40
        ))
        
        self.progress_bar = ProgressBar(
            max=100,
            value=0,
            size_hint_y=None,
            height=30
        )
        content.add_widget(self.progress_bar)
        
        self.progress_label = Label(
            text="Preparing...",
            size_hint_y=None,
            height=30
        )
        content.add_widget(self.progress_label)
        
        self.progress_popup = Popup(
            title="Updating",
            content=content,
            size_hint=(0.6, 0.4),
            auto_dismiss=False
        )
        self.progress_popup.open()
    
    def on_update_progress(self, update_manager, progress, message):
        """Called during update progress."""
        if self.progress_popup and hasattr(self, 'progress_bar'):
            self.progress_bar.value = progress
            self.progress_label.text = message
    
    def on_update_complete(self, update_manager, version):
        """Called when update is complete."""
        if self.progress_popup:
            self.progress_popup.dismiss()
        
        self.show_info_popup(
            "Update Complete",
            f"Successfully updated to version {version}.\nThe application will restart shortly."
        )
        
        # Schedule app restart
        Clock.schedule_once(self.restart_app, 3)
    
    def on_update_error(self, update_manager, error_message):
        """Called when an update error occurs."""
        if self.progress_popup:
            self.progress_popup.dismiss()
        
        self.show_info_popup("Update Failed", f"Update failed: {error_message}")
    
    def show_info_popup(self, title, message):
        """Show an information popup."""
        content = BoxLayout(orientation='vertical', spacing=10, padding=10)
        
        content.add_widget(Label(text=message, text_size=(300, None), halign='center', valign='middle'))
        
        ok_button = Button(text="OK", size_hint=(None, None), size=(100, 40), pos_hint={'center_x': 0.5})
        content.add_widget(ok_button)
        
        popup = Popup(
            title=title,
            content=content,
            size_hint=(0.6, 0.4),
            auto_dismiss=False
        )
        ok_button.bind(on_press=popup.dismiss)
        popup.open()
    
    def restart_app(self, dt):
        """Restart the application."""
        # This will depend on your deployment method
        # For Docker, the container should restart automatically
        import sys
        sys.exit(0)
    
    def toggle_auto_updates(self, enabled):
        """Toggle automatic update checking."""
        db_manager.set_setting('updates.auto_check', enabled)
        Logger.info(f"UpdateSettingsScreen: Auto-updates {'enabled' if enabled else 'disabled'}")
    
    def get_version_history(self):
        """Get version history for display."""
        return VERSION_HISTORY
