"""
Test runner script for development.
Run tests locally with various options.
"""

import os
import sys
import subprocess
import argparse


def setup_test_environment():
    """Setup environment variables for testing."""
    os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    os.environ['TRIMIX_ENVIRONMENT'] = 'test'
    print("✅ Test environment configured")


def run_unit_tests(verbose=False, coverage=False):
    """Run unit tests."""
    cmd = ['pytest', 'tests/', '-m', 'unit']
    
    if verbose:
        cmd.append('-v')
    
    if coverage:
        cmd.extend(['--cov=.', '--cov-report=html', '--cov-report=term-missing'])
    
    print("🧪 Running unit tests...")
    return subprocess.run(cmd).returncode


def run_integration_tests(verbose=False):
    """Run integration tests."""
    cmd = ['pytest', 'tests/', '-m', 'integration']
    
    if verbose:
        cmd.append('-v')
    
    print("🔗 Running integration tests...")
    return subprocess.run(cmd).returncode


def run_all_tests(verbose=False, coverage=False):
    """Run all tests."""
    cmd = ['pytest', 'tests/']
    
    if verbose:
        cmd.append('-v')
    
    if coverage:
        cmd.extend(['--cov=.', '--cov-report=html', '--cov-report=term-missing'])
    
    print("🚀 Running all tests...")
    return subprocess.run(cmd).returncode


def run_specific_test(test_path, verbose=False):
    """Run a specific test file or test method."""
    cmd = ['pytest', test_path]
    
    if verbose:
        cmd.append('-v')
    
    print(f"🎯 Running specific test: {test_path}")
    return subprocess.run(cmd).returncode


def run_linting():
    """Run code linting."""
    print("🔍 Running code linting...")
    
    # Run black
    print("  Running black...")
    black_result = subprocess.run(['black', '--check', '.']).returncode
    
    # Run flake8
    print("  Running flake8...")
    flake8_result = subprocess.run(['flake8', '.']).returncode
    
    # Run isort
    print("  Running isort...")
    isort_result = subprocess.run(['isort', '--check-only', '.']).returncode
    
    if black_result == 0 and flake8_result == 0 and isort_result == 0:
        print("✅ All linting checks passed")
        return 0
    else:
        print("❌ Some linting checks failed")
        return 1


def run_security_check():
    """Run security checks."""
    print("🔒 Running security checks...")
    
    # Run safety check
    print("  Running safety check...")
    safety_result = subprocess.run(['safety', 'check']).returncode
    
    # Run bandit
    print("  Running bandit...")
    bandit_result = subprocess.run(['bandit', '-r', '.', '--exit-zero']).returncode
    
    return max(safety_result, bandit_result)


def run_performance_tests():
    """Run performance tests."""
    cmd = ['pytest', 'tests/', '-m', 'slow', '--benchmark-only']
    
    print("⚡ Running performance tests...")
    return subprocess.run(cmd).returncode


def fix_code_style():
    """Automatically fix code style issues."""
    print("🔧 Fixing code style...")
    
    # Run black to format code
    print("  Running black formatter...")
    subprocess.run(['black', '.'])
    
    # Run isort to sort imports
    print("  Running isort...")
    subprocess.run(['isort', '.'])
    
    print("✅ Code style fixed")


def main():
    """Main test runner."""
    parser = argparse.ArgumentParser(description='Trimix Analyzer Test Runner')
    parser.add_argument('--unit', action='store_true', help='Run unit tests only')
    parser.add_argument('--integration', action='store_true', help='Run integration tests only')
    parser.add_argument('--all', action='store_true', help='Run all tests')
    parser.add_argument('--lint', action='store_true', help='Run linting checks')
    parser.add_argument('--security', action='store_true', help='Run security checks')
    parser.add_argument('--performance', action='store_true', help='Run performance tests')
    parser.add_argument('--fix', action='store_true', help='Fix code style issues')
    parser.add_argument('--test', type=str, help='Run specific test file or method')
    parser.add_argument('--verbose', '-v', action='store_true', help='Verbose output')
    parser.add_argument('--coverage', '-c', action='store_true', help='Generate coverage report')
    parser.add_argument('--quick', action='store_true', help='Run quick tests (unit only, no slow tests)')
    
    args = parser.parse_args()
    
    # Setup test environment
    setup_test_environment()
    
    total_result = 0
    
    if args.fix:
        fix_code_style()
        return
    
    if args.lint:
        total_result += run_linting()
    
    if args.security:
        total_result += run_security_check()
    
    if args.unit:
        total_result += run_unit_tests(args.verbose, args.coverage)
    elif args.integration:
        total_result += run_integration_tests(args.verbose)
    elif args.all:
        total_result += run_all_tests(args.verbose, args.coverage)
    elif args.test:
        total_result += run_specific_test(args.test, args.verbose)
    elif args.performance:
        total_result += run_performance_tests()
    elif args.quick:
        # Quick test mode: unit tests only, exclude slow tests
        cmd = ['pytest', 'tests/', '-m', 'unit and not slow']
        if args.verbose:
            cmd.append('-v')
        total_result += subprocess.run(cmd).returncode
    else:
        # Default: run unit tests
        total_result += run_unit_tests(args.verbose, args.coverage)
    
    if total_result == 0:
        print("\n✅ All checks passed!")
    else:
        print(f"\n❌ Some checks failed (exit code: {total_result})")
    
    return total_result


if __name__ == '__main__':
    sys.exit(main())
