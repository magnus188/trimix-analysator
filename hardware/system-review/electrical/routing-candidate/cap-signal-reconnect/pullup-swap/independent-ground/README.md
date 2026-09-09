# Independent saved-ground audit

Final candidate **a700 passes the saved-fill continuity and ground-anchor checks** against clean accepted baseline 12fc. In1 remains one physical copper region; all 70 GND vias and 35 plated GND pads retain their In1 contacts. All nine In2 GND regions retain an annular contact through a plated anchor to In1. This is a geometry review, not a manufacturing release or a current/thermal/EMC calculation.

The primary comparison is [accepted-plane-comparison.png](accepted-plane-comparison.png). [ground-audit.json](ground-audit.json) contains every anchor UUID, position, annular overlap, region membership, filled area, and check result. [native-crosscheck.json](native-crosscheck.json) records the independent native KiCad review.

## Frozen inputs

| Input | SHA-256 | Disposition |
|---|---|---|
| `accepted-12fc.kicad_pcb` | `12fc60412aa21dcbca3f4fb69da038a8d312193734992441231de17a70e3d5bc` | Clean accepted baseline, byte snapshot taken before owner advanced it. |
| `../before.kicad_pcb` | `43046290dd43fb281ee8711e50924bf6cb4f689afc3f26330c916a1776d2a0c3` | Invalid intermediate trial with four known CHG/SCL shorts; comparison context only. |
| `candidate-a700.kicad_pcb` | `a700da8b29a0faf6e3ea642cba1b0d9ed80d4d86c9f0e530417dc97956259c73` | Owner-confirmed final frozen candidate, with CHG via (19.95, 74.3) and SCL via (25.30, 75.125) mm. |

`candidate-a700-delta.json` is the matching owner delta. This audit loads only saved geometry, never refills or rewrites a board. Inputs are hashed before and after the audit. No direct geometry comparison to the unsnapshotted 85a6 intermediate is claimed.

## Filled copper and anchors

Areas below are original saved GND fill polygons, before drill subtraction, in mm². Physical connectivity and anchor tests separately subtract all drilled openings.

| Layer | Accepted 12fc | Invalid trial 430 | Final a700 | Final physical regions |
|---|---:|---:|---:|---:|
| In1 | 2059.932622 | 2058.035882 | 2059.324609 | 1 |
| In2 | 93.022271 | 91.335800 | 93.022271 | 9 |

Relative to accepted 12fc, candidate In1 removes 0.814781 mm² and adds 0.206768 mm² of saved fill. In2 is geometrically identical to accepted 12fc. The apparent In2 gain against 430 repairs that invalid intermediate and must not be presented as a gain against the accepted baseline. Zone outlines/settings are preserved against both inputs; there are no In1 signal tracks.

All 105 plated GND anchors contact In1, with the same UUID contact set in all three boards. Ten GND vias and ten plated GND pads contact In2. The nine In2 regions, ordered by area, have 1, 2, 3, 2, 1, 7, 1, 1, and 2 anchor witnesses respectively. Each region has a physical annular contact to an anchor that also contacts In1. Whole via disks are not used as contact proof.

In2 GND fill occupies X7–21, Y83–94.2 mm. It has **zero area in the requested local crop X16–28, Y60–78 mm**, including the added CHG In2 path. Consequently that long route does not cut a local In2 ground fill. In1 is the continuous adjacent ground reference in the reviewed geometry; this observation does not quantify the electrical return path or inductance.

## Local copper widths

[local-In1-throat-witnesses.png](local-In1-throat-witnesses.png) shows two verified material lines. Widths are measured between saved polygon boundaries, including drilled openings; they are local copper ligaments, not a global minimum-width result.

1. **0.159640645 mm, unchanged:** the pre-existing SCL antipad near (19.25, 74.75) to GND drill `235ba820-d791-47b0-b328-da46ddad33b8` at (19.825, 75.25). The new CHG antipad joins that SCL opening but does not narrow this existing ligament. It is not a newly created CHG-via neck.
2. **0.690670880 mm, previously 1.049469309 mm:** the northern gap from the merged CHG/SCL opening to the SCL antipad near (19.4, 72.8). Candidate witness endpoints are (19.776109, 73.880202) and (19.573886, 73.219799) mm. This is the local narrowing associated with the new CHG via; no ground region or anchor becomes disconnected.

The merged opening has area 1.275537 mm² and adds 0.634283 mm² to its related prior opening. Additional boundary distances are retained in the JSON for inspection. Rows with `material_line_verified: false` are excluded from accepted ligament claims and from the witness drawing. No minimum manufacturing width is inferred from these distances.

`local-In1-occupancy.npz` provides 0.01 mm pixel-centre sampling over X18.15–21.75, Y72.5–76.1 mm. A boundary has up to 0.007071 mm sampling quantization; a two-boundary width has up to 0.014142 mm. Features narrower than a pixel may be missed. The quoted widths use the polygons, not this raster. Erosion probes in the JSON are sensitivity diagnostics only.

## Overlays and limits

- [local-plane-comparison.png](local-plane-comparison.png): invalid trial versus candidate, requested local crop, both inner layers.
- [all-board-planes.png](all-board-planes.png): invalid trial versus candidate, entire board, both inner layers and anchor rings.
- [local-power-overlays.png](local-power-overlays.png): accepted versus candidate, actual F/B copper over the requested crop.
- [all-board-power-overlays.png](all-board-power-overlays.png): entire candidate F/B copper.

Each image has a matching SVG. Render geometry is simplified by at most 0.0005 mm for display only; measurements retain original geometry. The overlays show actual layer copper and net colours, without projected plane copper or inferred current/temperature performance. Titles, legends, and witness clipping were visually checked after rendering.

The parser's circular pad/drill approximation uses 128 segments per quadrant. Independent native KiCad extraction agrees on original saved area and all contact/component classifications. Native drill conversion uses a different 0.00005 mm curve tolerance, accounting for approximately 0.000402 mm² In1 and 0.000061 mm² In2 differences in drill-subtracted candidate area. Native `Unfracture` can alter nominal area by about 0.00004 mm², so original saved contours are the nominal-area reference.

## Separate owner DRC evidence

[owner-drc-capture.json](owner-drc-capture.json) binds the captured [raw owner report](candidate-a700-drc.json) to the frozen a700 source, with before/after byte checks during capture and the owner's matching-board confirmation. Native KiCad 10.0.6 report time: 2026-09-07T22:59:35. Both error and warning severities and the original ignored-check list are preserved.

The owner report contains 17 track-dangling and 8 via-dangling violations, 10 unconnected items, zero schematic-parity items, and no other violation types. This independent audit did not rerun DRC. The remaining disconnected/dangling items mean this evidence is not a board-release certificate.

## Reproduce

From the repository root, with Shapely, NumPy, sexpdata, and CairoSVG available:

```sh
/tmp/trimix-gerbonara-venv/bin/python hardware/system-review/electrical/routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py \
  --candidate-sha256 a700da8b29a0faf6e3ea642cba1b0d9ed80d4d86c9f0e530417dc97956259c73 \
  --candidate-board hardware/system-review/electrical/routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/candidate-a700.kicad_pcb \
  --delta hardware/system-review/electrical/routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/candidate-a700-delta.json
```

The script imports the read-only geometry parser `electrical/main-final-independent/cam_geometry.py`; it does not import the owner build script. `verification-receipt.json` records final artifact hashes and the evaluated gates.
