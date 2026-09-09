# Isolated BQ temperature-sense routing proposal

The accepted local proposal is `Trimix_Analyzer.kicad_pcb`, based on the immutable
`lower-bq-base-v2.kicad_pcb` snapshot. It completes only the missing PACK_TS edge to
R102.1. Main and USB native files were not edited.

- Source SHA256: `7fcbe36b68eac608b680227c07f77007240863bfe70c965aa21f78238f322458`.
- Output SHA256: `40158632831955192a2603701a928c6f53594d5937f9eee2602a55cd93141205`.
- Exact integration delta: `final-delta.json` (six added 0.15 mm tracks and one
  ordinary 0.50/0.25 mm through-via; no removed or modified existing copper).
- Native verification: `final-drc.json`; 39 pre-existing dangling-only findings,
  40 unconnected items, and zero schematic-parity findings. The supplied source
  had 41 unconnected items and the same 39 dangling findings.
- `local.png` / `local.svg` show the final F, B and In2 copper geometry. Filled
  planes are omitted in this review rendering; native plane outlines and fills
  were checked separately.

The B branch starts at (11.548,85.700), exactly on the existing TS diagonal,
then follows (10.900,85.700), (10.550,86.050), (10.550,88.300),
(10.150,88.700), and (10.150,89.075). Its final via connects through the short
F track to R102.1 at (10.900,89.075). No new In1 or In2 signal tracks were added.
The protected ground-plane outlines and every component footprint are unchanged.

The smallest nominal clearance from added tracks/via to unrelated physical
pad/track/via copper is 0.250 mm. This is an analytical geometry check, not a
manufacturing tolerance guarantee. The new via has a nominal 0.125 mm annulus,
and does not overlap an SMD land. Filled-zone clearances passed native DRC.

The earlier suggested dense via at (10.45,88.375) was withdrawn before use:
the REGN F track at y88.15 obstructs it. No dense-via rule exception is needed.

## Remaining bounded routing findings

STAT was not completed by the bounded X0..21, Y75..91 proposal. Its B-side source
pocket is bounded by the PACK_TS vertical at x10.8408, y82.1422..84.9928 and the
diagonal to (11.6116,85.7636), the 0.4 mm PACK_P roof through
(10.64,79.9091), (12.7684,82.0375), (16.154,82.0375), and the PGND exposed-pad
area x11.65..14.35, y82.65..85.35. Nearby I2C and GND vias constrain lower and
F-side escapes. A bounded conservative raster failure is not proof of global
unroutability; no barrier, clearance, component or plane was changed to force it.

ILIM remains with the main PCB owner. The CE and TS escape vias at
(12.75,86.65) and (13.75,86.60), each 0.45 mm, leave only about 0.15125 mm
between their 0.20 mm clearance envelopes. R101.1 REGN immediately below
(bounds x13.275..14.075, y87.075..88.025) obstructs the onward F escape.
No reduced-width track, component movement, or existing-via movement was made.

## Reproduction and integration

`add_ts_clean.py` regenerates the final additions from `before-v2.kicad_pcb`
using KiCad's bundled Python, then refills zones. UUIDs are regenerated, so use
the frozen board and `final-delta.json` for the actual integration receipt.
The main owner should copy only these seven copper objects into its current
board, refill, and repeat native DRC/parity because other routing proceeded
independently. This proposal is not an all-board manufacturing release.

Final DRC command:

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc --format json --schematic-parity -o hardware/system-review/electrical/routing-candidate/independent-bq/final-drc.json hardware/system-review/electrical/routing-candidate/independent-bq/Trimix_Analyzer.kicad_pcb
```

The macOS CLI was run outside the restricted sandbox because application
registration crashed in the sandbox. Earlier `landing-only-drc.json` is an
intermediate pre-refill diagnostic and must not be used as final verification.
Earlier raster intent files are retained for traceability; only the frozen
final board, `final-delta.json`, and `final-drc.json` describe this proposal.
