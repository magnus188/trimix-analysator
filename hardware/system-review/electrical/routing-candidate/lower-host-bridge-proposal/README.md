# Lower HOST pull-up connection

Frozen isolated proposal: `b819838cd4dcab44f12a37e3195da0d47c529e2027f6637c2f12360f1e433c74` → `20b27514e8a1e858c7afc8e599f33283b9fbe2a249da87b5c0d692a1877cd7a6`.

R115's HOST supply is connected to the existing HOST branch at (26.1375,82.7372) using ten0.15mm tracks and three ordinary0.50/0.25mm vias. Five explicitly approved dangling CHG_INT_N segments are removed; its connected upper branch is preserved, and its lower reconnection remains outstanding. No footprint, existing retained copper, board outline, stackup, zone boundary or project rule changes.

Native KiCad10.0.6 on the matching complete project: **zero geometric findings, zero schematic-parity findings**,21→20unconnected items and31→30dangling-only warnings. The complete board is still unfinished. `verify_proposal.py` verifies the exact delta, unchanged objects/rules and absence of via-on-SMT overlap, then emits `route-patch.kicad_sexpr`. Apply only that patch to the newer owner board and rerun native checks; do not overwrite the owner board.

Three independent direct-native witnesses connect R115 to C112, C110 and R120 through existing HOST copper. No zones or assumed IC internal paths are used. The long exploratory route was pruned at its first verified existing HOST connection; the unnecessary outer-edge loop is absent from the final proposal.

## Ground and routing review

`ground-comparison.png` /`.svg` show exact before/after F, B, In1 and In2 copper. All eight panels were inspected. In1 remains one continuous filled-ground region. The new diagonal deliberately changes local In2 partitions: the previous62.3339mm² region splits, while removing the unfinished CHG_INT branch joins other copper. Every resulting local In2 region has at least one existing GND via or plated pad to In1; the U101 thermal through-pads are included. Counts alone do not prove a good return path.

C115GND and the U115 control-ground stitches remain in one16.9202mm² region. C114GND is in the30.0791mm² left region; both reference continuous In1. The F/B power traces and their widths are unchanged. This is accepted as an explicit connectivity/return-path routing proposal. It does not qualify loop inductance, EMI, load steps or the still-open USB transient gate EL11. The final route combined with the CC interrupt patch needs the same checks again.

This HOST branch feeds a10k pull-up, not a supply load. The nominal complete-item witness to C112 is about0.172645Ω with three barrel transitions, giving approximately0.058mV drop at3.3V/9.9k. Copper temperature, finished height and plating remain model assumptions; this is not equivalent circuit resistance or a current rating.

## Retained rejected work

`first-scout/` retains a route rejected for the real bottom edge and rule-area clearance. The router copy was corrected to use actual native Edge.Cuts and keepout shapes. `unpruned-scout/` retains the unnecessarily long but native-clean route before pruning. `baseline-failed-project-lookup.json` is an invalid standalone-project check that could not find its schematic/rules; it is not acceptance evidence. Only the matching `baseline/` project and current`before-drc.json`/`after-drc.json` are used in the final comparison.
