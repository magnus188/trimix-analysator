# Samtec HTSW keyed header reference

`Samtec_HTSW_113_07_L_D_007_Drawing_Reconstruction.step` is a **nominal drawing-derived model**, not manufacturer-authored CAD. It represents the proposed factory-omitted contact 7 variant of HTSW-113-07-L-D. Exact configured-part orderability remains a purchasing gate; this model does not approve manually removing a contact.

Use **scale 1**, **offset (0, 0, 0)** and **model rotation (0°, 0°, 0°)** in the KiCad footprint. Footprint rotation then moves the whole model and its numbered contacts together.

| Datum or dimension | Model definition, mm |
|---|---|
| Pin 1 centre | X0, Y0 |
| Even row | X2.54 |
| Successive contact pairs | Y decreases by 2.54 |
| PCB seating face | Z0 |
| Insulator bounds | X−1.2446…3.7846; Y−31.75…1.27; Z0…2.54 |
| Square contacts | 0.64 × 0.64 |
| Contact bounds along Z | −2.54…8.382 |
| Omitted contact | 7, at X0/Y−7.62 |
| Solid count | 26: one insulator and 25 contacts |

The body, tail and stand-off include nominal/reference dimensions. Mold details, tip chamfers, plating thickness and complete dimensional tolerances are omitted. Contact-shaped openings in the insulator prevent overlapping internal solids; they are visual interfaces rather than manufacturing tooling geometry. The actual socket, cable, key and cable bend are separate interfaces.

A unit-aware Fusion STEP reimport preserves all 26 solids, total bounds and total volume to numerical precision. The [verification receipt](../verification/htsw-keyed-model.json) records all numbered contact centres, source hashes and preservation of the original Fusion documents. The STEP SHA-256 is `708f3b6e37f9967bfc62d485ede709656be0cf84bfa94b4b9ee2bf02c35c88cc`.

The source is the locally archived Samtec HTSW series drawing, SHA-256 `1b67562fde61dc2488bd76240e48c70399c0cffd9a1a62866d89535f186e49b4`, with the [host harness contract](../../electrical/host-harness-review/contract.json) retaining the nominal/max/reference distinctions and proposed mating cable. The CAD authoring script is [htsw_header_model.py](../scripts/htsw_header_model.py).
