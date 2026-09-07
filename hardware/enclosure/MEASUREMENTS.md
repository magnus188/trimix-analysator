# Enclosure measurement checklist — Revision 02

**Status: Editable concept built; physical measurements pending.** The [current Fusion audit](verification/model-audit.json) reports healthy features, fully constrained sketches and zero volumetric interferences for the modelled components. Published dimensions below are source-backed nominal references, not measurements of the purchased parts. Unconfirmed mounting, sealing and connector features remain clearance envelopes in CAD.

The housing is **180 H × 95 W × 60 D mm**, with **3 mm** general walls; side projections give a current overall model width of **107 mm**. Coordinates are **+X toward the viewer's left, +Y up and +Z rearward**, with front **Z = 0**. The rear cover's nominal 3 mm allocation includes a **0.25 mm seating gap**: its solid occupies **Z = 57.25–60 mm** and is **2.75 mm** thick. The future PCB target is **64 × 108 mm**; the actual KiCad PCB has not been resized.

## Published references

| Component | Verified published dimensions | What remains provisional |
| --- | --- | --- |
| Guition JC4880P443C_I_W/Y display | Active area **56.16 × 93.60 mm** in portrait. The specification lists a **69.41 × 117.01 mm** module envelope. | The document covers bare and shell variants. Page 6 shows **66.80 × 114.40 mm** front glass; page 7 shows the larger assembly, **13.8 mm** depth and **4 × Ø2 mm** holes on **60 × 102.6 mm** pitch. Confirm which drawing matches the actual unit before using depth or holes. |
| Honeywell AO2, AA428-210 | **Ø29.3 mm** body; **31.75 mm** below the upper body datum and a **6.5 mm M16 × 1** threaded projection: **38.25 mm** overall by addition, before the cable mating space. Drawing tolerance **±0.15 mm** unless stated. | Confirm the purchased cell matches this body and connector. Allow additional connector, removal and cable bend clearance. Defer mating thread, seal seat and retention details. |
| Winsen MD62 | Body **19 × 9.5 × 14 mm**; untrimmed leads **26 ±1 mm**. | Include the chosen lead length and harness or small board in the mounted envelope. Confirm detector marking, orientation and strain relief. |
| Winsen ZE07-CO | Board **25.4 × 22.4 × 1.6 mm**; sensor **Ø20 × 16.7 mm** above the PCB; pins **3.45 mm** below it. Total stack is **21.75 mm** by addition. | Verify actual module revision and connection hardware. Do not direct the inlet jet at the sensor; the manual excludes strong air convection. |
| GCT USB4720-03-A | Mid-mount PCB thickness **0.60 ±0.10 mm**. Manufacturer panel example has **1.80 mm** reference thickness and stepped openings including **8.44 × 2.66**, **9.14 × 3.35**, and **9.64 × 3.86 mm**, with **±0.03 mm** specified dimensions. | These are different sections of a shaped sealing aperture, not interchangeable rectangular cutouts. Defer final taper, radii, gasket compression and plug clearance until drawing and actual connector are checked together. Support the daughterboard for the specified mating/unmating forces, which reach **20 N**. |

Primary sources: [Guition specification, pages 4, 6–7](https://www.guition.com/icms/upload/fb081940d6fc11f09850077a33e1404f/FTPData/UEditor/file/2026121/1768961095795/JC4880P443C_I_W%20Specifications-EN-V1.0.pdf), [Honeywell AO2 drawing](https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/gas-sensors/automotive-and-emissions/documents/hon-ia-hss-automotive-ao2-o2-gas-sensor-dts-en.pdf), [Winsen MD62 manual](https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf), [Winsen ZE07-CO manual](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf), [GCT manufacturer drawing, sheets 1–2](https://www.mouser.com/pdfDocs/USB4720-ProductDrawing.pdf).

## Measure before fixing mounts and seals

- [ ] **Display:** identify bare/shell variant; measure glass and PCB outline, complete depth including connectors, active-area offsets, hole coordinates and connector insertion/removal space.
- [ ] **FMA FPML1S2P050C protected holder:** measure full occupied outline, cell height, protection-board protrusions, attachment features and cable exit. Include the retained red RCY/BEC-style plug and enough room to disconnect it. Capacity is owner-confirmed **2 × 3400 mAh**, electrically **1S2P**; it does not determine the mechanical envelope.
- [ ] **AO2:** measure body, threaded nose, existing seal and mated cable. Confirm access for removal without loading its connector.
- [ ] **MD62 and ZE07-CO:** measure the installed sensor, support and harness as an assembly. Confirm which surfaces must remain exposed to sample gas.
- [ ] **GYBMEP/BME280 board:** measure board outline, mounting hole, header height and wire exit. Keep it away from the MD62 and regulator's local heat. Confirm the physical sensor and board variant.
- [ ] **Right-side button:** verify the nominal **12 mm** panel size against the actual barrel, flange, nut, allowable panel thickness and complete terminal depth. Include nut-tool and wire-bend access.
- [ ] **USB assembly:** measure the connector and chosen daughterboard, plug overmould clearance, board support and wire exit. Test the replaceable side insert before finalising its seal geometry; a 3 mm general wall is not the manufacturer's local panel example.
- [ ] **Gas connections:** verify the owned **8 mm OD / 5 mm ID** tube, actual fittings, retaining method, insertion length and bend space. Confirm the exhaust remains open and that the chamber can be removed through the rear after releasing the fittings.
- [ ] **M3 inserts and screws:** record the exact insert OD, length, recommended pilot bore and boss diameter, plus screw-head and tool envelopes. Print a fit coupon before fixing production dimensions.
- [ ] **Chamber sealing:** select and measure seal stock, feedthroughs and compression limits before cutting final grooves. Check the removable chamber and rear cover as separate sealing interfaces.

## Model checks to record

- [x] Current Fusion model: healthy features, fully constrained sketches and zero volumetric interferences; **19 component occurrences, 50 solid bodies, 490 timeline items**. This static check excludes coincident faces and does not validate unmeasured physical parts or removal paths.
- [x] Width parameter regenerated **95 → 97 → 95 mm**, with healthy geometry and the original value restored.
- [x] Sampled extraction paths passed with the prerequisites in [README.md](README.md#assembly-and-service-intent). Carrier/display require removal of the USB assembly and button; the chamber requires removal of both gas stubs. This is not a continuous sweep or physical assembly test.
- [x] Nominal **Ø4 × 50 mm** rear-facing screwdriver shafts clear all four screw groups in the model. Actual driver handle and screw/insert selection remain unverified.
- [x] A gas centreline around the AO2 neck is clear at sampled points no more than **1 mm** apart. The ZE07-CO envelope starts at **Z = 16 mm** to clear the exhaust bore. Full flow area, sensor exposure, response, mixing and seals remain unverified.
- [ ] Confirm component and cable envelopes fit without interference; do not treat placeholder volumes as verified parts.
- [ ] Confirm every internal assembly has a feasible rearward removal sequence and reachable fasteners.
- [ ] Confirm the battery can be disconnected before carrier removal and that screws cannot contact cells or wiring.
- [ ] Confirm continuous inlet-to-exhaust flow space with no direct inlet jet on the CO module and no unintended path into the battery/electronics compartment.
- [ ] Confirm display, button and USB reach and plug clearance in front, rear, side and section views.
- [ ] Record the final measured dimensions and the reviewed Fusion version before releasing PLA fit-print files.
