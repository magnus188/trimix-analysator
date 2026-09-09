# Independent main PCB CAM audit

**Final main exports have now been independently checked.** See [final-9f274fdf/README.md](final-9f274fdf/README.md) for the source-bound final review. Files in `diagnostic/` remain an immutable historical routing-in-progress snapshot, not fabrication data. The preparation notes and counts below describe that earlier snapshot.

This reader uses Gerbonara 1.6.3 to parse exported Gerber/Excellon bytes, sexpdata to read native coordinates and Shapely 2.1.2 for geometry. It does not use KiCad's API, renderer, connectivity engine or the PCB owner's audit scripts. The frozen USB independent review was read as a starting point and was not modified. No native PCB or schematic is written by this reader.

## Inputs and execution

Pass the final **same-revision** board, XML netlist, CAM directory and purchasing BOM explicitly:

```sh
/tmp/trimix-gerbonara-venv/bin/python \
  hardware/system-review/electrical/main-final-independent/audit_exports.py \
  --board /absolute/path/to/frozen-board.kicad_pcb \
  --netlist /absolute/path/to/frozen-netlist.xml \
  --cam /absolute/path/to/frozen-CAM-directory \
  --bom /absolute/path/to/purchasing-bom.csv \
  --out /absolute/path/to/independent-final-review
```

Expected CAM layers are `gtl/g1/g2/gbl`, front/back mask and paste, front/back silkscreen, `gm1` outline, separate `PTH.drl` / `NPTH.drl`, and `placement-all.csv` in KiCad's CSV format. It reads the native drill/place origin (zero if omitted). Neither bottom-X mirroring nor arbitrary rotation normalization is silently applied.

The BOM reader accepts `Reference`, `References` or `Reference(s)`; `Quantity` or `Qty`; and `MPN`, `MPN_or_description` or `Manufacturer Part Number`. Grouped reference lists are comma/semicolon separated. Exact known native MPNs must be present and equal. Reference/quantity reconciliation permits a complete assembly-reference map or purchasing items following explicit native `exclude_from_bom` flags. There is no implicit exclusion for missing rows. The diagnostic fixture intentionally has no purchasing BOM; final execution must provide the real one.

Input paths, byte counts and SHA256s are captured before and after the audit. Its own code and runtime hashes belong in the final review receipt. `requirements.lock.txt` records the temporary environment versions; the sibling USB review retains the package installation provenance. The geometry contact tolerance is 0.000002 mm; ordinary shape comparison tolerance is 0.000025 mm. These are numerical settings, not fabrication tolerances.

## Coverage

- Each distinct physical copper pad is matched by reference, pin where exported, net, centre, shape and orientation. Same-number split pads remain separate physical objects. Front and back X2 records provide pin attributes; the examined inner-layer export provides only reference/net, so inner pin identity is derived from the matching native position and shape rather than claiming a nonexistent pin attribute.
- The TPS63020 custom EP is constructed as the native anchor plus its eight polygon extensions. Its four separate paste-only custom shapes are checked independently. Custom primitive coordinates are reflected from native Y-down to Gerber Y-up before rotation. The bottom HotRod split pads and their rotations are included.
- Mask margins and all paste apertures are reconciled. In the examined 0.07 mm custom mask expansion, KiCad emits 45° polygon chords: the corresponding polygon is matched explicitly. It falls up to 0.005329 mm inside the ideal circular offset at the chords, which is reported rather than hidden by increasing the general comparison tolerance. Nonzero paste-resize settings not yet supported cause an explicit failure.
- Native tracks, every via land on four layers, saved zone-fill polygons and drill/slot shapes are compared. Exported Excellon coordinates have a 0.001 mm grid; up to 0.000710 mm vector error is allowed solely for coordinate rounding, with drill diameter still compared separately. Physical connectivity uses the actual exported hole positions, not their unrounded native centres.
- Eight diagnostic outline segments form one closed profile. The final reader requires the same topology unless explicitly extended and tested for an additional cutout; it does not silently union a cutout back into solid board.
- Copper graph construction removes the actual drilled-away interiors, splits disjoint region islands, and uses a per-layer STRtree to find touching objects. Plated-hole walls join only the layers traversed by the barrel. NPTH, equal net names, equal pin numbers and assumed internal chip connections never add electrical links.
- The graph reports shorts, open nets, unidentified copper islands, copper outside the outline and same-layer clearance observations. These are independent of the owner's native DRC. Gerbonara does not preserve Region X2 attributes; regions retain unknown net identity until connected to attributed pad or track copper.
- CPL parity follows the native `exclude_from_pos_files` flags, including explicitly excluded through-hole hardware. The diagnostic has 169 footprints and 154 exported placement rows: 12 test pads, two mounting holes and J102 are intentionally excluded. A purchasing BOM may still need J102 even though the placement machine file omits it.

