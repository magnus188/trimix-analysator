# Charger SYS capacitor and inductor audit

**The selected design has two charger output capacitors, C104 and C105, totalling 44 µF nominal, and a 1 µH inductor L101. The available inventory does not support adding another bulk capacitor.** Local connections and effective capacitance still require qualification independently.

The authoritative netlist, authoritative board and current routing snapshot agree in all 26 checked MPN/net/value comparisons. `inventory.json` records exact snapshots and positions; `analysis.json` and `capacitance-sensitivity.csv` make the arithmetic reproducible. No authoritative files were edited.

| References | Selected MPN | Quantity / nominal total | Connection and role |
|---|---|---:|---|
| C104, C105 | TDK C3225X7R1C226M250AC | 2 × 22 µF = 44 µF | VSYS–GND, dedicated charger output bank |
| C201, C202 | TDK C3216X5R1E226M160AB | 2 × 22 µF = 44 µF | VSYS–GND, distributed TPS63020 input decoupling |
| C801 | TDK C1608X7R1H104K080AA | 100 nF | VSYS–GND, additional local decoupling |
| L101 | Würth 74437349010 | 1 µH, ±20% | BQ_SW–VSYS |

The full nominal VSYS inventory is **88.1 µF**. C102 is on PMID, so it is excluded. The exact L101 sheet specifies 1 µH and 6.5 mΩ maximum DC resistance at 20°C. Its 13 A saturation figure is typical at 10% inductance change; its 13.4 A performance-current entry uses a specified test board and 40 K rise. Those figures do not qualify this enclosure or PCB thermally. [Würth exact datasheet, revision003.000](https://www.we-online.com/components/products/datasheet/74437349010.pdf).

## What TI requires

BQ25895 RevC §9.2.2.3 recommends **1 µH with at least 20 µF system output capacitance**, using suitable ceramic capacitors. The SYS pin description also calls for close output decoupling. Section11.1 separately requires a compact SW-to-inductor path and nearby output capacitors with short ground returns to the charger. Capacitor quantity alone cannot satisfy those layout requirements. [TI BQ25895 datasheet, pp.5,50,55](https://www.ti.com/lit/ds/symlink/bq25895.pdf).

## Effective-capacitance evidence

C104/C105 are 16 V, ±20%, X7R parts. The inspected exact TDK characterization curve retains approximately 90% at 5.5 V; the half-rated-voltage temperature curve also shows bias/temperature interaction. TDK explicitly treats characteristic graphs as reference data rather than guaranteed production limits. [Current TDK part page](https://product.tdk.com/en/search/capacitor/ceramic/mlcc/info?part_no=C3225X7R1C226M250AC), [archived exact characterization source](https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3225x7r1c226m250ac.pdf).

Using the existing, explicitly provisional factors gives:

`2 × 22 × 0.90 bias × 0.80 tolerance × 0.85 temperature × 0.90 aging = 24.2352 µF`

This is an engineering estimate, **not a guaranteed minimum**. The 5.5 V comparison point does not establish an allowed SYS operating voltage. Initial tolerance, zero-bias temperature class and typical DC-bias loss cannot be multiplied into a guaranteed combined corner; the 10% aging allowance also lacks an exact qualified service interval.

With the same other assumptions, the pair needs a retained-bias factor above0.74272 to reach20 µF. At0.75 it gives20.196 µF; at0.70 it gives18.8496 µF. These are sensitivity cases, not predictions that the selected part suffers those losses.

C201/C202's exact 25 V/X5R characterization shows much greater bias loss. A conservative approximate0.50 retention at5.5 V gives another13.464 µF under the same factors. The four-capacitor model is therefore37.6992 µF, excluding C801. This is a low-frequency lumped-capacitance model; it is not the input-port impedance at1.5 MHz. [Exact TDK characterization](https://product.tdk.cn/system/files/dam/doc/product/capacitor/ceramic/mlcc/charasheet/c3216x5r1e226m160ab.pdf). Both downloaded graph pages were visually inspected; direct web retrieval of these archived characterization URLs failed during this pass, so the existing hashed manufacturer PDFs are the curve evidence.

## Local path distinction and remaining action

In the frozen routing snapshot, L101.2→C104.1 has a direct native witness through 4.5358 mm of F.Cu trace items at1.0 mm width. C104.1 is9.07–9.54 mm from the U101 SYS pad centres; C105.1 is7.39–7.60 mm away. These are observed geometry, not invented pass/fail distance limits.

The zone-excluding witness tool does **not** find explicit trace-only paths from SYS to either output capacitor or from their ground pads to PGND. Filled-plane connections may provide those paths; their absence from this deliberately limited graph is not proof of an open circuit. `trace-witnesses.json` preserves exact item UUIDs and limitations. Remote C201/C202 should not be credited as the charger's local20 µF merely because they share VSYS.

Complete and review the existing local output/ground paths, then qualify effective capacitance, output ripple, transients, startup and temperature. Extra bulk is justified only if that review or measured/guaranteed capacitance evidence establishes a remaining deficit. No additional component, purchase or release approval is implied here.
