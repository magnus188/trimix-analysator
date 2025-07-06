#!/usr/bin/env python3
"""
Automated test runner for continuous integration and development.
This script provides comprehensive testing capabilities including unit tests,
integration tests, performance tests, and code quality checks.
"""

import os
import sys
import argparse
import subprocess
from pathlib import Path


class TestRunner:
    """Main test runner class."""
    
    def __init__(self):
        self.project_root = Path(__file__).parent.parent
        self.setup_environment()
    
    def setup_environment(self):
        """Setup test environment."""
        os.environ['TRIMIX_MOCK_SENSORS'] = '1'
        os.environ['TRIMIX_ENVIRONMENT'] = 'test'
        
        # Add project root to Python path
        if str(self.project_root) not in sys.path:
            sys.path.insert(0, str(self.project_root))
    
    def run_command(self, command, description=""):
        """Run a command and return the result."""
        if description:
            print(f"🏃 {description}")
        
        print(f"Running: {' '.join(command)}")
        result = subprocess.run(command, capture_output=True, text=True)
        
        if result.stdout:
            print(result.stdout)
        if result.stderr:
            print(result.stderr)
        
        return result.returncode
    
    def check_dependencies(self):
        """Check if required dependencies are installed."""
        print("🔍 Checking dependencies...")
        
        required_packages = ['pytest', 'pytest-cov', 'black', 'flake8', 'isort']
        missing_packages = []
        
        for package in required_packages:
            result = subprocess.run(['python', '-c', f'import {package.replace("-", "_")}'], 
                                  capture_output=True)
            if result.returncode != 0:
                missing_packages.append(package)
        
        if missing_packages:
            print(f"❌ Missing packages: {', '.join(missing_packages)}")
            print("Install with: pip install -r requirements-dev.txt")
            return False
        
        print("✅ All dependencies are installed")
        return True
    
    def run_unit_tests(self, verbose=False, coverage=False):
        """Run unit tests."""
        command = ['python', '-m', 'pytest', 'tests/', '-m', 'unit and not slow']
        
        if verbose:
            command.append('-v')
        
        if coverage:
            command.extend(['--cov=.', '--cov-report=html:htmlcov', '--cov-report=term-missing'])
        
        return self.run_command(command, "Running unit tests")
    
    def run_integration_tests(self, verbose=False):
        """Run integration tests."""
        command = ['python', '-m', 'pytest', 'tests/', '-m', 'integration']
        
        if verbose:
            command.append('-v')
        
        return self.run_command(command, "Running integration tests")
    
    def run_all_tests(self, verbose=False, coverage=False):
        """Run all tests."""
        command = ['python', '-m', 'pytest', 'tests/']
        
        if verbose:
            command.append('-v')
        
        if coverage:
            command.extend(['--cov=.', '--cov-report=html:htmlcov', '--cov-report=term-missing'])
        
        return self.run_command(command, "Running all tests")
    
    def run_performance_tests(self):
        """Run performance tests."""
        command = ['python', '-m', 'pytest', 'tests/', '-m', 'slow', '--tb=short']
        
        return self.run_command(command, "Running performance tests")
    
    def run_linting(self):
        """Run code linting."""
        print("🔍 Running code quality checks...")
        
        results = []
        
        # Run black check
        black_result = self.run_command(['black', '--check', '--diff', '.'], "Checking code formatting with black")
        results.append(('black', black_result))
        
        # Run flake8
        flake8_result = self.run_command(['flake8', '.', '--count', '--statistics'], "Running flake8 linting")
        results.append(('flake8', flake8_result))
        
        # Run isort check
        isort_result = self.run_command(['isort', '--check-only', '--diff', '.'], "Checking import sorting with isort")
        results.append(('isort', isort_result))
        
        # Summary
        failed_checks = [name for name, result in results if result != 0]
        
        if failed_checks:
            print(f"❌ Failed checks: {', '.join(failed_checks)}")
            return 1
        else:
            print("✅ All code quality checks passed")
            return 0
    
    def run_security_check(self):
        """Run security checks."""
        print("🔒 Running security checks...")
        
        # Try to run safety check
        safety_result = subprocess.run(['safety', '--version'], capture_output=True)
        if safety_result.returncode == 0:
            safety_check = self.run_command(['safety', 'check'], "Running safety check")
        else:
            print("⚠️  Safety not installed, skipping safety check")
            safety_check = 0
        
        # Try to run bandit
        bandit_result = subprocess.run(['bandit', '--version'], capture_output=True)
        if bandit_result.returncode == 0:
            bandit_check = self.run_command(['bandit', '-r', '.', '--exit-zero'], "Running bandit security scan")
        else:
            print("⚠️  Bandit not installed, skipping bandit check")
            bandit_check = 0
        
        return max(safety_check, bandit_check)
    
    def fix_code_style(self):
        """Automatically fix code style issues."""
        print("🔧 Fixing code style...")
        
        # Run black to format code
        black_result = self.run_command(['black', '.'], "Formatting code with black")
        
        # Run isort to sort imports
        isort_result = self.run_command(['isort', '.'], "Sorting imports with isort")
        
        if black_result == 0 and isort_result == 0:
            print("✅ Code style fixed")
            return 0
        else:
            print("❌ Some issues could not be fixed automatically")
            return 1
    
    def run_basic_smoke_test(self):
        """Run basic smoke tests to verify the app can start."""
        print("💨 Running smoke tests...")
        
        smoke_tests = [
            ("Import main app", "from main import TrimixApp; app = TrimixApp(); print('✅ App import successful')"),
            ("Test database", "from utils.database_manager import db_manager; db_manager.set_setting('test', 'smoke', 'success'); result = db_manager.get_setting('test', 'smoke'); assert result == 'success'; print('✅ Database test passed')"),
            ("Test sensors", "from utils.sensor_interface import get_sensors, get_readings; sensors = get_sensors(); readings = get_readings(); assert isinstance(readings, dict); print('✅ Sensor test passed')"),
            ("Test platform detection", "from utils.platform_detector import get_platform_info, is_development_environment; info = get_platform_info(); assert isinstance(info, dict); assert is_development_environment() == True; print('✅ Platform detection test passed')")
        ]
        
        for test_name, test_code in smoke_tests:
            print(f"  Testing: {test_name}")
            result = subprocess.run(['python', '-c', test_code], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"    {result.stdout.strip()}")
            else:
                print(f"    ❌ {test_name} failed:")
                if result.stderr:
                    print(f"    Error: {result.stderr.strip()}")
                return 1
        
        print("✅ All smoke tests passed")
        return 0
    
    def generate_test_report(self):
        """Generate a comprehensive test report."""
        print("📊 Generating test report...")
        
        # Run tests with coverage
        coverage_result = self.run_command([
            'python', '-m', 'pytest', 'tests/', 
            '--cov=.', '--cov-report=html:htmlcov', '--cov-report=xml:coverage.xml', 
            '--cov-report=term-missing', '--tb=short'
        ], "Generating coverage report")
        
        if coverage_result == 0:
            print("✅ Test report generated in htmlcov/index.html")
        
        return coverage_result


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(description='Trimix Analyzer Test Runner')
    
    # Test type options
    parser.add_argument('--unit', action='store_true', help='Run unit tests only')
    parser.add_argument('--integration', action='store_true', help='Run integration tests only')
    parser.add_argument('--all', action='store_true', help='Run all tests')
    parser.add_argument('--performance', action='store_true', help='Run performance tests')
    parser.add_argument('--smoke', action='store_true', help='Run smoke tests only')
    
    # Quality checks
    parser.add_argument('--lint', action='store_true', help='Run linting checks')
    parser.add_argument('--security', action='store_true', help='Run security checks')
    parser.add_argument('--fix', action='store_true', help='Fix code style issues')
    
    # Options
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--coverage', '-c', action='store_true', help='Generate coverage report')
    parser.add_argument('--report', action='store_true', help='Generate comprehensive test report')
    parser.add_argument('--quick', action='store_true', help='Run quick tests (unit only, no slow tests)')
    parser.add_argument('--ci', action='store_true', help='Run in CI mode (all checks)')
    
    # Development options
    parser.add_argument('--check-deps', action='store_true', help='Check if dependencies are installed')
    
    args = parser.parse_args()
    
    runner = TestRunner()
    total_result = 0
    
    # Check dependencies first
    if args.check_deps or not any(vars(args).values()):
        if not runner.check_dependencies():
            return 1
    
    # Fix code style
    if args.fix:
        return runner.fix_code_style()
    
    # CI mode runs everything
    if args.ci:
        print("🚀 Running in CI mode - all checks")
        total_result += runner.run_linting()
        total_result += runner.run_security_check()
        total_result += runner.run_smoke_test()
        total_result += runner.run_all_tests(verbose=True, coverage=True)
    
    # Individual test types
    elif args.smoke:
        total_result += runner.run_basic_smoke_test()
    elif args.unit:
        total_result += runner.run_unit_tests(args.verbose, args.coverage)
    elif args.integration:
        total_result += runner.run_integration_tests(args.verbose)
    elif args.all:
        total_result += runner.run_all_tests(args.verbose, args.coverage)
    elif args.performance:
        total_result += runner.run_performance_tests()
    elif args.quick:
        total_result += runner.run_unit_tests(args.verbose, False)
    
    # Quality checks
    if args.lint:
        total_result += runner.run_linting()
    
    if args.security:
        total_result += runner.run_security_check()
    
    if args.report:
        total_result += runner.generate_test_report()
    
    # Default behavior
    if not any([args.unit, args.integration, args.all, args.performance, args.smoke, 
                args.lint, args.security, args.fix, args.report, args.ci, args.quick]):
        print("🎯 Running default test suite (unit tests + smoke tests)")
        total_result += runner.run_basic_smoke_test()
        total_result += runner.run_unit_tests(args.verbose, args.coverage)
    
    # Final result
    if total_result == 0:
        print("\n🎉 All tests passed!")
    else:
        print(f"\n💥 Some tests failed (exit code: {total_result})")
    
    return min(total_result, 1)  # Ensure exit code is 0 or 1


if __name__ == '__main__':
    sys.exit(main())
