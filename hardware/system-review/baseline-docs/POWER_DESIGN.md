# Power system, P1.1 review draft — 2026-09-05

> **Historical power-only draft, superseded.** Do not build or program from
> the values, connectors or charging instructions below. The current combined
> source is `pcb/analyzer/Trimix_Analyzer`; use the
> [current electrical integration review](system-review/electrical/README.md)
> and its interface contract. This historical body is preserved for provenance.

Open **[pcb/power/Trimix_Power.kicad_pro](pcb/power/Trimix_Power.kicad_pro)**.
The [four-page PDF](verification/power/Trimix_Power.pdf) has an overview and
three circuit sheets. This is the replacement power design. The original
`pcb/archive/deprecated-kicad-import/Trimix.kicad_sch` is preserved for later recovery of the sensor circuits;
it is not electrically included in this new project.

P1.1 improves the presentation: numbered section frames, aligned headings,
explanations beside each circuit, and a navigable block diagram on the first
page. Solid overview arrows show power/sensing; dashed arrows show host
communication. The actual electrical wiring is on sheets 2–4. The charging
sheet and overview use A3; the regulator and gauge sheets use A4.

This layout revision preserves all 41 component values, footprints, symbol
selections, DNP states and electrical net memberships. The saved P1 project
and verification files are in `verification/power/before-presentation-layout.zip`.
Comparison evidence is in `verification/power/presentation-preservation.json`.

The circuit is a review draft, not a manufacturing release. The original
empty PCB has not been populated or routed. Charger firmware has not been
implemented. Assigned footprints are provisional until the orderable parts
and mechanical drawings are checked.

A separate [3D placement preview](pcb/power/previews/README.md) now shows
the 41 parts on a temporary 90 × 64 mm outline. It has no routing, nine
placeholder footprints and two approximate 3D bodies. It is an educational
view of the component groups, not a validated PCB layout or safety result.

## What each part does

| Stage | Function |
| --- | --- |
| J101 / external USB-C assembly | Brings USB 5 V and ground to the PCB. The ordered variant has two terminals. |
| U101 BQ25895RTWR | Charges a single lithium-ion voltage stack and supplies `VSYS` from USB or battery. |
| J102 / FMA FPML1S2P050C | Connects the protected red P+ and black P− leads of the user-approved 1S2P holder. |
| U201 TPS63020DSJR | Converts variable `VSYS` into nominal 5 V for the Guition board. |
| U301 MAX17048G+ | Estimates battery state of charge and measures pack voltage through I2C. It does not replace battery protection. |

Two cells in parallel remain a **1S** voltage stack: nominal 3.7 V, with a
conventional 4.2 V full-charge chemistry assumed pending exact cell identity.
The owner reports 3700 mAh per cell, so 7400 mAh is a provisional combined
capacity. An older order says 3400 mAh per cell; neither number has been
confirmed against physical cell markings or a capacity test.

All circuit ground is the holder's **protected P−**. No connection is made
to raw cell negatives or around the protection electronics. The seller
advertises 5 A discharge and protection against overcharge, overdischarge
and shorts; trip thresholds and charging-current rating remain unverified.
Use matching cells at closely matched voltages before placing them in a
parallel holder. Do not use the 5 A discharge claim as permission to charge
at 5 A. The fuel gauge becomes unavailable when holder protection disconnects
the pack; this is intentional.

## USB input and charging limits

The completed order is **black2 / 5pcs / 2P / Female Insert**. Its product
page is now unavailable. Only VBUS and ground are exposed to this design.
Whether it contains the required USB-C CC pull-downs is unknown. Check
each CC contact to ground with the disconnected assembly: a sink normally
has a separate nominal 5.1 kΩ Rd on CC1 and CC2. Do not short CC1 and CC2.
If Rd is missing and the pins are inaccessible, replace the socket assembly.
A C-to-C cable may not provide power without the sink termination.

The connector's advertised 3 A is a contact rating, not a source-current
agreement. This draft has neither CC current detection nor USB PD nor USB
enumeration. BQ D+ and D− are left open, DSEL is unused, and OTG is grounded.
Do not raise input current to 1.5 A or 3 A just because the jack says 3 A.
The next architecture decision is whether to keep this slow input or use a
connector exposing CC plus a suitable sink/current-detection circuit.

R103 = 680 Ω, 1% gives about **522 mA nominal** at KILIM = 355 AΩ.
The datasheet KILIM range 320–390 and resistor tolerance yield approximately
466–579 mA; ILIM behavior below 500 mA is not specified. It is an approximate
backup ceiling, **not a guaranteed 500 mA USB limit**. Firmware starts with
IINLIM = 450 mA. Validate actual input current and power-up behavior before
using an unrestricted USB source. Charging starts disabled, but `VSYS` can
still draw input power to run the host. USB current compliance and inrush
have not been established by ERC.

