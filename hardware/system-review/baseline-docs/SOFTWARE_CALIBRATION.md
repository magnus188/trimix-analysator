# Software calibration — existing sensors, upgraded electronics

This revision keeps AO₂, R17JJ-CCR and MD62. It replaces the two ADC chips and the helium trimmer, and adds real acquisition, individual calibration records and a touchscreen workflow. **The accuracy targets remain unproven: ±0.2 percentage points O₂ and ±0.5 points He over the conditions actually tested.** No physical gas measurements were performed during this implementation.

The main PCB is still an unrouted placement. Finish routing and the electrical/thermal review before manufacture. Showcase, enclosure printing and community release preparation remain paused.

## What changed on the board

| Marking | Part / purpose |
|---|---|
| U401 | ADS122C04IPWR, TSSOP-16; reads AO₂ and JJ-CCR sequentially; address **0x40** |
| U502 | ADS122C04IPWR, TSSOP-16; reads MD62 and voltage diagnostics; address **0x41** |
| RN501 | Vishay **ACASN2001U2001P1AT**, two matched 2 kΩ resistors making a fixed half-excitation reference |
| RV501, R502, R503 | Removed; the matched array replaces this adjustable branch |
| J401 / J402 | Existing AO₂ / JJ-CCR connectors in the approved positions; no sensor replacement |
| J501 | Existing MD62 connection; regulated **3.0 V** excitation retained |

RN501 is a selected manufacturer order code; distributor stock and lead time still need checking. Its custom lands follow Vishay's IEC recommendation. Its nominal 3D body is drawing-derived, not exact manufacturer CAD. See the [component key](pcb/integration/reference/COMPONENT_REFERENCE.md), [CSV BOM/reference list](pcb/integration/reference/COMPONENT_REFERENCE.csv), [assembly map](pcb/integration/reference/main-assembly.svg) and [analog review](pcb/integration/verification/software-calibration/analog-check-notes.md).

The ADC samples a voltage. Software subtracts the measured zero offset and applies a measured sensitivity. A fixed reference is sufficient because software can correct the offset **provided the original voltage is inside the ADC's usable range**. It cannot recover a clipped signal, identify an unknown gas, or correct an unmeasured environmental dependency.

## Acquisition settings

Both converters use the internal 2.048 V reference, normal **20 samples/s conversion rate**, single-shot operation, and no IDAC or burnout excitation currents. AO₂ and JJ-CCR use gain 8 with the PGA enabled (±256 mV). MD62 uses gain 1 with PGA bypass (±2.048 V). Voltage diagnostics use gain 1 with PGA bypass.

