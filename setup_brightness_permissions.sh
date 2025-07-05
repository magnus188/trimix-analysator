#!/bin/bash
# Setup script for display brightness control
# Run this once with: sudo bash setup_brightness_permissions.sh

echo "Setting up brightness control permissions..."

# Create udev rule for backlight control
cat > /etc/udev/rules.d/99-backlight.rules << EOF
# Allow users in the 'video' group to control backlight
SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF

# Add current user to video group
usermod -a -G video $SUDO_USER

# Apply permissions to existing backlight devices
for backlight in /sys/class/backlight/*/brightness; do
    if [ -f "$backlight" ]; then
        chgrp video "$backlight"
        chmod g+w "$backlight"
        echo "Set permissions for $backlight"
    fi
done

echo "Brightness control setup complete!"
echo "Please reboot or log out/in for group changes to take effect."
echo "After that, the Trimix app should be able to control brightness without sudo."
