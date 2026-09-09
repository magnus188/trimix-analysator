# Electrical / firmware / harness contract

All voltages are relative to PCB GND unless a differential signal is stated. Native netlist and `connector-testpoint-pinmap.csv` define pin numbering. Connector mating views, keyed orientation and actual cable routing require physical confirmation; a software pin map alone cannot establish them.

## Power and source authorization

Protected1S2P FMA holder → PACK_P → BQ25895 SYS/VSYS → TPS63020 VOUT_5V → LM66100 HOST_5V → J301pins2/4. Return uses J301pins5/6/16. Guition supplies HOST_3V3 onpins1/3/18. Use both5V contacts; do not assume the bare header's rating proves a cable assembly's rating.

USB path: GCT connector/rawUSB_5V → TPS259470 sustainedOVP → USB_OVP_5V → TPS22950CQDDCRQ1 current limiter → USB_CHG_5V/BQ. Shared C114 is4.7uF25VX7R1206 on USB_OVP_5V. No duplicate interstage bulk. Raw/interstage capacitance and recovery inrush require the complete budget and oscilloscope checks.

U110 TUSB320LAIRWBR sink controller uses I2C0x47; U111 PI3USB9201ZTAEX BC1.2 detector uses0x5F. HOST3V3 powers both. BQ D+/D- remain NC, no PD/HVDCP. J101/J902pins1..6 are USB_5V,GND,USB_CC1,USB_CC2,USB_D_P,USB_D_M. R901/R902 are DNP to avoid parallel Rd.

GPIO50/J301.11 USB_ILIM_AUTH is fail-low. R119 is the sourced19.1k0.1% RT0402BRD0719K1L default resistor. U114's published34/50/66mA table is specified at19.2k; the19.1k E96 substitution has only a typical-formula estimate, with actual current corners still unmeasured. Q110 and Q111 must both conduct to add R1161k0.1%. U112 D-flipflopCLK is authorization, D/PRE areHOST3V3, Q drivesQ110, asynchronousCLR comes from U113. U113 is host powered, senses protectedVBUS, and MR is wired-OR TUSBINT and eFuseAUXOFF. R11133kMR pull-up and internalMR pull-up have a documented conservative leakage/load budget. CLR has separate10k pull-up R115. A low event clearsQ even if the host is stuck high; release alone cannot restore it.

U112 Qbar drives Q112: gate1Qbar/source2GND/drain3CHG_INT_N. Thus GPIO49/J301.13 is LOW while permission is absent or while BQ asserts its interrupt. It is an actual-state observation, not a separate source classification. Firmware must deglitch BQ's short interrupt pulses, lower AUTH before acknowledgment/configuration, qualify source again, wait reset release, generate a fresh edge and verify readback. GPIO52/J301.7 remains unused.

The exact Q1 part's34/50/66mA table does not establish arbitrary resistor extrema or instantaneous current bounds. BQ R103300ohm is a secondary supported-range ceiling; firmware1.4A requests do not promise1.4A delivered. Firmware commands BQ input HIZ for unqualified/SDP/unknown sources, while retaining the100mA register ceiling and fail-low hardware branch. It verifies isolation through register readback; a failed transaction is not reported as confirmed isolation. CC/BC detection remains independent of BQ power-good so HIZ does not block later qualification. Native Default cannot establish an unconditional legacy-A current entitlement. Whole-board low-current standby and cold/depleted recovery remain physical/architecture holds. Qualified-source policies require fresh CC/BC1.2 authorization; BQ IINLIM/OTG/HVDCP/watchdog configuration must stay consistent with root firmware tests.

J104 charge ARM remains OPEN. Exact cells, limits, NTC and a versioned charge profile must be qualified first. Current commissioning firmware inhibits charging. True hardware off removes host-powered source detection and high-current permission; the remaining nominal 50 mA path may permit limited recovery, but neither useful off-device charging nor recovery from a deeply depleted/protection-disconnected pack is verified. A host-alive charging standby mode is being implemented separately from shutdown and maintenance; it cannot bootstrap a dead host. See [the state review](../software/power/off-charge-review/README.md). With ARM open a dead pack intentionally cannot bootstrap from USB.

