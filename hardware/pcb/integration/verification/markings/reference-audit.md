# Reference and silkscreen audit

## Saved-board baseline

The audit uses the actual saved `Trimix_Analyzer.kicad_pcb`, not the old preview. The main board has 133 footprints: 119 original electrical positions, 12 test pads and two mounting holes. It has **zero visible reference fields on F.Silkscreen**. Its 131 electrical/testpad references are on F.Fab, sized 0.65 mm with a 0.10 mm stroke; hole references are hidden. The four USB references are hidden; its existing front silk contains `USB A3`, `+` and `-`.

Immutable board copies and `baseline-markings.json` record this state. Main-board routing remains incomplete: the prior final checks recorded 288 unconnected items and 39 DRC violations. Adding markings must not be presented as resolving those electrical gates.

## Readability targets

Use **1.0 mm high characters and 0.15 mm strokes** as the practical minimum for normal reference labels. Prefer 1.2 mm / 0.18–0.20 mm for larger ICs, connectors and useful test labels where space allows. Use the native KiCad stroke font, consistent reading directions and unambiguous nearby placement. Keep full reference identities, including `TP1001`-style labels; do not silently abbreviate them into a different identifier.

JLCPCB's rigid-board capability table lists 1.0 mm text, 0.15 mm lines and 0.15 mm pad-to-legend spacing. Its blog quotes a lower absolute text limit, so the capability table's 1.0 mm value is the conservative reference here. This is a design target, not selection of a manufacturer or fabrication approval. [JLCPCB capabilities](https://jlcpcb.com/capabilities/pcb-capabilities)

Eurocircuits also recommends 1.0 mm character height for readability and lists a 0.25 mm clearance to routed board edges. Its assembly guidance reserves clearance from physical component bodies, separately from the copper/legend rules. [Eurocircuits legend guidance](https://www.eurocircuits.com/technical-guidelines/pcb-design-guidelines/legend-print/)

## Obstacles and placement strategy

- **Solder-mask openings are the fabrication obstacle.** Check the actual front mask opening geometry, including footprint/pad mask expansion. Copper alone may be smaller than its opening. Include exposed vias, test pads and NPTH holes/cutouts. A sensible design target is 0.20 mm from the outside of the full text stroke to mask openings, with 0.25 mm preferred where room exists.
- **Bodies are the visibility obstacle.** Printing a reference beneath a fitted package may be manufacturable yet unreadable after assembly. Prefer clear courtyards as a conservative proxy, or use verified body outlines plus a stated margin. F.Fab geometry and generic library models are references; some actual MPNs are still provisional.
- **Courtyards are not copper or measured body boundaries.** They include assembly allowances, can surround pad fields, and a bare test pad's courtyard is an access allowance. A courtyard intersection must be reported separately from a mask or actual body intersection.
- Existing front silk lines, polarity/pin-one marks, other letters and leader strokes are also obstacles. Preserve meaningful orientation marks. Check complete glyph strokes rather than only label-centre distances; text bounding boxes are useful for conservative early rejection.
- Keep all ink at least 0.25 mm inside the routed outline. Respect the actual stepped outline and cutouts, not only a 30 × 99 mm bounding rectangle. Reserve the screw-head/driver footprints so labels remain useful when mounted.
- Place connectors, ICs, test pads and larger parts first, then dense passives. Relocate references locally before reducing size. If a readable full reference cannot fit, retain it on an assembly layer/diagram and explicitly list the omitted on-board reference. Do not force all labels to 0.65 mm or move them across unrelated components.

For the companion part list, reconcile by exact reference. Distinguish fitted parts, four DNP options, twelve bare copper test pads, two mounting holes and the separate four-part USB board. Keep offboard sensor modules separate from board-mounted connectors. Show unresolved MPNs as provisional; do not convert a footprint name into a claimed purchased part number.

## Final verification

1. Compare saved before/after boards with a strict annotation-only allowlist. Preserve every footprint origin/rotation/side, pad geometry and net, routing item, zone/rule area, Edge.Cuts item, stackup and 3D model placement. Preserve all source schematic/project hashes.
2. Count visible references against the declared scope and inventory any intentionally unplaced labels. Check minimum font/stroke, duplicate/missing reference strings, mirrored text, wrong layers and orientation.
3. Check complete rendered strokes against front mask openings, board boundaries, other silk and chosen body/courtyard obstacles. Record actual rule margins. Any fallback that permits courtyard intrusion must be identified rather than silently treated as clearance.
4. Run saved-board KiCad DRC with the same rules and compare against the existing electrical baseline; require no new silk findings or unexplained electrical changes. A clean custom silk check is not a substitute for DRC.
5. Inspect actual KiCad SVG/raster output both enlarged and at nominal 1:1 size. Review dense analog/passive areas, test labels, large connector rows and polarity marks. The readable part list must use the same saved references and DNP states.

Final status: annotation-only, native-field, NPTH/head-reserve, DRC-delta and visual checks passed. See [the final independent audit](final-independent-audit.md).
