# A3 CAD export notes

The native Fusion archive is the authoritative editable design. Its reopen
check passed with 102 placed solids, 1,078 timeline entries and 36 user
parameters. The assembly has 69 occurrences after adding the three purchased
assembly parents.

The STEP import preserves the placed-solid count, assembly count and overall
bounds. Its strict 1 ppm total-volume comparison **did not pass**. The retained
result is 1.466595 ppm, or 0.45617997 mm³ over the complete assembly.
The comparison report retains its geometry_mismatch status.

A separate investigation sampled the AO2 threaded sensor reference, threaded
adapter and manifold in both directions between native and imported geometry.
Across 23,022 deterministic samples, the largest point-to-body distance was
0.00129134 mm, below that investigation's 0.02 mm diagnostic threshold.
This supports sampled dimensional agreement for those three bodies. It neither
replaces the failed volume criterion nor establishes an exhaustive surface
bound, manufacturing tolerance or physical fit.

Use the native archive when editing dimensions or reviewing a detail near the
modeled threads. The STEP file carries geometry and assembly placement without
the native feature history. Preserve this numerical exception when sharing it.

Evidence:

- [Native reopen](../verification/native-reopen.json)
- [STEP roundtrip comparison](../verification/step-roundtrip.json)
- [Bidirectional surface sampling](../verification/step-surface-diagnostic.json)
- [Recorded STEP disposition](../verification/step-disposition.json)

These export checks are separate from physical print fit, seal performance,
insert retention and electrical or gas-measurement qualification.
