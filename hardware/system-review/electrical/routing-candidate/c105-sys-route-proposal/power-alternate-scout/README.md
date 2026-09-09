# Bounded alternate VSYS scout

**No complete additive 0.40 mm VSYS route was found** on the fixed CE-clean board, using either 0.60/0.30 mm vias or the subsequently authorized ordinary 0.50/0.25 mm vias. A smaller-via source gateway is verified below. Ignoring only USB_CC_INT_N tracks in separate hypothetical searches leaves the source reachable region exactly unchanged; CC relocation alone does not open this fixed-source route.

Source: `../ce-bridge-scout/candidate/Trimix_Analyzer.kicad_pcb`, SHA-256 `3ba04d481d49b39d87a800c941448d665bcbd465af761bb2b0d617c23429b469`. All results refer to that board. Later proposed R101/R116/R119 or CC changes are not included. No board or authoritative file was written by this scout.

## Actual islands and gateway

Zero-tolerance native copper connectivity identifies 40 objects in the C105/source VSYS island and 89 in the main VSYS island. Source seed: `e0ff3d79-dfcb-4e4d-bd20-72417ad68f09` at (7.0507,88.8048); main seed: `bb5aec9b-1ff4-4544-8878-dac6d41c8a1b` at (15.84,84.25). Searches start and end on all actual connected native conductors, not just those seeds. Source also reaches existing power via (3.3741,93.7614); main also reaches existing power via (21.0,80.5892). `gateways.json` contains the UUIDs and complete island evidence.

The ordinary **0.50/0.25 mm via at (9.4,88.7625)** is legal and accepts this **0.40 mm In2 route** from the source:

`(7.0507,88.8048) → (7.4,88.125) → (8.0,87.525) → (9.4,88.7625)`

Uncached native checks pass every segment, all four copper layers for the via, all SMT and PTH lands including same-net pads with +0.05 mm margin, board edges, and board/footprint rule areas. Via-centre to nearest foreign copper/pad distance is 0.4879546–0.4879551 mm, limited by R122.1 on B.Cu, UUID `1df64c1c-34ee-4df2-ad2a-342583083ad0`, net USB_OVP_UPPER. This gives at least **0.2379546 mm via copper clearance**. A 0.60 mm via fails at this same site. The binding route's minimum copper clearance is at least 0.2091677 mm, limited by the retained CE detour. See `boundary-witnesses.json`.

This gateway does not complete the VSYS connection. No candidate board, paired-via arrangement, or current rating is claimed.

## Search results

All searches use X0.8–29.15/Y78–94.3 mm, a 0.05 mm grid, continuous native segment checks, 0.40 mm traces and 0.20 mm foreign copper clearance. Routing layers are F, In2 and B; new vias are checked on all four copper layers. No In1 signal tracks are allowed. All new-via sites exclude all SMT/PTH pad lands plus 0.05 mm.

| Via / drill | Search | Reached nodes | Result |
|---|---|---:|---|
| 0.60 / 0.30 | Source to main, all foreign copper retained | 31,325 | Exhausted |
| 0.60 / 0.30 | Main to source, all foreign copper retained | 21,500 | Exhausted |
| 0.60 / 0.30 | Source to main, hypothetical CC tracks omitted | 31,325 | Exhausted; identical reachable set |
| 0.50 / 0.25 | Source to main, all foreign copper retained | 35,381 | Exhausted |
| 0.50 / 0.25 | Main to source, all foreign copper retained | 21,747 | Exhausted |
| 0.50 / 0.25 | Source to main, hypothetical CC tracks omitted | 35,381 | Exhausted; identical reachable set |

The CC-only hypothetical reports enumerate every omitted track UUID. CC pads and vias remain hard obstacles. No other foreign net is softened in any case. Files are `additive-result.json`, `reverse-additive-result.json`, `hypothetical-cc-result.json` and the corresponding `via050-` variants. Each contains the complete native island receipts, grid nodes, legal sampled via sites, source hash and bounds.

With 0.50 mm vias, the source reaches F X0.8–9.9, B X0.8–10.35 and In2 X0.8–11.35. The main region begins at F X12.75, B X14.8 and In2 X12.85 within the searched box. The route search includes all allowed layer changes and existing power-conductor seeds, so the outer-layer jump possibility is included.

## Exact outer-jump obstructions

`boundary-witnesses.json` native-checks the closest facing grid-frontier pairs. These are obstruction witnesses, not proposed tracks:

- **F.Cu:** (9.9,88.45)→(13.0,90.05) is blocked by BQ_REGN, PACK_TS, USB_OVP_SET, R101.1 and R102.1. Exact UUIDs include BQ_REGN `7b86bfad-a620-4f23-9307-6603eb0c559a`, `caa2a399-46c5-4b8f-8341-48abb83061e6`; PACK_TS `78fe77e5-3d4d-401f-a44b-1e47176e0fac`, `8c439f18-3ea0-4ca8-92e0-2fe6783d2743`; SET via `674c2f7e-3fc3-4bfb-a9c7-ef1bb5ae9d95`.
- **In2:** (11.35,87.3)→(12.85,87.7) is blocked by CHG_INT_N and USB_OVP_SET, including CHG barrier `a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8` and the connected CHG/SET vias and tracks listed in the JSON.
- **B.Cu:** (10.35,89.7)→(14.85,86.7) is blocked by PACK_TS, CC, SET and GND conductors, R123 lands and C114.2. Exact UUIDs are retained in the JSON.

The owner's v2 upper route suffix starting at **(13.25,88.6636563877)** was independently checked: it is native-clear and joins the actual main reachable region all the way to (17.2392857143,83.6821428571). The wider search failure is therefore not caused by missing that upper approach. An ordinary via at the suffix start is blocked by R101/BQ_REGN on F and U115.4 on B; see `upper-manifold-witness.json`. Pending R101 changes may alter this finding and require a new source hash.

## Reproduction and limits

Run the scripts with KiCad's bundled Python using `-B`. `gateway_probe.py` identifies the actual islands; `search_power.py` accepts `--via-diameter .5`, `--reverse`, and the explicitly hypothetical `--ignore-cc`; `boundary_witness.py` checks the concrete gateway and separated-region witnesses without the spatial search index. `power_context.py` never saves the board. The native island helper is the read-only `upper-bus-route-proposal/island_targets.py`.

Via collision distances are radius +0.2001 mm to foreign copper, radius +0.0501 mm to all pad lands, radius +0.5001 mm to edges and radius +0.0001 mm to via-prohibiting rule areas. Track centreline collision distances are 0.4001 mm, 0.7001 mm and 0.2001 mm respectively. Saved GND zones are not hard obstacles to normal refilled clearances; any adopted power route still requires native refill, DRC and ground review. Existing vias/pads are used as actual connected endpoints, not replaced or moved.

These are bounded grid results, not a proof that no sub-grid or longer route exists. No further old-source grids were run after the owner started the R101/CC revision. `summary.json` binds the final files and checks to the immutable CE-clean source.
