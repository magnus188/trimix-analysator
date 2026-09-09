# Coordinated control routing — isolated completed candidate

The frozen candidate has **zero unconnected items, zero copper/courtyard rule errors and zero schematic parity issues** in native KiCad. It is a routing-review candidate; it is not a manufacturing release or a physical charging/thermal qualification.

- Before: `../before-owner-cc.kicad_pcb`, SHA256 `0115f87b4b3f8f5b216b6f8a7e3b5ae6d2cc39cef97dbcb2f3233507b4721fe6`.
- After: `complete-controls-frozen.kicad_pcb`, SHA256 `b305a4c3ce2de15ec42ec1ddef622cf50f9166c37a5fa0958b50593f753eddb2`.
- Guarded native delta: `complete-controls-delta.json`: 39 removed, 56 added, 7 modified items. Four modified footprints are R115, R118, R119 and Q110. Remaining modified items are the ordinary CC destination via, its B segment, and the root-approved SET tail adjustment. Compare UUID and complete before item before applying. Do not overwrite a newer owner board.
- Full matching local project, sheets, rules and libraries are here. This includes the root's exact scoped U115.3 CC VIPPO rules. The canonical files have not been edited.

## Final electrical layout

R115 becomes the actual Yageo RT0402BRD0710KL 10k/0.1% at F(21.4,83.3),270°. Two short F traces connect it to the existing HOST and CLR networks. This removes the resistor-only lower HOST and CLR detours. The retained physical pad partitions and U113-to-U112 path were proved before pruning (`pruning-witnesses.json`).

R118 is RT0402BRD07100KL, F(10.75,91.95),180°. R119 is RT0402BRD0719K1L 19.1k/0.1%, B(5.15,88.15),0°. R116 stays RT0603BRD071KL, **the original actual 0603 part, value and F(7.75,94.75),0° pose**; both legs are connected. No 0402 R116 or B-side R115 trial is adopted.

Q110 remains DMN2056U-7 at F(18,89.5),180°, with the same purchased body, courtyard and unscaled model. Its copper lands now follow Diodes DS38480 Rev2-2, July2021, page7: 0.9mm radial ×0.8mm tangential rectangles, radial centres ±1mm and two-pin pitch1.9mm. Exact library ID `Trimix_Power:DMN2056U_SOT23_Diodes_Recommended`, file `Trimix_Power.pretty/DMN2056U_SOT23_Diodes_Recommended.kicad_mod`. Q111 is unchanged. Source: https://www.diodes.com/datasheet/download/DMN2056U.pdf ; saved PDF, page image and contract in `../land-pattern-source/`.

Mask/paste layer participation and existing margin settings are retained; the apertures follow the new rectangular lands. The manufacturer drawing defines copper lands, not a qualified factory stencil or solder-filleting process. Assembly-process review remains required.

Final special filled/capped interfaces are CC(13.6,89.775),0.40/0.20mm, and UVLO(13.6,91)/(17.95,87.925),0.50/0.25mm. Their factory VIPPO approval remains a separate hold. Ordinary CC destination is **(16.7,90.36)**,0.50/0.25mm. The earlier left-shifted(16.325,90.3) proposal was rejected and is not included.

Ordinary BRANCH escape(17.8,89.5),0.50/0.25mm, fits between the real Q110 lands. A short C116 B ground return was reshaped while preserving its R126 and U115 ground-via endpoints. CHG uses the existing via(16.8,87.8) directly on In2; the redundant second CHG via and F fanout were removed. UVLO also uses a direct In2 connection. The route into R116 reaches around the right controller area on F/B/In2. No signal was added to In1, and no 0.40mm power route was narrowed.

## Verification

- `drc-final.json`: 0 opens, 0 geometry/courtyard errors, 0 parity. 32 assembly/dangling warnings remain: 14 track-dangling, 6 via-dangling, 8 silk-over-copper, 3 silk-overlap and 1 back-text mirror warning. These are explicitly left for the owner's final cleanup; they are not represented as a clean manufacturing DRC.
- `native-conductor-witnesses.json`: 22 explicit native physical paths, including both R116 legs, R115/HOST/CLR, Q gate/SERIES, CHG to U101/R107/J301, CC, UVLO, SET, C116 DVDT and the C116/R126/U115 ground returns. No assumed IC/internal or same-pin joins; planes omitted from these conductor witnesses.
- `new-via-interface-audit.json`: all seven added/modified ordinary via interfaces pass ≥0.20mm foreign-pad and ≥0.05mm same-net surface-gap checks. The three exact filled/capped interfaces are labelled separately, not silently exempted as ordinary vias.
- `complete-plane-audit.json`: source was refilled in a separate snapshot under the same current rules. In1 remains one continuous filled region with105 via/plated-pad anchors; In2 remains11 regions, all21 anchor contacts retained. No prior ground-via contact is lost. In2 ground area increases from68.0174 to80.5613mm² after removal of detours. Erosion probes are diagnostics, not a guaranteed minimum neck or a current/thermal rating.
- `In1_Cu_F_Cu.png`, `In1_Cu_B_Cu.png`, `In2_Cu_F_Cu.png`, `In2_Cu_B_Cu.png` show actual filled ground with the outer-layer power/copper overlay. SVG sources are included. The B/In2 overlay was visually inspected; parent review of the actual return paths is still required before integration.
- Parent independently found all29 requested power/monitor native witness paths identical to the earlier completed SYS source (separate parent evidence). This is not a resistance/current/thermal qualification.

C116's existing true0402 Murata choice needed the local Manufacturer and Datasheet fields synchronized as well as its package/MPN. See `isolated-field-sync.json`, `c116-metadata-sync.json`, `q110-isolated-field-sync.json`, and the actual matching sheet. Native parity is the final consistency check.

The original canonical board, its current owner edits, USB daughterboard and Fusion model were not modified. Final owner merge, assembly markings, manufacturing constraints, combined CAM exports, CAD clearance, factory process approval and physical testing remain separate acceptance steps.
