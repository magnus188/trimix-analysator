#!/usr/bin/env python3
"""Source-bound portable verification. No board, network or firmware update access."""
import datetime
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / "main/services/system_power.cpp").is_file())
OUT = HERE / "standby-evidence"
OUT.mkdir(exist_ok=True)
BUILD = Path(tempfile.mkdtemp(prefix="trimix-standby-verification-"))
CXX = shutil.which("c++")
if not CXX:
    raise SystemExit("c++ unavailable")
CORE = ["main/services/charge_profile.cpp", "main/services/charge_standby_policy.cpp", "main/sensors/power_monitor.cpp"]
WORKER = ["main/services/system_power.cpp", "main/services/charge_standby_policy.cpp",
          "main/services/maintenance_service.cpp", "main/services/backlight_service.cpp",
          "main/sensors/power_monitor.cpp", "main/sensors/usb_input_policy.cpp",
          "main/sensors/usb_source_monitor.cpp", "main/sensors/bc12_monitor.cpp"]
TESTS = ["tests/test_charge_standby.cpp", "tests/test_backlight_standby.cpp", "tests/test_power_worker_standby.cpp"]
INPUTS = set(CORE + WORKER + TESTS + ["main/main.cpp", "main/hardware_contract.h", "main/CMakeLists.txt",
    "simulator/CMakeLists.txt", "scripts/run_tests.sh", "simulator/mocks/backlight_service_mock.cpp",
    "main/board/guition_jc4880p443.c", "main/services/storage_service.h", "main/sensors/system_i2c.cpp",
    "main/services/oxygen_selection_service.h", "main/services/gas_calibration_core.h",
    "main/third_party/bme280/bme280.h", "main/third_party/bme280/bme280_defs.h",
    "main/sensors/environment_monitor.h", "main/sensors/sensor_hardware.h", "main/sensors/sensor_interface.h",
    "main/sensors/system_i2c.h", "simulator/stubs/esp_err.h", "simulator/stubs/esp_log.h"])
for source in CORE + WORKER:
    header = str(Path(source).with_suffix(".h"))
    if (ROOT / header).exists():
        INPUTS.add(header)
for folder in ("tests/power_worker_stubs", "tests/backlight_stubs"):
    INPUTS.update(str(p.relative_to(ROOT)) for p in (ROOT / folder).rglob("*") if p.is_file())
INPUTS.add(str(Path(__file__).resolve().relative_to(ROOT)))

def hashes():
    return {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in sorted(INPUTS)}

before = hashes()
checks = []

def run(name, args):
    result = subprocess.run(args, cwd=ROOT, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    log = OUT / (name + ".log")
    log.write_text(result.stdout)
    checks.append({"name": name, "command": [str(v) for v in args], "exit_code": result.returncode,
                   "log": str(log.relative_to(ROOT)), "sha256": hashlib.sha256(log.read_bytes()).hexdigest()})
    if result.returncode:
        print(result.stdout)
        raise RuntimeError(f"{name} failed ({result.returncode})")
    print(f"PASS {name}")

def compile_test(name, sources, sanitizer, worker=False):
    includes = ["tests/power_worker_stubs", "tests/backlight_stubs", "simulator/stubs", "main"]
    args = [CXX, "-std=c++17", "-Wall", "-Wextra", "-Werror", "-pthread", "-g",
            f"-fsanitize={sanitizer}", "-fno-omit-frame-pointer"]
    if worker:
        args += ["-DESP_PLATFORM=1"]
    args += ["-I" + path for path in includes] + sources + ["-o", str(BUILD / name)]
    run("compile-" + name, args)
    return str(BUILD / name)

status = "failed"
try:
    run("compiler", [CXX, "--version"])
    core = compile_test("charge-core-asan-ubsan", [TESTS[0]] + CORE, "address,undefined")
    run("charge-core-asan-ubsan", [core])
    backlight = compile_test("backlight-asan-ubsan", [TESTS[1], "main/services/backlight_service.cpp"], "address,undefined")
    run("backlight-asan-ubsan", [backlight])
    worker = compile_test("worker-asan-ubsan", [TESTS[2]] + WORKER, "address,undefined", True)
    for scenario in ("normal", "maintenance", "maintenance-last", "bus-loss", "probation", "charger-irq", "kill-retry"):
        run("worker-asan-ubsan-" + scenario, [worker, scenario])
    backlight = compile_test("backlight-tsan", [TESTS[1], "main/services/backlight_service.cpp"], "thread")
    run("backlight-tsan", [backlight])
    worker = compile_test("worker-tsan", [TESTS[2]] + WORKER, "thread", True)
    for scenario in ("maintenance", "maintenance-last"):
        run("worker-tsan-" + scenario, [worker, scenario])
    cmake_build = BUILD / "cmake"
    run("cmake-configure", ["cmake", "-S", "simulator", "-B", str(cmake_build)])
    run("cmake-build", ["cmake", "--build", str(cmake_build), "--target", "test_charge_standby", "test_backlight_standby",
                       "test_power_worker_standby", "test_power_environment", "test_usb_input_policy", "test_storage_maintenance_race", "-j", "4"])
    run("cmake-ctest", ["ctest", "--test-dir", str(cmake_build), "-R",
                       "charge_standby|backlight_standby|power_worker_|test_power_environment|usb_input_policy|storage_maintenance_race", "--output-on-failure"])
    if before != hashes():
        raise RuntimeError("Verification source changed during checks")
    status = "passed"
finally:
    receipt = {"schema": 1, "scope": "Charge standby portable code and actual ESP worker with explicit hardware boundary stubs",
               "utc": datetime.datetime.now(datetime.timezone.utc).isoformat(), "status": status,
               "source_sha256": before, "source_unchanged": before == hashes(), "checks": checks,
               "production_profile": "CommissioningInhibited; J104 OPEN; no UI/NVS qualification",
               "physical_tests": "none", "full_firmware_builds": "separate parent integration receipt"}
    (OUT / "receipt.json").write_text(json.dumps(receipt, indent=2) + "\n")
