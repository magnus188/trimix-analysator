"""Selected A3 material sections and actual-instance fastener checks.

Explicitly read-only to CAD: transient copies, point containment and temporary
Boolean cylinders only. Call audit() inside the owned A3 design after hardware
binding. Writes one JSON report under Revision04/verification. This is neither
a global minimum-wall check nor proof of thread strength, insert installation,
seal compression, fatigue, creep or manufacturing tolerance.
"""
from datetime import datetime, timezone
from pathlib import Path
from math import ceil, dist, sqrt
import hashlib
import json

import adsk.core as core
import adsk.fusion as fusion
from audit_a3 import _owned_design, _bodies, attribute
from verification_a3 import (_records, _numeric_bounds, _numeric_overlap,
                             _record_bounds, _intersection_volume, _finish)

VOLUME_TOLERANCE_MM3 = 1e-5
COAXIAL_TOLERANCE_MM = .02
TIP_SEARCH_MM = 5.0
TIP_RESOLUTION_MM = .005
TIP_REQUIRED_NOMINAL_GAP_MM = .10
SECTION_STEP_MM = .1
SECTION_END_INSET_MM = .005


def _mm(d, expression):
    return d.unitsManager.evaluateExpression(expression, 'mm')*10


def _dot(a,b):
    return sum(x*y for x,y in zip(a,b))


def _minus(a,b):
    return [x-y for x,y in zip(a,b)]


def _plus(a,b,scale=1):
    return [x+scale*y for x,y in zip(a,b)]


def _normalized(axis):
    length = sqrt(_dot(axis,axis))
    if length < 1e-8:
        raise RuntimeError('Fastener axis has zero length')
    return [x/length for x in axis]


def _axial_limits(record, axis):
    """Project the actual transformed hardware vertices onto its installed axis.

    These nominal hardware definitions are joined cylinders with planar ends
    and a recessed hex drive. Their axial extrema occur at BRep vertices.
    This is not a general extrema solver for arbitrary curved fasteners.
    """
    origin=record['head_seat_mm']
    values=[_dot(_minus([v.geometry.x*10,v.geometry.y*10,v.geometry.z*10],origin),axis)
            for v in record['body'].vertices]
    if not values:
        raise RuntimeError('Hardware has no vertices for axial validation: '+record['occurrence'])
    return [min(values),max(values)]


def _hardware_records(d, records):
    """One record per real occurrence, with independently checked target pose."""
    seen = set(); result = []
    occurrences = {o.fullPathName:o for o in d.rootComponent.allOccurrences}
    for record in records:
        if not record['hardware'] or record['occurrence'] in seen:
            continue
        seen.add(record['occurrence'])
        occurrence = occurrences[record['occurrence']]
        expressions_raw = attribute(occurrence,'position_expressions')
        expressions = json.loads(expressions_raw) if expressions_raw else None
        expected = [_mm(d,e) for e in expressions] if expressions else None
        axis=_normalized(record['screw_axis'])
        limits=_axial_limits(record,axis)
        definition=record['hardware']
        expected_limits=[-definition['length_mm'],definition.get('head_height_mm',0)]
        result.append(dict(record,
                           axis=axis,actual_axial_limits_mm=limits,
                           axial_extent_error_mm=max(abs(x-y) for x,y in zip(limits,expected_limits)),
                           position_expressions=expressions,
                           joint_bound=attribute(occurrence,'joint_bound') == 'true',
                           expected_origin_mm=expected,
                           target_position_error_mm=dist(record['head_seat_mm'],expected) if expected else None))
    return result


