# Power-board 3D preview

Open `Trimix_Power_Preview.kicad_pcb` in KiCad PCB Editor, then choose
**View → 3D Viewer** (Option+3 on macOS). Drag to rotate and scroll to zoom.

This is an **unrouted educational placement preview**, not a build-ready PCB.
The temporary outline is 90 × 64 mm, 1.6 mm thick. Functional groups are
spread out for readability; final switching-loop placement, grounding,
thermal design, mounting holes and enclosure fit remain to be designed.
No tracks, ground planes or manufacturing outputs have been generated.

The 41 footprints represent the four-page P1.1 schematic. Two optional I2C
pull-up resistors (R302/R303) remain DNP, so their bodies are hidden.
All 131 numbered pin assignments match the KiCad-exported schematic netlist.
The working schematics and their footprint choices were not changed.

## Preview substitutions

These are visual placeholders, not purchasing or footprint recommendations:

| References | Shape used in this preview | Still required |
| --- | --- | --- |
| J101, J102, J301 | 5.08 mm two-position screw terminals | Actual PCB connector/wire termination choice and ratings |
| J103, J201 | 2.54 mm two-pin headers | NTC connector and OFF switch connection choice |
| J302 | 2.54 mm seven-pin header | Host connector and physical Guition pin mapping |
| D101 | 0805 LED | Actual LED package and part |
| SW101 | Generic 6 mm pushbutton | Actual switch drawing |
| L101 | Würth HCM-7050 footprint and body | Ordered inductor dimensions, land pattern, Isat and DCR |
| L201 | Existing XxL4020 footprint with XAL4020 body | Exact XFL4020 3D model; this substitution is visual only |
| U301 | Existing MAX17048 TDFN footprint with a generic 2 × 2 mm DFN body | Exact package model; exposed-pad geometry/height differ |

The panel USB-C socket, protected FMA holder, cells and Guition display are
external to this preview. The green blocks only represent provisional wire
connections on the PCB. They do not depict the ordered USB-C socket.

Nine footprints are placeholders; two additional 3D bodies are approximations.
Other assigned packages remain provisional pending final part selection.

## Verification and design status

See `../../verification/power/previews/audit.json` and `manifest.json` for
the source hashes, model paths and import audit. The initial MCP net import
missed connections in this hierarchy; the preview's pad assignments were
corrected from KiCad CLI's independently audited netlist and checked again
after saving. Do not re-sync using the MCP geometric parser without repeating
that comparison. This issue did not change the source schematics.

See `../../../POWER_DESIGN.md` for the open charging-design questions.
ERC and 3D rendering do not establish charging safety. USB-C input behaviour,
cell identity and ratings, holder protection, firmware fault handling, final
PCB layout and bench charging/temperature tests still require validation.

The generator is `../../../tools/prepare_power_3d_preview.py`. It stages copies
of the schematics in a temporary directory and refuses to overwrite an existing
preview. Future electrical work belongs in the working schematic project;
this preview should be replaced after the actual parts and layout are agreed.
