# J402 90-degree cable and J401 access

**The saved connector positions have changed: coax J402 is now above AO2 J401.** This review supersedes the earlier recommendation to retain their former positions. The actual JJ-CCR elbow and J401 mating plug remain unverified; J401 must be connectable and removable with the J402 cable fitted.

The current main board uses these datums, in millimetres:

| Feature | KiCad X, Y | Fusion X, Y |
|---|---|---|
| J402 coax centre / mating axis | 4.45, 16.60 | 54.85, 103.40 |
| J401 AO2 physical centre / middle pin | 4.90, 27.00 | 55.30, 93.00 |
| J401 footprint origin / pin 1 | 4.90, 24.46 | 55.30, 95.54 |

KiCad Y increases downward; Fusion Y increases upward. The transform is Fusion X = 50.4 + KiCad X and Fusion Y = 120 − KiCad Y. The PCB neck is now **8.90 mm wide**. The two connector centres are **10.41 mm apart**, with **1.75 mm between their conservative cached courtyard bounds**. J402's bounds are X0.155–8.745, Y12.305–20.895 mm; J401's are X3.085–6.715, Y22.645–31.355 mm. These bounds come from KiCad's `BuildCourtyardCaches()` followed by `GetCourtyard(F_Cu).BBox()`, rather than just the polygon vertices.

These gaps exclude cable plugs. J402 still displays a **70%-scaled SMA STEP placeholder**, which does not verify the purchased SMB connector. J401's model represents a bare standard header. Neither includes a mating housing, elbow, cable bend, strain relief or disconnection space. Rotating the symmetric vertical footprint does not establish the real elbow's permitted clocking.

The carrier's former openings have been restored and new solder-tail openings aligned to these positions. A dropped U-shaped bridge has a 2 mm floor at Fusion Z15–17 mm and two 2 mm end walls beneath the coax opening. The [native applied carrier](connector-swap/carrier-applied.json) is one solid lump. Final static checks found **zero intersections and zero errors** for both the [carrier](connector-swap/carrier-static.json) and the [685 imported PCB bodies](connector-swap/pcb-static.json), using 17 and 700 candidate-pair tests respectively.

The [complete assembly service check](connector-swap/service-check.json) verified containment of all 686 moving solids and a clear continuous **28 mm rearward movement**, plus two clear Ø5 × 50 mm screwdriver paths. Prerequisites remain: remove the rear cover, disconnect the battery and PCB harnesses, and remove the two carrier screws. The battery holder stays installed. These checks cover modeled rigid geometry; nominal divider contact, actual solder tails, print fit, cable access and structural strength still require physical validation.

The next cable check is to add the actual J402 connector, mated elbow and J401 mating-plug envelopes, then verify J401 insertion/removal with the coax connected. Include elbow clocking, mated height, sideways reach, cable diameter and bend radius, and clearance to neighbouring plugs, the divider, button, rear cover and fasteners. **The 1.75 mm courtyard gap is not a cable-clearance approval.**

J402's centre is `O2_B_RAW_P`; its exposed shell is the second sensor's negative signal, `O2_B_RAW_N`, not circuit GND. Preserve isolation from unrelated contacts and hardware. J401 pins 1 and 2 remain `O2_A_RAW_P` and `O2_A_RAW_N`; pin 3 is unused. This documentation update changes no electrical values or connections.

The earlier 12.91 mm centre distance, 4.25 mm courtyard gap, nearby-component gaps and imported model world bounds describe the previous placement and must not be used for this revision.

[Current native-board geometry, source hashes and open checks](j402-cable-review.json) · [Component reference key](../reference/COMPONENT_REFERENCE.md)
