# U115.3 filled/capped escape: process review

**Suitable for an isolated prototype-layout trial; not approved fabrication data.** The read-only audit uses board SHA `3a4602e834c0548dcf404e043945873e9a373d8839c6478f86059c6d80bbd1a0`. No native board, source, or global rule was changed.

At the actual U115.3 centre **(13.6, 89.775) mm**, a 0.40 mm land / 0.20 mm hole has a 0.10 mm nominal annulus. Its bore remains inside the existing SMT land. The cap adds 0.032620 mm² outside that land. Preserve the original B.Mask and B.Paste aperture exactly, tent the separate via on both faces, and keep this extension masked.

| Independent measurement | Nominal result |
|---|---:|
| Extension to U115.2 / U115.4 copper | 0.125 mm |
| Bore edge to those lands | 0.225 mm |
| Original exposed pad-to-pad gap | 0.200 mm |
| F.Cu nearest foreign copper | 0.545699 mm |
| In2.Cu nearest foreign copper, excluding pours | 0.238077 mm |
| Via copper to regular PTH/NPTH hole | 2.777161 mm |

Five controls pass. Enlarging the land to 0.50 mm fails the 0.10 mm spacing check. Opening the entire 0.40 mm via disk fails the 0.15 mm exposed-pad spacing check. These controls prevent treating tenting or a smaller drill as an automatic manufacturing waiver. The visual in `u115-cc-centred/geometry.png` was inspected.

JLC publishes 0.10 mm pad-to-track clearance, 0.15 mm different-net SMT-pad spacing, 0.20 mm via-hole-to-track/inner-copper clearance, 1:1 mask apertures, 0.09 mm aperture-to-neighboring-copper, and 0.10 mm coloured-mask bridges at 1 oz. This candidate keeps exposed pad spacing unchanged; interpreting its masked cap extension under the copper-spacing rule still requires the fabricator's review of actual CAM. [JLC capabilities](https://jlcpcb.com/capabilities/pcb-capabilities).

JLC's POFV guidance permits 0.20–0.50 mm holes and prefers a 0.075 mm annulus; four-layer POFV is paid. The listed regular-hole separation exceeds 0.45 mm. [POFV requirements](https://jlcpcb.com/news/free-via-in-pad-6-20-layer-pcbs-pofv). The July 2026 process guidance lists a maximum aspect ratio of 10:1. [Current POFV guidance](https://jlcpcb.com/blog/via-in-pad-design-deep-dive).

Assuming the submitted 0.20 mm hole is the actual mechanical drill, nominal thickness/drill is 8:1 and the published 1.76 mm finished maximum gives 8.8:1. The real tool diameter, plating and thickness basis need fabrication confirmation; finished-hole tolerances for component PTHs must not be assigned to vias. JLC distinguishes these tolerances and permits partially masked resin-filled/capped pad holes. Its published flatness description is not proof of acceptable RPW solder joints. [Via covering](https://jlcpcb.com/help/article/pcb-via-covering).

`u115-cc-scoped-rules.kicad_sexpr` proposes only the exact via size/annulus and a **0.12 mm** B.Cu clearance against U115 pins 2 and 4. All other copper retains its existing rules; hole clearance remains 0.20 mm. The independent geometry check binds exact coordinates, pad UUID, size, net and unchanged mask/paste. Position properties and these constraints are supported in [KiCad 10 rules](https://docs.kicad.org/10.0/en/pcbnew/pcbnew.html#custom_design_rules). The rule snippet still needs native parser/DRC and deliberate negative-control execution on the owner's actual routed candidate.

Before acceptance, require fresh filled-plane/native DRC and continuity, unchanged B pad/paste apertures in actual Gerber bytes, no unintended F mask opening, exact selected-hole resin-fill/copper-cap manufacturing drawing, and assembler-approved cap flatness/voiding/stencil. Preserve board ENIG and four-layer process. Do not substitute soldermask ink plugging. Explicit fabrication review remains open; no current, thermal, ESD, or physical test is claimed.

The subsequent owner's native-v3 escape is now independently checked in [native-v3-independent/README.md](native-v3-independent/README.md): the exact scoped rule parses, its counterexamples fail as intended, and 25 actual CAM/rule checks pass. This closes the earlier native/parser/local-export checks for that frozen source only. Remaining C116/CHG routing, final plane integration and fabrication/assembly acceptance remain open.
