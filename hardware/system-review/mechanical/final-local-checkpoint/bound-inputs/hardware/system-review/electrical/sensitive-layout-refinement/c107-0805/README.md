# C107 smaller REGN decoupler — isolated qualified-geometry proposal

Recommend **TDK C2012X5R1A476M125AC, 47µF / 10V / X5R / ±20%, real0805**, conditionally for this prototype. It preserves roughly the existing capacitor's estimated effective capacitance at REGN bias while shortening the actual routed decoupling branch. Geometry is digitally checked; startup, biased capacitance across production/temperature, ripple and enclosure fit remain unmeasured. No canonical PCB, CAM, or Fusion file was changed.

## Exact sources and capacitance

- [TI BQ25895 RevC](https://www.ti.com/lit/ds/symlink/bq25895.pdf): pin22 recommends4.7µF/10V ceramic to analogGND close to the IC; §8.2.3.1 describes bias/gate-driver/TS supply. Table7.5 specifies REGN5.6–6.4V at VBUS9V/40mA and4.7–4.8V at VBUS5V/20mA (the latter has no published maximum in that row).6.5V is a deliberately conservative review point, not a claimed normal rail voltage or approved9VUSB input.
- [Exact current TDK product](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C2012X5R1A476M125AC) and [TDK-hosted characteristic sheet](https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c2012x5r1a476m125ac.pdf):47µF±20%,10V,X5R±15%,−55..85°C; body2.0±.2×1.25±.2×1.25±.2mm. The characteristic chart is typical reference data, not a guaranteed DC-biased minimum. This retains the original capacitor's85°C maximum temperature class; verify local temperature.
- [Original TDK C3216X5R1E226M160AB](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C3216X5R1E226M160AB):22µF/25V/X5R/±20%,1206. Its archived primary curve remains in `../c107-independent/tdk-part.txt` provenance and `../../sources/c3216x5r1e226m160ab.pdf`.

At6.5V the new part's typical curve retains about22–23%; use22% for the engineering screen. The original curve retains about46%; use45%. Apply the **same** assumptions:

| Assumptions | New47µF0805 | Existing22µF1206 |
|---|---:|---:|
| Rounded typical DC-bias factor only |10.340µF|9.900µF|
| Also nominal−20% tolerance,−15% temp factor |7.031µF|6.732µF|
| Also illustrative10% aging allowance |6.328µF|6.059µF|
| Also additional illustrative20% measurement/ripple sensitivity |5.062µF|4.847µF|

These combined rows are **engineering sensitivity cases, not guaranteed manufacturer minima**. In particular, the10% aging allowance has no specified service time and is not a proven bound; the20% row is an extra sensitivity, not a measured AC correction. No manufacturer-approved combined DC/AC/temperature/life lower envelope was located. Confirm actual decoupling/ripple and startup; do not use these calculations as final capacitor or charger qualification. TI's pin recommendation is nominal4.7µF, not an explicit requirement for≥4.7µF effective under all conditions; using4.7µF as the retained-cap engineering screen adds a clear comparison basis without inventing a TI specification.

Two bounded22µF0805 alternatives were rejected for weaker margin: Murata GRM21BR61E226ME44L25V loses roughly60–65% around6–6.5V; TDK C2012X5R1V226M125AC35V loses roughly70%. Higher rated voltage alone did not establish better DC-bias performance. Their manufacturer-authored charts are archived with mirror provenance where the official document download returned403. No inventory or supplier order was made.

## Startup charge comparison

`capacitance_analysis.py` integrates visually read piecewise-linear **typical** C(V) points; this is analytical estimation, notSPICE or measurement. To4.8V: new≈145.07µC, old≈88.68µC. To6.5V: new≈166.28µC, old≈108.45µC. Thus the new capacitor needs about56–58µC more modeled charge. At a hypothetical dedicated20mA that difference corresponds to≈2.8–2.9ms; this is **not** a predicted startup delay.

TI specifies a50mA minimum REGN current-limit value only at VBUS9V and REGN3.8V. It does not establish spare cap-charging current throughout a5V startup with bias/gate/TS loads.20/40mA are voltage-characterization conditions, not guaranteed startup allocation. The220ms in §8.2.3.1 occurs before REGN enable; it is not a capacitor ramp deadline. No published maximum REGN capacitor or guaranteed startup ramp was found in the cited datasheet. Consequently no sourced contradiction was found, but startup compatibility is not proven. Keep EL13 cold/depleted-source startup and warm reconnect/ripple tests open; record the actual47µF population in those tests.

## Exact native proposal

Source: owner's immutable `c103-local2/Trimix_Analyzer.kicad_pcb`, SHA`c923d4089a2f41379cdfe414671334aef104d732ca95206d2386324e8ecde60e`. It includes the owner's C103 revision; **do not copy the whole candidate over his current board**.

Frozen candidate: `candidate/Trimix_Analyzer.kicad_pcb`, SHA`41393691dd716fe36a1ac9332ae1904d966b9017070489201ec7aef48b894cb1`.

- C107 B(13.875,79.125),0°. Exact local footprint `C107_Trial:C_TDK_C2012_Manufacturer_Reflow`. TDK reflow-land drawing: A=1.05mm gap, B=.80mm pad length, C=1.10mm pad width; all lie inside the published ranges A.9–1.2/B.7–.9/C.9–1.2. Rectangular lands centred±.925mm; package body is not scaled. Factory reflow process validation remains necessary.
- REGNpad1(12.95,79.125)→existingREGNvia(12.79,81.15),.25B. U101.22→C107.1 explicit native witness now2.9211mm total (.8898F/.2minimum +2.0313B/.25), one barrel, versus8.8841mm and two barrels. Full-item lengths include overlapping land portions; not extracted loop inductance.
- GNDpad2(14.8,79.125)→newordinary.50/.25via(16.05,78.05),1.6487mm .25B. NearestSMTsurfacegap to this via is.5500mm (L101), ownC107gap.7491mm. No drill/paste/SMT overlap.
- Seven obsolete original copper objects removed; two tracks+oneordinaryGNDvia added. No existing trace was moved or narrowed. Only C107 footprint changed. PACK, USB, SCL, C103, all other footprints and power paths are unchanged from the snapshot.
- In1 remains one contiguous GNDregion and covers the new groundbarrel; its filled area increases.64125mm² after removal of the oldREGNvia antipad. In2 remains11regions with **identical** filled geometry. No new In1signal or In2slot. This proves topology/reference coverage, not dynamic ground impedance.
- NativeKiCad10.0.6:0geometryerrors,0unconnected,0schematicparity after **isolated-only** source metadata synchronization. One inherited C103silkscreen warning remains; owner will finish that marking. C107reference is currently assembly-map-only, to avoid publishing overlapping marking.

`guarded-delta-and-ground.json` contains every original removedUUID/object, exactC107 before/after, added objects and source hashes. `guarded-patch.kicad_sexpr` contains only the add/replacement objects. `apply_guarded_delta.py --source … --out …` provides a guarded offline isolated integration path, refusing canonical output; run with the Gerbonara venv Python. The initial SWIG footprint-swap constructor saved a file but faulted on process teardown; it is an experimental scout, not the integration tool. The delivered file was independently reopened/refilled by nativeCLI and read by independent native+sexpr auditors. Use the guarded text delta, not re-running `setup.py`/`build_candidate.py`, for reproduction.

## Mechanical handoff

Max purchased body2.2×1.45×1.45mm. With.15mm assembly allowance below B.Cu Z20.5, envelope bottomZ18.90. NativeKiCad cached courtyard bounds X12.255..15.495/Y78.105..80.145. Requested new carrier opening with.30mm XY clearance: **X11.955..15.795/Y77.805..80.445**. Mapping toFusion is X=PCB_X+50.4, Y=120−PCB_Y. This area is outside the existing lower opening. A real Fusion interference/wall/support check and new opening are required before acceptance; no existing pocket or componentSTEP qualification is claimed. Coordinate with the owner's neighbouring C103B(14.6,80.7) and its separate lower-height opening.

Canonical9f274 PCB and its finished independent CAM package remain unchanged. The final merged candidate still needs fresh nativeDRC/ERC, BOM/CPL/markings/STEP/CAM and Fusion checks. This handoff is a reviewable isolated C107 improvement, not an order release.
