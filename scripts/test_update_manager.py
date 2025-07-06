#!/usr/bin/env python3
"""
Test script for the update manager functionality.
"""

import sys
import os

# Add the project root to Python path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from utils.update_manager import UpdateManager

def test_update_manager():
    """Test the update manager functionality."""
    print("Testing Update Manager...")
    
    # Create update manager
    um = UpdateManager()
    
    print(f"Repository: {um.repo_owner}/{um.repo_name}")
    print(f"Current version: {um.current_version}")
    
    # Test version comparison
    print("\nTesting version comparison:")
    test_cases = [
        ("0.1.0", "0.1.1", -1),
        ("0.1.1", "0.1.0", 1),
        ("0.1.0", "0.1.0", 0),
        ("0.1.0", "0.2.0", -1),
        ("1.0.0", "0.9.9", 1),
    ]
    
    for v1, v2, expected in test_cases:
        result = um.compare_versions(v1, v2)
        status = "✅" if result == expected else "❌"
        print(f"{status} {v1} vs {v2}: {result} (expected {expected})")
    
    # Test update check
    print("\nChecking for updates...")
    try:
        update_info = um.check_for_updates()
        if update_info:
            print(f"✅ Update available: {update_info['version']}")
            print(f"   Release name: {update_info['name']}")
            print(f"   Published: {update_info['published_at']}")
            print(f"   Download URL: {update_info['download_url']}")
        else:
            print("✅ No updates available (you're up to date)")
    except Exception as e:
        print(f"❌ Update check failed: {e}")
    
    # Test release history
    print("\nGetting release history...")
    try:
        history = um.get_release_history(limit=3)
        if history:
            print("✅ Release history:")
            for release in history:
                print(f"   - {release['version']} ({release['published_at'][:10]}): {release['name']}")
        else:
            print("❌ No release history found")
    except Exception as e:
        print(f"❌ Failed to get release history: {e}")

if __name__ == '__main__':
    test_update_manager()
