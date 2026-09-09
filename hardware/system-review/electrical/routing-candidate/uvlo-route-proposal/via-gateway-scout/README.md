# Superseded UVLO / HOST routing scout — do not merge

The native geometry checks pass against the isolated e62c867a source, but this candidate **conflicts with the newer CLR route**. The control stage uses the same via coordinates (13.2,95.05), (20.9,91.15) and In2 corridor near (16.65,94.1) on a different net. The candidate is rejected for integration.

No authoritative PCB or Fusion document was changed. The saved board and delta are diagnostic artifacts only. See `STATUS.json` for exact source hashes and native DRC evidence.

The useful bounded result is a legal ordinary OVLO via at (12.5,90.1) and UVLO via at (13,90.85), each0.50/0.25mm and outside all SMT lands. This still requires a jointly reviewed HOST reconnection against the latest actual control geometry. It is not an independently mergeable patch. The reserved raw-power via remains exactly (13,91.65),0.60/0.30mm.
