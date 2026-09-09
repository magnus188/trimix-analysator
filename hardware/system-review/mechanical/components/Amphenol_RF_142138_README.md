# Amphenol RF 142138 — J402 mounting reference

This model replaces the previous scaled SMA visual model. It is a **drawing-derived reconstruction**, not the manufacturer's CAD or a validated model of the owner's cable. The original J402 footprint position and electrical connections are unchanged.

Use `Amphenol_RF_142138_Drawing_Reconstruction.step` in KiCad with **scale 1, rotation 0°, offset 0 mm**. The origin is the centre signal pin at the connector's PCB seating plane. The body extends in +Z and the five solder tails extend in −Z. A separate `Amphenol_RF_142138_Nominal_Upper_Envelope.step` contains the full **7 × 7 × 7.6 mm nominal space above the PCB**, for a conservative check within the drawing's base footprint. Do not populate both alternatives as physical parts.

| Feature | Nominal dimensions | Evidence |
|---|---:|---|
| Base footprint | 7.00 × 7.00 mm | Rev B drawing |
| Nose-to-tail overall length | 11.50 mm | Rev B drawing |
| Solder-tail projection | 3.90 mm below seating plane | Rev B drawing |
| Barrel length above front base face | 5.80 mm | Rev B drawing |
| Base thickness | 1.80 mm | Derived: 11.50 − 3.90 − 5.80 |
| Above-PCB height | 7.60 mm | Derived: 11.50 − 3.90 |
| Four shell legs | 1.02 mm square, centres at (±2.54, ±2.54) mm | Rev B drawing |
| Centre solder tail | Ø0.96 mm | Rev B drawing |
| Recommended board holes | Ø1.20 centre; four Ø1.70 on a 5.08 mm square | Rev B drawing |

The product drawing does not dimension the complete barrel profile, snap groove, mating-pin projection, underside recess or internal insulator. The simplified visual barrel uses a generic SMB interface diameter reference; this is **not evidence that the complete RF142138 barrel has that diameter or axial profile**. Internal bore, pin and PTFE extents are explicitly marked reference parameters. The undimensioned underside recess and lead chamfers are omitted. Neither the reconstruction nor nominal envelope includes a mated plug, elbow, cable bend, solder fillet or tolerance margin.

The drawing's general metric tolerances are ±0.20 mm for 0.5–8 mm dimensions and ±0.40 mm for 8–30 mm dimensions. The derived 7.60 and 1.80 mm values are nominal differences, not independent tolerance specifications. Measure the received connector and cable before accepting a tight fit.

**Electrical isolation matters:** the J402 metal shell is connected to `O2_B_RAW_N`; it is not assigned to chassis or ground. The actual cable's SMB identity, mating force, occupied elbow volume and lead polarity remain to be checked.

The drawing specifies gold-finished brass shell/contact and natural PTFE. CAD colours represent those descriptions. The reconstruction's internal volume and default material properties must not be used for mass, plating, structural or thermal calculations.

Source: [Amphenol RF 142138 product page](https://www.amphenolrf.com/en-us/part/142138/883/), manufacturer Rev B drawing dated 21 November 2011, obtained unchanged through the [TestEquity drawing mirror](https://assets.testequity.com/te1/Documents/pdf/amphenol/amphenol_142138-connector_customer-drawing.pdf). The [official STEP download](https://www.amphenolrf.com/en-us/assets/file/4066922863/) was publicly listed but returned HTTP 403. Generic mating references are from the [Amphenol SMB interface sheet](https://www.amphenolrf.com/en-us/assets/file/4067456646/); they do not replace the undimensioned product profile.

The adjacent JSON contains hashes, exact CAD parameters, native bounds and unit-aware STEP reimport results. The editable F3D also retains a hidden nominal upper-envelope component. All modelling occurs in an isolated temporary Fusion document; the enclosure and unrelated open documents are preserved.
