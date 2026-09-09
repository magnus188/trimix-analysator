"""A3 continuous gas-clearance probes and reversible size-reduction diagnostics.

No action runs on import. Root owns native Fusion execution. A clear probe is a
geometric connection, not evidence of sensor response, flow rate or gas sealing.
"""
from datetime import datetime, timezone
import json
import math
import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
import chamber_a3 as chamber
import importlib
importlib.reload(chamber)
from audit_a3 import (_owned_design, _bodies, _health, _instance_interference,
                      attribute, write_report)
from verification_a3 import (_records, _numeric_bounds, _numeric_overlap,
                             _record_bounds, _intersection_volume, _label)

PROBE_DIAMETER_MM = 5.0
VOLUME_TOLERANCE_MM3 = 1e-5
LENGTH_TOLERANCE_MM = 1e-6


def _parameters(d):
    return {name: b.mm(d, name) for name in ('CaseWidth', 'CaseHeight', 'CaseDepth', 'GasY', 'GasZ')}


def analytic_checks(d):
    """Selected source-expression checks, independently reported from native BRep.

    They are not a whole-model minimum-channel or wall-thickness certificate.
    The width face gap could accept a recentered route at 84.75 mm, while the
    current fixed-offset candidate itself needs 84.875 mm to clear the CO face.
    """
    p = _parameters(d); width, height, depth = (p[k] for k in ('CaseWidth', 'CaseHeight', 'CaseDepth'))
    checks = []
    def minimum(name, value, required, formula, scope):
        checks.append({'name': name, 'value_mm': round(value, 9), 'minimum_mm': required,
                       'margin_mm': round(value-required, 9), 'source_expression': formula,
                       'scope': scope, 'pass': value + LENGTH_TOLERANCE_MM >= required})
    minimum('Nominal inlet, turns, isolated return and fitting bore diameter', 5, 5,
            '2 × source radius 2.5 mm', 'Designed bores and nominal fitting reference; actual bore and tolerances unmeasured.')
    minimum('AO2 nose to CO sensing-face gap', width-79.75, 5,
            '(CaseWidth - 52.5 mm) - (10.55 mm + 16.7 mm)', 'Opposed nominal sensor faces; no response or convection qualification.')
    minimum('Candidate route centre to CO face', width-82.375, 2.5,
            '(CaseWidth - 55.125 mm) - 27.25 mm', 'Radius clearance at the current selected face-channel centreline.')
    minimum('Candidate route centre to AO2 nose', 2.625, 2.5,
            '(CaseWidth - 52.5 mm) - (CaseWidth - 55.125 mm)', 'Radius clearance at the current selected face-channel centreline.')
    minimum('Return-bore full diameter beneath lid', depth-38, 5,
            '(CaseDepth - 7 mm) - (33.5 mm - 2.5 mm)', 'Rear return floor Z31 to lid inner plane; CaseDepth 43 gives exactly 5 mm.')
    minimum('Upper route rear sphere beneath lid', depth-38.5, 2.5,
            '(CaseDepth - 7 mm) - 31.5 mm', 'Selected upper-row rear route at Z31.5.')
    minimum('MD62 body rear to lid', depth-34, 5,
            '(CaseDepth - 7 mm) - (8 mm + 19 mm)', 'Selected body-to-lid passage, not a substitute for exact lead/baffle checks.')
    datum_checks = [
        {'name': 'GasY follows current chamber source', 'actual_mm': p['GasY'],
         'expected_mm': height-17.5, 'pass': abs(p['GasY']-(height-17.5)) <= LENGTH_TOLERANCE_MM},
        {'name': 'GasZ follows current chamber source', 'actual_mm': p['GasZ'],
         'expected_mm': 22, 'pass': abs(p['GasZ']-22) <= LENGTH_TOLERANCE_MM}]
    guard = {'minimum_dimensions_mm': {'CaseWidth':84.75,'CaseHeight':180,'CaseDepth':43},
             'within_declared_build_range': width >= 84.75 and height >= 180 and depth >= 43,
             'scope': 'chamber_a3._check construction guard. This is a design applicability limit, not a proven global physical minimum. Height reduction needs review even if the native model remains clear.'}
    return {'parameters_mm': p, 'checks': checks, 'datum_checks': datum_checks,
            'selected_channel_checks_pass': all(x['pass'] for x in checks+datum_checks),
            'construction_applicability': guard,
            'method': 'Selected dimensions from the currently reviewed chamber source expressions; exact native probe results are reported separately.',
            'global_minimum_channel_or_wall_proven': False}


