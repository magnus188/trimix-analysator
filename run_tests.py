"""
Test runner script for development.
Run tests locally with various options.
"""

import os
import sys
import subprocess
import argparse


def setup_test_environment():
    """
    Configure environment variables to enable the test environment.
    
    Sets variables to mock sensors and indicate a test environment for consistent local test execution.
    """
    os.environ['TRIMIX_MOCK_SENSORS'] = '1'
    os.environ['TRIMIX_ENVIRONMENT'] = 'test'
    print("✅ Test environment configured")


def run_unit_tests(verbose=False, coverage=False):
    """
    Run all unit tests using pytest with optional verbosity and coverage reporting.
    
    Parameters:
        verbose (bool): If True, enables verbose pytest output.
        coverage (bool): If True, includes coverage reporting in the test run.
    
    Returns:
        int: The exit code from the pytest process.
    """
    cmd = ['pytest', 'tests/', '-m', 'unit']
    
    if verbose:
        cmd.append('-v')
    
    if coverage:
        cmd.extend(['--cov=.', '--cov-report=html', '--cov-report=term-missing'])
    
    print("🧪 Running unit tests...")
    return subprocess.run(cmd).returncode


def run_integration_tests(verbose=False):
    """
    Run all integration tests using pytest.
    
    Parameters:
        verbose (bool): If True, enables verbose output from pytest.
    
    Returns:
        int: The exit code returned by the pytest process.
    """
    cmd = ['pytest', 'tests/', '-m', 'integration']
    
    if verbose:
        cmd.append('-v')
    
    print("🔗 Running integration tests...")
    return subprocess.run(cmd).returncode


def run_all_tests(verbose=False, coverage=False):
    """
    Run all tests in the 'tests/' directory using pytest.
    
    Parameters:
        verbose (bool): If True, enables verbose output.
        coverage (bool): If True, includes coverage reporting.
    
    Returns:
        int: The exit code from the pytest process.
    """
    cmd = ['pytest', 'tests/']
    
    if verbose:
        cmd.append('-v')
    
    if coverage:
        cmd.extend(['--cov=.', '--cov-report=html', '--cov-report=term-missing'])
    
    print("🚀 Running all tests...")
    return subprocess.run(cmd).returncode


def run_specific_test(test_path, verbose=False):
    """
    Run a specific test file or test method using pytest.
    
    Parameters:
        test_path (str): Path to the test file or test method to run.
        verbose (bool, optional): If True, enables verbose pytest output. Defaults to False.
    
    Returns:
        int: The exit code returned by the pytest subprocess.
    """
    cmd = ['pytest', test_path]
    
    if verbose:
        cmd.append('-v')
    
    print(f"🎯 Running specific test: {test_path}")
    return subprocess.run(cmd).returncode


def run_linting():
    """
    Run code linting checks using black, flake8, and isort.
    
    Returns:
        int: 0 if all linting checks pass, 1 if any check fails.
    """
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
    """
    Run security vulnerability checks using Safety and Bandit tools.
    
    Returns:
        int: The highest exit code returned by either Safety or Bandit, indicating the overall result of the security checks.
    """
    print("🔒 Running security checks...")
    
    # Run safety check
    print("  Running safety check...")
    safety_result = subprocess.run(['safety', 'check']).returncode
    
    # Run bandit
    print("  Running bandit...")
    bandit_result = subprocess.run(['bandit', '-r', '.', '--exit-zero']).returncode
    
    return max(safety_result, bandit_result)


def run_performance_tests():
    """
    Run performance tests marked as "slow" using pytest with benchmark-only mode.
    
    Returns:
        int: The exit code from the pytest subprocess.
    """
    cmd = ['pytest', 'tests/', '-m', 'slow', '--benchmark-only']
    
    print("⚡ Running performance tests...")
    return subprocess.run(cmd).returncode


def fix_code_style():
    """
    Automatically formats code and sorts imports using Black and isort.
    """
    print("🔧 Fixing code style...")
    
    # Run black to format code
    print("  Running black formatter...")
    subprocess.run(['black', '.'])
    
    # Run isort to sort imports
    print("  Running isort...")
    subprocess.run(['isort', '.'])
    
    print("✅ Code style fixed")


def main():
    """
    Parses command-line arguments to run tests, linting, security checks, or code style fixes, then executes the selected actions and returns the combined exit code.
    
    Runs the appropriate test or code quality commands based on user-specified flags, sets up the test environment, and prints a summary of results. Returns the cumulative exit code of all executed actions.
    """
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
