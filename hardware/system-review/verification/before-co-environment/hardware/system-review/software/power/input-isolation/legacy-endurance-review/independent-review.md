# Independent legacy attachment/endurance review

Completed 2026-09-07. The BC endurance correction passed the bounded review, but integration review found two additional attachment races. Both were reproduced against the actual ESP worker and corrected with parent authorization. No KiCad, power-driver, standby, storage or BC-monitor production code was changed in this follow-on; the sole production change is USB policy acknowledgment ordering. Full firmware builds are recorded separately by the parent.

## Findings and correction

1. **Initial sticky event hid a replacement source.** BC detection began while the initial CC interrupt remained set. A completed DCP result could survive a subsequent SDP connection with the same final CC state. The first independent actual-worker reproduction granted 1400 mA with one detection after that replacement. The policy now explicitly acknowledges and checks CC before starting each new BC cycle, with AUTH LOW and input isolated.
2. **Final W1C could erase a new event.** Even after the first correction, a replacement source arriving between the final ACK verification read and its W1C write could inherit the old result. A second actual-worker negative control reproduced that path. The legacy post-result barrier now performs only reads and requires unchanged generation and a clear interrupt; it does not acknowledge again. Subsequent CC changes invalidate the generation before another fresh detection.

This is grounded in the [TUSB320LAI Rev D register 09h description](https://www.ti.com/lit/ds/symlink/tusb320lai.pdf), which describes an event bit held until software clears it and specifically requires verified clearing for later events. The two failing controls preserve archived production policy and explicit hardware/RTOS boundary fixtures. They are intentional failure evidence, not failures of the corrected regression suite.

## Bounded review results

| Review item | Result and boundary |
| --- | --- |
| Attachment lifetime | Consistent with [PI3USB9201 Rev 3-2 p8](https://www.diodes.com/datasheet/download/PI3USB9201.pdf): detection on attached sink, stop/power down on departure; status is read-clear. Classification is retained for that attachment, not periodically recreated. |
| Health deadline | Ready results require elapsed time strictly below 3000 ms. Checks occur before and after control-register I2C reads. A late read, transport/configuration failure or generation change permanently invalidates the old result; polling cannot revive it. |
| Timestamp honesty | `observed_ms` remains the original completion observation. `validated_ms` advances only after exact repeated control readback using the caller's freshly polled CC generation. It is health validation, not another BC measurement. |
| CC event binding | Same-state events after verified clearing increment generation. Initial acknowledgment occurs before a new BC cycle; no destructive acknowledgment follows a legacy result. Production ordinary CC/BC polling remains read-only. |
| Long stable operation | DCP and CDP each run for six virtual hours through actual worker glue without repeated detection, HIZ exit or charge-enable edges. They also assert one pre-detection CC ACK per cycle. |
| Charger timer/termination | Stable paths do not reset the charge cycle. [BQ25895 Rev C §8.2.7.1](https://www.ti.com/lit/ds/symlink/bq25895.pdf) permits a new cycle after a charge-enable toggle, so avoiding periodic toggles matters. Existing real-driver fault tests retain a timer fault after status clears and reject later enable. The virtual six-hour bus does not emulate chemistry or autonomous timer expiry. |

## Current verification and provenance

The authoritative schema1 receipt is `../evidence/receipt.json`; its compatibility copy is `../../off-charge-review/standby-evidence/receipt.json`. The scoped runner completed **45 commands**, **460 reported ASan/UBSan assertions**, unchanged hashes for **101 inputs**, and **29/29 scoped CTest tests**. It reran the original standby/wake, retained-host-power KILL retry, bus-loss, probation, charger IRQ and maintenance cases, all HIZ/ADC cases, six legacy endurance/loss cases and three new attachment boundaries. TSan reran both charge-enable races, both HIZ-transition races and concurrent backlight operation.

The three new actual-worker boundaries replace DCP with SDP before initial detection, while the one-shot DCP result is pending, and immediately after collection. A replacement must stay ungranted and in HIZ until its own fresh result is evaluated. Pure policy checks reject failed pre-detection ACK and ensure a completed BC result does not cause another ACK. Existing native high-CC, source downgrade, feedback and maintenance tests remain in the run.

`independent-review-pending-replug-execution.json` binds the first negative control to the parent's archived pre-fix policy. `independent-review-final-ack-race-execution.json` binds the second to `independent-review-pre-final-barrier-policy.cpp`. Both compile with ASan/UBSan and intentionally report 3 passed / 1 failed. Current regression coverage is in repository tests, not these historical fixtures. `independent-review.json` binds current sources, documentation, retained proof logs and the authoritative receipt.

## Remaining boundary

These tests execute production worker, driver and policy code with explicit bus, RTOS, GPIO, storage and display-hardware boundaries; they do not prove electrical interrupt timing, VBUS loss, latch reset, cable bounce, cell limits, actual termination or timer operation. An unreported physical source change cannot be established from software registers alone. Production charging remains CommissioningInhibited with J104 OPEN; the synthetic qualified profile exists only in host tests. Cold/depleted recovery, whole-board USB current, protection transients and physical charging qualification remain open. No flashing, charging, purchasing or physical tests were performed.
