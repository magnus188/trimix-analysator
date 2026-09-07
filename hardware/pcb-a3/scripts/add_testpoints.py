"""Add twelve native test pads, preserving every existing schematic node.

Requires a verified source backup. Root overview receives only an added card;
all existing circuit pages remain byte-identical. Run once, then use KiCad CLI
to compare the exact before/after netlists and ERC reports.
"""
from pathlib import Path
import hashlib
import json
import re
import uuid
import xml.etree.ElementTree as ET

HW = Path(__file__).resolve().parents[2]
P = HW / 'kicad/analyzer'
V = HW / 'pcb-a3/verification'
ROOT = P / 'Trimix_Analyzer.kicad_sch'
NEW = P / 'Testpoints.kicad_sch'
FOOTPRINT = 'TestPoint:TestPoint_Pad_D1.0mm'
NETS = ['GND', 'USB_5V', 'PACK_P', 'VSYS', 'VOUT_5V', 'HOST_3V3',
        'POWER_EN', 'I2C_SCL', 'I2C_SDA', 'HE_3V0', 'HE_SENSE', 'O2_VMID']
ROOT_ID = 'be5f93e7-90aa-5980-82d3-22f711149c2a'
SHEET_ID = str(uuid.uuid5(uuid.NAMESPACE_URL, 'trimix:analyzer:A3:Testpoints'))


def q(s):
    return json.dumps(s, ensure_ascii=False)


def uid():
    return q(str(uuid.uuid4()))


def effects(size=1.27, bold=False, justify='left top'):
    return f'(effects (font (size {size} {size})' + (' (bold yes)' if bold else '') + f') (justify {justify}))'


def text(s, x, y, size=1.27, bold=False):
    return f'(text {q(s)} (at {x} {y} 0) {effects(size,bold)} (uuid {uid()}))'


def lib_testpoint():
    src = (Path('/Applications/KiCad/KiCad.app/Contents/SharedSupport/symbols') / 'Connector.kicad_sym').read_text()
    start = src.index('(symbol "TestPoint"')
    depth = 0
    quoted = False
    escaped = False
    for i in range(start, len(src)):
        c = src[i]
        if quoted:
            if escaped:
                escaped = False
            elif c == '\\':
                escaped = True
            elif c == '"':
                quoted = False
        elif c == '"':
            quoted = True
        elif c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                return src[start:i+1].replace('(symbol "TestPoint"', '(symbol "Connector:TestPoint"', 1)
    raise RuntimeError('Unterminated library symbol')


def pad(ref, net, x, y):
    footprint_property = f'(property "Footprint" {q(FOOTPRINT)} (at {x} {y} 0) (hide yes) {effects()})'
    sy = f'''(symbol (lib_id "Connector:TestPoint") (at {x} {y} 0) (unit 1)
        (in_bom no) (on_board yes) (dnp no) (uuid {uid()})
        (property "Reference" {q(ref)} (at {x-5.08} {y-9.525} 0) {effects()})
        (property "Value" {q(net)} (at {x} {y} 0) (hide yes) {effects()})
        {footprint_property}
        (property "Description" "Bare 1.0 mm copper probe pad; no fitted part" (at {x} {y} 0) (hide yes) {effects()})
        (pin "1" (uuid {uid()}))
        (instances (project "Trimix_Analyzer" (path "/{ROOT_ID}/{SHEET_ID}" (reference {q(ref)}) (unit 1)))))'''
    wire1 = f'(wire (pts (xy {x} {y}) (xy {x} {y+5.08})) (stroke (width 0) (type default)) (uuid {uid()}))'
    wire2 = f'(wire (pts (xy {x} {y+5.08}) (xy {x+10.16} {y+5.08})) (stroke (width 0) (type default)) (uuid {uid()}))'
    label = f'''(global_label {q(net)} (shape bidirectional) (at {x+10.16} {y+5.08} 0)
        {effects(1.27,False,'left')} (uuid {uid()})
        (property "Intersheetrefs" "${{INTERSHEET_REFS}}" (at {x+10.16} {y+5.08} 0) (hide yes) {effects()}))'''
    return '\n'.join([sy, wire1, wire2, label])


