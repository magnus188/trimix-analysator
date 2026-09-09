"""A3 checks: transient BRep service paths, nominal drivers and reversible regeneration.

Functions never run on import. audit_paths/audit_drivers are read-only to CAD;
regeneration_test explicitly changes parameters and restores them in finally.
Selections use actual A3 physical_group metadata, never A2 positions.
"""
from datetime import datetime, timezone
from math import ceil, dist
from pathlib import Path
import json
import adsk.core as core
import adsk.fusion as fusion
from audit_a3 import (_owned_design, _bodies, _instances, _health,
                      _instance_interference, attribute, write_report)

GROUP = "TrimixRev04"
OUTPUT = Path(__file__).resolve().parents[1] / "verification"
VOLUME_TOLERANCE_MM3 = 1e-5
LENGTH_TOLERANCE_CM = 1e-7
MAX_STEP_MM = 1.0


def _records(design, manager):
    result = []
    for occurrence, component, index, body in _instances(design):
        if not body.isSolid: continue
        raw = attribute(component, 'hardware_definition')
        hardware = json.loads(raw) if raw else None
        axis, position = None, None
        if hardware and occurrence:
            direction = core.Vector3D.create(0, 0, 1)
            if not direction.transformBy(occurrence.transform2): raise RuntimeError('Cannot resolve hardware axis')
            axis = [direction.x, direction.y, direction.z]
            p = occurrence.transform2.translation; position = [p.x*10, p.y*10, p.z*10]
        result.append({'uid': (occurrence.fullPathName if occurrence else 'ROOT', index),
                       'body': _world_copy(manager, body), 'name': body.name, 'component': component.name,
                       'occurrence': occurrence.fullPathName if occurrence else 'ROOT',
                       'physical_group': (attribute(occurrence, 'physical_group') if occurrence else None) or attribute(component, 'physical_group'),
                       'service_role': (attribute(occurrence, 'service_role') if occurrence else None) or attribute(component, 'service_role'),
                       'battery_role': attribute(component, 'battery_role'),
                       'hardware': hardware, 'screw_axis': axis, 'head_seat_mm': position})
    for r in result: _record_bounds(r)
    return result


def _groups(records):
    g = {}
    for group in ('rear_cover','battery','carrier','pcb','chamber','chamber_lid','display','display_retainers','usb','gas_fittings','button'):
        g[group] = [r for r in records if r['physical_group'] == group and not (r['hardware'] and r['hardware']['kind'] == 'screw')]
        g[group+'_screws'] = [r for r in records if r['physical_group'] == group and r['hardware'] and r['hardware']['kind'] == 'screw']
    g['mate'] = [r for r in records if r['battery_role'] == 'disconnect_mate' or r['service_role'] == 'battery_disconnect_mate' or ('disconnect' in r['component'].lower() and 'mate' in r['component'].lower())]
    g['pack'] = _without(g['battery'], g['mate'])+[r for r in records if r['battery_role'] == 'disconnect_body' and r not in g['battery']]
    g['electronics'] = g['carrier']+g['pcb']
    g['electronics_screws'] = g['carrier_screws']+g['pcb_screws']
    g['closed_chamber'] = g['chamber']+g['chamber_lid']+g['chamber_lid_screws']
    g['closed_usb'] = g['usb']+g['usb_screws']
    return g


def _require(groups, *names):
    for name in names:
        if not groups[name]: raise RuntimeError('Required A3 service group absent: '+name)


