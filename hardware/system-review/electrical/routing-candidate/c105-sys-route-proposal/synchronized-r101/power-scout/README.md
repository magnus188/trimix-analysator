# Independent SYS verification after CE, SET and CHG changes

**The explicit 0.40 mm In2 SYS route passes native geometry and connectivity checks with zero new power vias.** It joins all 129 original VSYS conductors from two physical islands into one connected component. The exact CHG replacement also forms one connected component. This is an independent geometry check; the owner runs the combined native refill and DRC.

The primary evidence is `explicit-sys-verification.json`, reproduced by `verify_explicit_sys.py`. Inputs are frozen within this directory:

- `ce-set-3d72.kicad_pcb`: SHA-256 `3d72a8d43823f29553d900e0c0820aed391bd7e5e336b70a5869bc3f220a1962`, the owner-confirmed native-saved CE+SET board.
- `chg-delta-frozen.json`: exact CHG proposal, replacing only `a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8` with nine 0.15 mm tracks and three ordinary 0.50/0.25 mm vias. Its required SET topology is checked against the saved board before the CHG delta is applied in memory.

No authoritative file or candidate board is written by this verification. The CHG and SYS objects are constructed only in memory. All input hashes remain unchanged.

The SYS path is:

`(7.0507,88.8048) → (7.4,88.125) → (8,87.525) → (10.525,88.2) → (11.55,89.2) → (11.85,89.3) → (12.15,89.25) → (17.825,86.225) → (18.4,85.65) → (18.55,85.25) → (18.4,84.85) → (17.2392857143,83.6821428571)`

All eleven segments use In2 and 0.40 mm width. Native continuous `SEG` collision tests require 0.4001 mm centreline distance to foreign copper, 0.7001 mm to board edges and 0.2001 mm to track-prohibiting rule areas. Board and footprint rule areas are included. The all-layer reserved rectangle X15.7–18.5/Y89.3–91.0 is treated as foreign copper, so its required clearance is also enforced. No In1 signals or new power vias are introduced.

The minimum foreign copper clearance is **0.200518894 mm**, on SYS segment (11.55,89.2)→(11.85,89.3), limited by new CHG segment `10472100-8047-4d16-9302-b4f9723128b5`. Every segment has its native clearance interval and binding UUIDs recorded in the JSON. No foreign net is ignored.

Native zero-tolerance physical connectivity confirms:

- VSYS: original islands of 89 and 40 conductors become one component of **140 objects**, including all eleven new SYS tracks.
- CHG_INT_N: **91 objects** form one connected component after the exact replacement.
- New SYS touches retained VSYS copper only at the initial source via `e0ff3d79-dfcb-4e4d-bd20-72417ad68f09` and terminal main track `f5ed89f1-ecd9-436a-b784-e4224244e909`. Main via `bb5aec9b-1ff4-4544-8878-dac6d41c8a1b` lies in the resulting component.

The saved CE+SET board includes the owner's two known R101 schematic-parity items. This proof does not clear those items or claim manufacturing readiness. Saved GND zones are not treated as immutable obstacles to normal refill; combined refill, DRC and ground review remain with the owner.

Earlier 0.05 mm additive searches on CE-only `983743…` and CE+SET `3d72…`, before the CHG replacement, each exhausted 35,381 nodes with 0.40 mm traces and 0.50/0.25 mm vias. They are retained as historical scout evidence. No further power grids were started after the concrete CHG solution arrived. The fixed route above supersedes those failed additive searches.

Run from the repository root:

```sh
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 -B \
  hardware/system-review/electrical/routing-candidate/c105-sys-route-proposal/synchronized-r101/power-scout/verify_explicit_sys.py
```

`verification-receipt.json` binds the scripts, frozen inputs and resulting evidence by hash.
