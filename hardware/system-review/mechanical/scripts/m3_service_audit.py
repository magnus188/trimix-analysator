"""Transient candidate service and explicit smooth-shaft/thread representation checks.

No parameter, native geometry, material, document save or source metadata edits.
The approved M2 checkpoint remains authoritative. M3 adoption is a later gate.
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

import m3_candidate_audit as candidate

OUT = candidate.OUT / 'service-and-thread'
CORE_SHA = 'e3604ecebeec60a903bdbad26a80c7140bcf45f7105e7fdb0072509d3d587af7'


def _write(name, value):
    path = OUT / name
    with path.open('x') as stream:
        stream.write(json.dumps(value, indent=2) + '\n')
    return value


def _proposed(manager, design, spec):
    """Repeat the eight-change simulation; retain every other actual solid."""
    import adsk.core as core
    import adsk.fusion as fusion
    import review_checks as review
    import wall_fastener_checks as fasteners
    import ruthex_m2_audit as rx
    import verification_a3 as v
    _, rows = review.records()
    hardware = fasteners._hardware_records(design, rows)
    by_name = {r['occurrence']: r for r in rows}
    hardware_by_name = {r['occurrence']: r for r in hardware}
    hosts = [r for r in rows if r['component'] == '01 Shape A housing']
    candidate._require(len(hosts) == 1, 'Expected one receiving housing')
    host = dict(hosts[0], body=manager.copy(hosts[0]['body']))
    original, source = candidate._official(manager)
    replacements = {}
    for placement in spec['candidate_placements_for_later_review']:
        old = hardware_by_name[placement['original_occurrence']]
        x, y, z = old['head_seat_mm']
        candidate._require(max(abs(a-b) for a,b in zip(old['head_seat_mm'], placement['open_face_mm_at_width85'])) < 1e-6, 'M3 pose changed')
        added = candidate._ring(manager, x, y, 30, 39, 4.2, 4.5)
        candidate._require(manager.booleanOperation(host['body'], added, fusion.BooleanTypes.UnionBooleanType), 'Copied boss addition failed')
        bore = rx._cylinder(manager, x, y, 34, 39.1, 2.2)
        candidate._require(manager.booleanOperation(host['body'], bore, fusion.BooleanTypes.DifferenceBooleanType), 'Copied pilot enlargement failed')
        body = manager.copy(original)
        matrix = core.Matrix3D.create()
        matrix.translation = core.Vector3D.create(x/10, y/10, (z-4)/10)
        candidate._require(manager.transform(body, matrix), 'Rigid candidate placement failed')
        row = dict(by_name[placement['original_occurrence']], body=body,
                   hardware=dict(old['hardware'], length_mm=4, outer_diameter_mm=5,
                                 source_step_sha256=candidate.SOURCE_SHA))
        row.pop('bounds_cm', None)
        v._record_bounds(row)
        replacements[row['occurrence']] = row
    host.pop('bounds_cm', None)
    v._record_bounds(host)
    replacements[host['occurrence']] = host
    return [replacements.get(r['occurrence'], r) for r in rows], replacements, source, hardware_by_name


def _thread(manager, spec, replacements, hardware):
    import adsk.fusion as fusion
    import ruthex_m2_audit as rx
    from runtime import bounds
    rows = []
    for placement in spec['candidate_placements_for_later_review']:
        insert = replacements[placement['original_occurrence']]
        screw = hardware[placement['paired_screw']]
        x, y, face = placement['open_face_mm_at_width85']
        h = screw['hardware']
        candidate._require(h['size'] == 'M3' and h['length_mm'] == 8 and h['shaft_diameter_mm'] == 2.9 and
                           max(abs(a-b) for a,b in zip(screw['head_seat_mm'], [x,y,41.35])) < 1e-6 and screw['target_position_error_mm'] < .001 and
                           screw['axial_extent_error_mm'] < .001, 'Actual retained screw source changed')
        overlap = manager.copy(insert['body'])
        candidate._require(manager.booleanOperation(overlap, screw['body'], fusion.BooleanTypes.IntersectionBooleanType), 'Thread/shaft intersection failed')
        candidate._require(overlap.volume*1000 > 1e-5, 'Expected explicit reference-model intersection is absent')
        # The tolerance padding only guards kernel boundary classification. The
        # exact source radii and unpadded nominal limits remain recorded below.
        band = candidate._ring(manager, x, y, face-4-.0001, face+.0001, 1.2645-.0001, 1.45+.0001)
        outside_band = candidate._difference_volume(manager, overlap, band)
        engaged_shaft = manager.copy(screw['body'])
        axial_section = rx._cylinder(manager, x, y, face-4, face, 2)
        candidate._require(manager.booleanOperation(engaged_shaft, axial_section, fusion.BooleanTypes.IntersectionBooleanType), 'Screw axial section failed')
        root_envelope = rx._cylinder(manager, x, y, face-4-.0001, face+.0001, 1.543)
        outside_root = candidate._difference_volume(manager, engaged_shaft, root_envelope)
        rows.append({'insert': insert['occurrence'], 'screw': screw['occurrence'],
                     'source_step_sha256': candidate.SOURCE_SHA, 'face_mm': [x, y, face],
                     'explicit_intersection_volume_mm3': overlap.volume*1000, 'intersection_bounds_mm': bounds(overlap),
                     'expected_engagement_annulus': {'inner_radius_mm': 1.2645, 'outer_radius_mm': 1.45,
                         'Z_mm': [face-4, face], 'boolean_boundary_padding_mm': .0001,
                         'intersection_outside_band_mm3': outside_band},
                     'shaft_within_manufacturer_thread_root_envelope': {'source_root_radius_mm': 1.543,
                         'actual_smooth_shaft_radius_mm': 1.45, 'nominal_radial_gap_mm': .093,
                         'shaft_outside_root_envelope_mm3': outside_root},
                     'nominal_axial_overlap_mm': 4, 'source_chamfers_mm_per_end': .3,
                     'central_allocation_excluding_source_chamfers_mm': 3.4,
                     'screw_tip_Z_mm': 33.35, 'screw_head_seat_Z_mm': 41.35,
                     'pass_representation_confinement': outside_band < 1e-5 and outside_root < 1e-5,
                     'physical_thread_engagement_qualified': False})
    return rows


def run():
    """Exact temporary thread confinement plus all eight paths and 14 drivers."""
    candidate._require(candidate._sha(candidate.__file__) == CORE_SHA, 'Frozen core simulation changed')
    candidate._require(not OUT.exists(), 'Preserve existing service/thread proof')
    app, doc, design, spec, receipt = candidate._guard()
    import adsk.fusion as fusion
    import review_checkpoint as checkpoint
    import verification_a3 as v
    import width_contract_checks as width
    from short_m2_validation import adapted
    before = checkpoint._state(design)
    others = checkpoint._documents(app, doc)
    modified = doc.isModified
    OUT.mkdir(parents=True)
    manager = fusion.TemporaryBRepManager.get()
    result = None
    hashes = {str(Path(__file__).resolve()): candidate._sha(__file__),
              str(Path(candidate.__file__).resolve()): CORE_SHA,
              str(candidate.SOURCE): candidate.SOURCE_SHA,
              str(candidate.OUT/'proposal.json'): candidate.PROPOSAL_SHA,
              str(candidate.OUT/'transient-core.json'): candidate._sha(candidate.OUT/'transient-core.json')}
    try:
        rows, replacements, source, hardware = _proposed(manager, design, spec)
        threads = _thread(manager, spec, replacements, hardware)
        _write('thread-confinement.json', {'generated_at_utc': datetime.now(timezone.utc).isoformat(),
                'interfaces': threads, 'manufacturer_model': source, 'source_sha256': hashes,
                'pass': all(q['pass_representation_confinement'] for q in threads),
                'scope': 'Only the four specified smooth nominal M3 shafts against the exact female-thread source; all explicit intersections retained.',
                'limits': ['Nominal M3 coarse identity is a design specification, not a purchased screw inspection.',
                    'Confinement in the thread-root envelope does not prove helical flank fit, runout, tolerance, engagement strength, pilot retention or torque.',
                    'No purchased geometry was scaled, trimmed or replaced. No unrelated pair is exempted.']})
        native_records = v._records
        # Copies already use actual world coordinates; repeated probes do not
        # change them. Every noncandidate physical/reference solid is retained.
        v._records = lambda d, m: rows
        try:
            with adapted(OUT):
                with width.allocations(OUT) as ic:
                    module, prior = ic._adapter(False)
                    try:
                        module.OUTPUT = OUT
                        paths = module.audit_paths()
                    finally:
                        module._records = prior
                    module, prior = ic._adapter(True)
                    try:
                        module.OUTPUT = OUT
                        drivers = module.audit_drivers()
                    finally:
                        module._records = prior
        finally:
            v._records = native_records
        result = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': doc.name,
                  'cloud_id': doc.dataFile.id, 'cloud_version': doc.dataFile.versionNumber,
                  'timeline': design.timeline.count, 'source_sha256': hashes, 'manufacturer_model': source,
                  'thread_interfaces': threads, 'service_status': paths['status'],
                  'path_counts': {q['name']: q['collision_count'] for q in paths['tests']},
                  'driver_status': drivers['status'], 'driver_count': len(drivers['tests']),
                  'driver_collision_count': sum(q['collision_count'] for q in drivers['tests']),
                  'pass': all(q['pass_representation_confinement'] for q in threads) and
                          all(not q['collision_count'] for q in paths['tests']+drivers['tests']),
                  'native_adopted': False, 'native_eight_parameter_regeneration_checked': False,
                  'limits': ['W85 transient candidate only. Eight native parameters and W87 regeneration still require adoption approval.',
                             'Paths are sampled actual BReps, accelerated only by verified enclosing-volume proofs; no continuous sweep, actual cable bend, hand or physical-fit qualification.',
                             'Existing source-bound placement-v2 R301/mated-connector finding remains historical and unchanged outside this candidate service scope.']}
    finally:
        preserved = before == checkpoint._state(design) and others == checkpoint._documents(app, doc) and modified == doc.isModified
        preserved = preserved and all(candidate._sha(p) == digest for p, digest in hashes.items())
        if result is not None:
            result['source_and_protected_documents_preserved'] = preserved
            result['pass'] = result['pass'] and preserved
            _write('summary.json', result)
        candidate._require(preserved, 'Transient candidate service altered source or protected documents')
    print(json.dumps({'path': str(OUT/'summary.json'), 'pass': result['pass']}))
    return result
