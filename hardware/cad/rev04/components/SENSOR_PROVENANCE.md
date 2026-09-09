# A3 sensor cartridge: component evidence

This record describes the staged source in `../scripts/chamber_a3.py`. Native
Fusion execution and interference checks are recorded separately by the assembly
builder. None of these sensor components is authenticated manufacturer STEP CAD.

| Component | Model basis | Required physical confirmation |
| --- | --- | --- |
| Honeywell AO2 / AA428-210 | Drawing-derived Ø29.3 mm body, 31.75 mm axial body and 6.5 mm M16 × 1 nose. Total nominal axial reference 38.25 mm. | Purchased variant, sealing datum, exposed membrane, thread engagement and mated connector. The additional 6.5 × 10 × 10 mm connector is an unmeasured allowance. |
| Winsen ZE07-CO | PCB 25.4 × 22.4 × 1.6 mm, Ø20 × 16.7 mm can and 3.45 mm opposite header. Rotated installed envelope **X21.75 × Y25.4 × Z22.4 mm**; no component dimensions reduced. | Actual revision, pin/header placement, support and gas-exposed face. Small header geometry and finishes are illustrative. |
| Winsen MD62 | Body 19 × 9.5 × 14 mm, oriented X14 × Y9.5 × Z19. Untrimmed 26 ± 1 mm leads reserve 27 mm along X; total installed envelope **41 × 9.5 × 19 mm**. | Four drawn lead positions and Ø0.5 mm visual thickness are illustrative. Measure lead pitch, detector marking, sensing faces, electrical support and strain relief before mounts are finalized. |
| GYBMEP / BME280 breakout | Provisional **17 × 12 × 5 mm** board allowance. PCB, metal cap and regulator are visual references. Bosch chip documentation does not establish the purchased breakout dimensions. | Board outline, header/wires, component heights, exact sensor identity, voltage and mounting. |

Primary sources:

- [Honeywell AO2 manufacturer drawing](https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/en-us/products/sensors/gas-sensors/automotive-and-emissions/documents/hon-ia-hss-automotive-ao2-o2-gas-sensor-dts-en.pdf).
- [Winsen MD62 manual, V1.3](https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf).
- [Winsen ZE07-CO manual, V1.7](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf).
- [Bosch BME280 datasheet](https://www.bosch-sensortec.com/media/boschsensortec/downloads/datasheets/bst-bme280-ds002.pdf).

Manufacturer documents and trademarks retain their respective owners' rights.
This project claims no open redistribution licence for those documents or
supplier CAD ownership. The editable reconstruction is a packaging reference.

## Nominal arrangement at 85 × 180 × 43 mm

Coordinates: +X is the viewer's left from the front, +Y up, +Z rearward.

- Manifold CO pocket: X3–35, Y130–167, Z3–36 mm. Upper row: X13–72.5,
  Y160.5–177, Z3–36 mm. The stepped upper outline clears the rear cover bosses.
- AO2 body: X39–70.75, centre Y142.5/Z21.75, radius14.65 mm. Nose: X32.5–39.
  The body and cable are dry, inside the outer housing. Only the nose faces the
  sample through a separate hand-tight adapter reference.
- CO envelope: X5.5–27.25, Y132.3–157.7, Z5.4–27.8 mm.
- MD62 with full leads: X19–60, Y163–172.5, Z8–27 mm.
- Humidity allowance: X53–70, Y162.8–174.8, Z6–11 mm. It is upstream and apart
  from the MD62 body; actual thermal influence remains untested.
- Both ports: Y162.5/Z22 mm. Inlet at the viewer's left (+X); exhaust at the
  viewer's right (−X). Ø8/Ø5 fitting references are unmeasured purchased parts.
  The internal inlet bends are at X70.75, Y162.5 and165, Z22. Lowering the AO2
  body3 mm and moving the bends5 mm inward avoids the rear housing boss during
  cartridge extraction. The dry AO2 body now reaches Y127.85; this is separate
  from the manifold's Y130 lower edge and requires the assembly service audit.
- Independent lid: Z36–38 mm. Four M2×5 screw heads end at Z40. With Cover2.4
  and CoverGap0.2, the outer-cover inside plane is40.8 mm, leaving0.8 mm.
  Its expression is `CaseDepth − Cover + CoverGap`; use the final assembly audit
  after changing those parameters. Each screw is a separate occurrence.
- Harness closure allowance: centre X17/Z31.5, Y128.7–132 mm. Actual potting,
  conductor count, gland, connector and cable bends are not established.

The gas route goes through the upstream humidity/MD62 region, down the channel
between the CO face and AO2 nose, and back through an isolated return. Bulkheads
block the direct upper inlet-to-exhaust route. The supplied Ø5 mm probe candidate
checks geometric access to these regions; it is not a flow simulation, proof of
uniform sample renewal or a response-time qualification. Avoid a direct high
velocity jet onto the CO module, as required by its manual.

## Source arithmetic and limits

- AO2-to-CO face gap = `(CaseWidth − 52.5) − 27.25`, or **5.25 mm at W85**.
  This particular packing requires W≥84.75 for a nominal Ø5 probe. Tolerances,
  actual membrane exposure and connector clearance remain physical gates.
- The rear return bore centre is Z33.5 with radius2.5, reaching Z36. The lid
  inside plane is `CaseDepth − 7`; therefore this route requires **D≥43**.
  Reducing depth to42 without repacking would truncate the route by1 mm.
- At H180 the feedthrough lower end is128.7 mm, nominally0.7 mm above the
  parent assembly's display-retainer limit128 mm. Shrinking height requires
  another clearance check; H180 is the current integration allowance.
- Selected printed sections are nominally2 mm: front and side manifold walls,
  lid, inlet-duct radius difference4.5−2.5, return floor31−29, M2 boss radial
  wall3.6−1.6, adapter10.1−8.1, and feedthrough collar4.2−2.2. These calculations
  are **not a whole-model minimum-wall analysis**.
- M2×5 screws seated at38 reach33. Insert faces are36 and their4 mm bodies
  reach32; nominal engagement is3 mm and screw tip clearance is1 mm. Blind
  pilot floors are32, with boss floors30. Exact fasteners/inserts remain
  generic references pending supplier selection and physical fit.

The lid and internal bulkheads meet at a flat contact plane. Seal stock, grooves,
compression and material compatibility are deliberately unqualified. The AO2
adapter has a simplified cylindrical M16 reference, not a modeled thread or
verified hand-tight sealing mechanism. Its thin face-seal object is an allowance,
not a specified gasket. Sensor supports and real harness strain relief must be
measured before manufacture; gas isolation and sampling performance require
bench testing.

Service intent: remove the outer rear cover, disconnect the pack and chamber
harness, remove both external fittings, and withdraw the closed cartridge to
the rear. Open its four-screw lid and unthread the AO2 on the bench. No chamber
to housing screws or in-case wrench operation are proposed.

## Retention and sensor-seat provisions

`chamber_retention_a3.py` adds three front support lands, straight lower/upper
and dry-side guides, and three stops on the rear cover. There are no additional
fasteners. Nominal lateral guide clearances are0.5 mm (0.6 mm at the opposite
shell wall); rear axial float is0.2 mm. Shallow raised front lands are supported
by the continuous front wall. The guides have no hooks across the +Z removal
path; actual retention stiffness and tolerances still require a fit prototype.

A separate stage adds labelled CO board seats/corner keepers, MD62 end contacts
and rear-lid stops, and humidity-board feet with a corner keeper. These use the
reference geometry rather than invented mounting holes. They do not establish
the real boards' free contact areas, the MD62's safe non-sensing contact faces,
or individual sensor insertion paths. Full MD62 leads remain modeled; measured
terminal support, insulation and strain relief are still required. These are
integration provisions, not fabrication-qualified sensor mountings.
