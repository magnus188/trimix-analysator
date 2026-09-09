# Enclosure measurements and evidence - Revision 03

**Status: compact Fusion CAD checks passed within the limits below; physical-fit qualification remains open.** The body is **125 H x 75 W x 56 D mm**. The audited complete model is **125 H x 87 W x 57.65 D mm**, including gas-fitting references and the external M3 rear screw heads. The **4 mm body-depth increase from the initial 52 mm** accommodates 2 mm display retainers plus internal chamber-lid screw heads. Nominal body-box volume is **48.8% below** Revision 02's 180 x 95 x 60 mm envelope, excluding projections. Coordinates are +X toward the viewer's left from the front, +Y up and +Z rearward. These notes supersede the corresponding Revision 02 assumptions for `Trimix_Enclosure_A2` only.

Depth-stack datums: display rear **Z = 14.1 mm**, chamber front **16.5 mm**, chamber rear **50.8 mm**, nominal chamber screw-head rear **52.8 mm**, rear-cover inside **53.8 mm**, flat-cover outer face **56 mm**, external M3 head rear **57.65 mm**. The cover is **2.2 mm thick**. Model regeneration and interference tests passed; these coordinates do not validate the actual factory-frame capture lip or purchased fastener tolerances.

## Confirmed owner measurements

| Purchased assembly | Supplied occupied envelope | Limits of the measurement |
| --- | --- | --- |
| Guition 4.3-inch portrait display in its existing factory housing, factory back removed | **116.8 H x 69.3 W x 13.7 D mm** | Overall size only. Confirm glass opening, corner radii, edge steps, retainer surfaces, connector locations and cable bends. Display retainers are released at the rear; the module then removes **forward**, as approved. |
| Occupied FMA FPML1S2P050C protected holder | **80.4 H x 42 W x 20.35 D mm** | Include any protection-board detail not captured by the overall measurement, wire exit, plug and unplugging space. No mounting-hole or clip dimensions were supplied. The cell specification is two 3400 mAh cells, 1S2P; capacity does not change the mechanical envelope. |

These are owner measurements of the actual hardware. No measurement method, tolerance or complete mounting drawing has been supplied; avoid implying sub-millimetre fit is established by the number of decimal places.

The occupied holder reference is positioned at **X = 3, Y = 4.2, Z = 16.7 mm**. Its two separately modelled blue cells use **18.2 mm diameter x 69 mm** visual-reference cylinders, with centres at **X/Z = 13.8/26.95 and 34.2/26.95 mm**, extending along Y from **9.2 to 78.2 mm**. These cell dimensions are not owner measurements. The pocket floor is **Z = 17.8 mm**, giving 0.05 mm nominal clearance beneath those cylinders; this is an illustrative holder detail, not an established manufacturing tolerance. The red disconnect is provisional reference geometry at **X = 29-41, Y = 70-80, Z = 43-49.2 mm**, with rearward separation; actual connector and finger clearance remain unmeasured.

## Manufacturer references

| Component | Drawing-derived nominal reference | Remaining qualification |
| --- | --- | --- |
| Guition JC4880P443C_I_W/Y | Active display **56.16 W x 93.60 H mm**, 480 x 800 portrait, 4.3-inch diagonal. Published assembly **69.41 W x 117.01 H mm** is a reference only; the actual measured envelope above controls this revision. | Confirm the visible window, active-area offset and actual factory housing details. Do not replace the owner's assembly dimensions with a different published variant. |
| Honeywell AO2, AA428-210 | **29.3 mm body diameter**; **31.75 mm** below the upper body datum plus **6.5 mm M16 x 1** projection, giving **38.25 mm** by addition, before connector clearance. Drawing general tolerance +/-0.15 mm. | Confirm purchased cell, seal, cable connector and axial clearance. The model axis is X. Any gas-side threaded mount or seal seat requires the actual mating dimensions. |
| Winsen MD62 | Body **19 x 9.5 x 14 mm**; untrimmed leads **26 +/-1 mm**. | Include the mounted leads, support/harness and exposed sensing surfaces. Retain detector marking and avoid interpreting a body-only envelope as the full installed assembly. |
| Winsen ZE07-CO | PCB **25.4 x 22.4 x 1.6 mm**; sensor **20 mm diameter x 16.7 mm** above PCB; pins **3.45 mm** below. Combined nominal stack **21.75 mm** by addition. | Confirm actual module revision and connector. Avoid a direct inlet jet; the manufacturer cautions against strong air convection. This is experimental CO sensing, not CO2 or a qualified safety channel. |
| GCT USB4720-03-A | Revision B drawing: mid-mount PCB **0.60 +/-0.10 mm**. Panel example **1.80 mm** reference thickness, with stepped sections including **8.44 x 2.66**, **9.14 x 3.35**, **9.64 x 3.86 mm** and tight specified tolerances. | No manufacturer STEP/IGES obtained. Reconstruction is drawing-derived, not supplier-authenticated CAD. Validate shaped opening, gasket compression, panel thickness, plug overmould and board support. These steps are not interchangeable rectangular holes. |

