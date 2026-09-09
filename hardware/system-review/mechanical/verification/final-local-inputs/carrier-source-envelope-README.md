# Rear-component carrier window proposal

`carrier-source-envelope.json` is bound to native board `0962ad86…82788`. It records exact B.CrtYd drawing polygons, KiCad cached contours and bounds, pad UUIDs/nets/effective copper bounds, supplier identifiers and body maxima. No board save, Fusion operation or carrier modification occurred.

The proposed rectangles use the **native cached B-courtyard bounding box plus 0.30 mm on every XY side**. The JSON preserves the distinction between that box and the drawn courtyard: native cached bounds extend 0.045 mm beyond the drawing centreline here. This conservative extent is not a manufacturer tolerance.

| Reference | Proposed PCB X | Proposed PCB Y | Size, mm |
|---|---|---|---|
| C103 | 13.430–15.770 | 79.805–81.595 | 2.340 × 1.790 |
| C107 | 11.955–15.795 | 77.805–80.445 | 3.840 × 2.640 |
| R504 | 16.425–20.075 | 46.925–49.075 | 3.650 × 2.150 |

C103/C107 windows overlap. Their enclosing rectangle is **PCB X11.955–15.795, Y77.805–81.595**, size **3.840 × 3.790 mm**. Its W85 world bounds are **X62.355–66.195, Y38.405–42.195**. R504's W85 world bounds are **X66.825–70.475, Y70.925–73.075**. Map all corners dynamically by `X=PcbX+PCB_x`, `Y=PcbY+PcbHeight−PCB_y`; purchased geometry remains rigid.

| Reference / exact MPN | Max body height | Separate assembly allowance | Required depth below nominal B.Cu | Lowest allocation Z |
|---|---:|---:|---:|---:|
| C103 / C1005X7R1H473K050BE | 0.60 | 0.15 | 0.75 | 19.75 |
| C107 / C2012X5R1A476M125AC | 1.45 | 0.15 | 1.60 | 18.90 |
| R504 / RT0603BRD0710KL | 0.55 | 0.15 | 0.70 | 19.80 |

All dimensions are millimetres and use the contract's nominal B.Cu/backseat Z20.5. The 0.15 mm allowance is the existing assembly allocation, not measured solder-joint thickness. No pocket floor or cut Z is selected here.

Source rectangle comparisons give **2.105 mm** between the combined capacitor rectangle and the previously extended lower opening, **6.605 mm** to the J103 tail opening, and **3.300 mm** between R504 and J301. R504 is diagonally separated from RV501 by X1.165/Y3.210 mm. These are not verified material webs. The parent must inspect current BRep topology, combined openings, selected walls, mounting support and service paths.

The purchasing and clearance counts describe different things. The frozen CAM ledger partitions **169 references = 145 purchasable component references (27 factory + 118 manual) + six DNP + 18 PCB features**. Height coverage's **147 populated maximum/allocation rows = those 145 components + J101/J102 custom harness/wire/solder termination allocations**. Thus all153 height rows are checked, six DNP rows are excluded from populated geometry, and 14 testpads plus two NPTH holes need no component-height row. J101/J102 are not standalone purchased connectors, but their clearance envelopes remain mandatory. These are reference-level counts, not unique MPN counts or orders placed.

The parent updated the active incoming-board manifest during the later purchasing check. The JSON records both observed hashes; that application-state file was not used to derive these windows and was not edited by this scout. All bound geometry, supplier and carrier-source inputs remained unchanged.
