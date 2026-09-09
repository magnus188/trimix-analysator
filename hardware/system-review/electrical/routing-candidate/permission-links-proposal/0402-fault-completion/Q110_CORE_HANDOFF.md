# Q110 control crossing handoff — isolated intermediate

The frozen control-only candidate is `q110-core-frozen.kicad_pcb`, SHA256 `410863e7fe55cf52bb664136389c03dd37a7ea9339eb100a9444632a11f36ece`. Its immutable baseline is `before.kicad_pcb`, SHA256 `edbad7a2e3e3414805d987dabb31f502318e73d42fd39eee08d2692c5104bf17`.

Apply only `q110-core-delta.json`: eight removed copper items, nine added segments, and five changed items (Q110 footprint, two existing ground vias, and two incident ground-return segment endpoints). The authoritative project was not edited.

- Q110: F.Cu, centre (18, 89.5), 180 degrees; exact purchased footprint unchanged.
- SERIES: all F.Cu, 0.15 mm, from Q110.2 to Q111.3.
- Gate: all F.Cu, 0.15 mm, from Q110.1 to the existing Q via (16.1827, 91.7017).
- Two GND vias: (20.3, 87.85) and (20.75, 88.3), retaining 0.60 mm copper / 0.30 mm drill. Their original B.Cu ground endpoints remain connected through 0.20 mm tracks.
- Q In2 segment replaced by the path (17.5142, 91.7017) → (21.4, 88.8) → (22.0427, 87.1732).

All R116/R118/R119 trial package, placement, field, and copper changes are excluded. Those components match the baseline verbatim. The separate true0402 trials are unfinished and must not be promoted; the pending CE route conflicts with two earlier trial poses.

## Checks

Native KiCad DRC: zero copper/courtyard/keepout errors, zero schematic parity issues, eleven unconnected items (unchanged from this baseline). Thirty-four warnings comprise 24 dangling-copper warnings and ten silk warnings. The board is not a completed routing or manufacturing release.

Six direct native conductor witnesses pass: Q110 gate to U112.5, SERIES to Q111.3, and U115.8 plus R126.2 to each relocated GND barrel. Witnesses exclude planes and never assume internal IC/pad joins. Both ground barrels contact the continuous In1 ground fill.

Independent exact copper-shape checks find minimum gaps from the two relocated via copper shapes to any SMT land of 0.5503 mm and 0.7791 mm, including same-net lands. Native drill clearance checks also pass.

Filled In1 geometry is unchanged and remains one continuous polygon. In2 loses no filled ground copper and gains approximately 1.7015 mm²; all nine filled regions retain a via or plated-pad anchor to continuous In1. These are geometry and connection checks, not measured return impedance or thermal/current qualification.

Evidence: `q110-core-drc.json`, `q110-core-witnesses.json`, `q110-core-smt-clearance.json`, `q110-core-plane-audit.json`.

## Coordination still required

The PCB owner must route the direct CC connection against this actual Q110 pose. The earlier hypothetical CC curve intersects the relocated Q110 branch pad and cannot be copied unchanged. Final assembly/CAD review and full-board routing/manufacturing checks remain pending. Resume resistor placement only on the synchronized CC/R101/CE source.