def _tip_probe(manager, screw, records, extent_mm=TIP_SEARCH_MM):
    """Find first material along a full-shaft-diameter continuation of the tip.

    Cumulative cylinders plus bisection are used, not isolated sampled points.
    Start0.001mm beyond the nominal shaft tip avoids coincident-end artifacts.
    All other assembly bodies remain obstacles, including the paired insert.
    No newly constructed body is inserted into the persistent design.
    """
    definition = screw['hardware']; axis = screw['axis']
    tip = _plus(screw['head_seat_mm'],axis,screw['actual_axial_limits_mm'][0])
    radius = definition['shaft_diameter_mm']/20
    start = _plus(tip,axis,-.001)
    obstacles = [r for r in records if r['occurrence'] != screw['occurrence']]

    def hits(length):
        end = _plus(tip,axis,-length)
        cylinder = manager.createCylinderOrCone(
            core.Point3D.create(*[v/10 for v in start]),radius,
            core.Point3D.create(*[v/10 for v in end]),radius)
        if cylinder is None or not cylinder.isTransient:
            raise RuntimeError('Cannot create transient screw-tip cylinder')
        bounds = _numeric_bounds(cylinder.boundingBox); result=[]
        for obstacle in obstacles:
            if not _numeric_overlap(bounds,_record_bounds(obstacle)):
                continue
            volume = _intersection_volume(manager,cylinder,obstacle['body'],bounds_checked=True)
            if volume > VOLUME_TOLERANCE_MM3:
                result.append({'occurrence':obstacle['occurrence'],'component':obstacle['component'],
                               'body':obstacle['name'],'volume_mm3':round(volume,8)})
        return result

    outer_hits = hits(extent_mm)
    if not outer_hits:
        lower,upper,first_hits = extent_mm,None,[]
    else:
        lower,upper,first_hits = .001,extent_mm,outer_hits
        while upper-lower > TIP_RESOLUTION_MM:
            middle = (lower+upper)/2
            result = hits(middle)
            if result:
                upper,first_hits = middle,result
            else:
                lower = middle
    return {'method':'Transient full-shaft-diameter cumulative cylinders with bisection',
            'tip_mm':[round(x,6) for x in tip],
            'direction_beyond_tip':[-x for x in axis],
            'probe_diameter_mm':definition['shaft_diameter_mm'],
            'unprobed_initial_distance_mm':.001,
            'search_extent_mm':extent_mm,'resolution_mm':TIP_RESOLUTION_MM,
            'clear_distance_lower_bound_mm':round(lower,6),
            'first_material_upper_bound_mm':round(upper,6) if upper is not None else None,
            'first_material':first_hits,
            'passes_selected_nominal_gap':lower >= TIP_REQUIRED_NOMINAL_GAP_MM}


def _pairs(d, manager, records):
    hardware = _hardware_records(d,records)
    screws = [r for r in hardware if r['hardware']['kind']=='screw']
    inserts = [r for r in hardware if r['hardware']['kind']=='insert']
    result=[]
    for screw in screws:
        hs=screw['hardware']; axis=screw['axis']; options=[]
        for insert in inserts:
            hi=insert['hardware']
            if hs['size'] != hi['size']:
                continue
            delta=_minus(insert['head_seat_mm'],screw['head_seat_mm'])
            axial=_dot(delta,axis)
            radial=sqrt(max(0,_dot(delta,delta)-axial*axial))
            parallel=_dot(axis,insert['axis'])
            overlap=max(0,min(0,axial+insert['actual_axial_limits_mm'][1])
                        -max(screw['actual_axial_limits_mm'][0],axial+insert['actual_axial_limits_mm'][0]))
            if radial <= COAXIAL_TOLERANCE_MM and parallel > .999999 and overlap > 0:
                options.append((overlap,radial,axial,insert))
        options.sort(key=lambda x:x[0],reverse=True)
        chosen=options[0] if len(options)==1 else None
        nominal_diameter=float(hs['size'][1:])
        probe=_tip_probe(manager,screw,records)
        pose_ok=(screw['joint_bound'] and screw['target_position_error_mm'] is not None
                 and screw['target_position_error_mm'] < .001 and screw['axial_extent_error_mm'] < .001)
        report={'screw':screw['occurrence'],'physical_group':screw['physical_group'],
                'size':hs['size'],'under_head_length_mm':hs['length_mm'],
                'actual_under_head_origin_mm':screw['head_seat_mm'],'actual_axis':axis,
                'actual_axial_extents_from_under_head_mm':screw['actual_axial_limits_mm'],
                'axial_extent_error_against_nominal_mm':screw['axial_extent_error_mm'],
                'position_expressions':screw['position_expressions'],
                'joint_bound':screw['joint_bound'],'target_position_error_mm':screw['target_position_error_mm'],
                'coaxial_candidate_count':len(options),'tip_clearance':probe,
                'required_nominal_engagement_mm':nominal_diameter}
        if chosen:
            overlap,radial,axial,insert=chosen
            insert_pose_ok=(insert['joint_bound'] and insert['target_position_error_mm'] is not None
                            and insert['target_position_error_mm'] < .001 and insert['axial_extent_error_mm'] < .001)
            report.update({'insert':insert['occurrence'],'insert_open_face_mm':insert['head_seat_mm'],
                           'insert_axis':insert['axis'],'coaxial_offset_mm':radial,
                           'insert_actual_axial_extents_from_open_face_mm':insert['actual_axial_limits_mm'],
                           'insert_axial_extent_error_against_nominal_mm':insert['axial_extent_error_mm'],
                           'insert_joint_bound':insert['joint_bound'],
                           'insert_position_error_mm':insert['target_position_error_mm'],
                           'nominal_axial_thread_overlap_mm':overlap,
                           'head_to_insert_open_face_mm':-axial,
                           'engagement_meets_one_nominal_diameter':overlap+1e-6 >= nominal_diameter})
            passed=(overlap+1e-6 >= nominal_diameter and pose_ok and insert_pose_ok
                    and probe['passes_selected_nominal_gap'])
        else:
            report['candidate_inserts']=[x[3]['occurrence'] for x in options]
            passed=False
        report['status']='selected_geometric_checks_passed' if passed else 'needs_review'
        result.append(report)
    if not result:
        raise RuntimeError('No actual screw occurrences found')
    return result


