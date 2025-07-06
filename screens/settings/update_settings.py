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
        """
        Initialize the UpdateSettingsScreen, set up the update manager, and bind event handlers for update-related events.
        """
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
        """
        Updates version information when the screen becomes active.
        """
        super().on_enter()
        self.update_version_info()
    
    def update_version_info(self):
        """
        Updates the UI labels to display the current application version and the last time updates were checked.
        """
        if hasattr(self.ids, 'current_version_label'):
            self.ids.current_version_label.text = f"Current Version: {__version__}"
        
        if hasattr(self.ids, 'last_check_label'):
            last_check = self.update_manager.last_check_time
            if last_check:
                self.ids.last_check_label.text = f"Last checked: {last_check.strftime('%Y-%m-%d %H:%M')}"
            else:
                self.ids.last_check_label.text = "Never checked for updates"
    
    def check_for_updates(self):
        """
        Initiates a manual check for application updates, temporarily disabling the check button and updating its label while the check is performed in the background.
        """
        Logger.info("UpdateSettingsScreen: Manually checking for updates")
        
        # Disable the check button temporarily
        if hasattr(self.ids, 'check_button'):
            self.ids.check_button.disabled = True
            self.ids.check_button.text = "Checking..."
        
        # Run update check in background
        Clock.schedule_once(self._perform_update_check, 0.1)
    
    def _perform_update_check(self, dt):
        """
        Initiates the update check process using the update manager.
        
        This method is typically scheduled to run after a short delay to perform the update check asynchronously.
        """
        self.update_manager.check_for_updates()
    
    def on_update_check_complete(self, update_manager, update_available, update_info):
        """
        Handles completion of the update check by re-enabling the check button, updating version information, and notifying the user if no updates are available.
        """
        # Re-enable the check button
        if hasattr(self.ids, 'check_button'):
            self.ids.check_button.disabled = False
            self.ids.check_button.text = "Check for Updates"
        
        # Update the last check time
        self.update_version_info()
        
        if not update_available:
            self.show_info_popup("No Updates", "You are running the latest version.")
    
    def on_update_available(self, update_manager, update_info):
        """
        Handles the event when an update becomes available by displaying a popup with update details.
        """
        self.show_update_popup(update_info)
    
    def show_update_popup(self, update_info):
        """
        Display a popup dialog presenting available update details and options to update immediately or postpone.
        
        The popup shows the new version, truncated release notes if available, and provides buttons for the user to start the update process or dismiss the dialog.
        """
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
        """
        Initiates the update process for the specified version.
        
        Closes the update information popup, displays a progress popup, and schedules the update manager to begin updating to the provided version.
        """
        if self.update_popup:
            self.update_popup.dismiss()
        
        # Show progress popup
        self.show_progress_popup()
        
        # Start the update
        version = update_info['version']
        Clock.schedule_once(lambda dt: self.update_manager.start_update(version), 0.1)
    
    def check_for_updates_docker(self):
        """
        Initiate a check for available Docker image updates and update the UI to reflect the checking status.
        
        If an error occurs during the process, displays an error popup to the user.
        """
        try:
            if hasattr(self.ids, 'check_button'):
                self.ids.check_button.disabled = True
                self.ids.check_button.text = "Checking..."
            
            # Update status
            if hasattr(self.ids, 'status_label'):
                self.ids.status_label.text = "Checking for updates..."
            
            # Check for updates asynchronously
            Clock.schedule_once(lambda dt: self.update_manager.check_for_updates(), 0.1)
            
        except Exception as e:
            Logger.error(f"UpdateSettingsScreen: Error checking for updates: {e}")
            self.show_error_popup(f"Failed to check for updates: {str(e)}")
    
    def apply_docker_update(self, version):
        """
        Initiate the process to download and apply a Docker-based update for the specified version.
        
        If a progress popup is already displayed, it is dismissed before showing a new progress popup. The update process is then started asynchronously.
        """
        if self.progress_popup:
            self.progress_popup.dismiss()
            
        # Show progress popup
        self.show_progress_popup("Downloading update...")
        
        # Start the update process
        Clock.schedule_once(lambda dt: self.update_manager.download_and_apply_update(version), 0.1)
    
    def show_progress_popup(self, message):
        """
        Displays a popup window with a progress bar and message to indicate update progress.
        
        Parameters:
            message (str): The message to display above the progress bar in the popup.
        """
        content = BoxLayout(orientation='vertical', spacing=10)
        
        progress_label = Label(text=message, size_hint_y=None, height='40dp')
        progress_bar = ProgressBar(max=100, value=0, size_hint_y=None, height='30dp')
        
        content.add_widget(progress_label)
        content.add_widget(progress_bar)
        
        self.progress_popup = Popup(
            title="Updating...",
            content=content,
            size_hint=(0.8, 0.3),
            auto_dismiss=False
        )
        
        # Store references for updates
        self.progress_popup.progress_label = progress_label
        self.progress_popup.progress_bar = progress_bar
        
        self.progress_popup.open()
    
    def on_update_progress(self, update_manager, progress, message):
        """
        Updates the progress popup with the current update progress and status message.
        
        Parameters:
            progress (float): The current progress value, typically between 0 and 100.
            message (str): A message describing the current update step.
        """
        if self.progress_popup:
            self.progress_popup.progress_label.text = message
            self.progress_popup.progress_bar.value = progress
    
    def on_update_complete(self, update_manager, version):
        """
        Handles actions after an update is completed by dismissing the progress popup and displaying a completion popup with options to restart the system immediately or later.
        """
        if self.progress_popup:
            self.progress_popup.dismiss()
            
        # Show completion popup
        content = BoxLayout(orientation='vertical', spacing=10)
        
        label = Label(text=f"Successfully updated to version {version}!\n\nThe system will restart automatically.")
        restart_button = Button(text="Restart Now", size_hint_y=None, height='50dp')
        later_button = Button(text="Restart Later", size_hint_y=None, height='50dp')
        
        def restart_now(instance):
            """
            Dismisses the current popup and initiates a system restart.
            """
            popup.dismiss()
            self.restart_system()
            
        def restart_later(instance):
            """
            Closes the current popup without restarting the system.
            """
            popup.dismiss()
            
        restart_button.bind(on_release=restart_now)
        later_button.bind(on_release=restart_later)
        
        content.add_widget(label)
        content.add_widget(restart_button)
        content.add_widget(later_button)
        
        popup = Popup(
            title="Update Complete",
            content=content,
            size_hint=(0.8, 0.5),
            auto_dismiss=False
        )
        popup.open()
    
    def restart_system(self):
        """
        Attempts to restart the system service to apply updates.
        
        If the restart fails, logs the error and displays an error popup to the user.
        """
        try:
            import subprocess
            subprocess.run(['sudo', 'systemctl', 'restart', 'trimix-analyzer'], check=True)
        except Exception as e:
            Logger.error(f"Failed to restart system: {e}")
            self.show_error_popup(f"Failed to restart: {str(e)}")

    def toggle_auto_updates(self, enabled):
        """
        Enables or disables automatic update checking based on the provided flag.
        
        Parameters:
            enabled (bool): If True, automatic update checks are enabled; if False, they are disabled.
        """
        db_manager.set_setting('updates.auto_check', enabled)
        Logger.info(f"UpdateSettingsScreen: Auto-updates {'enabled' if enabled else 'disabled'}")
    
    def get_version_history(self):
        """
        Return the application's version history for display purposes.
        
        Returns:
            list: A list containing version history entries.
        """
        return VERSION_HISTORY
    
    def go_back(self):
        """
        Navigates back to the previous settings screen.
        
        Intended to be triggered from the KV language UI file.
        """
        self.navigate_back()