def audit_paths(stages=None):
    app, d = _owned_design(); before = _bodies(d); timeline = d.timeline.count
    manager = fusion.TemporaryBRepManager.get(); records = _records(d, manager); g = _groups(records)
    allowed = ('cover','disconnect','battery','carrier','chamber','retainers','display','usb')
    chosen = list(stages) if stages is not None else list(allowed)
    if not chosen or any(s not in allowed for s in chosen): raise ValueError('Unknown or empty A3 service stage list')
    _require(g, 'rear_cover','rear_cover_screws')
    tests = []
    for stage in chosen:
        removed = [g['rear_cover'], g['rear_cover_screws']]
        prereq = ['Switch off and disconnect external power; free flexible harnesses as specified.']
        direction = 1; custom = None
        if stage == 'cover':
            moving = g['rear_cover']; removed = [g['rear_cover_screws']]
            prereq += ['Remove all four rear-cover screws; internal assemblies stay installed.']
        elif stage == 'disconnect':
            _require(g, 'mate'); moving = g['mate']
            prereq += ['Rear cover removed. Release battery connector latch; test mate rearward.']
        elif stage == 'battery':
            _require(g, 'pack','mate'); moving = g['pack']; removed += [g['mate']]
            prereq += ['Cover removed and battery unplugged. PCB, chamber, button and fixed supports remain installed.', 'Holder/cells/attached plug move rigidly; flexible cable and grip are unvalidated.']
        elif stage == 'carrier':
            _require(g, 'electronics','electronics_screws','mate'); moving = g['electronics']
            removed += [g['mate'], g['electronics_screws']]
            prereq += ['Cover off, battery unplugged, all PCB wiring freed; remove the two carrier/PCB screws. Pack remains installed.']
        elif stage == 'chamber':
            _require(g, 'closed_chamber','gas_fittings','chamber_lid_screws','mate')
            if g['chamber_screws']: raise RuntimeError('Unexpected chamber mounting screws; A3 uses rails/rear-cover capture')
            moving = g['closed_chamber']; removed += [g['mate'],g['gas_fittings']]
            prereq += ['Cover off, battery unplugged; detach both external gas fittings and chamber harness.', 'Closed cartridge slides on housing rails and is released by rear-cover removal. Keep its independently fastened lid, all four lid screws and sensors attached; no separate housing mounting screws.']
        elif stage == 'retainers':
            _require(g, 'display_retainers','display_retainers_screws','mate')
            moving = g['display_retainers']; removed += [g['mate'],g['display_retainers_screws']]
            prereq += ['Cover off and battery unplugged. Remove two rear display-retainer screws; other assemblies remain installed.']
        elif stage == 'display':
            _require(g, 'display','display_retainers','display_retainers_screws','mate'); moving = g['display']; direction = -1
            removed += [g['mate'],g['display_retainers'],g['display_retainers_screws']]
            prereq += ['Rear cover and retainers removed; disconnect display wiring. Entire factory-cased display moves forward (-Z).', 'Factory capture lip, actual contact and clamping force remain unvalidated.']
        else:
            _require(g, 'closed_usb','usb_screws','pack','mate'); moving = g['closed_usb']
            removed += [g['mate'],g['pack']]
            custom = 2.5
            prereq += ['Cover off releases its USB retaining key; pack removed after disconnection. Unplug USB loom. Both USB board/adapter screws and inserts remain with the cartridge.', 'Translate complete USB assembly +Y2.5 mm, then rearward +Z. PCB/carrier, fixed divider and supports remain installed.']
        fixed = _without(records, moving, *removed)
        if not fixed: raise RuntimeError('No fixed obstacles selected; invalid clearance scope')
        path = _full_z_path(moving, fixed, direction)
        if custom is not None: path = [(0,0,0),(0,custom,0),(0,custom,path[-1][2])]
        tests.append(_test(manager, stage, moving, fixed, path, prereq))
    report = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': app.activeDocument.name,
              'status': 'sampled_paths_clear_with_prerequisites' if all(not t['collision_count'] for t in tests) else 'blocked_or_needs_review',
              'tests': tests, 'volume_tolerance_mm3': VOLUME_TOLERANCE_MM3,
              'limits': ['Exact transient BRep Boolean tests at <=1 mm translation intervals; not a continuous sweep.',
                         'No solids excluded unless explicitly named as moving or removed prerequisites.',
                         'No hand/handle, cable slack, latch, seal compression or actual mounting qualification.']}
    return _finish(d, before, timeline, report, 'service-paths-'+'-'.join(chosen)+'.json')


