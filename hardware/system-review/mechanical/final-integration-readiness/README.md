# Final PCB integration readiness

The open SystemReview v7 contains the immutable **placement-v2** board, not the final routed board. Its source model remains saved and unchanged. The final routing owner must supply the synchronized artifacts listed in [required-final-inputs.json](required-final-inputs.json) before replacement.

The routed USB STEP and height contract still match the installed frozen versions. Do not replace the USB assembly unnecessarily. Preserve all FlowGrid documents; the R3.1 document has unsaved work. The initial and post-round-trip document records are linked by [document-preservation.json](document-preservation.json).

## Prepared checks

The offline coverage checker can validate an explicit new frozen bundle without overwriting the placement-v2 receipt:

```sh
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 hardware/system-review/mechanical/scripts/placement_height_coverage.py --checkpoint PATH_TO_FINAL_CHECKPOINT_JSON --output PATH_TO_FINAL_COVERAGE_REPORT_JSON
```

The main refresh guard now recognizes both the old20.545mm and already-installed20.5529mm wrapperZ datums. The intended detailed-stack registration remains20.5529mm. This is a narrowly bounded script correction; it has not refreshed or moved any live geometry. A final STEP with a different dielectric thickness must stop for datum review.

Use the gate sequence in the JSON to run the actual interference, maximum-envelope, cable/unmate, thickness, tool, removal, wall, gas and regeneration checks. Keep the 35 ×5.5×12.5mm J301 mating allocation intact. Export a separately named routed-integration checkpoint only after recording its real results; retain every unresolved physical qualification explicitly.

## Historical placement-v2 STEP check

The previously unperformed round-trip now matches all 1,074 physical solids and overall bounds exactly. Its matched VeryHigh property calculation gives a0.467263mm³ difference (1.521478ppm), above the old1 ppm numerical threshold. See [the original round-trip receipt](../placement-checkpoint-v2/verification/step-roundtrip.json). Further direct surface/section diagnosis is recorded separately; the historical numeric result is not overwritten. This is unrelated to the newer PCB routing changes still awaiting integration.

The completed [precision disposition](../placement-checkpoint-v2/verification/STEP_PRECISION.md) now supports use of this STEP as a placement geometry reference:23,022 surface samples and14 interface sections agree closely. The old1ppm numerical observation remains recorded, with its documented API accuracy limitation and actual STEP precision declaration.
