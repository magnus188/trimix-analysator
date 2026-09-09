# Next frozen main PCB import

Fusion is saved at **Trimix_Enclosure_A3_SystemReview v8**, 85 mm wide. The
current main STEP remains placement-checkpoint-v2 (`bb3473f6…885dd`). The
width-contract archive has reopened successfully with matching geometry,
poses, every parameter expression, all 1,199 timeline items, the main rigid
joint and 285 grounded descendants. No evolving routed board was imported.

Use `width_aware_refresh.main()` for the next main import. The legacy importer
still contains historical fixed-coordinate assumptions and must not be invoked
directly. The wrapper evaluates `[PcbX, PcbY + PcbHeight, PcbZ + 0.0529 mm]`,
requires the named width datum joint/origin, and prevents its legacy pose-change
branch from running. Only imported STEP descendants are retired/replaced.

The incoming bundle must provide:

1. An immutable checkpoint containing exactly one main `.kicad_pcb`, the STEP,
   and matching JSON/CSV maximum-height contracts, each with SHA-256.
2. A fresh `placement_height_coverage.audit(checkpoint, output)` receipt. The
   checker now rejects duplicate/missing references, mismatched board hashes,
   MPNs, positions, sides and DNP state, and classifies no-height mechanical
   holes/test pads separately. The strengthened checker was exercised against
   the frozen historical bundle: 169 footprints, 155 rows, zero errors. That
   receipt validates the guard implementation, not the new routed board.
3. A fresh `inspect_step_datums.inspect()` receipt for the incoming STEP.
   It measures actual local substrate bounds and cylindrical-hole axes in an
   unsaved temporary copy, then closes only that copy. Expected main core bounds
   are `(0, -99, 0)` to `(30, 0, 1.4942)` mm, with Ø2.30 mm hole axes at
   `(25.6, -92)` and `(4.4, -6)`. The source-centred Z translation is 20.5529 mm.
   Any changed exporter datum or stack stops import for explicit review.

Bind these receipt paths and hashes in the **main** entry of
`incoming-boards.json`: `coverage_file`, `coverage_sha256`,
`datum_receipt_file`, `datum_receipt_sha256`, in addition to its existing STEP,
height, checkpoint and board identities. The new guard requires all checkpoint
members to match before retiring anything, then rechecks those hashes afterward.
The old manifest intentionally lacks the final receipt fields and therefore
cannot accidentally pass this final-import guard.

After the guarded import, run fresh actual-solid, height/allocation, mounting,
thickness, driver and removal checks through `width_contract_checks.allocations`
so all source envelopes follow the current native datum exactly once. Include
the adopted staged upper-retainer withdrawal when testing wider variants.
The current R301/J301 failure is historical; keep it until the new native
STEP/maximum-envelope check demonstrates clearance. Root's current electrical
preflight reports R301 already moved, but that is not a substituted CAD result.

The contemplated alternate R118/R115 backside window was **never cut**. Latest
routing coordination reports a front-side 0402 R115 instead; the final frozen
board/height contract will decide the actual mechanical check. No alternate
window or Ruthex insert has been imported or modeled during the width suite.

Save and export a newly named routed-integration checkpoint only after those
checks complete, preserving the width checkpoint and original v7. The approved
exterior, purchased dimensions, carrier datum and other open Fusion documents
remain protected. Fit, insert retention, wires/seals and manufacturing holds
must not be cleared merely because a STEP import succeeds.
