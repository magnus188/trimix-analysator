# Charger input isolation and source qualification

Implemented 2026-09-07 on the existing hardware. This supersedes the earlier interpretation that an unrecognized source could indefinitely supply the 100 mA charger-register setting. The source decision follows [the primary USB specification review](../../../electrical/usb-default-current-review/README.md).

**Production battery charging remains `CommissioningInhibited`; J104 remains OPEN. No PCB, regulator, limiter or physical charging profile was changed.** This change controls the BQ input-to-system path while the host is functioning. It does not close the USB transient-voltage finding or establish whole-board legacy suspend-current compliance.

## Resulting behavior

| Source / condition | Input policy |
| --- | --- |
| Type-C advertises 1.5 A or 3 A, valid coherent evidence | Eligible for staged input connection and existing 1400 mA request/authorization sequence |
| Default CC plus fresh matching BC1.2 CDP/DCP | Same eligibility, with BC source-generation and bounded health checks |
| Default CC with SDP, unknown, proprietary, rejected or ambiguous BC evidence | BQ `EN_HIZ=1`, verified by readback; no input grant |
| Native higher CC advertisement with failed/irrelevant BC discovery | Higher CC remains eligible; failed BC does not override valid native Type-C permission |
| Detach, source fault, expired evidence, charger configuration failure or failed HIZ transaction | AUTH commanded LOW; isolation attempted; failures reported without pretending the electrical state is known |
| Maintenance | Worker must acknowledge charge inhibition and input isolation before the external barrier is Held |
| Persistent power-off | Continue attempting HIZ/charge inhibition and AUTH LOW; the worker may still issue hardware KILL if the charger is unreachable, without claiming successful isolation |

The 100 mA IINDPM setting remains the low register ceiling, **not source permission**. The current external limiter and hardware permission latch remain unchanged. The conservative policy does not infer a 500 mA native-C grant from Default CC because it cannot reliably distinguish a legacy A-to-C connection.

## Implementation and diagnostics

`power_monitor` starts by verifying HIZ, then inhibits battery charging/OTG and disables autonomous charger negotiation. HIZ isolation also restores the low register ceiling. A failed or ignored write cannot become confirmed isolation; wrong charger identity is never written. Configuration checks now include the expected EN_HIZ state, so an observed POR, watchdog/register reset or unexpected HIZ change triggers safe reconfiguration.

CC and BC detection run independently of BQ power-good while HIZ is active. Only a recognized source may clear HIZ. AUTH remains LOW while the policy rechecks source identity and waits up to **2500 ms** for charger power-good. That is a chosen software deadline accommodating the documented two-second poor-source retry interval; it is not a guarantee that every physical source will succeed. A source change or maintenance epoch change cancels this wait and reasserts HIZ. Fresh configuration, power-good, source evidence and hardware feedback are required before the final authorization edge. Healthy stable operation does not periodically disconnect input current.

The actual ESP power worker owns all BQ transactions. Maintenance publishes its intent before waiting on the shared input lock. Input enabling checks cancellation between transactions, and cancellation after a write completes HIZ rollback before acknowledgement. The actual-worker test found and corrected a further interaction: cancelling charge enable must also complete input isolation under the same lock; charge-bit rollback alone was insufficient for the maintenance barrier.

Existing snapshots now expose:

- `input_enable_command`: requested input state, distinct from electrical readback.
- `input_path`: `Unknown`, `Isolated` or `Enabled`, based on verified EN_HIZ state. Stale snapshots lose confirmation.
- `usb_power_good`: BQ observation, separate from `cc.attached_sink`; an isolated attached cable is not reported as proven absent.
- `bq_adc_idle_confirmed`: conservative observation of the unused BQ ADC's quiet state.

The driver writes **exact REG02=0** to disable continuous ADC operation without echoing a read CONV_START bit back as a new conversion request. It verifies CONV_RATE and the other lower seven bits. Bit7 also indicates input detection, so its busy state is tracked separately rather than causing an endless HIZ exit/configuration-reset cycle. No instantaneous abort is assumed: ADC-idle confirmation requires clear status and a full one-second quiet interval. Inherited continuous mode, ignored mode-clear writes and an in-progress single conversion are tested.

