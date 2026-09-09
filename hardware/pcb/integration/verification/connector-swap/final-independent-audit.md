# Final connector swap audit

The saved main PCB passes the independent scope and geometry audit. The before snapshot, accepted candidate, and final board are bound by SHA-256 in [the machine-readable receipt](final-independent-audit.json).

| Check | Result |
|---|---|
| Approved placements | Only J401, J402, C401, C402, R401 and R403 changed |
| Outline | Three connected Edge.Cuts segments widened the upper tongue from 8.60 to 8.90 mm; no other outline changes |
| Remaining board changes | Reference/annotation changes only |
| Electrical identities | All 365 numbered pin/net identities unchanged |
| Part values | All 133 values unchanged |
| Footprints and models | Purchased geometry, pad shapes, net assignments, library identity and 3D model definitions preserved |
| Schematics and projects | All source guard hashes unchanged |
| Courtyard checks | No overlaps or courtyards outside the board |
| Copper to edge | Every F.Cu pad retains at least 0.50 mm; J402's upper shell pads have 0.54 mm on each side |
| H2 driver space | J402 courtyard clears the R3 mm reserve by 3.305 mm |
| Saved references | 133 visible: 31 front, 102 back; 1.0 mm font / 0.15 mm stroke, correct mirroring |
| Label mounting clearance | All 266 reference/NPTH and head-reserve comparisons pass |
| DRC | Existing 39 violations, 288 unconnected items, 0 parity mismatches; violation identities and ignored checks unchanged |

Final board SHA-256: `ee3a7f69268d7686dc596779be5a64fcf4cdf58d08b633d9e0861e05fafceae9`.

The strict comparison reconstructs the allowed six poses and four outline endpoint edits from the immutable before file, independently of the candidate, and compares every protected serialized node. Pad/property angle serialization that follows the three 90-degree passive rotations is explicitly checked; their dimensions, text values, identities and other attributes remain protected. The candidate-to-final comparison then confirms annotation-only changes.

This is an unrouted placement update, not fabrication approval. The existing electrical/fabrication checks remain open. Native enclosure, carrier and removal-path checks are separate evidence. The actual JJ-CCR 90-degree plug, cable bend space and J401 mating/removal envelopes remain unverified until the real connector dimensions are available. Current front, back and assembly PNGs were visually inspected and pass screen QA. The assembly SVG contains each of the 133 native references exactly once, and all 133 main-board reference/side entries in the readable CSV match the saved board. All reviewed artifact hashes are recorded in the receipt. This enlarged screen review does not establish physical print quality or mating-cable clearance.
