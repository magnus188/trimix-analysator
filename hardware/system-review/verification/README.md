# Combined digital verification

## Current SD integration checkpoint — 2026-09-08

Use the [SD integration review](../software/sd-card/README.md) and its
[source-bound receipt](../software/sd-card/evidence/receipt.json) for the current
firmware. The final source-bound runs report **53/53 CTest targets normally and with
ASan/UBSan, 98 repository checks, and 22 portable Clang units**, plus scoped
ThreadSanitizer checks of the logger and actual storage/maintenance coordinator.
Both P4 images compile without warnings and fit their unchanged OTA partitions.
These counts overlap; they are not a sum of independent test cases.

The pre-v3 application is 2,051,056 bytes in a 4,194,304-byte slot; the v3
application is 2,056,432 bytes in a 6,291,456-byte slot. Linker section sizes do
not establish live free heap during simultaneous display, radio and card use.
The final receipt binds the actual sources, binaries, tests and patched Hosted
inputs. Physical card operation, shared-controller timing, peak power and
power-loss behavior remain pending.

Independent review corrected three reachable failures before this final run:
combined file-close/unmount failure, calibration values labelled with a different
revision, and analysis/calibration screen-event ordering. Negative controls fail
against the old behavior. The final log records both applied O2 and He revisions
atomically with their conversions; no persistent NVS layout changed.

The photograph and 13.4 mm front-glass-to-header-tip measurement require a new
mechanical checkpoint. Earlier v11 connector clearance and aggregate evidence
receipts do not qualify the corrected connector positions or complete looms.
See [the registration and routing review](../integration-photo/README.md).

## Preserved pre-SD verification

The following describes the archived baseline at
[before-sd-storage/](before-sd-storage/), not the current firmware sources.
Its old build counts and hashes remain point-in-time evidence. The original
verification README is retained inside that snapshot.

`software-final.json` binds the final software checks, application binaries,
source files and logs by SHA-256. All 144 recorded firmware inputs remained
unchanged during the two final builds. This is software evidence, not an order
release or a substitute for the final electrical/mechanical checks.

| Check | Result |
|---|---|
| P4 pre-v3 and P4-v3 applications | Passed digitally; both compile and fit their existing OTA slots |
| Routine CTest suite | 50/50 passed digitally |
| Same suite with AddressSanitizer/UndefinedBehaviorSanitizer | 50/50 passed digitally |
| Repository verification script | 95/95 passed digitally |
| Firmware-to-schematic logical contract | 70 assertions passed digitally, plus eight deliberately corrupted header cases and five disconnected-feedback cases |
| Clang static analyzer | 18 portable production units, no diagnostics |
| Actual ESP storage initialization branch with injected low-level NVS | 35 assertions; five isolated startup states, included in CTest |
| Storage/maintenance races | Separate ASan/UBSan and ThreadSanitizer receipts under `software/ota/` |
| Startup acceptance versus timeout | 1,000 contested rounds in each sanitizer configuration; one winner only |
| USB permission policy | 23 named assertions under ASan/UBSan, hardware-only latch clearing, short charger IRQ, failed rearming, maintenance and stable polling |
| Input isolation and charging standby | 460 scoped ASan/UBSan assertions; four worker maintenance races plus concurrent backlight TSan workload; actual worker with documented hardware boundaries |
| Attachment-event races | Three actual-worker swap boundaries plus two archived failing controls; initial CC event clears before detection and legacy post-result checks are read-only |
| Legacy charging-port endurance | Six virtual hours each DCP/CDP without repeated detection or charge-enable; missed health interval, detach, sticky replug and detector reset revoke permission |
| Selected-sensor publication | Seven regressions prevent old conversions/resets from replacing new setup history |
| CO operating-condition gate | 44 focused assertions in normal and ASan/UBSan runs; includes the actual acquisition adapter, stale/range rejection, invalid-value clearing and optional-sensor startup health |
| UI review | 11 simulator framebuffer captures inspected, including unavailable battery/storage and faulted air-check inputs |

The repository count includes the CTest invocation; these numbers are not a
sum of independent test cases. Repeated runs are not additional fault coverage.
Specific assertion counts and exact scope are recorded in each subsystem's
receipt. Older receipts remain point-in-time evidence and can have superseded
source hashes.

Both current incremental ESP-IDF builds completed without compiler warnings. An earlier compilation of the vendor TE-disabled display macro emitted seven missing-member-initializer warnings: `gpio_num = -1` is explicit and other aggregate members are zero initialized. No warning suppression or vendor modification was made. Current logs and per-build counts are in the receipt. Before-standby, before-input-isolation, before-legacy-endurance-fix and before-co-environment artifacts preserve the relevant earlier checkpoints.

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

The current firmware/schematic association was rerun after the reviewed `0962`
board and `b04e` netlist became canonical. `before-refined-hardware-contract/`
preserves the preceding verified software receipt and logical report; only the
hardware-associated logical receipt was refreshed. The build binaries and their
source inputs were not changed or rebuilt for that association.

`verify_review_evidence.py` checks current source/output hashes across the
firmware, canonical PCB, independent CAM, native Fusion reopen, bounded fit
checks, diagnostic slices and six-page interface packet. Its generated
`evidence-integrity.json` keeps engineering acceptance and physical/order holds
separate. A matching hash is evidence of byte identity, not proof of a part's
rating or a physical result. The final STEP numerical disposition is recorded
in the mechanical checkpoint alongside the exact native archive.
