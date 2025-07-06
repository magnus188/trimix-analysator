#!/usr/bin/env python3
"""
Version management script for Trimix Analyzer.
Use this script to bump versions and prepare releases.
"""

import os
import re
import sys
import subprocess
from datetime import datetime
from typing import Tuple


def get_current_version() -> str:
    """Get the current version from version.py"""
    with open('version.py', 'r') as f:
        content = f.read()
    
    match = re.search(r'__version__ = ["\']([^"\']+)["\']', content)
    if match:
        return match.group(1)
    else:
        raise ValueError("Could not find version in version.py")


def parse_version(version: str) -> Tuple[int, int, int]:
    """Parse a semantic version string into components."""
    parts = version.split('.')
    if len(parts) != 3:
        raise ValueError(f"Invalid version format: {version}")
    
    return int(parts[0]), int(parts[1]), int(parts[2])


def increment_version(version: str, part: str) -> str:
    """Increment a specific part of the version."""
    major, minor, patch = parse_version(version)
    
    if part == 'major':
        major += 1
        minor = 0
        patch = 0
    elif part == 'minor':
        minor += 1
        patch = 0
    elif part == 'patch':
        patch += 1
    else:
        raise ValueError(f"Invalid version part: {part}")
    
    return f"{major}.{minor}.{patch}"


def update_version_file(new_version: str, description: str = None):
    """Update the version.py file with a new version."""
    major, minor, patch = parse_version(new_version)
    
    with open('version.py', 'r') as f:
        content = f.read()
    
    # Update version string
    content = re.sub(
        r'__version__ = ["\'][^"\']+["\']',
        f'__version__ = "{new_version}"',
        content
    )
    
    # Update version info tuple
    content = re.sub(
        r'__version_info__ = \([^)]+\)',
        f'__version_info__ = ({major}, {minor}, {patch})',
        content
    )
    
    # Add new version to history if description provided
    if description:
        today = datetime.now().strftime('%Y-%m-%d')
        history_entry = f'''    "{new_version}": {{
        "release_date": "{today}",
        "description": "{description}",
        "features": [
            # Add features here
        ]
    }},'''
        
        # Insert new version at the beginning of VERSION_HISTORY
        content = re.sub(
            r'(VERSION_HISTORY = \{\n)',
            f'\\1{history_entry}\n',
            content
        )
    
    with open('version.py', 'w') as f:
        f.write(content)
    
    print(f"Updated version to {new_version}")


def create_git_tag(version: str):
    """Create a git tag for the version."""
    tag_name = f"v{version}"
    
    try:
        # Check if tag already exists
        result = subprocess.run(['git', 'tag', '-l', tag_name], capture_output=True, text=True)
        if tag_name in result.stdout:
            print(f"Tag {tag_name} already exists!")
            return
        
        # Create annotated tag
        subprocess.run(['git', 'tag', '-a', tag_name, '-m', f'Release version {version}'], check=True)
        print(f"Created git tag: {tag_name}")
        
        # Ask if user wants to push
        push = input("Push tag to origin? (y/N): ").lower().strip()
        if push == 'y':
            subprocess.run(['git', 'push', 'origin', tag_name], check=True)
            print(f"Pushed tag {tag_name} to origin")
        
    except subprocess.CalledProcessError as e:
        print(f"Git error: {e}")
    except FileNotFoundError:
        print("Git not found. Please install git or create tag manually.")


def main():
    """Main function."""
    if len(sys.argv) < 2:
        print("Usage: python version_manager.py <command> [args]")
        print("Commands:")
        print("  current                    - Show current version")
        print("  bump <major|minor|patch>   - Bump version and create tag")
        print("  set <version>              - Set specific version")
        print("  tag                        - Create git tag for current version")
        return
    
    command = sys.argv[1]
    
    try:
        if command == 'current':
            current = get_current_version()
            print(f"Current version: {current}")
        
        elif command == 'bump':
            if len(sys.argv) < 3:
                print("Usage: python version_manager.py bump <major|minor|patch>")
                return
            
            part = sys.argv[2]
            current = get_current_version()
            new_version = increment_version(current, part)
            
            description = input(f"Description for v{new_version}: ").strip()
            if not description:
                description = f"Version {new_version} release"
            
            update_version_file(new_version, description)
            create_git_tag(new_version)
        
        elif command == 'set':
            if len(sys.argv) < 3:
                print("Usage: python version_manager.py set <version>")
                return
            
            new_version = sys.argv[2]
            description = input(f"Description for v{new_version}: ").strip()
            if not description:
                description = f"Version {new_version} release"
            
            update_version_file(new_version, description)
            create_git_tag(new_version)
        
        elif command == 'tag':
            current = get_current_version()
            create_git_tag(current)
        
        else:
            print(f"Unknown command: {command}")
    
    except Exception as e:
        print(f"Error: {e}")


if __name__ == '__main__':
    main()
