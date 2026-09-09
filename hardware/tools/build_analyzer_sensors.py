"""Generate the two analogue sensor pages for the A2 analyzer review draft.

The pin maps below are independently specified from the TI ADS122C04 and
TPS7A20 data sheets. MD62 lead identification follows Winsen MD62 Manual V1.3;
its remote lead drawing is explanatory graphics, not a fabricated PCB footprint.
"""
from analyzer_sheet import Sheet as BaseSheet, node, S, uid, children, child
from sensor_calibration_parts import (adc_symbol, adc_pin_nets, divider_symbol,
    divider_properties, ADC_FP, ADS_DS, RN_FP)
from power_review_parts import LDO_ID, LDO_MPN, LDO_DS, ldo_symbol


def grid(value):
    return round(round(value / 1.27) * 1.27, 5)


class Sheet(BaseSheet):
    """Use a 50 mil electrical grid; annotation positions may be finer."""
    def add(self, lib_id, ref, value, x, y, nets, **kwargs):
        symbol = super().add(lib_id, ref, value, grid(x), grid(y), nets, **kwargs)
        if kwargs.get('angle', 0) == 180:
            for prop in children(symbol, 'property'):
                if prop[1] in ['Reference', 'Value']:
                    child(prop, 'at')[3] = 0
                    child(child(prop, 'effects'), 'justify')[1] = S('right')
        return symbol

    def wire(self, *points):
        return super().wire(*[(grid(x), grid(y)) for x, y in points])

    def label(self, net, xy, angle=0, global_label=True):
        return super().label(net, (grid(xy[0]), grid(xy[1])), angle, global_label)

R_FP = 'Resistor_SMD:R_0603_1608Metric'
C_FP = 'Capacitor_SMD:C_0603_1608Metric'
HEADER2 = 'Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical'
HEADER3 = 'Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical'
MD_DS = 'https://www.winsen-sensor.com/d/files/PDF/Thermal%20Conductor%20Gas%20Sensor/MD62%20Manual%20V1.3.pdf'


def wire_pin(s, ref, pin, *points):
    s.wire(s.pin(ref, pin), *points)
    s.done.add((ref, str(pin)))


def resistor(s, ref, value, x, y, a, b, angle=0, field_at=None, **kw):
    return s.add('Device:R', ref, value, x, y, {'1': a, '2': b},
                 footprint=R_FP, angle=angle, autowire=False,
                 field_at=field_at or (x+3.81, y-2.54), **kw)


def capacitor(s, ref, value, x, y, a, b, field_at=None, **kw):
    return s.add('Device:C', ref, value, x, y, {'1': a, '2': b},
                 footprint=C_FP, autowire=False,
                 field_at=field_at or (x+3.81, y-2.54), **kw)


def adc(s, ref, x, y, addr, inputs):
    # TI PW pinmap, not the different RTE/WQFN pinmap. A1 is tied to GND.
    s.add('Trimix_Analyzer:ADS122C04_PW', ref, 'ADS122C04IPWR', x, y,
          adc_pin_nets(addr, inputs), custom=adc_symbol(),autowire=False,
          footprint=ADC_FP, field_at=(x+20.32, y-33.02),
          properties={'Manufacturer':'Texas Instruments','MPN':'ADS122C04IPWR',
            'Primary_datasheet':ADS_DS,'Package':'TI PW TSSOP-16, 0.65 mm pitch',
            'Firmware_contract':'Internal 2.048 V reference; 20 SPS normal; signed data; IDAC and burn-out currents OFF',
            'Unused_pins':'REFP/REFN and DRDY NC per TI9.1.3; RESET=DVDD; poll DRDY status by I2C',
            'Decoupling':'Dedicated local AVDD-AVSS and DVDD-DGND capacitors, each >=100 nF',
            'I2C_address':'0x40' if addr=='GND' else '0x41'})
    # Short outward-facing ground labels avoid the existing filter/supply wires.
    for pin,sign in [(5,-1),(4,1)]:
        px,py=s.pin(ref,pin)
        wire_pin(s,ref,pin,(px,py+3.81),(x+sign*10.16,py+3.81))
        s.label('GND',(x+sign*10.16,py+3.81),180 if sign<0 else 0)
    s.connect(ref)


