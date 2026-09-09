"""Transient main-carrier screw checks over the finished PCB thickness limits.

Call audit() in the owned SystemReview document. No CAD body, occurrence,
parameter or joint is changed; only the JSON verification receipt is written.
"""
from datetime import datetime, timezone
from pathlib import Path
from math import sqrt
import hashlib

import adsk.core as core

from runtime import BASE, GROUP, configure, other_documents, owned, report

MAIN_PREFIX = 'PCB A3 - main four-layer placement:'
THICKNESSES_MM = (1.44, 1.60, 1.76)
BACK_SEAT_Z_MM = 20.5
NOMINAL_THICKNESS_MM = 1.6
INSERT_FACE_Z_MM = 18.5
POSE_TOLERANCE_MM = .001
EXPECTED_INSERT_LENGTH_MM = 4.0


def _pose(record):
    return {
        'occurrence': record['occurrence'],
        'definition': record['hardware'],
        'under_head_or_insert_face_mm': record['head_seat_mm'],
        'axis': record['axis'],
        'axial_extents_from_face_mm': record['actual_axial_limits_mm'],
        'position_expressions': record['position_expressions'],
        'joint_bound': record['joint_bound'],
        'target_position_error_mm': record['target_position_error_mm'],
        'axial_extent_error_mm': record['axial_extent_error_mm'],
    }


def _pose_ok(record):
    return (record['joint_bound']
            and record['target_position_error_mm'] is not None
            and record['target_position_error_mm'] < POSE_TOLERANCE_MM
            and record['axial_extent_error_mm'] < POSE_TOLERANCE_MM
            and max(abs(a-b) for a, b in zip(record['axis'], (0, 0, 1))) < 1e-6)


def _translated(manager, screw, delta_z_mm, w, v):
    """Translate a separate world-space solid and its reference point together."""
    body = manager.copy(screw['body'])
    if body is None or not body.isTransient:
        raise RuntimeError('Cannot copy main screw to transient geometry')
    transform = core.Matrix3D.create()
    transform.translation = core.Vector3D.create(0, 0, delta_z_mm/10)
    if not manager.transform(body, transform):
        raise RuntimeError('Cannot translate transient main screw')
    row = dict(screw, body=body,
               head_seat_mm=[screw['head_seat_mm'][0], screw['head_seat_mm'][1],
                             screw['head_seat_mm'][2]+delta_z_mm])
    # The inherited cache refers to the original solid and must be replaced.
    row.pop('bounds_cm', None)
    v._record_bounds(row)
    row['actual_axial_limits_mm'] = w._axial_limits(row, row['axis'])
    return row


def _candidates(screw, inserts, w):
    result = []
    for insert in inserts:
        if screw['hardware']['size'] != insert['hardware']['size']:
            continue
        delta = w._minus(insert['head_seat_mm'], screw['head_seat_mm'])
        axial = w._dot(delta, screw['axis'])
        radial = sqrt(max(0, w._dot(delta, delta)-axial*axial))
        parallel = w._dot(screw['axis'], insert['axis'])
        overlap = max(0, min(0, axial+insert['actual_axial_limits_mm'][1])
                      - max(screw['actual_axial_limits_mm'][0],
                            axial+insert['actual_axial_limits_mm'][0]))
        if radial <= w.COAXIAL_TOLERANCE_MM and parallel > .999999 and overlap > 0:
            result.append((insert, radial, axial, overlap))
    return result


def _collisions(manager, screw, obstacles, v, tolerance):
    hits = []
    for row in obstacles:
        if row['occurrence'] == screw['occurrence']:
            continue
        if not v._numeric_overlap(v._record_bounds(screw), v._record_bounds(row)):
            continue
        volume = v._intersection_volume(manager, screw['body'], row['body'], True)
        if volume > tolerance:
            hits.append({'occurrence': row['occurrence'], 'component': row['component'],
                         'body': row['name'], 'intersection_volume_mm3': volume})
    return hits


