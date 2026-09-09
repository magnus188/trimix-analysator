"""Read-only native candidate test for the oxygen-connector carrier swap.

Run inspect_candidate() through the root agent's serial Fusion connection.
The function finds an open PCBFit document without activating it. All Boolean
operations use TemporaryBRepManager copies; no native entity or file is saved.
This is a candidate test, not a model edit or a physical-strength certificate.
"""
from pathlib import Path
import hashlib
import json
import sys

import adsk.core as core
import adsk.fusion as fusion

HW = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(HW / 'cad/rev04/scripts'))
from audit_a3 import _instances, attribute
from verification_a3 import _world_copy, _intersection_volume, _bbox_overlap

NAME = 'Trimix_Enclosure_A3_PCBFit'
CARRIER = 'Carrier / removable electronics tray'
PCB = 'PCB A3 - main four-layer placement'
VOLUME_TOLERANCE_MM3 = 1e-5

# Rectangular coordinates are world millimetres, minXYZ followed by maxXYZ.
# Restore only material that occupied the original carrier plate before its
# source-recorded old J401/J402 through-window cuts.
RESTORE = [
    ('old J402 window', [50.2, 88.59, 18.5, 59.71, 97.41, 20.5]),
    ('old J401 window', [53.45, 102.010001, 18.5, 56.15, 109.790001, 20.5]),
]
CUT = [
    ('new J401 tail opening', [53.95, 89.11, 18.4, 56.65, 96.89, 20.6]),
    ('new J402 coax opening', [50.0, 98.99, 18.4, 59.26, 107.81, 20.6]),
]
U_PARTS = [
    ('U floor', [50.2, 96.99, 15.0, 59.4, 109.81, 17.0]),
    ('U lower end wall', [50.2, 96.99, 15.0, 59.4, 98.99, 20.5]),
    ('U upper end wall', [50.2, 107.81, 15.0, 59.4, 109.81, 20.5]),
]
U_SWEEP = [50.2, 96.99, 15.0, 59.4, 109.81, 50.0]


def _mm_bounds(body):
    b = body.boundingBox
    return [[x * 10 for x in b.minPoint.asArray()],
            [x * 10 for x in b.maxPoint.asArray()]]


def _box(manager, bounds):
    lo, hi = bounds[:3], bounds[3:]
    if any(b <= a for a, b in zip(lo, hi)):
        raise ValueError('Invalid candidate box: ' + str(bounds))
    oriented = core.OrientedBoundingBox3D.create(
        core.Point3D.create(*[(a + b) / 20 for a, b in zip(lo, hi)]),
        core.Vector3D.create(1, 0, 0), core.Vector3D.create(0, 1, 0),
        *[(b - a) / 10 for a, b in zip(lo, hi)])
    body = manager.createBox(oriented)
    if body is None or not body.isTransient:
        raise RuntimeError('Temporary box creation failed.')
    return body


def _boolean(manager, target, tool, operation, label):
    if not target.isTransient or not tool.isTransient:
        raise RuntimeError('Refusing Boolean on a persistent CAD body: ' + label)
    if not manager.booleanOperation(target, tool, operation):
        raise RuntimeError('Temporary Boolean failed: ' + label)


def _service_removed(record):
    if record['group'] == 'rear_cover':
        return True
    if 'disconnect' in record['component'].lower() and 'mate' in record['component'].lower():
        return True
    return (record['group'] in ('pcb', 'carrier') and
            record['hardware'] is not None and record['hardware'].get('kind') == 'screw')


def _native_intersections(manager, moving, fixed):
    hits = []; candidates = 0
    for item in fixed:
        if not _bbox_overlap(moving.boundingBox, item['body'].boundingBox):
            continue
        candidates += 1
        # Bounds only select candidates. Every candidate is evaluated using an
        # actual native BRep Boolean intersection on exact world-instance copies.
        obstacle = _world_copy(manager, item['body'])
        amount = _intersection_volume(manager, moving, obstacle, bounds_checked=True)
        if amount > VOLUME_TOLERANCE_MM3:
            hits.append({'occurrence': item['path'], 'component': item['component'],
                         'body': item['body_name'], 'volume_mm3': amount})
    return {'fixed_bodies_considered': len(fixed), 'native_BRep_candidate_pairs': candidates,
            'hits': hits, 'status': 'clear_for_candidate_geometry' if not hits else 'interference_found'}


