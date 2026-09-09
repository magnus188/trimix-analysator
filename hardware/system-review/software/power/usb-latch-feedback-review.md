# USB authorization feedback and recovery

Reviewed and corrected 2026-09-07. This supplements the earlier command-only policy review. Physical testing remains pending.

## Confirmed problem

The authorization latch can clear asynchronously because of OVLO or a brief supply dip while the battery keeps the host powered. CC state and the charger's power-good/configuration registers can remain unchanged. The former armed fast path checked only those values and a software command epoch. It could therefore report `Qualified` forever for native USB-C current advertisement while the external latch remained cleared and hardware input current stayed at its low default.

A pre-fix harness linked the actual production policy, modeled the external Q clear without a command/CC/BQ change, and reproduced **1000 consecutive incorrect Qualified results over 500 simulated seconds**, with no new acknowledgement or rising authorization edge. AddressSanitizer and UndefinedBehaviorSanitizer reported no diagnostics. This was a recoverability/status bug: the independent low-current hardware protection still acted.

## Corrected contract

- U112 is the SN74AUP1G74 latch; its complement output is pin 3. U113 is the supervisor. PCB ownership confirmed Q112 DMN2056U-7, gate 1 from U112 Q-bar, source 2 to ground, drain 3 to `CHG_INT_N`, and a 100 kΩ gate pulldown. Existing R107 pulls the shared line to HOST_3V3.
- `CHG_INT_N` already reaches **J301.13 / GPIO49**. Firmware now configures GPIO49 as an input with the external pull-up. GPIO52 remains unused.
- The new `Actions::permission_feedback_high()` reads that line. With the host supply valid and the described hardware intact, HIGH indicates Q is set and the charger IRQ is released; LOW can mean lost Q or a charger interrupt. It is not a measurement of actual current or proof against a broken feedback wire.
- `Result::permission_command` and `Result::permission_confirmed` distinguish the GPIO command from observed authorization. The live service getter downgrades a cached Qualified result when current feedback is LOW.

The [latch datasheet](https://www.ti.com/lit/ds/symlink/sn74aup1g74.pdf) specifies the complementary output and asynchronous clear behavior. The [BQ25895 datasheet](https://www.ti.com/lit/ds/symlink/bq25895.pdf), pin table and §8.2.9.2, describes its active-low 256 µs interrupt pulses.

## Recovery behavior

Healthy armed polls retain permission. If feedback is LOW, the policy gives a short charger IRQ an opportunity to release; a released line with the same command epoch keeps the existing grant without cycling USB current. Persistent LOW instead forces command LOW, fresh source acknowledgement, the supervisor-release wait, current-limit programming and renewed source/fault checks, then a new rising authorization edge.

After every new HIGH command, the policy waits for settling and verifies feedback plus the command epoch. Missing confirmation returns Fault and restores command LOW and the 100 mA software setting. A held supervisor reset or stuck-low feedback cannot be reported as a successful grant. Repeated attempts remain bounded by the normal worker cadence. No feedback HIGH is required before the first edge, because LOW is expected when Q has been cleared.

There is no GPIO49 interrupt handler: an externally cleared Q holds the feedback line LOW until a successful new edge, so the existing approximately 500 ms worker poll can recover without needing to catch the original short event. Exact latency also includes existing I2C operations and task scheduling. Ordinary charger IRQs may be missed by that polling, but charger state/faults are already polled separately.

## RTOS timing

The policy requests 2 ms for IRQ/feedback settling and 40 ms before a new authorization edge. A raw `vTaskDelay(1)` can finish at an imminent tick and is not a guaranteed minimum wait. The physical USB adapter therefore converts these delays using ceiling(milliseconds × tick frequency / 1000) plus one tick for phase.

At the inspected 100 Hz configuration, the 2 ms request occupies 2 ticks (approximately 10–20 ms before additional scheduling delay), and the 40 ms request occupies 5 ticks (approximately 40–50 ms). At 1000 Hz, the corresponding earliest phase bounds are 2 ms and 40 ms. This preserves the supervisor's 28 ms maximum open-CT release delay and avoids spuriously cycling input current for an ordinary 256 µs charger pulse. Neither the pulse duration nor scheduler latency is represented as a universally guaranteed system maximum.

## Verification

`usb-latch-feedback-asan-ubsan.log` records **23 named assertions passed, zero failed**, alongside the original sequencing suite. Twelve new assertions cover:

1. Hardware-only Q loss with unchanged CC, software epoch and BQ power-good.
2. A short IRQ while armed without another acknowledgement or permission edge.
3. A short IRQ coincident with a new grant.
4. Stuck-low feedback returning Fault and command LOW.
5. Twenty consecutive failed rearm attempts while hardware reset is held.
6. Recovery after that reset is released.
7. Hardware clear coincident with the new edge.
8. Maintenance lowering the command during the settling wait.
9. Maintenance between feedback sampling and the final epoch check.
10. Maintenance during armed-path IRQ deglitch.
11. Millisecond counter wrap.
12. One thousand healthy feedback polls with no periodic permission/current interruptions.

The fake adapter models host command and hardware latch as separate states; lowering the host clock does not erase the latch. Tests execute the production policy implementation. The ESP GPIO wrapper was reviewed but is not exercised by these host tests. Root owns the subsequent full pre3/v3 builds, final source binding, and integrated hardware/netlist reconciliation. No additional source files or build-list changes are needed.

## Remaining physical checks

Confirm Q112 orientation, GPIO49 continuity, pull-up level, and feedback HIGH/LOW at real logic voltages. Repeat brief OVLO and VBUS brownout events with the host powered by the battery and GPIO50 deliberately held high. Scope Q, Q-bar, GPIO49, GPIO50, supervisor RESET and USB current; demonstrate a cleared latch remains at low current and recovers only after the fresh software sequence. Check charger IRQ pulses and held-low/stuck/reset cases. These tests, analog transient protection and current measurements have not been performed.

The hardware feedback solution was selected over periodic leases: it observes the relevant latch state and recovers when needed, without repeatedly dropping a healthy USB source for a 40 ms requalification interval and relying on battery assist.

## Integrated review clarification

The final ESP service getter retains the last successful GPIO command when sample evidence becomes stale. It clears confirmed authorization and reports Fault, but does not falsely report that a LOW command occurred. This small diagnostic correction does not change the hardware control sequence or the portable policy tested above. Both P4 builds were repeated afterward; the combined verification receipt binds the resulting source and images.
