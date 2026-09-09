# Available bench equipment and test records

Owner confirmation, 2026-09-08. Availability is recorded below; no electrical, battery, thermal, gas or mechanical test has been performed by this review. Earlier order-list records remain historical snapshots.

| Equipment confirmed available | Planned use | Setup information to record before testing |
|---|---|---|
| Microscope | Pin-one, bridges and accessible solder-joint inspection | Magnification, photographs; assembler inspection for hidden joints |
| Soldering station | Larger SMD/through-hole assembly and harnesses | Tip, temperature, solder/flux and joint access |
| Hot-air reflow station | Accessible rework and supported component assembly | Nozzle, temperature/airflow and process limits; ownership does not qualify hidden-pad assembly |
| DL24/P electronic load | Controlled cell/pack discharge and capacity; regulator loading within its operating range | Exact model/manual, low-voltage operating range, current/power ratings, fixture resistance, cooling, accuracy and documented cell cutoff |
| DLA 24 MHz USB logic analyser | I²C ACK/address/timing, CO UART and control traces | Actual voltage limits, thresholds, sample rate, decoder settings and shared ground |
| FNB58 USB tester | VBUS voltage/current/energy and source observations | Hardware/firmware version, direction, accuracy, trigger mode and added resistance/CC effects |
| Multimeter | Unpowered continuity/polarity, resistance and steady rail/current checks | Model, range, accuracy, fused current input and lead placement |
| Oscilloscope | Startup, ripple, ringing, load steps and control timing | Model/bandwidth, probe attenuation/bandwidth, grounding, current fixture, acquisition settings and compensation |
| DC PSU | Single-source current-limited first power and rail tests | Model, verified current-limit behaviour, overshoot, isolation, reverse-current tolerance and ability to sink current |

The DLA's advertised 24 MHz sampling is not a 24 MHz signal-bandwidth rating. Use it for qualified low-speed logic captures; it does not replace analogue probing of I²C rise times or power rails. Do not use it as a USB high-speed or SDMMC signal-integrity instrument. The FNB58 may change the path being measured; its protocol display does not certify source compliance. Keep active voltage negotiation disabled for initial nominal-5 V tests.

Plan scope/probe grounding before attaching clips. A conventional earth-referenced scope can short a non-ground node through the probe ground. Keep protective earth intact and use a suitably rated differential/isolated arrangement where needed; [Tektronix's floating-measurement guidance](https://www.tek.com/en/documents/technical-brief/floating-oscilloscope-measurements-and-operator-protection) explains the distinction. Do not infer isolation from USB connectivity or battery operation without instrument specifications.

## Battery tests using the DL24/P

Record each cell's maker/model, permitted voltage/current range, condition, initial voltage and fixture polarity. Choose discharge current and stop voltage from the identified cell documentation and verified load/holder ratings; capacity alone cannot supply those limits. Test cells separately before assessing matching for parallel use. Do not parallel unequal-voltage cells as a way to equalize them.

Record voltage/current/time traces, delivered mAh and Wh, initial/final/rested voltage, temperatures, rest periods and uncertainty. Use the protected output for subsequent pack tests and keep protection operational. Capacity results do not establish charging limits, authenticity or protection behaviour. J104 remains OPEN and charging stays inhibited until the existing cell/holder/NTC gates close.

A nonsinking PSU is not a battery simulator. Do not connect it to a path that can receive USB charging or parallel it with a real pack without a qualified fixture. The [first-power procedure](first-power.md) separates the initial single-source test from charging tests.

## SD and complete-device tests

With a fresh supported card, measure startup and write load alongside backlight, Wi-Fi, heater and other modules. Capture rail dips/ripple, dropped records, normal-shutdown flush, absent/full/corrupt media and C6/Wi-Fi reconnection. Controlled power-loss tests use disposable test data only after basic electrical stages pass. Card removal, filesystem resilience and cable handling remain physical tests.

Use [test-record-template.csv](test-record-template.csv) for source/firmware/CAD/PCB revisions, instrument settings, acceptance limits, raw evidence and explicit results: **passed digitally**, **correction required**, **missing evidence** or **physical testing pending**. Equipment ownership is not a passed test.
