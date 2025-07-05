# Display Settings - Brightness Control & Sleep Timeout

## Features
- **Brightness Control:**
  - Drag slider to adjust screen brightness (10% - 100%)
  - Real-time brightness adjustment
  - Quick preset buttons (25%, 50%, 75%, 100%)
  - Automatic detection of current brightness level
  - Visual brightness level indicator

- **Sleep Timeout:**
  - Set when the screen should go to sleep
  - Options: 1 min, 2 min, 5 min, 10 min, Never
  - Uses X11 screen saver and DPMS settings
  - Current timeout displayed prominently

## Setup for Brightness Control

### Method 1: Automatic Setup (Recommended)
Run the setup script once as root:
```bash
sudo ./setup_brightness_permissions.sh
```
Then reboot or log out/in for the changes to take effect.

### Method 2: Manual Setup
1. Add your user to the video group:
   ```bash
   sudo usermod -a -G video $USER
   ```

2. Create udev rule for automatic permissions:
   ```bash
   sudo nano /etc/udev/rules.d/99-backlight.rules
   ```
   Add these lines:
   ```
   SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
   SUBSYSTEM=="backlight", ACTION=="add", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
   ```

3. Apply permissions to current backlight devices:
   ```bash
   sudo chgrp video /sys/class/backlight/*/brightness
   sudo chmod g+w /sys/class/backlight/*/brightness
   ```

4. Reboot or log out/in.

## Supported Brightness Control Methods

The display settings screen automatically detects and uses the best available method:

1. **Hardware Backlight Control** (Primary method)
   - Uses `/sys/class/backlight/*/brightness` files
   - Direct hardware control for best performance
   - Detected backlight devices: 11-0045, rpi_backlight, 10-0045

2. **X11 Display Control** (Fallback method)
   - Uses `xrandr --output <display> --brightness <value>`
   - Software-based brightness adjustment
   - Works when hardware backlight control is not available

## Troubleshooting

### Brightness not changing:
1. Check if you're in the video group: `groups $USER`
2. Check backlight permissions: `ls -la /sys/class/backlight/*/brightness`
3. Run the setup script: `sudo ./setup_brightness_permissions.sh`
4. Reboot the system

### Permission denied errors:
- The app will automatically try to use `sudo` if direct access fails
- For best experience, run the setup script to avoid sudo prompts

## Technical Details

- Brightness values are stored as percentages (10-100%)
- Hardware brightness is mapped to the device's native range
- Changes are applied with a 200ms delay to prevent excessive system calls
- Current brightness is automatically loaded when entering the screen
