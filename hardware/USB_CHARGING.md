# USB charging compatibility — A2.2

The selected input is now **GCT USB4720-03-A**, with two explicit CC
resistors on a separate USB daughterboard. The unknown AliExpress socket
is superseded; its low price alone does not establish whether it is faulty.

The complete analyser shows this circuit on **sheet 10, USB_Input**.
A separate editable project is `kicad/usb-input/Trimix_USB_Input.kicad_pro`.
J901/J902/R901/R902 are excluded from the main-board BOM and included in the
USB-board project. The existing charger input J101 remains two wires.

## Circuit and assembly

| Connection | Required part / destination |
|---|---|
| J901 CC1, A5 | R901, 5.1 kΩ 1%, to GND |
| J901 CC2, B5 | R902, 5.1 kΩ 1%, to GND |
| J901 VBUS, A4/A9/B4/B9 | J902 pin 1 → positive wire → main-board J101 pin 1 |
| J901 GND, A1/A12/B1/B12 | J902 pin 2 → return wire → main-board J101 pin 2 |
| J901 shell | GND |
| J901 data and SBU pins | Individually unused |

The GCT part is a bare connector: **fit R901 and R902 on our USB board**.
Keep CC1 and CC2 separate. These passive resistors remain present with no
battery or host power; no firmware is needed for source attachment.
A compliant A-to-C cable already supplies the source-side Rp in its Type-C
plug. Do not add Rp to this sink.
[TI sink-wiring guidance](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1287225/bq24075t-charging-li-ion-battery-from-usb-c)

GCT specifies a mid-mount footprint and **0.60 ±0.10 mm PCB thickness**.
Use a dedicated thin USB board instead of fitting it to the 1.60 mm main
board. Support the assembly against plug forces and provide wire strain
relief. The manufacturer also provides a panel/gasket drawing; the final
cutout, support and sealing need mechanical verification.
[GCT manufacturer drawing, sheets 1–2](https://www.mouser.com/pdfDocs/USB4720-ProductDrawing.pdf)

The connector is IP67 rated, including mated and unmated states. That
component rating does not establish the enclosure rating or validate the
battery circuit. Charge only with the connector clean and dry; IP67 does
not authorize wet charging. The BQ25895, protected holder, thermistor and
qualified charging profile still determine charging safety.
[GCT product information](https://gct.co/connector/usb4720),
[GCT IP67 statement](https://gct.co/news/usb4720_30)

## How to check the old socket

1. Disconnect it from the charger, battery and every USB source.
2. Use a bare USB-C test plug/breakout that exposes CC and has **no fitted
   pull-up/pull-down resistors, PD trigger or other active circuitry**.
   Otherwise the fixture can hide missing resistors in the socket.
3. Measure resistance from the plug's CC test point to socket GND, then
   reverse the plug to reach the other receptacle CC contact. Expect about
   **5.1 kΩ in both orientations** for a simple passive sink assembly.
4. If CC1 and CC2 are independently accessible, check that they are not
   shorted together. Two independent 5.1 kΩ resistors give about 10.2 kΩ
   between CC1 and CC2 through GND. Internal electronics can change these
   readings, so unusual results require inspection rather than guesswork.

The two power wires alone cannot reveal both CC connections. An open
CC-to-GND path would fail the required passive circuit. A basic functional
check is whether a known-good C charger/cable supplies nominal 5 V with the
plug both ways up; that alone does not prove the wiring is correct. Never
measure resistance while powered or poke a meter probe into live USB pins.

## Power limits

This is a dataless 5 V input. The BQ25895 data-detection pins remain separately
unconnected, selecting its nominal 500 mA input setting; its actual battery
charge current depends on available input power and system load. The 620 Ω
hardware ILIM resistor is a separate backup ceiling, not a precise 500 mA
limit. No USB PD contract or 1.5/3 A CC-current detection is implemented.
[TI BQ25895 floating-data-pin confirmation](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/784019/bq25895-bq25895-current-limit)

USB Type-C Release 2.5 §4.6.2.1 permits a dataless Power Sinking Device to
consume up to 500 mA with Default-current advertisement, subject to USB 2.0
inrush requirements. Sections 4.5.2.2.3 and 4.8.5 cover unpowered attachment;
Table 4-28 specifies Rd. This does not establish universal compatibility with
every old computer port, noncompliant cable or proprietary charger. Qualify
the charging adapters/power banks intended for use, including actual input
current tolerance, startup and inrush.
[USB-IF Type-C Release 2.5, March 2026](https://www.usb.org/sites/default/files/USB%20Type-C%202.5%20Release%20202603.zip)

A high-wattage USB-C PD charger can provide its default 5 V to a compliant
sink without a PD request. Its wattage label does not authorize this design
to draw higher current or request a higher voltage. Full device operation
plus charging can still exceed the available input power; battery assistance
or reduced charging is expected. The two cells remain 1S2P, 6800 mAh nominal.

## Physical acceptance checks — not yet performed

On the assembled USB board, verify each CC-to-GND resistance before
applying power. Check component values, solder bridges, harness polarity
and strain relief. The old-socket checks above are optional investigation;
that socket is no longer part of the selected design.

Keep charge ARM J104 **open** for the initial VBUS checks. Inspect polarity,
then use the intended charger and a known-good cable. Measure at J101 while
checking source turn-on; a power meter/test fixture and controlled load are
needed for current, cable-drop and inrush checks. Do not connect the Guition's
own USB power during these tests.

| Test | Required observation | Status |
|---|---|---|
| A charger → A-to-C cable, C plug each way up | Correct-polarity nominal 5 V at J101 | Not tested |
| C charger → C-to-C cable, all four end-orientation combinations | Source enables nominal 5 V every time | Not tested |
| C-to-C with an electronically marked cable | Same attachment behavior | Not tested |
| Above tests with battery disconnected and host off | CC attachment still works; no firmware dependency | Not tested |
| Controlled load near the intended input limit | Voltage/current within the qualified source and charger limits; no repeated resets | Not tested |
| Plug-in/startup/inrush | Meets source and USB inrush constraints; no transient overvoltage | Not tested |
| Charge ARM enabled after cell/NTC qualification, host off | Stable charging from both adapter types; correct pack voltage/current/temperature | Not tested |

Do not close ARM until cell charging limits, holder protection, polarity and
the pack thermistor have been verified. A successful USB attachment test is
not a validation of the battery charging profile.

## Saved checks

The ten-page schematic passes KiCad ERC with zero errors and zero warnings.
The CLI netlist independently confirms two separate CC nets, each containing
only its socket contact and resistor; both resistor returns join GND. All
existing main-board pin-net memberships are preserved. Results and explicit
physical-test status are in `verification/analyzer/usb-compatibility.json`.
The existing 3D board remains a main-board placement study. The USB
daughterboard is a separate assembly; its footprint and mounting need
mechanical review before PCB fabrication.
