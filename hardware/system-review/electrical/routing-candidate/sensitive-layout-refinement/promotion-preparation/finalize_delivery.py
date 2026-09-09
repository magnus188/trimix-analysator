"""Finalize promoted provenance only after canonical read-only checks pass."""
from pathlib import Path
import hashlib
import json
import shutil

P = Path(__file__).resolve().parent
S = P.parent
R = S.parents[4]
E = R / 'hardware/system-review/electrical'
F = S / 'frozen-local-bundle'
D = E / 'main-final'
V = S / 'post-promotion-verification'
plan = json.loads((P / 'promotion-plan.json').read_text())


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def rel(p):
    return str(p.relative_to(R))


def dump(p, d):
    p.write_text(json.dumps(d, indent=2) + '\n')


native = json.loads((V / 'canonical-drc.json').read_text())
assert not native['violations'] and not native['unconnected_items'] and not native.get('schematic_parity', []), 'Post-copy native findings'
route = json.loads((V / 'canonical-routing-audit.json').read_text())
# Accommodate the exact checker summary schema without assuming a missing count
# is a pass. The original 13 assertion records must be present and all true.
checks = route.get('checks')
assert isinstance(checks, list) and len(checks) == 13
assert all(c['passed'] for c in checks), 'Post-copy routing assertion failed'
for row in plan['source_files']:
    assert sha(R / row['destination']) == row['sha256'], row['destination']
for key in ['frozen_source_file_hashes', 'USB_canonical_hashes']:
    for row in plan[key]:
        assert sha(R / row['path']) == row['sha256'], row['path']
native_bindings = []
for src in sorted((F / 'hardware/pcb/analyzer').rglob('*')):
    if not src.is_file() or src.suffix == '.kicad_prl':
        continue
    dst = R / src.relative_to(F)
    assert dst.is_file() and sha(src) == sha(dst), rel(dst)
    native_bindings.append({'source': rel(src), 'destination': rel(dst), 'sha256': sha(dst)})
selections = json.loads((E / 'standard-part-selections.json').read_text())
assert selections['source_sha256'] == sha(E / 'analyzer-netlist.xml')
assert selections['parts']['C107']['MPN'] == 'C2012X5R1A476M125AC'
assert selections['parts']['C103']['MPN'] == 'C1005X7R1H473K050BE'
assert selections['parts']['R702']['MPN'] == 'RT0402BRD07100KL'

manifest_path = S / 'canonical-promotion-manifest.json'
m = json.loads(manifest_path.read_text())
m['post_copy_native_verification_pending'] = False
m['post_copy_native_verification'] = {'violations': 0, 'unconnected_items': 0, 'schematic_parity': 0,
    'routing_assertions': 13, 'drc_path': rel(V / 'canonical-drc.json'),
    'drc_sha256': sha(V / 'canonical-drc.json'),
    'routing_path': rel(V / 'canonical-routing-audit.json'),
    'routing_sha256': sha(V / 'canonical-routing-audit.json')}
m['native_input_bindings'] = native_bindings
for name in ['standard-part-selections.json', 'placement-change.json']:
    dst = E / name
    old = S / 'before-local-promotion' / rel(dst)
    m['active_updates'].append({'destination': rel(dst), 'previous_sha256': sha(old), 'sha256': sha(dst),
         'source_board_sha256': plan['source_board_sha256'], 'source_netlist_sha256': sha(E / 'analyzer-netlist.xml')})
m['preserved_checker_versions'] = {
    'previous_routing_checker': rel(S / 'before-local-promotion/hardware/system-review/electrical/audit_routing_geometry.py'),
    'reviewed_refinement_checker': rel(S / 'audit_local_routing_geometry.py'),
    'reviewed_refinement_checker_sha256': sha(S / 'audit_local_routing_geometry.py'),
    'active_checker_matches_reviewed_refinement': sha(E / 'audit_routing_geometry.py') == sha(S / 'audit_local_routing_geometry.py')}
dump(manifest_path, m)
shutil.copy2(manifest_path, D / 'canonical-promotion-manifest.json')
shutil.copy2(V / 'canonical-drc.json', D / 'canonical-drc.json')
shutil.copy2(V / 'canonical-routing-audit.json', D / 'canonical-routing-audit.json')
files = [{'path': str(p.relative_to(D)), 'sha256': sha(p), 'bytes': p.stat().st_size}
         for p in sorted(D.rglob('*')) if p.is_file() and p.name != 'delivery-manifest.json']
dump(D / 'delivery-manifest.json', {
    'status': 'Reviewed local power-layout prototype delivery; fabrication and physical acceptance HOLD',
    'canonical_board_sha256': sha(R / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'),
    'canonical_netlist_sha256': sha(E / 'analyzer-netlist.xml'),
    'source_geometry_manifest': rel(F / 'review/geometry-handoff-manifest.json'),
    'source_CAM_manifest': rel(F / 'review/cam-input-manifest.json'),
    'independent_CAM_receipt': rel(E / 'main-final-independent/final-0962ad86/verification-receipt.json'),
    'independent_CAM_receipt_sha256': sha(E / 'main-final-independent/final-0962ad86/verification-receipt.json'),
    'CAD_receipt': m['CAD_receipt'], 'CAD_receipt_sha256': m['CAD_receipt_sha256'],
    'previous_delivery_preserved': rel(S / 'before-local-promotion/main-final-9f274fdf'),
    'files': files, 'order_release': False})
print(json.dumps({'status': 'promotion and delivery provenance complete', 'native_bindings': len(native_bindings),
                  'delivery_files': len(files), 'promotion_manifest_sha256': sha(manifest_path),
                  'delivery_manifest_sha256': sha(D / 'delivery-manifest.json')}))
