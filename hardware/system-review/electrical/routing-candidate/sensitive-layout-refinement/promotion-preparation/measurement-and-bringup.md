# Measurements and physical acceptance — all pending

This checklist separates digital evidence from measurements. None of the following has been performed by the review.

## Before PCB release

- Record both18650 manufacturer/model markings and chemistry, maximum charge voltage/current, discharge rating, condition and matching. Confirm protected FMA holder polarity, BEC/RCY mating gender, contact/wire current rating, protection thresholds and actual NTC placement. Do not infer ratings from capacity or blue wrapping.
- Photograph/measure Guition header pitch, mating-side pin1 and dimensions, cable-exit direction, plugged connector height and available rear clearance. Our J301 selects the matched2.54mm Samtec HTSW-113-07-L-D-007/IDSD-13-S-04.00-G-P07 configuration; exact keyed availability remains unconfirmed. Guition catalog pitch is2.54mm, but measure the actual post/plating/mating geometry and verify continuity. Its JP1 VCC5V connects to the IP5306 boost output: approved external power-entry behavior is unresolved. Keep the Guition BAT socket empty and service USB isolated from J301 until that is qualified.
- Confirm Amphenol142138 SMB male-centre interface fits the actual90-degree JJ-CCR female elbow; measure bend sweep with J401 installed. Preserve differential shell isolation. Record AO2 threaded/seal/connector dimensions and MD62 lead identities.
- Confirm humidity module is genuine BME280 rather than pressure-only BMP280; check VIN range, pull-ups, address, actual chamber cable, strain relief and feedthrough seals. Verify CO module supply/logic current and exact pin order.
- Review the completed main CAM/CAD receipts and obtain process/assembly quotation using exact DNP/BOM/CPL, stackup, VIPPO/thermal-pad, edge/cutout and paste requirements. Both boards are logically routed; the daughter's manufacturer-land edge/annular process conflicts and the main factory/physical acceptance holds remain open.

## Staged first electrical bring-up

Use current-limited bench supply, DMM and magnification. Keep battery removed, J104ARMopen and the display/sensors disconnected initially. Inspect solder bridges and polarity; measure passive rail resistance, connector pin mapping and chassis/SMB isolation. Power only the intended rail at a conservative current limit; confirm raw/protected/limitedUSB voltages and no unexpected reverse feed before adding loads.

Scope-capable testing is required for regulator ripple, fast protection and source transitions; a DMM alone cannot validate them. Do not treat missing equipment as a passed waveform test.

1. Verify eFuse cutoff/recovery sweep and input leakage at temperature; confirm5.25V acceptance within chosen tolerance and document upper USB5.5V rejection/hysteresis.
2. Test both USB-A→C and C→C orientations; source states unknown/default/1.5A/3A and BC1.2SDP/CDP/DCP. Measure whole-board cold current, caps/inrush charge and actual current-limit corners.
3. Hold GPIO50 high deliberately, unplug/replug and applyCC/OVLO/undervoltage faults. Capture rawIN,protectedOUT,MR,RESET,Q,Qbar,GPIO49 andcurrent. Permission must stay absent until a fresh verified edge. Test BQ interrupt overlap and reset deglitching.
4. Measure fastOVP pulses, cable ringing, ESD test envelope and short faults. Published typical response plus cap estimates does not prove the TPS22950's6Vabsolute input survives. No DC-bench result replaces this transient check.
5. Load each regulator stepwise with an electronic load or documented resistor loads. Capture startup, output ripple, current limit, inductor/switch temperature and thermal steady state in the actual enclosure. Include minimum pack voltage, host Wi-Fi/backlight peaks, heater and CO load, and charging operation.
6. Verify Guition USB programming/charger/battery backfeed and LM66100 reverse isolation with every supply combination. Establish safe connection order and standalone-host programming method.
7. Only after cell/NTC/profile acceptance, close charge ARM for controlled charging tests. Test termination/recharge, NTC hot/cold/open/short response, pack protection and slow device-OFF recovery from depleted pack. Record temperatures and capacities; do not bypass protection.
8. Condition MD62 per manual; record warm-up, drift, bridge impedance, settling/noise, supply sensitivity, O2 cross-sensitivity and environment. Calibrate with known reference mixtures and validate on excluded mixtures. Repeat battery/USB operation and different O2fractions. Include reference analyzer uncertainty.
9. Confirm independent AO2/JJ-CCR/He calibration records, clipping/stale/disconnect rejection, stable-point rules and preservation of previous calibration on failure/power cycle. CO remainsCO.
10. Fit actual harnesses, insert/extract modules, disconnect battery, open rear cover and inspect wire bends/abrasion, screw/tool access and sensor sealing. Perform gas leakage/flow tests at intended near-ambient pressure and verify no unqualified pressure reaches sensors.

Record date, instrument, firmware/native design hash, gas/reference uncertainty, source/cable, ambient/chamber temperature, pressure/flow, acceptance limit and result for each test. Retain failures and revisions rather than replacing them with a later pass summary.

## Local service access

TP1014 is a 0.8 mm front-copper QON service pad beside U101; use TP1001 as the ground reference. The optional SW101 is omitted. Diagnose the cause before manually recovering the charger BATFET. TI specifies QON ship-mode wake and full SYS reset separately; the full reset requires USB disconnected and a 12–18 s low interval in its stated junction-temperature range. The firmware does not deliberately enter ship mode. Actual probe handling and recovery timing are untested; this service path does not establish depleted-pack USB startup (EL13).

TP1013 is the rear-copper charger STAT diagnostic pad. Remove the PCB for access. Neither TP is a purchased populated component, and neither has solder paste. C108 supplements the retained C104/C105 SYS bulk; its short local path still requires oscilloscope/noise qualification in the physical prototype.

## Revised local power-layout population

Test the exact populated revision: C103 is 47 nF/50 V TDK C1005X7R1H473K050BE; C107 is **47 µF/10 V TDK C2012X5R1A476M125AC**, replacing the earlier 22 µF/25 V part. Capture REGN voltage, rise time, ripple, charger startup/recovery and temperature across intended supply, load and ambient corners. Typical DC-bias curves suggest comparable operating capacitance, but the larger zero-bias value adds startup charge; neither curve estimates nor the shorter route establish guaranteed startup. Preserve the EL13 depleted-pack/true-off recovery hold.

For U701, measure output ripple/load-step response, switch ringing and inductor temperature with the revised C702/feedback layout. Check HE_EXC_DIV noise and false excitation-fault behavior because the rear R504 route passes beneath part of the CO input-inductor region, with In1 between. Inspect the actual Coilcraft C-mark/short-lead orientation against pad 2 before power-up. These digital layout corrections do not count as waveform, coupling or thermal measurements.
