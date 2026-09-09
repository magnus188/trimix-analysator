# HOST trace adjustment for the UVLO escape

**Bounded intermediate proposal; no release.** Source `14284b78370caaffa001b68c1985423ae700f3e24f02e64b3e80fd50b43b93b1`; result `4d5ae900d79416b9d28f2f5469e0ec90e3f7b333ff37fc05002dc899e3f7d602`.

Replace only HOST_3V3 In2 segment7640755f-7eb3-4787-b80f-b44f25a93b49 with three .15mm segments through (11.95,91.6), (13.45,90.45), (19.15,87.2), (19.3,87.05). No new via, footprint, power-trunk, rule or zone-boundary change.

The scout reserves the future .50/.25 UVLO via at (13.6,91.0) and the owner's .60/.30 RAW_USB via at (13,91.65). These ghost circles in the image are not fitted copper in this proposal. The UVLO via still requires the coordinated R116 relocation and removal of its obsolete local spur; this patch alone does not complete UVLO.

Native KiCad preserves17 opens and29 dangling warnings, with zero geometry errors/parity mismatches. Three independent native conductor witnesses preserve the R115 HOST pull-up branch. In1 filled geometry is identical. In2 retains seven regions with identical plated anchors; two areas change from16.9202/23.5476mm² to17.5373/22.9458mm². No new split or floating ground is introduced. Final merged ground and power checks remain required.

Apply only `route-patch.kicad_sexpr` against the exact original segment, preserve other newer routes/poses, refill and repeat native checks. The charging raw bypass is unchanged.
