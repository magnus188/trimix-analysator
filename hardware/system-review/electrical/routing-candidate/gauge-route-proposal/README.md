# R301 supply-branch routing proposal

The frozen proposal reconnects the HOST_3V3 supply at R301 to the existing
In2 rail and the R107 pull-up branch. It adds 21 tracks and three ordinary
0.50/0.25 mm through vias. No original copper, footprint, component pose,
zone boundary or design rule changes. The added vias do not overlap SMD lands.

Native KiCad DRC on the complete matching project and schematics changes
40 unconnected items to 38. The same 39 pre-existing dangling-item warnings
remain, with no new violation and no schematic parity finding. This completes
two scoped connections; it does not release the board. The separate gauge
alert signal is still unfinished in this proposal.

Use `added-items.kicad_sexpr` for integration after checking the exact base
and original UUIDs; do not replace the owner's board wholesale.
`proposal-verification.json` binds the before/after hashes and checks unchanged
copper, footprints, zones, project rules and native DRC signatures.

`baseline/` holds the accepted input. `Trimix_Analyzer.kicad_pcb` is the final
isolated proposal. Other stage directories preserve intermediate routing
experiments and are not the accepted patch. The initial gauge-alert search
found no path under its conservative mask. The first HOST experiment allowed
a via to overlap its own SMD land; it was rejected and the router mask was
corrected. The final route reuses the first new via for both branches and
removes redundant added In2 segments. Native KiCad checks, rather than the
raster search alone, determine acceptance.

The native CLI required execution outside the macOS sandbox. Its initial
sandboxed attempts aborted before producing a report; the successful reports
are `before-drc.json` and `after-drc.json`.
