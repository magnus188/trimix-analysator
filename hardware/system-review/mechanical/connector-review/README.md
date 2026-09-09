# Guition connectors and cable interfaces — current review

**ConnectorReview v3 is saved and reopened. The photo correction is adopted; a complete fitted harness and SD service path are not established.** SystemReview v11 and the intermediate photo archive remain unchanged. The enclosure remains 85 × 180 × 43 mm, with the original PCB, carrier, battery, sensor and feedthrough positions.

The current native file is [Trimix_Enclosure_A3_ConnectorReview_Interfaces.f3d](interface-checkpoint/Trimix_Enclosure_A3_ConnectorReview_Interfaces.f3d). Its SHA-256 is `a0500752f0875c7d9256fe17bc89b502b36bea4163c2bc10b4b3e8a689ad75f1`. [Summary](interface-checkpoint/summary.json), [export/source bindings](interface-checkpoint/export.json), and [native reopen](interface-checkpoint/native-reopen.json) provide the current evidence.

## Adopted correction

The obsolete nine-body Guition PCB illustration was retired. Three editable BaseFeatures now contain 36 supplied module details, one separate installed-card format reference and one hidden candidate-mate allocation. The supplied details remain under the single purchased Guition module; they add no separate purchasing quantities.

The model now shows all 26 header posts, including pin 7, with the header horizontal at the top; both USB-C mouths face rearward; the microSD holder faces left. Whole rigid detail occurrences follow `DisplayX`, `DisplayY` and `DisplayFront` through native joints. The measured glass-to-bare-tip distance is 13.4 mm, giving world Z13.8 at the present glass plane. The photo-position collar is ±2 mm in XY. Exposed PCB outline, component-base Z, USB/SD dimensions and socket mechanism remain reference geometry. The manufacturer's 60 × 108 mm grid belongs to the casing ears, not the exposed PCB.

[Rear inspection](guition-photo-rear.png) and [oblique inspection](guition-photo-oblique.png) show this geometry. The views predate the final status-only save; no subsequent geometry change was adopted.

## What the interface checks establish

| Interface | Current result |
|---|---|
| Guition remote JP1 socket | The nominal 35 × 5.5 mm conditional mate intersects housing, carrier and holder. The full ±2 mm photo collar also reaches the upper fixed PCB support. This is an unresolved installation conflict, not a qualified socket selection. |
| J301-to-display ribbon | Main J301 exits inward, −X. No complete 35 × 1.2 mm route is established. Cover retention rails, tall small-connector mates, and the remote +Y return constrain it. A folded or opposite-exit candidate needs its complete sheet, bend, pin-map and termination review. No validated cut length is available. |
| SD access | The current reference straight-left withdrawal intersects both housing and retained factory-frame geometry. Moving the released display forward clears the case in a limited probe, but does not prove clearance of its own frame or socket mechanism. Rear-cover-only removal is unproved. |
| Small cable mates | All seven intended J103/J401/J501/J601/J701/J801/J802 housings are included as candidates. J104 is an open header. Raw solid-envelope overlaps with their own imported headers are retained and explained separately; actual insertion is not qualified. Harwin's full 16.84 mm conditional stack leaves little axial wire-turn space. |
| Chamber wiring | Round occupied-space corridors can be clear without establishing a finite-radius cable bend. A 4.8 × 2.5 mm rectangular seven-wire trial includes actual R3/R5 circular bends; its exact route hits manifold features and the AO2 reference body. The existing Ø4.4 outlet also rejects the trial's rotated section. Sensor approaches, merge, eleven-wire outlet transition, termination, packing, strain relief and seal remain open. |

The full mate inventory is [intended-mate-allowances.json](intended-mate-allowances.json), with [raw-overlap interpretation](mate-envelope-disposition.json). The finite-bend failures are in [shaped-wire-trial.json](shaped-wire-trial.json). The original failed controls remain unchanged.

## Alternatives retained, not applied

The transient carrier sidebrace plus a rigid +0.8 mm main-PCB shift has one connected carrier and complete 2 mm witness sections. Its actual J402 metal clears the expanded remote-mate collar locally. Existing M2×7 nominal axial insert overlap remains 2.44–2.76 mm across the board-thickness range. Those local results do not resolve the housing support, remote exit, cable mates, service route or complete shifted assembly.

Battery +2Z / negative-Y moves, carrier reliefs, connector substitutions and a reshaped feedthrough were not adopted. The MD62 +0.5Z option is rejected because it overlaps the lid by 1.6 mm³. No new printed geometry was released, so this checkpoint needs no changed-part diagnostic slice.

## Practical next inputs

1. Measure the exposed Guition post length above the black base; confirm post section, mating finish and header XY from physical datums. Select the exact unkeyed remote termination and its cable-exit direction. The main keyed single-ended IDSD assembly does not define this remote end.
2. Inspect the installed SD socket's latch, ejection travel and card/finger path relative to the retained factory rim, including with the display released. Then choose direct internal service or a qualified extender if needed.
3. Select all actual cable mates and insulation constructions, including the existing AO2 cable/SMB elbow. Harwin/JST wire OD limits do not establish a chosen cable. A shorter side-exit connector family remains a proposal and requires PCB/BOM/footprint review.
4. Rework the complete ribbon and wet/dry harness using those parts and finite bend/assembly allowances. Review any necessary printed support, carrier, guide or closure changes together, then run their structural, service, parameter and diagnostic-slice checks.

The native reopen matches 2,575 total solids, 364 occurrence poses/visibility states, 38 user-parameter expressions, timeline 1224 and scoped native health. These are model counts, not BOM quantities. Four intentionally suppressed historical USB-wing features and nine empty group rollups are recorded separately. No new all-body volume, STEP-equivalence, physical fit, sealing, thread-retention or complete width-regeneration claim is made. The new joint expressions are present; v11's earlier width fit pass is not reused for these new cable interfaces.

The [original photo-stage input map](photo-bound-inputs/map.json) preserves all ten original hashes, including the two scripts before later functions were added. The current checkpoint separately preserves 23 source/evidence snapshots. Neither historical receipt was silently rewritten.
