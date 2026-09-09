# Four-layer main-board stackup selection

**Selected design basis: JLC04161H-3313, nominal 1.6 mm, 1 oz outer / 0.5 oz inner copper.** This is a source-verified published stackup, not a fabrication acceptance or an impedance certificate. The thin USB board is a separate two-layer process.

The following values were checked against JLCPCB's published table on 2026-09-07. [JLCPCB stackups](https://jlcpcb.com/impedance)

| Native layer / material | Published thickness, mm | Design use |
|---|---:|---|
| F.Cu | 0.035 | Components, local power loops and sensitive signals |
| 3313 prepreg | 0.09940 | Dk 4.1 |
| In1.Cu | 0.0152 | Continuous ground reference |
| FR-4 core | 1.265 | Dk 4.6 |
| In2.Cu | 0.0152 | Ground reference beneath rear-side circuitry, allocated distribution |
| 3313 prepreg | 0.09940 | Dk 4.1 |
| B.Cu | 0.035 | Local USB protection and remaining routing |

The published layer values sum to **1.5642 mm**, excluding solder mask. Retain the published values and nominal finished thickness separately; do not silently adjust the core to force an arithmetic 1.6 mm. Finished thickness is subject to the fabricator's process. JLCPCB lists **±10%** for a 1.6 mm board and **±0.1 mm** below 1 mm. Thus the main fit checks must consider **1.44–1.76 mm**, and the USB board **0.50–0.70 mm**. [JLCPCB capabilities](https://jlcpcb.com/capabilities/pcb-capabilities)

## Engineering rationale and conditions

The approximately 0.10 mm top-to-ground spacing is useful for compact return paths around the ADC and switching circuitry. This is a layout inference, not a measured noise improvement. A solid reference still requires inspection of the actual filled plane: an unbroken layer name does not prove unbroken copper.

Keep the ground plane under both oxygen input paths, their bias and ADC filters. Do not carry high-current returns through the sensor's differential negative conductor. Keep switching-node areas small. For B.Cu protection circuitry, retain contiguous In2 ground nearby and avoid crossing distribution gaps with fast control traces. Use local return vias at bypass capacitors, not long routes to a remote ground pour.

The internal copper is thinner than the outer copper. Power-current calculations must use the actual layer's thickness; do not apply 35 µm to an internal trace by default. Published nominal copper is not a guaranteed minimum after processing. Trace width, plating, temperature and contact-resistance assumptions remain explicit in the current-path review.

This board carries low-rate sensor/control interfaces rather than the display's high-speed bus. No controlled-impedance requirement is invented for these analogue connections. If a later interface introduces one, use the selected finished stackup and obtain fabrication confirmation before changing routing.

## Release checks

- Bind this exact selection in the native project and fabrication notes; confirm the supplier accepts it for the final board and assembly process.
- Independently inspect every layer and ground connection after zone filling.
- Check the final board at its thickness limits, including screw engagement and purchased-component clearances. Keep purchased parts at their actual size.
- Obtain acceptance for thermal via fill/cap, fine-pitch lands, stencil/paste and double-sided assembly. Published capability alone does not accept this job.
- Qualify the 0.60 mm USB daughterboard separately. Its GCT land/cutout and ground-tag annular-ring conflicts remain unresolved; selecting a main-board stackup does not resolve them.

Purchasing and fabrication release remain on hold.
