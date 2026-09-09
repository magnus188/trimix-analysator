# CHG_CE_N isolated detour

**The isolated CE-only detour passes native DRC with no new violations or unconnected items.** Final board: `candidate/Trimix_Analyzer.kicad_pcb`, SHA-256 `3ba04d481d49b39d87a800c941448d665bcbd465af761bb2b0d617c23429b469`. `candidate-delta.json` records exact removed/added UUIDs and source conservation; `receipt.json` binds the final saved board, fixed project files, and raw `candidate/drc.json`.

The adopted isolated topology is:

- B.Cu 0.15 mm: existing CE via (3.2403,91.5022)→new ordinary 0.50/0.25 mm via (6.4,88.35).
- In2.Cu 0.15 mm: (6.4,88.35)→(7.8,87.05)→first retained upper CE conductor endpoint (10.825,85.825).
- Remove the replaced track `d8e337d6-f633-48d8-8b77-3ad15ac9c500` and its now-unused lower In2 tail: `a28d2371-2f47-4bd8-b54f-07827780d7b9`, `445c723b-4c7d-49c8-b015-1b8fba0a79cd`, `63692ad1-fe67-4a80-bdeb-3633828b4083`, `445daa4f-037a-483f-860c-8b7949426704`.

The detour is 9.637313 mm long, with three new tracks and one new via. It preserves the existing R104 F connection and connects all 25 remaining/new CE objects in the native zero-tolerance graph. New copper contacts retained CE only at existing via `228a514a-28cf-4e4b-a43d-b0ea803668ce` and upper track `5387b2f8-e362-4b9a-9ea2-6dd458898e2a`, so the detour terminates at the first retained copper rather than following the old upper island. `verified-detour.json` records uncached native shape checks and this pruning witness. The via's minimum copper clearance is 0.201154 mm, limited by the existing F.Cu VSYS tracks; its distance to the nearest SMT land is 0.813014 mm.

Native KiCad 10.0.6 refill/save and full DRC with parity report the **same complete violation signatures** as the baseline: 16 track dangling, 7 via dangling, 7 silk overlap, 4 silk-over-copper warnings; 9 unconnected items and 0 parity items. Errors, warnings, exclusions, and the original ignored-check list were captured. No hypothetical SYS ghost tracks exist in the isolated board. The hypothetical SYS corridor was reserved as a hard In2 obstacle during route search and uncached checks; combining actual SYS copper still needs the owner's combined DRC and ground review. This is not a board release.

Frozen read-only input: `../before.kicad_pcb`, SHA-256 `609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1`. All source project/library files retain their captured hashes. All footprint/pad poses and nets, and every retained track signature, are unchanged. The only board written is the subsequently authorized isolated candidate within this scout directory.

The initial short local bridge search below failed. The subsequent all-island topology pass in `topology_search.py` removed only d8 in memory, identified disjoint lower/upper physical CE islands of 8/17 objects, and searched X0.8–21/Y78–94.4 at 0.05 mm to find the verified detour above. Its full evidence is `topology-result.json`.

The only target barrier is In2 track `d8e337d6-f633-48d8-8b77-3ad15ac9c500`, `/01  CHARGING + BATTERY/CHG_CE_N`, (8.75,88.425)→(10.825,85.825). The owner's hypothetical 0.40 mm VSYS corridor was additionally reserved, including (8.0,87.525)→(10.525,88.2). The reservation is captured verbatim in `bounded-sites.json`; it is not proposed as adopted copper.

## Initial local lower gateway (not used)

`lower-gateway-witness.json` verifies a **0.50/0.25 mm via at (9.4,88.7625)** and a **0.15 mm In2 binding segment (8.75,88.425)→(9.4,88.7625)**. Both pass native continuous shape checks including the reserved power route.

- Minimum via-centre to foreign copper distance: 0.4879546–0.4879551 mm, limited by R122.1 B.Cu pad `1df64c1c-34ee-4df2-ad2a-342583083ad0`, net `USB_OVP_UPPER`. With a 0.25 mm via radius this is at least 0.2379546 mm copper clearance.
- The minimum distance to every SMT land is the same 0.4879546 mm, exceeding the requested via radius plus 0.05 mm margin.
- Binding-segment centreline to foreign In2 copper distance: 0.4603457–0.4603462 mm, limited by `USB_OVP_5V` track `a4c16664-214b-4919-9c33-811d541f5ffc`; subtract the 0.075 mm CE track radius for copper clearance.

