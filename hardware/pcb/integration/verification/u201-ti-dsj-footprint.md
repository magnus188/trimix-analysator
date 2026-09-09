# U201 TPS63020: TI DSJ footprint correction

**The authoritative schematic now uses `Trimix_Power:TI_DSJ_14`.** This replaces the generic Linear Technology DE pattern with a transcription of TI's actual land and stencil example. All **407 schematic pin/net assignments**, all **137 references**, and every other component field remain unchanged. KiCad ERC reports **zero violations**. The main-board layout owner received the footprint and fresh netlist for replacement without changing U201's placement or nets.

The source is page 33 of the [official TPS63020 datasheet](https://www.ti.com/lit/ds/symlink/tps63020.pdf), **DSJ (R-PVSON-N14), LAND PATTERN DATA, drawing 4210895-2/E, 02/16**. This is the land pattern page, not an inference from the package's exposed metal. The drawing's long X direction maps to footprint +Y and its +Y direction to footprint -X, giving a 3 × 4 mm body with pin 1 at the upper left.

## Manufacturer geometry implemented

| Feature | Native KiCad geometry |
|---|---|
| Fourteen signal lands | 0.60 × 0.24 mm oval lands, 0.50 mm pitch, 2.80 mm row spacing |
| Signal solder mask | 0.07 mm expansion; 0.12 mm nominal mask web between neighbouring lands |
| Exposed pad | 1.58 × 2.85 mm core plus eight 0.20 × 0.775 mm fingers; total copper area 5.743 mm² |
| Thermal paste | Four separate C-shaped apertures; total 4.660 mm², or 81.142% of the copper area, consistent with TI's rounded 81% |
| Stencil example | TI specifies 0.125 mm stencil thickness for this example |
| Thermal via holes | Fifteen 0.20 mm holes on a 0.50 mm grid: three columns by five rows in footprint orientation |
| Pin identities | Signal pins 1–14 unchanged; exposed pad and thermal vias all numbered 15, connected to GND |

The four paste apertures were checked against the enlarged source drawing by an independent reviewer. In the drawing's original orientation their main rectangles are 1.25 × 0.66 mm, centred at X = ±0.725 and Y = ±0.46 mm, with two 0.85 × 0.20 mm outward tabs per rectangle. The central gaps are 0.20 and 0.26 mm.

KiCad loaded the footprint successfully. Its native copper and paste polygons reproduce the stated areas; all signal pad centres, sizes, via drills and annuli passed numerical checks. Actual KiCad [copper](u201-views/copper.png) and [paste](u201-views/paste.png) plots were visually inspected. There are 34 pad records: 14 signal lands, one composite exposed pad, 15 thermal vias and four unnumbered paste apertures. The fifteen unique electrical pin numbers remain unchanged.

## Fabrication choices requiring acceptance

TI's drawing does not specify every manufacturing parameter. These choices are explicit:

- Each 0.20 mm plated drill has a **0.40 mm copper land**, giving a nominal 0.10 mm annular ring. The fabricator must accept this drill and annulus combination.
- The vias are tented on the bottom; the top is open within the exposed-pad mask. The assembler must determine whether tenting, plugging or filling is suitable for solder-wicking control and its reflow process.
- The 0.07 mm mask expansion is also applied to the exposed pad; TI explicitly dimensions it for the signal lands only.
- The **3.9 × 4.9 mm courtyard** includes 0.25 mm clearance over the maximum copper/body extents. It is a layout allowance, not a dimension from TI.
- The existing generic 3 × 4 mm STEP body remains a visual reference. It is not an authenticated TI package model.

The footprint geometry gate is closed. Fabricator/assembler process acceptance, power-loop routing, decoupling, thermal copper and load testing remain separate tasks. This check does not authorize PCB manufacture.

## Change and verification records

Only U201's instance `Footprint` property changed in `Supply_5V.kicad_sch`; the project library table gained `Trimix_Power`. The embedded symbol defaults and all power connections were preserved. A CRC-checked source ZIP was saved before editing.

- [Detailed geometry, source hash, backup and verification receipt](u201-ti-dsj-footprint.json)
- [Fresh authoritative netlist](analyzer-with-testpoints-netlist.xml)
- [Zero-violation ERC report](analyzer-with-testpoints-erc.json)
- [Project-local footprint](../../analyzer/Trimix_Power.pretty/TI_DSJ_14.kicad_mod)

Subsequently, ten other blank footprint fields were assigned the existing board choices with an explicit provisional status. That separate [metadata-only change](provisional-footprints-verification.json) also preserved all 407 pin/net assignments and zero ERC violations.
