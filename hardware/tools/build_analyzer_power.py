"""Build A2 power/interface sheets from the preserved P1.1 presentation.

The archived power project is read only. Pin intent starts from its separately
recorded intent and is changed explicitly, never inferred from the new netlist.
Run with the KiCad MCP Python environment (sexpdata).
"""
import copy
import json

from analyzer_sheet import (
    HW, P, VERIFY, Sheet, S, child, children, custom_symbol, effects, fmt,
    node, save, sheet_uuid, sx, tag, uid,
)

SEED = HW / 'kicad/power'
INTENT = json.loads((HW / 'verification/power/intended-nets.json').read_text())
RES = 'Resistor_SMD:R_0603_1608Metric'
CAP = 'Capacitor_SMD:C_0805_2012Metric'


def props(symbol):
    return {p[1]: p for p in children(symbol, 'property')}


def ref(symbol):
    return props(symbol)['Reference'][2]


def symbol(sheet, reference):
    return next(s for s in children(sheet.a, 'symbol') if ref(s) == reference)


def legacy(name, page):
    sheet = Sheet(name, page, name)
    sheet.a = sx.loads((SEED / (name + '.kicad_sch')).read_text())
    sheet.intent = copy.deepcopy(INTENT[name])
    child(sheet.a, 'uuid')[1] = sheet_uuid(name)
    tb = child(sheet.a, 'title_block')
    child(tb, 'rev')[1] = 'A2'
    for comment in children(tb, 'comment'):
        comment[2] = 'Engineering review draft | Charge-arm shunt initially OPEN'
    return sheet


def finish_legacy(sheet):
    for sy in children(sheet.a, 'symbol'):
        sy[:] = [v for v in sy if tag(v) != 'instances']
        sy.append(sheet.instance(ref(sy)))
    save(sheet.path, sheet.a)
    (VERIFY / (sheet.name + '-intent.json')).write_text(
        json.dumps(sheet.intent, indent=2) + '\n')


def replace_text(sheet, prefix, replacement):
    matches = [v for v in children(sheet.a, 'text') if v[1].startswith(prefix)]
    assert len(matches) == 1, (sheet.name, prefix, len(matches))
    matches[0][1] = replacement


def field(sy, name, value=None, xy=None, size=1.016):
    prop = props(sy)[name]
    if value is not None:
        prop[2] = value
    if xy is not None:
        child(prop, 'at')[1:] = [*xy, 0]
        prop[:] = [v for v in prop if tag(v) != 'effects']
        prop.append(effects(size, 'left'))


def make_global(label):
    name, at = label[1], child(label, 'at')[1:]
    label[0] = S('global_label')
    if child(label, 'shape') is None:
        label.insert(2, node('shape', S('bidirectional')))
    if not any(p[1] == 'Intersheetrefs' for p in children(label, 'property')):
        label.append(node('property', 'Intersheetrefs', '${INTERSHEET_REFS}',
                          node('at', *at), effects(hide=True)))


def panel(sheet, title, x, y, w, h):
    sheet.box(x, y, w, h, title)
    sheet.a.append(node('polyline', node('pts', node('xy', x, y+8.89),
                                           node('xy', x+w, y+8.89)),
                        node('stroke', node('width', .1524), node('type', S('default'))),
                        node('fill', node('type', S('none'))), node('uuid', uid())))


def horizontal_labels(sheet, reference, stub=5.08):
    """Use readable horizontal power labels on vertical passive components."""
    for number, net in sheet.intent[reference].items():
        pin = sheet.pins[reference][number]
        xy = sheet.pin(reference, number)
        assert pin['angle'] in (90, 270)
        end = (xy[0], round(xy[1] + (stub if pin['angle'] == 90 else -stub), 5))
        sheet.wire(xy, end)
        sheet.label(net, end, 0)
        sheet.done.add((reference, number))


