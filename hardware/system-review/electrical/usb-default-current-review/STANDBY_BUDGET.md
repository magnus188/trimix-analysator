# Conditional USB input-current budget

**Missing evidence; no legacy SDP compliance claim.** The current native circuit
has three VBUS nets, checked against the exported netlist by
`standby_budget.py`. It produces [the reproducible calculation](standby-budget.json).
No circuitry is changed by this calculation.

| Condition | Conditional reference total |
|---|---:|
| 5.0 V input, verified HIZ and inactive BQ ADC | 1.6514 mA |
| 5.5 V input, same assumptions | 1.7461 mA |

These are sums of stated reference bounds and engineering allowances, **not
guaranteed whole-board maxima**. The remaining numerical margin below 2.5 mA
does not cover an unbounded device condition automatically. In particular:

- TI specifies the BQ25895 35 µA HIZ value at 5 V, **without a battery**, with
  its battery monitor disabled. It does not establish battery-present draw.
- The TPS259470 supply-current table uses 12 V and open OUT. Its application
  at 5 V is an explicit transfer assumption here.
- Capacitor insulation, board and connector leakage, temperatures, mode changes
  and USB inrush still need evidence. Physical voltage and current waveforms
  have not been measured.

The passive-leg estimates intentionally use only each upper resistor and a
nonnegative input-pin voltage, overestimating normal divider current. Listed
fractional resistor allowances are assumptions, not a new manufacturer rating.
The BQ-independent CC/BC detectors are supplied by HOST_3V3; in the isolated
case the battery supplies that host rail. CC/data signalling currents are
separate from this VBUS-only accounting.

Merely disabling charging cannot use this table: the BQ still has a system
power path unless HIZ is set. Even the datasheet's non-switching, non-HIZ
3 mA input-current maximum exceeds the legacy standby allowance after adding
the other circuitry. A running SYS load can draw more. HIZ readback, inactive
ADC observation and watchdog/reset handling are therefore relevant; they
cannot enforce an input mode when the host is unpowered or stalled.

Primary evidence: [BQ25895 Rev C](https://www.ti.com/lit/ds/symlink/bq25895.pdf),
[TPS25947 Rev C](https://www.ti.com/lit/ds/symlink/tps25947.pdf),
[TPS22950-Q1](https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf),
[TPD1E10B06](https://www.ti.com/lit/ds/symlink/tpd1e10b06.pdf).
The calculation records local source and netlist hashes. Source permission,
legacy ambiguity and attach/suspend rules remain in [the separate review](README.md).
