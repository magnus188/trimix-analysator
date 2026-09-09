# EL11 — upstream OVP transient review

Reviewed 2026-09-08 against the immutable `b305a4c3…eddb2` controls-complete routing snapshot. **EL11 remains an unresolved protection qualification gate, not a demonstrated 6.396 V hardware failure.** No transparent replacement or capacitor-only correction is justified by the evidence reviewed. Keep the routed design as the prototype baseline; do not describe its protection against adapter faults, ringing or ESD as qualified. If qualification of that baseline fails, a higher-voltage downstream limiter is the more useful redesign direction.

`review-calculations.json` binds the exact board, production policy, manufacturer PDFs and calculations. `conditional-charge-sweep.csv` contains 45 explicitly conditional cases. The board bytes were read without modification. No circuit was powered, manufacturer contacted, component ordered or authoritative file edited.

## What the existing calculation establishes

The actual path is U115 **TPS259470ARPWR** → C114 **C3216X7R1E475K160AC**, 4.7 µF/25 V → U114 **TPS22950CQDDCRQ1** → C101, 1 µF → BQ25895. U114 IN and ON share `USB_OVP_5V`. C116 is now the actual 0402 **GRM1555C1H332JE01D**, 3.3 nF. No circuit topology was inferred from an old illustration.

U114's recommended upper supply is **5.5 V** and absolute upper limit **6 V**. An absolute limit is not a normal operating target. [TI TPS22950-Q1, §§5.1/5.3](https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf)

The earlier `Vpeak = Vstart + I × t / C` calculation used 5.489550 V, 2.2 A, 1.2 µs and 2.912355 µF. It gives **6.396033 V**, correctly. However:

- **2.2 A is not a guaranteed instantaneous cap.** It is the upper steady current-limit test point at RILM = 1.65 kΩ. Current-limit settling is 400 µs typical; transient protection has separate thresholds and delays.
- **1.2 µs is typical only**, specified from OVLO threshold crossing to OUT beginning to fall. It is not a guaranteed total interval until zero transferred charge. Fast-trip's 500 ns is also typical only. [TI TPS25947 Rev C, §§6.5–6.6](https://www.ti.com/lit/ds/symlink/tps25947.pdf)
- **2.912355 µF is an engineering estimate**, combining reference DC-bias behavior with tolerance, temperature and an assumed aging allowance. It is not a guaranteed combined minimum. [Exact TDK characterization sheet](https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3216x7r1e475k160ac.pdf)
- Starting at the highest DC trip corner is possible as a conditional state; it is not the starting voltage of every 5 V step. Conversely, current need not remain at 2.2 A while protection responds. These effects can move the prediction in either direction.

The physically relevant condition is the **net charge reaching C114**, including load absorption and parasitics, before isolation. The table below assumes the same estimated capacitance, no ESL spike, and a constant net charging current solely to show sensitivity:

| Assumed initial node voltage | Charge headroom to 6 V | Time consuming that headroom at assumed 2.2 A | Conditional peak after 1.2 µs |
| --- | ---: | ---: | ---: |
| 5.000 V | 2.9124 µC | 1.3238 µs | 5.9065 V |
| 5.250 V | 2.1843 µC | 0.9928 µs | 6.1565 V |
| 5.489550 V | 1.4866 µC | 0.6757 µs | 6.3960 V |

Thus the illustration is **neither a guaranteed conservative upper bound nor evidence the device will fail**. It does expose limited headroom without a matching guaranteed response/charge envelope. This is a real missing design proof. Extra C101/downstream capacitance and load current may help through U114, but its operating state and finite current control prevent counting them unconditionally as local C114 capacitance.