This gateway alone does not cross the barrier. Do not remove the original CE segment or adopt this via without a complete replacement connection.

## Search evidence and blockers

`initial-sites.json` has all 201 original-segment samples and their exact blocker UUIDs. No sampled point along the original segment accepts an ordinary via. Representative binding obstacles include:

| Location on original segment | Foreign objects |
|---|---|
| Lower endpoint (8.75,88.425) | B.Cu USB_OVP_5V tracks `2d0b3462-c930-4bd7-9c2d-116800b00d7b`, `6b144845-f42c-4dc1-963c-d473a437c975` |
| Middle (9.3725,87.645) | C105.1 F.Cu VSYS pad `f0e3aa36-c2e5-49ed-affe-b7dc624fceab`; R122.1 B.Cu USB_OVP_UPPER pad `1df64c1c-34ee-4df2-ad2a-342583083ad0`; USB_OVP_UPPER tracks `92cfb7b7-e9d0-46e0-9a48-a79000d3a5ab`, `9716c018-d59c-4ca1-a07c-69d1549177ed` |
| Upper-middle (10.2025,86.605) | F.Cu BQ_REGN tracks `a1204210-6f2e-4a49-a853-ac71b521173a`, `f0b1a438-91c5-4746-a3bd-419c9f62c606`; B.Cu PACK_TS track `0b9db014-9eb3-40e0-aea2-002f10df9471` |
| Upper endpoint (10.825,85.825) | GND via `04a691e1-3978-4e3c-8aa1-481fb76918c4`; U101.6 F.Cu I2C_SDA pad `63ebb62c-ea26-4749-8643-c85664c750fa`; B.Cu PACK_TS conductors listed in the JSON |

`bounded-sites.json` samples X6.5–12.5/Y83.5–90.25 at 0.05 mm with the power corridor reserved. Its 19 legal via sites all lie in the lower pocket X9.05–9.50/Y88.65–88.80 and accept a direct In2 binding from (8.75,88.425). None can bind to the upper endpoint; no other ordinary via site was found anywhere in that sampled box.

`existing-via-bridge.json` searches a 0.15 mm single-layer route from any of those 19 sites to retained CE via `8ded3cc9-54c0-41ba-998d-242419a60348` at (12.75,86.65), without changing its existing size/pose. With search bounds X8.5–13.1/Y85.5–90.25 and 0.05 mm grid:

- F.Cu reaches 502 nodes, limited to X8.5–10.3/Y87.9–89.15; no route.
- B.Cu reaches 640 nodes, limited to X8.5–10.5/Y88.0–90.25; no route.

The direct outer segment is also checked in `lower-gateway-witness.json`. F is blocked by R102.2 GND, BQ_REGN conductors, and CHG_INT_N; B is blocked by R122 lands, PACK_TS, CHG_INT_N, and USB_OVP_SET. Full UUID lists are retained.

## Method limits

Ordinary via tests use 0.4501 mm centre-to-foreign-copper collision clearance on all four copper layers, 0.3001 mm against all SMT lands, 0.7501 mm against edges, and 0.2501 mm against via-prohibiting board/footprint rule areas. Track tests use native continuous `SEG` collisions at 0.2751 mm to foreign copper, 0.5751 mm to edges, and 0.0751 mm to track-prohibiting rule areas. No In1 signal routing is attempted. Native saved GND fill is not treated as an immutable obstacle to the normal via antipad; adopting any new via would still require owner refill, DRC, and ground review. This scout performs none of those mutations.

Grid misses remain possible below the sampling resolution; the initial negative results apply only to those bounds. Run `scout.py`, `bridge_search.py`, `existing_via_bridge.py`, `topology_search.py`, and `verify_detour.py` with KiCad's bundled Python to reproduce the searches and final geometry checks. They do not write a board. `build_candidate.py` is the separate authorized isolated builder; it restores the exact fixed project files after pcbnew's save. `finalize_receipt.py` verifies source conservation, copied project hashes and complete DRC signature equality.

The final native command was:

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc \
  --format json --severity-all --schematic-parity --refill-zones --save-board \
  --output candidate/drc.json candidate/Trimix_Analyzer.kicad_pcb
```

`candidate/drc-invalid-default-project.json` preserves the first, rejected diagnostic run: pcbnew had rewritten the copied project to default 0.20 mm minimum tracks. That report is not accepted as a final gate. Restoring the original 0.15 mm project rule and running native refill/save/DRC produced the accepted report without changing any source project setting.
