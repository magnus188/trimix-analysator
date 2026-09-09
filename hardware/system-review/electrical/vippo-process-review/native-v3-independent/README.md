# Independent CC escape CAM and rule verification

**25 scoped checks pass on native-v3 SHA `d490110c6335a6594a8d2171386926c65a95e0f8ba729feb378c478e8a676a63`.** The final four-panel image `actual-cam.png` was rendered from actual Gerber bytes and visually inspected. The owner project was copied before testing; no authoritative or owner source was changed.

The 0.40/0.20 mm via at (13.6,89.775) appears once with the correct CC net and geometry on all four copper layers and once as a 0.20 mm PTH drill. The B soldermask/paste retains the original U115.3 land aperture; its copper extension remains masked. F mask/paste contains no opening at that via. Native filling/capping and both-face tenting are explicitly recorded. These data express fabrication intent; Gerber/Excellon alone do not certify the factory process.

Native negative controls prove the precise permission:

- Removing only the local clearance rule produces three errors against the two compound U115.4 lands and U115.2. Other rules remain byte-for-byte identical.
- Enlarging the via land to 0.50 mm violates the exact size and local/ordinary clearance checks.
- Moving the via by 0.01 mm removes its coordinate-scoped permission and fails ordinary diameter/clearance checks.
- Opening the entire via on both faces preserves copper and paste but creates the prohibited F opening and B exposed extension. The independent CAM check detects both.

An initial attempt to create the first control used a generic S-expression serializer that misread hash comments, invalidating the other rules. Its report is explicitly rejected and retained as `no-local-clearance-rule/rejected-comment-serialization-*`. The corrected control removes exactly one original text span. It is the corrected report that supports the result.

The baseline has **three unconnected items, zero schematic parity discrepancies**, four distinct inherited C116/CHG geometry findings, including the soldermask bridge, plus remaining silk/dangling/text findings. The independent `--all-track-errors` report repeats the identical hole-clearance UUID pair once, so it contains five raw geometry rows for those four distinct findings. None involves the exact new CC via. Those remaining issues are outside this scoped acceptance and still prevent routing release.

Re-run the saved native commands in `native-run.json`, then use `../check_native_v3_cam.py` and `../render_native_v3_cam.py` with the documented Gerbonara environment. `independent-cam-and-controls.json` records the actual inputs, all 25 checks and inherited findings. Actual filled-plane return topology, final combined routing, selected-hole resin fill/copper cap, RPW planarity/voiding/stencil, factory quote and physical tests remain separate requirements.