At the high trip corner, the same assumed 2.2 A/1.2 µs would need **5.1719 µF effective** to stay at or below 6 V; to stay below 5.5 V it would need 252.63 µF. These are conditional effective values, **not nominal capacitor recommendations**. Increasing C114 does not supply missing timing/current limits. It also affects recovery/inrush: U115 bypasses its DVDT control after OVLO recovery. [TI TPS25947, §7.3.3](https://www.ti.com/lit/ds/symlink/tps25947.pdf)

## Bounded replacement review

| Candidate | Evidence and disposition |
| --- | --- |
| **TPS25200DRVR**, replacing U114 | Its input is 20 V absolute and its static output clamp is 5.25–5.55 V under the specified test. However, the lowest specified current point is **40/83/130 mA**, so it fails this design's ≤100 mA cold ceiling before other loads. The advertised 0.6 µs timing is explicitly typical/reference-only. WSON6 is not DDC6. Do not substitute. [TI Rev F, §§5.1/5.5/5.6](https://www.ti.com/lit/ds/symlink/tps25200.pdf) |
| **FPF2286UCX**, replacing/augmenting U115 | The primary table puts **40 ns internal / 100 ns external** OVP turnoff in the **Typical** column; 100 ns is not a maximum, despite distributor fields. External timing depends on OVLO capacitance. Default trip is 6.6–7.0 V; adjustable threshold requires a divider. It also lacks the existing AUXOFF reset function and changes package. Faster typical behavior is promising for a different circuit, but does not close this gate. [onsemi Rev 1, Table 5](https://www.onsemi.com/download/data-sheet/pdf/fpf2286ucx-d.pdf) |
| **TPS16416DRCR**, replacing U114 | A worthwhile conditional redesign: IN/OUT are rated 40 V operating/42 V absolute, removing this specific 6 V weak point while retaining U115. Published limits are **24/32/39 mA at 332 kΩ** and **0.918/0.987/1.035 A at 10 kΩ**, the latter only through 85°C. The 280 µs current-limit response remains typical. This changes the source-current contract, package and support circuit; it is not ready for native substitution. [TI Rev C, §§6.1–6.6](https://www.ti.com/lit/ds/symlink/tps1641.pdf) |

The preserved onsemi PDF and layout-text extract make its timing columns auditable. The archived [alternative study](../usb-protection-research/transient-options/README.md) retains exact package/pin/SOA/leakage issues; this review does not reopen its rejected alternatives.

## TPS16416 and the *current* firmware

Source hashes are recorded in the JSON receipt. In `main/sensors/usb_input_policy.cpp`, source detection is now PG-independent, but **lines 126–146 exit HIZ and wait for PG while permission stays LOW**. Only lines 147–161 configure the high charger limit and raise hardware permission. The startup objection is therefore narrower than the older software description, but still exists: BQ's source test draws **30 mA typical**, above TPS16416's 24 mA low corner. [BQ25895 §8.2.3.2](https://www.ti.com/lit/ds/symlink/bq25895.pdf)

An explicitly conditional architecture proposal is:

1. Retain U115's independent AUXOFF/supervisor/latch reset and fail-low two-condition authorization. Replace only the downstream low-voltage limiter with a separately audited TPS16416 circuit.
2. After fresh valid CC/BC entitlement, safely stage a hardware high-current grant before waiting for BQ PG, with HIZ/configuration readback, feedback, timeout and immediate cancellation on source change. Lower the eventual BQ request to a value supported by the selected ~1 A path; 800 mA is a candidate, not an approved setting.
3. Resolve CPU-off/depleted-pack autonomous startup separately. A running-host sequencing change does not prove that an empty battery can start the host or that autonomous BQ recovery will succeed.
4. Qualify hot off-branch leakage at the much higher 332 kΩ programming impedance, exact supported current corners, IOCP ordering, reverse/backfeed behavior, quiescent/inrush budget and transient peaks. Do not treat the existing MOSFET pair as an ideal open switch. Do not apply 5.5 V directly to a pin whose recommended limit is lower.
5. Only after that circuit review assess real PCB space/routing and carrier fit. No same-footprint or enclosure-fit claim is made here.

This removes the *specific* downstream voltage-rating weakness by rating, but is more work than validating the present prototype and may reduce available charging/system power. It does not rate every raw-USB device for 40 V.

## How to close the current gate before a PCB order

Prefer a **small, representative protection-chain bench assembly or suitable manufacturer evaluation hardware** first, with U115/U114, actual programmed dividers, C114/C116, authorization/reset circuit and dummy loads. Avoid using the battery or display as the first fault-injection load. Evaluation hardware can reduce risk but its different wiring/layout must remain an explicit limitation.

- Define the claim to test: normal source range, fault amplitude/duration/rise and fall rate, cable/source impedance, temperature, capacitor tolerance/aging assumptions, initial node charge and authorized/cold-load states. Include a 5.25 V starting state and OVLO recovery. Respect each tested component's limits; an undefined arbitrary surge cannot be qualified.
- Measure directly at **U114 IN/ON**, plus raw U115 IN, protected OUT, relevant currents, AUXOFF, MR/RESET and latch feedback. Use suitable probe bandwidth and short connections; record probe uncertainty and parasitic overshoot. Confirm the normal operating envelope and a fault peak below absolute limits with an explicit agreed margin, not merely a rounded reading below 6.0 V.
- Exercise rising faults, ringing/hot-plug, short pulses, sustained faults and recovery, including host held high/off and precharged output. Verify no stale permission survives, recovery charge does not exceed the intended source contract, and components do not overheat.
- A manufacturer answer could instead supply a **maximum delivered-charge/output-overshoot bound** for the exact input ramp/source impedance/load/capacitance/temperature envelope, or a maximum response with all additional assumptions needed to derive that bound. A typical trace or typical turnoff number alone is insufficient. No request has been sent.
- Recheck on the finished board: mockboard tests do not qualify final trace/cable inductance or final ESD paths. A tested envelope establishes evidence only for that envelope, not universal adapter/ESD immunity or a production-population guarantee.

**Recommendation:** retain EL11 as `OPEN—transient envelope unqualified`; do not re-label it “proved 6.396 V overshoot.” Do not add bulk capacitance or change an IC merely to make the illustrative arithmetic pass. Bench the existing compact chain first. If its bounded envelope fails, pursue the TPS16416 architecture deliberately, with its current/boot tradeoffs resolved before rerouting.

Reproduction: `/tmp/trimix-gerbonara-venv/bin/python hardware/system-review/electrical/ovp-transient-review/review_calculations.py [--board PATH --out DIRECTORY]`. This reads only the selected source; it writes this review's JSON/CSV outputs.