def supply_caps(s, refs, x1, x2, y, top, bottom, left, right):
    for ref, x, val in zip(refs, [x1, x2], ['100n', '1u / X7R']):
        capacitor(s, ref, val, x, y, 'HOST_3V3', 'GND')
        wire_pin(s, ref, 1, (x, top))
        wire_pin(s, ref, 2, (x, bottom))
    s.wire((left, top), (x2, top))
    s.wire((left, bottom), (x2, bottom))
    s.label('HOST_3V3', (left, top),180)
    s.label('GND', (left, bottom),180)


def oxygen_channel(s, letter, base, jref, rstart, cstart, coax=False):
    prefix = 'O2_' + letter
    neg_y, pos_y, mid_y = base+25.4, base+50.8, base+38.1
    connector_y = base+35.56
    note = ('SMB shell = SENSE-. Insulate it from the enclosure and GND; no 50 ohm load.'
            if coax else 'PCB harness convention: 1 = SENSE+, 2 = SENSE-, 3 = spare/NC. Verify all AO2 cable pins before mating.')
    s.box(20.32, base, 208.28, 76.2,
          ('2  |  OXYGEN B - ISOLATED COAX' if coax else '1  |  OXYGEN A - AO2 CABLE'), note)
    if coax:
        # The user owns an SMB Male PCB connector. Its actual land pattern and
        # mating half require inspection; do not silently pick another variant.
        s.add('Connector:Conn_Coaxial', jref, 'SMB Male PCB / verify fit', 43.18, connector_y,
              {'1': prefix+'_RAW_P', '2': prefix+'_RAW_N'}, angle=180,
              footprint='', on_board=True, in_bom=True, autowire=False,
              field_at=(24.13, base+58.42),
              properties={'Assembly_hold': 'Owned SMB Male PCB. Verify exact footprint and mating sensor connector; center = sensor +, shell = sensor -. Shell must not join GND/chassis.',
                          'Order_source': 'https://www.aliexpress.com/item/1005007851936695.html'})
        raw_minus = s.pin(jref, 2)
    else:
        s.add('Connector_Generic:Conn_01x03', jref, 'AO2 / 3-pin cable', 43.18, connector_y,
              {'1': prefix+'_RAW_P', '2': prefix+'_RAW_N', '3': None}, angle=180,
              footprint=HEADER3, autowire=False, field_at=(24.13, base+58.42),
              properties={'Assembly_hold': 'Three-position PCB harness convention only; third position is unused. Verify actual AO2 cable polarity, spare contact and mechanical mate before connection. Provisional header footprint.'})
        raw_minus = s.pin(jref, 2)
    wire_pin(s, jref, 2, (55.88, raw_minus[1]), (55.88, neg_y), (90.17, neg_y))
    wire_pin(s, jref, 1, (60.96, s.pin(jref,1)[1]), (60.96, pos_y), (90.17, pos_y))
    for suffix, y in [('N', neg_y), ('P', pos_y)]:
        s.wire((80.01, y), (80.01, y-5.08))
        s.label(prefix+'_RAW_'+suffix, (80.01, y-5.08), 180)
    for n, net, y in [(rstart, 'N', neg_y), (rstart+1, 'P', pos_y)]:
        ref = 'R'+str(n)
        resistor(s, ref, '100R / 0.1%', 93.98, y, prefix+'_RAW_'+net,
                 prefix+'_AIN_'+net, 90, (97.79, y-11.43))
        s.done.add((ref, '1'))
        wire_pin(s, ref, 2, (207.01, y))
        s.label(prefix+'_AIN_'+net, (207.01, y),0)
    # Equal 1 Mohm bias paths let both sensor leads float around mid-supply.
    resistor(s, 'R'+str(rstart+2), '1M / 1%', 121.92, mid_y-6.35,
             prefix+'_AIN_N', 'O2_VMID')
    resistor(s, 'R'+str(rstart+3), '1M / 1%', 121.92, mid_y+6.35,
             'O2_VMID', prefix+'_AIN_P')
    wire_pin(s, 'R'+str(rstart+2), 1, (121.92, neg_y))
    wire_pin(s, 'R'+str(rstart+2), 2, (121.92, mid_y))
    wire_pin(s, 'R'+str(rstart+3), 1, (121.92, mid_y))
    wire_pin(s, 'R'+str(rstart+3), 2, (121.92, pos_y))
    s.wire((114.3, mid_y), (121.92, mid_y))
    s.label('O2_VMID', (114.3, mid_y),180)
    capacitor(s, 'C'+str(cstart), '1u / X7R', 162.56, mid_y,
              prefix+'_AIN_N', prefix+'_AIN_P')
    wire_pin(s, 'C'+str(cstart), 1, (162.56, neg_y))
    wire_pin(s, 'C'+str(cstart), 2, (162.56, pos_y))
    for n, net, y in [(cstart+1, 'N', neg_y), (cstart+2, 'P', pos_y)]:
        ref = 'C'+str(n)
        capacitor(s, ref, '10n', 195.58, y+6.35, prefix+'_AIN_'+net, 'GND')
        wire_pin(s, ref, 1, (195.58, y))
        wire_pin(s, ref, 2, (195.58, y+12.7), (189.23, y+12.7))
        s.label('GND', (189.23, y+12.7),180)