def audit_drivers():
    app, d = _owned_design(); before = _bodies(d); timeline = d.timeline.count
    manager = fusion.TemporaryBRepManager.get(); records = _records(d, manager); g = _groups(records)
    seen = set(); tests = []
    for screw in records:
        if not screw['hardware'] or screw['hardware']['kind'] != 'screw' or screw['occurrence'] in seen: continue
        seen.add(screw['occurrence']); group = screw['physical_group']
        removed = []
        prereq = 'Exterior access, cover installed.'
        if group != 'rear_cover':
            removed = [g['rear_cover'],g['rear_cover_screws'],g['mate']]
            prereq = 'Cover off and battery unplugged; other assemblies installed.'
        if group == 'usb':
            removed = [_without(records, g['closed_usb'])]
            prereq = 'USB cartridge removed after cover and battery release; service its retained board/adapter screws on bench.'
        elif group == 'chamber_lid':
            removed = [_without(records, g['closed_chamber'])]
            prereq = 'Closed cartridge already removed and supported on bench; other cartridge solids remain.'
        elif group not in ('rear_cover','pcb','carrier','chamber','display_retainers'):
            raise RuntimeError('Unclassified screw driver prerequisite: '+screw['occurrence'])
        h = screw['hardware']; axis = screw['screw_axis']; seat = screw['head_seat_mm']
        diameter = 6.0 if h['size'] == 'M3' else 5.0
        start = [v+a*(h['head_height_mm']+0.05) for v,a in zip(seat,axis)]
        end = [v+a*50 for v,a in zip(start,axis)]
        shaft = manager.createCylinderOrCone(core.Point3D.create(*[v/10 for v in start]), diameter/20,
                                             core.Point3D.create(*[v/10 for v in end]), diameter/20)
        if shaft is None or not shaft.isTransient: raise RuntimeError('No transient driver cylinder')
        fixed = _without(records, *removed, [r for r in records if r['occurrence'] == screw['occurrence']])
        bbox = _numeric_bounds(shaft.boundingBox); hits = []
        for obstacle in fixed:
            if not _numeric_overlap(bbox, _record_bounds(obstacle)): continue
            vol = _intersection_volume(manager, shaft, obstacle['body'], bounds_checked=True)
            if vol > VOLUME_TOLERANCE_MM3: hits.append({'fixed': _label(obstacle), 'volume_mm3': round(vol,7)})
        tests.append({'name': screw['occurrence'], 'status': 'blocked' if hits else 'clear_for_nominal_shaft',
                      'occurrence': screw['occurrence'], 'physical_group': group, 'start_mm': start,
                      'direction': axis, 'shaft_diameter_mm': diameter, 'shaft_length_mm': 50,
                      'prerequisites': prereq, 'collision_count': len(hits), 'collisions': hits})
    if not tests: raise RuntimeError('No hardware screw instances to inspect')
    report = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': app.activeDocument.name,
              'status': 'clear_for_nominal_shafts' if all(not t['collision_count'] for t in tests) else 'blocked_or_needs_review',
              'tests': tests, 'screw_occurrence_count': len(tests),
              'limits': ['Transient cylinders, M2 diameter5/M3 diameter6 mm, length50 mm; 0.05 mm beyond actual transformed head top.',
                         'No real bit/handle/hand/torque or actual mechanical retention qualification.']}
    return _finish(d, before, timeline, report, 'service-drivers.json')


