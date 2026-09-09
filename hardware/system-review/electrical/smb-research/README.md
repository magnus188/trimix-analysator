# J402: manufacturer SMB connector selection

Reviewed 7 September 2026. This folder is research evidence; it does not change the PCB, schematic or enclosure.

**Recommended new design choice: Amphenol RF 142138**, a straight through-hole SMB jack with a male centre pin. The [manufacturer product page](https://www.amphenolrf.com/en-us/part/142138/883/) identifies the part as active. This selects a connector to buy; it does not identify the unspecified connector already ordered from AliExpress.

The manufacturer-authored drawing is saved unchanged as `amphenol-142138-drawing.pdf`, with a rendered page for inspection. It is Rev B, 21 November 2011, retrieved from [TestEquity's drawing mirror](https://assets.testequity.com/te1/Documents/pdf/amphenol/amphenol_142138-connector_customer-drawing.pdf). The [official drawing link](https://www.amphenolrf.com/en-us/assets/file/4065786651/) returned HTTP 403. The PDF is a raster drawing; its text extraction is empty and the dimensional audit used the rendered page.

| Interface | Manufacturer drawing | Current J402 footprint | Result |
| --- | --- | --- | --- |
| Four shell terminal centres | 5.08 mm square | 5.08 mm square | Nominal match |
| Centre mounting hole | Ø1.20 mm | Ø1.20 mm | Nominal match |
| Four shell mounting holes | Ø1.70 mm | Ø1.70 mm | Nominal match |
| Connector body | 7.00 mm square | 6.90 mm Fab outline | Correct the outline by 0.10 mm overall |
| Courtyard | Not specified | 8.50 mm square | Existing allocation; physical elbow clearance remains pending |
| Height above PCB | 7.60 mm nominal, inferred as 11.50 − 3.90 mm | Wrong SMA model | Replace the model |

Preserve J402's approved centre **(4.45, 16.60) mm** and **0° rotation**. The existing annular rings are 0.52 mm nominal; these are layout choices, not dimensions prescribed by the connector drawing. The drawing's general tolerances and the fabricator's finished-hole tolerances still require assembly review.

The centre contact remains pad 1, `O2_B_RAW_P`; all four metal-shell terminals remain pad 2, `O2_B_RAW_N`. **The shell is sensor minus and must remain isolated from GND, chassis and conductive fasteners.**

The [AII PSR-11-39-JJ replacement sensor page](https://www.aii1.com/en-us/sensors/PSR-11-39-JJ.htm) specifies a 90° SMB female cable termination. This supports a PCB male-centre-pin mating choice for that replacement sensor. It does not prove the exact owned sensor's connector, cable dimensions or polarity. Trial mate the actual cable and check its complete elbow sweep, strain relief, J401 clearance, enclosure clearance and removal path before fabrication.

Do not substitute Amphenol **142134**, whose mating contact is a female socket. Do not substitute **142138-11** (surface mount) or **142138-75** (Mini-SMB 75 Ω). The [manufacturer SMB interface drawing](https://www.amphenolrf.com/en-us/assets/file/4065861575/) distinguishes the mating interfaces; seller use of “male/female” alone is insufficient.

The official part page offers an [exact 142138 STEP file](https://www.amphenolrf.com/en-us/assets/file/4066922863/) listed as 81.1 KB. That download also returned HTTP 403 in this session, so no exact manufacturer STEP is included. The installed KiCad library references a generic `SMB_Jack_Vertical.step`, but that file is absent locally. Remove the current scaled `SMA_Amphenol_132134-10_Vertical.step`: use the exact 142138 model when accessible or a clearly labelled drawing-derived reconstruction at unit scale. A reconstruction is not exact manufacturer CAD and cannot validate the unmeasured cable.

`j402-connector-audit.json` records the source URLs, snapshot hashes, dimensions and outstanding physical checks. `J402-audit-snapshot.kicad_mod.txt` is a read-only snapshot for comparison, not a replacement footprint. No physical mating, assembly, sensor or electrical test was performed. Third-party drawings retain their original attribution and licensing; this work does not relicense them.
