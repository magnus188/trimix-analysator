# EL11: downstream limiter voltage-rating alternatives

Reviewed 2026-09-07. Research only. **No schematic, PCB, firmware or BOM substitution has been made. EL11 remains open on the current board.** The current protection chain is described in [upstream-ovp-review.md](../upstream-ovp-review.md).

The specific issue is the TPS22950CQDDCRQ1's 6 V absolute input limit. The existing TPS259470 overvoltage cutoff has a typical-only response time: the earlier illustrative 2.2 A / 1.2 µs / 2.912 µF calculation reaches 6.396 V. Increasing the downstream power-pin rating removes this particular weakness; it does not establish arbitrary adapter, ESD or surge survival for every device connected to USB.

**Selection is paused pending the separate USB power-only-device current-contract review.** A defensible 500 mA default allowance, if applicable to both C-to-C and A-to-C connections, materially changes the solution: a documented ~100 mA lower-range setpoint of a high-voltage eFuse becomes useful. Do not assume that allowance, or extrapolate an intermediate current accuracy, in the current design.

## TPS16416DRCR: mechanically plausible, not a drop-in approval

Primary source: [TI TPS1641 Rev C, June 2026](https://www.ti.com/lit/ds/symlink/tps1641.pdf), downloaded as `sources/tps1641.pdf`, SHA256 `3791e8cc9ee557bbd76ab543a30c4fa602237d1deeef0f443d35764c9f55560c`. Exact orderable [TPS16416DRCR](https://www.ti.com/product/TPS1641/part-details/TPS16416DRCR) is the automatic-retry current-limit variant **without** IN-to-OUT short detection. This avoids choosing the short-detection option that TI cautions can falsely trip with sufficiently large switching-load ripple. Availability for a purchase was not qualified.

| Audit item | Result / integration consequence |
| --- | --- |
| Power voltage | IN and OUT: 40 V recommended, 42 V absolute; Vcc 60 V recommended, 67 V absolute. Both IN and Vcc connect to protected `USB_OVP_5V`; Vcc must not be below IN. |
| Minimum supply | Current-limit variants operate from 2.7 V; electrical-table current limits are specified from VIN = 3 V. Do not extend that table below its condition. |
| Package | DRC0010J VSON10: body 2.9–3.1 mm square, 1.0 mm maximum overall height, 0.5 mm pitch. |
| Lands | Ten 0.60 × 0.24 mm lands on opposite row centres 2.8 mm apart; EP11 central metal 1.65 × 2.40 mm plus drawing tabs. Total recommended copper extent 3.4 × 3.4 mm. A **3.9 × 3.9 mm** courtyard is a proposed 0.25 mm allowance, not a TI-prescribed value. |
| Thermal ground | EP11 is the electrical ground and must be soldered. Follow the actual tabbed EP/paste drawing; a generic 3 mm DFN is insufficient. Thermal vias/paste processing need assembler agreement. |
| Current default | RILIM = 332 kΩ: 24 / 32 / 39 mA min/typ/max, −40…125°C. This alone is comfortably below 100 mA but is too low to establish unchanged BQ startup. |
| Current high | RILIM = 10 kΩ: 0.918 / 0.987 / 1.035 A; explicitly −40…85°C. A future 800 mA BQ request is plausible with separate register-accuracy/thermal verification. Do not quote this accuracy through 125°C. |
| Timing | ILIM response **280 µs typical**, not 215 µs. The 215 µs row is power limiting. Neither is a guaranteed maximum or an instantaneous source-current ceiling. |
| Circuit breaker | With IDLY open or grounded, no intentional blanking is added; the current-control loop still has finite response. A continuous limiting event times out after nominal 155 ms; retry is nominal 620 ms. |
| Reverse behavior | No reverse-blocking guarantee is specified for this part. OFF-state OUT leakage is measured with VIN = 40 V and VOUT = 0 V and does not establish OUT-to-IN isolation. Retain upstream reverse blocking and audit interstage backfeed/reset discharge. |

Pin mapping for a candidate symbol and footprint:

| Pin | Name | Candidate connection / restriction |
| --- | --- | --- |
| 1 | IN | Protected interstage input, short power route |
| 2 | Vcc | Same protected input as pin 1 |
| 3 | OVP | Dedicated divider if the secondary OVP function is used; must not float. Ground disables this IC's internal OVP, so retain upstream fixed OVP in all cases. Divider selection remains pending. |
| 4 | FLT | Open drain; functionally suitable to wired-OR into existing TPS3808 MR for OV, thermal and **current-limit timeout**. It does not assert merely for the whole ordinary limiting period. See caveat below. |
| 5 | EN/SHDN | **Leave open for autonomous default operation**, as explicitly used by TI's electrical-table default conditions. Do not reuse TPS22950 ON-to-IN wiring: EN absolute max is 5.5 V, and TI says not to connect it above 5 V. Internal open voltage is 4.9 V typical; this is not an external clamp guarantee. |
| 6 | IDLY | Open or ground; no added blanking capacitor |
| 7 | dVdT | Slew capacitor 0.01–5 µF permitted; 0.01 µF is only the range minimum, not a validated inrush choice for this board. Ground prevents startup. |
| 8 | ILIM | Permanently fitted default resistor plus separately authorized lower-resistance branch; proposed values not released |
| 9 | IOCP/IMON | Required resistor, must not be open/shorted. Set IOCP above the entire selected ILIM range. |
| 10 | OUT | `USB_CHG_5V` to BQ input capacitor |
| 11 | EP/GND | Ground plane |

The package outline and land pattern were rendered and visually inspected in `sources/tps1641-package-36.png` and `sources/tps1641-package-37.png`. Space-only information was sent to the PCB owner; it does not approve electrical substitution.

### What prevents a transparent 332 kΩ substitution

1. **Charger startup:** [BQ25895](https://www.ti.com/lit/ds/symlink/bq25895.pdf) §8.2.3.2 checks that VBUS stays above its threshold while drawing IBADSRC, **30 mA typical**, before asserting PG_STAT. Existing software requires BQ power-good before granting high current. At the TPS16416 24 mA low corner this test can fail on an otherwise capable source. This affects ordinary attach, not only an empty-pack scenario. The BQ test current itself lacks a maximum specification in the reviewed table.
2. **Intermediate-current accuracy:** the nominal formula would suggest roughly 50–65 mA using approximately 150–200 kΩ. The electrical table does not give bounds there. [TI support](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1531612/tps1641-current-limit-accuracy-at-100ma-and-300ma) reports varying low-current error; the published discussion is engineering guidance, not a replacement guaranteed table. [Another TI answer](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1474202/tps1641-when-riocp-and-rilim-are-changed-to-arbitrary-resistance-values-how-to-calculate-the-characteristic-values-including-ambient-temperature-fluctuations) directs users to the calculator and EVM rather than promising a uniform ±6% bound. The official calculator download returned HTTP 403 in this review. No spreadsheet formula was assumed.
3. **Switched-resistor leakage:** the existing Q110/Q111 DMN2056U devices act on a much higher impedance programming node than the current 19.2 kΩ circuit. Their reviewed primary datasheet's drain-leakage maximum is at 25°C; no applicable hot leakage bound or TPS16416 ILIM pin bias/transfer bound was obtained. Treating the off branch as an ideal open is therefore not a completed worst-case proof. A powered-off-protected low-leak analog switch could address part of this issue, but would require a separate exact-part audit and geometry.

The purely nominal high branch for 332 kΩ || R = 10 kΩ is **10.31056 kΩ**; 10.2 kΩ + 110 Ω approximates it. This calculation is not component approval, and does not include leakage or resistor corner effects. An always-present default resistor retains fail-low intent, while the existing latch and GPIO-controlled series switches must **both** authorize the branch.

For the isolated 332 kΩ test point, 39 mA + 2.1 mA Vcc quiescent + 0.52 mA IN leakage + the earlier 1.47 mA upstream estimate = **43.09 mA**, before programming/divider currents and all remaining direct USB loads. The 2.1/0.52 mA tests use open programming resistors; this is a useful subtotal, **not the completed source-current proof**. It also says nothing about the finite-response peak or capacitive charge.

### Other integration conditions if this candidate is reconsidered

- Use RIOCP = 7.32 kΩ only if a coarse 2.11–2.35 A overcurrent threshold is acceptable: it is an exact full-temperature test point. The 16.2 kΩ point's minimum 0.95 A is below the 10 kΩ ILIM maximum 1.035 A and fails the required ordering. Any intermediate IOCP value needs its own supported bounds. BQ's smaller source request still governs ordinary authorized loading.
- FLT's 73 Ω sink resistance is typical-only, with no maximum VOL. Existing MR load is small, but measure reset low levels, startup and fault recovery rather than invent a guaranteed sink level. FLT sink must remain below 3 mA; verify combined open-drain leakage, pull-ups and unpowered behavior.
- Keep existing upstream AUXOFF/supervisor asynchronous permission reset, latch edge requirement and Qbar/GPIO49 feedback. Upstream reset must still work with a stalled-high host. Do not rely solely on a newly added FLT signal.
- TI recommends local input bypass, more than 1 µF output capacitance and attention to negative output spikes on shorts, potentially including a ground-to-OUT Schottky clamp. Existing C102 must be included in the real startup charge calculation; a 10 nF dVdT part is not automatically slow enough.
- At 800 mA, the full-temperature 260 mΩ on-resistance gives 0.166 W resistive loss before quiescent loss. Board-specific thermal rise and gas-chamber temperatures remain unmeasured. The 1 A accuracy table stops at 85°C even though the silicon junction rating is higher.
- Re-run netlist, physical placement, carrier clearance, source-current corners, bounded state-machine tests, and final exported-byte checks after any approved substitution. No new part makes the raw TVS, CC/BC detectors or upstream controller 40 V tolerant.

## External-shunt fallback: quantitative feasibility, currently paused

[LTC4210-1IS6#TRMPBF](https://www.analog.com/media/en/technical-documentation/data-sheets/421012fa.pdf) offers a simpler 6-pin TSOT-23 controller with an external N-FET and one full-temperature 44–56 mV limiting/breaker threshold. A 1.00 Ω ±1% fixed default shunt implies **43.56–56.57 mA**, before the ±10 µA sense current. Adding its 3.5 mA maximum controller draw and the earlier 1.47 mA upstream subtotal remains far below 100 mA. Its disadvantage is **16.5 V operation / 17 V absolute**, so it needs a defensible retained front-end fault envelope.

A high-side P-FET-controlled parallel power shunt can retain the latch + GPIO AND logic: P-FET source to the higher shunt endpoint, drain through the lower-value resistor to SENSE, gate pulled to source by default, and gate pulled down only through both existing authorization transistors. Body-diode direction then blocks the forward bypass when off. Unlike high-impedance ILIM programming, microamp off leakage adds microamps to load current. This still needs a gate pull-up sized for hot leakage, gate overvoltage clamp, P-FET on-resistance/temperature bounds, pass-FET SOA, gate/timer components and additional PCB area. It is **not** a released circuit or a complete parts selection.

As an illustration only, 1 Ω || 43.2 mΩ, both ±1%, and a hypothetical zero-ohm on-switch gives a maximum **1.366 A** at 56 mV. Positive P-FET resistance reduces the limit, improving the ceiling but also reducing usable current. Its full-temperature maximum is essential to prove that a proposed 800 mA BQ setting does not repeatedly trip. LTC4210-1 is auto-retry; LTC4210-2 is latch-off and must not be substituted silently.

[LTC4231](https://www.analog.com/media/en/technical-documentation/data-sheets/LTC4231.pdf) provides 36 V operation / 40 V power-pin absolute rating, but has different thresholds: 47–53 mV breaker and 65–90 mV active limiting. Keeping the worst active limit at or below 1.4 A requires at least **64.29 mΩ** effective sense resistance, which puts the breaker minimum at about **0.731 A**, before resistor and switch margins. A BQ request around 600 mA, rather than 800 mA, may be necessary. A detailed FET/SOA/footprint design is paused until the USB contract is settled; the high-voltage benefit must not hide the charging/power-budget tradeoff.

## Rejected near-match

[FPF2495CUCX, onsemi Rev 4, August 2026](https://www.onsemi.com/download/data-sheet/pdf/fpf2495c-d.pdf) is **not** a solution in this direction. Its advertised 28 V maximum is on **VOUT**, while **VIN is still 6 V absolute maximum**. Older indexed current tables and the 28 V title are insufficient selection evidence. The actual current PDF is preserved with its hash in `sources/followup-provenance.json`.

## Remaining decision and verification gates

1. Resolve the exact power-only USB default allowance for C-to-C, A-to-C and relevant USB suspend/communication conditions. A broader allowance must be reflected consistently in hardware, firmware and documentation, not inferred from cable shape.
2. Choose an architecture with a supported normal-start lower limit and supported default maximum, including direct USB loads and hot leakage. Account separately for response peaks and capacitive inrush.
3. Prove the selected high setting against BQ accuracy, remaining power demand, passive tolerances, thermal range and fault timeout/SOA. Preserve default charge inhibition and J104 OPEN until physical cell qualification.
4. Only after those checks approve symbol/footprint/placement changes. Then verify native connections, carrier clearance, routing, exported manufacture files and firmware interfaces together.
5. Physical fault injection, cold-start, scope/current, temperature and depleted-pack tests remain pending. Research cannot certify physical surge immunity or release a charging profile.

No device was flashed, charged, purchased or connected to a test supply during this review.

## Historical SDP/HIZ integration finding

This section records the firmware state at the earlier alternatives-research checkpoint. The subsequent [input-isolation implementation and verification](../../../software/power/input-isolation/README.md) adds explicit HIZ ownership/readback, PG-independent source qualification and attachment-event checks. The historical finding below is retained to explain that correction; it does not describe the current firmware. The physical source-current, cold-recovery and transient-survival gates remain open.

The USB specification review is investigating a possible 2.5 mA unconnected/suspended legacy-SDP requirement. This section does not assert that interpretation is settled; it records what an actual-input-disable policy would need if it applies.

At that checkpoint, production `power_monitor::Monitor::inhibit_charge()` cleared REG03 charge/OTG enables only. It did **not** stop the BQ input from powering SYS. `configure_inhibited()` and `set_input_limit_ma()` preserved REG00 EN_HIZ with a `0x7f` mask; `config_matches()` also ignored bit 7. No service then set or verified an intended HIZ policy.

An HIZ write alone would be an incomplete correction: `usb_input::Policy::step()` currently treats BQ PG-low as Detached and stops BC detection **before** independent CC/BC qualification. If HIZ makes PG unavailable, the policy must still detect a changed permitted source without assuming stale charger status. A proposed correction needs an explicit worker-owned input-path mode/readback, CC/BC source-generation handling while input is disabled, and a staged exit from HIZ followed by fresh BQ PG/configuration checks before a full grant. Existing fault/maintenance cancellation and hardware permission-edge requirements must remain effective throughout.

The BQ datasheet's HIZ test gives 35 µA maximum at VBUS = 5 V, no battery, battery monitor disabled; that exact test condition is not a proof for every battery-present operating state. Total connector draw must also include the upstream eFuse, dividers, bleed, source detectors and leakage. In particular, the TPS16416's reviewed 2.62 mA enabled-controller subtotal plus approximately 1.47 mA upstream cannot establish a 2.5 mA total; a HIZ-only change would not cure that candidate's budget.

The CPU-off/depleted-pack case cannot rely on firmware completing detection or enforcing a timeout. It remains a distinct cold-recovery qualification/design gate, not something that can be cleared by describing a host-running source policy. No HIZ code or circuit change was made during this review.
