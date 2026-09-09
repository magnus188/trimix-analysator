# R118 backside placement preflight

**R118 at PCB (17.4, 94.7), 90° on B.Cu fits the saved carrier opening without a CAD change.** This is a source-bound preflight; final routed-board integration remains pending.

The frozen placement board `834da30ce768a85a07d15317c3b16698dede2e9eb590618f08a19faf86c2537c` and CLR stage `006a257b5d607cb8e2642f03852cc34c7c3f9f322699856adb3cb1ae144de834` both select Yageo RC0603FR-07100KL at that pose. Its manufacturer maximum body is 1.70 × 0.90 × 0.55 mm. The retained clearance contract is deliberately larger in height: 0.60 mm body plus 0.15 mm assembly allowance.

The complete native courtyard is PCB X16.67–18.13 / Y93.22–96.18 mm. It lies inside the existing opening and has 2.395 mm to its right edge and 2.82 mm to the board bottom. No other current backside courtyard overlaps it. R116 remains on F.Cu at (7.75, 94.75), rather than flipping underneath U115.

Registration is Fusion X = 50.4 + PCB X and Fusion Y = 120 − PCB Y. The conservative R118 lower face is Fusion Z19.7179, accounting for the exported B-component base at Z20.4679 and the full 0.75 mm allocation. This is 1.1679 mm above the lowest previously checked underside allocation. The fixed board back seat remains Z20.5; board thickness variation changes the front elevation.

The saved native carrier cut occupies X50–70.925 / Y20.3–36.3 / Z18.4–20.6 mm. Selected remaining sections—2.085 mm toward the J103 window, 2.0 mm plate thickness and 3.925 mm toward the lower mounting hole—are unchanged. These are selected sections, not a global wall or stiffness qualification.

See [the machine-readable receipt](r118-backside-preflight.json) for exact source hashes, dimensional arithmetic and limitations. No CAD geometry or PCB source was modified, and no new live Fusion Boolean test was performed. Physical solder shape, production tolerances and final assembly fit still require their separate checks.
