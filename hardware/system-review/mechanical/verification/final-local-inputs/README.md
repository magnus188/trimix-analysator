# Frozen local PCB inputs — draft for CAD review

The nine owner handoff members passed SHA256 and byte-count checks. This isolated local refinement is board `0962ad86…82788`, STEP `81eef018…99014`; canonical final `9f274fdf…56514f` and the active placement-v2 manifest remain unchanged. `incoming-boards.json` is a draft and has not been installed. Its USB object is exactly the active manifest's object, with both source files verified unchanged.

`checkpoint.json` is the workspace-relative adapter accepted by the current `placement_height_coverage.audit()` API. It binds 57 source files, including the native schematic/project/rules/library tree and the nine handoff artifacts. The factory-stencil derivative is outside this one-board correspondence check.

Native KiCad 10.0.6 coverage passed all **169 footprints** and all **153 contract rows**, including pose, side, DNP, MPN and registration checks. The rows comprise **147 populated maximum/allocation envelopes and six DNP rows**. The other footprints are **14 testpads and two NPTH mounting holes**. All 153 rows also match the frozen XML's MPN, footprint and DNP state. Six additional XML components are explicitly excluded from the main board; they are classified in `xml-height-correspondence.json`.

Every populated envelope is required during native CAD review, including U110/L201/L701, whose STEP models are recorded absent by the owner. STEP label inspection is only an identity aid: it finds 143 root occurrence labels, 139 exact populated reference labels and four anonymous labels. Eight populated references lack exact root reference labels; this is not a claim that all eight solids are absent. No generic or missing visual model can replace a maximum envelope.

| New rear component | MPN | W85 world X / Y / Z envelope, mm |
|---|---|---|
| C103 | C1005X7R1H473K050BE | 64.425–65.575 / 39–39.6 / 19.75–20.5 |
| C107 | C2012X5R1A476M125AC | 63.175–65.375 / 40.15–41.6 / 18.9–20.5 |
| R504 | RT0603BRD0710KL | 67.8–69.5 / 71.55–72.45 / 19.8–20.5 |

These are separate manufacturer maximum/assembly envelopes, not measured STEP bounds. Carrier collisions and reliefs remain unverified. For width changes, use the rigid board datums `X=PcbX+PCB_x`, `Y=PcbY+PcbHeight−PCB_y`; the table is the W85 frame only. Preserve `PcbX=CaseWidth−PcbWidth−4.6`, `PcbWidth=30` and the main rigid joint/grounded descendants.

The source stack arithmetic remains dielectric sum **1.4638 mm**, copper sum **0.1004 mm**, copper-plus-dielectric **1.5642 mm**, and interior span including inner copper **1.4942 mm**. The source defines two 0.01 mm masks; including them gives **1.5842 mm**, distinct from the 1.6 mm nominal finished allocation. **No native STEP datum has been measured here.** The current placement expression `PcbZ+0.0529 mm` is recorded as the existing contract, with all new STEP datum fields pending parent measurement; no automatic scaling or datum correction is authorized by this draft.

The two delta files record native identity/pose and contract changes separately. Against frozen final9f, exactly **six rows** change: C103, C107, C702, L701, R504 and R702; no references are added/removed. Against placement-v2, C108 is added and D101/R106/SW101 are removed; 34 common rows change pose, nine change MPN, and 11 change height/Z. Six DNPs are unchanged: C503, C706, R602, R603, R604 and R804.

`prepare.py` runs only offline KiCad/source checks and writes beside itself. It refuses to overwrite an existing checkpoint. Native board save and Fusion calls are absent. During this run KiCad emitted wx/image-handler diagnostics, but returned zero errors and the before/after source hashes matched.

The standalone coverage call is:

```python
placement_height_coverage.audit(
    checkpoint_path=Path("hardware/system-review/mechanical/verification/final-local-inputs/checkpoint.json"),
    output_path=Path("hardware/system-review/mechanical/verification/final-local-inputs/height-coverage.json"))
```

Run with KiCad's bundled Python and `PYTHONDONTWRITEBYTECODE=1`; use a new output name if retaining the existing coverage receipt. Native STEP/datums, all dynamic populated envelopes, carrier clearances, service/driver/width checks and physical qualification remain separate work. This is not an order release.
