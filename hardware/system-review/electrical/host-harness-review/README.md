# J301 host harness — component and interface review

**Result: prefer a matched Samtec HTSW header and IDSD cable, with pin 7 polarization. This remains a procurement, mechanical and electrical qualification candidate.** No native PCB, schematic, firmware or Fusion document was changed by this review. `contract.json` binds the read-only native snapshot; the main board was still being routed when captured.

Use **HTSW-113-07-L-D** with **IDSD-13-S-04.00-G** as the base configuration. The [exact HTSW product page](https://www.samtec.com/products/htsw-113-07-l-d) exists; Samtec also lists the exact 4-inch IDSD assembly among the related lengths on its [4.75-inch product page](https://www.samtec.com/products/idsd-13-s-04.75-g). These observations establish catalog identities, not stock, price or delivery availability. No purchase or supplier message was made.

## Why change the proposed Harwin part?

The original **M20-9981346** has tin contacts, whereas the IDSD default is gold. The IDSD `-G` suffix specifies **gray cable**; `-T` would specify tin. Harwin's [M20-9981345](https://www.harwin.com/products/M20-9981345) is an active gold alternative with the same basic geometry, but does not fix insertion tolerance. Harwin discusses mixed tin/gold contact concerns in its [plating guidance](https://cdn.harwin.com/pdfs/Pure_Tin_The_choice_for_connectors.pdf).

The [Harwin drawing](https://content.harwin.com/asset/1590d228-db5c-4836-ab0c-0f146730b624/DRG-00478-Technical-Drawing-Datasheet-M20-998-pdf.pdf), issue 24, gives a 6.10 mm post with the general ±0.25 mm tolerance: **5.85–6.35 mm**. The [IDSD catalog](https://suddendocs.samtec.com/catalog_english/idss.pdf) permits **5.588–6.223 mm** insertion. Fully seating the longest allowed Harwin pin exceeds that range by **0.127 mm**. Nominal fit is not a tolerance pass.

The [HTSW Rev BQ drawing](https://suddendocs.samtec.com/prints/htsw-xxx-xx-xxx-x-xx-xx-xx-mkt.pdf), Figure 1/Table 1, gives the `-07` post **5.842 ±0.2032 mm**, or **5.6388–6.0452 mm**, inside the socket's specified insertion interval. `-L` provides gold mating surfaces and matte-tin solder tails. The [combined TSW/HTSW catalog](https://suddendocs.samtec.com/catalog_english/tsw_th.pdf) identifies HTSW as suitable for lead-free processing; this is preferable to assuming that an ordinary TSW body is suitable for the intended assembly process. Final factory solder process still needs acceptance.

## Pin 7 polarization and assembly orientation

The source-derived preferred option is **HTSW-113-07-L-D-007** and **IDSD-13-S-04.00-G-P07**. HTSW's Option 2 specifies an omitted contact by position. [IDSX Rev AE, page 2, Figure 3](https://suddendocs.samtec.com/prints/idsx-xx-x-xx.xx-xxx-xxx-mkt.pdf) specifies a `-PXX` blocked cavity using **PK-06**. Pin 7 is electrically unused in this design and preserves the decision to leave host GPIO52 unused.

**The exact fully configured order codes are not confirmed as orderable.** The primary prints document the syntax and construction, but accessible exact-product pages/searches did not establish these complete combinations. Confirm them with Samtec before the final BOM. A standard IDSD assembly plus a separately supplied PK-06 inserted in cavity 7 follows the IDSD drawing's method and avoids requiring the cable to arrive pre-keyed. PK-06 supply and retention still need confirmation. A factory-omitted header is preferred: no located manufacturer instruction authorizes pulling or cutting a contact out of a standard HTSW header, so this review does not prescribe that procedure.

On a correctly aligned 2×13 grid, a 180° reversal maps blocked cavity 7 onto present pin 20 and prevents full seating. This does **not** prove protection against every shifted or partially engaged connection. Check alignment, strain relief and key retention; perform continuity/short checks before power. Without polarization, reversal can misroute 5 V, 3.3 V and control signals.

The source drawing's normal ribbon orientation exits toward the even row, from pin 1 toward pin 2. **The current routed 0962 board rotates J301 by 180°, so its standard ribbon exit is inward, −KiCad X / −Fusion X.** The [current native pose audit](../../integration-photo/current-host-pose.json) checks all 26 logical nets and retains pin 7 unused. The `native_pose` and XY coordinates in this folder's older `contract.json`/`pin-map.csv` describe the preserved earlier orientation, whose exit was +KiCad X; use them for the logical same-number net mapping, not current placement. Do not rotate the cable assembly 180° independently just to improve routing. A view into the socket mating face is mirrored relative to the PCB top view. Gray cable's marked edge identifies conductor 1, but verify the finished harness electrically.

`pin-map.csv` records all 26 native nets and the logical same-number mapping to Guition JP1. It does not certify the actual remote plug. Main-to-screen 5 V uses pins **2/4**; grounds **5/6/16**; screen-to-main 3.3 V uses **1/3/18**. Eighteen contacts are connected; pin 7 and the other seven NC positions are unused. Actual Guition JP1 pitch, exposed-post length, plating, orientation and suitable termination remain measured-part holds.

## Mechanical envelope for CAD

| Interface | Nominal | Published range or limitation |
|---|---:|---|
| IDSD length across 13 positions | 34.5186 mm | 34.3916–34.8996 mm |
| IDSD body height | 9.271 mm | 9.144–9.525 mm, Table 1 for 5–36 positions |
| IDSD width | 5.08 mm | Catalog nominal; guaranteed maximum not established |
| HTSW body length | 33.02 mm | 32.639–33.147 mm |
| HTSW stand above PCB | 2.54 mm | REF; guaranteed maximum not established |
| Mated top above PCB | 11.811 mm | 12.065 mm uses socket maximum plus **nominal** stand; not a full maximum |
| Assembled cable length | 101.6 mm | 98.425–104.775 mm; free wire is shorter |

Socket length/height and cable details derive from IDSX Rev AE; header values derive from HTSW Rev BQ. Socket assembly bow may reach 0.006 per unit length (about 0.209 mm over maximum body length); HTSW also permits 2° terminal sway. A reasonable starting **engineering allowance** is **35 ×5.5 ×12.5 mm**, long axis ×width ×height above PCB. This is not a manufacturer-guaranteed complete envelope. Check it against an actual assembly, including local wall/cable clearance.

Reserve at least **6.1 mm axial withdrawal travel** to clear the maximum exposed header post, then additional handling/slack space. This is geometric arithmetic, not a physical removal demonstration. The cable exits near the cap; Figure 1 section A–A places its lower surface approximately 2.362 mm below the cap top. Neither an allowable bend radius nor service-flex life was found. Do not invent a zero-radius fold or rely on catalog length as free cable length. Provide a removable cable clip/strain relief rather than pulling on the IDC termination.

The [HTSW footprint drawing](https://suddendocs.samtec.com/prints/htsw-xxx-xx-xxx-x-xx-xx-xx-footprint.pdf), Rev B, specifies the standard 2.54 ×2.54 mm grid and a 1.02 mm finished hole. The captured native header uses 1.00 mm drills and 1.70 mm pads. If this header is selected, its owner should adopt the manufacturer-recommended hole (subject to fabricator finished-hole tolerance), preserve sufficient annular ring and check solder-tail clearance. This review did not change it.

## Current and voltage drop: conditional calculations

The Samtec cable print specifies 28 AWG, 7/36 stranded tinned copper. Its nominal current annotation and the family qualification report do not guarantee the operating current of this exact 13-position, free-ended harness in a warm enclosure. The [Samtec qualification](https://suddendocs.samtec.com/testreports/112488_report_rev_1_qua.pdf) tested **IDSD-36-D-06.00-G with TST-136-01-G-D-01**, a different connector pair, contact count and length. Do not combine two advertised header-contact ratings into a device-current guarantee.

For a transparent reference only, [Belden 9L28026](https://catalog.belden.com/techdata/EN/9L28026_techdata.pdf) has the same 28 AWG 7×36 ribbon construction and **nominal** DCR 68.2 Ω/1000 ft. Belden recommends 1 A per conductor at 20°C. The Samtec cable drawing names alternate cable suppliers: the exact purchased assembly is not proven to use this Belden product, and neither a DCR maximum nor hot-enclosure derating for it is established here.

With identical branches and no other rail exchange, two supply wires and three return wires give `Rloop = Rwire ×(1/2 +1/3)`. At nominal 101.6 mm, wire-only drop is **37.9 mV at 2 A**. At maximum assembly length treated conservatively as conductive wire length and an explicitly assumed copper temperature coefficient of 0.00393/K, it becomes **49.1 mV at 85°C**. Adding a hypothetical 20 mΩ per termination at each of two ends produces approximately **115.7 mV**. These are scenarios, not worst-case guaranteed bounds. The 48 rows in `drop-scenarios.csv` expose all assumptions.

At 2 A, equal sharing means 1 A on each 5 V conductor. Just ±10% branch-resistance mismatch makes the more heavily loaded wire carry 1.1 A. An open supply conductor forces the remaining wire to carry the whole load. Consequently, the 2 A example is not a qualified operating limit, and the reference 1 A-at-20°C rating provides no margin for those cases.

Because 3.3 V travels back from the screen, the shared ground current is signed: with only these rail exchanges, `Ig = I5 −I3`. With external paths uncharacterized, use `|Ig| ≤|I5| +|I3|` as a conservative accounting bound. Host 3.3 V error includes both the three parallel supply conductors and the shared ground drop. Signal-ground shifts, startup capacitive current, external USB power and backfeed are outside this DC calculation.

## Remaining HOST_3V3 budget

The current netlist places both ADS122C04s, TUSB320LAI, PI3USB9201, the permission latch/supervisor, TXU0202 VCCA and the remote BME breakout on this rail. All external pullups held low plus the 10k/10k oxygen bias divider draw **3.682 mA nominal at 3.3 V**; this is a deliberately simultaneous resistor-load scenario, excluding unknown remote pullups and component dynamic currents.

[ADS122C04](https://www.ti.com/lit/ds/symlink/ads122c04.pdf) lists 360 µA typical for the oxygen analog configuration, 250 µA typical for helium bypass and 65 µA typical digital supply each with I²C inactive: 0.740 mA combined typical. The 510 µA analog maximum belongs to the gain1–16 PGA-enabled row; a separate bypass maximum is not supplied. [TUSB320LAI](https://www.ti.com/lit/ds/symlink/tusb320lai.pdf) lists 70 µA typical under a 4.5 V GPIO-mode test condition, without an active maximum for the actual 3.3 V I²C setup. [PI3USB9201](https://www.diodes.com/assets/Datasheets/PI3USB9201.pdf) page 4 lists 200 µA typical active supply current and no active maximum. Small logic/supervisor static currents add to these; switched loads and pullups vary with operation.

**A guaranteed maximum rail budget is not closed.** The actual remote BME module load and the Guition board's spare 3.3 V capacity are unmeasured. Its regulator part rating alone is not available JP1 current after display/ESP/Wi-Fi loads, heating and routing. Measure minimum HOST_3V3 at the analyzer under startup, full backlight/radio and sensor operation, as well as actual 5 V/3.3 V and individual harness-branch currents.

## Acceptance checklist and reproduction

- Confirm factory-omitted header part and cable/PK-06 availability, including the exact blocked position.
- Measure real JP1, completed socket width/seating height, cable exit, wall clearance and rearward removal/slack; check wrong/shifted insertion before power.
- Confirm finished-hole tolerance, lead-free process and tail clearance; verify solder joints and key/strain-relief retention.
- Continuity-test all used pin-to-pin paths, unused insulation and absence of 5 V/3.3 V shorts; record polarity photographs.
- Measure cold/hot startup and worst operating branch currents, voltage drops and temperatures; establish a documented current limit including imbalance and open-contact behavior.
- Verify HOST_3V3 supply margin, external-power sequencing/backfeed and bus operation on the actual cable; do not infer these from arithmetic.

Run `calculate_contract.py` with the KiCad MCP venv Python. It reads the native board/netlist, checks the power/NC mapping, writes the full pin map, evaluates insertion intervals and generates 48 conditional DC scenarios. It never saves native design files. `manifest.json` hashes the evidence. Source PDFs remain manufacturer reference documents with their original attribution; this review does not alter project licensing. Belden's PDF was readable through web retrieval, but direct download returned HTML; it is linked rather than falsely represented as a saved PDF.
