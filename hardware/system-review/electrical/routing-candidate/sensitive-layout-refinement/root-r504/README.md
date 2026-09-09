# R504 rear-side layout proposal

**Passed digitally as an isolated change; enclosure fit and the combined CO power-layout revision are still pending.** The authoritative PCB is unchanged.

The original northward front-side move has no clear pose on the tested 0.05 mm grid (X15.5–23.5, Y45–48 mm, four orthogonal orientations) with L701 provisionally at (19.5,50.65). U702 and adjacent components block the courtyards. The remaining front-side courtyard positions collide with CO communication and power copper. `pose-scout.json` preserves that rejected placement search.

`candidate3/Trimix_Analyzer.kicad_pcb` instead puts the unchanged 10 kΩ, 0.1%, 0603 resistor on B.Cu at (18.25,48), 180°. Pin 1 is HE_3V0 at (19.075,48); pin 2 is HE_EXC_DIV at (17.425,48). RN501, R503 and every other footprint are unchanged.

The HE_3V0 connection remains entirely on the rear face, so its redundant through-via is removed. The HE_EXC_DIV via moves to (20.5,47.75), retaining its 0.60/0.30 mm dimensions. Its front trace joins R505; its rear trace passes south of R504 to the existing ADC-monitor trunk. No electrical connection is inferred solely from a shared net or pin label.

The source is the preserved routed PCB `9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f`. The exact change set is `candidate3/delta.json`: seven removed copper items, seven added segments and two modified items. `candidate3/scope-and-witnesses.json` verifies 168 unchanged footprints, the same R504 value/package, the exact change set and five physical contact paths to RN501, J501, R505, U502 and C504.

Validation:

- Native KiCad: zero violations, zero unconnected items and zero schematic-parity issues.
- Routed-via/SMT-aperture guard: all 300 routed vias pass its explicit process checks. The existing three reviewed VIPPO sites remain unchanged.
- The first complete trial is preserved in `candidate/` as rejected: its via/trace crossed VOUT_5V and inner-layer CO_UART_TX copper.
- `candidate2/` corrected those electrical faults but retained an obsolete dangling trace tail; `candidate3/` removes the tail and trims only the unused part of the R505 branch.

This proposal does not move L701 or any other power-stage component. The PCB owner must integrate only the bounded delta and rerun all combined checks. The rear body and assembly allowance require a fresh source-bound enclosure check; no carrier clearance is assumed. Gas accuracy, current, thermal and physical-fit qualification are outside this isolated result.

The exact selected resistor is Yageo RT0603BRD0710KL. The archived manufacturer RT-series specification (`electrical/sources/yageo-rt.pdf`, 12 February 2026, V.17, page 4, Table 1) gives maximum L×W×H of **1.70×0.90×0.55 mm**. The source page was rendered and visually checked in `yageo-rt-p4.png`. Keep the separate 0.15 mm assembly-height allowance explicit. The older 0.60 mm body-height envelope may be retained conservatively, but must not be labeled the manufacturer's stated maximum.
