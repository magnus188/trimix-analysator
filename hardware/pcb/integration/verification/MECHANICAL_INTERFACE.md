# A3 PCB mechanical interface proposal

The main-board outline and mounting coordinates below reproduce the existing Fusion substrate. The USB daughterboard is different: the earlier Fusion board was a clearance placeholder and **does not support the manufacturer's SMT lands**. Use its corrected candidate only after revising and checking the connector/cartridge assembly.

This is an offline extraction from the A3 source and saved PrintReview audit. No Fusion or KiCad document was changed. The accompanying `mechanical-interface-proposal.json` contains exact coordinates, arcs, source hashes, classifications and remaining gates.

## Board coordinates

KiCad coordinates are local millimetres, with x right and y down when looking at **F.Cu from the enclosure rear**. The screen is on the opposite side. If a board is positioned elsewhere on the KiCad canvas, subtract that canvas offset first.

| Board | Fusion X | Fusion Y | Substrate Z | F.Cu/component face |
|---|---|---|---|---|
| Main | 50.4 + x | 120 - y | 20.5 to 22.1 | Z22.1, components toward +Z |
| USB | 34.5 + x | 18 - y | 25.7 to 26.3 | Z26.3, subject to connector-section check |

These map the 2D editor and a separately defined surface height. An exported STEP can use a different axis convention: align three noncollinear board/hole landmarks and confirm the component-side normal. Do not blindly treat the 2D/height formula as a rigid STEP rotation.

## Main PCB: current CAD datums

The proposed main board has four layers, 1.60 mm thickness and components on F.Cu only. Its 30 x 99 mm bounding rectangle has a button notch and USB service notch. The closed Edge.Cuts polygon in local KiCad coordinates is:

```text
(0,0) -> (8.6,0) -> (8.6,17) -> (30,17)
      -> (30,99) -> (5.8,99) -> (5.8,94.8) -> (0,94.8) -> close
```

| Mount | Local KiCad centre | Fusion centre | Hole |
|---|---|---|---|
| H1 | 25.6, 92 | 76, 28 | 2.30 mm NPTH |
| H2 | 4.4, 6 | 54.8, 114 | 2.30 mm NPTH |

Two nominal M2 x 7 socket-cap screws clamp the board and carrier. The modeled heads are 3.8 mm diameter and 2.0 mm high; no washers are modeled. Proposed allowances are **4.8 mm all-layer copper keepouts** and **6.0 mm component keepouts** at both centres. The final native service audit used a 5.0 mm diameter screwdriver shaft from Z24.15 rearward; preserve that corridor above each head. The allowances are engineering proposals, not measured hardware tolerances.

The 2 mm carrier touches the entire board back at Z20.5. It provides **zero nominal backside-component clearance**. Through-hole connector tails, backside solder joints and underside components need carrier relief or different mounting heights. The two housing inserts sit below the carrier.

The calculated substrate volume, including the two holes, is 4117.64877989 mm3, matching the native audit's 4117.648780 mm3. This checks the extracted outline; it does not qualify manufacturing tolerances.

The broad rear-cover inner face is Z40.8, giving 18.7 mm above F.Cu before allowances. Cover locating tabs reduce the local ceiling to Z38.6 at the outermost board edge near Fusion Y55-67 and Y98-110. Start actual component placement with an 8 mm height cap and perform the assembled collision check. Existing 5 mm power, 4 mm analog and 3 mm digital boxes are planning envelopes to replace with real parts.

## Nearby parts and harnesses

- The owner-measured holder envelope is Fusion X5.4-47.4, Y27-107.4, Z16.5-36.85. The fixed divider occupies X48.2-50.2 and reaches Z36; the PCB edge has only 0.2 mm clearance to it. Do not place side-facing connectors through that divider.
- Keep the full button notch empty. The unmeasured button terminal reference is X60-67, Y109-117, Z27-35; the barrel and nut are also provisional. Real terminals, insulation and finger access remain measurement gates.
- Prefer the main board's lower edge at Fusion Y21/X60-70 for the USB power harness. The USB service corner must stay clear.
- The narrow upper tongue at X51.4-58/Y117-120 is a candidate for small SMT or soldered-wire connections, subject to the upper mounting screw and chosen footprints. The Y121-127.5 region is a possible harness lane toward the chamber feedthrough, not a verified cable sweep.
- The provisional battery disconnect is X23-35/Y110-120/Z28-34.2. Preserve rearward unplug access and sufficient service slack. Wire lengths, insulation, bend radii and exact connector families remain unmeasured.

## USB: drawing conflict and correction needed

The current daughterboard has a 16 x 13.6 mm bounding rectangle, 0.60 mm thickness, front shoulders, a straddle cutout and R3.85 rear corner reliefs. The two M2 screws belong to the frame/bridge and are **not PCB mounting holes**. Their centres are X33.25 and X51.75, both Y18.25.

[GCT's Revision B drawing](https://gct.co/files/drawings/usb4720.pdf), sheet 1, specifies a 0.60 +/-0.10 mm board, 9.05 mm cutout width, a cutout rear datum 0.55 mm from the layout origin and 5.03 mm further to the front PCB edge. The nose extends 1.28 mm beyond that edge. Shell-tag rows are 4.00 mm apart.

Keeping the current connector nose at Fusion Y1.00 implies:

| Datum | Fusion Y |
|---|---:|
| Manufacturer layout origin | 7.86 |
| SMT pad centres | 7.81 |
| Cutout rear edge | 7.31 |
| PCB front edge | 2.28 |
| Shell-tag row centres | 7.56 and 3.56 |

The existing Fusion cutout reaches Y8.7, so the SMT pad row would lie in air. Its front PCB edge at Y4.4 and illustrative shell wings with 2 mm row spacing also disagree with the drawing. **Do not derive lands or final Edge.Cuts from that placeholder.**

The JSON includes a conditional forward-ear candidate: ear width 12.8 mm, front edge Y2.28, cutout X37.975-47.025 to Y7.31, retaining the existing rear capture reliefs. The 13 mm frame/bezel relief leaves only 0.1 mm clearance per ear side. Review printed tolerance and possibly enlarge that relief. Manufacturer R0.25/local cutout details, plated-slot pads, solder fillets and the actual mid-mount Z datum still need reconciliation. The root task owns this revision and its new native interference/service check.

The existing rear support/capture land X37.4-47.6/Y16-18 touches both PCB faces. Reserve it free of components and solder joints. Away from that land, the broad retaining bridge provides 4.9 mm nominal space above the board and the lower floor provides 4.7 mm below; use a provisional 3.5 mm top-component cap until the complete connector is checked. A small soldered-wire output region near X47.8-50.3/Y9-13 could exit toward the main board, pending the final electrical layout and cable sweep.

All purchased connector, button, harness and sealing interfaces remain physical gates. This proposal does not make the PCB ready to order.
