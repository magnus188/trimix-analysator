# Guition photo registration and wiring review

The owner supplied [IMG_0571.png](IMG_0571.png) on 2026-09-08 and explicitly confirmed that **up in the image is the top of the assembled device**. This is a rear view. The image is archived byte-for-byte, with SHA-256 `867f6220b1a6c27a98dfface8bef685d9fbe23a2dc351ea9fc20ac13ca1dda81`. Its stored raster is 4032 × 3024 with EXIF orientation 6; the correctly oriented view is 3024 × 4032. Apply EXIF orientation before interpreting pixel positions.

The photograph establishes:

- The two-row expansion header runs horizontally near the top. The visible near-row end labels are 1 at the left and 25 at the right. Verify the actual mating-side contact map by continuity before wiring.
- Two USB-C receptacles are immediately below that header.
- The onboard card socket is on the left edge, above the large ESP32 module. Its access is sideways in the PCB plane, rather than directly rearward.
- The main display flex is near the bottom. Keep its fold and exposed contacts out of retention and cable-clamping zones.

The owner will fit a fresh card. No extra SD socket is required on the main PCB. Rear-cover access is preferred; the actual ejection stroke and hand clearance still need checking. If the side wall blocks withdrawal, use the approved display-release sequence before considering an extender or a new exterior opening. No card has been mounted, formatted or written by this review.

## Position estimates, not manufacturing measurements

[registration.json](registration.json) registers the four mounting-ear hole centres using the **60 × 108 mm** grid in Guition's [manufacturer drawing](guition-manufacturer/JC4880P443C_I_W_Y.pdf), centred on the owner's **69.3 × 116.8 mm** retained casing dimensions. The manufacturer's outer dimensions are 69.41 × 117.01 mm; the hole grid is retained without scaling. Local X points right and local Y points up. The current display datum adds X=7.85 and Y=5.2 mm in Fusion; Z increases rearward.

The independent first-to-last header cross-check maps to **30.572 mm**, versus twelve 2.54 mm intervals = **30.48 mm**, a **0.30% disagreement**. This improves the earlier casing-edge estimate, which disagreed by 5.6% and is retained in [the superseded initial record](registration-initial-edge-estimate.json). Raised header/USB surfaces are not in the mounting-hole plane, and hole-centre picking is approximate. Use actual 2.54 mm pitch, provisional centres with ±2 mm starting XY allowances, and separate height/plug allowances. The ±2 mm value is an engineering allowance, not a calibrated uncertainty bound. Do not scale purchased parts to make the photograph fit.

The owner subsequently measured **13.4 mm from the front glass surface to the tall header tips**. This anchors the bare header's rearward extent. It does not establish the plugged-in socket height, PCB Z or exposed post length individually; use the actual front-glass plane as the datum. USB mouth Z, plug seating, card mechanism, ejection travel and cable bend radii remain reference interfaces. A generic microSD body is 11 × 15 × 1 mm according to the [Kingston dimensional specification](https://www.kingston.com/datasheets/sdcit2_en.pdf); this establishes a card-format reference, not the socket geometry or a selected purchased card.

The [candidate IDSD socket review](../electrical/host-harness-review/README.md) gives a 9.144–9.525 mm body height and permitted insertion of 5.588–6.223 mm. Conditional on the Guition posts and seating being compatible, the socket cap therefore reaches **16.321–17.337 mm from the glass** (`13.4 + socket height − insertion`). The CAD check starts with a **17.8 mm engineering allowance**, before separate cable bend and withdrawal space. This does not establish an exact remote termination or a guaranteed maximum. The pin-7-blocked main-board connector must not be copied onto the Guition end, where pin 7 is physically present. The proposed single-ended cable still needs a qualified remote termination.

## Complete cable routes to check

The preserved v11 CAD has local connector and feedthrough allowances, but no complete verified loom. Its earlier clearance results do not qualify the newly located Guition connectors.

