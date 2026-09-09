# Integrated firmware review

This review replaces physical-build placeholder acquisition with real, managed device drivers. A physical build reports unavailable readings when devices are absent or faulty. Demonstration readings remain confined to simulator builds.

## Acquisition and configuration

`main/hardware_contract.h` supplies the actual GPIO and I²C assignments used by the drivers. `scripts/verify_system_contract.py` reconciles it with the current KiCad netlist and Guition logical pin map. The connector pitch, mating view and harness geometry still need physical confirmation.

A single mutex-managed 100 kHz I²C bus on GPIO28/29 serves the MAX17048, BQ25895, both ADS122C04s, BME280, TUSB320LAI and PI3USB9201. It is separate from the display's touch-controller bus. Transactions have timeouts; repeated failures request a controller reset and remain failures. A physical short is not cleared by declaring the bus healthy.

The production acquisition state machine is also compiled into host tests. It owns measurement sequencing, per-input timestamps, settling, warm-up, selection-generation changes and heater control. Separate oxygen and helium ADC faults remain distinguishable. Invalid excitation latches heating off until restart; oxygen can continue only when its independently checked bias is valid. Stopping acquisition prevents later worker activity from re-enabling heating or CO translation.

Both ADCs use their approved **20 SPS internal conversion setting**, the internal 2.048 V reference and disabled IDACs. This is not a promise of 20 delivered samples per channel per second: sequential channel diagnostics and the conservative 100 ms settling interval reduce delivered rate. Oxygen uses gain8 with the PGA; helium gain1 with bypass. Diagnostics have separate configurations. Register readback, stale-data clearing, bounded conversion waits and clipping rejection operate on the actual driver path.

The current oxygen profile is revision1. Helium profile revision2 accounts for its reviewed analogue-path changes. Calibration is isolated by AO2/JJ-CCR/helium identity and profile revision. Intact older records remain inactive when the transfer function changes; a fresh save advances the existing record revision. The finite journal retains current/previous records, not an unlimited calibration archive. Export characterization logs and reference information for longer-term history.

The known-air screen displays both raw inputs and currently requires manual confirmation: qualified response bounds for connector advice are missing. It does not claim automatic cell identification. The runtime warm-up and electrical stability thresholds are provisional and must be characterized on the installed modules.

## Real power and environmental data

The MAX17048 driver validates its device family, word order, fractional SOC, signed rate and plausible voltage. No fabricated percentage replaces a failed read. Charger status distinguishes current faults from latched history, and configuration is read back after writes and reset evidence. OTA installation requires fresh battery/charger evidence with reserve; USB cable presence alone does not establish enough input power.

The BQ25895 commissioning profile inhibits charge/OTG and autonomous input negotiation and starts with a 100 mA software input ceiling. A separate source policy may raise that register ceiling to 1400 mA only after consistent Type-C 1.5/3 A advertisement or a fresh BC1.2 CDP/DCP result. SDP, proprietary and unknown sources keep the default ceiling; no USB enumeration is provided. These register values do not guarantee delivered current: the independent upstream limiter and BQ hardware ILIM can impose lower limits. This policy does not enable cell charging. J104 remains open pending exact cell, holder and NTC qualification.

GPIO50/J301.11 commands the hardware current-permission gate; the gauge alert is now polled instead of using that GPIO. The policy forces LOW before controller changes, acknowledges the CC event, waits 40 ms for the supervisor, rechecks the source, programs/readbacks the charger limit, then refreshes power, BC and CC evidence before a HIGH edge. A source change, stale classification, fault, failed control or maintenance request removes permission. An epoch tracks forced LOW events even when a complete maintenance request occurs between worker polls. GPIO49/J301.13 reads the shared charger IRQ and inverted latch feedback. A sustained LOW invalidates cached permission and requires a complete fresh qualification sequence; a brief charger IRQ gets a settling interval. The post-HIGH check also verifies feedback and the maintenance epoch. Command and confirmed permission remain separate. The RTOS adapter rounds up waits and adds a phase tick, so a requested 2 ms settling interval lasts approximately 10–20 ms at the configured 100 Hz. See the [targeted fault tests](power/usb-latch-feedback-review.md).

