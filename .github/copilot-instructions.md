# Trimix Analyzer - GitHub Copilot Instructions

Trimix Analyzer is a Python-based Raspberry Pi gas analyzer for diving trimix gas mixtures, built with Kivy GUI framework, featuring real-time O2, CO2, temperature, pressure, and humidity monitoring with a touch-friendly interface.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Bootstrap Environment
- **CRITICAL**: Set required environment variables before any testing or development:
  ```bash
  export TRIMIX_ENVIRONMENT=development  # or test, production
  export TRIMIX_MOCK_SENSORS=1          # enables mock sensors for dev/testing
  ```

### Dependencies and Setup
- Install base dependencies:
  ```bash
  make install  # Takes 25-60 seconds or may timeout due to network. NEVER CANCEL. Set timeout to 120+ seconds.
  ```
- Alternative manual setup:
  ```bash
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -r requirements-base.txt
  pip install https://github.com/kivy-garden/graph/archive/master.zip
  ```

### Development Commands
- Launch development environment (GUI):
  ```bash
  make dev  # NEVER CANCEL. Takes 5-10 seconds to start, requires X11 display.
  ```
- Quick core functionality test:
  ```bash
  make run  # Runs on Raspberry Pi (production-like, native)
  ```
- Clean environment:
  ```bash
  make clean  # Removes .venv and cache files
  ```

### Testing
- **CRITICAL**: Always set environment variables before testing:
  ```bash
  export TRIMIX_ENVIRONMENT=test
  export TRIMIX_MOCK_SENSORS=1
  ```
- Run all tests:
  ```bash
  make test  # NEVER CANCEL. Takes 30-60 seconds. Set timeout to 120+ seconds.
  ```
- Alternative test runners:
  ```bash
  python test_runner.py --smoke    # Quick smoke tests (5 seconds)
  python test_runner.py --unit     # Unit tests only
  python test_runner.py --quick    # Fast tests without slow markers
  python run_tests.py --all -v     # Comprehensive tests with verbose output
  ```
- **TIMING EXPECTATIONS**:
  - Core functionality tests: 0.1 seconds
  - Smoke tests: 5 seconds  
  - Full test suite: 30-60 seconds
  - **NEVER CANCEL** any test command - they complete quickly

### Build and CI Validation
- Run local CI checks:
  ```bash
  chmod +x scripts/run-ci-checks.sh
  ./scripts/run-ci-checks.sh  # NEVER CANCEL. Takes 60-120 seconds. Set timeout to 180+ seconds.
  ```
- Manual validation steps:
  ```bash
  # Test core components individually
  python -c "from utils.platform_detector import get_platform_info; print(get_platform_info())"
  python -c "from utils.sensor_interface import get_sensors, get_readings; sensors = get_sensors(); print(get_readings())"
  python -c "from utils.database_manager import db_manager; db_manager.set_setting('test', 'key', 'value'); print(db_manager.get_setting('test', 'key'))"
  ```

## Critical Development Notes

### Environment Requirements
- **Python**: 3.9+ (tested with 3.11, 3.12)
- **GUI Requirements**: X11 display for `make dev` (use Xvfb for headless CI)
- **Mock vs Real Sensors**: Always use `TRIMIX_MOCK_SENSORS=1` for development and testing
- **Virtual Environment**: Required - all commands assume `.venv` is activated

### Headless Testing (CI/CD)
- **DO NOT** attempt to run GUI commands (`make dev`, `main.py`) in headless environments
- Use test runners and core functionality tests instead
- For CI with GUI testing, setup virtual display:
  ```bash
  sudo apt-get install -y xvfb libgl1-mesa-dev libglib2.0-0 libmtdev1
  export DISPLAY=:99.0
  Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
  sleep 2
  ```

### Timeout Guidelines
- **Environment Setup**: 60+ seconds timeout
- **Testing**: 120+ seconds timeout  
- **CI Checks**: 180+ seconds timeout
- **GUI Startup**: 10+ seconds timeout (will fail without display)
- **NEVER CANCEL** any build or test commands

## Validation Scenarios

### Always Test After Making Changes
1. **Core Functionality Test** (headless safe):
   ```bash
   export TRIMIX_ENVIRONMENT=test && export TRIMIX_MOCK_SENSORS=1
   python -c "
   from utils.platform_detector import get_platform_info
   from utils.sensor_interface import get_sensors, get_readings  
   from utils.database_manager import db_manager
   print('Platform:', get_platform_info()['system'])
   print('Sensors working:', len(get_readings()) > 0)
   db_manager.set_setting('test', 'validation', 'success')
   print('Database working:', db_manager.get_setting('test', 'validation') == 'success')
   print('✅ Core functionality validation passed')
   "
   ```