| Harness | Required path and service provision | Outstanding evidence |
|---|---|---|
| Chamber → J501/J601/J701 | Sealed chamber pigtail, dry-side disconnects, strain relief, continuous route clear of the heater and gas passages | Actual insulation/bundle diameter, potting or gland, seal compatibility, mated plugs and bends; MD62 four physical leads to three interface nets |
| Oxygen → J401 or J402 | Selected cell's dry-body cable outside the wet chamber; maintain approved J402-above-J401 arrangement | Actual straight AO2 plug and JJ elbow sweep, cable exit and disconnect travel |
| J301 → Guition JP1 | Complete ribbon/loom around a PCB edge to the now-confirmed top header, correct pin-one orientation, service slack and retained strain relief | Connector post/mate geometry, free cable length, bend/twist envelope and qualified host power entry |
| Onboard SD | Installed card plus sideways ejection and grip corridor | Socket stroke/type and clearance with housing, battery and display retainers |

The [chamber termination record](chamber-wiring.md) resolves the MD62 four-lead/three-wire mapping from its manufacturer manual. The existing main PCB edge-to-divider gap is only about 0.2 mm and is **not a wiring passage**. A top-edge cable detour must be modeled and checked; a straight forward drop through FR4/carrier is invalid. The nominal four-inch Samtec assembly length is not its free ribbon length. The common Guition 5 V power/backfeed hold remains unchanged by this mechanical photograph.

The [current J301 pose check](current-host-pose.json) reads the unchanged routed board directly: its 180° orientation makes the standard ribbon exit inward (−X), while all 26 logical nets retain the earlier pin contract. The older electrical audit's outward-exit pose and pad coordinates are historical. [Cable termination candidates](connector-candidates.md) document the actual JST mates and the tall Harwin J501 housing; their complete installed heights and wire exits must be included before claiming fit.

## Current CAD result

The separate **Trimix_Enclosure_A3_ConnectorReview** now contains the [photo-correct native model](../mechanical/connector-review/Trimix_Enclosure_A3_ConnectorReview_Photo.f3d). The observed header, two USB ports and SD socket replace the earlier illustrative connector arrangement. The bare tips are 13.4 mm from the front-glass datum; their world Z is 13.8 mm because the glass datum is Z0.4 mm. PCB thickness/height, small component details and actual plug identities remain labelled references.

The [initial full-interface checks](../mechanical/connector-review/interface-checks.json) find intersections between the conditional Guition socket allocation and the housing, carrier and battery holder. A local carrier brace with a 0.8 mm PCB offset clears the expanded socket allowance and retains the checked screw engagement, but that isolated result does not close the housing, other plugs or ribbon routing. It is **not adopted**. The proposed round-wire route with a 0.5 mm MD62 shift also conflicts with the lid and is rejected. Straight cable-space probes alone do not verify a physical bend.

The direct SD withdrawal allocation intersects the housing and the retained factory-frame reference. Releasing the display forward is a service option to investigate, but access through the actual retained frame and the card's eject/grip mechanism remain unmeasured. No external card opening or frame cutting is specified.

The intended wet-side wiring remains a sealed eleven-conductor chamber pigtail with dry-side disconnects. The closure shape, complete finite-radius route, insulation sizes, sensor-lead joints and seal process require further design and qualification. The [smaller-connector addendum](connector-candidates-j501-addendum.md) identifies a Samtec IDSS side-exit factory cable and compatible shorter-post header, recovering about 4.7 mm of nominal stack compared with the straight Harwin pair. This is an unadopted candidate requiring exact ordering, hole tolerances, length, current and full fit checks; the purchasing BOM and routed board are unchanged. The local clearance studies are evidence for the next correction, not a complete assembled-harness pass.

This is an engineering input and correction record. Physical fit, sealing, cable handling and powered SD tests remain pending. The immediate additional screen measurement is the exposed metal post length above its black plastic base; the existing glass-to-tip value cannot determine usable socket insertion.

## Primary manufacturer files

Guition's [model list](https://www.guition.com/model-selection) links its [development archive](https://pan.jczn1688.com/directlink/1/HMI%20display/JC4880P443C_I_W.zip). The [retrieval receipt](guition-manufacturer/source-receipt.json) records two checksum-verified archive shards and CRC-verified extraction of the schematic, dimensional drawing and specification. The remaining archive was not downloaded; no vendor program was executed. These manufacturer documents retain their original attribution and terms.

The primary schematic confirms card CLK43, CMD44, data0–3 on GPIO39–42 and LDO4 power through the fitted R4/Q1 path. It does not establish a fitted GPIO45 power-control link or card-detect signal. Actual unit revision/population and electrical measurements remain separate checks.
