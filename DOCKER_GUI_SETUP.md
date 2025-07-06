# Docker GUI Development Setup

This document explains how to run the Trimix Analyzer with Docker GUI support on both Mac and Linux.

## Prerequisites

### For Mac Development

1. **Install XQuartz** (X11 server for Mac):
   ```bash
   brew install --cask xquartz
   ```

2. **Configure XQuartz**:
   - Start XQuartz
   - Go to XQuartz → Preferences → Security
   - Check "Allow connections from network clients"
   - Restart XQuartz

3. **Install Docker Desktop** for Mac if not already installed

### For Linux Development

1. **Install Docker** and **Docker Compose** if not already installed
2. **No additional setup required** - X11 is natively supported

### For Raspberry Pi Production

1. **Install Docker** on the Raspberry Pi
2. **Enable GPU and display access** (already configured in docker-compose.yml)

## Development Commands

### Mac Development
```bash
# Run with Docker GUI support on Mac
make run-dev-mac
```

### Linux Development  
```bash
# Run with Docker GUI support on Linux
make run-dev-linux
```

### Native Development (Any Platform)
```bash
# Run with native Python (no Docker)
make dev
```

### Production (Raspberry Pi)
```bash
# Run production setup
make run
```

## What Each Command Does

### `make run-dev-mac`
- Builds Docker image with GUI libraries
- Sets up X11 forwarding through XQuartz
- Runs the application in a container with GUI support
- Uses mock sensors (no hardware required)
- Emulates 480x800 RPi display

### `make run-dev-linux`
- Builds Docker image with GUI libraries  
- Sets up X11 forwarding through native X11
- Runs the application in a container with GUI support
- Uses mock sensors (no hardware required)
- Emulates 480x800 RPi display

### `make dev`
- Runs natively with Python virtual environment
- Fastest development cycle (no Docker overhead)
- Direct access to your development tools

### `make run`
- Production Docker setup
- Requires actual RPi hardware devices
- Fullscreen mode with framebuffer access
- Real sensor integration

## Troubleshooting

### Mac Issues

**"XQuartz is not running" error:**
- Start XQuartz manually
- Ensure "Allow connections from network clients" is enabled
- Try restarting XQuartz

**GUI doesn't appear:**
- Check that XQuartz is running: `pgrep XQuartz`
- Verify DISPLAY variable: `echo $DISPLAY`
- Try running: `xhost +localhost` manually

**Connection refused errors:**
- Restart XQuartz
- Check firewall settings
- Ensure Docker Desktop is running

### Linux Issues

**Permission denied for X11:**
- Run: `xhost +local:docker`
- Check that $DISPLAY is set correctly

**GUI doesn't appear:**
- Verify X11 is running: `echo $DISPLAY`
- Check that you're not in a headless environment

### General Docker Issues

**Container won't start:**
- Check Docker daemon is running
- Try: `docker system prune` to clean up
- Rebuild with: `docker compose build --no-cache`

**GUI performance issues:**
- This is expected with Docker GUI forwarding
- Use `make dev` for better performance during development
- Docker GUI is mainly for testing the exact same environment as production

## Development Workflow

1. **Day-to-day development**: Use `make dev` (fastest)
2. **Test Docker compatibility**: Use `make run-dev-mac` or `make run-dev-linux`
3. **Final testing**: Use `make run` on actual Raspberry Pi
4. **Deploy**: Use production docker-compose.yml on RPi

The Docker development setup ensures your code will work in the production container environment while still allowing GUI testing on your development machine.
