# A2 3D placement study

Open `Trimix_Analyzer_Preview.kicad_pcb` in KiCad PCB Editor and choose
View → 3D Viewer (Option+3 on this Mac).

This is a deliberately spacious educational arrangement of **119 PCB
components**, grouped to match the schematic overview. The 186 × 150 mm
outline is a study assumption, not an enclosure requirement. There are
**zero tracks and zero copper zones**. This board must not be fabricated.

The schematic includes off-board BME280 and ZE07-CO modules for the wiring
guide; those two modules are excluded from this PCB. The MD62 and AO2 cells
also remain on their external harnesses. The board contains their interface
components and connectors.

The authoritative source is `../Trimix_Analyzer.kicad_sch`. The temporary
schematic used for the MCP import assigns visual placeholder packages to
parts whose exact footprint remains unresolved; it is not a replacement
working schematic. All **353 numbered PCB pin assignments** were then
replaced and verified against KiCad CLI's audited XML netlist. The MCP's
geometric import alone missed connections and cannot be used as validation.

See `../../verification/analyzer/previews/manifest.json` for each
placeholder and `audit.json` for the final pad comparison. In particular:

- J101/J102 are preview wire pads for the USB assembly and protected-pack
  pigtail. J102 does not remove or replace the holder's RCY/BEC plug.
- J301's 2×13 header pitch and mating geometry require physical verification.
- J402 uses a provisional SMB footprint. Its 3D body is a scaled SMA model
  used only to identify a coax connector visually; it is not the real part.
- L201, L701 and U301 have approximate family/package body models.
- Other assigned headers, trimmer and passives still require exact orderable
  parts, mechanical and thermal review before routing.
- DNP options are omitted from the visible fitted model; J104 remains an
  open charge-arm header, without a shunt.

Power-stage loops, grounding, EMC, thermal spreading, component placement
and enclosure fit have not been optimized. The 3D view demonstrates how
the circuit groups relate to physical packages, not manufacturing readiness.