OTA eligibility still requires fresh, adequate battery reserve and a healthy charger configuration. Cable presence alone cannot authorize OTA. Intentional standby keeps acquisition/heater stopped and actual backlight PWM at zero; servicing and externally powered KILL-return behavior are retained.

## Reproducible digital verification

Run `python3 hardware/system-review/software/power/input-isolation/verify_input_isolation.py` from the repository. It builds into a temporary directory, records every command and log hash, and verifies its input hashes did not change. The authoritative current receipt is `evidence/receipt.json` (schema1).

The current-source suite reruns **all seven prior actual-worker scenarios**: normal standby/wake, maintenance during profile programming, maintenance at final charge enable, charger-bus loss, unaccepted startup probation, charger IRQ pulse, and failed KILL retry. It also reruns the production charge-profile/driver policy, actual backlight service, backlight concurrency workload and storage-maintenance race target.

Seven added input-isolation actual-worker scenarios cover SDP → detach → fresh DCP while PG is suppressed by HIZ; ignored HIZ writes; maintenance during HIZ-clear; maintenance during the PG wait; delayed PG; PG timeout; and ignored continuous-ADC disable. These execute production `system_power`, USB policy, BQ/CC/BC drivers and maintenance code. RTOS scheduling, electrical bus registers, GPIO, storage and the display hardware are explicit test boundaries. The synthetic qualified profile exists only at the test executable's provider seam; shipped `active()` remains inhibited.

Additional production-core tests cover source downgrades, failed/rejected BC priority versus native higher CC, stale generations, ignored HIZ exit, actual-versus-commanded input mode, ADC settling, charger identity, cancellation between BQ operations and timer wrap. ASan/UBSan runs the core and every worker scenario. TSan runs both original charge-enable races and both new HIZ-transition races, plus the existing concurrent backlight workload. Scoped CMake/CTest checks ensure routine test registration is usable.

The pre-HIZ standby receipt, logs, runner and narrative are preserved under `../off-charge-review/archive-before-hiz/`. The compatibility path `../off-charge-review/standby-evidence/receipt.json` is refreshed from the new suite, whose logs point here. Parent integration receipts separately govern complete pre3/v3 firmware builds, whole-suite runs and release acceptance.

The latest scoped run completed **45 recorded commands**, with **101 scoped input hashes unchanged**. ASan/UBSan reported **460 assertions**, including the BC driver and nine legacy-attachment scenarios. DCP and CDP each remain in standby for six virtual hours without restarting detection or charge enable. All four maintenance-race scenarios and the backlight concurrency workload passed TSan; scoped CTest completed **29/29**. See [the reproduced legacy-standby defect and correction](legacy-endurance-review/README.md). Receipt SHA256: `6689c4b7977723788e71971faf93cfdbdbcb4b1694940932cac6456458f27d3c`.

A further independent review reproduced two attachment-event races. The policy now clears and verifies the current CC interrupt before every new BC cycle, then uses read-only CC verification after collecting the result. Three actual-worker scenarios cover replacement SDP sources before detection, during a pending result and after collection; no replacement inherits DCP input permission. See [the independent review](legacy-endurance-review/independent-review.md).

The original detection timestamp is retained throughout one continuously verified attachment. Separate control-health observations must be less than three seconds apart; a missed interval or changed CC generation permanently revokes that result. This replaces the old absolute 30-second capability expiry, which the extended actual-worker test found would shut down a stable legacy charger.

## Explicit remaining limits

No board was flashed or electrically tested. The host cannot enforce HIZ while powered off, stalled or unable to communicate; the existing hardware default remains a separate limitation. Dead-pack/cold recovery, legacy timing and complete quiescent/inrush current need hardware qualification or further architecture work. The BQ 35 µA HIZ specification is for 5 V, no battery, ADC off: neither the new snapshot nor ADC-idle field proves battery-present or whole-board 2.5 mA compliance. Physical source changes, fast transients and true current consumption require measurement. EL11, cell qualification and the Guition external-power/backfeed questions remain open.
