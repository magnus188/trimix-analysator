# Off-device charging functional review — baseline before implementation

This document preserves the read-only findings that prompted the approved
software change. Its “unimplemented” observations describe that earlier source
snapshot (`review.json`), not the revised firmware. See
[the implemented standby policy and current verification](standby-implementation.md).
Production charging remains inhibited and J104 remains OPEN.

**Normal useful charging with a dark screen is not implemented. It can be added
as a host-alive standby policy without changing the present power topology.
True hardware-off charging remains limited by the nominal 50 mA USB path;
depleted-pack recovery is unproven and is not solved by standby software.**

This is a read-only review of current source/netlist behavior. No charge
configuration, firmware, schematic or board was changed, and no device was
energized. The current J104-open commissioning configuration intentionally
prevents charging.

## Observed implementation

1. `system_power.cpp` turns every accepted short-button event into
   `system_power_shutdown(2500)`. Shutdown obtains maintenance, forces
   GPIO50/AUTH LOW, stops acquisition, pauses writes and asserts KILL LOW.
   Low measured pack voltage also requests shutdown after three polls.
2. Netlist U801/LTC2954 EN controls U201/TPS63020 EN. Removing switched 5 V
   removes the Guition's HOST_3V3, which powers U110/U111 USB detection,
   U112 authorization latch and U113 supervisor. Q111's GPIO50 branch is
   pulled down by R117; Q110 has R118. Fast permission therefore cannot
   persist as an operational high-current grant with the host unpowered.
   R119 leaves U114 at its nominal 50 mA setting.
3. The BQ charger is upstream of switched power. J104 connects VSYS to Q101's
   gate; open J104 leaves Q101 off and R104 pulls CE high. A qualified closed
   ARM would pull CE low independently of the host, but does not set registers.
4. `power_monitor.cpp` explicitly clears CHG_CONFIG/OTG, reads this state back,
   disables the watchdog and enforces it on subsequent polls. There is no
   charging-enable/profile API. Increasing the permitted input budget to
   1400 mA does not enable charging. Closing ARM alone is not a completed
   charging implementation.
5. With a still-powered charger, host shutdown is not a BQ reset. Its last
   inhibited register state can remain inhibited after the screen turns off.
   Conversely, a future enabled profile could remain enabled. Complete power
   loss/reset returns the charger to its own defaults; this also needs cell
   qualification, because software is absent at that moment.
6. USB attach is not wired to the LTC pushbutton. Plugging in USB while truly
   off does not itself start the host. SW101 is BQ QON service control, not an
   alternative high-current authorization or LTC wake path.

## State table

| State | Host / acquisition | USB input permission | Charging consequence |
|---|---|---|---|
| Current commissioning, on, J104 open | Host and acquisition run | Qualified source may receive 1400 mA register request; others retain 100 mA request / nominal 50 mA hardware | Charging inhibited in hardware and software |
| Current short press / low-battery shutdown | Host switched off after maintenance | AUTH goes low; nominal 50 mA hardware remains | Current CHG_CONFIG=0 can persist while BQ remains powered; no implemented off charging |
| Future charge-enabled software, existing shutdown behavior | Host off | Nominal 50 mA | Only potential low-power autonomous charging; no useful full-charge-time guarantee |
| Proposed charge standby, fresh qualified higher-current source | Host alive; backlight dark; helium/acquisition stopped | Normal fresh source policy, feedback and fault handling continue | Can support ordinary charging after profile/cell qualification and measured positive net charge margin |
| Proposed standby, USB default/unknown/fault | Host may exceed available power | No high-current grant; nominal 50 mA | Must not claim charging or remain indefinitely draining the pack; defined fallback needed |
| True off, USB newly attached, usable battery | Host remains off until button | Nominal 50 mA | Depends on retained/reset BQ state, ARM and qualified autonomous profile; not fast charging |
| Deeply depleted or protection-disconnected pack | No host available to run policy | Nominal 50 mA; no software path to grant more | Cold recovery remains an unresolved hardware/pack/charger interaction |
| Forced long press, including standby or stalled firmware | LTC independently removes switched power | High-current branch loses host command/supply | Must remain true hardware off; useful charging may stop or fall to the low-current path |
| USB removed during standby | Battery would support host | Permission must fall immediately/fresh-source evidence invalidates | Stop standby and enter orderly off unless the user explicitly wakes the analyzer |

## Primary-source constraints

