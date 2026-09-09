# Deprecated EasyEDA-to-KiCad import notes

This is a historical conversion record, not the current analyzer design. Open
`Trimix.kicad_pro` only when inspecting the archived import. The corresponding
schematic is `Trimix.kicad_sch` and contains only the original **ESP-32S** page.
The page name is inherited from the source; it does not establish the final
controller or display interface.

## Migration from EasyEDA, 2026-09-05

Exported the open **Trimix** EasyEDA Pro project using **File → Save as →
Project Save as (Local)**, choosing **epro (V2 format)**. Imported it with
KiCad 10.0.6's native EasyEDA Pro importer.

The original source is preserved in
`easyeda-source/ProPrj_Trimix_2026-09-05.epro`.
`easyeda-source/initial-kicad-import.zip` preserves the initial full KiCad
import. The ESP-32S backup and Arduino alternative are excluded from the
working project at the owner's request. Earlier projects outside this
repository were not changed.

The importer generated footprint references without a usable footprint
library. The original footprints used on the ESP-32S page were individually
converted with KiCad's EasyEDA Pro importer and matched to components by the
source footprint UUID. The project now includes:

- `Trimix_Symbols.kicad_sym`: symbols matching the imported schematic cache.
- `Trimix_Footprints.pretty`: 19 native KiCad footprints for the 29 components.
- `sym-lib-table` and `fp-lib-table`: project-relative library links.

Power symbols received unique hidden references. The imported drawing-frame
symbol is excluded from the BOM and PCB. Circuit values and wire paths were
preserved. The PCB document in the source was empty: no placed components or
routed tracks were present. `Trimix.kicad_pcb` is therefore an empty board,
not a completed layout.

## Verification and current limitations

- All 29 physical component references match the source page.
- Component positions match after the coordinate transformation.
- The 108 KiCad wire segments cover the same paths as the source. KiCad
  removed five zero-length segments and merged adjoining segments.
- All 19 converted footprints reload in KiCad, with their original pad
  numbers retained. This checks conversion, not suitability for the actual
  parts; footprint dimensions and datasheet pin assignments still need review.
- The standalone netlist exports successfully and contains 29 components.
- Immediately after migration, the electrical rules check reported **67 errors and 50 warnings**. There
  are no footprint-link or symbol-library errors. Remaining findings are
  unconnected pins, pin electrical-type conflicts, undriven pins/power inputs,
  dangling wire endpoints, and an isolated pin label. These need circuit
  review; none were hidden or waived to make the report pass.
- Manufacturing readiness, analog performance, battery protection, power
  architecture, and 3D model completeness have not been validated.

Evidence is in `verification/migration.json`, `verification/Trimix-erc.json`,
`verification/Trimix-netlist.xml`, and `verification/Trimix.svg`.
Files prefixed `import-` describe the initial full import before isolating the
ESP-32S sheet and repairing the footprint links.

## Continue the schematic

### First correction: passive pin types, 2026-09-05

Installed and tested the KiCad MCP server described in
[`hardware/MCP_SETUP.md`](../../../MCP_SETUP.md).
Used its `set_symbol_pin_type` and `update_symbol_from_library` tools to
change the resistor, capacitor, and fuse pins from `input` or `unspecified`
to `passive`. This affects 18 pin definitions across nine library symbols,
used by 15 placed components: R3, R4, R6–R11, C13–C18, and F1.

The project library and embedded schematic definitions were updated together.
Only the pin electrical-type fields changed: geometry, values, references,
footprints, and wiring were preserved. All 73 exported net names and their
component/pin memberships match the migration netlist exactly.

The current ERC result is **61 errors and 39 warnings** (100 findings), down
from 117. No ERC severities or exclusions were changed. This correction
improves the symbol definitions; it does not complete or validate the circuit.

The complete project before this correction is preserved in
`verification/before-passive-pin-fix.zip`. Current verification files are
`verification/Trimix-passive-fix-erc.json` and
`verification/Trimix-passive-fix-netlist.xml`; the MCP operation record is
`verification/passive-pin-fix-mcp.json`. The earlier migration evidence
remains unchanged.

### Next circuit review

Review one section at a time with the owner, starting with the power tree and
USB input. Confirm the Guition ESP32-P4 board interface against the current
firmware before adding controller connections; older project notes describe
different ESP32 hardware. Then complete charging/protection, regulators,
sensor inputs, and I2C connections. Check parts against manufacturer
datasheets rather than treating the old BOM as a verified circuit design.

Resolve these specific discrepancies during that review:

- The schematic uses BQ24079RGTR at U19; older notes specify BQ24074.
- Both an ADS1115 breakout (U6) and a bare ADS1115 (U25) are present.
- Some resistor values differ from their sourcing metadata, including R11
  (1 kΩ with the same part number as the 100 kΩ resistors) and R6
  (10 kΩ with a part number containing 6201). R3/R4 also have inconsistent
  value, part-number, and footprint information. Verify the intended circuit
  values before selecting replacement orderable parts.
