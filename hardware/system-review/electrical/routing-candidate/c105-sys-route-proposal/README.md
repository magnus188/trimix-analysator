# C105–SYS isolated routing proposal

The complete **0.40 mm SYS connection is routed and native-checked in the frozen `synchronized-r101` candidate**. It is an isolated proposal; the authoritative PCB is owned by the coordinating PCB task.

- Source: `synchronized-r101/before.kicad_pcb`, SHA-256 `f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432`.
- Candidate: `synchronized-r101/complete-candidate/Trimix_Analyzer.kicad_pcb`, SHA-256 `de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db`.
- Exact guarded patch: `synchronized-r101/candidate-delta.json` and `route-patch.kicad_sexpr`: 11 removed, 29 added, no changed footprint or retained copper item.
- Native DRC: seven → six unconnected items, the same 33 existing warnings, no new geometric errors, and the same two expected R101 package/MPN parity differences retained in the raw reports.

The proposal replaces scoped CE, SET and CHG signal paths to make room for eleven 0.40 mm In2 SYS segments. It adds four ordinary 0.50/0.25 mm **signal** vias and no power vias. All new vias pass the native all-SMT/PTH-land exclusion check, including same-net lands. In1 carries no signal tracks.

The saved-fill review in `synchronized-r101/ground-review/` preserves all 105 In1 and 21 In2 ground anchors. In1 remains one physical region. In2 changes from ten to eleven regions; every final region is anchored to In1. Its ground coverage decreases by **18.228107307 mm², approximately 21%**. Selected local ligaments and actual F/B power and return overlays were measured and visually inspected. This is a meaningful plane change, not a no-change result.

`power-review/review.json` within that directory records source-bound conductor and barrel sensitivities. The new route alone is 16.023863 mm long; its nominal 20 °C item-length resistance sum is 45.439721 mΩ using the actual 15.2 µm inner copper. Complete native path witnesses include existing copper and barrels. These are diagnostic sums with explicit assumptions, not equivalent resistance, ampacity or thermal qualification.

**Newer C116 integration is not yet clean.** The owner's later 0402 C116 candidate conflicts with the de594 CHG via at (15.95,88.35). `synchronized-r101/c116-chg-relocation/` contains a frozen, explicitly blocked replacement corridor and exact C116 delta. A shared HOST_3V3 bridge is being coordinated before a combined candidate can pass native checks. This does not change the frozen de594 result, whose source still contains the earlier C116 pose.

Older top-level source `609a6241…`, CE-only candidate `3ba04d…`, and failed or hypothetical scouts remain historical evidence. Their status must not be substituted for the synchronized source-bound result. No manufacturing release, current rating, complete-device fit or finished-board routing claim is made. Fusion was not used during this routing task.
