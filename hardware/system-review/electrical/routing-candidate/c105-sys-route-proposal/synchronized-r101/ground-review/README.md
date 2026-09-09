# Saved ground and local power review

Compared frozen `before.kicad_pcb` (`f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432`) with frozen `complete-candidate/Trimix_Analyzer.kicad_pcb` (`de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db`). Neither PCB was modified or refilled by this review.

All existing ground annular contacts are preserved: 105 on In1 and 21 on In2. In1 remains one physical region. In2 changes from 10 to 11 physical regions; all 11 retain a plated-barrel anchor to In1. Native layer flashing was checked. No unflashed ground anchors or whole-disk/annulus contact disagreements were found.

| Layer | Saved fill area before, mm² | Final, mm² | Physical area before, mm² | Final, mm² |
|---|---:|---:|---:|---:|
| In1 | 2056.744480497 | 2054.234963659 | 2042.974291913 | 2040.464775074 |
| In2 | 86.886785232 | 68.658677924 | 85.284788691 | 67.056681384 |

In2 loses a net 18.228107307 mm² of saved fill, about 21%. Its largest original physical region shrinks from 23.738555276 to 3.085099338 mm² while preserving its GND via at `(19.0625, 85.95)`. Another original region splits into two anchored regions. The complete geometric mapping is recorded in `review.json`; preserved anchors do not mean unchanged ground coverage.

Local In1 witnesses around the new ordinary vias:

- CE `(6.4, 88.35)` merges previously separate clearances into one void. Its nearest verified material ligament to a neighboring void is 0.5442 mm, unchanged from the related prior void geometry.
- CHG `(20.15, 82.8)` leaves verified material ligaments of 0.4990 and 0.7161 mm.
- CHG `(15.95, 88.35)` and `(16.8, 87.8)` share a merged saved void: there is no In1 copper ligament between their antipads. The closest verified surrounding ligament is 1.724348636 mm.

These are selected local boundary-to-boundary material witnesses, not a global minimum neck or thermal/current/EMC rating.

Actual F/B GND, USB_OVP_5V, USB_CHG_5V, USB_5V, and VSYS copper within X 3.6–14.475 / Y 87.1–95.975 mm, around U114/C114/C115, is geometrically unchanged: zero removed or added copper area for each checked net and layer. This is a local geometry comparison, not a performance claim.

## Evidence

- `review.json`: native fill cross-checks, all ground anchor UUIDs, regional anchors and transitions, local void measurements, and power-copper comparisons.
- `local-plane-comparison.png`: before/final In1 and In2 copper.
- `u114-c114-c115-outer-copper.png`: before/final actual F/B copper with component-pad labels.
- `sys-outer-copper.png`: broader C105/SYS F/B context.
- `via-1-ligaments.png` through `via-4-ligaments.png`: selected new-via voids and measured witnesses.
- Matching SVG files retain vector geometry; PNGs are illustrations rather than measurement sources.

## Reproduction

From the repository root:

```sh
/tmp/trimix-gerbonara-venv/bin/python -B hardware/system-review/electrical/routing-candidate/c105-sys-route-proposal/synchronized-r101/ground-review/review.py \
  --source-sha256 f1c5f443cbd6cdf92e39e01fc7db374c30721b6e7945b3cdde3387e8cdff7432 \
  --candidate-sha256 de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db
```

`review.py` uses the existing shared ground-rendering primitives and launches native KiCad Python through `extract_native.py`. Native saved contours and independent S-expression parsing agree within 1e-8 mm² symmetric-difference area. All physical areas subtract native drill polygons (0.00001 mm maximum circle-conversion error). Contacts require positive annular overlap above 1e-8 mm² and layer flashing. Source hashes are checked before and after the review.

Native DRC, schematic matching, and complete-board disposition are separate owner checks. This review grants no release or manufacturing approval.