def oxygen():
    s = Sheet('Oxygen', 5, 'Oxygen | two independent millivolt inputs',
              'Passive galvanic cells in a vented chamber - short cables <=30 cm - review draft')
    oxygen_channel(s, 'A', 48.26, 'J401', 401, 401)
    oxygen_channel(s, 'B', 130.81, 'J402', 405, 404, coax=True)
    s.box(238.76, 48.26, 157.48, 109.22, '3  |  24-BIT DIFFERENTIAL ADC - I2C 0x40')
    adc(s, 'U401', 312.42, 93.98, 'GND',
        ['O2_A_AIN_P', 'O2_A_AIN_N', 'O2_B_AIN_P', 'O2_B_AIN_N'])
    supply_caps(s, ['C407', 'C408'], 283.21, 340.36, 134.62,
                123.19, 147.32, 267.97, 351.79)
    s.text('C407: AVDD/AVSS; C408: DVDD/DGND. Place at their supply pins.',
           242.57, 152.4, 1.016)

    s.box(20.32, 213.36, 208.28, 53.34, '4  |  SHARED MID-SUPPLY BIAS')
    resistor(s, 'R409', '10k / 0.1%', 66.04, 232.41, 'HOST_3V3', 'O2_VMID')
    resistor(s, 'R410', '10k / 0.1%', 66.04, 251.46, 'O2_VMID', 'GND')
    wire_pin(s, 'R409', 1, (66.04, 226.06), (55.88, 226.06))
    s.label('HOST_3V3', (55.88, 226.06),180)
    wire_pin(s, 'R409', 2, (66.04, 241.3))
    wire_pin(s, 'R410', 1, (66.04, 241.3))
    wire_pin(s, 'R410', 2, (66.04, 260.35))
    capacitor(s, 'C409', '1u / X7R', 124.46, 251.46, 'O2_VMID', 'GND')
    wire_pin(s, 'C409', 1, (124.46, 241.3))
    wire_pin(s, 'C409', 2, (124.46, 260.35))
    s.wire((66.04, 241.3), (148.59, 241.3))
    s.label('O2_VMID', (148.59, 241.3),0)
    s.wire((55.88, 260.35), (124.46, 260.35))
    s.label('GND', (55.88, 260.35),180)
    s.text('1.65 V nominal\nHe ADC AIN3 monitors this bias.', 148.59, 228.6, 1.016)
    s.text('Both cell leads float.\nNeither sensor receives power.', 148.59, 253.365, 1.016)

    s.box(238.76, 165.1, 157.48, 85.09, '5  |  SETUP AND CABLE RULES')
    s.text('AIN0-AIN1 = O2 A; AIN2-AIN3 = O2 B.\nInternal 2.048 V reference; 20 SPS normal; signed data.\nStart oxygen gain 8, PGA ON; verify headroom before use.\nIDAC and burn-out currents OFF. Pairs are multiplexed.',
           242.57, 181.61, 1.016)
    s.text('No 50 ohm termination. No ground connection on SMB shell.\nCheck cell loading, reversed leads and power-off leakage\nwith the actual sensors before accepting readings.',
           242.57, 200.66, 1.016)
    s.text('J402 is the owned SMB Male PCB connector. Verify its\nland pattern and mating sensor plug before manufacture.\nA disconnected/shorted cell can resemble 0% O2;\ncalibration and plausibility checks are required.',
           242.57, 226.06, 1.016)
    return s.finish()


