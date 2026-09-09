# Cable termination candidates — 8 September 2026

**No qualified lower-profile Guition replacement was found in this bounded manufacturer-source review. Keep the current remote socket allowance conditional, and preserve the keyed main-board Samtec end and its pin map.** This note changes no purchasing BOM, PCB, firmware or CAD. Neither the Guition post dimensions/plating nor a completed harness was physically verified.

## Guition 2 × 13 termination

The [existing IDSD review](../electrical/host-harness-review/README.md) establishes a socket body of 9.144–9.525 mm and permitted insertion of 5.588–6.223 mm. Thus its conditional cap extension beyond a compatible pin tip is 2.921–3.937 mm. The 13.4 mm glass-to-pin-tip measurement is **not** a usable exposed-post-length measurement. A shorter socket housing alone does not demonstrate an improved installed stack.

| Candidate | Manufacturer evidence | Disposition |
|---|---|---|
| **3M 89126-0001** | [TS0449, revision M](https://multimedia.3m.com/mws/media/22265O/3m-tm-idc-ribbon-cable-socket-891-series-ts0449.pdf), sheets 1–3: 26 positions, no center bump, no strain relief; closed **female socket plus cable** height approximately 10.5 mm; 37.6 mm length and 6.05 mm body width. The height section contains **no male header**. | Larger socket than IDSD; no demonstrated lower cap extension. Drawing specifies at least 5.84 mm posts, 0.64 ±0.03 mm square and a short tapered tip, but no maximum insertion. A guaranteed beyond-tip maximum therefore remains unavailable. |
| **Samtec HCSD family, 13 positions per row** | [HCSD catalog, 14 May 2026](https://suddendocs.samtec.com/catalog_english/hcsd.pdf): female body 9.53 mm reference, 37.59 mm derived length, 5.08 mm width; insertion 4.70–6.35 mm; square posts 0.61–0.66 mm. | No proven improvement. The tempting 7.87 mm drawing belongs to the **male HCMD**. The female's reference body minus permitted insertion spans about 3.18–4.83 mm before body tolerances. No mixed HCSD/IDSD assembly was qualified or invented. |

3M explicitly permits ribbon exit from either long side of its cap. Its contact numbering and orientation mark are shown in the bottom view. That can inform a later routing candidate, but reversing exit must not be treated as an electrically straight-through cable: verify every conductor against the existing [J301 contract](../electrical/host-harness-review/contract.json). All Guition cavities, including physically present pin 7, must remain open. The proposed 3M part has gold contact surfaces, uses 26/28 AWG stranded ribbon, and has no positive lock to bare posts. Its optional cable strain relief increases the height substantially. Quoted dimensions are manufacturer reference values; no current stock or custom assembly commitment was established.

The HCSD catalog specifies 28 AWG 7/36 stranded tinned copper, gold contact surfaces and several wiring variants. It does not establish compatibility with the actual Guition post plating. Neither candidate authorizes hand-soldering wires onto a PCB receptacle, cutting posts, omitting insulation, or reducing the CAD clearance. An exact vendor-assembled mixed-end harness remains a procurement/qualification action.

## J601/J701 — JST XH

Use **XHP-4**, with **four SXH-001T-P0.6 contacts per fully populated housing** for suitably selected 22–28 AWG wire. The current [JST XH catalog](https://www.jst-mfg.com/product/pdf/eng/eXH.pdf), pages 2–5, gives:

- XHP-4 housing: **12.3 × 5.7 × 7.5 mm** reference; 2.50 mm pitch.
- With the existing **B4B-XH-A** top-entry header: **9.8 mm reference height above the PCB**, before wire bending, grasping and withdrawal clearance. Do not add the two body heights together.
- SXH-001T-P0.6: tin-plated phosphor bronze, AWG 28–22, insulation OD **0.9–1.9 mm** in the current catalog.
- **SXH-002T-P0.6** is the alternative for AWG 30–26 and OD **0.9–1.3 mm**.
- **SXH-001T-P0.6N** is a different, lower-insertion-force contact, AWG 26–22 and OD 1.3–1.9 mm; JST explicitly notes lower vibration resistance. It is not the default choice here.

The [JST product page](https://www.jst-mfg.com/product/index.php?lang=2&series=277) identifies friction retention. Wires leave axially upward from a top-entry mate; strain relief and a physical bend radius are separate allocations. The 3 A family rating is conditional on 22 AWG, not every listed wire gauge. Exact wire type/OD, current, sealing compatibility and crimp process remain to be selected; the housing identification does not close those checks. No exact manufacturer-documented precrimp lead was qualified in this bounded pass.

## J501 — existing Harwin M20-9990346

The cable-side family mate is **M20-1060300** plus **three M20-1180046** loose tin contacts. [Harwin's housing page](https://www.harwin.com/products/M20-1060300) specifies the matching contact family; [contact details](https://www.harwin.com/products/M20-1180046) specify 22–30 AWG, tin over nickel, straight cable termination. This matches the existing header's tin mating finish.

**A small insertion tolerance mismatch remains:** the [M20-106 drawing, issue 8](https://content.harwin.com/asset/b9496f9a-d89f-420f-aea9-abb4534be02f/DRG-00376-Technical-Drawing-Datasheet-M20-106-pdf.pdf) permits **5.50–6.30 mm** mating pin length. The [M20-999 drawing, issue 23](https://content.harwin.com/asset/640f59f4-1860-40fe-82ef-f2a104ffa7d8/DRG-00479-Technical-Drawing-Datasheet-M20-999-pdf.pdf) gives **6.10 ±0.25 mm**, reaching **6.35 mm**. Thus a fully bottomed pair is not a complete worst-case tolerance pass, despite nominal compatibility. Obtain manufacturer acceptance or design and verify a controlled stand-off; do not force the longest permitted pins to bottom.

The female housing is **7.82 ±0.30 mm long × 2.50 ±0.20 mm wide × 14.00 ±0.20 mm high**. With the header base at **2.54 ±0.10 mm**, fully seated stack is **16.54 mm nominal / 16.84 mm maximum above PCB**, before any stand-off, wire bend or removal clearance. These are conditional stack calculations, not a fitted sample. CAD must use the full cable housing, not merely the 6.1 mm bare posts. Wire exit is axial. An unshrouded three-pin header is reversible; a labelled harness and polarity/continuity check are required.

The [M20-118 drawing, issue 13](https://content.harwin.com/asset/d742d022-1905-41c8-b996-8feb2ed262c8/DRG-00379-Technical-Drawing-Datasheet-M20-118-pdf.pdf) allows insulation OD **0.9–1.6 mm** and specifies the **Z20-320** hand tool. The current [C001 component specification](https://content.harwin.com/m/7d31e750480889aa/original/C001-C001XX-Component-Specification-M20-Series-2-54mm-pitch-PCB-connectors.pdf) gives 0.8 N minimum contact withdrawal and 7.84 N minimum contact retention; this is friction contact retention, not a housing latch. Tin contact durability is 50 operations. The owner's iron, microscope and hot air do not substitute for a controlled open-barrel crimp process.

[Harwin's cable-production guidance](https://content.harwin.com/m/196bd1cfbf043609/original/CP058-Product-Training-Module-Cable-Products-from-Harwin.pptx) offers M20 cable assemblies made to order. This is an alternative to buying a dedicated crimper, but no ready-made exact M20 lead/assembly MPN, price or delivery commitment was established. A vendor-assembled harness should name these exact contacts, wire, measured cut length and pin map.

## Shared wet-side bundle limitation

The [chamber wiring](chamber-wiring.md) contains eleven insulated conductors. A provisional Ø3.8 mm route is **not** a demonstrated complete harness: eleven Ø1.2 mm circles occupy 12.44 mm², exceeding the route's 11.34 mm² even before packing gaps. The existing Ø4.4 mm bore has 15.21 mm², but area alone still does not prove packing, bendability or room for seal material. Selecting an allowed wire gauge does not determine its insulation OD. Do not claim the route passes until the exact insulation diameters, jacket/heat-shrink, joints, packing, strain relief and sealing allowance are included. No physical crimp, fit, continuity, pull, leakage or current test was performed.

`connector-source-receipt.json` records the manufacturer PDF bytes inspected locally and their hashes. The PDFs were rendered for checking the drawing datums; this memo links the originals rather than redistributing the manufacturer documents.