## Failure controls

All controls modify only temporary in-memory geometry:

1. Removing a bridge splits a fixture into two components, even when both ends have the same pin label.
2. Adding a cross-net bridge produces a detected short.
3. One plated barrel joins four layers; the same hole marked NPTH leaves four separate components.
4. A single Gerber Region with two disjoint islands remains two disconnected graph nodes.
5. Cutting a moat around a real exported SMD pad creates an additional open on that net.
6. Bridging two real exported nets creates a detected mixed-net group.

The diagnostic has 1,406 copper nodes. Its spatial graph tests 830 candidate pairs instead of the 987,715 all-object pairs of a naive scan. Counts will change with final routing.

## Diagnostic observations and views

The copied board contains 169 footprints, 548 physical pad objects, 360 tracks, 67 vias and 153 holes. The independent reader compares 786 copper pad instances across four layers and 1,015 mask/paste pad apertures. All export-equivalence checks pass in the prepared reader; the expected routing-in-progress open nets and missing purchasing BOM remain separate failed gates. Those diagnostic results do not describe the final routed board.

`diagnostic/review/` contains rendered top, inner and bottom copper, mask/paste SVGs, and magnified actual copper/paste views for U201 and U115. Copper is gold and paste blue in the detailed views. Every layer uses top coordinates; the bottom image is not mirrored. The DSJ image preserves its four paste sections and extended pad geometry; the HotRod image preserves the split corner pads and two long central pads. These were visually inspected during reader preparation. Final views must be regenerated and inspected from the final supplied exports.

Export equivalence does not establish assembly yield, fabrication process capability, acceptable analog noise, regulator stability, thermal margins, ESD performance, gas performance, physical fit or overall product safety. Any outstanding native DRC, supplier or physical-test holds remain independent acceptance gates. This reader never creates an order release.

## Reproduce the diagnostic snapshot

The native copy is under `diagnostic/source/`; `capture.json` binds the live source at capture. All subsequent exports use that copy:

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb export gerbers \
  -o hardware/system-review/electrical/main-final-independent/diagnostic/cam/ \
  -l F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.Paste,B.Paste,F.Silkscreen,B.Silkscreen,Edge.Cuts \
  --use-drill-file-origin \
  hardware/system-review/electrical/main-final-independent/diagnostic/source/Trimix_Analyzer.kicad_pcb

/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb export drill \
  -o hardware/system-review/electrical/main-final-independent/diagnostic/cam/ \
  --drill-origin plot --excellon-units mm --excellon-separate-th \
  --generate-report --report-path hardware/system-review/electrical/main-final-independent/diagnostic/cam/drill-report.txt \
  hardware/system-review/electrical/main-final-independent/diagnostic/source/Trimix_Analyzer.kicad_pcb

/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb export pos \
  -o hardware/system-review/electrical/main-final-independent/diagnostic/cam/placement-all.csv \
  --format csv --units mm --use-drill-file-origin \
  hardware/system-review/electrical/main-final-independent/diagnostic/source/Trimix_Analyzer.kicad_pcb

/tmp/trimix-gerbonara-venv/bin/python \
  hardware/system-review/electrical/main-final-independent/audit_exports.py \
  --board hardware/system-review/electrical/main-final-independent/diagnostic/source/Trimix_Analyzer.kicad_pcb \
  --netlist hardware/system-review/electrical/main-final-independent/diagnostic/source/analyzer-netlist.xml \
  --cam hardware/system-review/electrical/main-final-independent/diagnostic/cam \
  --out hardware/system-review/electrical/main-final-independent/diagnostic/review \
  --diagnostic
```

`--diagnostic` still fails the command on export-equivalence or control errors; routing and missing-BOM findings stay visible in `audit.json`. Final mode does not suppress those gates.