## Host logic

| Net | J301 pin | GPIO | Function |
|---|---:|---:|---|
| I2C_SDA |21|28|100kHz shared managed bus |
| I2C_SCL |14|29|100kHz shared managed bus |
| CO_UART_TX |12|30|9600baud to TXU0202 |
| CO_UART_RX |10|31|9600baud from TXU0202 |
| POWER_INT_N |19|32|LTC2954 button interrupt |
| POWER_KILL_N |8|33|Open-drain, low shuts down |
| HE_ENABLE |17|34|Default low;100k pull-down |
| CHG_INT_N |13|49|Shared BQ interrupt + permission-absent feedback |
| USB_ILIM_AUTH |11|50|Fresh qualified edge |
| CO_UART_EN |9|51|Default low until supplies valid |

GPIO34 is a JTAG selection strap when corresponding eFuse settings select it; the expected board/default eFuse configuration must be verified before relying on boot behavior. This is not a claim that every custom-programmed Guition will boot with the same strap conditions.

## Guition onboard SD interface

The card stays on the Guition; it adds no SD footprint or signal wiring to the main PCB. The [official schematic and provenance](../integration-photo/guition-manufacturer/source-receipt.json) establish the following board interface:

| Function | P4 connection | Review boundary |
|---|---|---|
| Card SDMMC slot 0 | CLK43, CMD44, D0–D3 = GPIO39–42 | Four-bit board bus; actual unit/revision continuity pending |
| TF_VCC | ESP_LDO_VO4 through R4/Q1, nominal 3.3 V operation | GPIO45 switch link R10 is NC; do not assume software control through GPIO45 |
| Card detect | J1 K/contact 9 unconnected | No fitted detect GPIO established; media faults and explicit retry/eject must be handled |
| C6 SDIO slot 1 | CLK18, CMD19, D0–D3 = GPIO14–17 | Separate slot on the shared SDMMC controller; initialization and teardown need coordination |

The card bus is separate from the external J301 assignments. SD startup/writes increase the Guition load and belong in the existing EL12 supply/current-margin and transient tests. No guaranteed card-current maximum or spare HOST_3V3 budget is claimed. The photograph and schematic do not resolve the separate JP1 5 V power-entry/backfeed hold.

## Gas acquisition

Oxygen U4010x40: ADS122C04IPWR TSSOP16,20SPS,internal2.048V,gain8,PGA on,IDACoff. AO2 usesAIN0−AIN1; JJ-CCR usesAIN2−AIN3. Individual records and faults are separate. Preserve J401/J402 placement. SMB shell is O2_B_RAW_N, never ground or a chassis bond.

Helium U5020x41: sameADC,20SPS,internal2.048V,gain1,PGA bypassed,IDACoff. AIN0−AIN1 is **HE_REF−HE_SENSE**, not the reverse. RN501 is fixed matched2k:2k. Excitation diagnostic separately reads HE_EXC_DIV. R506/R507680ohm limit nominal unpowered input fault current below absolute maximum, but do not prove absence of backpower. RC time constant has no finite upper bound until MD62 source impedance is known;100ms is an initial settling allowance, not a measured guarantee.

TPS7A2030PDBVR U501 supplies MD62 regulated3V; maximum ±1.5% output bound gives2.955..3.045V within its3±0.1V interface. At120mA the LDO dissipates0.24W nominal; datasheet187.1C/W board-dependent estimate gives44.9C rise, not a thermal pass. With5.15Vinput/2.955Voutput loss is0.2634W before quiescent current. Keep humidity away from heater and record actual gas temperature/pressure/flow.

CO is distinct from CO2. The installed CO module has its own supply/logic translator and documented protocol; no invented recalibration commands. Sensor accuracy targets remain unproven until reference-gas, environmental, charging/battery and held-out mixture tests are performed.
