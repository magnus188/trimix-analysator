# Main PCB carrier: independent tail-clearance proposal

Fourteen true through-hole components require **eleven proposed windows**. These cover all actual copper-pad envelopes plus 0.50 mm laterally. U101/U201 thermal vias have no component tails and are excluded. This read-only review does not modify Fusion or KiCad geometry.

Coordinates below are Fusion world millimetres. The PCB back is Z20.5 and carrier material is Z18.5–20.5. Cut through the full carrier, for example Z18.4–20.6. The fixed housing supports require separate native checks.

| Parts | X min | Y min | X max | Y max | Open edge |
|---|---:|---:|---:|---:|---|
| SW101, J101, J102 | 50.000 | 20.300 | 70.925 | 33.750 | left and bottom |
| J801, J802 | 52.774 | 63.350 | 60.015 | 69.850 | closed |
| J103 | 53.050 | 38.385 | 55.750 | 43.625 | closed |
| J104 | 53.050 | 46.385 | 55.750 | 51.625 | closed |
| J501 | 53.050 | 78.610 | 55.750 | 86.390 | closed |
| RV501 | 58.140 | 76.285 | 65.660 | 78.725 | closed |
| J301 | 73.775 | 49.405 | 79.015 | 82.585 | closed |
| J402 | 50.000 | 88.590 | 59.710 | 97.410 | left |
| J601 | 68.000 | 97.000 | 78.200 | 99.950 | closed |
| J701 | 68.000 | 89.000 | 78.200 | 91.950 | closed |
| J401 | 53.450 | 102.010 | 56.150 | 109.790 | closed |

**J301 needs a local carrier extension** before making its closed window: join X80.5–81.20, Y47.4–84.6, Z18.5–20.5. The new right rim is 2.185 mm; the lower and upper end bridges at this extension are 2.005 and 2.015 mm. The source housing has a straight inner cavity boundary at X82.6 in this band, giving 1.40 mm nominal clearance. Its outer taper does not taper that inner cavity. Root must verify the actual BRep and +Z service path. The rear cover must be removed first because its locating lip overlaps this XY band higher in Z.

Separate raw openings would leave narrow material: 1.10 mm between J801/J802, 1.15 mm between J101/J102, 1.825 mm between their merged opening and SW101, and less than 1 mm at the outer edges beside J402/SW101. The larger merged openings remove those slivers. The merged J801/J802 minimum X is rounded outward by 0.001 mm to cover the actual source position.

The nearest separate openings are J501/J402, with **2.20 mm** between them, and J501/RV501, with **2.39 mm**. J601/J701 retain 2.40 mm to the right edge. J401 retains 3.25 mm to the left edge and 2.85 mm to the upper notch. Both R3.6 mounting reserves remain intact; the nearest cut is 3.925 mm from H1's actual hole edge and 3.060 mm from H2's actual hole edge. An orthogonal planar source calculation gives **one connected carrier region**. These are selected source checks, not a stiffness or global minimum-wall certificate.

RV501's library leads reach Z16.08; the display's occupied envelope ends at Z14.1, leaving 1.98 mm nominal separation before solder and assembly allowances. The actual trimmer MPN remains unverified. Real wire ends on J101/J102 are unmodelled, and J402's scaled SMA model cannot establish real SMB tail fit. The 0.50 mm allowance is a conservative design proposal, not a validated solder-fillet dimension.

[Full numeric receipt and source hash](carrier-relief-independent-review.json) · [Actual pad extraction](carrier-tht-pad-readonly.json) · [Native library-model tail report](main-through-hole-relief.json)
