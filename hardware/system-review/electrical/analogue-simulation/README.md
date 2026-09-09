# O₂ and helium passive-filter study

**Result:** the selected resistor/capacitor networks are plausible for low-impedance sensors, but the unknown sensor impedance prevents a guaranteed settling or gas-accuracy claim. The board resistors' calculated thermal noise is well below the ADC's typical noise. Input-current error, real sensor behaviour and environmental drift remain more consequential uncertainties.

This is a reproducible **linear passive nodal analysis**, not an ngspice run, a vendor IC-model simulation or a hardware measurement. No production files were changed. It uses the frozen `input-netlist.xml` and the approved O₂ profile 1 / He profile 2.

## Model and verification

`simulate_filters.py` models both oxygen inputs, their four 1 MΩ bias links, the shared 10 kΩ/10 kΩ midpoint and all seven filter capacitors. Exactly one floating Thevenin oxygen source is installed; the other connector is open. AO₂ and JJ-CCR have electrically identical filters, so the selected input is interchangeable in this model. For helium, the fixed reference has the RN501 1 kΩ Thevenin resistance, R506 is 680 Ω, and R507 is 680 Ω plus the assumed MD62 midpoint source resistance. The sign remains **REF − SENSE**.

The nodal equations are `C dv/dt + G v = b`. Generalized symmetric eigenvalues give the step response. Each resistor contributes one-sided Norton noise `4 k T/R`; integrating its squared transfer function gives that resistor's output variance. All resistor noise sources are uncorrelated and at 25 °C. This is Johnson noise only, excluding excess/flicker noise. The method follows [TI's thermal-noise equations](https://www.ti.com/lit/ab/sboa345/sboa345.pdf).

The run evaluated **394,752 tolerance corners**: 16,384 O₂ corners and 64 helium corners per assumed source impedance and scenario. It includes independent input-capacitor and shared-bias mismatch. Source resistances are **0, 100 Ω, 1 kΩ, 10 kΩ, 100 kΩ and 1 MΩ**, selected for sensitivity exploration; none is a measured sensor value or a manufacturer source-impedance bound. A one-volt mathematical step normalizes transfer gain; it is not a proposed one-volt O₂ test stimulus.

Checks passed: generalized-eigen and independent SciPy matrix-exponential responses differ by at most 2.14 × 10⁻¹⁴; integrated resistor variances agree with `kT · dᵀ C⁻¹ d`; numerical integration of the noise spectrum over 10⁻⁶–10⁶ Hz agrees within 0.5% including its omitted tails. The full and reduced nominal symmetric oxygen models agree to 1.23 × 10⁻¹⁵. These are numerical consistency checks, not circuit certification. Corner extrema apply to the enumerated linear models, not unspecified semiconductor or sensor behaviour.

## Loading and settling

The symmetric oxygen reduction is:

`gain = 2 MΩ / (2 MΩ + Rs + 200 Ω)`

`tau = ((Rs + 200 Ω) || 2 MΩ) × (1 µF + 10 nF/2)`

For ideal high-impedance ADC pins, helium's passive DC gain is one: capacitors become open circuits. Its nominal differential approximation is `tau ≈ (Rs + 1 kΩ + 2×680 Ω) × 1.005 µF`. The actual helium model includes both grounded capacitors and the unequal arm resistances, so it resolves two poles rather than forcing a one-pole fit.

| Assumed sensor Rs | O₂ DC gain, initial-tolerance corners | O₂ largest remaining step at 100 ms | He largest remaining step at 100 ms |
| --- | --- | --- | --- |
| 0 Ω | 0.99989890–0.99990110 | <0.000001% | Below numerical resolution |
| 1 kΩ | 0.99939421–0.99940639 | <0.000001% | <0.000001% |
| 10 kΩ | 0.99487479–0.99497596 | 0.01346% | 0.06777% |
| 100 kΩ | 0.95183146–0.95274040 | 38.77% | 41.50% |

These percentages refer to an **electrical voltage step**, not gas percentage points. Constant attenuation can be included in calibration; changes in source resistance with age, gas or temperature can change that attenuation after calibration. At 10 kΩ, adding the conservative temperature/high-capacitance scenario increases the 100 ms residual to about 0.0431% O₂ and 0.1757% He. Thus 100 ms cannot be called universally adequate.

An open oxygen input has a nominal **2.01 s** differential discharge constant; initial R/C corners span **1.79091–2.23311 s** in the symmetric reduction. Nominal residual is 95.15% after 100 ms, 0.6908% after 10 s, and 0.004772% after 20 s. Real leakage and ADC switching can dominate that open-input behaviour. Warm-up and a stable-history gate reduce risk but do not establish physical thermal or gas settling. The CSV's *slowest network pole* can belong to the unused oxygen input; it is not necessarily the selected channel's observed settling time.

The driver waits 100 ms after configuration and then starts a fresh conversion. [ADS122C04 Rev B](https://www.ti.com/lit/ds/symlink/ads122c04.pdf), sections 7.1 and 8.4, describes the 20 SPS conversion setting and single-cycle digital-filter settling. This does not mean the application delivers 20 gas frames per second, nor that its digital filter is an ideal 10 Hz brick wall. This study deliberately does not simulate that filter, charge injection, aliasing or real source recovery after MUX changes.

## Noise and input current

At 25 °C, all modeled resistors together give **0.0640 µV RMS** at either differential ADC input when integrated from zero to infinite frequency. The maximum initial-capacitance corner is **0.06746 µV RMS**. Including the low X7R temperature coefficient corner raises it to **0.07317 µV RMS**, before DC-bias/aging uncertainty. At a different common resistor temperature, this Johnson-noise result scales by `sqrt(T/298.15)`. Separately reported board-only noise excludes thermal noise attributed to the *assumed* sensor resistance.

TI's shorted-input typical noise is **0.64 µV RMS at gain 8** for O₂ and **5.04 µV RMS at gain 1 with PGA bypassed** for He, normal mode at 20 SPS. These are typical measurements, not maximum guarantees. The selected ADC's nominal code increments are 30.52 nV and 244.14 nV respectively. Nominal 24-bit resolution is not 24-bit measurement accuracy. Even quadrature addition of the largest stated passive thermal term to the typical ADC term would scarcely change them; it would still exclude the larger unknown errors.

As a requirement calculation only, 5.04 µV RMS ADC noise would require at least **30.24 µV per He percentage point** for three standard deviations to fit within ±0.5 percentage points. Allocating one quarter of that target to this noise term requires **120.96 µV/percentage point**. No measured MD62 sensitivity is available to close either requirement, and Gaussian/independent-noise assumptions need physical verification.

TI lists input-current figures as **typical only**: approximately 1 nA with PGA enabled and 5 nA when bypassed under the stated test conditions. `results.json` therefore reports transfer sensitivity per injected nA rather than inventing a guaranteed input resistance. With an assumed 10 kΩ oxygen source, 1 nA into just one ADC input moves the differential voltage by about **5.074 µV**. For helium with zero assumed midpoint resistance, the reference input sensitivity is **1.68 µV/nA** and the sense input is **−0.68 µV/nA**. This shows why ADC leakage/input-current drift can matter more than resistor thermal noise. The two-pin opposing-current examples are sensitivity cases, not TI worst-case limits.

## Component tolerance and ADC headroom

- R401/R402/R405/R406: 100 Ω, 0.1%, YAGEO `RT0603BRD07100RL`; R506/R507: 680 Ω, 0.1%, `RT0603BRD07680RL`; 10 kΩ divider resistors use `RT0603BRD0710KL`. The **D** TCR code is 25 ppm/°C in the [YAGEO RT specification](https://yageogroup.com/content/datasheet/asset/file/pyu-rt_1-to-0-01_rohs_l).
- The four 1 MΩ `RC0603FR-071ML` parts have 1% initial tolerance and 100 ppm/°C for this value/package in the [YAGEO RC specification](https://yageogroup.com/content/datasheet/asset/file/PYU-RC_GROUP_51_ROHS_L). Temperature scenarios conservatively add the largest excursion for ±25 K from 25 °C: 0.0625% RT and 0.25% RC. This is a scenario, not a validated product operating range.
- RN501 `ACASN2001U2001P1AT` is a matched 2 kΩ pair. [Vishay's U grade](https://www.vishay.com/doc?28770=) specifies 0.1% absolute/0.05% relative tolerance and 10/5 ppm/K absolute/relative TCR. The simulation conservatively bounds its Thevenin resistance using independent absolute limits and the larger RT thermal envelope; it does not take credit for the better matching. A nominal fixed half-excitation reference is not a calibrated zero voltage.
- C401/C404/C505 and the bias capacitor use [KEMET C0603C105K4RACTU](https://search.kemet.com/component-documentation/download/specsheet/C0603C105K4RACTU), 1 µF, 16 V, 10%, X7R. The sheet specifies ±15% TCC at zero DC, 3% aging loss per decade hour relative to 48 hours, and 100 MΩ insulation resistance. A separate **conditional 100 MΩ differential-leakage** case illustrates possible DC loading; it does not certify hot/humid leakage. The four oxygen and two helium common-mode capacitors are [TDK C1608X7R1H103K080AA](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1608X7R1H103K080AA), 10 nF, 50 V, 10%, X7R.
- Initial capacitor corners are 0.9–1.1 times nominal. Low/high TCC cases extend those to 0.765–1.265 times nominal. The additional 50%-effective-capacitance case is explicitly hypothetical. Typical bias curves do not provide a guaranteed minimum capacitance under all DC/AC voltage, temperature, aging and lot conditions. ESR, dielectric absorption, microphonics and excess noise are excluded.

For O₂ gain 8, the internal-reference initial tolerance alone gives ±0.255616 to ±0.256384 V full scale. At an assumed 3.3 V host rail, the resistor-bias/input envelope at that full scale is 1.51888–1.78112 V. TI equation 7 permits 0.32819–2.97181 V, leaving approximately **1.19 V conditional common-mode margin**. This ignores leakage, cable faults and supply dynamics. The JSON also evaluates assumed 3.0 V and 3.6 V rails; none substitutes for measuring the host rail.

The [TPS7A2030 output limit](https://www.ti.com/lit/ds/symlink/tps7a20.pdf) of nominal 3.0 V ±1.5% permits 3.045 V under its specified conditions. If the MD62 midpoint can approach that rail, PGA-bypassed U502 requires HOST ≥**2.945 V**, using TI's AVDD + 0.1 V usable-input limit. This is a conditional passive envelope, not an established MD62 range. Nominal supply, board excitation monitoring and firmware bias checks do not prove all source/power-fault conditions safe. No LDO or BQ charging/switching model was used; their ripple, dropout, thermal effects, PCB coupling and cable drops remain outside this linear passive study.

## Reproduce and use the evidence

Create a temporary Python virtual environment, install `requirements.txt`, then run:

```sh
python simulate_filters.py
```

The script reads its saved netlist and writes only inside this evidence folder. Delete or replace that *snapshot* deliberately when reviewing a later circuit, then re-audit the topology and MPN assertions. `corner-sweep.csv`, `noise-and-nominal.json`, `results.json`, `filter-study.png`/`.pdf` and `run.log` contain the outputs. `evidence.json` binds source and output hashes. The plot was visually inspected for labels, axes and completeness.

Before ordering or accepting gas accuracy, measure actual sensor source impedance/step settling, shorted-input and sensor-connected noise, known-reference residuals, supply/load/temperature drift, leakage and cable handling effects. Keep failed/unperformed physical checks pending. No gas accuracy, charging safety, EMC immunity or physical validation pass is implied by this calculation.
