# Trimix analyser — A2.2 engineering review

Open `kicad/analyzer/Trimix_Analyzer.kicad_pro`. The root schematic is a
numbered overview; double-click a block to open its circuit. A2 integrates
the power system, two oxygen inputs, MD62 bridge, wired BME280, experimental
ZE07-CO, and a momentary-button power controller. P1 in `kicad/power` and
the original EasyEDA import are preserved as historical references.

A2.2 selects GCT USB4720-03-A on a separate 0.60 mm USB daughterboard,
with two fitted CC resistors shown on sheet 10, `USB_Input`. Read
[USB_CHARGING.md](USB_CHARGING.md) for the wiring and pending physical tests.

This is a schematic review and an **unrouted placement preview**, not a
released PCB or a validated breathing-gas instrument. Electrical rules and
pin/net audits check the drawing; they do not establish gas accuracy,
charging safety, component authenticity, or thermal performance.

## Owner-confirmed configuration

| Item | A2 basis |
|---|---|
| Host | Guition JC4880P443C_I_W / ESP32-P4 touchscreen board |
| Cells | **Two 3400 mAh, 3.7 V 18650 cells in parallel: 6800 mAh nominal** |
| Capacity evidence | Owner explicitly confirmed 3400 mAh on 2026-09-05, overriding the 2200 mAh listing image and earlier 3700 mAh estimate |
| Protected holder | FMA FPML1S2P050C; retain its red two-pin RCY/BEC-style plug |
| USB input | GCT USB4720-03-A + two 5.1 kΩ CC resistors on a separate 0.60 mm board; two-wire output to charger |
| Oxygen | AO2 with its three-pin cable; separate R17JJ-CCR on SMB, connected only to this analyser |
| Chamber sensors | MD62, GYBMEP/BME280, ZE07-CO; harnesses up to 30 cm in a vented, regulated chamber near atmospheric pressure |
| Button | Owned green illuminated 12 mm, momentary 1NO, 3–6 V LED variant |
| Off state | Guition and gas sensors off; battery charging remains possible after commissioning |

Capacity alone does not establish the cells' maximum charge current or
allowed charging-voltage tolerance. The physical cell markings, reliable
cell specifications, matched-cell condition, holder protection behavior,
wire size and connector polarity remain commissioning inputs.

## Power, charging and shutdown

The always-connected domain contains the protected pack, BQ25895,
MAX17048 and LTC2954. The LTC2954-1 controls TPS63020 EN, switching the
5 V domain that supplies the host and sensors. No second MCU is required.

The charge ARM connection is **open by default**. Closing it permits the
BQ25895 to charge autonomously even with the P4 off. The external pack NTC
must contact the cells; the chamber BME280 is not a battery-temperature
sensor. All PCB ground returns go to the protected holder's P−, never
directly to raw cell negatives.

