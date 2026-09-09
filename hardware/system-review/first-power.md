# Staged first-power procedure — draft commissioning record

**Do not energize the present unreleased board.** This procedure applies after
routing, fabrication inspection and interface release. It does not authorize
closing charge ARM, connecting unqualified cells or skipping a failed stage.
Record the board revision/serial, firmware hash, instrument model/accuracy,
source limits, readings and photographs at each stage. All stages are pending.

The owner has confirmed a soldering station, hot-air station, microscope,
DL24/P electronic load, DLA 24 MHz USB logic analyser, FNB58 USB tester,
multimeter, oscilloscope and DC PSU. See the [equipment and test record](lab-equipment.md).
Verify actual PSU current-limit/reverse-current behaviour, probe grounding,
instrument ranges and USB/battery fixtures before each stage. Availability is
confirmed; model-specific capabilities and all test results remain pending.

## 1. Inspect without power

Use the microscope to check factory-assembled IC pin1 orientation, bridges,
missing parts, DNP locations, inductor/capacitor markings and accessible solder
joints. Exposed-pad solder quality may require the assembler's inspection;
an attractive top surface is not proof of a good hidden joint. Keep J104 OPEN.

Disconnect USB, the pack, Guition and every sensor/harness. Confirm the current
BOM and connector pin map. Check continuity from each connector contact to its
named net, and check that the SMB shell goes only to its oxygen return. Check
rail-to-ground resistance after capacitor readings settle. A transient low
resistance caused by charging capacitors is different from a persistent short;
record the value and investigate discrepancies before applying power.

## 2. Isolate the pack-input power path

Leave USB completely disconnected. After the actual J102 polarity is confirmed,
a regulated bench supply can stand in for the protected pack **for this
single-source test only**. Do not connect a real pack in parallel. Do not
connect USB while using a source that cannot safely absorb reverse current.

Set the disconnected supply to **3.7 V** and start with a **100 mA current
limit**, output off. These are conservative commissioning settings, not a
measured startup-current specification. Connect through the verified protected
pack input with correct polarity, then enable the output. If it remains in
current limit or the voltage collapses, turn it off and investigate; do not
raise the limit repeatedly to force startup.

With no host or sensors attached, record PACK_P, VSYS and quiescent current.
Use the button to enable switched power and check the unloaded VOUT_5V rail
against the final converter tolerance calculation. HOST_3V3 is supplied by the
Guition and is expected to be absent while that board is disconnected; ADC
and controller operation cannot be inferred from this stage.

## 3. Check converter loads in controlled steps

Use a controllable dummy load or suitably rated external load resistors. Start
small and increase only after regulation/current readings are consistent with
the final load budget. Set the bench current limit from the approved load
calculation, allowing controlled startup margin. Do not exceed the converter,
trace, connector or fixture rating. Load resistors can become hot; keep them
outside the printed enclosure.

A DMM checks steady voltage and current. An oscilloscope is still needed for
startup overshoot, ripple, switch behaviour and load steps. Record the missing
waveform checks instead of treating a steady5V reading as a complete pass.
Repeat at the qualified pack-input range only after the nominal test passes.

## 4. Add the host, then one peripheral at a time

Power off before changing connections. Confirm the actual Guition JP1 pitch,
row orientation, pin1 and the5V/3.3V/ground mapping with unpowered continuity.
Use one power source. Keep the Guition's own USB disconnected until its
IP5306/backfeed arrangement has been tested with controlled supplies.

Run the correct application for the physical P4 revision. Confirm that missing
peripherals are reported as unavailable, then attach verified modules one at
a time with power removed. Check device identities, I2C/UART logic levels,
heater enable defaults and3.0V at the MD62 under load. Verify ADC input limits
through startup/shutdown, not just at equilibrium. Compare known small voltage
inputs with the DMM before any gas calibration; record instrument uncertainty.

With the CO converter starting, idling and supplying its qualified load, record
the MD62 excitation monitor and raw helium ADC data. The revised R504 route
has a ground reference between it and the inductor, but that does not prove
immunity to magnetic pickup. Check for false or missed excitation faults around
the configured 2.9–3.1 V window; use controlled voltage fixtures within the
verified input limits rather than stressing the sensor itself.

