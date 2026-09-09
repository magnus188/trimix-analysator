# CO environment qualification review

Implemented 2026-09-08. CO readings now require fresh, finite chamber temperature and humidity within the module's published working range. Missing or invalid environment produces `co_valid=false` and NaN, even when UART frames are fresh and warm-up has elapsed. This is a data-validity gate, not a safety qualification.

## Manufacturer basis and limits

Primary source independently checked: [Winsen ZE07-CO manual V1.7](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf), technical parameters and cautions. It specifies -10 to 55 C, 15 to 90% RH without condensation, 5 to 12 V supply, and at least five minutes for first use. The module is CO, not CO2. It warns against strong convection and use in human-safety systems. Root's [module-use review](../../electrical/co-module-use-review.md) records the project implications.

Reported chamber bounds alone do not prove the temperature/humidity at the module, absence of condensation, supply compliance, suitable gas flow or accurate ppm. Measurement uncertainty and sensor placement remain physical checks. No undocumented commands, calibration commands, voltage assumptions or new physical qualification were introduced.

## Production path

`main/sensors/co_qualification.cpp` composes the existing `Ze07CoDecoder`. It requires an available UART interface, 300000 ms of warm-up, a valid recent frame, a valid environment snapshot no older than 3000 ms, finite temperature/RH and inclusive operating bounds. The decoder retains its existing 3000 ms frame age limit and protocol/checksum/full-scale checks. A failed check produces NaN, with separate fault bits for interface, warm-up, frame, missing/stale/nonfinite environment and temperature/humidity range. Fault transitions log a readable reason, bitmask and the actual environment values/timestamp under `CO_STATUS`.

The actual acquisition task invokes this gate before publication and publishes the same environment snapshot used by it. It additionally checks snapshot age after UART work. GPIO51 is `CO_UART_EN`, enabling translation rather than switching or measuring module power. The full five-minute wait now begins after its first successful interface-enable command; repeating a successful command does not reset it. An interface failure discards old decoder state and restarts that conservative wait. None of this proves the physical module supply.

Oxygen/helium conversion, selection, calibration and persisted data layouts were left unchanged. No UI layout change was needed. The current CO label explicitly switches to `--` on invalid readings; averaging requires every included CO value to be valid; history writes NaN/false and renders unavailable instead of retaining an old number. The gate's detailed transient fault bits remain diagnostic logs rather than a new persisted schema.

## Tests and acceptance boundary

The portable production gate has 28 assertions covering exact and just-outside temperature/RH endpoints, missing/nonfinite/future/stale environment, warm-up boundary, interface interruption, checksum/expiry recovery, legitimate full-scale CO and 32-bit timer wrap. The actual ESP acquisition adapter fixture adds 11 assertions covering warm-up, environment absence, valid 2.5 ppm, active clearing at 10% RH, stale evidence despite a provider's valid flag, unchanged O2/He publication and worker health. A separate missing-UART run adds 5 assertions. All 44 run normally and under ASan/UBSan. Three scoped CTest cases are registered in the normal suite, and repository tests compile the actual adapter with strict warnings.

That adapter test compiles unchanged production acquisition/ADC code and the OTA `boot_healthy` function. UART, I2C, time, GPIO and calibration services are explicit test boundaries. Optional CO/environment failures leave the real worker heartbeat healthy; acceptance is exercised with supplied UI/storage readiness. This is not an execution of the full bootloader, LVGL hardware or physical OTA rollback. Existing main startup acceptance continues to require service progress, not gas validity, network association or warm-up completion.

## Source-bound evidence

Reproduce the focused checks with `python3 hardware/system-review/software/co-environment/verify_co_environment.py`. `evidence/receipt.json` binds both configurations, commands, logs and source hashes. Existing UI/history consumer branches were reviewed, and unchanged consumer tests rerun in the whole suite; no new rendered-interface claim is made.

After source freeze, the complete pre3 and v3 applications built successfully with zero warnings in these incremental logs. Both full normal and ASan/UBSan CTest suites passed 50 tests; repository checks passed 95; Clang static analysis passed 18 production units. The unchanged logical firmware/schematic contract passed 70 checks. `hardware/system-review/verification/software-final.json` binds 204 review inputs, including 144 firmware inputs, to those artifacts; root may separately refresh its hardware-contract association after a canonical PCB promotion. Release descriptor, silicon-family and OTA-slot checks also passed.

The unchanged USB/charging-standby source-bound suite was rerun because CMake/test registration changed and a portable header was added. It retains 460 reported sanitizer assertions, four worker maintenance race runs plus concurrent backlight TSan, and 29 scoped CTest tests. Original successful binaries, logs, receipts and affected sources are retained in `hardware/system-review/verification/before-co-environment/manifest.json`. The initial ESP-IDF build was denied by the macOS sandbox's process-inspection restriction; its log remains here. The same local builds completed after the approved build permission, without flashing or source substitution.

No firmware was flashed or deployed. No gas, leakage, electrical supply, humidity chamber, temperature chamber, flow, CO accuracy or physical charging tests were performed. Production battery charging remains CommissioningInhibited and J104 OPEN. O2/He bench qualification and the module's manufacturer use restrictions remain independent limits.