At 5 V × 450 mA the nominal input budget is only 2.25 W before losses.
Guition specifies approximately 320 mA at 5 V (1.6 W), without specifying
peak load. This leaves little charging power while the display is active;
the battery may supplement the supply during peaks. Full-load USB-only
operation and any charge-time claim require measurement. The TPS target
of 5 V / 1 A is a **battery-backed converter design target**, not the USB
input power rating and not yet a measured performance guarantee.

## Charger implementation and firmware contract

- Charging is inhibited by R104 pulling `/CE` to `VSYS`. Q101 pulls `/CE`
  low only when `ALLOW_CHG` is high. R105 pulls its gate low during reset
  or when the host is disconnected. This architecture requires an operating
  host to enable charging; autonomous charging with the Guition powered off
  is not implemented.
- Before asserting `ALLOW_CHG`, read and verify the BQ part identity and
  program/read back input current, charge voltage/current, timers and boost
  settings. Initial engineering targets are **450 mA IINLIM, 512 mA ICHG,
  4.192 V VREG**. Cell chemistry, authenticity and allowed charge current
  must be checked first. These are not instructions to enable charging now.
- Do not rely on the chip defaults (2048 mA charge-current setting and
  4.208 V regulation setting). Disable HVDCP/MaxCharge/automatic DPDM when
  configuring this two-wire 5 V input, and explicitly keep OTG disabled.
- Watchdog expiry restores most charger registers to defaults; IINLIM is
  among the retained registers. Define the driver's watchdog policy and
  fault recovery explicitly. Deassert charge permission on communication
  failure, abnormal pack temperature or charger fault. R105 does not detect
  a hung processor that leaves its GPIO high.
- A 7.4 Ah pack takes at least about 14.5 hours at a continuous 512 mA,
  before taper/losses. Review the safety-timer duration (20-hour selection
  is available) and DPM timer behavior against measured charging current.
  At the much smaller current available with the display running, a full
  charge can take considerably longer and the safety timer can expire.
  Keep temperature and safety protections active; do not automatically
  restart a timed-out charge to work around the power limitation.
- SW101 connects QON to ground for wake/reset behavior. It is not a general
  on/off switch; long assertion can reset the charger system output.
- R101 = 5.23 kΩ and R102 = 30.1 kΩ use TI's 103AT-2 thermistor network.
  Connect an external 10 kΩ **Semitec 103AT-2 characteristic** NTC to J103
  and thermally attach it to the cells. No fixed resistor bypass is fitted.
  Check open/short and hot/cold inhibit behavior before connecting cells.

## 5 V supply and gauge details

TPS63020 uses a 1.5 µH inductor, two 10 µF input capacitors and three 22 µF
output capacitors. R201/R202 = 1.62 MΩ / 180 kΩ sets nominal 5.000 V from
the 0.5 V reference; the actual tolerance includes the IC and both resistors.
VINA connects only to its 100 nF bypass capacitor: TI confirms that it is
internally fed through a resistor. An external VIN strap bypasses that filter.
PS/SYNC is high for forced PWM, PG is intentionally unused. J201 shorts EN
to ground to turn off the converter; open means on. This also removes the
host that enables charging, as described above.

The initial inductor candidate is Coilcraft XFL4020-152ME, cited by TI at
1.5 µH / 5.1 A saturation. At 3.0 V input, 5 V / 1 A output, assumed 90%
efficiency, 2.5 MHz and 1.5 µH, the estimated peak is about 2.01 A; allow
additional tolerance, start-up, transient and temperature margin. This
calculation is not a bench result or a thermal/layout validation.

The MAX17048 VDD and CELL both connect to protected `PACK_P`; CTG, QSTRT,
GND and exposed pad connect to protected ground. There is a 100 nF local
bypass capacitor. I2C addresses are 0x36 for MAX17048 and 0x6B for BQ25895.
Configure gauge compensation for the actual cells/temperature; an estimated
percentage is not a replacement for the holder's hardware cutoff.

## Guition connector contract — physical mapping still pending

J301 is **our new PCB's** two-pin power connector: pin 1 = `VOUT_5V`,
pin 2 = ground. J302 is **our PCB's** seven-pin logic connector:

| Pin | Net | Direction relative to new PCB |
| --- | --- | --- |
| 1 | GND | Protected common ground |
| 2 | HOST_3V3 | Input from Guition 3.3 V, for pull-ups |
| 3 | I2C_SCL | Host clock input |
| 4 | I2C_SDA | Bidirectional |
| 5 | ALLOW_CHG | Host output into Q101 gate |
| 6 | CHG_INT_N | Open-drain charger interrupt to host |
| 7 | GAUGE_ALERT_N | Open-drain gauge alert to host |

