# TPS22950CQDDCRQ1 package/current-limit review

**Recommendation:** use the exact automotive `TPS22950CQDDCRQ1` as the leaded candidate for the existing nominal 50 mA limiter. Published TI evidence supports this substitution. Do not substitute industrial `TPS22950CDDCR` or preproduction `PTPS…` parts. This selection does not resolve the separate VBUS overvoltage/transient problem.

TI's Q1 datasheet SLVSGP6A, December 2022, section 6.5 page 5 specifies **34 / 50 / 66 mA minimum / typical / maximum at RILIM = 19.2 kΩ**, over −40 to 125 °C. Operating input is 1.8–5.5 V; absolute maximum input is 6 V. ON current consumption is at most 60 µA. Pin assignment is **1 ON, 2 VIN, 3 GND, 4 ILIM, 5 VOUT, 6 FLT**. FLT is open drain. [TI Q1 datasheet](https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf)

The datasheet's **31 October 2025** ordering addendum lists this exact `C…Q1` orderable as Active / Production, DDC six pins, marking **950Q**. Its live TI orderable page links that same Q1 datasheet and describes a 0.05–3.5 A current-limit range. The page treats `.A` as identical to the unsuffixed orderable. Active status is not a stock promise; the fetched inventory display was unavailable/out of stock. [Exact TI orderable](https://www.ti.com/product/TPS22950-Q1/part-details/TPS22950CQDDCRQ1)

The apparent C-variant conflict is explained by the **different catalog family**. Industrial TPS22950C has a published 0.5–3.5 A range, while original TPS22950 has 0.05–3.5 A. [Industrial comparison table, page 3](https://www.ti.com/lit/ds/symlink/tps22950.pdf) TI engineer Elizabeth Higgins additionally clarifies that industrial C operation below 0.5 A is not tested/guaranteed and distinguishes it from Q1. This support clarification corroborates, rather than replaces, the Q1 specification. [TI E2E clarification](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1232889/tps22950-functional-difference-between-tps22950-q1-and-tps22950c)

## Mechanical interface

The official orderable's DDC0006A drawing, 4214841/E August 2024, was rendered and inspected. Use **3.05 × 3.05 × 1.10 mm maximum overall occupied envelope**, including leads. Molded body is 3.05 × 1.75 mm maximum; lead pitch 0.95 mm. The drawing's example pads are 1.1 × 0.6 mm, with opposing pad centers 2.7 mm apart. Do not interpret the product page's nominal 2.9 × 2.8 mm figure as the maximum molded-body dimensions. [TI DDC drawing](https://www.ti.com/lit/pdf/MPDS124I)

## Boundaries to preserve

- This is a new footprint/pin mapping, not a WCSP pad replacement. Reconcile symbol, lands, orientation and CAD height against the DDC drawing.
- The 19.2 kΩ table point is the evidence; resistor tolerance, upstream auxiliary consumption and transient current still belong in the complete USB budget. The typical resistor equation is not an independent worst-case tolerance guarantee.
- The Q1 table literally prints its test condition as `VOUT − VIN = 0.3 V`, an apparent sign inconsistency for forward limiting. Preserve that documentation caveat; do not claim the table proves every dynamic fault waveform.
- Bench checks still need startup into capacitance, overload behavior, source changes and current-limit/OVP interaction. Nothing was ordered, soldered or tested electrically in this review.