def regeneration_test(trials=None):
    """Explicitly change each size independently +2 mm, then restore all expressions.

    Purchased selection uses explicit geometry metadata; known fixed-size display,
    battery, sensor, connector, button and nominal hardware names are conservative
    fallbacks. Report selected names so missing purchased parts cannot be hidden.
    """
    _, d = _owned_design()
    trials = trials or {name: f'({d.userParameters.itemByName(name).expression}) + 2 mm'
                        for name in ('CaseWidth','CaseHeight','CaseDepth')}
    original = {name: d.userParameters.itemByName(name).expression for name in trials}
    if not d.computeAll(): raise RuntimeError('Baseline recompute failed')
    before = _bodies(d); timeline = d.timeline.count
    selected_components = set()
    for c in d.allComponents:
        role = attribute(c,'geometry_role') or ''; basis = attribute(c,'model_basis') or ''
        purchased = attribute(c,'purchased') == 'true' or role in ('purchased','purchased_reference','manufacturer_drawing','owner_measured')
        fallback = c.name.startswith(('03 ','04 ','05 ','06 ','Battery /','Sensor /','Controls /',
            'USB A3 — GCT','USB A3 — tongue','USB A3 — illustrative contact')) or attribute(c,'hardware_definition')
        if purchased or fallback: selected_components.add(c.id)
    def signature(records):
        return {(r['occurrence'],r['name']):(r['bounds_mm']['size'],r['volume_mm3']) for r in records if r['component_id'] in selected_components}
    measured = signature(before)
    if not measured: raise RuntimeError('No purchased components selected; regeneration cannot claim fixed-part invariance')
    tests = []; error = None
    try:
        for name, expression in trials.items():
            d.userParameters.itemByName(name).expression = expression
            if not d.computeAll(): raise RuntimeError('Regeneration failed: '+name)
            health = _health(d); overlap = _instance_interference(d); now = signature(_bodies(d))
            changed = [list(k) for k,v in measured.items() if k not in now or any(abs(a-b)>1e-4 for a,b in zip(v[0],now[k][0])) or abs(v[1]-now[k][1])>1e-3]
            tests.append({'parameter': name, 'test_expression': expression, 'health_pass': health['pass'],
                          'unhealthy': health['unhealthy_entities'], 'interference_count': overlap['collision_count'],
                          'collisions': overlap['collisions'], 'purchased_dimensions_changed': changed})
            d.userParameters.itemByName(name).expression = original[name]
            if not d.computeAll(): raise RuntimeError('Restoration failed: '+name)
    except Exception as exc:
        error = f'{type(exc).__name__}: {exc}'
    finally:
        for name, expression in original.items(): d.userParameters.itemByName(name).expression = expression
        if not d.computeAll(): raise RuntimeError('Final parameter restoration failed')
    restored = _bodies(d) == before and d.timeline.count == timeline
    report = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'original_expressions': original,
              'tests': tests, 'geometry_restored': restored, 'error': error,
              'purchased_body_instances_checked': [list(k) for k in measured],
              'pass': restored and not error and len(tests)==len(trials) and all(t['health_pass'] and not t['interference_count'] and not t['purchased_dimensions_changed'] for t in tests),
              'limits': 'Specified independent size trials only; not arbitrary resizing or physical fit. Purchased-body selection is recorded explicitly.'}
    path = write_report('parameter-regeneration.json', report)
    print(json.dumps({'report': path,'pass': report['pass'],'geometry_restored': restored,'error': error}))
    if not restored: raise AssertionError('A3 geometry not restored')
    return report

def _same_bounds(one, two):
    return all(abs(getattr(getattr(one, end), axis) - getattr(getattr(two, end), axis)) < 1e-6
               for end in ("minPoint", "maxPoint") for axis in "xyz")

def _numeric_bounds(box):
    return (box.minPoint.x,box.minPoint.y,box.minPoint.z,
            box.maxPoint.x,box.maxPoint.y,box.maxPoint.z)

def _record_bounds(record):
    # Records hold immutable world-space temporary copies throughout the audit.
    # One cached API lookup replaces thousands of per-pair boundingBox calls.
    if "bounds_cm" not in record:
        record["bounds_cm"]=_numeric_bounds(record["body"].boundingBox)
    return record["bounds_cm"]

def _numeric_overlap(one,two):
    return all(min(one[index+3],two[index+3])-max(one[index],two[index])>LENGTH_TOLERANCE_CM
               for index in range(3))

def _world_copy(manager, body):
    """Copy native geometry, apply its exact instance pose, verify root bounds."""
    context = body.assemblyContext
    native = body.nativeObject if context else body
    copied = manager.copy(native)
    if copied is None or not copied.isTransient:
        raise RuntimeError("Could not copy a native BRep body to transient geometry.")
    if context and not manager.transform(copied, context.transform2):
        raise RuntimeError("Could not apply occurrence transform to transient body.")
    if not _same_bounds(copied.boundingBox, body.boundingBox):
        raise RuntimeError("Native-to-instance copy bounds differ from root-context proxy: " + body.name)
    return copied

def _label(record):
    return record["occurrence"] + " / " + record["name"]

def _select(records, predicate, label, required=True):
    selected = [record for record in records if predicate(record)]
    if required and not selected:
        raise RuntimeError("Required service group missing: " + label)
    return selected

def _without(records, *groups):
    excluded = {record["uid"] for group in groups for record in group}
    return [record for record in records if record["uid"] not in excluded]

def _bbox_overlap(one, two):
    return all(min(getattr(one.maxPoint, axis), getattr(two.maxPoint, axis))
               - max(getattr(one.minPoint, axis), getattr(two.minPoint, axis)) > LENGTH_TOLERANCE_CM
               for axis in "xyz")

