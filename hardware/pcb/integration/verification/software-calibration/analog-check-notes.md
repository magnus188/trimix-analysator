# Sensor ADC and fixed-reference review

U401 and U502 now use TI ADS122C04IPWR in the PW TSSOP-16 package. RN501 replaces the three-part adjustable reference branch with a nominal 2 kΩ / 2 kΩ matched pair. These are design and calculation checks; no gas, sensor-drift, assembled-PCB or cable measurements were performed.

| Item | Implemented connection |
|---|---|
| U401 address | A1 = GND, A0 = GND: 0x40 |
| U502 address | A1 = GND, A0 = HOST_3V3: 0x41 |
| ADC supplies | AVDD and DVDD = HOST_3V3; AVSS and DGND = GND |
| Reset / readiness | RESET tied to DVDD; DRDY deliberately unconnected; firmware polls readiness |
| Reference | Internal 2.048 V selected by firmware; unused REFP and REFN deliberately unconnected |
| O₂ inputs | AIN0−AIN1 = channel A; AIN2−AIN3 = channel B |
| He inputs | AIN0−AIN1 = HE_REF−HE_SENSE; AIN2 = excitation/2; AIN3 = O₂ bias |
| Conversion contract | 20 SPS normal, signed results; IDAC and burn-out current sources off |
| RN501 | Vishay ACASN2001U2001P1AT; R1 pins1–4, R2 pins2–3; pins2+4 form HE_REF |
| RN501 performance grade | U grade: 0.1% absolute tolerance, 0.05% relative matching, 10 ppm/K absolute TCR and 5 ppm/K relative tracking, using Vishay's medial-axis definitions |

The complete manufacturer order code is selected using Vishay's ordering table; distributor stock and lead time are unconfirmed. The local IEC footprint uses pads 0.70 × 0.65 mm, opposing inner gap 0.60 mm and inter-element gap 0.35 mm. Its drawing-derived 3D body is separately identified as a reference model.

The PW pin map is 1 A0, 2 A1, 3 RESET, 4 DGND, 5 AVSS, 6 AIN3, 7 AIN2, 8 REFN, 9 REFP, 10 AIN1, 11 AIN0, 12 AVDD, 13 DVDD, 14 DRDY, 15 SDA and 16 SCL. RESET and DRDY are active low. The PW numbering must not be replaced by the different RTE/WQFN numbering. [TI datasheet, sections5,8.5.1.1 and9.1.3](https://www.ti.com/lit/ds/symlink/ads122c04.pdf), [Vishay array specification, pages2–3 and8](https://www.vishay.com/doc?28770=), [Vishay recommended lands, page2](https://www.vishay.com/doc?28950=).

## Calculated headroom

At O₂ gain8, the nominal differential range is ±0.256 V. TI equation7 gives the individual-input bounds

`0.2 + |Vin|max × (gain−4)/8 ≤ AIN ≤ AVDD − 0.2 − |Vin|max × (gain−4)/8`.

With AVDD3.3 V and a full-scale 0.256 V difference, this is **0.328–2.972 V per input**. A symmetric pair around the nominal1.65 V bias reaches only1.522–1.778 V. Thus the assumed bias and signal range have electronic headroom. Confirm actual cell outputs, bias tolerance, leakage and transient extremes before authorizing this gain. Gain8 necessarily enables the PGA; its analog amplifier gain is2 and its switched-capacitor gain is4.

For He, gain1 with PGA bypass allows the wide differential range needed before the real MD62 bridge offset/span are known. A nominal1.5 V reference against a0–3 V midpoint gives a difference within±1.5 V; this ideal voltage envelope is not a measured sensor specification. Analog input voltage limits and startup/shutdown sequencing still apply. Increasing gain requires measured full-range and drift headroom.

The current schematic instructs initial gain1/PGA bypass, followed by a checked gain selection. Firmware must keep each calibration associated with its channel, polarity, PGA setting and reference configuration. A changed gain requires the corresponding ADC-offset handling and a valid gas calibration.

## Calculated filtering and timing

The following are first-order approximations from component values; they do not bound unmeasured sensor impedance, cable pickup, capacitor tolerance or temperature drift.

| Circuit | Nominal calculation | Implication |
|---|---|---|
| O₂ differential filter | `Ceff ≈ 1µF + 10nF/2 = 1.005µF`; `τ ≈ (200Ω + cell/cable source impedance) × Ceff`, neglecting the2 MΩ bias shunt | Zero-source-impedance limit: τ0.201 ms, corner≈792 Hz; real impedance increases settling time |
| He differential filter | Reference Thevenin resistance1 kΩ; `τ ≈ (1200Ω + MD62 midpoint source impedance) × 1.005µF` | Minimum nominal τ1.206 ms, corner≤132 Hz; no claimed upper bound without measuring the sensor |
| Excitation monitor | `(10k || 10k) × 100n = 0.5 ms` | Board supply monitoring only; it cannot measure remote cable drop |
| O₂ bias node | `(10k || 10k) × 1µ = 5 ms` | Also allow the sensor input common-mode networks to settle |
| O₂ input common-mode network | Approximate1 MΩ × 10 nF =10 ms per input with a stiff bias source | Startup involves a coupled RC network; a fixed delay is not a sensor warm-up criterion |

The two1 MΩ bias resistors present approximately2 MΩ differential loading to each oxygen cell. Validate that loading and leakage with both real sensor types. Do not infer the MD62 source impedance from its maximum120 mA consumption; that current limit does not provide the resistance upper bound needed for a guaranteed RC settling time.

The ADC's digital filter settles in one conversion cycle, and nominal20 SPS single-shot conversion takes50.01 ms. Wait for fresh readiness after each MUX or gain change; include bus time and oscillator tolerance in timeout limits. Analog filter settling, bias startup, MD62 heating and stable gas flow are separate requirements. Two O₂ pairs share one ADC, so they are read sequentially. [TI datasheet, equations5–7, Table12 and sections8.3.5,9.1.4 and9.2.1.2](https://www.ti.com/lit/ds/symlink/ads122c04.pdf).

## Physical checks still required

- Measure both ADC supplies and every analog input relative to GND during steady operation, turn-on, turn-off, sensor disconnection and reference-gas transitions.
- Confirm C407/C508 locally decouple AVDD–AVSS and C408/C509 locally decouple DVDD–DGND, with short return paths. Their100 nF /1 µF values each meet the minimum specified capacitance; placement remains important.
- Measure shorted-input and assembled-sensor noise, gain-specific ADC offset, input leakage, cable pickup and mains/switching interference. Resolution labels are not a demonstrated gas accuracy.
- Check both oxygen channels for open/reversed/shorted cells. With the current passive bias, a disconnected cell can resemble a near-zero differential reading; calibration alone cannot diagnose every fault.
- Measure MD62 warm-up, zero/span over known He/O₂ mixtures, temperature, humidity, pressure and flow. Confirm excitation at the sensor, not only at the regulator.
- Verify repeatability after restart, calibration persistence, stale/invalid calibration rejection and drift/service prompts. Unknown samples must never automatically become a zero-gas reference.
