# Upper/left routing proposal

This isolated copy resolves the five assigned residual connections. It is an additive proposal for the PCB owner to integrate, not a complete-board or fabrication release.

| Check | Frozen source | Proposal |
|---|---:|---:|
| Unconnected items | 47 | 42 |
| Existing dangling warnings | 31 | 31 |
| New DRC violations | — | 0 |
| Schematic parity issues | 0 | 0 |

The 31 remaining warnings are the same 19 track and 12 via dangling warnings identified by their original UUIDs. All five assigned missing connections disappear from native DRC.

## Changes

- BME_VIN: R601 and R602 join the existing R603/R604/J601/C601 network. The new path uses a short B.Cu connection before joining In2.Cu, allowing it to pass the local HOST_3V3 connection without a clearance exception.
- HOST_3V3: R601 joins the existing R802 network through a local In2.Cu route.
- C402 and U401: each previously isolated ground cluster receives a short front-side connection and a through-via into the existing ground plane.

There are **25 added segments and seven added vias**, with no removed items. All existing track/via nodes and footprint/pad/pose nodes compare exactly with the frozen source. Board setup, mechanical drawing objects, zone boundaries, project settings and custom rules remain unchanged. Existing ground zones were refilled.

New signal traces are 0.15 mm. Their five ordinary through-vias are 0.50/0.25 mm; the two ground vias are 0.60/0.30 mm with 0.20 mm ground traces. The smallest nominal new via annulus is 0.125 mm. None of these vias overlaps an SMD copper land. No signal track was added to In1.Cu. This does not establish global plane continuity or manufacturing qualification.

## Integration

Use `added-items.kicad_sexpr` or the explicit coordinates/UUIDs in `added-items.json`. **Append only the 32 segment/via nodes** to the owner's current candidate after checking that its scoped copper has not changed. Do not replace the owner's board wholesale. Refill zones and rerun native DRC and schematic parity on the combined result.

`proposal-verification.json` binds the board and evidence hashes. `routing-geometry-audit.json` passes ten of the owner's twelve checks; only the deliberately unfinished full-board connectivity and dangling-warning checks remain open.

Frozen board SHA-256:

`f836e8a68f4a4bfa8bec3684f96ef2766bd40bcc5af55bbfe4549180c43dc992`

Proposal board SHA-256:

`618a8e51676c448a67ce1033463f1af2bc6cf87e241e09eaa8f2789c8748915b`

`route_upper.py` recreates the explicit proposal from the frozen local baseline. `verify_proposal.py` compares the delta and emits the integration patch; use KiCad's bundled Python with the existing KiCad MCP environment's `sexpdata` on `PYTHONPATH`. `before-drc.json` and `after-drc.json` were produced by KiCad CLI 10.0.6 with `--format json --schematic-parity` and the copied project rules.

Only files in this `upper-route-proposal/` directory were changed. No authoritative PCB, schematic, or Fusion document was edited.
