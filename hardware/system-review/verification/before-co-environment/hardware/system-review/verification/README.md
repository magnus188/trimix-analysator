# Combined digital verification

`software-final.json` binds the final software checks, application binaries,
source files and logs by SHA-256. All 142 recorded firmware inputs remained
unchanged during the two final builds. This is software evidence, not an order
release or a substitute for the final electrical/mechanical checks.

| Check | Result |
|---|---|
| P4 pre-v3 and P4-v3 applications | Passed digitally; both compile and fit their existing OTA slots |
| Routine CTest suite | 47/47 passed digitally |
| Same suite with AddressSanitizer/UndefinedBehaviorSanitizer | 47/47 passed digitally |
| Repository verification script | 92/92 passed digitally |
| Firmware-to-schematic logical contract | 70 assertions passed digitally, plus eight deliberately corrupted header cases and five disconnected-feedback cases |
| Clang static analyzer | 17 portable production units, no diagnostics |
| Actual ESP storage initialization branch with injected low-level NVS | 35 assertions; five isolated startup states, included in CTest |
| Storage/maintenance races | Separate ASan/UBSan and ThreadSanitizer receipts under `software/ota/` |
| Startup acceptance versus timeout | 1,000 contested rounds in each sanitizer configuration; one winner only |
| USB permission policy | 23 named assertions under ASan/UBSan, hardware-only latch clearing, short charger IRQ, failed rearming, maintenance and stable polling |
| Input isolation and charging standby | 460 scoped ASan/UBSan assertions; four worker maintenance races plus concurrent backlight TSan workload; actual worker with documented hardware boundaries |
| Attachment-event races | Three actual-worker swap boundaries plus two archived failing controls; initial CC event clears before detection and legacy post-result checks are read-only |
| Legacy charging-port endurance | Six virtual hours each DCP/CDP without repeated detection or charge-enable; missed health interval, detach, sticky replug and detector reset revoke permission |
| Selected-sensor publication | Seven regressions prevent old conversions/resets from replacing new setup history |
| UI review | 11 simulator framebuffer captures inspected, including unavailable battery/storage and faulted air-check inputs |

The repository count includes the CTest invocation; these numbers are not a
sum of independent test cases. Repeated runs are not additional fault coverage.
Specific assertion counts and exact scope are recorded in each subsystem's
receipt. Older receipts remain point-in-time evidence and can have superseded
source hashes.

Both current incremental ESP-IDF builds completed without compiler warnings. An earlier compilation of the vendor TE-disabled display macro emitted seven missing-member-initializer warnings: `gpio_num = -1` is explicit and other aggregate members are zero initialized. No warning suppression or vendor modification was made. Current logs and per-build counts are in the receipt. Before-standby, before-input-isolation and before-legacy-endurance-fix artifacts preserve the relevant earlier checkpoints.

The input-isolation correction keeps unqualified SDP, unknown and proprietary sources in verified BQ HIZ. Recognized sources reconnect only through fresh CC/BC health, bounded power-good checks and hardware authorization. Stable legacy classifications belong to one continuously verified attachment: their original observation time is preserved and a missed three-second control-health interval revokes them. A longer actual-worker test caught and corrected the earlier 30-second redetection policy causing a stable charger to shut down. See [input isolation](../software/power/input-isolation/README.md) and [the endurance correction](../software/power/input-isolation/legacy-endurance-review/README.md).

Standby keeps the source worker running with a dark screen only when a future qualified profile and fresh source/battery evidence permit it. Production still uses `CommissioningInhibited`, and J104 stays OPEN. Cold/depleted-pack recovery remains a separate order hold; software tests do not prove that a powered-off host can bootstrap from the default USB current limit.

The physical peripheral adapters are compiled by ESP-IDF. Host tests inject
transport, storage, timing and startup failures into production logic. They do
not execute a real radio, ESP flash power loss, bootloader rollback, analogue
sensor, electrical bus, charging cycle, heater temperature or enclosure seal.
Actual shared-bus scheduling and aggregate SDK call duration remain unmeasured.

Ordinary application updates remain separate from bootloader/partition/C6
recovery operations. No device was flashed, no update installed and no release
published by this review. The two application-only binaries in
`../software/firmware/` target this reviewed hardware contract; they are build
artifacts, not permission to bypass unfinished hardware release gates.