def _section(d, records, name, component, start_expr, end_expr, source, nominal_minimum_mm=2):
    selected=[r for r in records if r['component']==component]
    if not selected:
        raise RuntimeError('Missing selected wall component: '+component)
    start=[_mm(d,e) for e in start_expr]; end=[_mm(d,e) for e in end_expr]
    length=dist(start,end)
    if length <= 2*SECTION_END_INSET_MM:
        raise ValueError('Wall section is degenerate: '+name)
    n=max(2,ceil(length/SECTION_STEP_MM)); sampled=[]; misses=[]
    axis=[(z-a)/length for a,z in zip(start,end)]
    for index in range(n+1):
        along=SECTION_END_INSET_MM+(length-2*SECTION_END_INSET_MM)*index/n
        point=_plus(start,axis,along)
        states=[r['body'].pointContainment(core.Point3D.create(*[v/10 for v in point])) for r in selected]
        if fusion.PointContainment.UnknownPointContainment in states:
            raise RuntimeError('Unknown point containment for selected wall: '+name)
        solid=any(s in (fusion.PointContainment.PointInsidePointContainment,
                        fusion.PointContainment.PointOnPointContainment) for s in states)
        sampled.append(solid)
        if not solid: misses.append([round(v,6) for v in point])
    outside=[]
    for point in (_plus(start,axis,-.05),_plus(end,axis,.05)):
        states=[r['body'].pointContainment(core.Point3D.create(*[v/10 for v in point])) for r in selected]
        if fusion.PointContainment.UnknownPointContainment in states:
            raise RuntimeError('Unknown boundary context for selected wall: '+name)
        outside.append(all(s==fusion.PointContainment.PointOutsidePointContainment for s in states))
    passed=all(sampled) and length+1e-6>=nominal_minimum_mm
    return {'name':name,'component':component,'source':source,
            'start_expressions_mm':start_expr,'end_expressions_mm':end_expr,
            'start_mm':start,'end_mm':end,'nominal_section_length_mm':length,
            'selected_nominal_minimum_mm':nominal_minimum_mm,
            'method':'Point containment along one deliberate material segment; maximum0.1mm spacing',
            'sample_count':len(sampled),'all_interior_samples_in_material':all(sampled),
            'missing_material_sample_points_mm':misses,
            'outside_at_0_05mm_beyond_endpoints':outside,
            'boundary_interpretation':'Both sampled boundaries observed' if all(outside) else 'Material can continue beyond this deliberately limited section',
            'status':'selected_section_passed' if passed else 'needs_review'}


