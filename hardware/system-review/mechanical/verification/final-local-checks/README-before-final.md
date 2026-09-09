# SystemReview mechanical working copy

This directory owns the **85 mm wide × 180 mm high × 43 mm deep** Fusion review copy. PCBFit v6 and the unrelated FlowGrid documents are preserved. This is an engineering prototype review, with electrical and purchased-part updates still being integrated; it is not a fabrication, gas-analysis or charging release.

The single rear cover, bottom USB-C port, side power button, upper gas ports and front display arrangement remain unchanged. The display is released at the rear and withdrawn through the front; the carrier, pack, USB cartridge and closed sampling cartridge use rear service paths.

## Corrections made in the native model

- Added a hidden **JJ oxygen alternative** using the owner's comparison: diameter −2 mm and length +2 mm relative to AO2. AO2 was not scaled. The same-thread nose and shoulder, and the extra cable allowance, remain explicitly provisional until measured.
- Corrected GCT USB4720-03-A registration using the manufacturer's Rev B drawing. The port centre remains Z26; the nominal 0.60 mm PCB occupies Z24.9–25.5. The support ledge and rear capture pad now match that stack, while screw positions remain fixed.
- Corrected the GCT nose/stake datum without moving the correct PCB lands: nose Y0.61, shell stakes Y3.56/7.56. Replaced four obsolete flat wing references with the drawing-derived bent shell stakes. The gasket outer bounds are corrected to the drawing’s 9.54 × 3.75 mm nominal values. Internal plastic, bend radii, gasket section and physical connector seating remain reconstruction limits.
- Corrected stale P09/P10 component names to **printed bezel** and **printed retaining bridge**. Printed parts use an explicitly unqualified PET-family surrogate for the PETG target; known PCB, copper, shell and contact material families are recorded separately. No mass or FEA claim follows from these metadata changes.
- Bound the imported USB board to its enclosure datum and grounded all STEP descendants to their parent. This prevents pads, dielectric and one formerly free resistor occurrence from remaining behind when the parent moves. The PCB geometry is unchanged.
- Retargeted the lower carrier mount from enclosure width to the fixed real PCB hole, retaining its original position. J402 now uses the Amphenol RF 142138 drawing-derived mounting reconstruction, with the specified nominal tail dimensions and an unchanged PCB pose. The barrel/internal details and the owner's mated plug remain unverified.
- Extended the carrier's existing bottom/left through-opening upward by **2.55 mm** for the approved B.Cu cluster at PCB x7.5–20.0, y84.0–94.5, up to 1.95 mm below the board back. The existing opening is retained, rather than leaving a thin pocket floor. The carrier remains one connected part; the checked strips measure 2.085 mm toward J103, 2.0 mm through the plate and 3.925 mm toward the lower M2 hole. Mount positions and the exterior are unchanged. Final backside component and solder geometry still need the synchronized PCB export.

## Current board integration

The immutable **placement/package-escape checkpoint v2** is imported: **878 main-board STEP solids**, **99 USB STEP solids**, and **1,074 physical assembly solids**. It is not the final routed board. All source hashes are recorded in the [placement export receipt](placement-checkpoint-v2/verification/geometry-export.json).

Native KiCad correspondence checks account for all **169 footprints**: **149 populated maximum/allocation envelopes**, six DNP parts, 12 bare testpads and two mounting holes. All 155 contract rows match the frozen board pose, side, DNP state and enclosure registration, including the **12 backside components**. Three purchased packages lack exact STEP models and are covered by the envelope checks.

Actual assembly geometry has **zero cross-assembly intersections**. All populated component envelopes clear at the nominal 1.60 mm and maximum 1.76 mm finished-board thickness. All **14 nominal driver corridors**, four additional thickness-limit driver probes and **eight sampled service paths** pass. The gas clearance route and separate JJ installed/removal reference checks also pass. The current wall audit passes **34 existing selected sections plus six corrected sections**, and all 14 nominal screw/insert pairs; the backside opening has three additional previously checked material strips. These finite checks do not establish global wall thickness or physical performance.

