# Local USB CC interrupt route proposal

Native KiCad DRC passes this bounded delta: unconnected items decrease from23 to22; the exact32 existing dangling warnings remain, with no introduced finding and no schematic parity issue.

- R111 remains atX27.5mm and movesY77.75→77.55mm; its footprint rotates90→270degrees. Its pin numbers and nets remain unchanged. The original reference label stays at its global location.
- Five0.15mm F.Cu segments replace four local HOST_3V3 segments. No vias, power/data/CC line changes, zone boundary changes or other component moves.
- R111.2 now connects directly to the existing U110 interrupt via. The separate remote U115 interrupt gap is outside this patch.

Apply only [route-patch.kicad_sexpr](route-patch.kicad_sexpr), asserting the old nodes first. Replace only the enclosed R111 footprint. Preserve all unrelated owner changes, refill zones and rerun native DRC/parity. See [proposal-verification.json](proposal-verification.json) and [delta.json](delta.json). Do not replace the owner board wholesale.

Update the final PCB STEP/height contract for theR1110.20mm position change. This is a routing proposal, not a fabrication release. The general audit's three inherited failures concern unfinished connectivity, dangling items, and a pre-existing BQ_REGN small-via allowlist discrepancy.
