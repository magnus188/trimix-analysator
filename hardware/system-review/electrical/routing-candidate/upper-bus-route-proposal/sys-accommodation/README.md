# Upper interrupt / SYS accommodation proposal

This isolated stage moves the CHG_INT_N crossing to front copper so the main board owner can route the reserved 0.40 mm VSYS corridor on In2. It depends on the separately frozen `../chg-corrected/` stage; it is not a complete-board release.

- Base: `01b013196d3db09db2d506edf1cd52908d13c4d3dbc7730eeb2da5f7b51655ec`.
- Candidate: `0838043fdf156acc053910ab2bdec53db5c0a61c01e7b66ca501bda0db76038c`.
- Native DRC: 19 unconnected items before/after, the same 31 pre-existing dangling-only findings, zero introduced findings, and zero schematic parity issues.
- Incremental changes: 11 segments and two 0.50/0.25 mm ordinary vias added; only the two explicitly listed original CHG segments removed. All pads, component poses, other copper, board outlines, project rules and zone boundaries remain unchanged.
- Native copper-shape connectivity verifies that the original BQ interrupt island remains connected to R107.2 and its original upper branch. The BQ lower via/branch used by the separately owned lower interrupt route is preserved.

`route-patch.kicad_sexpr` contains exact original nodes and new nodes for a guarded merge. Do not replace the owner board wholesale. Refill and rerun native DRC/parity after all independent patches are integrated.

`final-plane-audit.json` records actual filled polygons and ground anchors. In1 remains one connected filled region. In2 changes from seven filled regions to six; all six retain an anchor to In1, and no existing ground-via plane contact is lost. These geometric checks do not certify impedance, thermal capacity, EMI or analogue noise.

`final-plane-views.png` / `.svg` show actual before/after In2, and actual outer-layer copper with the **projected, not-yet-installed** SYS corridor in cyan. The reserved path is `(15.84,84.25) → (17.5,83.9) → (19,83.3)` at 0.40 mm width. It was treated as a foreign-net obstacle while routing this stage. The owner must validate the actual merged power route.

The I2C_SCL gap remains unresolved in this stage. The failed additive search in `I2C_SCL-reachable.json` is diagnostic only; it did not add SCL copper.
