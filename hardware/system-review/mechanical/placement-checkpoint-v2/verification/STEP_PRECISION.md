# Placement-v2 STEP precision disposition

The STEP is acceptable as a geometry-exchange and fit reference for this **placement-only checkpoint**. It is not the final routed assembly or a fabrication qualification. The native Fusion design remains authoritative.

The historical 1 ppm volume comparison is preserved as failed:0.467263mm³ (1.521478ppm). Both sides were explicitly calculated using Fusion's highest `VeryHighCalculationAccuracy`, and the returned value was 3. Autodesk documents this level as±0.01% (100 ppm); `High` is±0.1%. A1 ppm difference threshold is therefore100 times tighter than the documented computational accuracy. It cannot independently establish a geometry defect at this scale. [Autodesk CalculationAccuracy](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/CalculationAccuracy.htm), [BRepBody.getPhysicalProperties](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/BRepBody_getPhysicalProperties.htm).

Direct geometric checks give stronger evidence:

- All 1,074 placed solids match, all body bounds have matches, and overall bounds match exactly.
- 23,022 deterministic surface samples in both directions have a maximum measured separation of0.001291339mm. This is a sampled result, not an exhaustive Hausdorff bound.
- 14 thread, adapter and manifold interface sections have maximum bound differences of0.000655112mm. The unchanged diagnostic threshold was0.02 mm.
- The STEP itself declares0.001 centimetre (0.01 mm) model connectivity uncertainty: entity`#305850` references length unit`#306066`, `SI_UNIT(.CENTI.,.METRE.)`. This declaration concerns asserted geometric connections; it is not a manufacturing tolerance.

The analytic-plane lookup had one distinct missing datum, Z23.757766953mm. Actual inspection found six native sliver faces there, totalling0.000295890mm². The long slivers have transverse edges only0.00005634 mm wide, well below the STEP's declared connectivity uncertainty. The0.742 mm lookup difference was the distance to a different surviving plane; it was not a measured displacement of the surface. All independently sampled surfaces and section bounds pass. The raw lookup result remains in the diagnostic receipt.

The measured pattern is consistent with STEP surface conversion/healing and numerical integration. It does not prove identical kernel topology. Thread perimeter-length differences are also recorded, rather than treated as exact measurements of manufacturing fit. The source nominal M16 thread class, actual sensor shoulder/seal and physical gas-path tests remain unqualified.

See [step-disposition.json](step-disposition.json), [the matched-accuracy/surface/section report](step-precision-diagnostic.json), [sliver-face measurements](step-unmatched-plane.json), and [the unchanged historical volume comparison](step-roundtrip.json). All source geometry, instance positions, timeline and open-document modified flags were preserved; only the temporary import was closed.
