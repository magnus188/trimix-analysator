# Chamber cable and dry-side termination

The intended arrangement is one sealed pigtail attached to the removable chamber. Connectors on the main board remain on the dry side. Disconnect the battery, then the chamber harness before withdrawing the chamber. Strain relief must carry cable loads without pulling on sensor leads, solder joints or the seal.

| Main-board contact | Remote termination | Conductors through chamber closure |
|---|---|---:|
| J501.1 HE_3V0 | MD62 outer compensator lead | 1 |
| J501.2 HE_SENSE | MD62 two middle leads joined locally and insulated | 1 |
| J501.3 GND | MD62 outer detector lead; detector body carries the square marking | 1 |
| J601.1 BME_VIN, .2 GND, .3 BME_SCL, .4 BME_SDA | Corresponding identified BME280 breakout terminals | 4 |
| J701.1 CO_5V28, .2 GND, .3 CO_TX_CABLE, .4 CO_RX_CABLE | Corresponding verified ZE07-CO supply/ground/UART terminals; TX/RX naming must be checked from the actual module's perspective | 4 |

This is **11 insulated conductors**, assuming the MD62 midpoint joint is made near the sensor. The four physical MD62 leads do not require four separate PCB contacts. This follows the [Winsen MD62 V1.3 manual, connection caution 1.6](https://www.winsen-sensor.com/d/files/thermal/md62.pdf): the two central leads form the output node, with detector and compensator outer leads connected to opposite supply ends. The CAD rods are illustrative and do not assign physical pin numbers. Verify the actual detector marking, lead order and unpowered element continuity before soldering. Do not treat wire colours as a pinout.

The selected oxygen sensor's electrical end remains in the dry enclosure. Its cable runs directly to J401 or J402 and does not add conductors to the wet-chamber feedthrough. Preserve the approved J402-above-J401 arrangement and clearance for the JJ right-angle plug.

## Closure and routing constraints

The earlier CAD bore is Ø4.4 mm with a Ø8.4 mm collar. It is an unqualified sealing provision. Eleven contact positions do not prove that eleven actual wires fit: insulation outside diameter, shared jacket, joints, potting gap, bend radius and strain relief must be specified. For example, eleven round 1.2 mm insulated wires occupy 12.44 mm² before packing gaps, compared with 15.21 mm² bore area; area alone does not establish a packable or sealable bundle. Do not force a bundle through or enlarge the bore without rechecking the collar's structural material and removal path.

Keep the wet-side conductors supported away from the active sensor faces, hot MD62 surfaces and the nominal 5 mm gas route. The seal material and cure products must be compatible with all sensors and the sample path; a generic silicone or epoxy is not automatically qualified. Keep connector bodies and disconnectable joints out of the wet path unless separately qualified.

Dry-side routing needs a complete model from the closure to each mated PCB plug, including bends and a service loop. A clear line or a short local connector envelope is insufficient. Record actual wire identity/OD, cut length, bend limit, end pin mapping, joint insulation, strain relief, seal process and continuity/leak results. All physical wiring, sealing, thermal and gas-response tests remain pending.