Primary references: [Guition specification, pages 4, 6-7](https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/FTPData/UEditor/file/2026121/1768961095795/JC4880P443C_I_W%20Specifications-EN-V1.0.pdf), [Honeywell AO2 drawing](https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/gas-sensors/automotive-and-emissions/documents/hon-ia-hss-automotive-ao2-o2-gas-sensor-dts-en.pdf), [Winsen MD62 manual](https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf), [Winsen ZE07-CO manual](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf), [GCT Revision B drawing, sheets 1-2](https://gct.co/files/drawings/usb4720.pdf). The GCT revision date is printed **02/01/25**, with original drawing date **26 October 2023**. Retrieval details and checksum are recorded in [GCT_USB4720_PROVENANCE.md](components/GCT_USB4720_PROVENANCE.md).

## Measure before fixing mounts, seals or print geometry

- [ ] **Display:** corner radii, local shell steps, active-area offsets, front support land, retainer contact points, mounting details and connector/cable space. Prove forward removal after rear retainer release.
- [ ] **Occupied holder:** retention surfaces, protection-board protrusions, wire exit and retained red RCY/BEC plug dimensions. Reserve finger/tool access to unplug it first.
- [ ] **AO2:** installed cell, thread, sealing face and mated cable. Verify the horizontal X-axis arrangement leaves gas exposure and service clearance.
- [ ] **MD62 and CO:** installed dimensions including pins/support/harness, gas-exposed faces and clearance within the L-shaped side column. Record purchased revisions.
- [ ] **GYBMEP/BME280:** board outline, hole, header and wire exit. Confirm actual BME280 chip/board rather than relying on the generic BME/BMP sales label.
- [ ] **Right button:** actual nominal 12 mm barrel, flange, nut, panel-thickness range, terminal depth, nut-tool access and cable bend space.
- [ ] **Left USB:** check the purchased part against the drawing-derived model, daughterboard outline, plug clearance, retaining hardware and local gasket/panel geometry. Keep the connector supported against insertion forces. The final sampled service path is 12.4 mm inward, then rearward, after removing the clamp and required assemblies.
- [ ] **Tubing and fittings:** owned **8 mm OD / 5 mm ID** tube, actual fitting envelope, insertion depth, retaining method and bends. Verify the inlet and exhaust are open and chamber removal does not require forcing tubing against sensors.
- [ ] **Fasteners:** exact M3 insert and screw selections, pilot bore, boss diameter, insertion depth, engagement and driver envelope. Every screw is a separate occurrence in CAD; that does not qualify the chosen hardware.
- [ ] **Chamber seal/feedthrough:** measured seal stock, compression limits, removable-lid retention and feedthrough dimensions. Isolate the gas path from the battery/electronics when the single external rear cover is removed.
- [ ] **Future PCB and wiring:** reshape the clearance envelope behind the pack, then reconcile it with a new KiCad outline and actual component heights. Reserve harness routes and test access before layout release.

## Recorded Revision 03 CAD checks

The [model audit](verification/model-audit.json) dated **2026-09-06 13:11:15 UTC** covers 80 occurrences, 118 solid body instances and 983 timeline items. No Revision 02 result is carried forward as evidence for the compact layout.

- [x] Actual body/complete-model bounds and the current parameter values recorded.
- [x] Healthy features and fully constrained sketches; zero positive-volume static overlaps.
- [x] Three independent +2 mm width, height and depth trials passed with unchanged purchased-part dimensions; original geometry restored. See [parameter-regeneration.json](verification/parameter-regeneration.json).
- [x] 22 separate screw occurrences and 22 inserts. All 22 nominal driver-shaft approaches clear, using 5 mm shafts for M2 and 6 mm for M3; actual hands and handles remain unverified. See [service-drivers.json](verification/service-drivers.json).
- [x] All eight required paths pass in the [final combined service audit](verification/service-paths-cover-disconnect-carrier-chamber-pack_rotated-display-usb_clamp-usb.json), with the documented removals and no CAD mutation. Translation steps are at most 1 mm and rotation steps at most 1 degree; continuous swept volumes were not tested.
- [x] Pack route passes 129 poses with button/USB installed after cover, carrier and closed chamber removal: +Y5.2 mm, -9-degree in-plane turn, +Y19.6 mm, +X10.1 mm, undo turn, +X12.9 mm, +Z60 mm. Actual wire slack and hand access are not established.
- [x] Complete display passes forward extraction after rear retainer release. USB clamp passes rear withdrawal; the cartridge passes 12.4 mm inward then rearward after its stated prerequisites.
- [x] Two continuous 5 mm-diameter BRep probe routes clear: inlet to exhaust and a branch to the lower CO/He region. See [gas-clearance-paths.json](verification/gas-clearance-paths.json). This establishes geometric probe clearance only, not sample renewal or qualified sensor interfaces.
- [ ] **Whole-model minimum printed wall:** selected housing and USB sections meet 2 mm nominal after the flat-cover correction, but a global minimum-wall analysis is not complete. Source-arithmetic reports are partial evidence, not full-model certification.
- [ ] **Actual mechanical retention:** measure and validate the factory-frame capture lip, contact and preload. Accessible retainers and a clear extraction path do not establish secure display mounting.
- [ ] **Actual wiring, connectors and gas performance:** validate connector mating, cable bends, flexible service loops, seal leakage, lower-column sample renewal, thermal effects and response. The upper flow route can bypass the lower CO/He region.
- [x] Seven actual Fusion view exports, native archive CRC and STEP file structure/units checked; all three final A3 review PDF pages rendered and visually inspected. See [export integrity](verification/export-file-integrity.json) and [PDF QA](verification/pdf-review.json).
- [x] [STEP physical geometry/scale round-trip](verification/step-roundtrip.json): 118 solids and 80 occurrences, exact overall bounds, 0.066313 mm3 total-volume difference (0.0000252%); native geometry/timeline unchanged. The current cloud document is version 3 with millimetre display units.
- [ ] Physical fit coupons and complete prototype fit, gas seals, response, thermal behaviour and material suitability before print-ready release.

Earlier partial/failed build and service files are diagnostic history. In particular, initial straight pack paths and USB offsets of 11.7 mm or 13 mm are not substitutes for the final combined audit above. Re-run checks after any subsequent geometry change.
