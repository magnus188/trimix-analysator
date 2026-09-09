# Upstream USB overvoltage protection — engineering proposal

Reviewed 2026-09-07. Research only: this file does not establish that the PCB has been changed or tested.

**Recommend TPS259470ARPWR ahead of the TPS22950CQDDCRQ1 low-current switch**, with a fixed OVLO divider, controlled cold-start slew, a small interstage capacitor, and its **AUXOFF** output clearing the existing authorization latch through the supervisor. This substantially improves sustained input-overvoltage protection. It does **not** digitally prove immunity to every ESD, cable-ringing or adapter pulse. The finite response and its missing maximum specification remain physical qualification work.

Suggested path: connector/TVS → TPS259470 → `USB_OVP_5V` → TPS22950 → charger. Keep the source detectors' raw-VBUS connection as required by their own ratings and detection function. Move the permission supervisor's voltage divider to `USB_OVP_5V`.

## Exact parts and pins

The [TI orderable page](https://www.ti.com/product/TPS25947/part-details/TPS259470ARPWR) lists this exact part ACTIVE. This is the adjustable-OVLO, active-current-limit, auto-retry variant. Stock availability was not verified for purchase.

| Pin | Signal | Proposed connection |
| --- | --- | --- |
| 1 | EN/UVLO | 21.5 kΩ from raw VBUS; 10 kΩ to ground |
| 2 | OVLO | 34.0 kΩ + 649 Ω series from raw VBUS; 10 kΩ to ground |
| 3 | AUXOFF | Open-drain wired-OR with CC interrupt into existing TPS3808 MR; use a weak pull-up to HOST_3V3 |
| 4 | FLT | Unused, or diagnostic only; **not** an OVLO reset signal |
| 5 | IN | Raw VBUS, short route from connector TVS and input bypass |
| 6 | OUT | Protected `USB_OVP_5V`, local output capacitor and 10 kΩ bleed |
| 7 | DVDT | 3.3 nF C0G to ground |
| 8 | GND | Ground plane, short local connections |
| 9 | ILM | 1.65 kΩ to ground; independent coarse protection, not USB source authorization |
| 10 | ITIMER | Open for fastest overcurrent response |

[TI Rev C, May 2026](https://www.ti.com/lit/ds/symlink/tps25947.pdf), printed pp. 5–11 and 38–39, supplies the pin and functional evidence. RILM = 1.65 kΩ is the explicit table test point with 1.8–2.2 A limits before resistor tolerance. It accommodates the intended qualified 1.5 A path; TPS22950 and charger settings still determine the source limit.

The RPW0010A drawing was rendered and inspected: **2.1 × 2.1 × 1.0 mm maximum**, 10 asymmetric pads, no extra center-ground pad. IN/OUT are the two large central lands; do not substitute a generic perimeter-pad QFN footprint. Reflow assembly is appropriate.

| Role | Proposed manufacturer part | Package / status |
| --- | --- | --- |
| Output capacitor | TDK **C3216X7R1E475K160AC** | 4.7 µF ±10%, 25 V X7R, 1206; maximum 3.4 × 1.8 × 1.8 mm |
| Input bypass | TDK **C1608X7R1H104K080AA** | 100 nF, 50 V X7R, 0603; already researched in project |
| Slew capacitor | TDK **C1608C0G1H332J080AA** | 3.3 nF ±5%, 50 V C0G, 0603; maximum 1.7 × 0.9 × 0.9 mm |
| OVLO upper | Vishay **TNPW060334K0BYEA** + **TNPW0603649RBYEA** | 0603; 0.1%, 10 ppm/K; exact codes derived from manufacturer ordering table, procurement availability pending |
| OVLO lower | Vishay **TNPW060310K0BYEA** | Same precision requirements |
| UVLO upper/lower | Vishay **TNPW060321K5BEEA** / **TNPW060310K0BEEA** | 0603; 0.1%, 25 ppm/K; ordering-table candidates |

Primary capacitor pages: [output capacitor](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C3216X7R1E475K160AC), [slew capacitor](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C1608C0G1H332J080AA). Precision resistor codes and ranges: [Vishay TNPW e3](https://www.vishay.com/docs/28758/tnpw_e3.pdf). Preserve these tolerance/TCR requirements if sourcing alternatives.

## DC threshold calculation and compatibility

`check_ovp_bounds.py` generates `upstream-ovp-review.json`. It uses independent resistor extrema, ±0.1 µA OVLO leakage, the 1.183/1.223 V threshold extrema, and a 100°C excursion from the nominal 25°C resistor reference to 125°C. No resistor tracking is assumed.

For (34.0 kΩ + 649 Ω) / 10 kΩ, all 0.1%, 10 ppm/K:

| Additional independent resistor drift allowance | Rising cutoff | Falling recovery |
| --- | --- | --- |
| None | 5.26214–5.48103 V | 4.78588–5.00180 V |
| ±0.05% each | 5.25806–5.48529 V | 4.78216–5.00568 V |
| ±0.10% each | **5.25398–5.48955 V** | 4.77845–5.00957 V |

This accepts a steady input through 5.25 V under the stated component corners while cutting below 5.5 V. Margins are narrow; PCB leakage, long-term drift beyond the explicit allowance, or substitute resistors require recalculation. This does **not** accept every valid upper-range USB-C 5.5 V source. After an OVLO fault, a source that returns only to approximately 5.0–5.25 V may require unplug/replug because of hysteresis. This is an intentional protection tradeoff.

Rejected alternatives: 34.0 kΩ/10 kΩ with 25 ppm/K parts may cut at 5.1737 V; (34.0 kΩ + 649 Ω)/10 kΩ with 25 ppm/K misses 5.25 V at the low corner and has only 6.2 mV upper margin; 34.8 kΩ/10 kΩ with 10 ppm/K has only 0.415 mV upper margin. The extra series 0603 is justified.

The 21.5 kΩ/10 kΩ UVLO divider yields 3.7066–3.8731 V rising and 3.3711–3.5344 V falling before an additional aging allowance. Startup therefore requires no firmware. The 28 V IC absolute-input rating does not make the entire board 28 V tolerant: signal dividers, TVS, bypass components and input slew limits must also be respected. TI specifies 100 V/µs maximum input rise and 10 V/µs fall. OVLO's recommended pin range is narrower than its absolute range; behavior during a gross abnormal source must be checked, not inferred from the IN rating alone.

## Transients, capacitance and inrush

The actual TDK output-capacitor curve was rendered and inspected. It retains approximately 94% at 5.5 V. Using a deliberately lower 90% bias estimate, -10% tolerance, -15% temperature and a separate 10% engineering aging allowance gives **2.912 µF**. This is an engineering estimate from reference curves, **not a guaranteed manufacturer combined minimum**. With positive tolerance/temperature and a 3% allowance for the curve's slight initial rise, input plus output capacitance is estimated at **6.254 µF maximum**, or **31.27 µC at 5 V**. Other upstream capacitances must be added to the complete USB inrush budget.

Using the drift-inclusive 5.48955 V trip corner, the *illustrative* constant-current model `ΔV = I × t / C` gives:

| Assumed surge current | Assumed turn-off time | Estimated output peak |
| --- | --- | --- |
| 1 A | 1.2 µs | **5.902 V** |
| 2.2 A | 1.2 µs | **6.396 V — exceeds TPS22950 absolute maximum** |
| 5 A | 1.2 µs | **7.550 V — exceeds TPS22950 absolute maximum** |

**The hardware does not guarantee the assumed 1 A surge ceiling**, and 1.2 µs is a typical-only TI number. These calculations demonstrate useful capacitance/headroom and expose the remaining limit; they do not close transient qualification. ESR, ESL, source impedance, cable inductance and response-time distribution are omitted. Even the 1 A estimate exceeds the 5.5 V recommended operating ceiling. Scope measurements at TPS22950 IN are mandatory before claiming survival/performance for a particular fault envelope.

3.3 nF on DVDT gives about 0.606 V/ms nominal cold-start slew. Using maximum pin charging current and minimum C0G capacitance with an explicitly assumed unity transfer gives a conservative engineering estimate of 7.49 mA capacitor-charging current. **TPS259470 bypasses DVDT on OVLO recovery**; that recovery must be treated as a capacitive inrush event, not described as always below 100 mA. The proposed output cap remains deliberately small. Added steady current is approximately **1.47 mA maximum** for the eFuse, both voltage dividers and 10 kΩ bleed under this budget; it excludes the rest of the USB circuitry.

## Independent permission clearing

**AUXOFF is the relevant output.** Table 7-4 makes it low on UVLO, OVLO and inrush, independent of OUT holding charge. Table 7-3 makes **FLT high on OVLO**. TPS259474 was investigated but rejected for this integration: its PG can stay high during OVLO while PGTH stays high. [TI's clarification](https://e2e.ti.com/support/power-management-group/power-management/f/power-management-forum/1075668/tps25947-what-is-the-output-of-pg-in-the-state-not-mentioned-in-table-8-5) confirms the PG dependence.

Wire AUXOFF to the existing MR/CC-IRQ open-drain net, and move the TPS3808 SENSE divider to the protected interstage voltage. Consider increasing the shared external pull-up from 10 kΩ to 47 kΩ: together with TPS3808's minimum 70 kΩ internal pull-up, this draws about 128 µA at 3.6 V. Check combined output leakage and GPIO rise-time requirements. The powered AUXOFF low value is 0 V typical; TI does **not** provide a powered maximum VOL or a maximum AUXOFF propagation delay. Neither may be invented.

Unpowered AUXOFF may reach 1 V and cannot be the only reset guarantee. A 10 kΩ protected-node bleed, estimated maximum output capacitance and a deliberately conservative 4.1 V supervisor threshold give about **18.3 ms** discharge time from 5.5 V without load. This assumes no backfeed; verify all connected parts and their leakage. The [TPS3808 datasheet](https://www.ti.com/lit/ds/symlink/tps3808.pdf) gives the MR function and 12–28 ms open-CT reset release. The existing edge-triggered latch stays cleared after MR releases until a new authorization edge; a host stuck high must not rearm it.

## Physical acceptance still pending

- Slow input sweep and fault recovery over the actual intended temperature range; verify normal 5.25 V sources are accepted and cutoff remains below 5.5 V.
- Hot-plug, rapid disconnect/reconnect, short and long overvoltage pulses: scope raw IN, protected OUT, AUXOFF, MR, RESET, latch Q and input current.
- Repeat with HOST GPIO deliberately held high, the host off, a fully charged interstage node, and the charger drawing its highest authorized current.
- Verify no permission reappears without a fresh edge; verify discharge, reset pulse capture, and interrupted/restarted slew behavior.
- Measure combined capacitive/inrush charge and steady input current against the selected USB source modes. Check QFN soldering and temperature rise.

No hardware measurements, PCB edits, purchases or firmware changes were made as part of this research. This proposal improves protection while leaving the specific transient and assembly tests visible.
