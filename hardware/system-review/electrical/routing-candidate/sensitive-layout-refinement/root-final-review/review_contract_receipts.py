"""Independently bind the frozen refinement's ERC and electrical receipts."""
from pathlib import Path
import hashlib
import json

D = Path(__file__).resolve().parent
B = D.parent / 'frozen-local-bundle'
R = B / 'review'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda name: json.loads((R / name).read_text())

guard = read('erc-exception-guard.json')
identity = read('refinement-identity-audit.json')
electrical = read('electrical-audit.json')
faults = read('audit-fault-tests.json')
routing = read('routing-audit.json')
scope_faults = read('routing-scope-negative-controls.json')
drc = read('drc.json')
inputs = []
for name, row in guard['inputs'].items():
    path = Path(row['path'])
    assert sha(path) == row['sha256'], name
    inputs.append(dict(name=name, path=str(path), sha256=sha(path)))
assert guard['source_inputs_unchanged']
expected = dict(raw_error_count=1, reviewed_exception_count=1,
                unexpected_violation_count=0, warnings=0)
assert all(guard['verification'][k] == v for k, v in expected.items())
assert all(row['rejected'] for row in guard['negative_tests'])
assert not any(drc[k] for k in ('violations', 'unconnected_items', 'schematic_parity'))
board = B / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
assert sha(board) == identity['board_sha256'] == routing['board_sha256']
assert sha(R / 'analyzer-netlist.xml') == identity['netlist_sha256'] == electrical['netlist_sha256']
assert identity['passed'] == len(identity['checks']) == 205 and identity['failed'] == 0
assert all(row['passed'] for row in identity['checks'])
assert all(row['rejected'] for row in identity['negative_controls'])
assert electrical['checks_passed'] == len(electrical['checks']) == 217
assert electrical['checks_failed'] == 0 and all(row['status'] == 'pass' for row in electrical['checks'])
assert faults['representative_faults_rejected'] == 12
assert all(row['expected_exit'] == row['actual_exit'] for row in faults['cases'])
assert routing['passed'] == 13 and routing['failed'] == 0
assert len(scope_faults) == 3 and all(row['rejected_by'] for row in scope_faults)
names = ['erc-exception-guard.json', 'erc-raw.json', 'drc.json',
         'refinement-identity-audit.json', 'electrical-audit.json',
         'audit-fault-tests.json', 'routing-audit.json',
         'routing-scope-negative-controls.json', 'analyzer-netlist.xml']
result = dict(
    status='passed digitally', board_sha256=sha(board),
    scope='Receipt inspection and source-byte verification; no new ERC/DRC execution or physical qualification is claimed.',
    erc_counts=expected, native_drc=dict(violations=0, unconnected_items=0, schematic_parity=0),
    erc_negative_controls=len(guard['negative_tests']), electrical_assertions=217,
    identity_assertions=205, identity_negative_controls=4,
    electrical_negative_controls=12, routing_assertions=13, routing_negative_controls=3,
    source_inputs_checked=inputs,
    receipts=[dict(path=str((R / name).resolve()), sha256=sha(R / name)) for name in names],
    checker_sha256=sha(Path(__file__)), order_release=False,
    limits='The single LM66100 unused status-pin ERC exception remains explicitly reviewed. Manufacturer current limits, transient survival, real mates, final CAD and supplier process acceptance remain separate gates.')
(D / 'root-contract-erc-review.json').write_text(json.dumps(result, indent=2) + '\n')
print({k: result[k] for k in ('status', 'electrical_assertions', 'identity_assertions', 'erc_negative_controls')})
