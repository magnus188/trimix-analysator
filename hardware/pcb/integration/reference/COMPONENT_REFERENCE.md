# PCB component reference

Read the printed reference (for example **R101**) and find it below. The letters identify the component type; the number is its unique identifier, not its resistance or rating.

**173 PCB references:** 169 on the main board and 4 on the USB board. The main count includes twelve test pads and two mounting holes. These are the current design values, not a confirmed shopping list or fabrication release. Main routing is unfinished.

Values below expand the schematic unit notation into plain English. The [CSV](COMPONENT_REFERENCE.csv) also preserves every exact schematic value, footprint, source field, assembly note and source location. Ratings and part numbers are shown only where the source supplies them. A blank manufacturer/MPN field means none is explicitly assigned there.

**DNP** means “do not populate”: leave that component position empty. **Fit in current draft** describes the current assembly choice, not stock or package qualification. **PROVISIONAL** and **validation required** remain open gates. Test pads and mounting holes are not purchased electronic components. J104 uses a header, but its charging-arm shunt must remain off before commissioning.

**Silkscreen side** tells you where the reference is printed; it is independent of the component mounting side in the CSV. Both faces now carry components. Back labels are mirrored in KiCad so they read normally when you turn the bare board over. Dense areas use reverse labels, which may be covered after assembly. Nine references are explicitly **Assembly map only** because no readable nearby silkscreen position was available: main C106, R102, R115, R116, R119, R124, U115; USB J901 and J902. U901 and D901 use independent board-text labels. Use the assembly maps to locate unprinted references.

Companion maps: main [front silkscreen](main-front.svg), [back silkscreen](main-back.svg) and [front assembly map](main-assembly.svg), [back assembly map](main-back-assembly.svg); USB [front silkscreen](usb-front.svg) and [back silkscreen](usb-back.svg).

## Prefix legend

| Prefix | Meaning | How to read it |
|---|---|---|
| R | Resistor | Sets resistance; a zero-ohm part is an electrical link. |
| RN | Resistor network | Matched resistors in one package; their ratio provides a stable reference. |
| C | Capacitor | Stores charge; often used for filtering or supply decoupling. |
| U | Integrated circuit | A chip or, in the schematic, an explicitly identified remote module. |
| J | Connector | A cable connection, socket or jumper/header position. |
| L | Inductor | Stores energy magnetically, for example in a switching supply. |
| Q | Transistor | An electronic switching or signal-control device. |
| D | Diode | Includes light-emitting diodes (LEDs). |
| RV | Adjustable resistor | A potentiometer or trimming resistor. |
| SW | Switch | A physical contact switch. |
| TP | Test pad | Bare PCB copper for a measurement probe; no fitted component. |
| H | Mounting hole | A mechanical PCB hole; no electronic component. |

## Main board

