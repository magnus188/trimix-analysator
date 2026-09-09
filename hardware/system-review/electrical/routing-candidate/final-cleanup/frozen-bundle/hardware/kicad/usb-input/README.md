# USB input daughterboard — A3 USB6 + ESD

Open `Trimix_USB_Input.kicad_pro`. The board is electrically routed and its
schematic matches the PCB, but **it is not ready to order**. The unchanged
GCT recommended lands conflict with the general fabrication constraints:
0.10/0.15 mm copper-to-edge gaps and two 0.15 mm PTH annular rings.
No copper-edge exception hides these findings.

- J901: GCT USB4720-03-A; fixed mid-mount pose and original Rev B lands/cutout.
- U901: TPD4E05U06DQAR, four signal ESD clamps. Real PCB copper bridges
  1–10, 2–9, 4–7 and 5–6; the chip's NC lands contain no internal connection.
- D901: TPD1E10B06DYAR, VBUS ESD suppression. It is not a 5.5 V voltage clamp.
- J902: six soldered wires to main PCB J101, using identical pin numbers:
  **1 VBUS, 2 GND, 3 CC1, 4 CC2, 5 D+, 6 D−**.

R901/R902 are removed. The main-board TUSB320LAI provides the independent
CC pull-downs; a disconnected six-wire harness cannot provide attachment.
Data wiring is for BC1.2 source detection, not a high-speed USB data port.

The two-layer board is nominally 16 × 15.72 × 0.60 mm, with finished thickness
0.60 ±0.10 mm. Manufacturing needs a supplier/assembler-approved solution
for the original connector's land/cutout and tolerance requirements, and the
fine USON pads. Do not shrink purchased parts, erase the findings, or silently
relax the fabrication rules. Reflow assembly, connector support, harness fit,
source changes, hot plug, temperature and assembled-port ESD remain physical
checks. Sealing is not established by the connector's component rating.

See `../../system-review/electrical/usb-final/README.md` for sources, exact
routing/height contracts, integration instructions and diagnostic exports.
The local STEP models for U901/D901 are unchanged KiCad nominal package
illustrations, not exact manufacturer CAD; maximum purchased envelopes are
recorded separately. Existing model licenses and exceptions are retained.
