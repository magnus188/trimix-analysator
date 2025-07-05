"""
KV File loader and manager for the Trimix application.
Handles automatic discovery and loading of KV files with error handling.
"""

import os
import glob
from typing import List, Dict
from kivy.lang import Builder
from kivy.logger import Logger


class KVLoader:
    """Manages loading of KV files for the Trimix application"""
    
    def __init__(self, base_path: str):
        self.base_path = base_path
        self.loaded_files: List[str] = []
        self.failed_files: List[str] = []
    
    def load_all_kv_files(self) -> Dict[str, bool]:
        """
        Load all KV files in the application.
        
        Returns:
            Dict mapping file paths to success status
        """
        results = {}
        
        # Define loading order - some files need to be loaded before others
        load_order = [
            'widgets',      # Load widgets first
            'screens',      # Then basic screens
            'screens/settings',  # Then settings screens
            '.'             # Finally, root level files
        ]
        
        for directory in load_order:
            dir_results = self._load_directory(directory)
            results.update(dir_results)
        
        # Load main app.kv last
        app_kv_path = os.path.join(self.base_path, 'app.kv')
        if os.path.exists(app_kv_path):
            results[app_kv_path] = self._load_file(app_kv_path)
        
        self._log_results(results)
        return results
    
    def _load_directory(self, directory: str) -> Dict[str, bool]:
        """Load all KV files in a specific directory"""
        results = {}
        
        if directory == '.':
            kv_path = self.base_path
        else:
            kv_path = os.path.join(self.base_path, directory)
        
        if not os.path.exists(kv_path):
            Logger.warning(f"KVLoader: Directory {kv_path} does not exist")
            return results
        
        # Get all .kv files in directory (not recursive for subdirectories)
        if directory == '.':
            pattern = os.path.join(kv_path, '*.kv')
        else:
            pattern = os.path.join(kv_path, '*.kv')
            
        kv_files = glob.glob(pattern)
        
        # Sort for consistent loading order
        for kv_file in sorted(kv_files):
            # Skip app.kv as it's loaded separately
            if os.path.basename(kv_file) == 'app.kv':
                continue
                
            results[kv_file] = self._load_file(kv_file)
        
        return results
    
    def _load_file(self, file_path: str) -> bool:
        """Load a single KV file"""
        try:
            Logger.info(f"KVLoader: Loading {file_path}")
            Builder.load_file(file_path)
            self.loaded_files.append(file_path)
            return True
            
        except Exception as e:
            Logger.error(f"KVLoader: Failed to load {file_path}: {e}")
            self.failed_files.append(file_path)
            return False
    
    def _log_results(self, results: Dict[str, bool]):
        """Log loading results summary"""
        total_files = len(results)
        successful = sum(1 for success in results.values() if success)
        failed = total_files - successful
        
        Logger.info(f"KVLoader: Loaded {successful}/{total_files} KV files successfully")
        
        if failed > 0:
            Logger.warning(f"KVLoader: {failed} files failed to load:")
            for file_path, success in results.items():
                if not success:
                    Logger.warning(f"  - {file_path}")
    
    def reload_file(self, file_path: str) -> bool:
        """Reload a specific KV file (useful for development)"""
        if file_path in self.loaded_files:
            # Builder doesn't have an unload method, so we need to track changes
            Logger.warning(f"KVLoader: Reloading {file_path} (may cause issues)")
        
        return self._load_file(file_path)
    
    def get_loaded_files(self) -> List[str]:
        """Get list of successfully loaded files"""
        return self.loaded_files.copy()
    
    def get_failed_files(self) -> List[str]:
        """Get list of files that failed to load"""
        return self.failed_files.copy()


def create_kv_loader(base_path: str) -> KVLoader:
    """Factory function to create a KV loader"""
    return KVLoader(base_path)
