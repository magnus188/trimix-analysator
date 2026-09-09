# C116 DVDT local routing proposal

The isolated candidate reconnects U115.7 to C116.1 on B.Cu while preserving the existing U115 ground return and all other component positions. It is an additive/removal delta for the current PCB owner to integrate, not a replacement for the evolving main board.

- Approved source: `996e9676ff714fa5d2dd904934af3e44114bcfe34cb4e7035ef05024aedc1189` (`before.kicad_pcb`).
- Frozen candidate: `63a75e1552670e029314f58e01d0f5d28b195a4ca3096c68adf460ca8f04a66c` (`Trimix_Analyzer.kicad_pcb`).
- C116 centre moves from (17.00,90.00) to (17.24,89.96) mm; its rotation changes from +90° to −90° (equivalent to270°). Same purchased part, pad and courtyard geometry; no scaling.
- Add14 B.Cu tracks, all0.15mm wide. Remove10 former local ground/ILM/DVDT tracks and the now-obsolete DVDT access via at(15.89,88.8). `final-delta.json` contains exact UUIDs, nets, endpoints, widths and the sole footprint pose change.
- Preserve U115 and R126 poses, Q via(16.1827,91.7017), GND via(18.6,88.45), battery pads, all retained copper, all zone outlines/settings and all other footprints. Plane fill is refreshed to remove the obsolete via clearance.

## Verification

The final native KiCad10.0.6 DRC finds31 unconnected items elsewhere in this intermediate board (source32),32 dangling-only warnings (source33), zero geometric errors and zero schematic-parity issues. There are no new DRC violations. This does not declare the full board routed or ready to manufacture.

Eight direct native `GetConnectedTracks` / `GetConnectedPads` witnesses verify both physical U115.7 lands to C116.1, U115.9 to R126.1, and the U115/C116/R126 ground connections through the preserved ground via. These witnesses exclude zones and do not invent internal connections between like-numbered package pads. See `native-witnesses.json`.

The independent geometric check reports a smallest nominal new-copper gap of0.2010876mm (U115.9 versus the new ground branch). The ILM bend uses the actual rounded C116 land geometry to clear the preserved Q via within the approved x16..18.2,y91.3..91.55mm extension. Native clearance and courtyard checks pass. This is nominal layout evidence, not fabrication tolerance, thermal, analogue or current-rating qualification. Do not simplify the bend through the via or enlarge a pad without rechecking.

`dvdt-copper.png` / `.svg` show the before/after B copper and were visually inspected. The plotted bottom layer is viewed through the board; planes are intentionally omitted from the drawing.

## Reproduction

Use the KiCad bundled Python runtime to run `build_proposal.py` in this repository. It starts from the immutable source, removes only the enumerated balanced segment/via forms, changes C116, adds the listed traces, refills and saves. The exact source project and rules are restored **after** SaveBoard so API-generated default settings cannot substitute for the project rules. Rebuilding generates new copper UUIDs, so do not rebuild the frozen candidate merely to copy it.

Final native validation command:

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc --format json --schematic-parity -o hardware/system-review/electrical/routing-candidate/independent-dvdt/final-drc.json hardware/system-review/electrical/routing-candidate/independent-dvdt/Trimix_Analyzer.kicad_pcb
```

The macOS native CLI required sandbox escalation for its application runtime; the action only read the isolated board and wrote the report. Run `audit_local.py` with `/tmp/trimix-gerbonara-venv/bin/python` and `native_witness.py` with the KiCad bundled Python. The initial exploratory `proposal-drc.json` predates the final exact-removal implementation and is not acceptance evidence; only `final-drc.json` is bound to this candidate.
