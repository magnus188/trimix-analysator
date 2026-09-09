# Upper power-routing handoff

This isolated proposal completes three previously missing connections:

1. Existing VOUT copper spine to U302.1.
2. U302.1 to its C302 input capacitor.
3. U801.1 VSYS supply to the existing VSYS trunk feeding U201.10/11.

U201.13 remains unresolved. No authoritative main/USB board or Fusion document
was edited. The main routing owner should integrate the copper delta only.

| Item | Frozen value |
|---|---|
| Source board SHA256 | `40158632831955192a2603701a928c6f53594d5937f9eee2602a55cd93141205` |
| Proposed board SHA256 | `090f49dfefc6963d7579a60acee352ae90e5158fcb3572686434a119d2d4319b` |
| Added copper | 13 tracks and 3 ordinary through-vias |
| Removed copper | One U302 input stub, UUID `083685fa-78b3-4ded-8fb3-cc7af34dad2f` |
| Native DRC | 38 dangling-only findings; 37 unconnected; zero parity findings |
| Approved source DRC | 39 dangling-only findings; 40 unconnected; zero parity findings |

`final-delta.json` contains every added/removed UUID, endpoint, layer, width and
via dimension. `final-drc.json` is the final native check against the exact copied
owner project settings and custom rules, also hashed in the delta receipt.
`direct-native-witnesses.json` independently confirms the three connections using
layer-aware direct native track/pad adjacency; it does not infer connections from
net names, pours, or equal pin numbers.

## Route details

- **U302 load feed:** 0.40 mm B trace from the existing VOUT branch to a
  0.60/0.30 mm via at (10.25,51.00). The former straight 0.30 mm F input stub is
  replaced with two 0.30 mm segments ending at the via center.
- **C302 capacitor branch:** 0.20 mm local In2 route from that input via to a
  0.50/0.25 mm via at (10.40,48.90), then two short 0.20 mm F segments to C302.1.
  This avoids the existing HOST_5V and GND F connections. It is a capacitor
  branch; the U302 load-current feed remains on the wider F/B copper above.
- **U801 controller supply:** 0.30 mm F from pin1 to a 0.60/0.30 mm via at
  (11.40,54.025), then 0.30 mm B routing to the existing VSYS trunk at
  (12.8897,58.1006).

All added centerline points are inside the authorized x8..21, y47..62 mm scope.
No In1 signal track was added. The plane outlines, all purchased component
positions, the direct C204–206 F spine, and every other existing copper object
are unchanged. Native zones were refilled around the three ordinary vias.

The smallest nominal gap between new copper and unrelated pad/track/via copper
is 0.2218 mm. The via annuli are 0.15 mm, 0.15 mm and 0.125 mm respectively.
No via land overlaps an SMD land. These are nominal geometry checks, not
fabrication tolerance, load-current, temperature or current-rating guarantees.
Global return-plane/CAM and physical electrical checks remain separate.

## Remaining U201.13 connection

Pin13 at (14.4,60.0) is bounded by the POWER_EN F trace at x14.9767,
y58.6135..60.5, the NC PG14 land above, VIN11 below and C201's GND land on the
right. A direct ordinary via near (15.15,60.0) would intersect POWER_EN.
No POWER_EN route, package land, switching-loop track or component position was
changed to force this connection. The owner must coordinate a different local
escape; this report does not claim global unroutability.

## Review and reproduction

`upper-copper.svg` / `.png` show actual final copper on F, B and In2. New VOUT
copper is blue and VSYS orange. B is shown through the board in PCB coordinates.
Filled planes are intentionally omitted from the visual; their outlines and
native refill were checked separately.

`build_proposal.py` reconstructs the proposal from `before.kicad_pcb` and restores
the frozen verification project/rules. Regeneration assigns new copper UUIDs,
so use the existing frozen delta for integration. `audit_local.py` recomputes
the source/geometry/delta checks with the Gerbonara/Shapely environment.

After integration into the evolving main board, refill and repeat native DRC,
parity and connectivity checks. The whole source was still unfinished; neither
the isolated board nor its diagnostic exports are an order release.

Final native check command:

```sh
/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli pcb drc --format json --schematic-parity -o hardware/system-review/electrical/routing-candidate/independent-upper-power/final-drc.json hardware/system-review/electrical/routing-candidate/independent-upper-power/Trimix_Analyzer.kicad_pcb
```

The CLI ran outside the restricted sandbox because macOS application
registration crashed in the sandbox. Only the frozen final board, delta,
verification and review views describe the handoff; older raster/landing files
are intermediate work and must not be integrated.