def audit():
    """Measure nominal poses, then move only transient screws by -0.16/0/+0.16Z."""
    configure()
    import audit_a3 as a
    import verification_a3 as v
    import wall_fastener_checks as w
    import review_checks

    app, doc, design = owned()
    before = a._bodies(design)
    timeline = design.timeline.count
    other_before = other_documents(app)
    manager, rows = review_checks.records()
    hardware = w._hardware_records(design, rows)
    screws = [r for r in hardware if r['hardware']['kind'] == 'screw'
              and r['physical_group'] == 'pcb']
    if len(screws) != 2 or any(r['hardware']['size'] != 'M2'
                               or abs(r['hardware']['length_mm']-7) > 1e-6
                               for r in screws):
        raise RuntimeError('Expected exactly two main-carrier M2 x 7 screws')
    screws.sort(key=lambda r: r['occurrence'])
    inserts = [r for r in hardware if r['hardware']['kind'] == 'insert']
    actual_main = [r for r in rows if r['occurrence'].startswith(MAIN_PREFIX)]
    if not actual_main:
        raise RuntimeError('Actual main STEP wrapper is missing; exclusion cannot be verified')
    alternatives = [r for r in rows if r['physical_group'] == 'alternative_oxygen_reference']
    physical = v._without(rows, actual_main, alternatives)
    nominal_seat_z = BACK_SEAT_Z_MM+NOMINAL_THICKNESS_MM
    actual_backseat = w._mm(design, 'PcbZ')
    nominal_poses_ok = (abs(actual_backseat-BACK_SEAT_Z_MM) < POSE_TOLERANCE_MM
                        and all(_pose_ok(s) and abs(s['head_seat_mm'][2]-nominal_seat_z)
                                < POSE_TOLERANCE_MM for s in screws))
    nominal_pairs = {}
    for screw in screws:
        options = _candidates(screw, inserts, w)
        if len(options) != 1:
            raise RuntimeError('Expected one coaxial insert for '+screw['occurrence'])
        insert = options[0][0]
        nominal_pairs[screw['occurrence']] = insert
        nominal_poses_ok = (nominal_poses_ok and _pose_ok(insert)
                            and abs(insert['head_seat_mm'][2]-INSERT_FACE_Z_MM) < POSE_TOLERANCE_MM
                            and abs(insert['hardware']['length_mm']-EXPECTED_INSERT_LENGTH_MM) < 1e-6)

    cases = []
    for thickness in THICKNESSES_MM:
        delta = thickness-NOMINAL_THICKNESS_MM
        moved = [_translated(manager, s, delta, w, v) for s in screws]
        by_occurrence = {r['occurrence']: r for r in moved}
        # Both screws adopt the same thickness case. Every other retained solid
        # stays at its actual installed pose, including both receiving inserts.
        obstacles = [by_occurrence.get(r['occurrence'], r) for r in physical]
        pairs = []
        for screw in moved:
            options = _candidates(screw, inserts, w)
            if len(options) != 1:
                raise RuntimeError('Thickness case has ambiguous insert pairing')
            insert, radial, axial, overlap = options[0]
            same_insert = insert['occurrence'] == nominal_pairs[screw['occurrence']]['occurrence']
            probe = w._tip_probe(manager, screw, obstacles)
            collisions = _collisions(manager, screw, obstacles, v, w.VOLUME_TOLERANCE_MM3)
            engagement_ok = overlap+1e-6 >= 2.0
            passed = (nominal_poses_ok and same_insert and engagement_ok
                      and probe['passes_selected_nominal_gap'] and not collisions)
            pairs.append({
                'screw': screw['occurrence'], 'insert': insert['occurrence'],
                'hypothetical_under_head_origin_mm': screw['head_seat_mm'],
                'axis': screw['axis'],
                'actual_axial_extents_from_under_head_mm': screw['actual_axial_limits_mm'],
                'fixed_insert_open_face_mm': insert['head_seat_mm'],
                'coaxial_offset_mm': radial, 'head_to_insert_open_face_mm': -axial,
                'nominal_axial_thread_overlap_mm': overlap,
                'required_selected_overlap_mm': 2.0,
                'engagement_meets_one_nominal_diameter': engagement_ok,
                'same_insert_as_nominal': same_insert, 'tip_clearance': probe,
                'moved_screw_solid_collisions': collisions,
                'status': 'selected_geometric_checks_passed' if passed else 'needs_review',
            })
        cases.append({'finished_board_thickness_mm': thickness,
                      'hypothetical_board_bottom_Z_mm': BACK_SEAT_Z_MM,
                      'hypothetical_board_top_Z_mm': BACK_SEAT_Z_MM+thickness,
                      'transient_screw_translation_mm': [0, 0, delta], 'pairs': pairs})

    all_pairs = [p for case in cases for p in case['pairs']]
    passed = all(p['status'] == 'selected_geometric_checks_passed' for p in all_pairs)
    per_screw = []
    for screw in screws:
        selected = [p for p in all_pairs if p['screw'] == screw['occurrence']]
        per_screw.append({'screw': screw['occurrence'],
                          'minimum_axial_overlap_mm': min(p['nominal_axial_thread_overlap_mm'] for p in selected),
                          'maximum_axial_overlap_mm': max(p['nominal_axial_thread_overlap_mm'] for p in selected),
                          'minimum_tip_clear_distance_lower_bound_mm': min(p['tip_clearance']['clear_distance_lower_bound_mm'] for p in selected)})
    wrappers = [o for o in design.rootComponent.occurrences if o.fullPathName.startswith(MAIN_PREFIX)]
    installed_sources = []
    for wrapper in wrappers:
        values = {}
        for key in ('source_step_sha256', 'source_step_file', 'integration_status'):
            item = wrapper.component.attributes.itemByName(GROUP, key)
            values[key] = item.value if item else None
        installed_sources.append(dict(occurrence=wrapper.fullPathName, **values))
    source_paths = [Path(__file__), Path(w.__file__), Path(v.__file__),
                    Path(review_checks.__file__), Path(__file__).with_name('runtime.py')]
    stackup = BASE.parent/'electrical/stackup-review.json'
    if stackup.exists():
        source_paths.append(stackup)
    source_hashes = {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in source_paths}
    _, current_doc, _ = owned()
    preserved = (design.timeline.count == timeline and a._bodies(design) == before
                 and other_documents(app) == other_before
                 and current_doc.dataFile.id == doc.dataFile.id
                 and current_doc.name == doc.name)
    if not preserved:
        raise RuntimeError('Thickness audit source geometry/document state preservation check failed')
    result = {
        'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': doc.name,
        'status': 'selected_thickness_cases_geometrically_clear' if passed else 'needs_review',
        'finished_board_thickness_cases_mm': list(THICKNESSES_MM),
        'fixed_backseat_Z_mm': BACK_SEAT_Z_MM, 'measured_PcbZ_parameter_mm': actual_backseat,
        'nominal_finished_board_thickness_mm': NOMINAL_THICKNESS_MM,
        'nominal_pose_preflight_passed': nominal_poses_ok,
        'measured_nominal_screws': [_pose(s) for s in screws],
        'measured_fixed_inserts': [_pose(nominal_pairs[s['occurrence']]) for s in screws],
        'cases': cases, 'per_screw_extrema': per_screw,
        'minimum_axial_overlap_mm': min(p['nominal_axial_thread_overlap_mm'] for p in all_pairs),
        'maximum_axial_overlap_mm': max(p['nominal_axial_thread_overlap_mm'] for p in all_pairs),
        'excluded_actual_main_STEP_solids': len(actual_main),
        'excluded_main_wrapper_prefix': MAIN_PREFIX,
        'excluded_alternative_reference_solids': len(alternatives),
        'retained_physical_obstacle_solids': len(physical),
        'installed_main_sources': installed_sources, 'source_sha256': source_hashes,
        'tip_required_selected_gap_mm': w.TIP_REQUIRED_NOMINAL_GAP_MM,
        'coaxial_tolerance_mm': w.COAXIAL_TOLERANCE_MM,
        'intersection_volume_tolerance_mm3': w.VOLUME_TOLERANCE_MM3,
        'source_state_preserved': True, 'persistent_geometry_unchanged': True,
        'timeline_count': timeline, 'body_instance_count': len(before),
        'preserved_other_documents': other_before,
        'assumptions': [
            'The finished main board rests on fixed rear seat Z20.5. Thickness changes move the under-head seat and entire screw along world +Z; the nominal axis is rear +Z.',
            'Finished thicknesses 1.44, 1.60 and 1.76 mm are selected bounds and nominal, not substrate STEP thicknesses. Screw length, insert dimensions and enclosure remain nominal.',
            f'Nominal M2 x 7 screw under-head Z22.1 and receiving M2 insert open face Z18.5 with {EXPECTED_INSERT_LENGTH_MM:g} mm length are checked against actual native poses before interpreting cases.',
            'Actual main STEP is excluded because it retains a single nominal thickness. No hypothetical board solid or board-hole/bearing contact is asserted. Other physical solids and receiving inserts remain obstacles.',
        ],
        'limits': [
            'Only the three listed thickness cases are probed. Tip clearance and intersections are not a continuous tolerance sweep.',
            'Axial overlap is geometric overlap of simplified unthreaded nominal envelopes; it does not establish usable thread engagement or physical clamping.',
            'A one-diameter overlap and 0.10 mm tip-gap threshold are selected CAD gates, not mechanical design certification or manufacturing tolerance budgets.',
            'Full-shaft tip probes search 5 mm beyond the tip with 0.005 mm bisection resolution and an unprobed initial 0.001 mm. The first material is identified in each case.',
            'Board bow, solder/mask thickness distribution, screw/insert tolerances, seating, torque, pull-out, stripping, insert retention, print creep and clamp force remain physically unqualified.',
        ],
        'physical_clamping_qualified': False, 'insert_retention_qualified': False,
    }
    report('board-thickness-fasteners.json', result)
    return result


def run(_context):
    return audit()