### 01  CHARGING + BATTERY

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C101](../../analyzer/Charging.kicad_sch#L5144) | Back | Capacitor | 1 microfarad / 25 volts X7R / 10% | Fit in current draft | — |
| [C102](../../analyzer/Charging.kicad_sch#L4598) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [C103](../../analyzer/Charging.kicad_sch#L5750) | Back | Capacitor | 47 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C104](../../analyzer/Charging.kicad_sch#L4384) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [C105](../../analyzer/Charging.kicad_sch#L7161) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [C106](../../analyzer/Charging.kicad_sch#L5252) | Assembly map only | Capacitor | 22 microfarads / 25 volts X5R / 20% | Fit in current draft | — |
| [C107](../../analyzer/Charging.kicad_sch#L6006) | Back | Capacitor | 22 microfarads / 25 volts X5R / 20% | Fit in current draft | — |
| [D101](../../analyzer/Charging.kicad_sch#L6446) | Back | Light-emitting diode (LED) | CHARGE (red) | Fit in current draft; PROVISIONAL footprint | — |
| [J101](../../analyzer/Charging.kicad_sch#L6808) | Front | Connector | USB HARNESS: 5V/GND/CC1/CC2/D+/D- | Fit in current draft; PROVISIONAL footprint | — |
| [J102](../../analyzer/Charging.kicad_sch#L6271) | Back | Connector | PACK PIGTAIL | Fit in current draft; PROVISIONAL footprint | PCB pigtail to RCY/BEC mate; verify red/black polarity; PCB land pending |
| [J103](../../analyzer/Charging.kicad_sch#L5634) | Back | Connector | PACK NTC: 103AT-2 | Fit in current draft; PROVISIONAL footprint | — |
| [J104](../../analyzer/Charging.kicad_sch#L7278) | Back | Jumper header | ARM: OPEN | Fit in current draft | Enables autonomous charging even when host power is off |
| [L101](../../analyzer/Charging.kicad_sch#L4715) | Back | Inductor | 1 microhenry / 74437349010 | Fit in current draft; PROVISIONAL footprint | — |
| [Q101](../../analyzer/Charging.kicad_sch#L6908) | Back | N-channel MOSFET transistor | 2N7002 | Fit in current draft | — |
| [R101](../../analyzer/Charging.kicad_sch#L7411) | Back | Resistor | 5.23 kilohms 1% | Fit in current draft | — |
| [R102](../../analyzer/Charging.kicad_sch#L5369) | Assembly map only | Resistor | 30.1 kilohms 1% | Fit in current draft | — |
| [R103](../../analyzer/Charging.kicad_sch#L4946) | Back | Resistor | 300 ohms / 1% / supported ILIM range | Fit in current draft | — |
| [R104](../../analyzer/Charging.kicad_sch#L4137) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [R105](../../analyzer/Charging.kicad_sch#L6561) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [R106](../../analyzer/Charging.kicad_sch#L4501) | Back | Resistor | 2.2 kilohms | Fit in current draft | — |
| [R107](../../analyzer/Charging.kicad_sch#L5045) | Back | Resistor | 10 kilohms | Fit in current draft | — |
| [SW101](../../analyzer/Charging.kicad_sch#L4821) | Back | Switch | BQ service wake / B3U-1000P | Fit in current draft; PROVISIONAL footprint | — |
| [U101](../../analyzer/Charging.kicad_sch#L5468) | Back | Integrated circuit | BQ25895RTWR | Fit in current draft | Single-cell battery charger controlled over I2C. |

### 02  SWITCHED 5 V

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C201](../../analyzer/Supply_5V.kicad_sch#L2395) | Back | Capacitor | 22 microfarads / 25 volts X5R / 20% | Fit in current draft | — |
| [C202](../../analyzer/Supply_5V.kicad_sch#L3352) | Back | Capacitor | 22 microfarads / 25 volts X5R / 20% | Fit in current draft | — |
| [C203](../../analyzer/Supply_5V.kicad_sch#L1991) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C204](../../analyzer/Supply_5V.kicad_sch#L2512) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [C205](../../analyzer/Supply_5V.kicad_sch#L2963) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [C206](../../analyzer/Supply_5V.kicad_sch#L3617) | Back | Capacitor | 22 microfarads / 16 volts X7R / 20% | Fit in current draft | — |
| [L201](../../analyzer/Supply_5V.kicad_sch#L2728) | Back | Inductor | 1.5 microhenries / XGL4030-152MEC | Fit in current draft | — |
| [R201](../../analyzer/Supply_5V.kicad_sch#L3253) | Back | Resistor | 1.62 megaohms 1% | Fit in current draft | — |
| [R202](../../analyzer/Supply_5V.kicad_sch#L3080) | Back | Resistor | 180 kilohms 1% | Fit in current draft | — |
| [R203](../../analyzer/Supply_5V.kicad_sch#L2629) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [U201](../../analyzer/Supply_5V.kicad_sch#L2825) | Back | Integrated circuit | TPS63020DSJR | Fit in current draft | Adjustable buck-boost voltage converter. |

### 03  GUITION + FUEL GAUGE

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C301](../../analyzer/Gauge_Interface.kicad_sch#L4468) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C302](../../analyzer/Gauge_Interface.kicad_sch#L5355) | Back | Capacitor | 4.7 microfarads / 16 volts X5R / 10% | Fit in current draft | — |
| [C303](../../analyzer/Gauge_Interface.kicad_sch#L5524) | Back | Capacitor | 4.7 microfarads / 16 volts X5R / 10% | Fit in current draft | — |
| [J301](../../analyzer/Gauge_Interface.kicad_sch#L4576) | Back | Connector | GUITION JP1 / 2x13 | Fit in current draft; PROVISIONAL footprint | Pin-for-pin cable to Guition JC4880P443C_I_W JP1 |
| [R301](../../analyzer/Gauge_Interface.kicad_sch#L4143) | Back | Resistor | 10 kilohms | Fit in current draft | — |
| [R302](../../analyzer/Gauge_Interface.kicad_sch#L3970) | Back | Resistor | 4.7 kilohms / FIT | Fit in current draft | — |
| [R303](../../analyzer/Gauge_Interface.kicad_sch#L3871) | Back | Resistor | 4.7 kilohms / FIT | Fit in current draft | — |
| [U301](../../analyzer/Gauge_Interface.kicad_sch#L4879) | Back | Integrated circuit | MAX17048G+ | Fit in current draft | Single-cell battery fuel gauge. |
| [U302](../../analyzer/Gauge_Interface.kicad_sch#L5077) | Back | Integrated circuit | LM66100DCKR | Fit in current draft | Blocks Guition USB-powered 5V rail from feeding our buck-boost output |

### 04  TWO OXYGEN INPUTS

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C401](../../analyzer/Oxygen.kicad_sch#L2838) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [C402](../../analyzer/Oxygen.kicad_sch#L4587) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C403](../../analyzer/Oxygen.kicad_sch#L2625) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C404](../../analyzer/Oxygen.kicad_sch#L4698) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [C405](../../analyzer/Oxygen.kicad_sch#L2949) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C406](../../analyzer/Oxygen.kicad_sch#L3783) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C407](../../analyzer/Oxygen.kicad_sch#L3570) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C408](../../analyzer/Oxygen.kicad_sch#L2514) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [C409](../../analyzer/Oxygen.kicad_sch#L4098) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [J401](../../analyzer/Oxygen.kicad_sch#L4462) | Front | Connector | AO2 / 3-pin cable | Fit in current draft; PROVISIONAL footprint | — |
| [J402](../../analyzer/Oxygen.kicad_sch#L4209) | Front | Connector | SMB male-centre / Amphenol142138 | Fit in current draft; PROVISIONAL footprint | — |
| [R401](../../analyzer/Oxygen.kicad_sch#L3681) | Back | Resistor | 100 ohms / 0.1% | Fit in current draft | — |
| [R402](../../analyzer/Oxygen.kicad_sch#L3996) | Back | Resistor | 100 ohms / 0.1% | Fit in current draft | — |
| [R403](../../analyzer/Oxygen.kicad_sch#L3264) | Back | Resistor | 1 megaohm / 1% | Fit in current draft | — |
| [R404](../../analyzer/Oxygen.kicad_sch#L3468) | Back | Resistor | 1 megaohm / 1% | Fit in current draft | — |
| [R405](../../analyzer/Oxygen.kicad_sch#L3162) | Back | Resistor | 100 ohms / 0.1% | Fit in current draft | — |
| [R406](../../analyzer/Oxygen.kicad_sch#L4360) | Back | Resistor | 100 ohms / 0.1% | Fit in current draft | — |
| [R407](../../analyzer/Oxygen.kicad_sch#L3366) | Front | Resistor | 1 megaohm / 1% | Fit in current draft | — |
| [R408](../../analyzer/Oxygen.kicad_sch#L2736) | Back | Resistor | 1 megaohm / 1% | Fit in current draft | — |
| [R409](../../analyzer/Oxygen.kicad_sch#L3060) | Back | Resistor | 10 kilohms / 0.1% | Fit in current draft | — |
| [R410](../../analyzer/Oxygen.kicad_sch#L3894) | Back | Resistor | 10 kilohms / 0.1% | Fit in current draft | — |
| [U401](../../analyzer/Oxygen.kicad_sch#L4806) | Back | Integrated circuit | ADS122C04IPWR | Fit in current draft | — |

### 05  HELIUM BRIDGE

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C501](../../analyzer/Helium.kicad_sch#L2961) | Back | Capacitor | 4.7 microfarads / 16 volts X5R / 10% | Fit in current draft | — |
| [C502](../../analyzer/Helium.kicad_sch#L3933) | Back | Capacitor | 4.7 microfarads / 16 volts X5R / 10% | Fit in current draft | — |
| [C503](../../analyzer/Helium.kicad_sch#L3285) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% / DNP | DNP — do not fit | — |
| [C504](../../analyzer/Helium.kicad_sch#L3822) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C505](../../analyzer/Helium.kicad_sch#L2617) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [C506](../../analyzer/Helium.kicad_sch#L3396) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C507](../../analyzer/Helium.kicad_sch#L2850) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C508](../../analyzer/Helium.kicad_sch#L3609) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C509](../../analyzer/Helium.kicad_sch#L4053) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [J501](../../analyzer/Helium.kicad_sch#L4266) | Back | Connector | MD62 cable / <=30 cm | Fit in current draft; PROVISIONAL footprint | — |
| [R501](../../analyzer/Helium.kicad_sch#L3507) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [R504](../../analyzer/Helium.kicad_sch#L3183) | Back | Resistor | 10 kilohms / 0.1% | Fit in current draft | — |
| [R505](../../analyzer/Helium.kicad_sch#L3720) | Back | Resistor | 10 kilohms / 0.1% | Fit in current draft | — |
| [R506](../../analyzer/Helium.kicad_sch#L4164) | Back | Resistor | 680 ohms / 0.1% | Fit in current draft | — |
| [R507](../../analyzer/Helium.kicad_sch#L3081) | Back | Resistor | 680 ohms / 0.1% | Fit in current draft | — |
| [RN501](../../analyzer/Helium.kicad_sch#L4399) | Back | Resistor network | Two matched 2 kilohm resistors; 1:1 divider | Fit in current draft | Fixed 1.5 V nominal MD62 bridge reference; software stores signed zero/span |
| [U501](../../analyzer/Helium.kicad_sch#L2728) | Front | Integrated circuit | TPS7A2030PDBVR | Fit in current draft | — |
| [U502](../../analyzer/Helium.kicad_sch#L4714) | Back | Integrated circuit | ADS122C04IPWR | Fit in current draft | — |

### 06  GAS-CHAMBER CLIMATE

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C601](../../analyzer/Environment.kicad_sch#L2145) | Back | Capacitor | 1 microfarad / 25 volts X7R / 10% | Fit in current draft | — |
| [J601](../../analyzer/Environment.kicad_sch#L2463) | Back | Connector | BME280 harness | Fit in current draft | — |
| [Q601](../../analyzer/Environment.kicad_sch#L2358) | Front | N-channel MOSFET transistor | BSS138 | Fit in current draft | — |
| [Q602](../../analyzer/Environment.kicad_sch#L2040) | Back | N-channel MOSFET transistor | BSS138 | Fit in current draft | — |
| [R601](../../analyzer/Environment.kicad_sch#L2816) | Back | Resistor | 0 ohms / fit: 3.3 volts | Fit in current draft | — |
| [R602](../../analyzer/Environment.kicad_sch#L1938) | Back | Resistor | 0 ohms / DNP: 5 volts option | DNP — do not fit | — |
| [R603](../../analyzer/Environment.kicad_sch#L2256) | Back | Resistor | 4.7 kilohms / DNP | DNP — do not fit | — |
| [R604](../../analyzer/Environment.kicad_sch#L2580) | Back | Resistor | 4.7 kilohms / DNP | DNP — do not fit | — |

### 07  EXPERIMENTAL CO

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C701](../../analyzer/Carbon_Monoxide.kicad_sch#L3541) | Back | Capacitor | 22 microfarads / 25 volts X5R / 20% | Fit in current draft | — |
| [C702](../../analyzer/Carbon_Monoxide.kicad_sch#L4114) | Back | Capacitor | 22 microfarads / 16 volts X5R / 20% | Fit in current draft | — |
| [C703](../../analyzer/Carbon_Monoxide.kicad_sch#L3781) | Back | Capacitor | 22 microfarads / 16 volts X5R / 20% | Fit in current draft | — |
| [C704](../../analyzer/Carbon_Monoxide.kicad_sch#L4461) | Back | Capacitor | 1 microfarad / 25 volts X7R / 10% | Fit in current draft | — |
| [C705](../../analyzer/Carbon_Monoxide.kicad_sch#L3661) | Back | Capacitor | 1 microfarad / 25 volts X7R / 10% | Fit in current draft | — |
| [C706](../../analyzer/Carbon_Monoxide.kicad_sch#L5144) | Back | Capacitor | 10 nanofarads / 50 volts X7R / 10% / DNP | DNP — do not fit | — |
| [C707](../../analyzer/Carbon_Monoxide.kicad_sch#L4003) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C708](../../analyzer/Carbon_Monoxide.kicad_sch#L4698) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [J701](../../analyzer/Carbon_Monoxide.kicad_sch#L4581) | Back | Connector | ZE07-CO harness | Fit in current draft | — |
| [L701](../../analyzer/Carbon_Monoxide.kicad_sch#L5644) | Front | Inductor | 1 microhenry / XGL4020-102MEC | Fit in current draft; validation required | — |
| [R701](../../analyzer/Carbon_Monoxide.kicad_sch#L5255) | Back | Resistor | 787 kilohms / 0.1% | Fit in current draft | — |
| [R702](../../analyzer/Carbon_Monoxide.kicad_sch#L5042) | Back | Resistor | 100 kilohms / 0.1% | Fit in current draft | — |
| [R703](../../analyzer/Carbon_Monoxide.kicad_sch#L4940) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [R704](../../analyzer/Carbon_Monoxide.kicad_sch#L3901) | Back | Resistor | 100 ohms | Fit in current draft | — |
| [R705](../../analyzer/Carbon_Monoxide.kicad_sch#L4359) | Back | Resistor | 100 ohms | Fit in current draft | — |
| [U701](../../analyzer/Carbon_Monoxide.kicad_sch#L4234) | Front | Integrated circuit | TPS61023DRLR | Fit in current draft | — |
| [U702](../../analyzer/Carbon_Monoxide.kicad_sch#L4809) | Back | Integrated circuit | TPS7A2030PDBVR | Fit in current draft | — |
| [U703](../../analyzer/Carbon_Monoxide.kicad_sch#L5357) | Back | Integrated circuit | TXU0202DCUR | Fit in current draft | — |

### 08  PUSH-BUTTON ON / OFF

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C801](../../analyzer/Power_Control.kicad_sch#L1728) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C802](../../analyzer/Power_Control.kicad_sch#L2070) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C803](../../analyzer/Power_Control.kicad_sch#L2423) | Back | Capacitor | 33 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C804](../../analyzer/Power_Control.kicad_sch#L2312) | Back | Capacitor | 1 microfarad / 16 volts X7R / 10% | Fit in current draft | — |
| [J801](../../analyzer/Power_Control.kicad_sch#L1839) | Front | Connector | POWER BUTTON / 1NO | Fit in current draft; PROVISIONAL footprint | Panel momentary normally-open contact; no load current |
| [J802](../../analyzer/Power_Control.kicad_sch#L2181) | Front | Connector | BUTTON LED +/- | Fit in current draft; PROVISIONAL footprint | — |
| [R801](../../analyzer/Power_Control.kicad_sch#L2738) | Front | Resistor | 5.1 kilohms | Fit in current draft | — |
| [R802](../../analyzer/Power_Control.kicad_sch#L2534) | Back | Resistor | 10 kilohms | Fit in current draft | — |
| [R803](../../analyzer/Power_Control.kicad_sch#L1968) | Back | Resistor | 100 kilohms | Fit in current draft | — |
| [R804](../../analyzer/Power_Control.kicad_sch#L2636) | Back | Resistor | 1 kilohm / DNP | DNP — do not fit | — |
| [U801](../../analyzer/Power_Control.kicad_sch#L2840) | Back | Integrated circuit | LTC2954CTS8-1 | Fit in current draft | Push-button controller. |

### 10  TEST PADS + BRING-UP

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [TP1001](../../analyzer/Testpoints.kicad_sch#L134) | Back | Test pad | GND | Bare test pad; no fitted component | — |
| [TP1002](../../analyzer/Testpoints.kicad_sch#L147) | Back | Test pad | USB_5V | Bare test pad; no fitted component | — |
| [TP1003](../../analyzer/Testpoints.kicad_sch#L160) | Front | Test pad | PACK_P | Bare test pad; no fitted component | — |
| [TP1004](../../analyzer/Testpoints.kicad_sch#L173) | Front | Test pad | VSYS | Bare test pad; no fitted component | — |
| [TP1005](../../analyzer/Testpoints.kicad_sch#L188) | Front | Test pad | VOUT_5V | Bare test pad; no fitted component | — |
| [TP1006](../../analyzer/Testpoints.kicad_sch#L201) | Back | Test pad | HOST_3V3 | Bare test pad; no fitted component | — |
| [TP1007](../../analyzer/Testpoints.kicad_sch#L214) | Back | Test pad | POWER_EN | Bare test pad; no fitted component | — |
| [TP1008](../../analyzer/Testpoints.kicad_sch#L227) | Back | Test pad | I2C_SCL | Bare test pad; no fitted component | — |
| [TP1009](../../analyzer/Testpoints.kicad_sch#L242) | Back | Test pad | I2C_SDA | Bare test pad; no fitted component | — |
| [TP1010](../../analyzer/Testpoints.kicad_sch#L255) | Front | Test pad | HE_3V0 | Bare test pad; no fitted component | — |
| [TP1011](../../analyzer/Testpoints.kicad_sch#L268) | Back | Test pad | HE_SENSE | Bare test pad; no fitted component | — |
| [TP1012](../../analyzer/Testpoints.kicad_sch#L281) | Back | Test pad | O2_VMID | Bare test pad; no fitted component | — |

### 11  USB SOURCE QUALIFICATION

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C110](../../analyzer/USB_Source_Control.kicad_sch#L2418) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C111](../../analyzer/USB_Source_Control.kicad_sch#L3030) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C112](../../analyzer/USB_Source_Control.kicad_sch#L4096) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [C113](../../analyzer/USB_Source_Control.kicad_sch#L4622) | Back | Capacitor | 100 nanofarads / 50 volts X7R / 10% | Fit in current draft | — |
| [Q110](../../analyzer/USB_Source_Control.kicad_sch#L4933) | Back | Transistor | DMN2056U-7 | Fit in current draft | — |
| [Q111](../../analyzer/USB_Source_Control.kicad_sch#L5118) | Back | Transistor | DMN2056U-7 | Fit in current draft | — |
| [R110](../../analyzer/USB_Source_Control.kicad_sch#L2116) | Back | Resistor | 887 kilohms / 1% | Fit in current draft | — |
| [R111](../../analyzer/USB_Source_Control.kicad_sch#L2267) | Back | Resistor | 33 kilohms / 1% | Fit in current draft | — |
| [R112](../../analyzer/USB_Source_Control.kicad_sch#L3190) | Back | Resistor | 10 kilohms / 1% | Fit in current draft | — |
| [R113](../../analyzer/USB_Source_Control.kicad_sch#L3643) | Back | Resistor | 97.6 kilohms / 0.1% | Fit in current draft | — |
| [R114](../../analyzer/USB_Source_Control.kicad_sch#L3794) | Back | Resistor | 10 kilohms / 0.1% | Fit in current draft | — |
| [R115](../../analyzer/USB_Source_Control.kicad_sch#L3945) | Assembly map only | Resistor | 10 kilohms / 1% | Fit in current draft | — |
| [R116](../../analyzer/USB_Source_Control.kicad_sch#L4782) | Assembly map only | Resistor | 1 kilohm / 0.1% | Fit in current draft | — |
| [R117](../../analyzer/USB_Source_Control.kicad_sch#L5303) | Back | Resistor | 100 kilohms / 1% | Fit in current draft | — |
| [R118](../../analyzer/USB_Source_Control.kicad_sch#L5454) | Back | Resistor | 100 kilohms / 1% | Fit in current draft | — |
| [U110](../../analyzer/USB_Source_Control.kicad_sch#L1643) | Back | Integrated circuit | TUSB320LAIRWBR | Fit in current draft | — |
| [U111](../../analyzer/USB_Source_Control.kicad_sch#L2611) | Back | Integrated circuit | PI3USB9201ZTAEX | Fit in current draft | — |
| [U112](../../analyzer/USB_Source_Control.kicad_sch#L4289) | Back | Integrated circuit | SN74AUP1G74DCUR | Fit in current draft | — |
| [U113](../../analyzer/USB_Source_Control.kicad_sch#L3374) | Front | Integrated circuit | TPS3808G01DBVR | Fit in current draft | — |

### 12  USB INPUT LIMITER

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C114](../../analyzer/USB_Input_Limiter.kicad_sch#L1176) | Back | Capacitor | 4.7 microfarads / 25 volts X7R / 10% | Fit in current draft | — |
| [R119](../../analyzer/USB_Input_Limiter.kicad_sch#L1025) | Assembly map only | Resistor | 19.2 kilohms / 0.1% | Fit in current draft | — |
| [R120](../../analyzer/USB_Input_Limiter.kicad_sch#L1345) | Back | Resistor | 10 kilohms / 1% | Fit in current draft | — |
| [U114](../../analyzer/USB_Input_Limiter.kicad_sch#L711) | Back | Integrated circuit | TPS22950CQDDCRQ1 | Fit in current draft | — |

### 13  USB OVERVOLTAGE PROTECTION

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [C115](../../analyzer/USB_Overvoltage.kicad_sch#L1340) | Back | Capacitor | 100 nanofarads / 50 volts X7R | Fit in current draft | — |
| [C116](../../analyzer/USB_Overvoltage.kicad_sch#L1500) | Back | Capacitor | 3.3 nanofarads / 50 volts C0G / 5% | Fit in current draft | — |
| [Q112](../../analyzer/USB_Overvoltage.kicad_sch#L2846) | Back | Transistor | DMN2056U-7 | Fit in current draft | — |
| [R121](../../analyzer/USB_Overvoltage.kicad_sch#L1843) | Back | Resistor | 34 kilohms / 0.1% / 10ppm | Fit in current draft | — |
| [R122](../../analyzer/USB_Overvoltage.kicad_sch#L2003) | Back | Resistor | 649 ohms / 0.1% / 10ppm | Fit in current draft | — |
| [R123](../../analyzer/USB_Overvoltage.kicad_sch#L2163) | Back | Resistor | 10 kilohms / 0.1% / 10ppm | Fit in current draft | — |
| [R124](../../analyzer/USB_Overvoltage.kicad_sch#L2323) | Assembly map only | Resistor | 21.5 kilohms / 0.1% / 25ppm | Fit in current draft | — |
| [R125](../../analyzer/USB_Overvoltage.kicad_sch#L2483) | Back | Resistor | 10 kilohms / 0.1% / 25ppm | Fit in current draft | — |
| [R126](../../analyzer/USB_Overvoltage.kicad_sch#L1660) | Back | Resistor | 1.65 kilohms / 0.1% | Fit in current draft | — |
| [R127](../../analyzer/USB_Overvoltage.kicad_sch#L2643) | Back | Resistor | 10 kilohms / 1% | Fit in current draft | — |
| [R128](../../analyzer/USB_Overvoltage.kicad_sch#L3049) | Back | Resistor | 100 kilohms / 1% | Fit in current draft | — |
| [U115](../../analyzer/USB_Overvoltage.kicad_sch#L944) | Assembly map only | Integrated circuit | TPS259470ARPWR | Fit in current draft | — |

### Mechanical mounting

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [H1](../../analyzer/Trimix_Analyzer.kicad_pcb#L29073) | Back | Mounting hole | 2.30 mm non-plated hole for M2 mounting | Mounting hole; no fitted component | — |
| [H2](../../analyzer/Trimix_Analyzer.kicad_pcb#L6742) | Back | Mounting hole | 2.30 mm non-plated hole for M2 mounting | Mounting hole; no fitted component | — |


## USB board

### 09  USB-A + USB-C INPUT

| Marking | Silkscreen side | Component type | Value or type | Fit status | Function stated in source |
|---|---|---|---|---|---|
| [D901](../../usb-input/Trimix_USB_Input.kicad_sch#L2455) | Front | Diode | TPD1E10B06DYAR | Fit in current draft | — |
| [J901](../../usb-input/Trimix_USB_Input.kicad_sch#L1380) | Assembly map only | Connector | USB4720-03-A | Fit in current draft | — |
| [J902](../../usb-input/Trimix_USB_Input.kicad_sch#L2624) | Assembly map only | Connector | TO MAIN J101 \| SAME PIN NUMBERS | Fit in current draft | — |
| [U901](../../usb-input/Trimix_USB_Input.kicad_sch#L2014) | Front | Integrated circuit | TPD4E05U06DQAR | Fit in current draft | — |

## Remote modules are separate

These two schematic references are off-board modules, so they are excluded from the 173-row PCB list:

- **U601 — GYBMEP / BME280-5V**: Off-board purchased module; verify actual chip ID and pull-up rail
- **U704 — ZE07-CO / off-board**: Experimental CO measurement; manufacturer excludes human safety use

The main schematic also shows J901/J902/U901/D901 for context; those four parts are counted once, on the separate USB board.

## Sources and checks

Generated: 2026-09-07T14:07:05.955918+00:00. KiCad CLI XML was freshly exported from both current schematics. Both native PCB files were loaded without saving.

Checks passed: exact 173-reference membership; 164 printed reference fields with correct front/back mirroring and 9 explicitly documented assembly-map-only references; exact schematic/native-board value and footprint agreement; native/schematic DNP agreement; twelve main test pads; two Ø2.30 mm mounting holes; and unchanged source files throughout generation.

The [verification receipt](component-reference-verification.json) includes all source hashes, full reference membership and DNP checks. Board hashes identify the source snapshot; later markings-only saves require regeneration to bind their new hashes.

| Source snapshot | SHA-256 |
|---|---|
| [Trimix_Analyzer.kicad_pcb](../../analyzer/Trimix_Analyzer.kicad_pcb) | `a3b5947a4b3d53cc4f905c464f7975963e18bc7d611ce47a21f470bf111a5346` |
| [Trimix_USB_Input.kicad_pcb](../../usb-input/Trimix_USB_Input.kicad_pcb) | `63d5742a1f8a2598a80c5d6a962a5551b9bebfa1a59c6780a00ab8ba3dd15ea7` |
| [main-fresh-netlist.xml](source/main-fresh-netlist.xml) | `1d9cd65d59b48c7a85b30863492eef4699a731c0607b1346fe60b818140fa21f` |
| [usb-fresh-netlist.xml](source/usb-fresh-netlist.xml) | `ec28b64cbd630cd4fa4753c59c4df9f517bdf823c91313bc97f8e1ef84e927d3` |
