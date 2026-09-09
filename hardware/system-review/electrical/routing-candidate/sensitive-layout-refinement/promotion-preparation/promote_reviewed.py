"""Guarded promotion of the immutable 0962 source after parent CAD acceptance.

Default invocation verifies the prepared plan without changing active files.
The execute mode archives every replaced active payload before copying exact
reviewed bytes. It does not regenerate or modify frozen evidence.
"""
from pathlib import Path
import argparse
import csv
import datetime
import hashlib
import json
import os
import shutil

P = Path(__file__).resolve().parent
S = P.parent
R = S.parents[4]
E = R / 'hardware/system-review/electrical'
F = S / 'frozen-local-bundle'
PLAN = json.loads((P / 'promotion-plan.json').read_text())


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rel(path):
    return str(path.relative_to(R))


def write(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')


def verify():
    checks = 0
    for key in ['frozen_source_file_hashes', 'previous_delivery_file_hashes',
                'active_update_preconditions', 'USB_canonical_hashes']:
        for item in PLAN[key]:
            assert sha(R / item['path']) == item['sha256'], item['path']
            checks += 1
    for item in PLAN['source_files']:
        assert sha(R / item['source']) == item['sha256'], item['source']
        dst = R / item['destination']
        assert (sha(dst) if dst.exists() else None) == item['previous_sha256'], str(dst)
        checks += 2
    assert sha(R / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb') == PLAN['previous_board_sha256']
    assert PLAN['previous_board_sha256'] == '9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
    assert sha(E / 'main-final-independent/final-0962ad86/verification-receipt.json') == '4791f3d658d49fd5465f14843d4dbf527f23e8cc657f06377c9fb10cd10a0ed7'
    return checks


ap = argparse.ArgumentParser()
ap.add_argument('--execute', action='store_true')
ap.add_argument('--cad-receipt', type=Path)
a = ap.parse_args()
count = verify()
if not a.execute:
    print(json.dumps({'status': 'preflight passed; no active changes', 'hash_checks': count}))
    raise SystemExit(0)
assert a.cad_receipt and a.cad_receipt.is_file(), 'Parent-reviewed final CAD receipt is required'
cad = a.cad_receipt.resolve()
cad_hash = sha(cad)
backup = S / 'before-local-promotion'
assert not backup.exists(), 'Refuse to overwrite the preserved before-state'
backup.mkdir()

# Copy the complete native project, all replaced active files, and the entire
# previous delivery. No file is deleted without preservation.
shutil.copytree(R / 'hardware/pcb/analyzer', backup / 'hardware/pcb/analyzer')
prior = []
paths = {x['destination'] for x in PLAN['source_files']}
paths |= {x['path'] for x in PLAN['active_update_preconditions']}
for name in sorted(paths):
    src = R / name
    if src.is_file():
        dst = backup / name
        dst.parent.mkdir(parents=True, exist_ok=True)
        if not dst.exists():
            shutil.copy2(src, dst)
        assert sha(src) == sha(dst)
        prior.append({'path': name, 'backup': rel(dst), 'sha256': sha(dst)})
old_delivery = E / 'main-final'
old_delivery.rename(backup / 'main-final-9f274fdf')
write(backup / 'preservation-manifest.json', {
    'previous_board_sha256': PLAN['previous_board_sha256'],
    'files': prior,
    'old_delivery': rel(backup / 'main-final-9f274fdf'),
    'old_delivery_files': PLAN['previous_delivery_file_hashes'],
    'previous_frozen_bundle_and_promotion_manifests_unchanged': True,
})

for item in PLAN['source_files']:
    src, dst = R / item['source'], R / item['destination']
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    assert sha(dst) == item['sha256']

active_updates = []
for name in ['README.md', 'manufacturing-and-routing.md', 'measurement-and-bringup.md',
             'audit_routing_geometry.py', 'build_assembly_ledgers.py']:
    src, dst = P / name, E / name
    shutil.copy2(src, dst)
    active_updates.append({'source': rel(src), 'destination': rel(dst), 'sha256': sha(dst)})

# Replace the obsolete search snapshot with exact final all-reference poses and
# a bounded seven-footprint delta, retaining the historical snapshot in backup.
old_rows = {r['Reference']: r for r in csv.DictReader((backup / 'main-final-9f274fdf/cam/assembly-reference-map.csv').open())}
new_rows = {r['Reference']: r for r in csv.DictReader((F / 'cam/assembly-reference-map.csv').open())}
changed = json.loads((F / 'review/aggregate-delta.json').read_text())['changed_footprints']
pose_keys = ['Side', 'PCB_X_mm', 'PCB_Y_mm', 'Rotation_deg', 'Value', 'MPN', 'Footprint']
write(E / 'placement-change.json', {
    'status': 'Final source-bound placement record; historical search snapshot archived',
    'source_board_sha256': PLAN['previous_board_sha256'],
    'result_board_sha256': PLAN['source_board_sha256'],
    'changed': [{'reference': ref, 'before': {k: old_rows[ref][k] for k in pose_keys},
                 'after': {k: new_rows[ref][k] for k in pose_keys},
                 'note': 'Reference-display metadata only; physical pose unchanged' if ref == 'U701' else 'Reviewed native footprint/pose/part delta'} for ref in changed],
    'all_final_reference_poses': [{k: row[k] for k in ['Reference'] + pose_keys} for row in new_rows.values()],
    'native_DRC_pending': False,
    'native_DRC': 'zero violations, zero opens, zero schematic mismatch',
    'CAD_receipt': rel(cad), 'CAD_receipt_sha256': cad_hash,
    'mechanical_cable_qualification_pending': True,
    'order_release': False,
})

delivery = E / 'main-final'
delivery.mkdir()
for name in PLAN['copy_delivery_subdirectories']:
    shutil.copytree(F / name, delivery / name)
for name in ['cam-input-manifest.json', 'geometry-handoff-manifest.json',
             'supplementary-drawings-manifest.json']:
    shutil.copy2(F / 'review' / name, delivery / name)
shutil.copy2(F / 'assembly-notes.md', delivery / 'assembly-notes.md')
cad_link = os.path.relpath(cad, delivery)
readme = (P / 'main-final-README.md').read_text().replace(
    '__CAD_DISPOSITION__',
    'The [source-matched final CAD disposition](' + cad_link + ') is bound to this board, STEP and maximum-height contract. '
    'Digital interference checks do not qualify actual printed dimensions, part mates or cable bending.')
(delivery / 'README.md').write_text(readme)

assert sha(R / 'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb') == PLAN['source_board_sha256']
for item in PLAN['frozen_source_file_hashes']:
    assert sha(R / item['path']) == item['sha256'], item['path']
for item in PLAN['USB_canonical_hashes']:
    assert sha(R / item['path']) == item['sha256'], item['path']
manifest = {
    'status': 'Reviewed local power-layout source promoted under manufacturing and physical HOLD',
    'promoted_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'source_board_sha256': PLAN['source_board_sha256'],
    'previous_board_sha256': PLAN['previous_board_sha256'],
    'backup': rel(backup), 'source_files': PLAN['source_files'],
    'active_updates': active_updates,
    'CAD_receipt': rel(cad), 'CAD_receipt_sha256': cad_hash,
    'review_gates': [rel(S / 'root-final-review/root-power-layout-review.json'),
                     rel(S / 'root-final-review/root-contract-erc-review.json'),
                     rel(E / 'main-final-independent/final-0962ad86/verification-receipt.json'), rel(cad)],
    'canonical_board_matches_reviewed_exact_bytes': True,
    'frozen_bundle_unchanged': True,
    'USB_canonical_source_untouched': True,
    'physical_and_factory_qualification_pending': True,
    'post_copy_native_verification_pending': True,
    'order_release': False,
}
write(S / 'canonical-promotion-manifest.json', manifest)
print(json.dumps({'status': 'exact source copied and old delivery archived; complete post-copy verification and final delivery manifest',
                  'board_sha256': PLAN['source_board_sha256'], 'backup': rel(backup)}))