def _gas_result(d):
    manager = fusion.TemporaryBRepManager.get(); records = _records(d, manager)
    names = {r['component'] for r in records}
    missing = [name for name in (chamber.BODY, chamber.LID, chamber.AO2, chamber.CO, chamber.HE, chamber.BME) if name not in names]
    fittings = {r['occurrence'] for r in records if r['physical_group'] == 'gas_fittings'}
    if missing or len(fittings) != 2:
        raise RuntimeError('Incomplete gas assembly: missing '+repr(missing)+'; fitting instances '+str(len(fittings)))
    expressions = chamber.probe_route_expressions()
    route = [[b.mm(d, value) for value in point] for point in expressions]
    if len(route) < 2 or any(not math.isfinite(v) for p in route for v in p):
        raise RuntimeError('Gas route is absent or invalid')
    point = lambda values: core.Point3D.create(*[v/10 for v in values])
    radius_cm = PROBE_DIAMETER_MM/20
    probes = []
    for index, p in enumerate(route):
        probes.append(('vertex '+str(index), manager.createSphere(point(p), radius_cm)))
    for index, (p,q) in enumerate(zip(route,route[1:])):
        if math.dist(p,q) <= LENGTH_TOLERANCE_MM: raise RuntimeError('Zero-length gas segment '+str(index))
        probes.append(('segment '+str(index), manager.createCylinderOrCone(point(p),radius_cm,point(q),radius_cm)))
    hits, small = [], []; boolean_count = 0
    fixed_bounds = [(r,_record_bounds(r)) for r in records]
    for label, probe in probes:
        if probe is None or not probe.isTransient: raise RuntimeError('Could not create transient gas '+label)
        bounds = _numeric_bounds(probe.boundingBox)
        for obstacle, obstacle_bounds in fixed_bounds:
            if not _numeric_overlap(bounds,obstacle_bounds): continue
            boolean_count += 1
            volume = _intersection_volume(manager, probe, obstacle['body'], bounds_checked=True)
            if volume <= 0: continue
            item = {'probe':label,'obstacle':_label(obstacle),'volume_mm3':round(volume,9)}
            (hits if volume > VOLUME_TOLERANCE_MM3 else small).append(item)
    analytic = analytic_checks(d)
    clear = not hits and analytic['selected_channel_checks_pass']
    return {'status':'clear_5_mm_candidate_with_selected_dimensions' if clear else 'blocked_or_dimension_check_failed',
            'pass':clear, 'probe_diameter_mm':PROBE_DIAMETER_MM,
            'route_expressions':expressions, 'route_mm':route,
            'continuous_cylinders_and_vertex_spheres':True,
            'probe_count':len(probes),'tested_placed_solid_count':len(records),
            'solid_obstacles':[_label(r) for r in records], 'obstacles_excluded':[],
            'boolean_intersection_count':boolean_count,'collision_count':len(hits),
            'collisions':hits,'sub_tolerance_intersections':small,
            'volume_tolerance_mm3':VOLUME_TOLERANCE_MM3,'analytic':analytic,
            'method':'Continuous transient cylinders along every segment and spheres at every vertex; cached AABB pruning followed by exact Boolean intersection against all placed solid BReps, including both fitting walls. Coincident bore faces are allowed only because they have no positive volume above tolerance.',
            'limits':['The route visits nominal humidity/He and AO2/CO regions, but does not prove exposure of each actual sensing surface, complete sample renewal, or absence of bypass.',
                      'No numerical sample-flow rating, pressure drop, sensing response, thermal interaction, leak tightness, materials or seal compression is qualified.',
                      'A 5 mm geometric probe is not a physical tube, hose or achievable bend-radius claim.',
                      'Actual sensors, connectors and nominal fittings still require the stated physical measurements.']}


def audit():
    app,d = _owned_design(); before = _bodies(d); timeline = d.timeline.count
    poses = {o.fullPathName:o.transform2.asArray() for o in d.rootComponent.allOccurrences}
    result = _gas_result(d)
    unchanged = before == _bodies(d) and timeline == d.timeline.count and poses == {o.fullPathName:o.transform2.asArray() for o in d.rootComponent.allOccurrences}
    if not unchanged: raise AssertionError('Transient gas audit changed the native model')
    report = {'generated_at_utc':datetime.now(timezone.utc).isoformat(), 'document':app.activeDocument.name,
              'persistent_geometry_unchanged':True, **result}
    path = write_report('gas-clearance-paths.json',report)
    print(json.dumps({'report':path,'pass':report['pass'],'collisions':report['collision_count'],
                      'analytic_pass':report['analytic']['selected_channel_checks_pass'],
                      'blockers':report['collisions']}))
    return report


def _purchased_components(d):
    ids = set()
    for c in d.allComponents:
        role = attribute(c,'geometry_role') or ''
        if attribute(c,'purchased') == 'true' or role in ('purchased','purchased_reference','manufacturer_drawing','owner_measured') or attribute(c,'hardware_definition') or c.name.startswith(
            ('03 ','04 ','05 ','06 ','Battery /','Sensor /','Controls /','USB A3 — GCT','USB A3 — tongue','USB A3 — illustrative contact')):
            ids.add(c.id)
    return ids


