# Revision 04 measurements and validation boundary

Owner-measured purchased envelopes: display 116.8 H x 69.3 W x 13.7 D mm with factory back removed; occupied FMA protected holder 80.4 H x 42 W x 20.35 D mm. These measurements do not establish local fit tolerances, mounting points or seal dimensions.

At the current 180 H x 85 W x 43 D mm body dimensions, depth is 23.2% lower than A2's 56 mm and the body bounding-box volume is 25.3% higher than A2's 125 x 75 x 56 mm. The factory display casing rectangle occupies 52.9% of the front rectangle. These dimension calculations do not establish native clearance, usable internal volume or active screen coverage.

- [ ] Display frame lip, contact/preload, glass opening, corner radii and cable exits.
- [ ] Holder retention, protection-board protrusions, wire exit and actual RCY/BEC connector latch/clearance.
- [ ] Actual 18650 dimensions; the blue cylinders are visual references, not measured cell CAD.
- [ ] Left button barrel, flange/nut, terminal envelope, tool access and wiring.
- [ ] GCT USB4720-03-A drawing-derived connector fit, local panel, gasket compression and plug overmould. A3 uses a reconstruction from the official drawing; authenticated manufacturer CAD was not obtained. See [USB provenance](components/GCT_USB4720_A3_PROVENANCE.md).
- [ ] AO2 M16 x 1 mating seal and threaded port; hand-tight gas-tight assembly without spanners. No seal groove or O-ring dimensions have been established.
- [ ] Actual MD62 leads/support, CO board/header, humidity board and gas-exposed sensor faces.
- [ ] Tubes/fittings, lid/feedthrough seals, leakage, sample renewal, pressure stability and thermal response.
- [ ] Actual PCB outline and both notches reconciled with KiCad, connector positions, electrical placement, thermal copper, routing and DRC.
- [ ] Exact fastener/insert selection and engagement; separate CAD occurrences do not qualify procurement.
- [ ] Global minimum printed wall; selected sections are partial evidence only.
- [ ] Physical prototype fit, service access, sealing and final material before print-ready release.

The Revision 04 native CAD, eight service paths, 14 driver approaches, 20 selected wall sections, 14 nominal screw/insert pairs, continuous 5 mm gas probe and three independent +2 mm regeneration trials passed their recorded digital checks. Eight selected printed components are each one solid. Nine actual viewport images and all three PDF review sheets passed visual inspection. These completed checks do not close the physical items above; see the [evidence table](README.md).

The native Fusion archive and STEP are saved. STEP re-import verification passed: 102 solids, 66 occurrences and exact overall bounds. Matching High-accuracy mass-property calculations differ by 0.007434 mm³ (about 0.024 ppm), within the unchanged 1 ppm acceptance tolerance. The temporary import was closed and native geometry, poses and timeline remained unchanged. The offline PCB report is only courtyard-area/rectangle-packing evidence; no routed-board fit is claimed.
