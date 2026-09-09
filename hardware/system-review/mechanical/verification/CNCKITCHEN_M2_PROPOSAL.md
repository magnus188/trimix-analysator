# TC-M2x3.0 — reviewed internal support proposal

**Prepared for review; not adopted.** One exact CNC Kitchen TC-M2x3.0 part could replace all ten generic M2 insert references. Temporary Fusion solids passed the selected checks below without changing the saved v8 model. The four M3 inserts remain outside this proposal.

## Changes and preserved datums

The [27-parameter proposal](cnckitchen-m2-proposal.json) changes only three printed parts:

| Printed part | Local change |
|---|---|
| P01 main housing | Widen both PCB support webs to 7.6 mm and both display-retainer bosses to radius 3.8 mm. Use Ø3.2 pilots. Make **only the two PCB posts and lower display retainer** intentional through-pilots. The upper retainer pilot stays blind. |
| P06 USB support frame | Enlarge both bosses from radius 3.65 to 3.8 mm; change pilots from Ø3.3 to Ø3.2, retaining their existing 4.25 mm blind depth. |
| P07 chamber manifold | Enlarge four bosses from radius 3.6 to 3.8 mm. Retain the existing Ø3.2 × 4 mm blind pilots and sealed floors. |

All insert open faces, screw bodies/seats/axes, PCB registrations, display geometry, other purchased parts and the exterior remain unchanged. P09 USB bezel and P10 retaining bridge are unchanged. Ten inserts retain the stable project rollup **TMX-A3-F05**, with exact purchased identity **TC-M2x3.0**, EAN 4262391010013, recorded separately. No BOM change has yet been applied.

The three through-support lengths remain 4.2 mm, exceeding the manufacturer's 3 mm through-hole guidance. They remove existing 0.1 mm membranes without extending the support into the screen frame. The other seven locations retain blind depths of 4.00–4.25 mm; actual existing floors are at least 2 mm. Heat-set installation requires the display and electronics to be removed. Printed pilot accuracy, insertion process and retention still require coupons and physical testing.

## Native transient results

[Evaluation receipt](cnckitchen-m2-proposal-evaluation.json):

- All ten exact candidate insert exteriors clear unrelated installed solids.
- The three proposed printed hosts have zero unrelated solid intersections.
- Selected radial-material sections support a nominal 2 mm beyond the published Ø3.6 crest. The numerical sampled lower bounds are 1.99932 mm at the stated 0.001 mm radial resolution; this is not a global wall certificate.
- The continuous Ø5 mm gas path remains clear, with no gas hole changed to a through-pilot.
- Main screw checks at finished-board thicknesses 1.44, 1.60 and 1.76 mm are clear. The lowest measured tip-clearance bound is **0.8358 mm**, at the lower PCB screw and 1.44 mm board. Its nominal and thick-board results are 0.9969 and 1.1580 mm.
- All screws occupy the nominal 3 mm insert span, with **2.6 mm central axial allocation** after excluding the source CAD's 0.2 mm end chamfers. This does not establish actual full-thread engagement or clamping strength.

Hypothetical screw-thickness checks exclude the fixed-thickness main STEP to avoid treating the old nominal board as the thin-board case. All other physical obstacles remain. The new final PCB maximum-body contract and native service/driver/width checks are required after any authorized implementation.

## Manufacturer model limitation

The unmodified official STEP has one solid with 300 faces, outer span approximately 3.6 × 3.6 mm and length 3 mm. Its narrow lead is at source Z0; source Z3 aligns with the existing insert open face. Installation therefore uses a rigid translation by `faceZ − 3 mm`, with no scaling.

Its internal coaxial cylinder is Ø2.0755 mm, and an actual nominal Ø2 mm cylinder passes through the entire source model without solid intersection. **This CAD bore cannot prove a faithful M2 thread or its engagement.** The purchased M2 identity is supported independently by the manufacturer's product page/poster. Keep the exact external CAD, label its internal thread visual/reference only and verify actual thread class, usable length and runout physically. Do not silently modify the manufacturer's bore to make a digital engagement claim.

Intended insert-to-printed-pilot interference is quantified per actual insert/host pair in the receipt. It represents the manufacturer's heat-set material displacement, not a blanket waiver for collisions. The printed pilot and any post-install cavity remain distinct manufacturing states.

## Guard and next step

The read-only [preflight](cnckitchen-m2-proposal-preflight.json) passed all 27 parameter names, existing expressions and feature owners, ten insert poses/bindings, exact source hashes and saved v8 state. Proposal SHA256:

`5bedc48c0226e6822b8fe5d2813a7520f025da666fddb8bf855ba65fecaa45ca`

Root review must precede native geometry changes. Any implementation must preserve the ten hardware bindings, repeat geometry/material/gas/screw/service/driver checks, test the 85 and 87 mm width endpoints and save a new owned version only after successful restoration and validation. The source v8 and all three FlowGrid document states are preserved, including unsaved R3.1.

The [RX-M2x4 review](RUTHEX_M2_REVIEW.md) remains intact as the rejected universal blind-hole alternative. [CNC Kitchen provenance](../components/cnckitchen-m2-review/source-review.json) and [actual STEP inspection](cnckitchen-m2-model-inspection.json) bind the replacement candidate.