def charging():
    s = legacy('Charging', 2)
    child(child(s.a, 'title_block'), 'rev')[1] = 'A2.2'
    child(child(s.a, 'title_block'), 'date')[1] = '2026-09-06'
    field(symbol(s, 'J101'), 'Value', 'FROM USB BOARD (2P)')
    replace_text(s, 'J101 brings 5 V from the two-pin',
        'J101 receives 5 V from the GCT USB daughterboard.\n'
        'J902 -> two-wire harness -> J101 (same pin numbers).\n'
        'See USB_Input, sheet 10; qualify before charging.')
    for label in s.a:
        if tag(label) in {'label', 'global_label'} and label[1] == 'ALLOW_CHG':
            label[1] = 'CHARGE_ARM'
    s.intent['Q101']['1'] = 'CHARGE_ARM'
    s.intent['R105']['1'] = 'CHARGE_ARM'
    field(symbol(s, 'R103'), 'Value', '620R 1%')
    field(symbol(s, 'J102'), 'Value', 'PACK PIGTAIL', (370.84, 100.33))
    # These pins identify the PCB cable termination, not the RCY housing's
    # physical terminal numbering. The RCY/BEC mate remains wire-to-wire.
    props(symbol(s, 'J102'))['Footprint'][2] = ''
    symbol(s, 'J102').append(node('property', 'Connection',
        'PCB pigtail to RCY/BEC mate; verify red/black polarity; PCB land pending',
        node('at', 365.76, 99.06, 0), effects(hide=True)))
    s.add('Jumper:Jumper_2_Open', 'J104', 'ARM: OPEN', 236.22, 177.8,
          {1: 'VSYS', 2: 'CHARGE_ARM'},
          footprint='Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical',
          field_at=(223.52, 166.37), properties={
              'Assembly': 'Fit header; do not fit shunt before commissioning',
              'Purpose': 'Enables autonomous charging even when host power is off',
          })
    replace_text(s, 'TRIMIX  /  POWER ELECTRONICS',
                 'TRIMIX  /  ANALYZER ELECTRONICS  /  SHEET 2')
    replace_text(s, '05  CHARGE ENABLE', '05  COMMISSIONING ARM & SERVICE WAKE')
    replace_text(s, 'P+ = protected red lead.',
        'J102 = PCB pigtail to the RCY/BEC cable mate.\n'
        'Red = protected P+; black = protected P-.\n'
        'FMA holder: 2 x 3400 mAh in parallel, 6800 mAh total.\n'
        'Verify polarity; no PCB-mounted RCY footprint is implied.')
    replace_text(s, 'HIGH at ALLOW_CHG',
        'J104 OPEN = charging disabled; R105 holds Q101 off.\n'
        'Fit the shunt only after cell/USB/NTC validation.\n'
        'Armed = autonomous charging with the host ON or OFF.\n'
        'SW101 is service wake/reset, not the front power button.')
    # Make space for the four-line note without crossing the section frame.
    note = next(v for v in children(s.a, 'text') if v[1].startswith('J104 OPEN'))
    child(note, 'at')[2] = 237.49
    replace_text(s, 'IINLIM: 450 mA',
        'Autonomous defaults: 4.208 V, 2.048 A charge setting.\n'
        'Floating D+/D- selects 500 mA input; actual charge\n'
        'current falls to match input power. ILIM: 620R (~0.57 A).\n'
        'No charger firmware is implemented; defaults need review.')
    replace_text(s, 'Matching labels connect,',
        'Matching labels connect electrically. VSYS also supplies the always-on pushbutton controller.\n'
        'BQ25895 I2C address = 0x6A. If firmware writes settings, disable its watchdog before host shutdown.\n'
        'Default settings return after complete charger power loss. Keep J104 OPEN until those settings are qualified.')
    finish_legacy(s)


def supply():
    s = legacy('Supply_5V', 3)
    removed = []
    for obj in s.a:
        if tag(obj) == 'symbol' and ref(obj) == 'J201':
            removed.append(obj)
        elif tag(obj) == 'wire':
            pts = [tuple(v[1:]) for v in children(child(obj, 'pts'), 'xy')]
            if any(p in {(99.06, 172.72), (99.06, 175.26)} for p in pts):
                removed.append(obj)
        elif tag(obj) == 'global_label' and child(obj, 'at')[1:3] == [92.71, 175.26]:
            removed.append(obj)
    for obj in removed:
        s.a.remove(obj)
    del s.intent['J201']
    for label in s.a:
        if tag(label) in {'label', 'global_label'} and label[1] == 'POWER_EN':
            make_global(label)
    replace_text(s, 'TRIMIX  /  POWER ELECTRONICS',
                 'TRIMIX  /  ANALYZER ELECTRONICS  /  SHEET 3')
    replace_text(s, '04  ON / OFF INPUT', '04  PUSHBUTTON CONTROLLER ENABLE')
    replace_text(s, 'Open J201 = ON.',
        'POWER_EN comes from the LTC2954-1 on sheet 9.\n'
        'R203 pulls EN up; the controller pulls it low to turn off.\n'
        'Only the regulated 5 V output is switched.')
    finish_legacy(s)