def _sections(d, records):
    housing='01 Shape A housing'; cover='02 Single rear cover'
    frame='USB A3 — removable printed support frame'
    chamber='Chamber / A3 top manifold with serial return'
    lid='Chamber / A3 four-screw service lid'
    specs=[
        ('Right straight shell at mid height',housing,['RearInset*27 mm/(CaseDepth-Cover)','60 mm','27 mm'],['Wall','60 mm','27 mm'],'Loft outer taper toRearInset; unchanged inner cavityX=Wall'),
        ('Left straight shell at mid height',housing,['CaseWidth-Wall','60 mm','27 mm'],['CaseWidth-RearInset*27 mm/(CaseDepth-Cover)','60 mm','27 mm'],'Loft taper plus fixed inner cavity'),
        ('Straight bottom shell away from USB',housing,['20 mm','RearInset*27 mm/(CaseDepth-Cover)','27 mm'],['20 mm','Wall','27 mm'],'Loft taper plus fixed inner cavity'),
        ('Rear cover broad central field',cover,['CaseWidth/2','80 mm','CaseDepth-Cover+CoverGap'],['CaseWidth/2','80 mm','CaseDepth'],'Cover-CoverGap; no claim at recesses/edges'),
        ('Rear cover M3 bearing annulus',cover,['10.2 mm','8 mm','CaseDepth-3.8 mm'],['10.2 mm','8 mm','CaseDepth-1.65 mm'],'2.15mm local bearing thickness between underside and head recess'),
        ('Rear M3 boss radial wall',housing,['10.15 mm','8 mm','CaseDepth-6 mm'],['12.2 mm','8 mm','CaseDepth-6 mm'],'OD8.4 minus pilotOD4.3, divided by2 =2.05mm'),
        ('Lower display retainer boss wall',housing,['CaseWidth-19.7 mm','12.3 mm','16.5 mm'],['CaseWidth-17.65 mm','12.3 mm','16.5 mm'],'R3.7 less pilotR1.65 =2.05mm; centreX=CaseWidth-16mm; bracket may continue material'),
        ('Upper display retainer boss wall',housing,['DisplayX+4.3 mm','126 mm','16.5 mm'],['DisplayX+6.35 mm','126 mm','16.5 mm'],'R3.7 less pilotR1.65 =2.05mm; follows the measured display seat'),
        ('USB fixed housing support floor',housing,['UsbX','12 mm','UsbZ-9 mm'],['UsbX','12 mm','UsbZ-7 mm'],'Housing support floor2mm'),
        ('USB removable frame floor',frame,['UsbX','12 mm','UsbZ-7 mm'],['UsbX','12 mm','UsbZ-5 mm'],'Printed frame floor2mm'),
        ('USB frame opening upper wall',frame,['UsbX','5.5 mm','UsbZ+3.2 mm'],['UsbX','5.5 mm','UsbZ+5.2 mm'],'Backing opening top to printed front wall top =2mm'),
        ('USB insert boss radial wall',frame,['UsbX+10.9 mm','18.25 mm','UsbZ+3 mm'],['UsbX+12.9 mm','18.25 mm','UsbZ+3 mm'],'R3.65 less pilotR1.65 =2mm'),
        ('Chamber front floor selected point',chamber,['20 mm','CaseHeight-40 mm','3 mm'],['20 mm','CaseHeight-40 mm','5 mm'],'2mm outer floor before rear-open cavity'),
        ('Chamber inlet duct upper radial wall',chamber,['CaseWidth-5 mm','GasY','GasZ+2.5 mm'],['CaseWidth-5 mm','GasY','GasZ+4.5 mm'],'DuctOD9/ID5 =2mm radial nominal wall'),
        ('Lower inlet elbow new outside-quadrant wall',chamber,
         ['CaseWidth-14.25 mm-2.5 mm*0.7071067811865476','GasY-2.5 mm*0.7071067811865476','GasZ'],
         ['CaseWidth-14.25 mm-4.5 mm*0.7071067811865476','GasY-4.5 mm*0.7071067811865476','GasZ'],
         'ConcentricR4.5/R2.5 native sphere wall; diagonal(-X,-Y) outside both entering/outgoing cylinder halves'),
        ('Upper inlet elbow new outside-quadrant wall',chamber,
         ['CaseWidth-14.25 mm+2.5 mm*0.7071067811865476','CaseHeight-15 mm+2.5 mm*0.7071067811865476','GasZ'],
         ['CaseWidth-14.25 mm+4.5 mm*0.7071067811865476','CaseHeight-15 mm+4.5 mm*0.7071067811865476','GasZ'],
         'ConcentricR4.5/R2.5 native sphere wall; diagonal(+X,+Y) outside both entering/outgoing cylinder halves'),
        ('Chamber return bore lower wall',chamber,['7.5 mm','CaseHeight-27 mm','29 mm'],['7.5 mm','CaseHeight-27 mm','31 mm'],'Rear return block lower face29 to bore lower31 =2mm'),
        ('Chamber lid over rear return',lid,['7.5 mm','CaseHeight-27 mm','CaseDepth-7 mm'],['7.5 mm','CaseHeight-27 mm','CaseDepth-5 mm'],'Independent service lid2mm'),
        ('Chamber M2 insert boss radial wall',chamber,['19.6 mm','CaseHeight-21 mm','CaseDepth-9 mm'],['21.6 mm','CaseHeight-21 mm','CaseDepth-9 mm'],'BossR3.6 minus pilotR1.6 =2mm; adjacent baffle may add material'),
        ('AO2 adapter radial wall','Chamber / AO2 hand-tight adapter reference',['CaseWidth-48 mm','CaseHeight-37.5 mm','29.85 mm'],['CaseWidth-48 mm','CaseHeight-37.5 mm','31.85 mm'],'OD20.2/ID16.2 =2mm; simplified thread bore; assembly lowered3mm for inlet elbow clearance'),
    ]
    return [_section(d,records,*spec) for spec in specs]