**One conservative mating-allocation finding remains open:** R301 at PCB (25.75, 71.8) enters the full 35 × 5.5 × 12.5 mm J301 box by 0.1675 mm, producing a 0.2135625 mm³ intersection. The nominal resistor is below the nominal socket seat, but the full approved box remains in the check. The newer routing candidate moves R301 to (11.95, 71.15), outside that allocation. A new synchronized STEP and height contract must close this finding and the associated socket-disengagement test; the earlier failed result is preserved until that check passes.

J301 is rotated 180° around its unchanged connector centre, directing the ribbon inward. A 35 mm wide, 10 mm inward band at Z30.5–34.8 plus 3 mm rearward turn space clears the modeled assembly at both board thicknesses. This is an engineering space allowance, not a supplier cable-bend rating. The actual ribbon, remote connector, free wire length and strain relief remain unmeasured.

The main detailed layer sum is **1.5642 mm**, with a **1.4942 mm substrate body**; nominal finished allocation remains **1.60 mm**. Centre registration puts ordinary copper faces at Z20.5179 and Z22.0821 without scaling. The exporter’s component reference is Z22.1321, about 0.0321 mm beyond the nominal top. This is exporter placement, not measured solder standoff. USB retains its 0.51 mm substrate and nominal Z24.9–25.5 allocation. No physical mask layer is inferred from those differences.

- [Placement native Fusion archive](placement-checkpoint-v2/Trimix_Enclosure_A3_SystemReview_PlacementV2.f3d) and [STEP assembly](placement-checkpoint-v2/Trimix_Enclosure_A3_SystemReview_PlacementV2.step)
- [Placement native roundtrip](placement-checkpoint-v2/verification/native-roundtrip.json): 1,077 solids including three hidden JJ references, 1,197 timeline entries and 38 parameters match exactly, including body poses. The STEP is exported but has not been roundtrip checked for this interim placement checkpoint.
- [Placement geometry and retained mating-allocation finding](placement-checkpoint-v2/verification/integrated-clearance.json)
- [All-footprint height coverage](placement-checkpoint-v2/verification/placement-v2-height-coverage.json)
- [USB fit receipt](verification/final-usb-clearance.json)
- [Thickness screw engagement and tip probes](verification/board-thickness-fasteners.json)
- [Failure-state preservation inspection](placement-checkpoint-v2/verification/post-metadata-state.json)

An optional imported-material annotation attempt failed a compound preservation guard. No imported material-basis annotations were retained, and the imported wrapper descriptions remain older text. Current geometry, body positions and both FlowGrid document states were independently checked afterward. Inherited component materials must not be used for mass or FEA claims.

## Historical digital evidence

The frozen **first-pass main PCB** has been imported with **811 PCB solids**, giving **955 default physical assembly solids**. It retains the original board datum and passes cross-assembly volumetric interference checks. All **137 populated maximum/allocation envelopes** from its 143-row contract also clear the enclosure; six DNP rows are excluded. Internal package/pad/solder contacts within each imported PCB remain in the separate PCB review scope.

The first pass also clears **14 nominal screwdriver corridors and eight sampled service paths**, with all those component envelopes included. Six supplemental J402 tolerance-bound solids clear both installed and service checks. Its conservative 7.2 × 7.2 × 8.2 mm upper bound comes from independent extremes of the drawing's general tolerances; it is not a supplier-rated maximum or a model of the mated cable. These overlays are transient BRep check bodies recorded in JSON, not additional physical parts in the assembly.

This is **first-pass evidence, not the final board**. The snapshot predates the smaller SW101, the revised U114 package/position and the daughterboard ESD changes. The STEP and height contract must be exported together after those changes and routing. The contract combines manufacturer dimensions, F.Fab-derived bounds and provisional allocations; it is not a list of uniformly verified maxima. Missing STEP models are covered by the envelope test, while unsourced dimensions and mated interfaces remain open.

The **pre-refresh baseline** checked 834 physical solids and passed **14 nominal driver paths, eight sampled service paths, a continuous Ø5 mm gas probe route, 34 existing selected wall sections plus six changed sections**, plus the separate JJ installation/removal reference check. Those historical service results must not be attributed to the replacement PCB. These are finite geometric checks, not global wall, strength, gasket, wire-bend, flow distribution or physical-fit verification.