def gauge_interface():
    s = legacy('Gauge_Interface', 4)
    child(s.a, 'paper')[1] = 'A3'
    kept = []
    for obj in s.a:
        kind = tag(obj)
        if kind == 'symbol' and ref(obj) in {'J301', 'J302'}:
            continue
        if kind in {'global_label', 'label', 'text'} and child(obj, 'at')[1] >= 210:
            continue
        if kind == 'wire' and all(v[1] >= 210 for v in children(child(obj, 'pts'), 'xy')):
            continue
        if kind == 'rectangle' and child(obj, 'start')[1] >= 210:
            continue
        if kind == 'polyline':
            pts = children(child(obj, 'pts'), 'xy')
            if all(v[1] >= 210 for v in pts):
                continue
            if pts[0][2] == 41.91:
                pts[-1][1] = 401.32
        kept.append(obj)
    s.a = kept
    # GPIO28/29 is a new bus, so the touch-bus pull-ups cannot serve it.
    for part in children(s.a, 'symbol'):
        if ref(part) in {'R302', 'R303'}:
            child(part, 'dnp')[1] = S('no')
            next(p for p in children(part, 'property') if p[1] == 'Value')[2] = '4.7k / FIT'
    del s.intent['J301']
    del s.intent['J302']
    jp1 = {
        1: 'HOST_3V3', 2: 'VOUT_5V', 3: 'HOST_3V3', 4: 'VOUT_5V',
        5: 'GND', 6: 'GND', 7: None, 8: 'POWER_KILL_N',
        9: 'CO_UART_EN', 10: 'CO_UART_RX', 11: 'GAUGE_ALERT_N', 12: 'CO_UART_TX',
        13: 'CHG_INT_N', 14: 'I2C_SCL', 15: None, 16: 'GND',
        17: 'HE_ENABLE', 18: 'HOST_3V3', 19: 'POWER_INT_N', 20: None,
        21: 'I2C_SDA', 22: None, 23: None, 24: None, 25: None, 26: None,
    }
    s.add('Connector_Generic:Conn_02x13_Odd_Even', 'J301',
          'GUITION JP1 / 2x13', 304.8, 104.14, jp1, footprint='',
          field_at=(292.1, 66.04), properties={
              'Connection': 'Pin-for-pin cable to Guition JC4880P443C_I_W JP1',
              'Mechanical': 'Verify mating view, header pitch and cable current rating before PCB release',
              'Source': 'https://github.com/ultramcu/guition-jc4880p443c-i-w/blob/master/schematic/03-expand-io_usb-fs-hs_lcd-backlight.webp',
          })
    panel(s, '03  GUITION JP1 — POWER & SIGNALS', 212.09, 45.72, 189.23, 170.18)
    s.text('Pin numbers match the vendor JP1 drawing. Confirm the physical mating view.\n'
           '5 V flows TO Guition; HOST_3V3 returns FROM its switched 3.3 V regulator.',
           217.17, 129.54, 1.143)
    s.text('GPIO28 / pin21 = I2C SDA     GPIO29 / pin14 = I2C SCL\n'
           'GPIO30 / pin12 = CO TX      GPIO31 / pin10 = CO RX (host perspective)\n'
           'GPIO32 / pin19 = power INT  GPIO33 / pin8 = power KILL\n'
           'GPIO34 / pin17 = He enable  GPIO49 / pin13 = charger INT\n'
           'GPIO50 / pin11 = gauge ALT  GPIO51 / pin9 = CO UART enable',
           217.17, 144.78, 1.143)
    s.text('JP1 pins 23/25 belong to the existing GPIO7/8 touch bus and are unused here.\n'
           'GPIO35 (BOOT), GPIO52 and ESP32-C6 pins are deliberately unconnected.\n'
           'The firmware must add the new GPIO28/29 I2C bus; it is not implemented.',
           217.17, 175.26, 1.143)
    s.text('Disconnect Guition USB power for the button to switch the device fully off.\n'
           'Do not connect the protected pack to Guition CN4 / its onboard charger.\n'
           'Connector pitch, mechanical mate and cable ampacity remain to be verified.',
           217.17, 194.31, 1.143)
    replace_text(s, 'TRIMIX  /  POWER ELECTRONICS',
                 'TRIMIX  /  ANALYZER ELECTRONICS  /  SHEET 4')
    replace_text(s, '05  ERC POWER SOURCE MARKERS', '04  ERC POWER SOURCE MARKERS')
    replace_text(s, 'R301 pulls the alert',
        'R301 pulls the alert signal high.\n'
        'R302/R303: FIT 4.7k on this new bus.\n'
        'Verify rise time with the complete harness.\n'
        'I2C: gauge 0x36 / charger 0x6A.')
    replace_text(s, 'PACK_P = protected red',
        'PACK_P = protected red P+ / GND = protected black P-.\n'
        'Two 3400 mAh parallel cells: 6800 mAh nominal, one voltage stack.')
    finish_legacy(s)


