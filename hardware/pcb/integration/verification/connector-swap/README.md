# Applied connector swap — current placement

J402 (coax) is now above J401 (AO₂) in the authoritative KiCad PCB and `Trimix_Enclosure_A3_PCBFit v5`. The exact centre-for-centre swap would not fit the original narrow PCB section, so the adopted arrangement includes a 0.30 mm local widening and four passive moves. The enclosure exterior and mounting datums are unchanged.

| Reference | Footprint origin X, Y (mm) | Orientation |
|---|---|---|
| J402 | 4.45, 16.60 | 0° |
| J401 | 4.90, 24.46 | 0°; physical centre Y27.00 |
| C401 | 1.30, 23.30 | 90° |
| C402 | 1.30, 26.51 | 90° |
| R403 | 1.30, 29.76 | 90° |
| R401 | 8.25, 25.50 | 90° |

The narrow section is now 8.90 mm wide. Native PCB checks pass, all pad copper retains at least 0.50 mm board-edge clearance, and J402 has 0.54 mm on each side. All 365 numbered pin/net assignments and 133 component values remain unchanged. Existing DRC findings remain 39 violations, 288 unconnected items and zero schematic parity mismatches; this is still an unfinished PCB layout.

The revised carrier has a dropped coax recess with a 2 mm floor and end walls, and remains one connected solid. The imported PCB and revised carrier have no positive-volume clashes with the checked modeled enclosure geometry. Both screwdriver paths and the continuous 28 mm rearward removal path pass, subject to the prerequisites in the service receipt. The native Fusion archive has been saved, reopened and visually reviewed; labels and the component reference list match the updated PCB.

**Actual JJ-CCR elbow, mating connector, cable bends, solder and physical print fit remain unverified.** The swap does not prove that the real elbow fits. Previous print meshes and slicer projects have not been regenerated.

[Consolidated final verification](final-verification.json) · [Independent audit](final-independent-audit.md) · [Cable review](../j402-cable-review.md) · [Carrier solid check](carrier-static.json) · [PCB solid check](pcb-static.json) · [Removal and screwdriver checks](service-check.json)

The candidate files and their intermediate receipts are diagnostic history. `carrier-applied.json` records the state immediately after applying the change; the final static, service and delivery receipts above supersede its pending-check status. Backups in `before/` preserve the previous PCB and local CAD exports.
