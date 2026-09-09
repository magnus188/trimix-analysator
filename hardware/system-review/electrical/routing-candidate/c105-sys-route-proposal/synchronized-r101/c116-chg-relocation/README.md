# C116 / CHG gateway coordination

The frozen C105→SYS candidate remains `de594d8ef4db9489931fe091ba63d938a0d4a33f1bb0455e988433c3fefa95db`. This folder contains isolated, unadopted diagnostics.

The owner’s C116 0402 candidate (`e894cd36…`) replaces exactly one footprint and three B.Cu track endpoints. Applying that guarded delta causes the existing CHG via at (15.95,88.35) to conflict with C116 pin 1 and its DVDT trace.

A new ordinary Ø0.50/0.25 gateway at (17.65,88.7) and its F.Cu link from (16.8,87.8) pass the native shape checks. The In2 link back to (12.2,89.75) crosses HOST_3V3 track `7640755f-7eb3-4787-b80f-b44f25a93b49` at (16.175820,88.984016). This is a **blocked hypothetical corridor, not a clean patch**. Parent and controls are coordinating a shared HOST bridge.

`hypothetical-corridor.json` records exact before/proposed nodes and the source hashes. `gateway-clearance-comparison.json` records selected native minimum gaps; (17.9,88.7) has more margin than (17.65,88.7), but remains unadopted and crosses the same HOST barrier.

No schematic, purchased pose, authoritative PCB, Fusion model, or completed de594 candidate was changed. Fresh native DRC, connectivity, ground/return and source-conservation checks are required after a coordinated combined solution exists.

## Later combined-source rejection

The (17.9,88.7) alternative is **superseded and rejected** by the controls owner’s later native DRC: Q110.2 copper gap0.0500mm/drill gap0.175mm, and R126.2 copper gap0.1874mm. The earlier0.275mm value was a preflight on the explicitly older de594+e894 obstacle set, not a valid clearance on the later combined source. Do not adopt that alternative. Controls owns further17.65 fallback evaluation.
