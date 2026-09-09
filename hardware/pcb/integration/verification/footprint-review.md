# PCB footprint review

This is an audit of the original analyzer schematic, its **119-position unrouted preview**, and the separate USB-input schematic. It is not approval of the new PCB-A3 placement, routing, or manufacture. The machine-readable evidence and source hashes are in [footprint-review.json](footprint-review.json).

**No pin-number swaps were found in the three requested ICs.** All 353 unique main-board reference/pin net assignments match a fresh KiCad CLI export. There are 368 numbered physical pad records because some pins have multiple copper/thermal-pad instances. That check verifies connectivity labels, not routing or package qualification.

**Subsequent correction:** U201 now uses the verified project-local TI DSJ land/stencil example, with unchanged pin nets and zero ERC violations. See [the correction receipt](u201-ti-dsj-footprint.md). The original-source findings below remain historical; the separate USB and test-pad implementation records describe their newer state.

## Findings that affect the next PCB

| Part | Result | Required action |
|---|---|---|
| U101 BQ25895RTWR | TI RTW WQFN24, 4 x 4 mm, 0.5 mm pitch, 2.7 x 2.7 mm exposed pad: consistent. Pins 1-24 and KiCad EP25 match the symbol. | Retain the grounded EP and thermal path. The footprint contains nine 0.2 mm drills with 0.5 mm lands; confirm the fabricator and assembly process support them. |
| U201 TPS63020DSJR | Original generic DE footprint was unqualified. **Resolved:** `Trimix_Power:TI_DSJ_14` transcribes TI drawing 4210895-2/E, including shaped copper, four paste apertures and fifteen thermal vias. | Native footprint fidelity and unchanged pin nets passed. Fabricator/assembler acceptance of annuli, via treatment and stencil process remains required; see [details](u201-ti-dsj-footprint.md). |
| U301 MAX17048G+ | T822+3 TDFN8, 2 x 2 mm, 0.5 mm pitch, EP core 0.8 x 1.2 mm: consistent. Pins 7=SCL and 8=SDA are correct. EP9 is a KiCad convention and is grounded. | Copper does not need changing on the evidence reviewed. Its substitute 3D body is approximate and must not establish fit. |
| J901 GCT USB4720-03-A | Existing land order and deliberately shared VBUS/GND lands agree with Rev B. | Complete the actual mid-mount Edge.Cuts and reconcile its panel/PCB datums. Keep it on a **0.60 +/-0.10 mm daughterboard**. |

