# GCT USB input daughterboard — A2.2

Open `Trimix_USB_Input.kicad_pro`. This is the same circuit shown on page 10
of the complete analyser, with its four parts included for a separate PCB.

- J901: GCT USB4720-03-A, selected replacement connector.
- R901/R902: fit 5.1 kΩ 1% on CC1/CC2 independently.
- J902: soldered two-wire output to main PCB J101, pin 1 positive and pin 2 GND.

Use 0.60 ±0.10 mm PCB thickness per the manufacturer drawing. The main board
stays 1.60 mm. This project has a checked schematic and a drawing-based
connector land pattern; final PCB outline, routing, mechanical support and
enclosure sealing have not been completed. The footprint cutout lines on
Dwgs.User are a guide, not fabrication Edge.Cuts. No exact STEP model is
attached. Do not order the unfinished PCB.

See `../../USB_CHARGING.md` for source references and physical tests.
