# Gauge-alert routing proposal

This isolated patch completes **GAUGE_ALERT_N, R301.2 → U301.5**. It preserves every footprint pose and the existing USB data, CC, HOST, I²C and power-control signal routes.

**Native result:** 38 → 37 unconnected items; the same 39 pre-existing dangling warnings; zero introduced DRC violations; zero schematic-parity issues. This remains a partial-board checkpoint, not a fabrication release.

## Necessary local copper corrections

The U301 escape could not fit an ordinary through via inside the original copper pocket. The finished proposal uses no smaller-via or clearance exception:

| Change | Actual preserved constraint |
|---|---|
| U301 pin4 ground dogleg becomes a shorter direct connection into the exposed ground pad | 0.20 mm width; both original local ground vias and the other ground connections remain |
| PACK_P via moves from (16.1271,72.7514) to (16.0271,72.9014) | Ø0.60/0.30 mm, 0.40 mm F/B connections, original electrical endpoints |
| Nearby VSYS corner moves 0.15 mm right; its horizontal section moves 0.15 mm down | 1.00 mm width; original supply/capacitor connections |
| USB5 back-layer diagonal becomes (16.3692,71.9863) → (16.75,72.55) → (17.4989,73.116) | 0.40 mm width, same endpoints, unchanged USB data copper |

The new gauge signal uses 0.15 mm tracks and four Ø0.50/0.25 mm through vias. The final via at (11.95,71.65) is deliberately clear of the same-net resistor land; all five new/replacement vias have at least 0.20 mm native copper-edge separation from every SMT land. This is a copper-geometry check, not a solder-process qualification.

In total: **22 segments and five vias added; nine segments and one via removed**. No footprint, pad, board outline, stackup, zone boundary or project rule changes. No new signal tracks use In1.Cu. The In2 gauge route stays above y73.9, outside the existing y83..94.2 In2 ground allocation.

## Integration and evidence

Base SHA-256: `ae51286a3d1f7a6ffcfca5bc9bde7de25bca9cfac3d611ff8d309067b79131a8`.
Proposal SHA-256: `d9735085c822b8b7e40fd0b3b27c35f5de65b047b856b3840a5e7673f77619e8`.

Use `route-patch.kicad_sexpr`, `delta.json` and `removed-items.json`. Assert the original UUID nodes still match the owner's board, remove only the ten listed nodes, then add only the 27 additions. There are no footprint replacements. Preserve the owner's unrelated changes and net-code mapping; do not replace their complete board. The owner must review the documented local power-copper changes, refill zones and rerun native DRC/parity after merging.

`route_gauge.py` is the complete rebuild entry point; `build_gauge.py` is its helper. Rebuilds start from `before.kicad_pcb` and restore the exact frozen project file. New UUIDs are generated on rebuild, so DRC and `verify_proposal.py` must be refreshed before issuing a new patch.

See `proposal-verification.json`, `before-drc.json`, `after-drc.json`, and `routing-geometry-audit.json`. The broader audit remains 9/12: other unconnected/dangling items remain, and the unchanged inherited BQ_REGN Ø0.45/0.20 via at (13.5,88.25) is absent from its reviewed-coordinate list. The patch adds no such exception. Manufacturing, thermal, noise/EMC and physical-assembly qualification remain project-level work.
