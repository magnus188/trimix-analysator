# Lower shared charging interrupt route

**Isolated routing proposal; not a fabrication release.**

The route joins Q112 pin 3 to the existing CHG_INT_N island containing BQ25895 U101 pin 7 and J301 pin 13. The separate R107 pull-up connection is handled by the upper-bus proposal.

- Source: `25ccd798740da0ac1c45eccec28d6cfc83d5a4f81b867c085142661a17155ada`.
- Result: `ba4a97e37d91e7b076a8c523165bd74d1a86e4ed627869dab6bd34df3b116842`.
- Exact change: fourteen .15 mm tracks, three ordinary .50/.25 mm vias; remove one unfinished In2 stub and its now unnecessary old via. No component poses, unrelated copper, board outline, stackup, zone boundary or design rule changes.
- Native KiCad: 18→17 open connections, 28→27 prior-type dangling warnings, zero geometry errors and zero schematic mismatch. These remaining opens still block whole-board routing acceptance.

The route uses a short front connection from the lower island to a rear trace along Y98.35, returns through the front near X8.45, then follows In2 to the original upper node at (12.1659,87.2159). Native direct-conductor witnesses connect Q112.3 to both U101.7 and J301.13. The board checker includes the real board and footprint-local keepouts; it does not rely only on the scouting router.

The filled-ground comparison retains a single continuous In1 plane. The local In2 area beside C114 changes from one 27.0259 mm² region to regions of 19.0020 and 4.0503 mm². The C114 region retains its existing .60/.30 GND via at (11.1,91.1), directly into In1. Its original rear copper return is unchanged. Every local In2 region retains a plated ground anchor. C115/U115 control and battery-return regions retain their existing anchors. The net is a low-current open-drain interrupt. This is a geometric return-path review, not a transient, inductance or EMC validation.

## Reproduce and merge

`apply_explicit.py` creates the exact bounded route from the immutable source. `verify_proposal.py` verifies the source/delta and writes `route-patch.kicad_sexpr`. `inspect_witness.py` independently checks native direct adjacency. `ground_audit.py` regenerates the native filled-ground comparison; retain the reviewed disposition when refreshing it.

The owner must apply only the exact remove/add nodes, preserve newer unrelated changes, refill and repeat native checks. No authoritative main-board writes are made by these scripts.

The original bounded search failed. The wider `with-upper-bridge/` scout found this route while including an unrelated upper-stage trial that later failed its inductor keepout check. This accepted proposal copies **none** of that upper-stage copper: it is checked directly on the original source, and terminates on original copper. The failed scout is retained for provenance, not accepted manufacturing evidence.
