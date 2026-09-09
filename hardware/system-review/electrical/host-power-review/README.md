# Guition host power and service isolation

**JP1 power-input suitability and simultaneous-source operation remain unqualified.**
The analyzer's LM66100 protects the analyzer against reverse current on HOST_5V.
It does not establish that externally driving the Guition board's own 5 V rail
is permitted, or isolate the Guition's two USB sockets from one another.
No harness, PCB or Guition board was modified by this inspection.

## Evidence checked

The [Guition specification, V1.0](https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/FTPData/UEditor/file/2026121/1768961095795/JC4880P443C_I_W%20Specifications-EN-V1.0.pdf)
identifies the expansion header as **2×13, 2.54 mm** on page 5. This establishes
the catalog pitch; it does not establish the fitted header's post tolerance,
plating, pin-1 orientation or compatibility with a particular socket. Page 4
specifies 5 V and approximately 320 mA, with no maximum startup/radio/backlight
current. The rendered interface page was inspected and retained here.

The previously archived schematic crops `../sources/guition-power.webp` and
`../sources/guition-usb-jp1.webp` were also inspected. They show:

- JP1 pins 2/4 on VCC5V, connected through R22 to VOUT-BAT and U5/IP5306 VOUT.
- Both Guition USB sockets sharing USB5V_IN, which feeds U5 VIN.
- JP1 3.3 V supplied from the host regulator; the analyzer uses that rail for
  logic, ADCs and USB source detection.

[Injoinic IP5306 V1.32](https://www.injoinic.com/api/static/uploads/20250528/20250528180813_6836e08d3eb50.pdf),
page 6, describes VIN as the charging input and VOUT as the boost output.
Pages 7–8 give operating conditions but no located guarantee for externally
back-driving VOUT with the battery absent. The published pin functions alone
cannot prove the proposed JP1 feed safe. This is a missing operating-mode
specification, not a prediction that the actual board will fail.

Downloaded originals and hashes are in `sources.json`. These documents retain
their manufacturers' terms. The two schematic crops are existing project
evidence; actual board revision and fitted parts must be confirmed.

## Consequences for this build

The native candidate still allocates HOST_5V to J301 pins 2/4. Finalizing copper
for those contacts does not release the remote harness. Resolve the remote
power entry before installation: obtain a manufacturer-supported JP1 input
mode or qualify a suitable input-side connection. An input-side alternative
would require a revised harness map and CAD clearance checks; it has not been
silently substituted here.

Keep the Guition battery socket unconnected in this architecture. Connecting
the FMA pack to a second charger would create a different, unreviewed power
system. The protected pack belongs to J102 on the analyzer.

The two host USB sockets must not be assumed to provide independent power
inputs. For initial wired recovery, disconnect J301 from the analyzer and use
one host USB connection. Do not connect both host sockets to powered USB
sources. The analyzer's bottom charging connector is a different circuit.

LTC2954's forced shutdown removes the analyzer's switched supply. A Guition
powered separately through its own USB can remain alive after that action.
Therefore the forced-shutdown test must record every connected source; a
service setup powered externally is not the normal assembled power state.

## Controlled checks to close the interface

1. Identify the actual screen revision and U5 marking; verify the schematic
   rail paths by unpowered continuity and diode-mode measurements.
2. Establish an approved power-entry configuration before applying power.
   Record the required isolation/modification and update both logical and
   physical harness drawings if it changes.
3. With the pack and analyzer detached, characterize the host's input current,
   startup peak and minimum 3.3 V at full display/radio load. A nominal 320 mA
   figure is not a guaranteed maximum.
4. Verify the approved analyzer-to-host feed using a current-limited source.
   Measure unintended voltage/current at the unused host USB and battery
   interfaces. Do not use a computer USB port as a test load.
5. Test main on/off, host USB service power, attach/detach order, reverse
   isolation and forced shutdown with the final harness. Measure spare 3.3 V
   capacity and each parallel power-wire branch under cold and warm conditions.

All powered checks are pending. This expands acceptance gates EL09/EL12; it
does not add an unsupported power-input approval.