The BQ needs CE low and CHG_CONFIG enabled. Its documented defaults are
4.208 V, 2.048 A fast charge, 128 mA precharge and 256 mA termination. DPM can
reduce charging to zero; termination is suspended during DPM and the safety
timer normally runs at half rate. The default fast-charge timer is 12 hours,
precharge has a four-hour limit, and the timing table separately lists a
two-minute USB100/default case. Poor-source qualification draws a typical
30 mA. These facts require the actual cold-start source classification,
registers and timer behavior to be established; they do not prove recovery
behind this limiter. [TI BQ25895 Rev C, §§8.2.3.2, 8.2.6.2, 8.2.7, 8.3](https://www.ti.com/lit/ds/symlink/bq25895.pdf).

TUSB320LAI supplies dead-battery Rd with VDD absent, so absence of host power
does not itself remove USB-C sink attachment. Active CC/BC1.2 classification
and this project's fresh-edge grant still require the host.
[TI TUSB320LAI Rev D, §7.3.3](https://www.ti.com/lit/ds/symlink/tusb320lai.pdf).

LTC2954's KILL blanking is 400–650 ms after enable, and its held-button
power-down timer is independent of the processor. Here R803 senses HOST_3V3
at KILL; the host rail must rise in that hardware window, not merely finish
firmware later. C804 programs the held-button timeout. Standby keeps this
circuit enabled and must not defeat its forced-off behavior.
[ADI LTC2954, electrical characteristics and operation](https://www.analog.com/media/en/technical-documentation/data-sheets/2954fb.pdf).

An illustrative energy calculation using the user's unverified 2 × 3400 mAh,
3.7 V labels gives 25.16 Wh. Nominal 5 V × 50 mA supplies only 0.25 W, giving
about **101 hours at impossible 100% efficiency and zero other load** to add
that energy. This is not a charging-time prediction. It shows why calling the
true-off path ordinary overnight charging would be misleading, and why timer
behavior matters. A small amount of recovery energy sufficient to boot may
be possible; that is a different and still unverified claim.

## Smallest useful software feature, still unimplemented

Implement an explicit `ChargeStandby` operating mode, separate from maintenance
and true off. Enter it for a normal short press only when a qualified source,
validated charge profile and usable battery reserve make it appropriate.
Retain the running power/source worker, GPIO50/feedback monitoring, charger
readback, fault handling and normal source-change requalification. Leave KILL
released. A later normal press restores the analyzer and its full sensor
warm-up/validity sequence; forced long press stays hardware off.

Current code has specific obstacles that need tests, not just a new UI label:

- Maintenance Held inhibits AUTH, so it cannot be used as permanent charge
  standby. Storage may use a bounded transition barrier without holding the
  USB source policy inhibited throughout charging.
- The power worker restarts a stopped acquisition worker whenever it is outside
  maintenance. A deliberate standby mode must suppress that restart and
  distinguish deliberate sensor stop from worker failure.
- `backlight_set(0)` clamps to 10%. The board's lower-level backlight function
  supports zero; a managed standby override must actually allow darkness and
  restore brightness reliably.
- GPIO51 controls CO UART translation only. U701's CO regulator EN and U702's
  enable remain tied to switched 5 V. CO/module/display-logic idle load is not
  removed by stopping acquisition. Actual standby demand must be measured.
- The BQ driver currently treats any enabled charging as configuration drift
  and disables it. A future validated profile and explicit charging states,
  telemetry and fault latching must replace that inhibited-only contract.
- USB alone cannot justify bypassing critical battery shutdown. The current
  voltage guard needs an explicit standby policy based on validated voltage
  and net-power behavior, with hysteresis and no reboot/charge oscillation.
- Startup currently initializes the display at full backlight before USB
  qualification. This reinforces that a dead host cannot be rescued by a
  runtime-only standby change. Any later early-start optimization still needs
  real peak-current and hardware KILL-window tests.
- OTA health currently expects a live acquisition worker. Standby entered
  during probation must either be deferred or represented as an intentional
  healthy service mode, without accepting a genuinely stalled startup.

## Order and acceptance gates

**Software-completion gate:** select and implement the normal off/standby
behavior before presenting this PCB as a ready charging device. The proposed
mode does not itself demand a new PCB architecture. Source-policy and storage
protections must remain intact; current commissioning charge inhibit stays
until exact cells/NTC/profile acceptance.

**Hardware-feasibility gate:** do not promise automatic recovery from a deeply
depleted/protection-cut-off holder. Establish the cold BQ configuration, CC
attachment, default-limit startup and pack re-enable behavior with a controlled
fixture or explicitly accept the first PCB as an experiment for that question.
An approved external/manual recovery method would be a documented limitation,
not proof of the board's recovery capability. No new MCU is proposed here.

**Physical acceptance gate:** verify all source orientations/classes, positive
battery charging in standby, measured heat, timer and NTC/fault behavior,
USB removal, low-battery margins, forced-off rail collapse, repeated start and
holder protection recovery. No timing/charging claim becomes proven through
these read-only checks.

Minimum future production-core tests: run→standby→wake; same-source stable grant;
standby detach/default/downgrade/OVP/lost latch; interrupted save; no sensor
restart; no heater activation; profile readback mismatch; stale/low battery;
charge timer fault retention; normal/forced-off distinction; boot probation;
timer wrap and repeated transitions. Hardware tests remain necessary afterward.

`state-table.csv` and `review.json` provide machine-readable states and source
hashes. Existing `interface-contract.md` wording that low-current off recovery
"can recharge" should be read as a future possibility; it has not been proven.