def main():
    assert not NEW.exists(), 'Refuse to overwrite an existing Testpoints sheet.'
    backup = json.loads((V / 'testpoints-source-backup.json').read_text())
    for path, digest in backup['source_hashes'].items():
        p = HW.parent / path
        assert hashlib.sha256(p.read_bytes()).hexdigest() == digest, f'Source changed since backup: {path}'
    old = ROOT.read_text()
    assert 'Testpoints.kicad_sch' not in old and ROOT_ID in old
    baseline = ET.parse(V / 'source-review/analyzer-fresh-netlist.xml').getroot()
    net_names = {n.get('name') for n in baseline.findall('./nets/net')}
    refs = {c.get('ref') for c in baseline.findall('./components/comp')}
    assert set(NETS) <= net_names
    assert not refs.intersection(f'TP{1001+i}' for i in range(12))

    nodes = [f'''(kicad_sch (version 20260306) (generator "eeschema") (generator_version "10.0")
        (uuid "{SHEET_ID}") (paper "A3")
        (title_block (title "Test pads and bring-up access") (date "2026-09-06") (rev "A3-TP1")
          (company "Trimix") (comment 1 "Engineering review draft - not released for manufacture"))
        (lib_symbols {lib_testpoint()})''']
    nodes += [text('TRIMIX / TEST PADS AND BRING-UP ACCESS',20.32,22.86,2.54,True),
              text('Twelve bare 1.0 mm copper pads. Matching global labels connect to the existing circuit pages.',20.32,34.29)]
    groups = [(20.32, '01  BATTERY AND USB', 0),
              (147.32, '02  HOST POWER AND CONTROL', 4),
              (274.32, '03  BUS AND SENSOR SIGNALS', 8)]
    for x, title, first in groups:
        nodes.append(f'(rectangle (start {x} 55.88) (end {x+116.84} 208.28) (stroke (width 0.254) (type default)) (fill (type none)) (uuid {uid()}))')
        nodes.append(text(title,x+3.81,62.23,1.524,True))
        for row in range(4):
            n = first + row
            nodes.append(pad(f'TP{1001+n}',NETS[n],x+20.32,85.09+row*30.48))
    nodes += [text('PROBE ACCESS',20.32,222.25,1.524,True),
              text('Place pads where a probe can reach them after opening the rear cover. Label each pad on silkscreen.',20.32,232.41),
              text('Use TP1001 as the circuit ground reference. HE_SENSE and O2_VMID require a high-impedance probe.',20.32,241.30),
              text('Do not bridge adjacent pads. Keep the charge-arm shunt open during initial power checks.',20.32,250.19),
              text('Verify pad locations, clearances and physical test access on the PCB; this page adds no circuit bias or switches.',20.32,259.08),
              '(embedded_fonts no)', ')']
    NEW.write_text('\n'.join(nodes)+'\n')

    # Compact fourth-row card stays left of the A3 title block; previous overview is untouched.
    x,y,w,h = 20.32,264.16,116.84,17.78
    card = f'''(sheet (at {x} {y}) (size {w} {h}) (fields_autoplaced yes)
        (stroke (width 0.381) (type default)) (fill (color 0 0 0 0)) (uuid "{SHEET_ID}")
        (property "Sheetname" "10  TEST PADS + BRING-UP" (at {x} {y} 0) (hide yes) {effects()})
        (property "Sheetfile" "Testpoints.kicad_sch" (at {x} {y+h} 0) (hide yes) {effects()})
        (instances (project "Trimix_Analyzer" (path "/{ROOT_ID}" (page "11")))))'''
    card += '\n'+text('10  TEST PADS + BRING-UP',x+3.81,y+3.81,1.524,True)
    card += '\n'+text('12 labelled probe pads / power, control and sensors',x+3.81,y+10.16,1.016)
    i = old.rfind(')')
    ROOT.write_text(old[:i]+card+'\n'+old[i:])
    intent = {f'TP{1001+i}':{'1':net} for i,net in enumerate(NETS)}
    (V / 'testpoints-intent.json').write_text(json.dumps(intent,indent=2)+'\n')
    print('Added Testpoints.kicad_sch and overview card;12 one-pin pads.')


if __name__ == '__main__':
    main()
