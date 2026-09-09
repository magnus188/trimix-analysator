# Frozen C105–SYS candidate

`complete-candidate/Trimix_Analyzer.kicad_pcb` is the complete, isolated routing proposal on the synchronized R101/Q110 source. The proposal closes the C105 bulk-capacitor SYS island through an actual copper connection to the main SYS network. Its source and resulting hashes are recorded in `candidate-delta.json`.

| Check | Frozen result |
|---|---|
| Patch | 11 removals, 29 additions; no footprint changes |
| Native geometry errors introduced | 0 |
| Unconnected items | 7 → 6 |
| Warnings | Same 33 signatures |
| Schematic parity | Same two expected R101 package/MPN differences |
| New SYS route | Eleven 0.40 mm In2 tracks, 16.023863 mm total; no new power vias |
| New vias | Four 0.50/0.25 mm signal vias; all SMT/PTH exclusions pass |
| Native SYS contact graph | Original 89- and 40-object islands become one 140-object component |
| In1 | One physical region, all 105 ground anchors retained |
| In2 | Ten → eleven physical regions, all 21 anchors retained; every region anchored to In1 |
| In2 ground area | −18.228107307 mm², approximately 21% |

Read `ground-review/README.md` with the actual plane and F/B power overlays. `power-review/review.json` records conductor/barrel sensitivity assumptions and native connected-path witnesses. Those reports do not qualify current capacity, temperature rise, EMC, global minimum plane widths, or fabrication.

`verify_complete.py` verifies the immutable source/patch/native-report conservation. The raw reports retain the two expected package/MPN parity findings. A later authoritative source adoption must resolve those findings and rerun the complete checks.

The later C116 0402 candidate is a separate integration dependency. Its guarded overlay conflicts with the CHG via at (15.95,88.35); see `c116-chg-relocation/README.md`. That folder's hypothetical replacement crosses HOST_3V3 and is not an adoptable patch. The de594 frozen board has not been edited to hide this conflict.

Historical `complete-unpruned.kicad_pcb` retains the initial unused CHG leaf; `leaf-pruning-witness.json` records its removal without losing any required native connection. `complete-stage.json` describes that historical unpruned stage, not the final board hash.
