# Offline M3 candidate scaffold

`proposal.json` prepares **only a later transient assessment** of four CNC Kitchen VORON M3 × 5 × 4 inserts (EAN 4262391010051). It does not authorize adoption, change CAD/BOM, or claim a current native pass. `prepare.py` uses only Python's standard library and writes only this folder's proposal. Ten input hashes, manufacturer STL bounds and the eight expected parameter values passed its offline checks.

The source is `../../components/cnckitchen-m3-review/source-review.json`; the exact unscaled STEP is `M3x5x4_VORON_manufacturer.step`, SHA-256 `9a9e695a44e1136ed39daa1b194bfff6342266593b003778e6307485c29edc37`. The manufacturer poster, page 2, specifies length 4 mm, crest Ø5 mm, pilot Ø4.4 mm, minimum wall 1.6 mm **from the pilot**, and blind depth at least length + 1 mm. The project's 2 mm beyond the crest is a separate, stricter target. Published nominal geometry does not supply manufacturing tolerances or retention qualification.

| Axis at W85/H180 | Boss radius change | Pilot radius change | Original suffix |
|---|---|---|---|
| 8, 8 | d267: 4.2 → 4.5 mm | d274: 2.15 → 2.2 mm | none |
| 77, 8 | d317: 4.2 → 4.5 mm | d324: 2.15 → 2.2 mm | (1) |
| 8, 172 | d367: 4.2 → 4.5 mm | d374: 2.15 → 2.2 mm | (2) |
| 77, 172 | d417: 4.2 → 4.5 mm | d424: 2.15 → 2.2 mm | (3) |

All eight are sketch radius dimensions in `01 Shape A housing`, owned by `Rear M3 boss sketch` or `M3 insert pilot sketch` with the indicated suffix. Source implementation: `hardware/cad/rev04/scripts/build_a3.py`, `rear_fasteners()`, lines 194–210. The proposal records exact saved owners/expressions, protected parameters, four insert instance identities and joint names. Do not perform a global numeric replacement: the cover's 2.15 mm bearing thickness is unrelated.

The cached complete inventory is SystemReview v7/timeline1197. The later v8/timeline1199 inventory confirms the four pilot radii, axes and cut depths, but neither is a fresh checkpoint after ongoing M2 and PCB integration. Before any transient operation, the owner must bind the then-current version/timeline and verify the exact parameter owners, expressions, occurrences and poses. No live document guard is asserted here.

**Keep the four open faces and axes.** Positions remain `[8 or CaseWidth−8, 8 or CaseHeight−8, CaseDepth−4]`; at D43 their faces are Z39. Bosses/webs remain Z30…39. The Ø4.4 pilot starts Z34 and cuts through Z39.1, leaving an actual 5 mm full-diameter cavity below the face; the last 0.1 mm is top overshoot. Map the manufacturer's Z0…4 model to face-relative Z−4…0 with translation only, yielding nominal Z35…39. Keep the narrower R1.6 tip relief at Z33…35, all screw seats/axes, cover bearing surfaces, clearance holes, head recesses, exterior and purchased modules. Existing M3 × 8 screws have nominal tip Z33.35, 4 mm candidate axial overlap, and extend 1.65 mm below the new insert bottom. Neither these nominal extents nor a simplified CAD bore establishes usable mating thread or torque.

**A 7.4 mm web does not itself require widening when joined to a complete R4.5 cylinder.** The cylinder supplies a full nominal 2 mm radial annulus outside the Ø5 crest and 2.3 mm outside the Ø4.4 pilot. Web material is additional. Its sides X±3.7 meet the R4.5 circle at Y±2.56125; exposed web side points are at radius ≥4.5. The isolated-web calculation gives only 1.2 mm beyond the crest (1.5 mm beyond the pilot), but does not describe that union. This analytical conclusion assumes the final body retains the full cylinder through the insert depth and its join to the wall.

The old `selected-wall-fastener-checks.json` proves only one +X segment at Z37 on the first boss, using **R4.2 − pilot R2.15 = 2.05 mm**. It does not prove all four circumferences or clearance beyond the new crest: an old R4.2 boss gives only 1.7 mm beyond R2.5. A later actual BRep volume/section check must establish the complete intended annulus, web connection and retained floors after all cuts. Exactly 2 mm has no nominal tolerance margin.

Conditional web identities are included for review, **outside the eight-change set**: shift d257/d307/d357/d407 from axis−3.7 to axis−4.5 and widen d259/d309/d359/d409 from 7.4 to 9 mm only if native evidence requires it. First assess added-material interference and service clearance. In particular preserve d408=`CaseHeight−10.5 mm` and d410=`8.2 mm`: `service_refine_a3.upper_web_relief()` deliberately shortened the upper inlet-side web to clear closed-chamber withdrawal.

The proposal's pending checks cover all four actual host annuli, tip/bore clearance, rear-cover bearing/removal and driver access, inlet/gas/chamber paths, final routed PCB height envelopes, purchased geometry and rigid placement at W85/W87 with restoration. Only each exact insert/assigned-host pair may receive an intentional heat-set overlap classification; crest-to-pilot overlap is nominally 0.3 mm radial. It is not a general interference exception. Source files, CAD and owner documents were untouched.

Regenerate offline with `python3 -B hardware/system-review/mechanical/verification/m3-candidate/prepare.py` from the workspace root. Regeneration refreshes hashes of the saved evidence; it does not obtain new native evidence.
