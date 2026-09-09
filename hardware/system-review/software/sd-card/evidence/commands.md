# Reproducing the SD verification

Run from the repository root on this macOS/ESP-IDF development environment.
No command below flashes a device, mounts its card or publishes a release.
The build tool prints example flash commands at completion; those were not executed.

1. Capture the frozen source/build/test inputs:

   `python3 hardware/system-review/software/sd-card/verify_evidence.py --capture`

2. Configure `/tmp/trimix-sd-host` using `cmake -S simulator -B /tmp/trimix-sd-host -DCMAKE_BUILD_TYPE=Debug`, build with `cmake --build /tmp/trimix-sd-host -j8`, then run `ctest --test-dir /tmp/trimix-sd-host --output-on-failure`.

3. Configure `/tmp/trimix-sd-sanitizer` with the same source/build type and `-DCMAKE_C_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'`, `-DCMAKE_CXX_FLAGS='-fsanitize=address,undefined -fno-omit-frame-pointer'`, `-DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined'`. Build and run `ASAN_OPTIONS=detect_leaks=0 ctest --test-dir /tmp/trimix-sd-sanitizer --output-on-failure`. The CMake integration also enables those sanitizers in the coordinator Python fixture's C executable.

4. Run `TRIMIX_REQUIRE_SIMULATOR=1 bash scripts/run_tests.sh` for repository checks and its separately built simulator tests.

5. Import `scripts/verify_portable_analysis.py` with Python `importlib.util`, set its `OUT` to the absolute `hardware/system-review/software/sd-card/evidence/static-analysis` directory, and call `main()`. This preserves earlier review outputs. Its `results.json` contains exact per-unit compiler commands, headers, versions and diagnostics.

6. ThreadSanitizer commands:

```sh
c++ -std=c++17 -Wall -Wextra -Werror -pthread -fsanitize=thread -fno-omit-frame-pointer -I main -I simulator/stubs tests/test_sd_log.cpp main/services/sd_log_core.cpp main/services/sd_log_files.cpp main/services/sd_log_format.cpp -o /tmp/trimix-sd-tsan
/tmp/trimix-sd-tsan
c++ -std=c++17 -Wall -Wextra -Werror -pthread -fsanitize=thread -fno-omit-frame-pointer -I main tests/test_sd_maintenance.cpp main/services/sd_log_core.cpp main/services/maintenance_service.cpp main/services/storage_service.cpp main/services/blob_journal.cpp -o /tmp/trimix-sd-maintenance-tsan
/tmp/trimix-sd-maintenance-tsan
```

7. Run `make build P4_REV=pre3`, then `make build P4_REV=v3`. `make` invokes the configured ESP-IDF environment; this host required sandbox access for IDF's system process query. No device connection or update was used. The owned Hosted patch is checked/applied into each build directory; the managed component stays unchanged.

8. Use the ESP-IDF Python environment to run `python -m esp_idf_size --format json build/esp32p4-pre3/Trimix_analyzer.map` and the corresponding v3 map. Preserve diagnostic output separately from JSON. Also run `--ng --format json2` for the independent section report. The older tool's v3 region warnings are retained; free/total memory is not treated as measured runtime heap.

9. Run `python3 scripts/verify_release.py --version 0.2.0 --build-root build --output hardware/system-review/software/sd-card/evidence/release-manifest.json`. This checks application bytes, silicon identity, project/version, slot fit and separation from C6 recovery.

10. Run `/tmp/trimix-sd-host/test_ui_smoke` with `TRIMIX_UI_CAPTURE_DIR` set to the absolute evidence `ui` directory. Convert the analysis, calibration and Device Settings PPM captures to PNG using Pillow and inspect them. `ui-review.json` binds the viewed PNGs. This uses simulator data only.

11. Run the SD maintenance fixture 101 consecutive times to check the previously intermittent drained-state invariant. The fixture itself checks 1,000 no-op writer wakeups after pause. `maintenance-repeat.log` preserves all executions.

12. After writing logs, image/partition/size outputs and review notes, run `python3 hardware/system-review/software/sd-card/verify_evidence.py`. It refuses changed source inputs, failed/incomplete or stale checks, and binds the actual application bytes and checked Hosted build copies.

The deliberate negative controls restore the old close/unmount behavior or the split applied-revision lookup in isolated temporary source files. Their expected failing output and exact source/test hashes are retained separately; they are not firmware builds and their failures are not hidden or included as passing tests.
