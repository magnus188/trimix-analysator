# Upper I2C / charging-interrupt routing proposal

Both assigned gaps are connected in this isolated board, with the adjacent SYS power corridor kept available. This is a guarded merge proposal, not a replacement for the owner's evolving board or a fabrication release.

| Evidence | Result |
|---|---|
| Original source SHA-256 | `14367156de7b285eeaa40d434b1a09892f73b8bf4a0f59665b21d0971047dc00` |
| Final candidate SHA-256 | `5cef686d6021d193a995b34c4b8338eb0ed53878ec636a26415b2c6ae869df40` |
| Native unconnected items | 20 → 18 |
| Native DRC | Same 31 original dangling-only findings; zero introduced findings |
| Schematic parity / courtyard errors | Zero |
| Exact copper delta | 40 segments +12 ordinary vias added;4 approved original segments removed |
| New copper rules | 0.15 mm traces;0.50/0.25 mm vias;0.125 mm via annulus; no new In1 signal tracks |
| Purchased-part poses | Only C707 moves (21,69)→(21.70,68.925), retaining 90° rotation and its package |

The first stage lifts a short SDA section onto front copper and connects R107.2 to the BQ interrupt island. The second stage lifts the original CHG crossing onto front copper to reserve the owner's 0.40 mm In2 SYS path `(15.84,84.25) → (17.5,83.9) → (19,83.3)`. The final stage moves C707 slightly, opens an ordinary SCL via and completes the BQ SCL connection.

Use `route-patch.kicad_sexpr` / `delta.json` to merge only these changes. The patch includes exact original nodes; verify them before removing anything. Replace only the explicitly paired C707 footprint. All other original copper, component poses, board geometry, project rules and zone boundaries are asserted unchanged. Refill and rerun native DRC/parity on the owner's final merged board. **If earlier stages are already integrated, use only the remaining incremental stage, not this combined patch again.** Stage hashes and original native DRC provenance are in `stage-provenance.json`.

`proposal-verification.json` includes native copper-shape graph witnesses for SCL, SDA and the charging interrupt. `C707-connectivity-witness.json` proves its original HOST network remains connected and its ground pad still reaches unchanged traces and a plated via in contact with actual In1 ground fill. This is a trace/via network witness, not merely an overlap of two nominal pad boxes.

`final-plane-audit.json` and `final-plane-views.png` / `.svg` report actual before/after filled ground and outer-layer copper. In1 remains one connected filled region. All seven final In2 ground regions have an anchor to In1; no existing ground-via plane contact is lost. The cyan SYS corridor is a projected reserved route, not installed copper. The owner must review and verify the actual merged power route. These nominal geometric checks do not qualify transient impedance, thermal performance or EMI.

`C707-placement-change.json` records the translated existing maximum/allocation envelope and its 0.72 mm separation from the provisional J301 mating box. Regenerate the final PCB STEP and height contracts before Fusion integration; purchased geometry is not scaled. Actual connector/cable measurements remain a separate fit gate.

The full-board geometry audit still reports the unchanged existing narrow-via coordinate gate and incomplete routing/dangling copper; `routing-audit-disposition.json` compares that gate to the baseline. This patch adds no sub-0.25 mm drills or sub0.15 mm traces.