These numbers do **not** establish Guition's connector pinout. The firmware
currently uses GPIO8 SCL / GPIO7 SDA for the touch bus, as seen in
`main/board/guition_jc4880p443.c`; accessible pads and spare GPIOs still need
checking. R302/R303 are optional 4.7 kΩ pull-ups, marked DNP until the
board's existing pull-ups and total bus capacitance are known. Populate them
if needed and check rise time; DNP is not an assertion that the board's
pull-ups have been verified.

Verify Guition's 5 V input topology before simultaneously connecting its USB
and this supply. Backfeed isolation has not been added based on an invented
board pinout. The vendor's board schematic download was not accessible in
this session, so this remains a physical interface check before connection.

## Parts and layout still needed

See [power-inventory.csv](power-inventory.csv) for order evidence and
[verification/power/pcb-bom.csv](verification/power/pcb-bom.csv) for the PCB
components. A completed order is evidence of purchase, not a counted stocktake.

- BQ25895 was requested by the owner but not found by exact-name order
  search. MAX17048 and bare TPS63020 orders were found. The separate TPS63020
  modules ordered were the 3.3 V variant and are not substituted here.
- The stocked 1 µH inductor (0650 / 7 × 7 × 5 mm) is a candidate for L101.
  Its saturation current, DCR, temperature rating and actual land dimensions
  are unknown. L101 has no invented footprint assigned.
- The 0603 resistor kit was found, but individual precision values/tolerances
  need checking. BQ ILIM, NTC divider and TPS feedback resistors require the
  stated tolerances; 1.62 MΩ, 5.23 kΩ and 30.1 kΩ may need separate sourcing.
- Suitable power-stage ceramic capacitors were not established from orders.
  The through-hole 100 nF and electrolytic assortment are not substitutes
  for the close SMD ceramic bypassing. Select real X5R/X7R parts and check
  capacitance after DC bias and tolerance. In particular C102 must retain
  at least 8.2 µF at its operating voltage; its nominal 10 µF label alone
  does not prove that. Check input inrush with the final capacitors.
- The external 103AT-2 NTC, Q101, LED, switch, connectors and L201 need stock
  confirmation or sourcing. No purchases were made.
- Connector footprints, LED/switch selection, reverse-connection robustness,
  USB ESD/transient protection and the enclosure cable arrangement remain
  part of the next schematic/PCB review. The holder is the chosen pack
  protection; no second unverified PCM is cascaded with it.
- Follow the manufacturers' placement examples, exposed-pad soldering and
  thermal-via guidance. Keep both switching loops short and separate their
  return paths from the analog sensor/front-end return. Layout and thermal
  measurements determine whether the power target is achievable.

## Verification

The KiCad MCP created the hierarchy, placed the components and supplied the
pin coordinates. `tools/wire_power_draft.py` wires that initial placement
and records the intended connectivity. Do not rerun it after manual moves
without updating its recorded coordinates.

`tools/present_power_sheets.py` applies the P1.1 visual layout to the archived
P1 seed. It checks file hashes and refuses to overwrite subsequent edits it
does not recognize. Continue normal editing in KiCad; rebase the layout script
before using it on a later electrical revision.

KiCad 10.0.6 exports the complete four-page schematic and reports **zero ERC
errors and zero warnings**, with no rule exclusions or reduced severities.
Power flags only represent external supplies and the regulated system source
after L101; they are not physical components. Netlist membership comparison
and pin-number checks are recorded in `verification/power/connectivity-audit.json`.
ERC and connectivity checks do not validate USB compliance, cell suitability,
component authenticity, charging behavior or the future PCB layout.

## Primary references

- [TI BQ25895 datasheet, Rev C](https://www.ti.com/lit/ds/symlink/bq25895.pdf),
  pin functions, typical application, input current regulation and register map.
- [TI BQ25895 schematic checklist](https://e2e.ti.com/cfs-file/__key/communityserver-discussions-components-files/196/0456.BQ25895_5F00_SchematicChecklist-V1p1.pdf).
- [TI TPS63020 datasheet, Rev I](https://www.ti.com/lit/ds/symlink/tps63020.pdf),
  pin functions, component selection and application circuit.
- [TI clarification of the internally connected VINA pin](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/117826/tps63020-ps-sync-and-vina-connections).
- [Analog Devices MAX17048/MAX17049 datasheet, Rev 7](https://www.analog.com/media/en/technical-documentation/data-sheets/max17048-max17049.pdf).
- [Guition ESP32-P4 module specifications](https://www.guition.com/esp32p4-display-module/esp32p4-lcd-module),
  5 V and approximately 320 mA; not a peak-current specification.
- [TI discussion of a power-only USB-C sink](https://e2e.ti.com/support/interface-group/interface/f/interface-forum/799330/tusb320-usb-type-c-minimum-system-for-power-sink-only-and-no-data).

Seller pages and selected variants are in the inventory file. Seller ratings
are identified as claims and are not treated as manufacturer verification.