def size_reduction_trials():
    """Independent 84 W, 42 D and 179 H trials; restore size and poses in finally.

    Results are diagnostic. A geometry pass never approves reduced dimensions,
    especially when outside the current chamber source's construction guard.
    """
    app,d = _owned_design()
    trials = [('CaseWidth','84 mm'),('CaseDepth','42 mm'),('CaseHeight','179 mm')]
    original = {name:d.userParameters.itemByName(name).expression for name,_ in trials}
    if not d.computeAll(): raise RuntimeError('Baseline recompute failed')
    before = _bodies(d); timeline = d.timeline.count
    poses = {o.fullPathName:o.transform2.copy() for o in d.rootComponent.allOccurrences}
    ids = _purchased_components(d)
    def signature(records):
        return {(r['occurrence'],r['name']):(r['bounds_mm']['size'],r['volume_mm3']) for r in records if r['component_id'] in ids}
    baseline = signature(before)
    if not baseline: raise RuntimeError('No fixed-size purchased references selected')
    results = []; restoration_error = None; trial_error = None
    try:
        for name,expression in trials:
            result = {'parameter':name,'expression':expression,'diagnostic_only':True}
            try:
                d.userParameters.itemByName(name).expression = expression
                if not d.computeAll(): raise RuntimeError('Trial recompute failed')
                health = _health(d); interference = _instance_interference(d); now = signature(_bodies(d))
                changed = [list(k) for k,v in baseline.items() if k not in now or any(abs(a-b)>1e-4 for a,b in zip(v[0],now[k][0])) or abs(v[1]-now[k][1])>1e-3]
                gas = _gas_result(d)
                geom = health['pass'] and not interference['collision_count'] and not interference['non_solid_bodies_not_tested'] and not changed
                reasons = []
                if not health['pass']: reasons.append('Native health or full sketch constraint checks failed.')
                if interference['collision_count']: reasons.append('Positive-volume static interference in the installed assembly.')
                if changed: reasons.append('A purchased reference or nominal fastener changed size.')
                if gas['collision_count']: reasons.append('Current continuous 5 mm gas probe intersects a placed solid.')
                if not gas['analytic']['selected_channel_checks_pass']: reasons.append('A selected minimum gas-channel dimension or route datum fails.')
                if not gas['analytic']['construction_applicability']['within_declared_build_range']: reasons.append('Outside the chamber source construction guard; a native clearance pass alone does not authorize this size.')
                reasons.append('Physical fit, retention, seal compression, gas response, wiring and routed PCB allocation remain qualification gates for every size.')
                result.update({'parameters_mm':_parameters(d),'health':health,'interference':interference,
                               'purchased_dimensions_changed':changed,'gas':gas,
                               'native_geometry_checks_pass':geom,
                               'geometry_and_gas_checks_pass':geom and gas['pass'],
                               'accepted_as_final_size':False,'decision_reasons':reasons})
            except Exception as exc:
                result.update({'error':f'{type(exc).__name__}: {exc}','geometry_and_gas_checks_pass':False,
                               'accepted_as_final_size':False,'decision_reasons':['Trial execution incomplete; no clearance conclusion.']})
            finally:
                for key,value in original.items(): d.userParameters.itemByName(key).expression=value
                if not d.computeAll(): raise RuntimeError('Between-trial restoration failed')
            results.append(result)
    except Exception as exc:
        trial_error = f'{type(exc).__name__}: {exc}'
    finally:
        try:
            for key,value in original.items(): d.userParameters.itemByName(key).expression=value
            if not d.computeAll(): raise RuntimeError('Final expression restoration failed')
            for o in d.rootComponent.allOccurrences:
                if o.fullPathName not in poses: raise RuntimeError('Occurrence inventory changed during size trial')
                saved = poses[o.fullPathName]
                if o.transform2.asArray() != saved.asArray(): o.transform2 = saved
            if not d.computeAll(): raise RuntimeError('Final pose restoration failed')
        except Exception as exc: restoration_error = f'{type(exc).__name__}: {exc}'
    restored = not restoration_error and before == _bodies(d) and timeline == d.timeline.count and all(o.transform2.asArray()==poses[o.fullPathName].asArray() for o in d.rootComponent.allOccurrences)
    report = {'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':app.activeDocument.name,
              'status':'diagnostic_trials_complete' if len(results)==len(trials) and restored and not trial_error else 'incomplete_or_restore_failed',
              'original_expressions':original,'tests':results,'geometry_and_poses_restored':restored,
              'restoration_error':restoration_error,'trial_error':trial_error,
              'purchased_body_instances_checked':[list(k) for k in baseline],
              'dimensions_changed_as_final':False,
              'limits':['These are independent single-dimension trials, not a combined reduction or optimization.',
                        'Only root may select final dimensions after reviewing actual checks and physical-fit limitations.',
                        'Selected gas dimensions and continuous BRep probes do not certify global wall thickness or sample performance.']}
    path = write_report('size-reduction-trials.json',report)
    print(json.dumps({'report':path,'geometry_and_poses_restored':restored,
                      'trials':[{'parameter':r['parameter'],'checks_pass':r['geometry_and_gas_checks_pass'],'reasons':r['decision_reasons']} for r in results]}))
    if not restored: raise AssertionError('A3 original geometry or occurrence poses were not restored')
    return report


def run(_context):
    return audit()
