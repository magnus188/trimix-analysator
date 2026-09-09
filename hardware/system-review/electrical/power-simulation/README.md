# Power-model availability and probe

**Missing evidence — no valid power transient simulation result.**

TI publishes an unencrypted industrial TPS22950 transient model, version1.00
from2020, designed for PSpice17.2. The original ZIP and extracted `.lib` are
preserved unchanged with their copyright and usage notices. The model describes
nominal switching/current-limit behaviour and explicitly excludes temperature
effects. It is not a supplied model of the selected automotive Q1 orderable.
[TI download page](https://www.ti.com/product/TPS22950),
[original model archive](https://www.ti.com/lit/zip/SLVMDI3).

`run_model_probe.py` runs in a separate Python process using KiCad's installed
ngspice45.2 shared library. No live KiCad document is changed. It attempts
three resistor values under a1-ohm load and an additional light-load case,
with the model's RLIM parameter and external resistor set consistently.
PSpice compatibility and the installed XSPICE modules were enabled. All four
final runs reach12ms, but **fail the output sanity check**: with VIN and enable
at5V, the output remains approximately zero, including the1kΩ light load.
These waveforms are not accepted as predictions of the real part. Library
return codes and a completed time vector alone are insufficient evidence.

The model/engine integration needs validation in its intended simulator. The
vendor model was not edited to make the result pass. Even a validated nominal run would not qualify
the Q1 current-limit tolerance, temperature, switched-resistor permission
network, cable ringing, VBUS protection or complete charger/converter loops.
Datasheet bounds and the independently computed passive network analysis
remain separate evidence. A matching validated model/native simulator or
physical measurements are needed for those transient claims.

The interface follows the [ngspice shared-library header](https://raw.githubusercontent.com/ngspice/ngspice/master/src/include/ngspice/sharedspice.h).
`model-probe.json` hashes the unchanged model, runner and local simulator.
Nothing here establishes a manufacturing release or measured charging safety.