Test short press, long press and a deliberately stalled firmware case. A held
button must remove switched power through hardware. Check pending-save refusal
or completion and actual standby current. Verify that disconnecting the pack
is possible without a tool or finger bridging live test pads.

## 5. Test USB power separately from cell charging

Keep J104 OPEN and cells disconnected. Reconfigure the controlled test setup
so no nonsinking bench supply is connected to a path that might receive power
from USB. Start with a characterized nominal5V source and a verified harness.
Test A-to-C and C-to-C in the recorded orientations.

Without a powered host, this is a hardware-default/leakage test only: the CC
and BC controllers use HOST_3V3 and cannot provide firmware classification.
Do not raise the input limit to force the touchscreen to bootstrap. Complete
integrated source-classification tests require either a qualified source/sink
battery simulator or a qualified protected pack, with J104 still OPEN and
charge inhibition verified. Establish that fixture and the Guition power-entry
arrangement first. An ordinary nonsinking supply is not a battery simulator.

Measure conservative startup current, inrush, source classification and
permission changes. Check both sides of the input protection and limiter.
Capture voltage at the limiter input during hot plug, source changes,
undervoltage and overvoltage tests using a controlled fault fixture. Do not
inject an arbitrary high voltage with the ordinary charger attached.

Record the fitted C107 part number and capacitance. The refined board uses
47 µF / 10 V in an 0805 package, with greater nominal startup charge than
the earlier 22 µF / 25 V part. Capture BQ REGN rise, input-current demand and
any repeated startup at the qualified supply/load corners. The source-based
capacitance calculation is not a measured startup or stability result; see
[the C107 review](electrical/sensitive-layout-refinement/c107-0805/README.md).

Check that a source fault clears the hardware permission latch even with the
processor stalled HIGH, and that recovery needs a fresh permitted edge. Check
that an unknown/SDP source never gains high-current permission. A source's
wattage label and a successful attachment do not prove this behaviour.

For an unqualified legacy source, verify commanded and read-back BQ HIZ and
measure total VBUS draw under the applicable USB suspend conditions. The
50 mA limiter and 100 mA register setting are ceilings, not suspend-current
permission. The conditional standby estimate does not establish whole-board
2.5 mA compliance, especially with a battery present or the host unavailable.
For a stable DCP/CDP, run beyond the former 30-second failure interval and
check that charge enable and input power do not cycle. Inject a missed health
interval, detector reset and detach/replug; record actual cutoff timing.

## 6. Commission charging only after cell qualification

First establish exact cell model/chemistry, allowed charge voltage/current,
matching, holder/protection ratings, plug polarity and the pack NTC mounting.
Then establish a documented commissioning profile and the hardware ARM
procedure. The current firmware intentionally inhibits charging.

Measure charge/precharge/termination behaviour and both cell temperatures.
Test NTC open, short, hot and cold; input loss; charger faults and timers;
pack disconnection; and operation with the host off. Do not defeat a protection
or automatically restart a failed charge to obtain a full battery. Charging,
thermal and protection results remain pending until recorded.

Distinguish dark-screen standby from true hardware off. For a qualified profile,
measure standby draw and positive net battery charge, then check wake, source loss,
failed reads and held-button cutoff. Separately establish cold/depleted-pack
recovery and its startup timing; passing a standby test does not cover that case.
The synthetic profile in the test executable is not a commissioning recipe.

## 7. Characterize the complete instrument

Install the enclosure only after electrical and module-fit checks pass. Follow
the applicable MD62 conditioning instructions. Record pressure/flow,
temperature/humidity, elapsed warm-up, battery/USB state and reference-gas
uncertainty. Keep calibration mixtures and held-out validation mixtures
separate. The O2/He accuracy targets are unproven; a stable displayed number
is not a reference-gas validation.

For CO, record the actual chamber temperature, humidity and flow conditions.
The ZE07-CO manufacturer's operating and intended-use restrictions apply;
even a calibrated reading is not certification of breathing-gas safety. See
[the CO module review](electrical/co-module-use-review.md). A missing or
out-of-range environmental reading must leave CO unavailable, with oxygen and
helium handled independently.

Use [acceptance.csv](acceptance.csv) for the four explicit result categories,
[the electrical checklist](electrical/measurement-and-bringup.md) for remaining
measurements and [the harness packet](interface-packet.pdf) for logical wiring.
An unexpected result stops that stage and becomes a recorded correction.
