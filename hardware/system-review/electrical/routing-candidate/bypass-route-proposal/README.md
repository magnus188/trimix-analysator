# Input-protection capacitor routing correction

This frozen, isolated proposal improves U115 input bypassing and completes its DVDT capacitor connection. It is a delta for the evolving main board, not a manufacturing release.

Source SHA256: `471b5059a89365352759817f32cfa7922196a4002e63903c4b09b96962ca520a`.
Final SHA256: `63a75e1552670e029314f58e01d0f5d28b195a4ca3096c68adf460ca8f04a66c`.

## Changes

- Move C115 (100 nF) from (17,90),90° to (12,92.75),−90° and connect it directly to U115 IN on B.Cu. Add a ground stitch at (12.8,93.95).
- Move C116 (3.3 nF) from (12,92.75),90° to (17.24,89.96),−90°. Reconnect DVDT, ILM and the local ground branches while retaining the existing ground stitch at (18.6,88.45).
- Escape U115 OUT through a new ordinary 0.50/0.25 mm via at (14.8,91.6). A 0.40 mm front trace and a short 0.30 mm diagonal join the existing output via at (13.3,92.4). The 1.1314 mm diagonal clears J102's square PACK_P pad; widening it requires rerouting and fresh checks.
- Remove the approved unfinished Q front stubs, obsolete DVDT via and unfinished UVLO extension. Preserve the Q via at (16.1827,91.7017) and the owner's remaining Q branch. UVLO and the raw USB source trunk remain routing work for the owner.
- Hide only C115/C116 silkscreen reference fields in the dense underside cluster. Their values, Fab information and BOM identities remain; the final reference map must include them.

No package, pad number, pad net, pad size, drill or component-relative pad position changes. All other footprints, board outline, stackup, zone boundaries and project rules are unchanged. No In1 signal routing is introduced.

## Verification and integration

Fresh native KiCad 10.0.6 DRC on the complete matching project: **zero geometric errors, zero schematic-parity issues**, 31 unconnected items and 32 dangling-only warnings. The immutable source had 32 unconnected items and 33 dangling warnings. These remaining whole-board failures prevent release.

`verify_delta.py` checks the complete source/final differences and emits `route-patch.kicad_sexpr`. Integrate only that patch, checking each removed object and before-footprint against the current owner board; do not overwrite the newer owner board. Refill and repeat native DRC/parity after integration.

`power-final.png` shows exact F/B/In1 copper, pads and plane fill. All three panels were inspected. `../independent-dvdt/native-witnesses.json` supplies eight native direct-adjacency witnesses for DVDT, ILM and ground return. `power-path-final/` binds a fresh trace-only inventory to the final board: 15 of 29 requested pad pairs have explicit witnesses, 14 remain unresolved when pours are excluded. Its 540 sensitivity cases are calculation scenarios, not physical tests.

The OUT-to-output-capacitor route remains relatively long. Its complete native-item witness is approximately 13.363 mm through two barrel transitions (~20.43 mΩ at 20 °C using 35 µm outer copper and assumed 25 µm plating). This is not equivalent circuit resistance or a current/thermal rating. Short 0.15/0.25 mm package-land escapes and the 0.30 mm front neck remain explicit final current-path review items. USB transient survival (EL11), charging, startup, solderability and thermal behaviour require separate qualification.

`baseline/`, `frozen-out-input-stage.kicad_pcb` and stage reports retain the development history. Historical reports apply only to their original stages, not the final file. Acceptance uses `after-drc.json`, `proposal-verification.json` and the final hash above.