def audit():
    """Read actual A3 instance geometry, inspect selected sections and all screws."""
    app,d=_owned_design()
    if not d.computeAll():
        raise RuntimeError('A3 recompute failed before wall/fastener audit')
    before=_bodies(d); timeline=d.timeline.count
    manager=fusion.TemporaryBRepManager.get(); records=_records(d,manager)
    pairs=_pairs(d,manager,records); sections=_sections(d,records)
    scripts=Path(__file__).resolve().parent
    sources={name:hashlib.sha256((scripts/name).read_bytes()).hexdigest()
             for name in ('build_a3.py','usb_a3.py','chamber_a3.py','hardware_a3.py','gas_elbows_a3.py',
                          'chamber_adjust_a3.py','chamber_retention_a3.py','service_refine_a3.py')
             if (scripts/name).exists()}
    elbow_metadata=[{'component':c.name,'correction':attribute(c,'gas_elbows_added'),
                     'straight_bore_restoration':attribute(c,'inlet_bores_restored_after_elbows')}
                    for c in d.allComponents if attribute(c,'gas_elbows_added')]
    passed=(all(r['status']=='selected_geometric_checks_passed' for r in pairs)
            and all(r['status']=='selected_section_passed' for r in sections))
    report={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':app.activeDocument.name,
            'status':'selected_checks_passed' if passed else 'needs_review',
            'minimum_printed_wall_status':'not_globally_verified',
            'selected_wall_sections':sections,'selected_wall_section_count':len(sections),
            'fastener_pairs':pairs,'screw_count':len(pairs),
            'tip_required_nominal_gap_mm':TIP_REQUIRED_NOMINAL_GAP_MM,
            'coaxial_tolerance_mm':COAXIAL_TOLERANCE_MM,'volume_tolerance_mm3':VOLUME_TOLERANCE_MM3,
            'source_sha256':sources,'applied_gas_elbow_correction_metadata':elbow_metadata,
            'parameters':[{'name':p.name,'expression':p.expression,'value_internal':p.value,'unit':p.unit} for p in d.userParameters],
            'limits':['Only listed line segments are checked for material; no global minimum-wall verification.',
                      'Thread overlap uses simplified unthreaded hardware envelopes and actual placed axes/axial vertices, not modeled threads or material strength.',
                      'Axial vertex extrema are valid for these nominal cylindrical hardware models; not a general solver for arbitrary curved hardware.',
                      '0.10mm tip-gap threshold is a selected nominal CAD gate, not a manufacturing tolerance allowance.',
                      'Transient tip cylinders search5mm ahead; first material may be another part rather than the receiving boss floor.',
                      'Point spacing0.1mm can miss features between samples. Other wall sections and fillets need separate review.',
                      'No physical insert fit, screw torque, stripping, seal preload, waterproofness, print anisotropy or creep qualification.']}
    return _finish(d,before,timeline,report,'selected-wall-fastener-checks.json')


def run(_context):
    return audit()
