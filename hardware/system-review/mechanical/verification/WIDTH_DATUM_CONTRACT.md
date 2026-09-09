# Main PCB width datum — SystemReview

The main PCB is a rigid 30 mm-wide purchased assembly. Its maximum-X edge remains
4.6 mm inside the maximum-X enclosure datum when `CaseWidth` changes:

```text
PcbWidth = 30 mm
PcbX = CaseWidth - PcbWidth - 4.6 mm
Main wrapper = [PcbX, PcbY + PcbHeight, PcbZ + 0.0529 mm]
```

Coordinates retain the existing Fusion convention: positive X is viewer-left,
positive Y is upward, and positive Z is rearward. The maximum-X datum is
therefore on the viewer-left side.

The approved manifest is `width-contract-proposal.json`, SHA-256
`138c1ea26d12f18a2cbb87c736a85747f98e388082db3300e5fcfb03989bec2f`.
It changes 35 parameter expressions and synchronizes four hardware occurrence
bindings. The rigid assembly joint is **SystemReview main PCB parametric
placement**, using **SystemReview main PCB stack datum**. Imported child parts
remain grounded at their original local poses; nothing is scaled.

The PCB, both holes, screws, inserts, carrier outline and all source-derived
carrier pockets share this datum. The hole centres are `(PcbX + 25.6, 28)` and
`(PcbX + 4.4, 114)` mm; their spacing stays 88.5744884264 mm. The carrier's USB
service corner remains 6 mm wide. The USB cartridge remains centred in the
enclosure, so its translation is half the width change.

The measured battery holder stays at its established datum. The divider's
battery-facing surface stays at X48.2 mm; its printed width grows from 2 to 4 mm
over the tested 85–87 mm enclosure widths. The printed cradle, end stops and
upper mounting support extend to meet it. This preserves the existing holder
clearance and support connection rather than translating the holder.

## Baseline and bounded verification

`width-contract-baseline-applied.json` records the native application at 85 mm.
All 1,074 physical solids have identical world bounds, volumes and bilateral
Boolean-difference residuals of zero. All 285 main-board descendants retain
their local poses. Feature health passed, and the three unrelated FlowGrid
documents retained their identities and modified flags, including the unsaved
R3.1 document. The apply stage did not save a cloud version.

Individual trial receipts belong under `width-contract-tests/W*/`. Each changes
only `CaseWidth`, tests the current native model and source-derived allocations,
then restores 85 mm in `finally`. Restoration compares all physical solids,
parameter expressions, timeline count, health and protected document states.
The receipts below record the completed checks and their exact scope.
The final validation scope uses full sampled removal, driver and thickness checks
at 85 and 87 mm only. Samples at 85.5, 86 and 86.5 mm retain actual static/max
allocations, bore alignment, selected material and rigid-solid equivalence checks;
the full path tests are not repeated at those intermediate widths.

The completed [validation disposition](width-contract-validation-disposition.json)
records passes for all five static/core samples and all five exact restorations.
There are zero actual cross-assembly solid clashes at every sample. At both
endpoints all 14 nominal driver shafts and the main screw thickness cases pass;
the modeled axial screw/insert overlap is 3.24–3.56 mm, with a measured tip-clear
distance lower bound of 0.538 mm. These values describe the current generic
hardware geometry, not qualified heat-set retention.

The original straight upper-retainer withdrawal fails at 87 mm against the
chamber's feedthrough allowance. Its failed receipt is retained. The adopted
sequence passes actual rigid-body checks at both 85 and 87 mm, sampled every
0.25 mm or less: remove the upper retainer screw, lift the upper clip **6 mm
rearward**, shift it **1.5 mm toward negative X**, then withdraw rearward. The
lower retainer, display, chamber/feedthrough and other assemblies remain fixed
during that upper-clip step. Remove the lower retainer afterward and support the
display when both retainers are off. Physical hand access and the unmeasured
factory retention interface remain to be checked.

The restored 85 mm design was saved as **SystemReview v8**, preserving v7. The
separate [native checkpoint](../width-checkpoint/Trimix_Enclosure_A3_SystemReview_WidthContract.f3d)
contains the revised dependencies. [Cloud completion](../width-checkpoint/cloud-save-status.json)
confirms v8 saved, complete and unmodified, with every protected FlowGrid state
preserved. The [native reopen receipt](../width-checkpoint/native-reopen.json) passes geometry,
poses, every parameter expression, history, the main joint and 285 grounded
descendants; its temporary copy was closed and all source/other-document state
was preserved. This is a width-datum checkpoint; it is not final routed integration.

The selected checks include actual PCB/carrier/housing bore axes, hardware
coaxiality, purchased dimensions and movement, selected material sections,
maximum part and cable allowances, socket withdrawal, service paths, driver
shafts, and screw engagement at 1.44/1.60/1.76 mm finished PCB thickness.
Maximum envelopes follow the datum once while the electrical source coordinates
remain unchanged. Native PCB package-to-package intersections remain an EDA
package audit, separate from cross-assembly enclosure checks.

## Limits retained

- The installed main STEP is immutable **placement-checkpoint-v2**, not the final
  routed board. Its known R301/J301 mated-envelope conflict remains visible.
- The upper pilot's existing Y ligament is **1.95 mm**, from a 7.2 mm support web
  around a 3.3 mm pilot. This baseline datum change does not strengthen it or
  claim it meets a 2 mm minimum.
- The bounded width range is 85–87 mm. Narrower widths would reduce the divider
  below its selected 2 mm section and are not covered.
- Selected section probes are not a global minimum-wall proof. Nominal screw
  engagement is not insert retention, torque or material qualification.
- Purchased tolerances, real cables, the owned SMB elbow, thread/shoulder/seal
  details and gas performance retain their existing physical-validation holds.

## Next frozen PCB import

`width_aware_refresh.py` is prepared but not executed by the width workflow.
Use a complete frozen PCB/STEP/height bundle and inspect its source-hashed local
stack datums before retiring the previous import. The helper preserves the
native wrapper joint and replaces only its STEP descendants. Any changed stack
requires an explicit reviewed datum change; it must not scale the PCB or its
purchased components. Run the width-aware maximum and service checks again on
the new bundle before describing it as integrated.