A pre-refresh +2 mm width trial moves the USB assembly rigidly and preserves purchased dimensions. It exposes a range limit: the centred USB frame overlaps the fixed main PCB corner by **0.0819 mm³ at width 87 mm**. The 85 mm baseline is clear. Increasing width requires coordinated USB datum/PCB corner review; do not treat the trial as a validated resize. The pre-refresh +2 mm height and depth trials pass with no clashes or purchased-shape changes. The original dimensions and complete body poses are restored after every trial.

The latest electrical revision adds parts and changes populated heights. Its final STEP must replace the current board reference and the affected checks must run again before these results describe that new board.

## Files to use

- [Measurement checklist with oxygen datum illustration](MEASUREMENTS.md)
- [Machine-readable review summary](verification/summary.json)
- [First-pass main import receipt](verification/pcb-refresh-main-first-pass.json) and [all supplied height/allocation checks](verification/main-first-pass-clearance.json)
- [First-pass envelope-inclusive drivers](verification/first-pass-max-envelopes/service-drivers.json), [removal paths](verification/first-pass-max-envelopes/service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json) and [coax tolerance check](verification/main-first-pass-coax-tolerance.json)
- [J402 model, datum and source limits](components/Amphenol_RF_142138_README.md)
- [Backside allocation probe](verification/backside-allocation-probe.json), [applied carrier cut](verification/backside-allocation-applied.json) and [local diagnostic slicing](verification/backside-allocation-slice-review.json)
- [Baseline body, feature and interference audit](verification/mechanical-audit.json)
- [JJ configuration checks](verification/oxygen-variant-checks.json)
- [USB drawing registration](verification/usb-connector-datum.json) and [PCB stack correction](verification/usb-board-elevation.json)
- [Service paths](verification/service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json), [drivers](verification/service-drivers.json), and [gas route](verification/gas-clearance-paths.json)
- [Changed wall sections](verification/changed-section-checks.json) and [existing selected walls/fasteners](verification/updated-wall-gate.json)
- [Width regeneration receipt](verification/regeneration-CaseWidth.json)

The native `.f3d` checkpoint reopens with all 837 solids (including three hidden JJ references), 1187 timeline entries, 38 parameters and exact body/pose agreement. It remains a pre-electrical-refresh checkpoint; final export/roundtrip checks must describe the replacement boards. Diagnostic meshes and local H2D slice files, when produced, are limited to changed parts P03/P06/P10. Six local H2D diagnostic slices (PLA/PETG for each of the three parts) pass mesh topology and all-layer screening, with zero slicer warnings or island candidates; six selected-layer sheets have been visually reviewed. Support removal, surface quality and physical fit remain unqualified. No printer jobs are sent and the earlier print release is not silently updated.

## Source and qualification limits

The GCT reconstruction uses [USB4720 Rev B](https://gct.co/files/drawings/usb4720.pdf), archived at `hardware/cad/rev03/components/GCT_USB4720_RevB_drawing.pdf` with SHA-256 `b3347df8cf39cc4f72e60f88708d3ddedec681d77bfcbbc9a3a5fd53975a5be6`. The manufacturer's CADENAS entry requires account sign-in; no account was created and no supplier STEP is claimed.

The actual sensor models and sealing shoulders, mated coax/USB/holder connectors, six-wire USB harness, display retention lip, gas fittings, feedthroughs and insert series still require the measurements in the checklist. Generic insert clearance bores are **not approved heat-set retention pilots**. The printed bezel and uncompressed connector gasket establish no device IP rating. PLA is limited to dry fit; PETG remains an unqualified material/process target.

The thickness checks use the chosen fabricator's limits. [JLCPCB currently specifies](https://jlcpcb.com/capabilities/pcb-capabilities) 1.44–1.76 mm for a nominal 1.60 mm board. With the carrier seating plane fixed, the 1.76 mm case moves front-side component bounds 0.16 mm rearward. Both carrier M2 screws retain 3.56/3.40/3.24 mm insert overlap at 1.44/1.60/1.76 mm thickness, and the smallest measured tip-clearance lower bound is 0.538 mm. The current maximum-height and driver checks cover these limits; later component or mounting changes require repeating the affected checks. Purchased models are not scaled to represent this tolerance.
