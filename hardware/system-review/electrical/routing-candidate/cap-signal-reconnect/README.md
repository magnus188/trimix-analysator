# Capacitor-repack control connections

**Historical isolated patch: native geometry passed on its source, but the later SCL merge conflicts. Do not merge this first patch by itself.** The owner retained the rejected combined board `../cap-signals-merged.kicad_pcb` (`43046290dd43fb281ee8711e50924bf6cb4f689afc3f26330c916a1776d2a0c3`). Its four new CHG/SCL crossings are being corrected in `with-scl/`, against the combined source. Whole-board order readiness remains on hold.

This reconnects HOST_3V3 and the charger interrupt pull-up after the owner moved C101, C102 and R107 to improve the charger's local capacitor connections. It preserves every capacitor, power trace, part selection and board dimension in the source.

- Source: `3a80cb5790642217c881de08bef14d233bbb3f8f6b44477a32f7e113180b04f3`.
- Result: `ea819631d83e4e1998aeafc01460f0cd642406b9989aa16acc09f04d6045d571`.
- R107 moves from front (3.9,83.55), 270° to front (3.4,83.5), 0°. Its exact 0603 package, value and nets remain unchanged.
- Fourteen .15 mm tracks and three ordinary .50/.25 mm vias are added. No existing copper is removed. No In1 signal traces, rule changes, board-outline changes or zone-boundary changes.
- Native KiCad: 14→12 unconnected items, 28→27 pre-existing-type dangling warnings, zero geometric violations and zero schematic mismatch. These remaining connections and dangling items still require completion.

`native-witnesses.json` records direct native conductor paths from R107 pin 2 to U101 pin 7, J301 pin 13 and Q112 pin 3, and from R107 pin 1 to J301 pin 1. Independent manufacturing checks find no new via overlapping any SMT land, including same-net lands.

The actual filled-copper comparison is in `ground-comparison.png` and its source-bound JSON. In1 remains one continuous ground region; its substantive changes are the three signal-via clearances and adjoining fill cleanup, confined within .8 mm of the new via centers. Remote polygon rounding totals less than .000001 mm². One nearby In2 region splits into capacitor-side and charger-side regions. Both retain plated ground anchors: the capacitor side keeps the existing .60/.30 ground via at (7.75,85.525), and the charger side retains two thermal barrels. Direct native witnesses connect C101 and C105 ground pads to the existing via and In1. Power trace geometry is unchanged. This is a geometric review, not a transient, thermal or EMC pass.

The former vertical R107 pose had no route within the inspected outer/inner signal-layer area. An initial horizontal pose at (3.4,83.15) failed the R803 courtyard check. It was moved down .35 mm before routing; both failed scouts remain distinguishable from the accepted result.

## Reproduce and merge

`build_bridge.py` and `run_route.py` regenerate an isolated proposal from the immutable source. `verify_proposal.py` checks exact source conservation and emits `route-patch.kicad_sexpr`; `inspect_witness.py` checks native conductor paths. `ground_audit.py` regenerates the comparison and deliberately requires a fresh review disposition.

The owner must match the old R107 footprint exactly, apply only the patch's additions and footprint replacement, preserve newer unrelated changes, refill all planes and repeat native checks. Final merged routing, current-path qualification, CAD integration and manufacturing exports remain separate gates.
