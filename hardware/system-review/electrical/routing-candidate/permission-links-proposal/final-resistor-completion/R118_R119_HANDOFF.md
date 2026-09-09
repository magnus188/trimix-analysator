# R118/R119 partial — isolated, digitally checked

Source: `synchronized-sys-source.kicad_pcb`, SHA256 `de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db`.
Output: `r118-r119-frozen.kicad_pcb`, SHA256 `2341a6462363e2c7c40866340aaf8249acf1e7733e4378090bdd0a0c88ed1b2f`.

`r118-r119-delta.json` contains exactly four removed old resistor stubs, eleven added copper items and two changed footprints. R116's original selected 0603 footprint and pose are retained; its two connections remain open. Do not replace the main board wholesale: apply the bounded delta to its synchronized successor and repeat native checks.

| Part | Exact selection | Position, native mm | Package maximum |
|---|---|---|---|
| R118 | YAGEO RT0402BRD07100KL, 100 kΩ ±0.1%, 25 ppm/°C | F.Cu (10.75,91.95),180° | 1.1×0.55×0.35 mm |
| R119 | YAGEO RT0402BRD0719K1L, 19.1 kΩ ±0.1%,25 ppm/°C | B.Cu (5.15,88.15),0° | 1.1×0.55×0.35 mm |

Actual unscaled KiCad `R_0402_1005Metric` geometry/model is used. R119 lies inside the existing carrier opening at native X−0.4..20.525,Y83.7..99.7; its maximum body height is 0.35 mm. Final integrated CAD and factory-assembly capability still need review. Manufacturer source: [YAGEO RT V17, 12 February 2026](https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l). Published 19.2 kΩ limiter data are not a guaranteed characterization of the chosen19.1kΩ network; physical current qualification remains pending.

R118 connects to the existing permission-Q network on F.Cu and returns directly to the GND barrel at (10.45,90.5). R119 connects by a short B.Cu segment to a new ordinary .50/.25 mm via at (4.95,88.85), then F.Cu to U114.4. Its GND return reaches the existing barrel at (3.7,87.75). No new In2 signal track or zone-outline change is introduced.

Verification:
- `r118-r119-final-drc.json`: zero geometry errors, zero schematic parity issues; four remaining opens and31 existing-type silk/dangling warnings. Matching isolated schematic changes are listed in `isolated-field-sync.json`; R101 is a synchronization of the pre-existing source change, not part of this PCB delta.
- `r118-r119-witnesses.json`: four explicit native pad/track/via witnesses, without zone or internal-IC shortcuts.
- `r118-r119-via-pad-clearance.json`: ordinary annulus0.125mm nominal; closest same-net pad surface gap0.15892mm, closest foreign pad0.38691mm. Native DRC also checks trace/other-net clearances and drill constraints.
- `r118-r119-plane-audit.json`: In1 remains a single continuous filled region; new via clearance removes0.641254mm². In2 filled ground is identical to the source. Geometric connectivity does not establish physical current/thermal performance.

Not a fabrication release. R116, CC and UVLO completion, integrated rerun, final CAM/CAD review and physical validation remain outside this partial acceptance.
