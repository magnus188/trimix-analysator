# USB support wall evidence — Revision 03

**Evidence level: calculations from the corrected construction inputs, not a minimum-thickness measurement of every final CAD face.** These checks apply after `build_usb()`, `add_housing_clamp()` and `fix_usb_geometry()`. The accompanying `../verification/usb-wall-source-checks.json` contains the arithmetic and source hash. No Fusion operations were used to create this evidence.

| Printed feature | Source-derived dimension | Scope |
| --- | --- | --- |
| Backing flange | 2.00 mm along X | Nominal uninterrupted plate; openings are intentional. |
| Flange lower corner | **2.072281 mm** at Y4: `69 + sqrt(3.5² − 2²) − 69.8` | New R3.50 outer corner inside the housing R3.60 corner; inward reinforcement preserves thickness. This selected section does not prove a global minimum. |
| Board support rails | 3.60 mm wide × 4.00 mm deep | Nominal rectangular cross-sections. |
| Board and faceplate insert bosses | **2.00 mm** radial: `3.6 − 3.2/2` | Full circular annulus before joining; final intersections and pilot dimensions still require checking against actual inserts. |
| Fixed clamp post around eccentric insert | **2.00 mm** radial: `4.3 − 0.7 − 3.2/2` | Post centre X70; insert axis X69.3. |
| Fixed clamp post floor | **2.00 mm**: `39.2 − 37.2` | Material beneath the reference insert bore. |
| Clamp strap / stalk | **2.00 mm** thickness / **2.00 × 2.00 mm** | Strap Y12–25; offset stalk Y23–25 after the correction. |
| Clamp strap around M2 clearance | **2.00 mm** minimum nominal edge distance: `72.4 − 69.3 − 2.2/2` | Other planar edge distances are 2.50, 2.90 and 7.90 mm. |

The separate **metal faceplate** is 2.30 mm thick in its main area and has the **1.80 mm local reference seat** from the [GCT Revision B drawing](https://gct.co/files/drawings/usb4720.pdf). Its small steps and lips are metal geometry, outside the printed-wall claim. The connector shell, insulator, gasket, electrical contacts, 0.60 mm PCB and nominal fasteners are also outside that claim. Their thin features must not be classified as printed-wall failures.

The corrected upper faceplate mount is at **Y23.75, Z30.95 mm**. Its R3.60 boss spans Z27.35–34.55, leaving **0.05 mm calculated clearance** above the provisional PCB and **0.45 mm** below the clamp stalk. These are small nominal fit clearances, not established production tolerances. The 11.7 mm USB extraction is a separate service check with battery, lower display retainer and clamp removal prerequisites.

Release still needs a final CAD wall check at joins, corner transitions and holes; actual insert/fastener selection; printer/process allowance; and physical plug-load and fit tests. Zero volumetric interference alone establishes none of those results.