2. **Import Validation** (requires X11 display - will fail in headless CI):
   ```bash
   # Only run with display available
   python -c "from main import TrimixApp; app = TrimixApp(); print('App import successful')"
   ```

3. **Test Suite Validation** (headless environments):
   ```bash
   # NOTE: Built-in smoke tests fail in headless - use core functionality test instead
   python test_runner.py --smoke  # Fails without X11 display
   # Use this instead for headless validation:
   # Run the core functionality test above
   ```

### Manual Testing Scenarios (with display)
- Launch application: `make dev`
- Verify GUI loads with 480x800 portrait display emulation
- Check sensor readings update in real-time
- Test navigation between screens (Home, Analyze, Settings)
- Verify calibration and settings persistence

## Common Issues and Solutions

### GUI Won't Start
- **Missing X11**: Expected in headless environments - use test runners instead
- **libmtdev.so.1 missing**: Non-critical warning, GUI still works with X11
- **Permission denied on scripts**: Run `chmod +x scripts/*.sh`

### Testing Issues  
- **pytest not found**: Run `pip install -r requirements-dev.txt` (may timeout, retry)
- **Import errors**: Ensure `TRIMIX_ENVIRONMENT=test` and `TRIMIX_MOCK_SENSORS=1` are set
- **Database errors**: Check write permissions in home directory for `.trimix_data.db`

### Network Timeouts
- **pip install failures**: Common in CI environments due to network timeouts - document as expected failure
- **make install may timeout**: Network-dependent, can take 25-60 seconds or fail with timeout
- **Workaround**: Use pre-installed environments or retry with better network connection
- **GitHub API limits**: Update manager may fail - not critical for development

## Key Repository Structure

```
trimix-analysator/
├── main.py                    # Application entry point
├── version.py                 # Version info (auto-managed by CI/CD)
├── Makefile                   # Development commands (make dev, make test, etc.)
├── requirements-base.txt      # Core UI dependencies (Kivy)
├── requirements-dev.txt       # Development tools + testing
├── app.kv                     # Main UI layout
├── screens/                   # UI screens (analyze.py, home.py, settings/)
├── utils/                     # Core utilities
│   ├── sensor_interface.py    # Hardware abstraction layer
│   ├── platform_detector.py   # Environment detection
│   ├── database_manager.py    # Settings storage
│   └── sensors.py             # Legacy sensor code
├── widgets/                   # Custom UI components
├── tests/                     # Test suite (pytest with markers)
├── scripts/                   # Development and deployment scripts
└── .github/workflows/         # CI/CD automation
```

## Quick Reference Commands

```bash
# Essential workflow
make install                    # Setup environment (25s)
export TRIMIX_ENVIRONMENT=test && export TRIMIX_MOCK_SENSORS=1
# Quick validation (headless safe):
python -c "from utils.sensor_interface import get_readings; print('Readings:', get_readings())"
make dev                       # Launch GUI (needs display)

# Testing (headless environments)
python -c "from utils.platform_detector import get_platform_info; print(get_platform_info())"
# Note: python test_runner.py --smoke fails without display

# Testing (with display)
python test_runner.py --unit   # Unit tests only
python test_runner.py --all -c # All tests with coverage
./scripts/run-ci-checks.sh     # Full CI validation (60-120s)

# Core validation (always works)
python -c "from utils.sensor_interface import get_readings; print('Readings:', get_readings())"
python -c "from utils.platform_detector import get_platform_info; info = get_platform_info(); print(f'Platform: {info[\"system\"]}, Machine: {info[\"machine\"]}, Development: {info[\"is_development\"]}')"
```

## Development Best Practices

- **Always run core functionality tests** before committing changes (headless safe)
- **Set environment variables** for consistent testing behavior  
- **Use mock sensors** for all development and testing (TRIMIX_MOCK_SENSORS=1)
- **Test core functionality** in headless environments before GUI testing
- **GUI testing requires X11 display** - built-in smoke tests will fail in headless CI
- **Respect timeouts** - builds are fast but network may be slow
- **Check CI workflow** (.github/workflows/tests.yml) for complete validation pipeline

## CI/CD Integration

The repository includes automated CI/CD with GitHub Actions:
- **Fast tests**: Run on every PR (unit tests, linting)
- **Comprehensive tests**: Run on main branch (all tests + coverage)
- **Security checks**: Bandit, Safety scans
- **Auto-release**: Semantic versioning based on commit messages
- **Multi-platform**: Tests run on Ubuntu with Xvfb for GUI testing

Always ensure your changes pass local validation before pushing to avoid CI failures.