BQ25895's cold-start defaults include 4.208 V regulation and a 2.048 A
fast-charge register setting. The stated voltage accuracy at this setting
is ±0.5%; this spans about 4.187–4.229 V. The programmed charge-current
setting is further limited by available input power. Separately floating
D+ and D− select the chip's nominal 500 mA source limit. A2's 620 Ω ILIM
resistor is a backup ceiling, approximately 511–635 mA including its 1%
tolerance and TI's K-factor range; it is not a precise 500 mA clamp.
Qualify the cell, protection and USB source before closing ARM.
[BQ25895 datasheet](https://www.ti.com/lit/ds/symlink/bq25895.pdf),
[TI autonomous-operation guidance](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/704475/bq25895-is-an-i2c-buss-required-to-use-this),
[TI floating-data-pin guidance](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/784019/bq25895-bq25895-current-limit)

The P4 may configure a lower profile and disable the watchdog before
shutting down. Such settings survive while the charger retains valid power;
they do **not** replace qualification of cold-start defaults. Precharge,
termination and safety-timer behavior must also be checked with this pack.
Sheet 10 uses GCT USB4720-03-A with two fitted 5.1 kΩ CC pull-downs
on a separate 0.60 mm USB board. Its output reaches J101 through two wires.
The old socket is superseded. The connector is passive and does not supply
CC resistors or certify battery safety. Follow the manufacturer mounting
and gasket drawing, and qualify both cable types before use. See
[USB_CHARGING.md](USB_CHARGING.md).

The LTC2954 uses a filtered panel-button input, 33 nF ONT and 1 µF PDT.
A normal press produces an interrupt; firmware can stop measurements, save
state and pull KILL low. A sustained press forces power off independently
of firmware. The KILL pull-up is on the switched host 3.3 V rail, whose
startup rise must satisfy the controller's 400–650 ms blanking interval;
this does not require firmware to boot within that time.
[LTC2954 datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/2954fb.pdf)

**Disconnect the Guition's own USB power while testing this power system.**
Its onboard IP5306/5 V path can otherwise keep the host powered or create a
second supply path. Do not connect this pack to Guition CN4 in parallel with
the BQ charger. Source isolation must be resolved before allowing both USB
inputs together. The schematic's shutdown behavior assumes this condition.

The 5 V stage's 1 A figure is a design target, not a measured capability.
Guition's approximate 320 mA plus MD62's up-to-120 mA through its LDO already
use about 440 mA at 5 V before CO, other loads and conversion losses. A
500 mA USB input cannot guarantee full operation and charging simultaneously.
Test battery assistance, load steps, USB-only startup, and thermal behavior.

The red holder connector is modeled as a **wire-to-wire mating pigtail**.
RCY has no official PCB-mounted mate; the board needs a soldered pigtail or
another verified board-side connection with strain relief. Do not interpret
the preview's wire pads as a replacement battery plug. JST rates RCY at 3 A
with AWG22, and lower current with finer wire; the seller's holder rating
does not prove the entire assembled path meets 5 A.
[JST RCY specification](https://www.jst-mfg.com/product/pdf/eng/eRCY.pdf)

## Oxygen inputs

AO2 and the standalone JJ sensor have separate differential signal paths
into one ADS1115 at address 0x48. They are multiplexed, not sampled
simultaneously and not independent redundant electronics. Calibrate each
cell and report its own validity and age.

The circuit biases both leads of each cell around half the 3.3 V supply
through high-value resistors and filters each pair symmetrically. This lets
a reversed cell produce a signed fault reading without intentionally
driving the ADC below ground. Use the ±0.256 V range after checking all
input limits; its nominal LSB is 7.8125 µV. At 8 samples/s, alternating the
two channels gives approximately four conversions/s per channel.

AO2's manufacturer specifies 9–13 mV in air and an external load of at least
10 kΩ. The intended input loading is much lighter, but actual ADC loading,
filter settling, leakage while off and noise must be measured. The schematic
does not apply excitation across either galvanic cell. Do not fit a 50 Ω
termination to the coax. The SMB shell is a **signal return**, isolated from
ground and chassis. Verify both sensor cable polarities before connection.
[Honeywell AO2 datasheet](https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/gas-sensors/automotive-and-emissions/documents/hon-ia-hss-automotive-ao2-o2-gas-sensor-dts-en.pdf),
[TI ADS1115 datasheet](https://www.ti.com/lit/ds/symlink/ads1115.pdf)

## MD62 bridge

Winsen specifies **3.0 ±0.1 V constant-voltage excitation** and consumption
up to 120 mA. The SPX3819 3.0 V LDO is fed from switched 5 V for dropout
margin. Its enable has a default-low bias. Keep this heater/LDO and the
switching converters thermally separated from the chamber's humidity sensor.

At the MD62, connect the outer detector lead marked with a black square to
ground, the outer compensator lead to 3.0 V, and **join the two inner leads
to form HE_SENSE**. The manufacturer drawing does not assign pin numbers;
the harness numbers are our assembly convention, not sensor pin numbers.
The other bridge arm is 2 kΩ + 500 Ω multiturn trim + 2 kΩ. A second
ADS1115, at 0x49, measures the difference between the trim wiper and sensor
midpoint. Start at ±2.048 V range, establish polarity with known gas, then
select a narrower range if justified. Verify 3.0 ±0.1 V at the actual sensor
under load, not only at the regulator.
[Winsen MD62 manual, circuit drawing](https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf),
[SPX3819 datasheet](https://www.maxlinear.com/ds/spx3819.pdf)

MD62 is sold as a thermal-conductivity CO₂ sensor. Using it for helium is an
experimental inference from conductivity, affected by gas composition,
temperature, pressure, flow and humidity. Its output does not directly
encode helium percent. Establish warm-up stability and calibration using
known He/O₂ mixtures over the intended conditions. Do not copy an arbitrary
millivolt-to-percent constant from the inspiration project.

## BME280 and CO harnesses

The pictured GYBMEP board uses VIN, GND, SCL and SDA. Its shared BME/BMP
silkscreen and a seller's “5 V” name do not prove chip identity or I/O levels.
A2 defaults to 3.3 V module power and includes an I2C level interface. Before
selecting another module supply, inspect its regulator and pull-ups, measure
logic voltage, and confirm BME280 ID **0x60** at 0x76 or 0x77. BMP280 does
not measure humidity. Use 100 kHz and verify rise time with the actual short
harness and combined pull-ups. Keep the module dry and away from heat sources.
[Bosch BME280 datasheet](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf)

ZE07-CO measures carbon monoxide, **not CO₂**. Its 5–12 V requirement is
handled with a separate nominal 5.28 V boost supply, leaving Guition's 5 V
rail unchanged. Measure voltage at the module, including ripple and cable
drop. Its 3.0 V UART is translated using TXU0202 and a separate 3.0 V logic
supply; module pin 1 is reserved and is not a power source. The harness maps
VIN to pin 15, return to pins 5/14, TX to pin 8 and RX to pin 7.

This is an experimental indication only. Winsen excludes use in systems
related to human safety, and specifies 15–90% RH; dry cylinder gas can be
outside that range. No maximum/startup current is published in the reviewed
manual, so measure it. Validate warm-up, frame checksum, timestamps and
unplugged/stale-data faults. A zero warm-up reading is not a clean-gas result.
[ZE07-CO manual](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf),
[TI TXU0202](https://www.ti.com/lit/ds/symlink/txu0202.pdf),
[TI TPS61023](https://www.ti.com/lit/ds/symlink/tps61023.pdf)

## Firmware interface contract — implementation still pending

The present firmware uses simulated sensors and battery readings. This
hardware revision does not implement real drivers or the shutdown sequence.

| Signal | Guition JP1 | P4 GPIO / purpose |
|---|---:|---|
| I2C_SDA | 21 | GPIO28, dedicated sensor bus |
| I2C_SCL | 14 | GPIO29, dedicated sensor bus |
| CO_UART_TX | 12 | GPIO30, host transmit |
| CO_UART_RX | 10 | GPIO31, host receive |
| POWER_INT_N | 19 | GPIO32, button interrupt |
| POWER_KILL_N | 8 | GPIO33, open-drain shutdown assertion |
| HE_ENABLE | 17 | GPIO34, enable after ADC is powered |
| CHG_INT_N | 13 | GPIO49 |
| GAUGE_ALERT_N | 11 | GPIO50 |
| CO_UART_EN | 9 | GPIO51, enable after CO rails are valid |

I2C addresses: MAX17048 **0x36**, O₂ ADS1115 **0x48**, He ADS1115 **0x49**,
BQ25895 **0x6A**, BME280 **0x76 or 0x77**. The old power draft's 0x6B note
was incorrect. Do not reuse the touch bus (GPIO7/8, JP1 pins23/25) for the
new external harnesses. Confirm the actual Guition board revision and JP1
orientation before assembly.
[Guition vendor schematic mirror](https://github.com/ultramcu/guition-jc4880p443c-i-w/tree/master/schematic)

Shutdown software should stop conversions, disable MD62 and CO translation,
save state, then drive POWER_KILL_N low. Initial commissioning should check
that a long held button removes switched power even if firmware is stalled.
Keep `co_ppm` separate from the existing `co2_ppm`; add per-oxygen-channel
readings, calibration and faults rather than silently averaging them.

## Evidence and next engineering steps

The exported PDF, ERC result, intended pin maps, CLI netlist, BOM and
connectivity audit are in `verification/analyzer`. The preview manifest
records all provisional footprints and 3D models. Verify component markings,
footprint drawings, connector orientation, capacitor effective capacitance,
inductor saturation current and regulator thermal layout before routing.
Do not order boards from an unrouted placement preview.

The project is inspired by
[captainigloo/Trimix-analyzer](https://github.com/captainigloo/Trimix-analyzer).
A2 uses manufacturer pin drawings for the new circuits. No firmware or
schematic artwork from that repository was copied into A2. Its repository
declares CC BY-NC-SA 4.0; preserve appropriate attribution and review that
license if copying its material in a future revision.
