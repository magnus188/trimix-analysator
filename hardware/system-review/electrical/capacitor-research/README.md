# Capacitor selection support

The ordinary-capacitor proposal covers **28 references**: 15 have new exact KEMET selections backed by downloaded manufacturer sheets, and 13 retain the PCB owner's TDK candidates. This research does not edit the schematic, PCB, BOM, firmware or purchasing state. `ordinary-capacitor-proposals.csv` is an integration proposal for the PCB owner.

## Ordinary selections

| References | Exact manufacturer part | Rating | Maximum body height |
| --- | --- | --- | --- |
| C103 | KEMET C0805C473K5RACTU | 47 nF, 50 V, ±10%, X7R, 0805 | 0.90 mm |
| C803 | KEMET C0805C333K5RACTU | 33 nF, 50 V, ±10%, X7R, 0805 | 0.88 mm |
| C401/C404/C408/C409/C505/C509 | KEMET C0603C105K4RACTU | 1 µF, 16 V, ±10%, X7R, 0603 | 0.90 mm |
| C203/C301/C707/C708/C801/C802 | KEMET C0805C104K5RACTU | 100 nF, 50 V, ±10%, X7R, 0805 | 0.88 mm |
| C706 | KEMET C0805C103K5RACTU | 10 nF, 50 V, ±10%, X7R, 0805 | 0.88 mm |

All five types specify −55 to +125°C and ±15% temperature change. The downloaded four-page sheets include exact dimensions, electrical ratings, aging information, impedance/ESR plots and DC-bias plots. At 5.5 V the ordinary 0805 nF types show small typical bias losses; the 1 µF/16 V 0603 type shows approximately 3–4% at 3.3 V and 8–10% at 5.5 V. These values were read visually from the manufacturer plots and are deliberately approximate. No extra precision or guaranteed DC-bias bound is implied.

Sources: [47 nF](https://search.kemet.com/component-documentation/download/specsheet/C0805C473K5RACTU), [33 nF](https://search.kemet.com/component-documentation/download/specsheet/C0805C333K5RACTU), [1 µF/0603](https://search.kemet.com/component-documentation/download/specsheet/C0603C105K4RACTU), [100 nF/0805](https://search.kemet.com/component-documentation/download/specsheet/C0805C104K5RACTU), [10 nF/0805](https://search.kemet.com/component-documentation/download/specsheet/C0805C103K5RACTU).

The KEMET sheets specify 3% aging loss per decade of hours; the downloaded 33 nF sheet uses a 1000-hour referee time, while the other ordinary sheets use 48 hours. Aging must be related to that reference, service duration and soldering/de-aging history. A blanket 10% allowance is an engineering assumption, not a universal manufacturer guarantee. The graphs are explicitly typical simulations and are not guaranteed production limits. Retain the actual downloaded sheet revision when ordering; rendered graph pages and SHA-256 hashes are included here.

## Critical power capacitance

The PCB owner's proposed TDK C3216X5R1E476M160AC 47 µF/25 V/1206 has substantial bias loss. Using the proposed retained factors gives:

- C102: `47 × 0.30 × 0.80 × 0.85 × 0.90 = 8.6292 µF`, only **5.23%** above 8.2 µF.
- Three identical 5 V output capacitors: **25.8876 µF**, only **17.67%** above 22 µF.
- Changing the assumed retained bias from 0.30 to 0.25 makes both cases fail: **7.191 µF** and **21.573 µF**.

This is a sensitivity calculation, not a prediction that a particular part will have exactly 0.25 retention. It demonstrates why typical-curve arithmetic with small margin should not be labeled a guaranteed worst case. Initial tolerance, zero-bias temperature classification and room-temperature DC bias also do not independently guarantee combined temperature/bias behavior. TDK's temperature curves at half rated voltage help assess interaction, but they remain typical characterization.

**Preferred concrete output-bank candidate if the 1210 land pattern and height fit:** TDK **C3225X7R1C226M250AC**, 22 µF/16 V/±20%/X7R, 1210, maximum 2.8 mm body height. The retrieved manufacturer curve retains approximately 90% at 5.5 V. The same provisional tolerance/temperature/aging factors yield **12.1176 µF each**, or **36.3528 µF for three**, about 65% above the output minimum. This preserves the original output nominal capacitance of 22 µF per reference while increasing package size. [TDK product](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C3225X7R1C226M250AC), [retrieved characterization](https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3225x7r1c226m250ac.pdf).

The same part is a possible C102 alternative only after the PCB owner explicitly checks that **16 V** covers every allowed PMID voltage/transient/OTG condition; it reduces the original 25 V rating. If 25 V must remain, a second parallel, already evidenced 47 µF/25 V/1206 capacitor gives more defensible engineering margin than the single 47 µF candidate. Its quantity, charging input capacitance, inrush and placement need the owner's review. A fourth 47 µF output capacitor is a second possible mitigation if the 1210 replacement is impractical.

Additional manufacturer-backed options were inspected: KEMET C1210C226K3RACTU (22 µF/25 V/±10%/X7R/1210/max 2.8 mm) retains approximately 65% at 5.5 V, producing an estimated 9.8456 µF under the stated factors; this gives only about 20% PMID margin. KEMET C1210C476M4PACTU (47 µF/16 V/±20%/X5R/1210/max 2.8 mm) has more typical capacitance but a specified 5%/decade-hour aging rate and the lower X5R temperature range. Neither is a silently substituted approval. [22 µF KEMET](https://search.kemet.com/component-documentation/download/specsheet/C1210C226K3RACTU), [47 µF KEMET](https://search.kemet.com/component-documentation/download/specsheet/C1210C476M4PACTU).

The requested **C3225X5R1E476M250AC** 47 µF/25 V/1210 number was not verified against a primary manufacturer listing or characterization sheet. Do not select it by extrapolating TDK's part-number format. Failed URL retrieval alone does not prove whether a product exists. The newer C3225X7R1H226M250AC 22 µF/50 V/1210 is listed as production by TDK, but this pass did not retrieve its DC-bias curve or confirm inventory; it remains a research alternative, not a chosen replacement.

The C501 estimate of 0.9708 µF is above the **0.47 µF effective input minimum** confirmed by the root reviewer for the selected TPS7A20. It must not be rounded to 1 µF or compared against an invented strict 1 µF minimum. `critical-capacitance-sensitivity.csv` retains the explicit arithmetic and assumptions.

## Remaining checks

The ordinary nominal MPN choices can be integrated now, with normal footprint/height and ordering-suffix reconciliation. Critical capacitor acceptance still needs a documented permitted rail-voltage range, chosen service/temperature range, tolerance and aging treatment, conservative bias margin, ESR/ripple/layout review and confirmation that increased capacitance stays within each regulator's stability/inrush limits. Physical bias, ripple, startup and temperature measurements remain pending. No components were purchased, and no guaranteed production-wide DC-bias limits were obtained in this research pass.
