# A2.2 verification record

Integrated USB-input revision checks on 2026-09-06, KiCad 10.0.6:

| Check | Result |
|---|---|
| Schematic pages | 10, including the overview and GCT USB daughterboard |
| ERC | 0 errors, 0 warnings; no new exclusions or disabled checks |
| Connected nets | 69 intended groups match the CLI export |
| Complete schematic pin coverage | 395 pins, including off-board parts and intentional NCs |
| PCB components | 119; two remote modules plus four USB-daughterboard parts excluded |
| PCB numbered pin coverage | 353, all match the CLI netlist |
| PCB routing | 0 tracks, 0 zones; placement preview only |
| Render inspection | All circuit pages and final 3D render inspected |
| Actual assembled USB board / cable testing | Not performed; see USB_CHARGING.md |

`intended-nets.json` combines explicit generator intent maps. It is compared
with KiCad's independently exported `Trimix_Analyzer-netlist.xml`, checking
complete net membership, extra/missing pins, accidental NC connections and
assigned footprint pad numbers. `connectivity-audit.json` includes source
hashes and records KiCad's default ignored-check list; passing ERC does not
mean every possible rule was enabled.

`pcb-bom.csv` includes board components and fit/DNP status. Purchased remote
modules are recorded separately in `../../sensor-inventory.csv`.

`previews/audit.json` verifies the saved PCB pad nets after correcting the
MCP import using the CLI netlist. It does not validate routing or charging
and measurement performance. Review unresolved engineering qualifications
in `../../ANALYZER_DESIGN.md`.

The separate USB daughterboard schematic also passes ERC with zero
violations and matches the integrated page pin for pin. The GCT land
pattern is checked against its drawing; board cutout/enclosure geometry
remain pending. See `usb4720-footprint.json`.
