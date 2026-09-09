# CC interrupt route adapted to the HOST proposal

**The isolated CC connection is complete and passes native geometry/parity checks.** Parent review and integration remain required because this uses the secondary inner layer near power circuitry. No authoritative board was edited.

- Source: root's frozen HOST proposal, SHA `20b27514e8a1e858c7afc8e599f33283b9fbe2a249da87b5c0d692a1877cd7a6`.
- Frozen result: `Trimix_Analyzer.kicad_pcb`, SHA `ee2f1de7ffbbff8db7c75249654496e2597080563e53dd9e9ca9824a9adb0732`.
- Delta: **16 tracks and three ordinary through-vias**, all on `USB_CC_INT_N`. No copper removals, retained-copper edits, component moves, pad changes or zone-boundary/settings changes.
- Every added track is0.15 mm wide; new vias are0.50/0.25 mm (nominal annulus0.125 mm), clear of all SMT lands. No new dense-via or narrow-track exemption is used.
- `final-delta.json` gives exact UUIDs, poses, widths and nets. Integrate only this delta; the source already contains root's HOST and earlier routing changes.

## Route and native verification

The source via(11.9,88.65) and target via(25.0745,87.2118) were verified to be the same CC interrupt net. The former reaches U115.3; the latter already connects U113.3 to U110.6/R111.2. F/B-only searches could not escape the left pocket while preserving foreign copper. Parent authorized investigation of a concrete In2 bridge with continuous In1 reference.

The accepted-for-review candidate routes around the left end of the HOST diagonal. New via centres are **(12.8,96.15), (16.4,93.6), (22.2,88.35)**. Added trace lengths: In2 **8.9702 mm**, F **7.5693 mm**, B **8.1518 mm**. This includes the outer-layer return to the existing right-side endpoint; it is not an all-inner-layer route.

The matching old schematic/project tree was copied from the frozen HOST proposal. Final KiCad10.0.6 DRC: **19 unconnected items elsewhere** (source20), **29 existing-type dangling warnings** (source30), **zero geometric violations and zero schematic-parity issues**, with no new violations. Three direct native witnesses prove U115.3 reaches U113.3, U110.6 and R111.2. They use direct track/pad adjacency, excluding zone shortcuts and assumed IC connections. The smallest independently checked nominal new-copper clearance is0.200893 mm. These results do not release the whole board for manufacture.

## Ground and power-overlay review

`final-plane-audit.json` binds the actual before/after filled copper, not only zone outlines. `final-plane-views.png`/`.svg` were visually reviewed and show In2 ground before/after plus F/B copper with the In2 CC projection.

- **In1 remains one continuous filled region.** Three new via antipads remove1.8723 mm²; no signal track is placed on In1.
- **In2 remains six regions**, removing3.8277 mm² without adding a new split. Each resulting region has a pre-existing GND via or plated through-hole pad tied to continuous In1. Thermal pads are counted using actual `thru_hole` type and drill, including the seven U101 plated anchors in the6.6681 mm² region.
- The C115 ground via(12.8,93.95) and U115 control-return vias remain on the same16.9202 mm² region as in the HOST source. C114's ground via(11.1,91.1) stays grounded through In1.
- A local narrow section near x16.25–17.21/y92.2–93.0 is flagged: eroding ground by0.20 mm keeps a small tongue attached, while0.225 mm separates it. This indicates an approximately0.40–0.45 mm constriction under that morphological test; it is **not** a guaranteed global minimum width or a current rating. Its coordinates and eroded pieces are recorded for review against the B-side power path.

No additional ground stitch is needed merely to reconnect an island: all six regions already have verified plated anchors. Whether the remaining neck and return paths provide adequate impedance/current handling still belongs to the parent power-layout review. Filled-region connectivity does not establish switching-loop inductance, crosstalk, thermal capacity or physical behavior.

## Reproduction and limitations

`run_route.py` uses a local copy of the root's native-shape router. `build_bridge.py` restores the immutable source before routing and restores exact project/rule snapshots after SaveBoard. Inner-layer travel is penalized to favour an escape with outer-layer routing. Rebuilding generates new UUIDs; preserve the frozen result for integration.

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc --format json --schematic-parity -o hardware/system-review/electrical/routing-candidate/remote-cc-route-proposal/with-host/final-drc.json hardware/system-review/electrical/routing-candidate/remote-cc-route-proposal/with-host/Trimix_Analyzer.kicad_pcb
```

The CLI required macOS runtime sandbox escalation for this read-only validation. Geometry/plane readers use the Gerbonara/Shapely environment; direct native witnesses use KiCad's bundled Python. Source files and results are hashed in `final-manifest.json`. The earlier standalone route in the parent folder conflicts with HOST and must not be integrated. The owner's later C108/STAT schematic updates are deliberately outside this frozen source and will need validation after the bounded deltas are merged.