def inspect_candidate():
    app = core.Application.get()
    matches = [doc for doc in app.documents if doc.name.startswith(NAME)]
    if len(matches) != 1:
        raise RuntimeError('Expected exactly one open PCBFit document; no document was activated.')
    doc = matches[0]
    design = fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    if design is None:
        raise RuntimeError('PCBFit document has no Design product.')
    active_before = app.activeDocument
    before = {'timeline': design.timeline.count,
              'occurrences': design.rootComponent.allOccurrences.count,
              'modified': doc.isModified}
    manager = fusion.TemporaryBRepManager.get()
    records = []
    for occurrence, component, index, body in _instances(design):
        if not body.isSolid:
            continue
        path = occurrence.fullPathName if occurrence else 'ROOT'
        if 'daughterboard provisional' in path or 'future PCB allocation' in path:
            continue
        raw = attribute(component, 'hardware_definition')
        group = ((attribute(occurrence, 'physical_group') if occurrence else None)
                 or attribute(component, 'physical_group'))
        records.append({'path': path, 'component': component.name, 'index': index,
                        'body_name': body.name, 'body': body, 'group': group,
                        'hardware': json.loads(raw) if raw else None})
    carrier_records = [r for r in records if r['path'].startswith(CARRIER + ':')]
    if len(carrier_records) != 1:
        raise RuntimeError('Expected one current carrier solid: ' + str(len(carrier_records)))
    fixed = [r for r in records
             if not r['path'].startswith((CARRIER + ':', PCB + ':'))]
    if not any(r['component'] == '01 Shape A housing' for r in fixed):
        raise RuntimeError('Native housing obstacle was not selected.')
    if not any(r['group'] == 'button' for r in fixed):
        raise RuntimeError('Native button obstacles were not selected.')

    candidate = _world_copy(manager, carrier_records[0]['body'])
    native_volume = carrier_records[0]['body'].volume * 1000
    operations = []
    for label, bounds in RESTORE:
        _boolean(manager, candidate, _box(manager, bounds), fusion.BooleanTypes.UnionBooleanType, label)
        operations.append({'operation': 'restore_union', 'label': label, 'bounds_mm': bounds})
    for label, bounds in CUT:
        _boolean(manager, candidate, _box(manager, bounds), fusion.BooleanTypes.DifferenceBooleanType, label)
        operations.append({'operation': 'cut', 'label': label, 'bounds_mm': bounds})
    # Build one connected U separately, then unite it with the carrier. This
    # avoids relying on a disjoint floor-only union as an intermediate step.
    bridge = _box(manager, U_PARTS[0][1])
    for label, bounds in U_PARTS[1:]:
        _boolean(manager, bridge, _box(manager, bounds), fusion.BooleanTypes.UnionBooleanType, label)
    if bridge.lumps.count != 1:
        raise RuntimeError('Candidate U itself is not one connected lump.')
    _boolean(manager, candidate, bridge, fusion.BooleanTypes.UnionBooleanType, 'join complete U to carrier')
    operations.extend({'operation': 'U_union', 'label': label, 'bounds_mm': bounds}
                      for label, bounds in U_PARTS)
    if not candidate.isSolid or candidate.lumps.count != 1:
        raise RuntimeError('Candidate carrier is not one connected solid/lump: ' + str(candidate.lumps.count))
    static = _native_intersections(manager, candidate, fixed)

    removed = [r for r in fixed if _service_removed(r)]
    service_fixed = [r for r in fixed if not _service_removed(r)]
    carrier_screws = [r for r in removed if r['group'] in ('pcb', 'carrier')
                     and r['hardware'] and r['hardware']['kind'] == 'screw']
    if len(carrier_screws) != 2:
        raise RuntimeError('Expected two carrier/PCB screws in removal prerequisites.')
    sweep = _native_intersections(manager, _box(manager, U_SWEEP), service_fixed)
    after = {'timeline': design.timeline.count,
             'occurrences': design.rootComponent.allOccurrences.count,
             'modified': doc.isModified}
    if before != after or app.activeDocument != active_before:
        raise RuntimeError('Persistent document state or activation changed during read-only test.')
    data = {
        'status': ('candidate_static_and_U_sweep_clear' if not static['hits'] and not sweep['hits']
                   else 'candidate_requires_revision'),
        'document': doc.name, 'read_only': True, 'native_document_state_unchanged': before == after,
        'active_document_unchanged': True, 'before': before, 'after': after,
        'source_script_sha256': hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
        'coax_centre_local_mm': [4.45, 16.60], 'coax_centre_Fusion_mm': [54.85, 103.40],
        'candidate_lumps': candidate.lumps.count, 'candidate_is_solid': candidate.isSolid,
        'native_carrier_volume_mm3': native_volume, 'candidate_volume_mm3': candidate.volume * 1000,
        'candidate_bounds_mm': _mm_bounds(candidate), 'operations': operations,
        'static_carrier_against_fixed_native_parts': static,
        'U_continuous_sweep_bounds_mm': U_SWEEP, 'U_continuous_sweep_against_fixed_native_parts': sweep,
        'service_prerequisites': 'Rear cover off; battery disconnected; all PCB harnesses detached; two carrier screws removed. Battery holder and button stay installed.',
        'removed_fixed_occurrences': sorted(set(r['path'] for r in removed)),
        'source_clearance_arithmetic_mm': {'H2_fixed_web_Y_gap': 0.59, 'button_terminal_X_gap': 0.60,
            'display_envelope_to_floor_Z_gap': 0.90, 'supplied_proxy_tail_to_floor_Z_gap': 0.715,
            'J401_window_to_coax_cavity_plate_bridge': 2.10, 'J401_window_to_lower_U_wall_Y_gap': 0.10,
            'divider_X_gap': 0.0},
        'scope': 'Exact temporary candidate-carrier Booleans and fixed-part BRep intersections; candidate carrier must have one lump. The supplied U prism is a conservative continuous +Z sweep envelope for the new bridge only.',
        'limits': ['The old main PCB and old carrier are excluded as requested. This does not test the newly swapped PCB against the new carrier.',
                   'The complete swapped board/carrier assembly still needs its native static and full service checks.',
                   'Zero-volume face contact at the divider is not a physical print-fit clearance.',
                   'Actual coax pins, solder, mating connector, cable bends, display tolerances and structural strength remain unqualified.'],
    }
    print(json.dumps(data, indent=2))
    return data
