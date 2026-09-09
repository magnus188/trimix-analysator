"""Verify independent audit rejects representative wrong wiring in scratch XML.

No KiCad source is modified. This validates the audit's failure paths, not the
electrical circuit or physical sensor behavior.
"""
from pathlib import Path
import contextlib
import copy
import importlib.util
import io
import json
import tempfile
import xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('electrical_audit', HERE / 'audit_electrical.py')
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)
source = ET.parse(HERE / 'analyzer-netlist.xml').getroot()


def node(root, ref, pin):
    return next(n for n in root.findall('./nets/net/node') if n.get('ref') == ref and n.get('pin') == pin)


def move(root, ref, pin, name):
    n = node(root, ref, pin)
    old = next(net for net in root.findall('./nets/net') if n in list(net))
    old.remove(n)
    dest = next(net for net in root.findall('./nets/net') if net.get('name') == name)
    dest.append(n)


def wrong_series(root):
    next(c for c in root.findall('./components/comp') if c.get('ref') == 'R506').find('value').text = '100R / 0.1%'


def swapped_adc_pin_function(root):
    lib = next(p for p in root.findall('./libparts/libpart') if p.get('part') == 'ADS122C04_PW')
    pins = {p.get('num'): p for p in lib.findall('./pins/pin')}
    a, b = pins['10'].get('name'), pins['11'].get('name')
    pins['10'].set('name', b); pins['11'].set('name', a)


def bad_value(root,ref,value):
    next(c for c in root.findall('./components/comp')if c.get('ref')==ref).find('value').text=value

faults = {
    'Protected limiter bypassed by raw VBUS':lambda r:move(r,'U114','2','USB_5V'),
    'Permission-absent feedback drain disconnected':lambda r:move(r,'Q112','3','GND'),
    'OVP AUXOFF moved off reset':lambda r:move(r,'U115','3','HOST_3V3'),
    'Unsupported BQ sub500mA resistor reintroduced':lambda r:bad_value(r,'R103','4.02k / 1%'),
    'Upstream50mA default resistor lost':lambda r:bad_value(r,'R119','300R / 1%'),
    'Incorrect OVLO divider':lambda r:bad_value(r,'R121','30k / 1%'),
    'He input goes to wrong differential pin': lambda r: move(r, 'U502', '11', 'HE_AIN_N'),
    'Old unsafe He limiting resistor restored': wrong_series,
    'USB CC1 and CC2 shorted': lambda r: move(r, 'J901', 'B5', node_net(r, 'J901', 'A5')),
    'SMB sensor return grounded': lambda r: move(r, 'J402', '2', 'GND'),
    'He enable accidentally tied high': lambda r: move(r, 'U501', '3', 'HOST_3V3'),
    'ADS package pin names swapped': swapped_adc_pin_function,
}


def node_net(root, ref, pin):
    n = node(root, ref, pin)
    return next(net.get('name') for net in root.findall('./nets/net') if n in list(net))


results = []
with tempfile.TemporaryDirectory(prefix='trimix-electrical-faults-') as tmp:
    audit.OUT = Path(tmp)
    audit.NETLIST = audit.OUT / 'input.xml'
    for name, mutate in [('Unmodified exported source', None), *faults.items()]:
        root = copy.deepcopy(source)
        if mutate:
            mutate(root)
        ET.ElementTree(root).write(audit.NETLIST, encoding='utf-8', xml_declaration=True)
        with contextlib.redirect_stdout(io.StringIO()):
            rc = audit.run()
        output = json.loads((audit.OUT / 'electrical-audit.json').read_text())
        expected = 0 if mutate is None else 1
        assert rc == expected, (name, rc, expected)
        results.append({'scenario': name, 'expected_exit': expected, 'actual_exit': rc,
                        'failed_assertions': [c['check'] for c in output['checks'] if c['status'] == 'fail']})
receipt = {'status': 'pass', 'baseline_acceptance': 1, 'representative_faults_rejected': len(faults),
           'limits': 'Tests the audit detection paths only; no physical evidence or order approval.', 'cases': results}
(HERE / 'audit-fault-tests.json').write_text(json.dumps(receipt, indent=2) + '\n')
print(json.dumps(receipt, indent=2))