The driver resets and checks registers, writes and reads back each configuration, allows 100 ms for analog settling, clears old conversion data, starts a new conversion and polls for fresh readiness with a timeout. A nominal conversion takes about 50 ms. **20 samples/s is the ADC setting, not the delivered rate for each gas:** sequential channels, voltage diagnostics, settling and bus/task delays make the published rate lower. No helium constants from the inspiration repository are used. [TI ADS122C04 datasheet](https://www.ti.com/lit/ds/symlink/ads122c04.pdf)

The dedicated external I²C bus uses GPIO28/29 and addresses 0x40/0x41. The touchscreen bus on GPIO7/8 remains separate. The acquisition task enables the MD62 after ADC startup checks and disables its heater on acquisition/excitation faults. An excitation fault is latched until restart. It monitors the board's 3.0 V excitation and the O₂ bias, but cannot measure voltage drop in the remote sensor cable.

The initial 180-second MD62 warm-up lockout and 10-second electrical-stability window are **provisional settings**, not evidence that the sensor has reached thermal equilibrium. O₂ has a provisional 10-second startup delay. The stability gates start at 10 µV peak-to-peak for O₂ and 30 µV for MD62, with a tighter early/late-window drift check; characterize these with the assembled system.

## Touchscreen procedure

1. Open **Settings → Calibration** and select **AO₂ oxygen**, **JJ-CCR oxygen** or **Helium (MD62)**. Each channel has independent readings, draft points and saved corrections.
2. Apply the first known reference gas at the intended controlled flow and near-atmospheric chamber pressure. Enter its known O₂ and He percentages, reference/cylinder ID and, if available, the reference uncertainty in percentage points. The first point is a baseline; it is not automatically assumed to be zero.
3. Wait for warm-up, fault-free readings and a stable window. Capture the baseline. A true zero correction requires a suitable known zero gas; a baseline above zero makes the zero an extrapolation.
4. Apply a second known mixture with enough concentration and voltage separation, enter its composition/ID/uncertainty, wait again and capture the span. The draft needs at least 5 percentage points of concentration separation and a signal span comfortably greater than measured noise.
5. Review both points and select **Save channel calibration**. A rejected capture, unstable/stale/faulty reading, insufficient span or storage failure leaves the previous valid calibration in use. **Discard** clears only the draft.
6. Repeat for the other channels. Verify each saved record by restarting the device and rechecking a known gas. Simulator practice records are isolated from hardware records and last only for that simulator process.

The current correction is `percent = (voltage − zero_voltage) × sensitivity`. Hardware records are stored in NVS with per-channel identity, ADC acquisition configuration/gain, version/revision and CRC. A changed gain or acquisition revision invalidates incompatible saved corrections. An inactive record is written and verified before switching the active record. Two-point calibration remains a **bench correction**, particularly for MD62. It does not qualify the device's accuracy. Unknown reference uncertainty is allowed for exploration and remains explicitly unqualified; the record notes whether the entered uncertainty meets a provisional quarter-target allocation (0.05 points O₂ / 0.125 points He). This is only one contribution to the full uncertainty budget.

The physical live screen labels results as calibration/bench status and withholds derived gas claims while helium characterization is unvalidated. Both oxygen channels remain visible independently; a failed AO₂ reading is not silently replaced by JJ-CCR. A disconnected passive oxygen cell can resemble a true zero signal with this circuit, so electrical fault flags cannot detect every disconnected or failed cell. Known-gas functional checks remain necessary.

## MD62 characterization and validation checklist

All boxes below are **pending physical work**. Do not mark a box complete from CAD or software tests.

- [ ] Record actual sensor identifiers, installation orientation, cell age, reference analyzer model/serial/calibration status, certificate uncertainty, gas composition and cylinder/reference IDs.
- [ ] Condition the MD62 according to the applicable Winsen manual and storage history. The reviewed guidance calls for at least 8 hours after short storage and longer recovery after extended storage; check the exact storage-duration table rather than using the daily startup timer. [Winsen MD62 manual](https://www.winsen-sensor.com/d/files/thermal/md62.pdf)
- [ ] Verify connector polarity, 3.0 ±0.1 V at the MD62 **under load**, ADC supplies, bias and all ADC input voltages during power-on, power-off and sensor disconnection. Check input leakage/back-powering and analog settling after MUX/gain changes.
- [ ] Measure shorted-input noise and sensor-connected noise. Record raw codes and volts, clipping, supply ripple, repeated cold starts, warm-up trajectories and restart persistence. Keep analog input filters and local supply-capacitor return paths short during routing.
- [ ] Determine thermal warm-up from repeated cold starts and actual drift, including the final enclosure. Adjust the provisional timer/stability thresholds only from the measurements.
- [ ] Obtain dive-shop reference mixtures spanning the intended He range and **several O₂ fractions**, including zero-He mixtures. Repeat each measurement and change the measurement order; avoid fitting a curve to one sequence of warming/drift.
- [ ] Reserve entire mixtures and separate measurement runs as validation data **before fitting**. Use them only to test the proposed correction, not to tune it. Include independent days/restarts where practical.
- [ ] Record chamber temperature, humidity, pressure and flow, ambient conditions, elapsed heater-on time and battery voltage. Repeat on battery, USB-A→USB-C charging and USB-C→USB-C charging. Charge-system commissioning requirements still apply.
- [ ] Compare a simple linear helium correction with composition/environment-dependent candidates using the measured data. Select additional terms only if they improve held-out results and remain physically plausible. The firmware contains no fitted nonlinear MD62 helium curve yet because no measured dataset exists.
- [ ] Report bias, repeatability, worst observed error, environmental/gas range, number of independent runs and reference-analyzer uncertainty. Include reference uncertainty, repeatability, resolution, drift and environmental sensitivity in an uncertainty budget. A low ADC noise figure does not establish gas accuracy.
- [ ] Check oxygen-cell open/short/reversed and low-output behavior; compare both channels against known gas. Check MD62 heater/cable faults, stale ADC/CO data and fault recovery. Confirm safe shutdown and charging behavior separately.
- [ ] Validate actual elbows, mating plugs, solder, cable bends and battery disconnection in the enclosure before final placement/routing lock.

Use [characterization-log.csv](pcb/integration/verification/software-calibration/characterization-log.csv) as a manual bench log. It is a blank template, not an implemented logger or measured dataset. The current firmware records environment as unavailable until a physical environmental-sensor driver is implemented; use independent instruments and write readings in the log. Calendar-age reminders and automatic aging-based recalibration prompts are not implemented.

## CO remains CO

The ZE07-CO UART decoder receives documented 9600-baud frames, checks framing/checksum, observes warm-up and rejects stale data. It sends **no recalibration commands**. Current CO readings are separate from CO₂, and legacy CO₂ history stays identified as CO₂ when records are migrated. No CO₂ concentration is inferred from MD62 helium mode. The ZE07's humidity range and manufacturer restrictions still apply. [Winsen ZE07-CO manual](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf)

## Digital verification and remaining scope

The [verification package](pcb/integration/verification/software-calibration/) contains schematic, PCB, native Fusion and software/UI evidence. Main-board placement has 131 footprints, 374 numbered pad/net assignments, four copper layers and unchanged 1.6 mm thickness. It preserves all connectors, both screw datums and the enclosure exterior. Native ERC and schematic parity are zero. There are no native courtyard collisions or copper-edge failures below 0.50 mm; **39 pre-existing fabrication findings and 295 unrouted connections remain**.

Fusion's revised main-board/carrier solid checks and 28 mm rearward service sweep pass for the modeled geometry. The native archive reopens with 834 solids and unchanged total volume. Purchased-part approximations, the actual SMB elbow and the previously unresolved GCT connector-model comparison remain open; this is not an overall physical fit approval. No enclosure resizing or purchased-part scaling was used for this change.

Neither O₂ nor He target accuracy is demonstrated. The new driver is build-tested, not flashed or exercised against the actual board. Battery-gauge, charger, humidity-driver and hardware shutdown integration are separate remaining work. Keep the MD62 unless measured results demonstrate a limitation that better electronics and an evidence-based correction cannot resolve.