def power_control():
    s = Sheet('Power_Control', 9, 'Momentary power button & safe shutdown',
              'The button switches the 5 V load. The armed charger remains available with the screen and sensors off.')
    panel(s, '01  PANEL BUTTON & INPUT FILTER', 20.32, 52.07, 114.3, 128.27)
    panel(s, '02  ALWAYS-ON POWER LATCH', 142.24, 52.07, 134.62, 128.27)
    panel(s, '03  HOST SHUTDOWN HANDSHAKE', 284.48, 52.07, 116.84, 128.27)
    panel(s, '04  BUTTON SEQUENCE & IMPLEMENTATION', 20.32, 189.23, 256.54, 67.31)
    panel(s, '05  SEPARATE BUTTON LED', 284.48, 189.23, 116.84, 58.42)
    latch = custom_symbol('LTC2954CTS8_1', [
        (1, 'VIN', 'power_in', -12.7, 10.16, 0),
        (2, '~{PB}', 'input', -12.7, 2.54, 0),
        (3, 'ONT', 'passive', -5.08, -15.24, 90),
        (4, 'GND', 'power_in', 0, -15.24, 90),
        (5, '~{INT}', 'open_collector', 12.7, -2.54, 180),
        (6, 'EN', 'open_collector', 12.7, 10.16, 180),
        (7, 'PDT', 'passive', 5.08, -15.24, 90),
        (8, '~{KILL}', 'input', 12.7, 2.54, 180),
    ], description='LTC2954-1 positive-enable pushbutton controller, TSOT-23-8 pinout',
       datasheet='https://www.analog.com/media/en/technical-documentation/data-sheets/2954fb.pdf')
    s.add('Trimix_Analyzer:LTC2954CTS8_1', 'U801', 'LTC2954CTS8-1', 208.28, 111.76,
          {1: 'VSYS', 2: 'PB_FILTERED_N', 3: 'PWR_ONT', 4: 'GND',
           5: 'POWER_INT_N', 6: 'POWER_EN', 7: 'PWR_PDT', 8: 'POWER_KILL_N'},
          footprint='Package_TO_SOT_SMD:TSOT-23-8', custom=latch,
          autowire=False, field_at=(200.66, 85.09))
    s.add('Connector_Generic:Conn_01x02', 'J801', 'POWER BUTTON / 1NO', 50.8, 101.6,
          {1: 'PANEL_PB_N', 2: 'GND'}, footprint='', angle=180,
          autowire=False, field_at=(29.21, 81.28), properties={
              'Connection': 'Panel momentary normally-open contact; no load current',
          })
    for key, yy in [('Reference', 78.74), ('Value', 81.28)]:
        prop = props(symbol(s, 'J801'))[key]
        child(prop, 'at')[1:] = [50.8, yy, 0]
        prop[:] = [v for v in prop if tag(v) != 'effects']
        prop.append(effects(1.016))
    s.add('Device:R', 'R801', '5.1k', 86.36, 101.6,
          {1: 'PANEL_PB_N', 2: 'PB_FILTERED_N'}, footprint=RES,
          angle=90, autowire=False, field_at=(81.28, 90.17))
    s.wire(s.pin('J801', 1), s.pin('R801', 1))
    s.done.update({('J801', '1'), ('R801', '1')})
    s.add('Device:C', 'C802', '100n / 10V', 111.76, 124.46,
          {1: 'PB_FILTERED_N', 2: 'GND'}, footprint=CAP, autowire=False,
          field_at=(116.84, 120.65))
    s.wire(s.pin('R801', 2), (111.76, 101.6), s.pin('C802', 1))
    s.label('PB_FILTERED_N', (111.76, 101.6), 0)
    s.done.update({('R801', '2'), ('C802', '1')})
    s.connect('J801')
    s.connect('C802')
    s.add('Device:C', 'C801', '100n / 10V', 162.56, 109.22,
          {1: 'VSYS', 2: 'GND'}, footprint=CAP, autowire=False,
          field_at=(166.37, 111.76))
    horizontal_labels(s, 'C801')
    s.add('Device:C', 'C803', '33n / 10V', 187.96, 154.94,
          {1: 'PWR_ONT', 2: 'GND'}, footprint=CAP, autowire=False,
          field_at=(193.04, 151.13))
    s.add('Device:C', 'C804', '1u / 10V', 238.76, 154.94,
          {1: 'PWR_PDT', 2: 'GND'}, footprint=CAP, autowire=False,
          field_at=(243.84, 151.13))
    s.wire(s.pin('U801', 3), (187.96, 127), s.pin('C803', 1))
    s.wire(s.pin('U801', 7), (238.76, 127), s.pin('C804', 1))
    s.done.update({('U801', '3'), ('C803', '1'), ('U801', '7'), ('C804', '1')})
    s.connect('C803'); s.connect('C804'); s.connect('U801')
    for r, x, value, net in [('R802', 325.12, '10k', 'POWER_INT_N'),
                              ('R803', 378.46, '100k', 'POWER_KILL_N')]:
        s.add('Device:R', r, value, x, 88.9, {1: 'HOST_3V3', 2: net},
              footprint=RES, autowire=False, field_at=(x+5.08, 85.09))
        horizontal_labels(s, r)
    s.add('Device:R', 'R804', '1k / DNP', 317.5, 219.71,
          {1: 'VOUT_5V', 2: 'BUTTON_LED_A'}, footprint=RES, dnp=True,
          angle=90, field_at=(309.88, 209.55))
    s.add('Connector_Generic:Conn_01x02', 'J802', 'BUTTON LED +/-', 373.38, 222.25,
          {1: 'BUTTON_LED_A', 2: 'GND'}, footprint='', field_at=(368.3, 209.55),
          properties={'Assembly': 'Keep R804 DNP until button LED voltage/polarity is confirmed'})
    s.text('J801 carries only the isolated switch contacts.\n'
           'The separate LED wires go to J802.\n'
           'Place R801/C802 close to U801.\n'
           'A normally-open contact closes PB to ground.',
           25.4, 148.59, 1.143)
    s.text('ONT: about 0.245 s to switch on.\n'
           'PDT: about 6.5 s held to force off.\n'
           'R203 on sheet 3 supplies the EN pull-up.',
           147.32, 169.545, 1.016)
    s.text('GPIO32 reads the debounced active-low interrupt.\n'
           'GPIO33 releases KILL during boot and normal use.\n'
           'After saving state, drive KILL low to turn off.\n'
           'Configure GPIO33 as open-drain; avoid a low glitch.\n'
           'R803 uses the switched 3.3 V rail so startup does\n'
           'not depend on firmware asserting an early hold.',
           289.56, 118.11, 1.143)
    s.text('HOST_3V3 must rise within the 400 ms minimum\n'
           'startup blanking period; verify on real hardware.',
           289.56, 160.02, 1.143)
    s.text('OFF: press for about 0.25 s; the converter, Guition and sensors turn on.\n'
           'ON: firmware should treat a deliberate press as a shutdown request, stop sensing,\n'
           'save state, then pull POWER_KILL_N low. This firmware is not implemented yet.\n'
           'A continuous ~6.5 s hold forces off even if the host hangs. Timing has component tolerance.\n'
           'The charger keeps working while OFF only after the commissioning ARM shunt is fitted.\n'
           'Guition USB must be disconnected for full power-off; do not use its CN4 battery input.',
           25.4, 207.01, 1.27)
    s.text('R804 initially DNP. Verify the ordered LED voltage,\n'
           'built-in resistor and polarity before fitting a value.',
           289.56, 241.3, 1.143)
    s.finish()


if __name__ == '__main__':
    charging()
    supply()
    gauge_interface()
    power_control()
    print('Wrote analyzer Charging, Supply_5V, Gauge_Interface and Power_Control with explicit intent.')
