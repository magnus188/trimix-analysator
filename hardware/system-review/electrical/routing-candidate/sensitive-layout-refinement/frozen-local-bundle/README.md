# Local power-layout refinement — review checkpoint 0962ad86

This isolated revision completes four targeted layout corrections. Native KiCad reports **zero violations, zero open connections and zero schematic-parity differences**. The previously delivered 9f274fdf board and its CAM package remain unchanged while the new mechanical and independent CAM checks finish. These files are **on hold for manufacturing**.

The source board is `hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb`, SHA256 `0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788`. `review/geometry-handoff-manifest.json` binds the matching XML, 153-row maximum-height contract and STEP exported without decorative extra pad thickness. `review/cam-input-manifest.json` separately binds the actual copper, drill, mask, paste, BOM and placement bytes. Generic or missing STEP models do not replace the maximum-height contract.

| Native physical path | Previous full-item length | Revised full-item length | Revised layers / barrels |
|---|---:|---:|---|
| U701 FB to R702 | 29.841 mm | 1.040 mm | F / 0 |
| U701 output to C702 | 6.803 mm | 1.603 mm | F / 0 |
| BQ BTST to C103 | 9.150 mm | 1.356 mm | F+B / 1 |
| BQ SW to C103 bootstrap branch | 9.838 mm | 5.621 mm | F+B / 1 |
| BQ REGN to C107 | 8.884 mm | 2.921 mm | F+B / 1 |
| U701 FB to R701 | 4.194 mm | 4.561 mm | F+B / 2 |
| U701 SW to L701 | 5.245 mm | 6.377 mm | F / 0 |

These are explicit native trace/barrel witnesses, including complete intersecting track items. They are not clipped shortest geometric paths, loop-inductance estimates, current ratings or measured performance. The last two modest increases are retained openly: the coordinated arrangement gives the output capacitor a short direct feed and puts the R702 feedback connection beside the IC. The actual BQ-to-inductor load path remains on front copper; the sole new rear BQ_SW segment belongs to C103's bootstrap branch.

C702 now has a direct front-layer ground return to U701, around the outside of the switching trace, plus a new ordinary 0.60/0.30 mm ground stitch at (22.8,55.8). Both previous ground anchors remain. The return uses 0.35 mm copper with a 0.20 mm, 0.6875 mm pin escape; using 0.35 mm at the IC failed the adjacent switching-pad clearance and was corrected. No new filled/capped interface was introduced. The short capacitor feed is separate from the existing longer output load branch, whose ordinary via is now clear of C702's SMT aperture.

Actual component changes are:

- C103: TDK C1005X7R1H473K050BE, 47 nF / 50 V / X7R / ±10%, genuine 0402 with manufacturer-range rectangular lands; rear (14.6,80.7),180°. Maximum body 1.15 × 0.60 × 0.60 mm. The nominal bootstrap capacitance is preserved.
- C107: TDK C2012X5R1A476M125AC, 47 µF / 10 V / X5R / ±20%, genuine 0805 with manufacturer-range lands; rear (13.875,79.125),0°. Maximum body 2.20 × 1.45 × 1.45 mm. It replaces the original 22 µF / 25 V / 1206. Under identical typical-curve assumptions it has comparable retained capacitance at REGN bias, but about 56–58 µC more modeled startup charge. Biased capacitance, startup, ripple and local temperature still require physical testing.
- R702: YAGEO RT0402BRD07100KL, 100 kΩ / ±0.1%, genuine 0402; front (18.8,54.25),90°. Value unchanged; maximum body 1.10 × 0.55 × 0.35 mm.
- R504 remains the same YAGEO RT0603BRD0710KL, 10 kΩ / ±0.1%, moved to the rear at (18.25,48),180°. Exact maximum body is 1.70 × 0.90 × 0.55 mm. RN501 and R503 remain unchanged. Its filtered excitation-monitor trace passes under the input-side edge of L701 with continuous In1 ground between the layers; magnetic coupling and measured noise are not qualified by the geometric check. A direct north-side wrap would encounter the HE_3V0 conductor, so no unreviewed crossing was added.
- C702 and L701 retain their purchased parts and sizes, at front (21.25,54.2),0° and (19.5,50.65),−90° respectively. L701's manufacturer-marked short lead remains on its switching pad. U701 has no pose or electrical change; its dense overlapping reference moved to the assembly map.

The new rear C103, C107 and R504 envelopes require the source-matched carrier assessment; an old enclosure pass does not establish their clearance. Purchased geometry is not scaled to fit. Assembly allowance is separate from manufacturer maximum dimensions.

`review/electrical-audit.json` contains 217 freshly run electrical assertions. `review/refinement-identity-audit.json` adds 205 exact value, MPN, land, body and pin-conservation checks, with four deliberately incorrect metadata controls rejected. `review/erc-raw.json` has one reviewed LM66100 ST-to-ground exception; `review/erc-exception-guard.json` verifies that exact exception against freshly exported sources and negative controls. It is not a claim of zero raw ERC errors. Parent review separately verifies all 29 power/monitor paths and filled-ground contacts.

The main assembly ledger contains **169 physical references: 27 factory parts, 118 manual parts, six DNP and 18 PCB features**. The 145 populated purchased parts have exact MPNs; the keyed host connector configuration and supplier/process acceptance remain explicit holds. Factory assembly adds C103, C107 and R702. R504 is installed manually before the board is fitted to the carrier. The source-matched silk has 141 printed references; the remaining 28 have exact pad locators in `assembly-drawings/` and all references appear in `cam/assembly-reference-map.csv`.

`factory-stencil/` contains a derived paste-only source and Gerbers retaining only the 27 factory parts' original apertures. Manual and DNP parts, including C706, are omitted from that subset. `fill-cap-process/` requires resin fill, planarization and copper capping on both faces of the same 24 thermal bores and three signal VIPPO interfaces. All 27 native pad/via definitions are unchanged from 9f274fdf. Supplier acceptance of hole classification, capping, flatness, stencil thickness, double-sided reflow and inspection remains mandatory before an assembly order.

The earlier battery, charging-arm, host input, real harness, transient/ESD, cold/depleted startup, thermal, gas-path and sensor-calibration holds remain in force. Relative layout improvement and clean digital checks do not close those physical qualifications.
