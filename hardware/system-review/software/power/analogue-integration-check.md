# Analogue integration check

The checked XML and production ADC settings agree. U401 reads AO2 on MUX0 and JJ-CCR on MUX6 at gain8/PGA enabled. U502 reads **HE_REF minus HE_SENSE** on MUX0 at gain1/bypass; MUXA reads excitation/2 and MUXB reads O2 bias. The polarity concern was a stale review summary; no connection or profile was changed. Profiles remain O2=1, He=2.

| Network | Nominal time constant |
|---|---:|
| O2 differential, negligible cell impedance |0.201ms|
| He differential, negligible midpoint impedance, revised680ohm series pair |2.3718ms|
| Excitation monitor |0.5ms|
| Bias source |5ms|
| Individual O2 common-mode path |10ms|
| Coupled symmetric bias/input network |about10.386ms|

The driver waits100ms before starting each new conversion. This is not a guaranteed analogue settling bound: source impedance and effective capacitance remain unmeasured. A simple ten-time-constant criterion would require cell impedance below about9.75kohm or MD62 midpoint impedance below7.59kohm, before tolerances/coupling. An open O2 differential input instead decays through the2Mohm bias path with about2.01s time constant. Neither near-zero voltage nor a fixed delay proves an intact cell or thermal readiness.

At exactly3.3V, resistor initial tolerances place VMID at1.64835–1.65165V and each cell sees1.98–2.02Mohm loading. The matched2k array has999–1001ohm Thevenin resistance using its individual0.1% limits conservatively. Loading error depends on the cell impedance, and calibration does not automatically compensate subsequent impedance/leakage drift. [Vishay array specification](https://www.vishay.com/doc?28770=)

TI specifies the PW reference at±0.15% at25C; nominal O2/He LSBs calculate to30.52nV/244.14nV. Gain8 full-range input limits at3.3V are approximately0.3282–2.9718V, leaving ample nominal centered-O2 headroom. Typical shorted-input noise is0.64uV RMS at O2gain8 and5.04uV RMS at Hebypassgain1; these are not worst-case noise or gas-accuracy bounds. Single-shot timing is51213 oscillator cycles, at mostabout51.034ms with the specified−2% clock corner. Firmware150ms conversion timeout has clock margin. Its four sequential measurements plus100ms delays and200ms worker delay produce at mostabout1.25 gas frames/s before bus/RTOS overhead (about1.05 with the input probe), despite the20SPS ADC setting. [TI ADS122C04 sections6.3–6.5, Tables1/3/12 and8.4.2](https://www.ti.com/lit/ds/symlink/ads122c04.pdf)

The selected3.0V TPS7A20 permits2.955–3.045V in its specified regulated conditions. Combined with the0.1% monitor divider, AIN2 is1.4760–1.5241V, below the internal reference. Assuming a passive midpoint between ground and excitation, He differential magnitude stays below1.5241V. Recommended individual-input limits additionally require HOST_3V3≥2.945V at the3.045V midpoint extreme; the current1.4–1.9V bias diagnostic gate alone does not establish this. Measure the actual host rail/midpoint envelope. If the sensor requirement literally forbids any excursion above3.000V, nominal3.0V regulation does not resolve that requirement. [TI TPS7A20](https://www.ti.com/lit/ds/symlink/tps7a20.pdf)

No physical test is claimed. Exact MLCC tolerance/derating, sensor source impedance, input current/leakage, remote excitation, board noise, cable effects and thermal/gas behavior remain qualification inputs. Input-current and bypass gain/offset figures that TI lists only as typical cannot support a guaranteed complete error budget. JSON records calculations, assumptions and exact source hashes; PCB routing and component qualification are reviewed separately.
