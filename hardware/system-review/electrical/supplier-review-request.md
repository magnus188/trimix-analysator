# Unsent fabrication and assembly review request

This is a draft for a later supplier enquiry. It has **not been sent**, and it is not authorization to fabricate, assemble, substitute parts or purchase anything. Attach only the final source-matched engineering exports after routing and inspection finish.

## Proposed message

Please review these two engineering prototype boards and provide written process feedback before any order is placed. We need a fabrication/assembly solution for the critical interfaces below. Please identify any required drawing or footprint change explicitly; a generic DFM pass will not establish connector fit.

### Main PCB

- Four layers, nominal 1.6 mm, JLC04161H-3313, 1 oz outer and 0.5 oz inner copper, ENIG. Please confirm the finished stackup and thickness tolerance for this job.
- Factory assembly of the exposed-pad/fine-pitch devices and the agreed factory BOM population. The manual-assembly population and DNP rows must remain unpopulated unless separately approved.
- Confirm epoxy resin fill, planarization and copper cap on both faces for the **27 selected holes** in `main-final/fill-cap-process/required-fill-cap-holes.csv`: 9 U101 and 15 U201 package thermal bores, plus 3 signal VIPPO. Some thermal holes are encoded as plated footprint pads, so a routed-via option alone does not specify them. Soldermask plugging is not the specified substitute. Do not fill component lead holes.
- Review paste and stencil apertures for BQ25895, TPS63020, TPS259470 RPW0010A, the ADCs and the matched resistor network. RPW0010A has asymmetric power lands; do not replace them with a generic center-ground QFN footprint.
- Review the source-matched factory-only paste in `main-final/factory-stencil/cam/`, containing only the 24 factory parts. Manual/DNP apertures, including C706, are omitted. Confirm stencil thickness, cap flatness, solder volume, thermal-pad coverage/void criteria and inspection. The full-board paste in the general CAM folder is retained only for design/export comparison.
- Confirm double-sided assembly feasibility, tooling/panel requirements, inspection coverage and the exact manufacturer part numbers. TPS22950CQDDCRQ1 must not be replaced by the similarly named industrial C variant.
- Review the final inner-layer drill-to-copper clearances and confirm that all quoted fabrication tolerances are reflected in the supplied process.

### USB daughterboard — unresolved process conflicts

- Two layers, nominal **0.60 mm**, matching the GCT USB4720-03-A drawing's **0.50–0.70 mm** range. Review the small board's panel and connector-support fixture requirements.
- The current footprint preserves the GCT recommended lands and cutout. Its nominal copper-to-cutout gaps include approximately **0.10 mm and 0.15 mm**, below JLCPCB's published 0.20 mm routed-edge clearance.
- Two ground tags use **0.80 mm lands with 0.50 mm holes**, giving **0.15 mm nominal annular rings**. This is below JLCPCB's published **0.18 mm absolute minimum for two-layer, 1 oz PTH pads**.
- The connector drawing's cutout tolerance is tighter than the published routing tolerance. Please confirm a specific achievable process or provide a manufacturer/assembler-approved alternative land and cutout drawing. Merely accepting a DRC waiver is insufficient.
- Review **TPD4E05U06DQAR** 0.20 mm-wide lands, paste/bridge control and optical inspection. Its internally unconnected opposite pads are deliberately connected by external copper for TI's supported straight-through routing; those are real PCB connections.
- Review the soldered six-wire interface, plated slots and connector retention. Do not increase board thickness, relocate the connector, enlarge the notch or change its lands without a revised drawing and fit review.

Please state which items your process can meet, which require changes, what inspection you provide, and any minimum panel/order constraints. Do not begin production or make substitutions based on this enquiry.

## Source references for the enquiry

- [GCT USB4720 product](https://gct.co/connector/usb4720)
- [GCT product drawing](https://www.mouser.com/pdfDocs/USB4720-ProductDrawing.pdf)
- [JLCPCB capabilities](https://jlcpcb.com/capabilities/pcb-capabilities)
- [JLCPCB stackup table](https://jlcpcb.com/impedance)
- [TI TPD4E05U06 datasheet](https://www.ti.com/lit/ds/symlink/tpd4e05u06.pdf)

The electrical review and all physical validation requirements remain separate from supplier acceptance.
