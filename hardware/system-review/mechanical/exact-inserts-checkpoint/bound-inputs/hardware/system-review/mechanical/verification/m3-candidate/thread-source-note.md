# M3 nominal thread source note

**M3 × 0.5 is the nominal ISO coarse-thread designation.** Bossard's ISO 262 selection table explicitly pairs M3 with pitch P=0.5 mm (PDF page 2, catalogue page F.089, revision F-en-2024.12). This establishes the nominal pitch convention; it does not certify the particular insert or screw. [Bossard metric ISO threads](https://www.bossard.com/global-en/-/media/bossard-group/website/documents/technical-resources/en/f-079-en.pdf#page=2).

The same page gives these ISO 965 reference ranges in millimetres:

| Reference class | Major diameter | Pitch diameter | Minor diameter |
|---|---:|---:|---:|
| External M3, 6g | 2.874–2.980 | 2.580–2.655 | — |
| Internal M3, 6H | — | 2.675–2.775 | 2.459–2.599 |

These are **reference classes, not declared product tolerances**. The manufacturer page identifies the CNC Kitchen VORON M3×5×4 insert, EAN **4262391010051**, as M3 and 4 mm long. Its reviewed drawing gives exterior crest Ø5 mm. Neither that identification nor the nominal table establishes the purchased thread class or usable thread length. [Manufacturer product](https://cnckitchen.store/products/made-for-voron-gewindeeinsatz-threaded-insert-m3x5x4-100-stk-pcs).

The retained STEP is unchanged: SHA-256 `9a9e695a44e1136ed39daa1b194bfff6342266593b003778e6307485c29edc37`. Text inspection confirms eight cylindrical-surface entities at R1.2645 and nine at R1.543; examples #1666/#1673 are coaxial with Z. These correspond to Ø2.529 and Ø3.086, consistent with the native audit's reported minor/root surfaces. STEP entity #5540 establishes millimetres. Its 0.01 mm connectivity-accuracy metadata is **not** manufacturing tolerance. This offline inspection did not measure helix pitch, handedness or thread flank accuracy.

The four existing screws remain **GEN-M3-BHCS-L8-AF2**, not a purchased MPN. `hardware_a3.py:23–25,128–155` deliberately creates an **unthreaded Ø2.9 × 8 mm shaft** (R1.45), a Ø5.7 × 1.65 mm button head and AF2 recess. The smooth shaft occupies material between the insert's reported minor and root radii: `1.2645 < 1.45 < 1.543`. Consequently, its positive CAD overlap with modeled internal crests is compatible with a representation mismatch; this inequality proves neither physical fit nor misfit. The four world-space screw/insert overlaps span approximately **2.8648–2.8859 mm³**. Independent recomputations give slightly different volumes; those differences do not determine classification. The parent's separate whole-intersection confinement proof is the geometric criterion. No interference waiver, scaling or source repair is made here.

Actual screw manufacturer/MPN, pitch and tolerance class, insert thread class, coating, usable engagement, gauged mating fit and installation/retention remain unqualified. The parent owns the separate native intersection-confinement and service proofs.

Retrieval limitation: the supplied Bossard URL and a direct download returned HTTP 404. The browser provided indexed primary PDF text through the official `/global-en/` and `/us-en/` URLs; page screenshot retrieval failed. No downloaded-PDF hash or visual-page verification is claimed. Local source hashes and exact evidence identifiers are in `thread-source-note.json`. No Fusion calls or existing source/receipt changes were made.
