# Incremental VBUS-sense routing proposal

This patch is based on the already frozen six-connection controller proposal. It completes **USB_VBUS_DET, R110.2 → U110.4**, without changing any footprint pose or USB data/CC copper.

**Native result:** 36 → 35 unconnected; exactly the same 38 existing dangling warnings; zero introduced DRC violations; zero schematic-parity issues. This remains an incomplete-board checkpoint, not a fabrication release.

## Scope and source connection

- Add 37 segments and three ordinary Ø0.50/0.25 mm through vias; remove 14 segments and one previous local ground via. All new tracks are 0.15 mm; all new via annuli are nominally 0.125 mm. No new via overlaps an SMD land.
- Move one U110 ground fanout to a Ø0.50/0.25 mm via at (24.2,79.1), keeping its ground connection. Reroute the adjacent HOST back-layer branch around it.
- Shift the owned upper SDA bus bend inward by 0.1711 mm so VBUS sensing can pass between the unchanged USB-data vias.
- Preserve the exact HOST source via **(19.9905,70.8601)**, UUID `222dfe92-badf-43a1-972f-171087a3ac32`. Reconnect it to the existing HOST via (24.5,75.98) on F.Cu. Remove the obsolete front-layer branch and its two short stubs ending at (21,69.95), rather than leave a dangling stub. The original logical supply source remains connected.
- The new HOST F.Cu bridge is (19.9905,70.8601) → (22.05,70.3) → (22.3,70.35) → (22.55,70.6) → (23.4,73.3) → (23.65,75.45) → (23.85,75.7) → (24.5,75.98). Only the direct tie to the existing source via extends west of x20. Coordinate the owner's R301 connection at this common via.

The VBUS-sense copper is 19.3548 mm long, 0.15 mm wide, on F.Cu and B.Cu with two through vias. This is a geometric route check, not a noise/EMC or transient-performance qualification.

## Integration

The exact base is the six-connection proposal SHA-256 `dedd6db2668e97a1e59e31f35d4b147597c115376029c4f2fe232ec5ede81204`.
The resulting isolated board SHA-256 is `971ebbbec09f426860fe198544fae3988bfa502a52f033badfada259f769fb1d`.

Use `route-patch.kicad_sexpr`, `delta.json`, and `removed-items.json`: assert original UUID nodes match the owner's current board, remove only the 15 listed nodes, and append only the 40 additions. The patch has **no footprint replacements**. Preserve the owner's unrelated routing and net-code map; never replace the whole owner board. Refill zones, rerun native DRC with schematic parity, and check the merged geometry audit.

`route_vbus.py` is the complete rebuild entry point and imports `build_vbus.py` as its helper. It writes only this isolated directory, starts from `before.kicad_pcb`, and restores the exact frozen project file. Rebuilding creates new copper UUIDs; rerun DRC and `verify_proposal.py` before issuing refreshed receipts.

## Evidence and remaining gates

See `proposal-verification.json`, `before-drc.json`, `after-drc.json`, and `routing-geometry-audit.json`. Footprints, board geometry, zone boundaries and rule settings are unchanged. The continuous-ground layer receives no signal tracks.

The broader geometry audit remains 9/12 because the board still has unconnected and dangling items, and the inherited BQ_REGN via at (13.5,88.25), Ø0.45/0.20 mm, is absent from the audit's reviewed-coordinate list. This patch neither adds nor changes that inherited via. It adds no manufacturing-rule exceptions and makes no physical-assembly or EMC claim.
