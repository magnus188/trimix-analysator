# RX-M2x4 candidate — native interface review

**Candidate not adopted. SystemReview v8 remains saved and unchanged.** All ten exact manufacturer insert solids clear unrelated installed parts at the existing insertion faces. That does not qualify the pilots: every current blind hole is shorter than the manufacturer's 5 mm guidance, and the sampled surrounding material falls below the project's stricter 2 mm beyond the 3.6 mm crest.

| Interface | Qty | Face Z | Current pilot Ø / depth | Actual floor beneath full Ø3.2 probe | Nominal material beyond Ø3.6 crest |
|---|---:|---:|---:|---:|---:|
| Main PCB posts | 2 | 18.5 | 3.3 / 4.1 | 0.10 | 1.80 |
| Lower display retainer | 1 | 18.5 | 3.3 / 4.1 | 0.10 | 1.90 |
| Upper display retainer | 1 | 18.5 | 3.3 / 4.1 | ≥5.0, search limit | 1.90 |
| USB cartridge | 2 | 31.2 | 3.3 / 4.25 | ≥5.0, search limit | 1.85 |
| Chamber lid | 4 | 36.0 | 3.2 / 4.0 | Three 2.0; first at (18,159): 3.0 | 1.80 |

Dimensions are millimetres. Floor results use cumulative whole-cylinder Boolean coverage with 0.001 mm resolution; actual intervals are in [the floor receipt](ruthex-m2-existing-floors.json). Radial sampling used 72 angles at five axial depths and is not a global wall proof. The manufacturer measures its 1.3 mm minimum wall from the **pilot**, whereas the project 2 mm-beyond-crest criterion requires a 7.6 mm support diameter or span.

## Tested RX correction proposal

A 7.6 mm boss with Ø3.2 × 5 mm blind pilot and 2 mm nominal floor was tested using temporary BRep additions. Seven positions were statically clear: both USB, all four chamber and the upper display retainer. The twoPCB supports and lower display retainer enter the retained factory screen frame; intersection volumes were 34.594,0.848 and10.534 mm³. At the lowerPCB post, even the required 5 mm pilot void enters that frame by 3.469 mm³. Changing the screen, scaling purchased parts or silently accepting a thinner floor is not proposed.

The [guarded proposal manifest](ruthex-m2-proposal.json) identifies exact parameter names, existing expressions, native feature owners and source hashes for the seven possible local changes. It is a review artifact, not an instruction to apply a partial insert substitution. USB/chamber service, gas continuity, width, material and tool checks would still be required after any authorized native implementation.

A shorter insert with explicit manufacturer through-hole guidance is now a separate candidate. An intentional through-pilot may be appropriate for only the three thin-floor **non-gas** posts. Chamber holes must stay blind and sealed. The shorter candidate does not inherit the RX thread-engagement result.

## Physical interface semantics

The unmodified manufacturer STEP has one 256-face solid, nominal 4 mm length and approximately 3.6 mm crest span. Its placement requires translation only: open face Z0, body extends toZ−4. Native reported volumes are 20.93595 mm³ (`body.volume`),20.93349 atHigh and20.93138 atVeryHigh; no manufacturing tolerance is inferred from those numerical differences. The first inventory's temporary-body High-property call returned 0 and is unusable; the subsequent [evaluation](ruthex-m2-interface-evaluation.json) records the actual positive native values explicitly.

The exact purchased insert intersects its identified printed host by about 0.620 mm³ for current Ø3.3 pilots or 1.149 mm³ for Ø3.2 pilots. This is intended heat-set material displacement, whose real process remains unqualified. Its modeled internal threads also intersect the existing simplified, unthreaded M2 screw shafts by approximately 1.05–1.19 mm³. Both relationships must be explicit per-occurrence engaged interfaces, not a blanket clash waiver. Unrelated-part collision checks remain mandatory.

Keep separate printed-pilot and installed-cavity semantics. If an installed visualization subtracts the actual insert cavity, that post-install shape must never replace the source print's manufacturer pilot geometry. No retention, torque, creep, seal or printing qualification follows from CAD overlap classification.

## Evidence and preservation

- [Native axes, pilots, features and exact candidate](ruthex-m2-native-inventory.json)
- [Candidate and proposed-support intersections](ruthex-m2-interface-evaluation.json)
- [Actual existing floors](ruthex-m2-existing-floors.json)
- [Manufacturer source receipt](../components/ruthex-review/source-review.json)

All temporary STEP documents were closed without saving. SystemReview v8 stayed at 1199 timeline items and its bodies, parameters and modified state were preserved. All three FlowGrid documents, including unsaved R3.1, retained their original states. No native geometry, BOM, print or purchased part was changed.
