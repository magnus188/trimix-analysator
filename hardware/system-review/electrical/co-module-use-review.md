# CO module: operating conditions and intended use

The ZE07-CO remains an experimental CO measurement channel. Its reading must
not be presented as certification that breathing gas is safe.

Winsen's V1.7 manual specifies 5–12 V supply, −10 to 55 °C and 15–90% RH without
condensation. It calls for at least five minutes on first use, excludes strong
air convection and explicitly excludes applications involving human safety.
These restrictions apply even if a bench calibration appears successful.
[Manufacturer manual, pages 3 and 6](https://www.winsen-sensor.com/d/files/manual/ze07-co.pdf).

The intended 5.28 V rail lies inside the stated supply range nominally; actual
startup, ripple and loaded voltage remain part of EL10. The corrected firmware
waits 300 seconds after successful UART-interface enable before accepting CO.
This conservative time gate is not a measurement of module power or readiness.
Time alone does not establish valid conditions.

The final review found that a fresh UART frame could still become valid with
missing or out-of-range chamber environment data. The correction now qualifies CO separately using fresh finite temperature
and humidity evidence, records a diagnostic reason when unavailable, and preserves
the independent oxygen and helium acquisition/calibration behaviour. The portable
gate and actual worker boundary tests pass; see the [source-bound CO evidence](../software/co-environment/evidence/receipt.json).

Dry sample gas may fall below the module's RH range; this is an inference to
check against measured chamber conditions. BME280 readings cannot establish the
absence of condensation, local thermal gradients or excessive flow at the CO
sensor. Physical characterization remains pending, and neither environmental
gating nor gas tests remove the manufacturer's intended-use restriction.
