# Trimix Analyzer

A gas analyzer for trimix diving gas mixtures, featuring real-time O2, CO2, temperature, pressure, and humidity monitoring with a touch-friendly interface.

## 🔄 **NEW: ESP32 Version Available!**

This project now includes an **ESP32 implementation** alongside the original Raspberry Pi version:

- **[ESP32 Version](esp32/)** - Modern microcontroller implementation with LVGL GUI
- **[Raspberry Pi Version](#raspberry-pi-version)** - Original Python/Kivy implementation

| Feature | ESP32 Version | Raspberry Pi Version |
|---------|---------------|---------------------|
| **Display** | 800x480 capacitive touch | 480x800 resistive touch |
| **Framework** | C++ / LVGL | Python / Kivy |
| **Boot Time** | <5 seconds | ~30 seconds |
| **Power** | ~300mA @ 5V | ~2A @ 5V |
| **Cost** | ~$50 | ~$150 |
| **Portability** | Compact, embedded | Larger, full computer |

---

## Raspberry Pi Version

## 🔄 Auto-Release System

This project features **automatic release creation** when Pull Requests are merged into `main`:

- **Smart Version Bumping**: Analyzes commit messages and PR labels to determine version bump type
- **Automated Testing**: Runs comprehensive tests before release creation  
- **GitHub Releases**: Automatically creates releases with changelogs
- **Built-in Updates**: Applications can auto-update from GitHub releases

See [docs/AUTO_RELEASE.md](docs/AUTO_RELEASE.md) for detailed information.

### Quick Examples
```bash
# Patch release (1.0.0 → 1.0.1)
git commit -m "fix: resolve sensor calibration issue"

# Minor release (1.0.0 → 1.1.0)
git commit -m "feat: add new temperature sensor support" 

# Major release (1.0.0 → 2.0.0)
git commit -m "BREAKING CHANGE: new sensor interface API"
```

## 🏗️ Architecture

- **UI Framework**: Kivy (touch-friendly interface)
- **Hardware**: Raspberry Pi with I2C sensors (ADS1115, BME280)
- **Deployment**: Docker containers for consistent environments
- **Development**: Multi-platform support (Mac, RPi 5, RPi Zero 2W)

## 🚀 Quick Start

### Choose Your Platform

#### ESP32 Version (Recommended for new builds)
```bash
# See esp32/README.md for detailed instructions
cd esp32/
idf.py set-target esp32s3
idf.py build flash monitor
```

#### Raspberry Pi Version (Original implementation)

### Development (Recommended - Native GUI)

```bash
# Clone the repository
git clone https://github.com/magnustrandokken/trimix-analysator.git
cd trimix-analysator

# NPM-style commands using Make
make dev           # 🎮 Start development server (RPi emulation)
make run           # 🏃 Quick run without env setup
make install       # 📦 Install dependencies
make clean         # 🧹 Clean up virtual environment
make test          # 🧪 Run tests
make help          # ❓ Show all available commands

# Simple one-command startup (emulates 4.3" 480x800 RPi display)
make dev

# Or manually:
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-base.txt
pip install https://github.com/kivy-garden/graph/archive/master.zip
export TRIMIX_ENVIRONMENT=development TRIMIX_MOCK_SENSORS=1
python main.py
```

**Display Emulation**: The development window exactly matches the 4.3 inch 480x800 portrait display used on the Raspberry Pi hardware, ensuring pixel-perfect UI development.

### Testing (Docker - Headless)

```bash
# Run tests in Docker container
docker-compose -f docker-compose.dev.yml up

# Interactive shell for debugging
docker-compose -f docker-compose.dev.yml run trimix-dev-shell
```

### Testing on Raspberry Pi 5

```bash
# SSH into your RPi 5
ssh pi@raspberrypi5.local

# Clone and run
git clone https://github.com/magnustrandokken/trimix-analysator.git
cd trimix-analysator
docker-compose up

# Or deploy from Mac using Make
make deploy-dev    # 🚢 Deploy to RPi 5 (staging)
```

### Production on Raspberry Pi Zero 2W

```bash
# One-time setup
make setup-rpi     # ⚙️ Setup production environment

# Or manually
sudo bash scripts/setup-production.sh
sudo reboot

# System will boot directly into the Trimix Analyzer
```

## 📋 Requirements

### Hardware Requirements

#### For Development (Mac)
- Docker Desktop
- 4GB+ RAM
- Git

#### For Raspberry Pi Testing/Production
- Raspberry Pi 4/5 (development) or Zero 2W (production)
- MicroSD card (16GB+)
- **Sensors:**
  - ADS1115 16-bit ADC (I2C address: 0x48)
  - BME280 temperature/pressure/humidity sensor (I2C address: 0x76/0x77)
  - O2 sensor (analog, connected to ADS1115 channel 0)
  - CO2 sensor (analog, connected to ADS1115 channel 1)
  - Power button (GPIO 18)

#### Wiring Diagram
```
Raspberry Pi <-> Sensors
GPIO 2 (SDA) <-> ADS1115 SDA, BME280 SDA
GPIO 3 (SCL) <-> ADS1115 SCL, BME280 SCL
GPIO 18      <-> Power Button (with pull-up)
3.3V         <-> Sensor VCC
GND          <-> Sensor GND
```

### Software Requirements

- **Docker** (recommended) or Python 3.11+
- **Git** for version control
- **SSH access** for remote deployment

## 🐳 Docker Setup

### Environment Files

The project uses environment-specific requirements:

- `requirements-base.txt` - Core UI dependencies (Kivy)
- `requirements-dev.txt` - Development tools + testing
- `requirements-rpi.txt` - Hardware libraries for Raspberry Pi

### Docker Compose Files

- `docker-compose.dev.yml` - Development environment (mock sensors)
- `docker-compose.yml` - Production environment (real hardware)

## 🛠️ Development Workflow

### Available Commands

Use the new Makefile commands for streamlined development:

```bash
make help          # Show all available commands
make dev           # Start development environment (RPi emulation)
make run           # Quick run without environment setup
make install       # Install dependencies in virtual environment
make clean         # Clean up virtual environment and cache
make test          # Run tests
make deploy-dev    # Deploy to RPi 5 (staging)
make deploy-prod   # Deploy to RPi Zero (production)
make setup-rpi     # Setup production environment on RPi
```

### 1. Local Development (Mac)

```bash
# Start development environment
make dev

# Or with Docker
docker-compose -f docker-compose.dev.yml up

# Features:
# ✅ Mock sensors (no hardware needed)
# ✅ Live code reload
# ✅ Same environment as production
# ✅ Fast iteration
```

### 2. Hardware Testing (RPi 5)

```bash
# Deploy from Mac
make deploy-dev

# Or manually on RPi 5
git pull origin develop
docker-compose up

# Features:
# ✅ Real sensor hardware
# ✅ Full GPIO access
# ✅ Production-like environment
```

### 3. Production Deployment (RPi Zero 2W)

```bash
# One-time setup
make setup-rpi

# Creates:
# ✅ Boot-to-app functionality
# ✅ Auto-restart on failure
# ✅ Systemd service
# ✅ Docker auto-start
```

## 📊 Monitoring & Health Checks

### Health Check

The application includes built-in health monitoring:

```bash
# Check container health
docker-compose exec trimix-analyzer python /usr/local/bin/healthcheck.py

# View logs
docker-compose logs -f trimix-analyzer

# Container status
docker-compose ps
```

### Health Check Components

- **Application Process**: Verifies main.py is running
- **Sensor Access**: Tests sensor communication
- **I2C Devices**: Validates hardware connectivity (production only)

## 🔧 Configuration

### Environment Variables

| Variable | Development | Production | Description |
|----------|-------------|------------|-------------|
| `TRIMIX_ENVIRONMENT` | `development` | `production` | Runtime environment |
| `TRIMIX_MOCK_SENSORS` | `1` | `0` | Use mock vs real sensors |

### Sensor Configuration

The application automatically detects the environment:

- **Mac/Development**: Uses mock sensors with realistic data
- **Raspberry Pi**: Uses real hardware sensors

Mock sensors simulate:
- O2: ~20.9% (with noise)
- CO2: ~400ppm (variable)
- Temperature: 20-25°C (daily cycle)
- Pressure: ~1013 hPa
- Humidity: 40-50%

## 📁 Project Structure

```
trimix-analysator/
├── main.py                     # Application entry point
├── app.kv                      # Main UI layout
├── Makefile                    # Development commands (make dev, make test, etc.)
├── Dockerfile                  # Multi-stage container build
├── docker-compose.yml          # Production deployment
├── docker-compose.dev.yml      # Development environment
├── requirements-*.txt          # Environment-specific dependencies
├── screens/                    # UI screens
│   ├── analyze.py             # Real-time sensor display
│   ├── home.py                # Main menu
│   ├── sensor_detail.py       # Individual sensor details
│   └── settings/              # Configuration screens
├── utils/                      # Core utilities
│   ├── sensor_interface.py    # Hardware abstraction layer
│   ├── platform_detector.py   # Environment detection
│   ├── sensors.py             # Legacy sensor code
│   └── database_manager.py    # Settings storage
├── widgets/                    # Custom UI components
├── scripts/                    # Deployment and setup scripts
│   ├── dev.sh                 # Development launcher
│   ├── healthcheck.py         # Container health monitoring
│   ├── setup-production.sh    # Production RPi setup
│   └── deploy-dev.sh          # Development deployment
└── tests/                      # Test suite
```

## 🧪 Testing

### Run Tests

```bash
# Using Make (recommended)
make test

# With Docker
docker-compose -f docker-compose.dev.yml exec trimix-dev pytest

# Natively
pip install -r requirements-dev.txt
export TRIMIX_MOCK_SENSORS=1
pytest tests/ -v
```

### Test Coverage

Tests include:
- Mock sensor functionality
- Platform detection
- Database operations
- Import validation
- Basic UI components

## 🏷️ Automated Versioning & Releases

This project uses **fully automated** version management and releases through GitHub CI/CD.

### 🤖 **How It Works**

1. **Development**: Work on feature branches, create PRs to `main`
2. **Automatic Version Bumping**: When PR is merged to `main`, CI/CD automatically:
   - Detects version bump type from commit message
   - Bumps version in `version.py`
   - Creates git tag
   - Builds and pushes Docker images
   - Creates GitHub release with PR description

### 📝 **Version Bump Types**

Control version bumping through your **commit messages** or **PR titles**:

```bash
# Patch version (0.1.0 → 0.1.1) - DEFAULT
git commit -m "fix: resolve sensor reading issue"
git commit -m "docs: update README"

# Minor version (0.1.0 → 0.2.0)
git commit -m "feat: add new calibration feature"
git commit -m "feature: implement WiFi setup wizard"

# Major version (0.1.0 → 1.0.0)
git commit -m "BREAKING CHANGE: redesign sensor interface"
git commit -m "major: complete API overhaul"
```

### 🔄 **Development Workflow**

```bash
# 1. Create feature branch
git checkout -b feature/awesome-feature

# 2. Make changes and commit
git commit -m "feat: add awesome feature"

# 3. Push and create PR
git push origin feature/awesome-feature
# Create PR on GitHub with descriptive title/description

# 4. Merge PR to main
# ✅ CI/CD automatically handles versioning and release!
```

### 📦 **What Happens Automatically**

When you merge to `main`:

1. **Tests Run**: Full test suite on multiple platforms
2. **Version Detection**: Analyzes commit message for bump type
3. **Version Bump**: Updates `version.py` automatically
4. **Docker Build**: Multi-platform images (ARM64, ARMv7, x86_64)
5. **Image Push**: To GitHub Container Registry
6. **Git Tag**: Creates `v0.1.1`, `v0.2.0`, etc.
7. **GitHub Release**: With your PR description as release notes
8. **Deployment**: (Optional) Auto-deploy to your Raspberry Pi

### 🎯 **Current Version**: `v0.1.0`

Check current version:
```bash
python -c "from version import __version__; print(__version__)"
```

### 🔄 **Automatic Updates**

The app includes an update manager that:
- ✅ Automatically checks GitHub releases
- ✅ Compares semantic versions correctly  
- ✅ Downloads new Docker images
- ✅ Restarts the application
- ✅ Shows update progress to users

Access via: **Settings → Update Settings**

### 🧹 **Workspace Stays Clean**

- ❌ No manual version bumping
- ❌ No manual tagging
- ❌ No manual release creation
- ✅ Just commit, PR, and merge!

## 🚀 CI/CD Pipeline

The project includes automated CI/CD with GitHub Actions:

### Automated Workflow

1. **Code Push** → GitHub
2. **CI Pipeline** → Tests, builds, multi-arch images
3. **Staging Deploy** → RPi 5 (develop branch)
4. **Production Deploy** → RPi Zero 2W (tagged releases)

### Manual Deployment

```bash
# Deploy to staging
make deploy-dev

# Deploy to production
make deploy-prod

# Create production release
git tag v1.0.0
git push --tags  # Triggers automatic production deployment
```

## 🔒 Security

- Non-root container user
- Minimal container image
- Hardware device isolation
- Environment-specific configurations

## 📚 API Reference

### Sensor Interface

```python
from utils.sensor_interface import get_sensors

sensors = get_sensors()  # Automatically detects mock vs real

# Read sensor values
o2_percent = sensors.read_oxygen_percent()
co2_ppm = sensors.read_co2_ppm()
temperature = sensors.read_temperature_c()
pressure = sensors.read_pressure_hpa()
humidity = sensors.read_humidity_pct()
button_pressed = sensors.is_power_button_pressed()
```

### Platform Detection

```python
from utils.platform_detector import is_raspberry_pi, is_development_environment

if is_raspberry_pi():
    print("Running on Raspberry Pi")

if is_development_environment():
    print("Using mock sensors")
```

## 🐛 Troubleshooting

### Common Issues

#### Mac Development
```bash
# Docker not starting
docker-compose -f docker-compose.dev.yml down
docker system prune -f
docker-compose -f docker-compose.dev.yml up --build

# Port conflicts
docker-compose -f docker-compose.dev.yml down
lsof -ti:5900 | xargs kill -9  # Kill VNC processes
```

#### Raspberry Pi
```bash
# I2C not working
sudo raspi-config  # Enable I2C
sudo reboot

# Permissions issues
sudo usermod -aG docker pi
sudo usermod -aG i2c pi
sudo reboot

# Container won't start
docker-compose down
docker system prune -f
docker-compose up --build
```

#### Sensor Issues
```bash
# Check I2C devices
i2cdetect -y 1

# Expected output:
#      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:          -- -- -- -- -- -- -- -- -- -- -- -- --
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 40: -- -- -- -- -- -- -- -- 48 -- -- -- -- -- -- --  # ADS1115
# 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
# 70: -- -- -- -- -- -- 76 --                          # BME280
```

### Log Analysis

```bash
# Application logs
docker-compose logs -f trimix-analyzer

# Health check logs
docker-compose exec trimix-analyzer python /usr/local/bin/healthcheck.py

# System logs (RPi)
journalctl -u trimix-analyzer.service -f
```

## 📄 License

[Add your license here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/magnustrandokken/trimix-analysator/issues)
- **Discussions**: [GitHub Discussions](https://github.com/magnustrandokken/trimix-analysator/discussions)

---

Built with ❤️ for the diving community
