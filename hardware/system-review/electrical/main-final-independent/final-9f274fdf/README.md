# Final main PCB independent CAM review

The frozen board is SHA256 **9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f**; the matching XML netlist is **4512ae125c98cf091a24bf806f0ca78e14d59bcaffe59626d95386f100e0e609**. The reviewed source/CAM bundle is `routing-candidate/final-cleanup/frozen-bundle/`. This review reads its bytes without KiCad's API, connectivity or rendering engine and does not change the board, schematic or manufacturing inputs.

**Export equivalence and physical copper connectivity pass. This is not an order release.** Supplier process acceptance and electrical/thermal/transient/fit tests remain separate. `verification-receipt.json` binds the exact inputs, reader code, outputs and limitations.

## Independent results

- **44/44 general checks pass** in `audit.json`: four copper layers, pad shapes/positions/nets, all saved zone fill, mask and paste apertures, track/via/drill geometry, outline, placement, reference BOM and unchanged input bytes.
- **501 distinct physical pin/net mappings** match the XML. The keyed J301 header omits a purchased post; its unused PCB pad/hole7 remains present and matches the XML. That distinction is intentional.
- **2,280 tracks, 301 routed vias, 388 drill/slot objects, 547 physical pad objects and 169 footprints** are reconciled. Copper graph construction uses 5,171 physical nodes and 5,185 spatial candidate comparisons; all **117 named-net components are connected**, with no mixed-net shorts or unattributed isolated copper.
- Graph controls detect removed bridges, same-pin disconnected copper, unplated versus plated layer crossings, separate region islands and injected shorts. Equal labels and presumed IC-internal connections never join copper.
- **20/20 assembly-ledger checks pass** in `assembly-ledger-audit.json`: factory24 + manual121 + DNP6 + PCB features18 =169. Purchasing comprises145 populated parts. Factory CPL is the exact unchanged24-row subset; no manual, DNP or board-only feature leaks into it. All ICs, the resistor network, actual0402 parts and custom-land Q110 are factory-assigned.
- **146 visible native reference declarations** match `marking-legend.csv`;23 dense-area references are explicitly available only through the assembly map/native Fab view. Actual Gerber views were inspected, but this is not an OCR claim or proof every label is convenient to read on a manufactured board.

The independent clearance screen uses0.15mm, separate from native0.20mm routing rules. Its only lower observations are the two **0.125mm B-copper gaps at the exact masked U115.3 cap extension**, governed by the reviewed0.12mm local rule. Removing only the0.40mm disk from the relevant exported copper leaves the rest of each entire net pair at or above the ordinary screen threshold. This is a coordinate/geometry check, not a whole-net waiver. Native rule compliance is separately recorded by the owner.

## Special process, stencil and ordinary-hole checks

`process-audit.json` independently checks these three routed resin-filled/copper-capped sites against actual Gerber copper, drill hits and mask/paste geometry:

| Native PCB centre, mm | Net | Land / hole, mm | Aperture treatment |
| --- | --- | --- | --- |
|13.6,89.775|USB_CC_INT_N|0.40 /0.20|Original U115.3 B aperture only; cap extension masked; no F opening|
|13.6,91.0|USB_OVP_UVLO|0.50 /0.25|Original compound U115.1 B aperture retained; no F opening|
|17.95,87.925|USB_OVP_UVLO|0.50 /0.25|Original R125.1 B aperture retained; no F opening|

The two UVLO vias inherit both-face tenting from native board setup; the CC via states it locally. Actual exported openings, rather than the mere absence of a local flag, govern the aperture check. Filling and capping are explicit on all three. Q110 retains its exact DMN2056U manufacturer rectangular0.90×0.80mm lands and pin centres. The ordinary C708 GND via is at **4.95,63.875**, **0.60/0.30mm**, and produces no ordinary populated-pad paste/bore encounter.

The first full-paste pass exposed the documented **C706 DNP paste overlap with an ordinary bore**. It was not waived because the part is unpopulated. The owner supplied a separate derived `factory-stencil/cam/` output; independent union-geometry comparison proves it contains **only the original24 factory parts' apertures**, with manual/DNP/feature apertures removed. The native source/full-paste exports remain unchanged. Full native paste is a failing counterexample to the factory-only stencil contract. The factory stencil still requires assembler approval.

Package thermal holes were checked as well as routed vias. **12 thermal bores overlap factory paste:8 at U201 and4 at U101.** These are not ordinary open-via approvals. The exact `fill-cap-process/required-fill-cap-holes.csv` lists **all24 package thermal holes (15U201 +9U101) plus3 signal VIPPO**, and is reconciled to native UUID, reference/pin/net, coordinates and actual plated drill hits. The required process is nonconductive resin fill, planarization and copper cap on both faces. A routed-row parser alias was corrected to its actual native UUID before final verification; geometry and native files did not change.

The process audit intentionally keeps **one unsatisfied factory-approval hold** for thermal-hole/paste processing. It must not be interpreted as a geometry mismatch or as a waived assembly risk. None of the27 holes has a supplier quote, flatness/voiding acceptance or physical reflow result in this review. Native metadata, copper Gerbers and Excellon tools cannot establish those process properties.

## Visual inspection and limits

Generated directly from actual Gerber bytes and inspected: `F-Cu.png`, `B-Cu.png`, `In1-Cu.png`, `In2-Cu.png`, `U115-copper-paste.png` and `U201-copper-paste.png`. Bottom copper is intentionally shown in top coordinates, so its silkscreen appears mirrored. In1 shows the continuous reference-plane layout; the In2 lower regions and power/control crossings are visible. Root's separate ground/current-path review owns electrical return-path and load-path acceptance. These renders do not substitute for that review.

The detailed U115 view retains the split physical corner lands and the masked cap extension. U201 retains its four custom paste sections and extended EP lands. Filled holes remain visible in raw drill data because Excellon does not encode the later resin/capping operation.

No claim is made for component sourcing, manual-soldering yield, final stencil thickness, cap flatness, current/thermal ratings, regulator stability, analogue accuracy, ESD/OVP survival, battery charging qualification or enclosure fit. The EL11 transient gate remains open. No fabrication or assembly upload, purchase or physical test occurred.

## Reproduction

Run the three scripts in the parent directory with the frozen board/CAM paths:

- `audit_exports.py --board … --netlist … --cam … --bom …/assembly-reference-map.csv --out …`
- `audit_assembly_ledgers.py --board … --cam … --expected-sha256 9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f --out …`
- `audit_final_process.py --board … --cam … --factory-cam …/factory-stencil/cam --fill-cap-table …/fill-cap-process/required-fill-cap-holes.csv --expected-sha256 9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f --out …`

Runtime: `/tmp/trimix-gerbonara-venv/bin/python`. The general and ledger commands return0 when their checks pass. The process command intentionally returns1 while the explicitly reported factory-approval hold is unresolved; its other check results remain separate and inspectable.
