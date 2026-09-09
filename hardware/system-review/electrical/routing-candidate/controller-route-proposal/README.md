# Isolated controller routing proposal

This is a six-connection proposal for the frozen local-controller board, not a full-board or fabrication release.

**Native result:** 42 → 36 unconnected items; 40 → 38 pre-existing dangling-only warnings; zero introduced DRC violations; zero schematic-parity issues.

## Included

- Connect C111 and the local R111/R112/U112 HOST_3V3 network.
- Connect U111 pin 3 (SCL) and pin 4 (SDA) to their existing buses.
- Move C111 from **(28.900, 73.700, 90°)** to **(29.025, 73.100, 90°)**. Its package and orientation are unchanged. Refresh the final MCAD contract and STEP after integration. R111/R112 and all other component poses are unchanged.
- Add **27 track segments and four Ø0.50/0.25 mm vias**; remove **six track segments and two ground vias**. The removed ground branch is replaced by the new C111 ground connection; U111's existing ground connection remains.
- Keep the default 0.15 mm tracks, with only two 0.125 mm escape segments within the reviewed U111 allocation. New nominal via annuli are 0.125 mm. No via overlaps an SMD land; no new In1 signal copper is added.

## Explicitly left for the owner

**USB_VBUS_DET R110.2 → U110.4 remains unconnected and unchanged.** A separate experiment found that finishing this escape also required changing the HOST source branch beyond the assigned rectangle; those experimental copper changes are excluded. They are retained only as text under `experiments/` and must not be applied as a finished route.

The broader audit reports 9/12 checks passed: complete routing and removal of existing dangling items remain unfinished, and one unchanged base via at (13.5, 88.25), BQ_REGN, Ø0.45/0.20 mm is absent from the audit's explicit reviewed-coordinate list. See `inherited-via-audit-exceptions.json`; the proposal adds no such small via and does not qualify that inherited exception.

## Integration

Use `route-patch.kicad_sexpr`, `delta.json`, and `removed-items.json`. Assert that each listed old UUID and its original node still match, remove only those eight nodes, add only the 31 new nodes, and update only C111's position. Preserve the owner board's other work and net-code mapping. Refill ground zones and run native DRC with schematic parity on the merged board. **Do not replace the owner board wholesale.**

The base SHA-256 is `02d5c11904035d4482d4fe30a29508557842293e3757523aeac20dc0c95e503a`.
The proposal SHA-256 is `dedd6db2668e97a1e59e31f35d4b147597c115376029c4f2fe232ec5ede81204`.

`build_clean_partial.py` is the reproducible builder. It writes only this isolated directory, starts from `before.kicad_pcb`, and restores the frozen project settings after saving. The experimental source is deliberately saved as `.txt` to prevent accidental execution. Rebuilding generates new copper UUIDs; regenerate DRC and verification receipts after any rebuild.

See `proposal-verification.json`, `before-drc.json`, `after-drc.json`, and `routing-geometry-audit.json` for the native and semantic checks. Copper geometry checks do not qualify manufacturing, EMI/noise, thermal performance or physical assembly.
