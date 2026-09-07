# Trimix enclosure — Revision 02

**Status: Editable concept built in Fusion.** The official MCP connection was used with Fusion 2705.1.11. The current model has **19 component occurrences** (20 components including the root), **50 solid bodies** and **490 timeline items**. Its [Fusion model audit](verification/model-audit.json) reports healthy features, fully constrained sketches and **zero volumetric interferences** among the modelled component occurrences. Sampled removal checks pass with the sequence below. Physical fit, practical service access, gas sealing and flow performance remain to be validated.

The new Fusion design is saved as **`Trimix_Enclosure_A1 v2`**, in the **Trimix analyzer** Fusion folder. Cloud processing is complete and there are no unsaved changes, as recorded in [cloud-save.json](verification/cloud-save.json). The original `Casing v1` document remains unchanged. The model has millimetre user parameters and named components.

## Files

- [Native Fusion design](Trimix_Enclosure_A1.f3d): editable sketches, features, parameters and component assembly; archive integrity checked.
- [STEP assembly](Trimix_Enclosure_A1.step): neutral geometry with 50 exported solids; no parametric history.
- [Review drawings](Trimix_Enclosure_A1_Review.pdf): two A3 sheets containing actual Fusion front, rear, left, right, section and rear-open views. Both pages visually inspected; not to scale or manufacturing drawings.
- [Measurement checklist](MEASUREMENTS.md): published references and the measurements required for final mounts and seals.
- [View images](views/): individual Fusion viewport exports. The rear-open view hides the outer cover and internal chamber lid; the centre section is at X = 0.

## Agreed arrangement

- The housing uses a provisional **180 mm height × 95 mm width × 60 mm depth**, with **3 mm walls**. Current side projections increase the complete model's bounding width to **107 mm**. Final dimensions depend on measured components and assembly clearance.
- Model coordinate convention: **X increases toward the viewer's left, Y points up, Z points rearward** when looking at the front. USB is on **+X** and the power button on **−X**. The front is **Z = 0**. The rear cover's nominal 3 mm allocation includes a **0.25 mm seating gap**; its current solid occupies **Z = 57.25–60 mm**, giving **2.75 mm** actual thickness.
- The front contains only the **4.3-inch portrait touchscreen** and its bezel. Use the agreed **69.41 × 117.01 mm** display envelope while confirming the hardware variant.
- The left side carries USB-C and the upper gas inlet. The right side carries the power button and upper gas exhaust. There is no external O₂ socket.
- One rear cover provides access to the battery, electronics and sensor assembly. **Six M3 screw and heat-set insert envelopes** are modelled; final boss bores, hardware selection and engagement lengths follow the chosen insert drawing and fit coupons.
- The upper sampling chamber is an independently enclosed, removable assembly, separated from the battery and electronics. Provide sealed wire feedthroughs and rear-accessible fasteners; final sealing details await component and material measurements.
- The model includes envelopes for the protected FMA two-cell holder and retained battery plug, an electronics carrier, cable-routing space and a supported, replaceable USB daughterboard mounting insert. The button centre is at **Y = 102 mm** to clear the adjacent boss; the USB daughterboard has a connector clearance slot.

## Assembly and service intent

The [service audit](verification/service-audit.json) checks temporary copies at discrete positions; it does not claim a continuous swept-volume or physical fit test. The tested sequence is:

1. Switch off and unplug USB. Remove the six rear screws and single cover, disconnect the RCY/BEC battery plug, release holder retention and withdraw the protected pack rearward.
2. For carrier/display service, disconnect side wiring and release the USB insert and button retainers. Move the USB assembly **3.1 mm inward**, then withdraw it through the rear. The panel button is removed **outward through the right side** after its internal nut and wiring are released; actual terminals must fit the measured hole.
3. Release the carrier screws and harnesses, then withdraw carrier and future PCB rearward. Remove the carrier before withdrawing the display. Keeping the button and USB assemblies installed obstructs these straight rearward paths in the present concept.
4. For chamber service, remove both external gas stubs, disconnect the sensor harness on the electronics side of the feedthrough and release the cartridge screws. The closed chamber, internal lid, seal and sensors then withdraw rearward together. Retained gas stubs obstruct that path.

All final paths were clear at the sampled positions after these prerequisites. A nominal **Ø4 × 50 mm** straight screwdriver shaft cleared the rear cover, carrier, cartridge and internal-lid screw access positions. The actual driver handle, connectors, retainers and cable bends still require physical checks. Wiring volumes reserve space; they do not model flexible harness behaviour.

The sampling path is a vented flow-through arrangement, entering at the upper left and exhausting at the upper right. The ZE07-CO clearance envelope starts at Z = 16 mm, leaving 1.5 mm beyond the top of the nominal 5 mm exhaust bore. A segmented air centreline around the AO2 neck was clear at points spaced no more than 1 mm apart. This does **not** prove a continuous 5 mm flow area, adequate mixing, response time or gas-tight seals. Keep a continuous open gas passage around the sensors and separate sample gas from the electrical compartment. Pressure-retaining tank or BCD adapters are outside this revision.

The external USB-C board supplies charging. Guition's own USB connector remains an internal service connection, accessed with the main power disconnected. The enclosure reserves a **64 × 108 mm** target for the future main PCB. The actual KiCad PCB has not been resized; its oversized placement preview is not the enclosure reference.

## Review before printing

The current solid model passes Fusion's geometry checks, including a static interference analysis with coincident faces excluded. The [parameter test](verification/parameter-regeneration.json) changed CaseWidth from 95 to 97 mm, confirmed healthy regeneration and restored 95 mm. These checks do not establish clearance for unmeasured real parts. Complete the [measurement checklist](MEASUREMENTS.md), then confirm practical rear removal, screwdriver reach, battery disconnection, cable bends and sample flow using the actual hardware.

The first planned print is a **PLA fit prototype for the Bambu H2D**, following review in Fusion. Final material, gas seals, thermal behaviour and weather sealing remain to be qualified. The connector's IP67 rating does not establish a rating for the complete enclosure.

## Editing and repeatable checks

Open the native file in Fusion and use **Modify → Change Parameters** for the provisional case dimensions, wall, display and port positions. Recheck component clearance after every dimensional change; changing the enclosure size does not automatically repack fixed internal envelopes. Named sketch and extrusion features remain available in the timeline. The retained `A-A centre section / X=0 / review only` analysis can be enabled in the browser.

The scripts use Autodesk's official local MCP endpoint at `http://127.0.0.1:27182/mcp`. `fusion_mcp.py` sends an explicitly chosen script into Fusion; it does not replace Fusion's geometry kernel. `fusion_audit.py`, `check_parameters.py` and `service_audit.py` record their results under `verification/`. The parameter check temporarily changes and restores width; the service check uses transient copies only.

`build_enclosure.py` is a staged construction record, not an automatic rebuild-on-open add-in. For a deliberately new design, its stages are `create_design`, `build_shell`, `build_chamber`, `build_hardware`, `refine_fit`, `finish_mechanics`, then `style_model`. Do not replay creation stages into the delivered document. The guarded `correct_front_reference` function records a one-time correction of the earlier build; current construction code already uses the corrected orientation.