Primary sources: [TI BQ25895 datasheet, pin table and RTW drawings](https://www.ti.com/lit/ds/symlink/bq25895.pdf), [TI TPS63020 datasheet, DSJ drawings 4208212-3/C and 4208549-3/G](https://www.ti.com/lit/ds/symlink/tps63020.pdf), [ADI MAX17048 datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/MAX17048-MAX17049.pdf), [ADI TDFN outline 21-0168](https://www.analog.com/media/en/package-pcb-resources/package/pkg_pdf/tdfn/21-0168.pdf), and [GCT USB4720 drawing Rev B](https://gct.co/files/drawings/usb4720.pdf). Package-metal dimensions are not automatically the correct copper or stencil dimensions; a smaller thermal-pad rectangle alone would not constitute a qualified footprint correction.

## Board membership

The schematic has 125 physical references. Six are intentionally excluded from the original main PCB:

| References | Physical location |
|---|---|
| U601 | Purchased wired GYBMEP/BME280 module in the gas chamber |
| U704 | Purchased wired ZE07-CO module |
| J901, R901, R902, J902 | Separate USB-input daughterboard |

AO2 and MD62 sensor bodies are also offboard; J401 and J501 are the main-board harness connections. The original main PCB has 115 fitted positions and four DNP options: **R602, R603, R604, R804**. These are real optional footprints, not missing imported parts. J104 remains an open charge-arm header without a fitted shunt.

## Ten explicit preview substitutions

These parts originally had **blank footprint fields in the authoritative schematic**. The ten current board choices have now been assigned to the corresponding schematic instances, each with `Package_Status = PROVISIONAL: verify exact purchased part before fabrication`. This makes the mapping explicit for PCB updates; it does not qualify the MPNs. [Metadata-only verification](provisional-footprints-verification.json) confirms unchanged nets and zero ERC violations.

| Reference | Preview footprint | What remains unresolved |
|---|---|---|
| D101 | LED_0805_2012Metric | Actual LED part, polarity and visibility |
| J101 | SolderWire-0.25sqmm, 2 pads, 4.2 mm pitch | USB pigtail gauge, retention and routing |
| J102 | Same solder-wire lands | PCB end of the protected-holder RCY/BEC pigtail; retain its disconnect |
| J103 | 1x02, 2.54 mm vertical header | Actual NTC connector, cable and mounting |
| L101 | L_Wuerth_HCM-7050 | Exact 1 uH inductor MPN and electrical/thermal ratings |
| SW101 | SW_PUSH_6mm | Exact wake/reset pushbutton and access |
| J301 | 2x13, 2.54 mm vertical header | Actual Guition JP1 pitch, mating geometry and cable pinout |
| J402 | SMB_Jack_Vertical | Actual SMB MPN and mating gender; current scaled SMA model is not the real part |
| J801 | 1x02, 2.54 mm vertical header | Momentary button harness connector and retention |
| J802 | Same 1x02 header | Button LED connector, polarity and actual LED rating |

Other assigned footprints also need actual-part checks: J401/J501 are generic 2.54 mm headers; J601/J701 specify main-board JST-XH 2.50 mm headers but do not establish sensor-end pin compatibility. L701 has no complete inductor MPN. L201 names XFL4020-152ME but shows an approximate XAL4020 model. RV501 needs a complete 500-ohm trimmer order code and adjustment access. Capacitor voltage, DC-bias capacitance and height depend on the selected MPNs.

## USB contact and enclosure datums

The origin is midway between the two round ground-tag holes, with positive footprint Y towards the insertion face. Rev B gives these derived coordinates:

| Feature | Footprint Y, mm | Fusion Y if the face is at Y=1, mm |
|---|---:|---:|
| Ground-tag centres | 0 | 7.86 |
| SMT pad-row centre | 0.05 | 7.81 |
| Cutout rear | 0.55 | 7.31 |
| PCB front edge | 5.58 | 2.28 |
| Connector face | 6.86 | 1.00 |

The mapping is `FusionY = 7.86 - footprintY`. The existing simplified CAD cutout/connector/pigtail provision is **not validated** against these exact datums. The footprint still calls itself Rev A; its verified lands agree with Rev B, but the R0.25 reliefs and front blend need a complete fabrication outline. [GCT Rev B, sheet 1](https://gct.co/files/drawings/usb4720.pdf)

J901 A5 goes through R901 to GND; B5 goes through separate R902 to GND. Both are 5.1 kohm, 1%. All four VBUS contacts join USB_5V; GND contacts and shell join GND. The daughterboard output J902 has pin 1=USB_5V, pin 2=GND, matching main J101. D+/D-/SBU contacts are deliberately unused. These net assignments agree between the two schematic projects. They do not implement USB PD or validate cable/current behaviour.

## Test access and release gates

The audited original schematic/preview has **zero dedicated test-point footprints**. Twelve test pads were subsequently added under explicit authorization; [testpoints-verification.json](testpoints-verification.json) records unchanged original pin nets, exactly twelve new nodes and zero ERC violations. This original-source finding must not be interpreted as the later board status.

Before fabrication, resolve the provisional components and U201 fabrication-process acceptance; verify the completed USB mechanical reconciliation against its newer records; route power loops and decoupling with thermal/analog review; provide accessible test pads and mounting/cable keepouts; run final board/schematic consistency and DRC. The original preview has zero tracks and zero zones. Four copper layers or a collision-free 3D view alone do not close these gates.

The other seven main-board ICs were inventoried but their entire datasheet pin maps were not newly audited here. Source files and the original PCB were not changed during this review. Later test-pad, U201 footprint and provisional-footprint metadata implementations have separate backup and verification records.
