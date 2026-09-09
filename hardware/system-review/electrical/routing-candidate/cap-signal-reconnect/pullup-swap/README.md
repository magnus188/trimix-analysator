# Charger interrupt and I²C pull-up routing

The accepted isolated proposal restores the charger interrupt and clock pull-up connections after moving the charger input capacitors closer to the IC. R107 and R302 exchange available front-side sites; their 10 kΩ and 4.7 kΩ values, electrical identities and 0603 packages are preserved. R107 is rotated 180° to provide an accessible interrupt trace exit. The board owner has merged this bounded change into the subsequent power-routing candidate; this folder preserves its independently checked source snapshot.

| Item | Final isolated position, mm | Rotation |
|---|---|---|
| R107 | X23.5, Y75 | 180° |
| R302 | X3.4, Y83.5 | 0° |
| Added CHG_INT_N via | X19.95, Y74.3 | Ø0.50 / drill 0.25 |
| Moved SCL via | X25.30, Y75.125 | Ø0.50 / drill 0.25 |

The preferred guarded delta is [direct-clean-merge/route-patch.kicad_sexpr](direct-clean-merge/route-patch.kicad_sexpr), with its exact object and footprint checks in [proposal-verification.json](direct-clean-merge/proposal-verification.json). It compares clean source `12fc60412aa21dcbca3f4fb69da038a8d312193734992441231de17a70e3d5bc` with candidate `a700da8b29a0faf6e3ea642cba1b0d9ed80d4d86c9f0e530417dc97956259c73`. Earlier proposals in the parent folder and the rejected `430` intermediate must not be applied independently.

Native checks found zero geometry or schematic-parity violations, with unconnected items reduced from 12 to 10. The remaining 17 dangling-track and 8 dangling-via warnings are retained in the raw report. Eight native connectivity witnesses cover the interrupt endpoints, both pull-up supplies, the clock input and capacitor ground returns. New and moved vias were also checked against all surface-mount lands, including same-net lands that ordinary DRC can overlook.

The [independent ground audit](independent-ground/README.md) confirms one continuous In1 ground region and preserved contacts at all 105 plated ground anchors. In2 ground fill is unchanged from the clean baseline. The added interrupt via narrows one local In1 ligament from 1.049 to 0.691 mm; the nearby pre-existing 0.160 mm ligament is unchanged. These are local polygon measurements, not a current rating or a global minimum-width certificate. The root reviewer inspected the final comparison, local ligament witness and actual front/back copper overlays on 2026-09-07.

This is a passed digital review of a bounded routing correction. Final combined routing, current paths, manufacturing exports and enclosure fit require their own fresh checks. Charging, transient, thermal and EMC behaviour have not been physically tested; order readiness remains on hold.