The BQ25895 ILIM pin does **not** support a guaranteed sub-500 mA limit; the earlier high-value ILIM-resistor approach was rejected during independent review. The revised electrical design uses a separate TPS22950-family low-current stage before the charger (the electrical review selects the accessible TPS22950CQDDCRQ1 package; the industrial C part is not an interchangeable substitute). Its exact implementation, startup/inrush, sustained fault response and depleted-pack recovery must be verified against the final electrical evidence and bench measurements. Default USB power cannot operate the complete screen/heater load. Future charging with the device off must be qualified separately; firmware cannot bootstrap a depleted pack merely by requesting more current. [BQ25895 datasheet](https://www.ti.com/lit/ds/symlink/bq25895.pdf), [TPS22950 datasheet](https://www.ti.com/lit/ds/symlink/tps22950.pdf).

The BME280 driver uses the official Bosch factory-trim compensator, forced T/P/H measurements and configuration readback. It rejects the common BMP280 substitution, erased/missing trim, skipped/reset samples, invalid uniform bursts, ignored configuration/trigger writes, busy conversions and failed reads. Legitimate zero humidity is not rejected merely because it is an endpoint. The sensor's calibration and physical chamber environment remain unverified.

The [qualified-profile standby implementation](power/off-charge-review/standby-implementation.md) can keep the source/charger worker active with zero backlight, stopped acquisition and heater control, after startup acceptance. Its enabled profile is currently a test fixture only; production remains charge inhibited. Profile writes, readback, final enable, maintenance, wake and failed/service-powered KILL returns have host fault tests. Standby requires adequate battery reserve and does not establish cold/depleted-pack recovery or positive net charging current.

The LTC2954 button interrupt is latched by an ISR because its pulse can be shorter than a polling cycle. GPIO33 releases the open-drain KILL output during startup and asserts it only after maintenance preparation. The hardware held-button shutdown remains independent of firmware. GPIO34 heater and GPIO51 translator enables retain hardware-off defaults. Real GPIO timing, rail sequencing and forced shutdown still require bench tests.

## Raw characterization capture

Capture the serial output with an ordinary serial monitor, then run:

```sh
python3 scripts/extract_characterization.py serial.log measurements.csv
```

The extractor opens no serial port and performs no flashing. Each `CSV1` row retains the raw channel's own timestamp, cell-selection identity, sequence/generation, ADC code, volts, gain, excitation, bias, environment, faults, warm-up and acquisition profile. `calibration_revision` means the last saved record's revision; that record may be inactive and is not proof that valid calibration was applied. Raw volts are not validated gas percentages. The32-bit millisecond timer wraps; the extractor deliberately preserves its raw values instead of inventing wall-clock time.

Record board/firmware hashes, sensor and reference-gas identities, reference uncertainty, environmental conditions, flow arrangement and charging state alongside each capture. Keep calibration mixtures separate from withheld validation mixtures. Determine the helium correction curve from those measurements.

## Reproduction and limits

```sh
cmake -S simulator -B simulator/build
cmake --build simulator/build -j6
ctest --test-dir simulator/build --output-on-failure
bash scripts/run_tests.sh
make build P4_REV=pre3
make build P4_REV=v3
python3 scripts/verify_system_contract.py
```

Build commands compile only. Host fakes inject faults into production logic; they do not exercise the ESP peripheral drivers, flash timing, network radio, actual sensor physics or thermals. Sanitizer and concurrency receipts are under the relevant subsystem directories. Firmware binaries, source manifests and integrated logs are in the parent verification package. No device was flashed or updated during this review.