def graphic_line(s, *points):
    s.a.append(node('polyline', node('pts', *[node('xy', *p) for p in points]),
                    node('stroke', node('width', 0.254), node('type', S('default'))),
                    node('fill', node('type', S('none'))), node('uuid', uid())))


def graphic_rect(s, x, y, w, h, filled=False):
    s.a.append(node('rectangle', node('start', x, y), node('end', x+w, y+h),
                    node('stroke', node('width', 0.254), node('type', S('default'))),
                    node('fill', node('type', S('color' if filled else 'none')),
                         *([node('color', 0, 0, 0, 1)] if filled else [])), node('uuid', uid())))


def helium():
    s = Sheet('Helium', 6, 'Helium | MD62 thermal-conductivity bridge',
              'Winsen MD62 repurposed for He - constant 3.0 V excitation - calibration-dependent review draft')
    s.box(20.32, 48.26, 180.34, 86.36, '1  |  SWITCHED 3.0 V EXCITATION')
    ldo_nets = {'1': 'VOUT_5V', '2': 'GND', '3': 'HE_ENABLE', '4': None, '5': 'HE_3V0'}
    s.add(LDO_ID, 'U501', LDO_MPN, 101.6, 83.82,
          ldo_nets, custom=ldo_symbol(), autowire=False, footprint='Package_TO_SOT_SMD:SOT-23-5',
          field_at=(92.71, 70.485), properties={'Primary_datasheet': LDO_DS})
    assert {n: p['name'] for n, p in s.pins['U501'].items()} == {
        '1': 'IN', '2': 'GND', '3': 'EN', '4': 'NC', '5': 'OUT'}
    wire_pin(s, 'U501', 1, (81.28, 81.28), (81.28, 67.31), (43.18, 67.31))
    s.label('VOUT_5V', (43.18, 67.31),180)
    wire_pin(s, 'U501', 5, (132.08, 81.28), (132.08, 67.31), (177.8, 67.31))
    s.label('HE_3V0', (177.8, 67.31),0)
    for ref, x, net in [('C501', 50.8, 'VOUT_5V'), ('C502', 167.64, 'HE_3V0')]:
        capacitor(s, ref, '4.7u / X7R / 10V', x, 82.55, net, 'GND')
        wire_pin(s, ref, 1, (x, 67.31))
        wire_pin(s, ref, 2, (x, 106.68))
    capacitor(s, 'C503', '10n / DNP: obsolete bypass', 127.0, 99.06, None, 'GND', dnp=True)
    wire_pin(s, 'C503', 2, (127.0, 106.68))
    wire_pin(s, 'U501', 2, (101.6, 106.68))
    wire_pin(s, 'U501', 3, (86.36, 83.82), (86.36, 93.98), (65.405, 93.98))
    s.label('HE_ENABLE', (65.405, 93.98),180)
    resistor(s, 'R501', '100k', 76.2, 100.33, 'HE_ENABLE', 'GND')
    wire_pin(s, 'R501', 1, (76.2, 93.98))
    wire_pin(s, 'R501', 2, (76.2, 106.68))
    s.wire((43.18, 106.68), (167.64, 106.68))
    s.label('GND', (43.18, 106.68),180)
    s.text('3.0 V +/-0.1 V at the sensor; operating current <=120 mA.\nEnable after HOST_3V3 is valid; disable before the ADC loses power.\nLDO may dissipate 0.24 W. Verify temperature and cable voltage drop.',
           24.13, 120.015, 1.016)

    s.box(208.28, 48.26, 187.96, 86.36, '2  |  REMOTE MD62 - THREE-WIRE HARNESS')
    s.add('Connector_Generic:Conn_01x03', 'J501', 'MD62 cable / <=30 cm', 241.3, 86.36,
          {'1': 'HE_3V0', '2': 'HE_SENSE', '3': 'GND'}, angle=180, footprint=HEADER3,
          field_at=(217.17, 69.85), properties={
              'Assembly_hold': 'PROVISIONAL PCB header. Join both inner MD62 leads remotely. D black mark outer lead = GND; C outer lead = +3V.',
              'Primary_datasheet': MD_DS})
    s.text('PCB assignment:\n1 = +3 V, 2 = joined midpoint, 3 = GND.\nMD62 has no assumed numeric lead order.',
           212.09, 107.95, 1.016)
    # Explanatory remote element drawing, intentionally no footprint/pins.
    graphic_line(s, (335.28, 66.04), (335.28, 73.66))
    graphic_rect(s, 332.74, 73.66, 5.08, 12.7)
    graphic_line(s, (335.28, 86.36), (335.28, 96.52))
    graphic_line(s, (335.28, 91.44), (304.8, 91.44))
    graphic_rect(s, 332.74, 96.52, 5.08, 12.7)
    graphic_line(s, (335.28, 109.22), (335.28, 118.11))
    graphic_rect(s, 341.63, 103.505, 2.54, 2.54, True)
    s.text('+3 V: outer C', 344.17, 66.04, 1.016)
    s.text('C / compensator', 344.17, 80.01, 1.016)
    s.text('Join inner leads', 296.545, 87.63, 1.016)
    s.text('D / detector', 347.98, 99.06, 1.016)
    s.text('Black mark', 347.98, 106.68, 1.016)
    s.text('GND: outer D', 344.17, 118.11, 1.016)
    s.text('Winsen Manual V1.3: bridge + marked detector lead, pp. 1 and 3.',
           212.09, 129.54, 1.016)

    s.box(20.32, 142.24, 180.34, 121.92, '3  |  BRIDGE REFERENCE AND EXCITATION CHECK')
    s.add('Trimix_Analyzer:ACAS0606_2R_MATCHED','RN501','2x2k / 1:1 matched',
          66.04,196.85,{'1':'HE_3V0','4':'HE_REF','2':'HE_REF','3':'GND'},
          custom=divider_symbol(),footprint=RN_FP,autowire=False,
          field_at=(24.13,171.45),properties=divider_properties())
    wire_pin(s, 'RN501', 1, (66.04, 161.29), (44.45, 161.29))
    s.label('HE_3V0', (44.45, 161.29),180)
    wire_pin(s, 'RN501', 3, (66.04, 233.68), (44.45, 233.68))
    s.label('GND', (44.45, 233.68),180)
    wire_pin(s,'RN501',4,(88.9,191.77),(88.9,196.85))
    wire_pin(s,'RN501',2,(88.9,201.93),(88.9,196.85))
    s.label('HE_REF',(88.9,196.85),0)
    resistor(s, 'R504', '10k / 0.1%', 142.24, 176.53, 'HE_3V0', 'HE_EXC_DIV')
    resistor(s, 'R505', '10k / 0.1%', 142.24, 217.17, 'HE_EXC_DIV', 'GND')
    capacitor(s, 'C504', '100n', 179.07, 217.17, 'HE_EXC_DIV', 'GND')
    wire_pin(s, 'R504', 1, (142.24, 161.29), (132.08, 161.29))
    s.label('HE_3V0', (132.08, 161.29),180)
    wire_pin(s, 'R504', 2, (142.24, 196.85))
    wire_pin(s, 'R505', 1, (142.24, 196.85))
    wire_pin(s, 'C504', 1, (179.07, 196.85))
    s.wire((142.24, 196.85), (179.07, 196.85))
    s.label('HE_EXC_DIV', (152.4, 196.85), 90)
    wire_pin(s, 'R505', 2, (142.24, 233.68))
    wire_pin(s, 'C504', 2, (179.07, 233.68))
    s.wire((130.81, 233.68), (179.07, 233.68))
    s.label('GND', (130.81, 233.68),180)
    s.text('RN501: matched 2k + 2k; HE_REF = excitation / 2 (1.5 V nominal).\nNo manual trim. Store signed zero and span/curve with known reference gases.\nHE_EXC_DIV remains separate; it does not sense remote cable drop.',
           24.13, 250.825, 1.016)

    s.box(208.28, 142.24, 187.96, 107.95, '4  |  24-BIT DIFFERENTIAL ADC - I2C 0x41')
    adc(s, 'U502', 330.2, 182.88, 'HOST_3V3',
        ['HE_AIN_P', 'HE_AIN_N', 'HE_EXC_DIV', 'O2_VMID'])
    supply_caps(s, ['C508', 'C509'], 245.11, 276.86, 181.61,
                166.37, 198.12, 232.41, 284.48)
    for ref, y, src, dest in [('R506', 213.36, 'HE_REF', 'HE_AIN_P'),
                              ('R507', 232.41, 'HE_SENSE', 'HE_AIN_N')]:
        resistor(s, ref, '680R / 0.1%', 254.0, y, src, dest, 90, (246.38, y-8.89))
        wire_pin(s, ref, 1, (235.585, y))
        s.label(src, (235.585, y),180)
        wire_pin(s, ref, 2, (345.44, y))
        s.label(dest, (345.44, y),0)
    capacitor(s, 'C505', '1u / X7R', 281.94, 222.25, 'HE_AIN_P', 'HE_AIN_N')
    wire_pin(s, 'C505', 1, (281.94, 213.36))
    wire_pin(s, 'C505', 2, (281.94, 232.41))
    for ref, y, net in [('C506', 219.71, 'HE_AIN_P'), ('C507', 238.76, 'HE_AIN_N')]:
        capacitor(s, ref, '10n', 325.12, y, net, 'GND')
        wire_pin(s, ref, 1, (325.12, y-6.35))
        wire_pin(s, ref, 2, (325.12, y+6.35), (318.77, y+6.35))
        s.label('GND', (318.77, y+6.35),180)
    s.text('REF-SENSE: gain 1, PGA bypass; +/-2.048 V.\n20 SPS normal; IDAC/burn-out OFF; signed data.\nAIN2 = excitation / 2; AIN3 = O2 bias.\nC508: AVDD/AVSS; C509: DVDD/DGND.\nKnown gases + controlled T/RH/pressure/flow.',
           352.425, 218.44, 0.889)
    # Keep the full conditioning/experimental limitation in a readable footer.
    s.text('MD62 is a thermal-conductivity sensor, not selective to He. Conditioning and gas-specific calibration are mandatory; no factory He accuracy is specified.',
           20.32, 271.78, 1.016)
    return s.finish()


if __name__ == '__main__':
    # These original templates do not include every later connector annotation.
    # Require a staging directory so a template run cannot erase live edits.
    import argparse
    from pathlib import Path
    import analyzer_sheet as shared
    parser=argparse.ArgumentParser(description='Generate sensor templates into a staging directory; live sheets use surgical upgrades.')
    parser.add_argument('--output-dir',required=True)
    args=parser.parse_args()
    output=Path(args.output_dir).resolve()
    if output==shared.P.resolve():parser.error('The live analyzer directory is not a valid staging destination.')
    shared.P=output
    shared.VERIFY=output/'intent'
    for path in [oxygen(), helium()]:
        print(path)
