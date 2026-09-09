# Software calibration UI review

The native LVGL interface passed 19 event-driven UI assertions and the three focused CTest targets (`ui_smoke`, `analysis_calculator`, `analysis_history`). The six PNGs in this folder are actual 480 × 800 RGB565 framebuffer captures from the host simulator, converted from PPM with `sips`. Their gas values are simulated test data.

The reviewed wizard selects AO2, JJ-CCR or helium independently; captures two identified, known reference gases; and requires a stable, warmed, fault-free raw signal. Blank reference uncertainty remains unknown and permits only a bench/comparison record. Capture failures retain the previously saved record. Saving a two-point helium fit cannot mark the MD62 as characterized. There is no undocumented CO calibration command.

Visual review covered readable selectors and fields, the fixed simulation identity/navigation bar, touchscreen keyboard clearance, capture/save states, saved-record feedback and fault feedback. The analysis screen keeps AO2 and JJ-CCR readings separate. History retains CO2 meaning and displays CO in its own field, with simulation or hardware provenance; migrated records have unknown provenance. Pages deliberately scroll vertically.

| Capture | Reviewed state |
| --- | --- |
| `calibration-overview.png` | Source identity, channel selection, raw signal, baseline reference inputs |
| `calibration-review.png` | Captured baseline/span, reference identity, review and save |
| `calibration-fault.png` | Fault blocks capture; earlier saved record retained |
| `calibration-helium-saved.png` | Saved simulation helium fit, no physical calibration claim |
| `analysis-live.png` | Independent AO2/JJ-CCR/helium/CO values and readable controls |
| `history-gas-provenance.png` | Distinct CO and CO2 data and simulation provenance |

`review.json` records assertion names, source hashes and screenshot hashes. `tests.log` and `ui-smoke.log` contain the test results.

To reproduce from the repository root:

```sh
cmake --build simulator/build --target test_ui_smoke test_analysis_calculator test_analysis_history -j4
ctest --test-dir simulator/build --output-on-failure -R '^(ui_smoke|analysis_calculator|analysis_history)$'
mkdir -p /tmp/trimix-ui-review
TRIMIX_UI_CAPTURE_DIR=/tmp/trimix-ui-review simulator/build/test_ui_smoke
```

Physical touchscreen testing, real sensor/ADC reference capture, on-device NVS migration and power-cycle testing remain pending. These captures do not validate sensor accuracy, gas compensation or use for diving. Hardware configurations build and core calibration/acquisition tests are recorded separately by the firmware verification.
