# Assembly orientation supplement — source 0962ad86

Use this supplement with the exact BOM, placement file and native Fab view. It does not change any placement or approve an assembly order.

The Coilcraft inductors are electrically nonpolar, but their winding orientation matters for switching noise. Fit the terminal on the manufacturer's **C-mark / short-lead side to native pad 2**, which is identified by the extra line on the custom Fab drawing. Do not infer that orientation from a generic STEP model or from an unmarked square body.

| Reference | Purchased series | Native centre / rotation | C-mark terminal must face |
|---|---|---|---|
| L701 | XGL4020-102MEC | (19.5,50.65), −90° | Pad 2 at (19.5,51.835), CO_SW; toward increasing PCB Y, toward U701 |
| L201 | XGL4030-152MEC | (13,66), 180° | Pad 2 at (11.815,66), TPS63020 L2 switch net; toward decreasing PCB X |

Coordinates are top-view PCB millimetres. The manufacturer describes the marked short lead and preferred switching-node connection in the [XGL4020 drawing](https://www.coilcraft.com/pdfs/xgl4020.pdf) and [XGL4030 drawing](https://www.coilcraft.com/pdfs/xgl4030.pdf). Inspect the real markings before soldering; both inductor switch pads and the selected winding orientation still require waveform/noise qualification in the prototype.

Fit manual rear R504 before installing the PCB in its carrier. C103 and C107 are factory rear-side components. Confirm that the approved carrier opening corresponds to this exact board and maximum-height contract; do not force the board down against a component. Rear test pads require board removal for access.

Leave J104's charging-arm shunt open. The matched Samtec header/socket key configuration and remote Guition power entry remain unresolved supplier/interface gates. The factory-only paste subset, 27-hole fill/cap list, side/rotation convention and two-sided reflow/inspection must be accepted by the assembler before ordering.
