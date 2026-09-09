# Final height-contract coverage audit

Generated 2026-09-07T14:14:33.215756+00:00. Read-only native KiCad and local manifest checks; no PCB or Fusion edits.

**Main: 169 footprints = 149 populated envelopes + 6 DNP envelopes + 12 testpads + 2 mechanical holes.** Missing/extra/duplicate refs: zero. All 155 rows match native side, XY, rotation and DNP; current native F.Fab/B.Fab correspondence and Fusion envelope transforms also match. Actual footprint library IDs agree with the current netlist (mechanical H1/H2 are intentionally absent from that netlist).

**Version gap:** the frozen import snapshot remains board `a3b5947a…`, STEP `a28de6b7…`, contract JSON `f6f59586…`. During this audit the working board and electrical checkpoint advanced to `2b502a6e…`, STEP `450e1f44…`, JSON `3f6dbd43…`. The newer checkpoint identifies a J102 drill-only revision to 1.00 mm and J402 maximum-height metadata of 8.2 mm. Its four current checkpoint hashes match. The frozen and current contract rows/CSV are identical, and current ref/pose/side checks pass; this does not make their STEP geometry identical. Do not claim the frozen import contains the newer J102 drilled geometry.

B.Cu populated references (12): C114, C115, C116, R121, R122, R123, R124, R125, R126, R127, R128, U115. These envelopes extend down from PCB-back Z20.5; front envelopes extend up from F.Cu Z22.1.

DNP: C503, C706, R602, R603, R604, R804. Testpads: TP1001–TP1012. Mechanical: H1/H2.

**USB: four F.Cu footprints** — D901/U901 purchased envelopes, J902 provisional six-wire allocation, J901 separate native connector/stake geometry. No DNP, testpad, mechanical-only, missing or extra references. All poses match. All 67 USB manifest entries pass hash/size checks. STEP text includes D901/U901; J901 is deliberately separate and J902 has no wire-bundle model.

## Open physical dimensions

- J101/J102: 6 mm wire allocations are unmeasured. R128 has a generic 0603 envelope but no source URL.
- J902: no maximum installed XY or known physical height. The 4.5 mm allowance does not measure solder tips, insulation/bundle width, bending, seating or strain relief.
- J901: the USB contract carries pose and MPN but no numeric maximum envelope; separately retained connector/stake geometry and actual mating remain required checks.
- U901/D901: use maxima 0.55/0.77 mm plus the provisional 0.10 mm assembly allowance, not illustrative STEP heights ~0.53/~0.63 mm.
- Header mating housings, latches, wire bends, lower solder protrusions, test-probe access, finished-board tolerances and physical fit remain open.

The main contract has no blank/invalid numeric dimensions or UNVERIFIED fallback rows, but numeric completeness does not establish manufacturer maxima for every field. The contract itself omits footprint library IDs. Native STEP import/interference and manufacturing release are outside this audit.

[Machine-readable details](final-height-coverage.json)
