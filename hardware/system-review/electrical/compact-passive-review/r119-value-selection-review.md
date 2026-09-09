# R119 value and exact-part lookup

Reviewed 2026-09-08. Retain the qualified **RT0402BRD0719K1L, 19.1 kΩ ±0.1%** selection for the current routing candidate. An exact, available 19.2 kΩ ±0.1% 0402 replacement within the same maximum envelope was not established by this lookup. No new part or native-design change was made.

The earlier `../ilim-0402-candidates.json` incorrectly calls 19.2 kΩ an E192 value. [Vishay's manufacturer table, document 28372](https://www.vishay.com/docs/28372/e-series.pdf), lists 191 followed by 193 in E192; 192 is absent. Thus an E192-on-request statement does not establish a 19.2 kΩ orderable part. The old JSON is retained as historical evidence, with this correction superseding that assertion.

[Vishay's TNPW e3 data sheet](https://www.vishay.com/docs/28758/tnpw_e3.pdf) supports 0402 precision resistors and E192 ranges, but it does not establish an exact `19K2` product, availability or conformity with this board's maximum envelope. Broad 19.2 kΩ/0402/0.1% and exact `RT0402…19K2` / `TNPW0402…19K2` searches did not produce a verified replacement. This is a limited search result, not a claim that such a custom resistor cannot be manufactured.

U114's [TPS22950-Q1 table](https://www.ti.com/lit/ds/symlink/tps22950-q1.pdf) uses a 19.2 kΩ test point. The current selected 19.1 kΩ differs by −0.5208% nominally. Neither substituting the table's 34/50/66 mA bounds unchanged nor inventing a guaranteed interpolation is justified by this lookup. Keep typical-formula estimates separate from guaranteed device test conditions and retain the actual-current qualification gate. A future verified exact-value substitution still needs resistor tolerance, TCR, leakage, complete source draw and assembly checks.
