"""
Update Manager for Trimix Analyzer.
Handles checking for updates from GitHub releases and managing update process.
"""

import requests
import json
import os
import subprocess
import time
from typing import Dict, Optional, Tuple, List
from datetime import datetime
from kivy.logger import Logger
from kivy.event import EventDispatcher

from version import __version__, get_version_info


class UpdateManager(EventDispatcher):
    """Manages application updates from GitHub releases."""
    
    # Events
    __events__ = ('on_update_available', 'on_update_check_complete', 'on_update_progress', 'on_update_complete', 'on_update_error')
    
    def __init__(self, repo_owner: str = None, repo_name: str = None):
        """
        Initialize the UpdateManager with repository and version information.
        
        Attempts to detect the GitHub repository owner and name from the local git remote URL if not provided. Falls back to environment variables or default values if detection fails. Sets up GitHub API settings, update check preferences, and initializes the current application version.
        """
        super().__init__()
        
        # Try to detect repository from git remote if not provided
        if not repo_owner or not repo_name:
            try:
                import subprocess
                result = subprocess.run(['git', 'remote', 'get-url', 'origin'], 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    url = result.stdout.strip()
                    # Parse GitHub URL: https://github.com/owner/repo.git
                    if 'github.com' in url:
                        parts = url.split('/')
                        detected_owner = parts[-2]
                        detected_repo = parts[-1].replace('.git', '')
                        repo_owner = repo_owner or detected_owner
                        repo_name = repo_name or detected_repo
            except Exception:
                pass
        
        # Default to repository from environment or fallback
        self.repo_owner = repo_owner or os.environ.get('GITHUB_REPOSITORY_OWNER', 'magnus188')
        self.repo_name = repo_name or os.environ.get('GITHUB_REPOSITORY_NAME', 'trimix-analysator')
        self.current_version = __version__
        
        # GitHub API settings
        self.api_base = "https://api.github.com"
        self.timeout = 30
        
        # Update settings
        self.check_prereleases = False
        self.auto_check_interval = 3600  # 1 hour
        self.last_check_time = None
        
        Logger.info(f"UpdateManager: Initialized for {self.repo_owner}/{self.repo_name}, current version: {self.current_version}")
    
    def compare_versions(self, version1: str, version2: str) -> int:
        """
        Compares two semantic version strings and determines their ordering.
        
        Returns:
            int: -1 if version1 is less than version2, 0 if they are equal, 1 if version1 is greater than version2.
        """
        def normalize_version(v):
            # Remove 'v' prefix if present
            """
            Converts a version string into a list of integers for comparison, handling optional 'v' prefix and pre-release suffixes.
            
            Parameters:
            	v (str): The version string to normalize (e.g., 'v1.2.3', '1.2.3-alpha').
            
            Returns:
            	List[int]: A list of integers representing the major, minor, and patch components of the version.
            """
            v = v.lstrip('v')
            # Split into parts and convert to integers
            parts = []
            for part in v.split('.'):
                try:
                    parts.append(int(part))
                except ValueError:
                    # Handle pre-release versions (e.g., '1.0.0-alpha')
                    if '-' in part:
                        parts.append(int(part.split('-')[0]))
                    else:
                        parts.append(0)
            return parts
        
        v1_parts = normalize_version(version1)
        v2_parts = normalize_version(version2)
        
        # Pad shorter version with zeros
        max_len = max(len(v1_parts), len(v2_parts))
        v1_parts.extend([0] * (max_len - len(v1_parts)))
        v2_parts.extend([0] * (max_len - len(v2_parts)))
        
        for p1, p2 in zip(v1_parts, v2_parts):
            if p1 < p2:
                return -1
            elif p1 > p2:
                return 1
        
        return 0
    
    def check_for_updates(self) -> Optional[Dict]:
        """
        Checks GitHub for the latest release and determines if an update is available.
        
        If a newer release is found (excluding prereleases unless enabled), dispatches update events and returns release information. Returns None if no update is available or if an error occurs.
        
        Returns:
            update_info (dict or None): Dictionary with release details if an update is available, otherwise None.
        """
        try:
            Logger.info("UpdateManager: Checking for updates...")
            self.last_check_time = datetime.now()
            
            # Get latest release from GitHub API
            url = f"{self.api_base}/repos/{self.repo_owner}/{self.repo_name}/releases/latest"
            
            response = requests.get(url, timeout=self.timeout)
            response.raise_for_status()
            
            release_data = response.json()
            
            # Extract version from tag name
            latest_version = release_data['tag_name']
            release_name = release_data['name']
            release_notes = release_data['body']
            published_at = release_data['published_at']
            is_prerelease = release_data['prerelease']
            
            # Skip prereleases if not enabled
            if is_prerelease and not self.check_prereleases:
                Logger.info("UpdateManager: Skipping prerelease version")
                self.dispatch('on_update_check_complete', False, None)
                return None
            
            # Compare versions
            if self.compare_versions(self.current_version, latest_version) < 0:
                Logger.info(f"UpdateManager: Update available! Current: {self.current_version}, Latest: {latest_version}")
                
                update_info = {
                    'version': latest_version,
                    'name': release_name,
                    'notes': release_notes,
                    'published_at': published_at,
                    'is_prerelease': is_prerelease,
                    'download_url': self._get_docker_image_url(latest_version),
                    'assets': release_data.get('assets', [])
                }
                
                self.dispatch('on_update_available', update_info)
                self.dispatch('on_update_check_complete', True, update_info)
                return update_info
            else:
                Logger.info(f"UpdateManager: No updates available (current: {self.current_version}, latest: {latest_version})")
                self.dispatch('on_update_check_complete', False, None)
                return None
                
        except requests.RequestException as e:
            Logger.error(f"UpdateManager: Network error checking for updates: {e}")
            self.dispatch('on_update_error', f"Network error: {e}")
            return None
        except Exception as e:
            Logger.error(f"UpdateManager: Error checking for updates: {e}")
            self.dispatch('on_update_error', f"Update check failed: {e}")
            return None
    
    def _get_docker_image_url(self, version: str) -> str:
        """
        Constructs the Docker image URL for the specified version tag.
        
        Parameters:
            version (str): The version tag to use in the Docker image URL.
        
        Returns:
            str: The full Docker image URL for the given version.
        """
        return f"ghcr.io/{self.repo_owner}/{self.repo_name}:{version}"
    
    def start_update(self, version: str) -> bool:
        """
        Pulls the specified Docker image version and restarts the application containers to apply the update.
        
        Initiates the update process by downloading the new Docker image, updating the Docker Compose configuration, and restarting the containers. Emits progress and completion events throughout the process. Returns True if the update succeeds, or False if any step fails.
         
        Parameters:
            version (str): The version tag of the Docker image to update to.
        
        Returns:
            bool: True if the update was successful, False otherwise.
        """
        try:
            Logger.info(f"UpdateManager: Starting update to version {version}")
            self.dispatch('on_update_progress', 0, "Starting update...")
            
            # Get the new Docker image URL
            image_url = self._get_docker_image_url(version)
            
            # Pull the new image
            self.dispatch('on_update_progress', 25, "Downloading new version...")
            pull_result = subprocess.run(
                ['docker', 'pull', image_url],
                capture_output=True,
                text=True,
                timeout=300  # 5 minutes timeout
            )
            
            if pull_result.returncode != 0:
                error_msg = f"Failed to pull Docker image: {pull_result.stderr}"
                Logger.error(f"UpdateManager: {error_msg}")
                self.dispatch('on_update_error', error_msg)
                return False
            
            self.dispatch('on_update_progress', 75, "Preparing to restart...")
            
            # Update docker-compose.yml to use the new version
            self._update_docker_compose(version)
            
            self.dispatch('on_update_progress', 90, "Restarting application...")
            
            # Restart the containers with the new image
            restart_result = subprocess.run(
                ['docker-compose', 'up', '-d'],
                capture_output=True,
                text=True,
                timeout=60
            )
            
            if restart_result.returncode != 0:
                error_msg = f"Failed to restart containers: {restart_result.stderr}"
                Logger.error(f"UpdateManager: {error_msg}")
                self.dispatch('on_update_error', error_msg)
                return False
            
            self.dispatch('on_update_progress', 100, "Update complete!")
            self.dispatch('on_update_complete', version)
            Logger.info(f"UpdateManager: Successfully updated to version {version}")
            return True
            
        except subprocess.TimeoutExpired:
            error_msg = "Update process timed out"
            Logger.error(f"UpdateManager: {error_msg}")
            self.dispatch('on_update_error', error_msg)
            return False
        except Exception as e:
            error_msg = f"Update failed: {e}"
            Logger.error(f"UpdateManager: {error_msg}")
            self.dispatch('on_update_error', error_msg)
            return False
    
    def _update_docker_compose(self, version: str):
        """
        Update the `docker-compose.yml` file to reference the specified Docker image version.
        
        If the compose file is present, replaces the image tag for the application's service with the new version. Logs a warning if the file is missing and logs an error if the update fails.
        """
        compose_file = 'docker-compose.yml'
        
        if not os.path.exists(compose_file):
            Logger.warning("UpdateManager: docker-compose.yml not found, skipping version update")
            return
        
        try:
            with open(compose_file, 'r') as f:
                content = f.read()
            
            # Replace the image tag with the new version
            # This is a simple replacement - in production you might want to use a YAML parser
            old_pattern = f"ghcr.io/{self.repo_owner}/{self.repo_name}:"
            new_image = f"ghcr.io/{self.repo_owner}/{self.repo_name}:{version}"
            
            # Find and replace the image line
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if old_pattern in line:
                    # Extract the service indentation
                    indent = len(line) - len(line.lstrip())
                    lines[i] = ' ' * indent + f"image: {new_image}"
                    break
            
            # Write back to file
            with open(compose_file, 'w') as f:
                f.write('\n'.join(lines))
                
            Logger.info(f"UpdateManager: Updated docker-compose.yml to use version {version}")
            
        except Exception as e:
            Logger.error(f"UpdateManager: Failed to update docker-compose.yml: {e}")
    
    def download_and_apply_update(self, version: str) -> bool:
        """
        Downloads and applies an update for the application using a Docker-based release package from GitHub.
        
        This method downloads a tar.gz update package for the specified version, extracts it, pulls the corresponding Docker image, runs an update script if present, and updates the Docker Compose configuration to use the new version. Progress and completion events are dispatched throughout the process. Returns True if the update is successfully applied, or False if any step fails.
        """
        try:
            Logger.info(f"UpdateManager: Starting Docker update to version {version}")
            self.dispatch('on_update_progress', 10, "Downloading update package...")
            
            # Download update package
            download_url = f"{self.api_base}/repos/{self.repo_owner}/{self.repo_name}/releases/download/{version}/trimix-analyzer-update-{version}.tar.gz"
            
            update_dir = "/tmp/trimix-update"
            os.makedirs(update_dir, exist_ok=True)
            
            # Download update package
            response = requests.get(download_url, stream=True, timeout=300)
            response.raise_for_status()
            
            update_file = f"{update_dir}/update.tar.gz"
            with open(update_file, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            self.dispatch('on_update_progress', 50, "Extracting update...")
            
            # Extract update package
            subprocess.run(['tar', '-xzf', update_file, '-C', update_dir], 
                         check=True, cwd=update_dir)
            
            self.dispatch('on_update_progress', 70, "Pulling new Docker image...")
            
            # Pull new Docker image
            image_name = f"ghcr.io/{self.repo_owner.lower()}/{self.repo_name.lower()}:{version}"
            result = subprocess.run(['docker', 'pull', image_name], 
                                  capture_output=True, text=True)
            
            if result.returncode != 0:
                raise Exception(f"Failed to pull Docker image: {result.stderr}")
            
            self.dispatch('on_update_progress', 90, "Applying update...")
            
            # Run update script
            update_script = f"{update_dir}/update.sh"
            if os.path.exists(update_script):
                os.chmod(update_script, 0o755)
                result = subprocess.run(['sudo', 'bash', update_script], 
                                      capture_output=True, text=True)
                
                if result.returncode != 0:
                    raise Exception(f"Update script failed: {result.stderr}")
            
            # Update docker-compose.yml to use new version
            self._update_compose_version(version)
            
            self.dispatch('on_update_progress', 100, "Update complete!")
            self.dispatch('on_update_complete', version)
            
            Logger.info(f"UpdateManager: Successfully updated to version {version}")
            return True
            
        except Exception as e:
            error_msg = f"Failed to apply update: {str(e)}"
            Logger.error(f"UpdateManager: {error_msg}")
            self.dispatch('on_update_error', error_msg)
            return False
    
    def get_release_history(self, limit: int = 10) -> List[Dict]:
        """
        Retrieve a list of recent GitHub release entries for the configured repository.
        
        Parameters:
        	limit (int): The maximum number of releases to retrieve.
        
        Returns:
        	List[Dict]: A list of dictionaries containing release version, name, notes, publish date, and prerelease status. Returns an empty list if retrieval fails.
        """
        try:
            url = f"{self.api_base}/repos/{self.repo_owner}/{self.repo_name}/releases"
            params = {'per_page': limit}
            
            response = requests.get(url, params=params, timeout=self.timeout)
            response.raise_for_status()
            
            releases = response.json()
            
            return [{
                'version': release['tag_name'],
                'name': release['name'],
                'notes': release['body'],
                'published_at': release['published_at'],
                'is_prerelease': release['prerelease']
            } for release in releases]
            
        except Exception as e:
            Logger.error(f"UpdateManager: Failed to get release history: {e}")
            return []
    
    def should_check_for_updates(self) -> bool:
        """
        Determine whether the automatic update check interval has elapsed.
        
        Returns:
            bool: True if enough time has passed since the last update check or if no previous check has occurred; False otherwise.
        """
        if self.last_check_time is None:
            return True
        
        time_since_check = (datetime.now() - self.last_check_time).total_seconds()
        return time_since_check >= self.auto_check_interval
    
    # Event methods
    def on_update_available(self, update_info):
        """
        Event handler invoked when a new update is detected.
        
        Parameters:
            update_info (dict): Information about the available update, including version and release details.
        """
        pass
    
    def on_update_check_complete(self, update_available, update_info):
        """
        Event handler called when an update check has finished.
        
        Parameters:
            update_available (bool): Indicates whether a new update is available.
            update_info (dict): Information about the update if available, otherwise None.
        """
        pass
    
    def on_update_progress(self, progress, message):
        """
        Event handler called to report progress updates during the update process.
        
        Parameters:
            progress (float): The current progress as a value between 0 and 1.
            message (str): A descriptive message about the current update step.
        """
        pass
    
    def on_update_complete(self, version):
        """
        Event handler called when an update has been successfully completed.
        
        Parameters:
            version (str): The version number of the update that was applied.
        """
        pass
    
    def on_update_error(self, error_message):
        """
        Event handler called when an update error occurs.
        
        Parameters:
            error_message (str): Description of the error encountered during the update process.
        """
        pass


# Global update manager instance
_update_manager = None

def get_update_manager() -> UpdateManager:
    """
    Returns the singleton instance of the UpdateManager, creating it if it does not already exist.
    """
    global _update_manager
    if _update_manager is None:
        _update_manager = UpdateManager()
    return _update_manager