def _intersection_volume(manager, moving, obstacle, bounds_checked=False):
    if not bounds_checked and not _bbox_overlap(moving.boundingBox, obstacle.boundingBox):
        return 0.0
    target, tool = manager.copy(moving), manager.copy(obstacle)
    if target is None or tool is None:
        raise RuntimeError("Transient Boolean copy failed.")
    if not manager.booleanOperation(target, tool, fusion.BooleanTypes.IntersectionBooleanType):
        raise RuntimeError("Transient Boolean intersection failed; clearance is unknown.")
    return target.volume * 1000 if target.faces.count else 0.0

def _at(manager, body, offset_mm):
    copied = manager.copy(body)
    transform = core.Matrix3D.create()
    transform.translation = core.Vector3D.create(*(value / 10 for value in offset_mm))
    if copied is None or not manager.transform(copied, transform):
        raise RuntimeError("Temporary BRep pose transform failed.")
    return copied

def _path(waypoints, max_step_mm=MAX_STEP_MM):
    poses = [tuple(waypoints[0])]
    for start, end in zip(waypoints, waypoints[1:]):
        count = max(1, ceil(dist(start, end) / max_step_mm))
        poses.extend(tuple(a + (b - a) * index / count for a, b in zip(start, end))
                     for index in range(1, count + 1))
    return poses

def _full_z_path(moving, fixed, direction=1):
    if direction > 0:
        end = max(_record_bounds(record)[5] for record in fixed) * 10
        start = min(_record_bounds(record)[2] for record in moving) * 10
        travel = ceil(max(1, end - start + 2))
    else:
        end = min(_record_bounds(record)[2] for record in fixed) * 10
        start = max(_record_bounds(record)[5] for record in moving) * 10
        travel = -ceil(max(1, start - end + 2))
    return [(0, 0, 0), (0, 0, travel)]

def _test(manager, name, moving, fixed, waypoints, prerequisites, diagnostic=False):
    collisions, samples = [], []
    fixed_bounds=[(obstacle,_record_bounds(obstacle)) for obstacle in fixed]
    moving_bounds=[(part,_record_bounds(part)) for part in moving]
    for pose in _path(waypoints):
        count = 0
        for part,original_bounds in moving_bounds:
            translated_bounds=tuple(value+pose[index%3]/10 for index,value in enumerate(original_bounds))
            candidates=[obstacle for obstacle,bounds in fixed_bounds if _numeric_overlap(translated_bounds,bounds)]
            if not candidates:
                continue
            moved = _at(manager, part["body"], pose)
            for obstacle in candidates:
                volume = _intersection_volume(manager, moved, obstacle["body"],bounds_checked=True)
                if volume > VOLUME_TOLERANCE_MM3:
                    count += 1
                    collisions.append({"translation_mm": [round(value, 6) for value in pose],
                                       "moving": _label(part), "fixed": _label(obstacle),
                                       "volume_mm3": round(volume, 7)})
        samples.append({"translation_mm": [round(value, 6) for value in pose], "collision_count": count})
    return {"name": name, "diagnostic_only": diagnostic,
            "status": "blocked_at_sampled_poses" if collisions else "clear_at_sampled_poses",
            "moving": [_label(record) for record in moving], "fixed": [_label(record) for record in fixed],
            "prerequisites": prerequisites, "translation_waypoints_mm": waypoints,
            "maximum_sample_step_mm": MAX_STEP_MM, "sample_count": len(samples), "samples": samples,
            "collision_count": len(collisions), "collisions": collisions,
            "blocked_by": sorted({item["fixed"] for item in collisions}),
            "continuous_swept_volume_checked": False,
            "method": "Exact instance BRep copies; translated at <=1 mm intervals; AABB pruning then Boolean intersection"}

def _finish(design, before, timeline_before, report, filename):
    if design.timeline.count != timeline_before or _bodies(design) != before:
        raise AssertionError("Transient-only service checks changed persistent model geometry or instance placement.")
    report["persistent_geometry_unchanged"] = True
    report["timeline_count"] = timeline_before
    report["body_instance_count"] = len(before)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT / filename
    path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"report": str(path), "status": report["status"],
                      "tests": [{"name": test["name"], "status": test["status"],
                                 "collisions": test["collision_count"]} for test in report.get("tests", [])]}))
    return report
