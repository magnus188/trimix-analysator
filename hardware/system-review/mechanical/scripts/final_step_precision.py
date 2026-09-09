"""Read-only dimensional investigation of the final-v11 STEP outliers.

Only a new, unsaved import document is created and then closed. All calculations
use placed native geometry or transient copies; source CAD is never edited.
The historical one-ppm observation remains intact in step-roundtrip.json.
"""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import math

import adsk
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, BASE, other_documents

DEST = BASE/'final-local-checkpoint'
SOURCE = DEST/'Trimix_Enclosure_A3_SystemReview_FinalLocal.step'
SOURCE_SHA = 'e06d615c2c5f4eff045a5dbfbc3e14249158470ce8b8970aca009d841657507b'
NAMES = ['Sensor / AO2 dry body with wetted threaded nose',
         'Chamber / AO2 hand-tight adapter reference',
         'Chamber / A3 top manifold with serial return',
         'M2 insert — CNC Kitchen TC-M2x3.0',
         'M3 insert — CNC Kitchen VORON M3x5x4']
DIMENSIONAL_TOLERANCE_MM = .02


def _bounds(entity):
    box = entity.boundingBox
    return [list(x*10 for x in box.minPoint.asArray()),
            list(x*10 for x in box.maxPoint.asArray())]


def _normal(values):
    out = list(values)
    length = math.sqrt(sum(v*v for v in out))
    out = [v/length for v in out]
    for value in out:
        if abs(value) > 1e-9:
            if value < 0:out = [-v for v in out]
            break
    return out


def _datums(body):
    """Read actual analytic cylinders and planar face locations, not parameters."""
    rows = []
    for face in body.faces:
        surface = face.geometry
        if surface.objectType == core.Cylinder.classType():
            axis = _normal(surface.axis.asArray())
            origin = [x*10 for x in surface.origin.asArray()]
            distance = sum(a*x for a,x in zip(axis,origin))
            perpendicular = [x-distance*a for x,a in zip(origin,axis)]
            row = {'type':'cylinder','axis':axis,'axis_perpendicular_origin_mm':perpendicular,
                   'radius_mm':surface.radius*10,'diameter_mm':surface.radius*20}
        elif surface.objectType == core.Plane.classType():
            normal = _normal(surface.normal.asArray())
            origin = [x*10 for x in surface.origin.asArray()]
            row = {'type':'plane','normal':normal,
                   'signed_origin_distance_mm':sum(a*x for a,x in zip(normal,origin))}
        else:continue
        rows.append(row)
    # One underlying surface may be split into several bounded faces by STEP.
    unique = {}
    for row in rows:
        key = json.dumps(row,sort_keys=True)
        unique[key] = row
    return list(unique.values())


def _datum_difference(a,b):
    if a['type'] != b['type']:return None
    if a['type'] == 'plane':
        if max(abs(x-y)for x,y in zip(a['normal'],b['normal'])) > 1e-6:return None
        return abs(a['signed_origin_distance_mm']-b['signed_origin_distance_mm'])
    if max(abs(x-y)for x,y in zip(a['axis'],b['axis'])) > 1e-6:return None
    return max(abs(a['radius_mm']-b['radius_mm']),
               *(abs(x-y)for x,y in zip(a['axis_perpendicular_origin_mm'],b['axis_perpendicular_origin_mm'])))


def _compare_datums(a,b):
    result = []
    for direction,source,target in [('native_to_STEP',a,b),('STEP_to_native',b,a)]:
        rows = []
        for datum in source:
            options = [(error,candidate)for candidate in target
                       if (error:=_datum_difference(datum,candidate)) is not None]
            options.sort(key=lambda item:item[0])
            rows.append({'source':datum,'minimum_corresponding_datum_error_mm':options[0][0]if options else None,
                         'matched':options[0][1]if options else None})
        result.append({'direction':direction,'rows':rows,
                       'pass':all(r['minimum_corresponding_datum_error_mm']is not None
                                  and r['minimum_corresponding_datum_error_mm']<=DIMENSIONAL_TOLERANCE_MM for r in rows)})
    return result


def _sample(body):
    points = []
    for face in body.faces:
        points.append(face.pointOnFace)
        calculator = face.meshManager.createMeshCalculator()
        calculator.surfaceTolerance = .0001  # cm -> 0.001 mm chord request
        calculator.maxSideLength = .1        # cm -> 1 mm edge request
        mesh = calculator.calculate()
        if not mesh:raise RuntimeError('Face tessellation failed')
        nodes = mesh.nodeCoordinates
        stride = max(1,math.ceil(len(nodes)/120))
        points.extend(nodes[::stride])
    return points


def _section(manager,body,axis,coordinate):
    origin = [0.,0.,0.];normal = [0.,0.,0.]
    origin[axis] = coordinate/10;normal[axis] = 1
    plane = core.Plane.create(core.Point3D.create(*origin),core.Vector3D.create(*normal))
    wire = manager.planeIntersection(body,plane)
    if not wire:raise RuntimeError('Expected section missing at '+str((axis,coordinate)))
    return {'axis':'XYZ'[axis],'coordinate_mm':coordinate,'bounds_mm':_bounds(wire),
            'wire_edges':wire.edges.count,'edge_length_sum_mm':sum(edge.length*10 for edge in wire.edges)}


def _properties(body):
    result = {}
    for name,accuracy in [('high',fusion.CalculationAccuracy.HighCalculationAccuracy),
                          ('very_high',fusion.CalculationAccuracy.VeryHighCalculationAccuracy)]:
        value = body.getPhysicalProperties(accuracy)
        if not value or value.accuracy < accuracy:raise RuntimeError('Requested physical-property accuracy not returned')
        result[name] = {'requested_accuracy_enum':int(accuracy),'returned_accuracy_enum':int(value.accuracy),
                        'volume_mm3':value.volume*1000,'area_mm2':value.area*100}
    return result


def run():
    configure()
    import audit_a3 as audit
    import step_a3 as step
    app,doc,design = owned()
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest()!=SOURCE_SHA:raise RuntimeError('Frozen STEP hash mismatch')
    before = audit._bodies(design);poses = step._poses(design);timeline = design.timeline.count
    protected = other_documents(app);modified = doc.isModified
    manager = fusion.TemporaryBRepManager.get()
    occurrences = [(o,c,i,b) for o,c,i,b in audit._instances(design) if c.name in NAMES]
    definition_coverage = {name:{'placed_occurrences':sum(c.name==name for o,c,i,b in occurrences), 'unique_component_definitions':len({c.id for o,c,i,b in occurrences if c.name==name})} for name in NAMES}
    if any(v['unique_component_definitions']!=1 for v in definition_coverage.values()):raise RuntimeError('Selected occurrence family is not a shared rigid definition')
    original = {c.name:body for _,c,_,body in audit._instances(design)if c.name in NAMES}
    if set(original)!=set(NAMES):raise RuntimeError('Expected five unique source definitions')
    native = {name:manager.copy(body)for name,body in original.items()}
    native_properties = {name:_properties(body)for name,body in original.items()}
    native_points = {name:_sample(body)for name,body in native.items()}
    temporary = None;result = None
    sections = {NAMES[0]:[(0,x)for x in (33.,34.,35.,36.,37.,38.,50.)],
                NAMES[1]:[(0,x)for x in (35.5,36.5,37.5)],
                NAMES[2]:[(1,162.5),(1,157.5),(2,22.),(2,33.5)],
                NAMES[3]:[(2,z)for z in (33.1,33.5,34.,35.,35.5,35.9)],
                NAMES[4]:[(2,z)for z in (35.1,35.5,36.,37.,38.,38.5,38.9)]}
    try:
        options = app.importManager.createSTEPImportOptions(str(SOURCE));options.isViewFit=False
        temporary = app.importManager.importToNewDocument(options)
        if not temporary or temporary.isSaved:raise RuntimeError('Expected new unsaved STEP diagnostic document')
        imported_design = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        imported_occurrences = [(o,c,i,b)for o,c,i,b in audit._instances(imported_design)if c.name in NAMES]
        imported_coverage={name:{'placed_occurrences':sum(c.name==name for o,c,i,b in imported_occurrences),'unique_component_definitions':len({c.id for o,c,i,b in imported_occurrences if c.name==name})}for name in NAMES}
        if imported_coverage!=definition_coverage:raise RuntimeError('Export changed insert definition reuse or coverage')
        actual = {c.name:body for _,c,_,body in audit._instances(imported_design)if c.name in NAMES}
        if set(actual)!=set(NAMES):raise RuntimeError('Expected matching STEP body names')
        result = {'generated_at_utc':datetime.now(timezone.utc).isoformat(),'source_step':str(SOURCE),
            'source_sha256':SOURCE_SHA,'parts':[], 'definition_coverage':definition_coverage,
            'imported_definition_coverage':imported_coverage,
            'source_bindings':{str(q):hashlib.sha256(q.read_bytes()).hexdigest()for q in (Path(__file__),DEST/'export.json',DEST/'step-roundtrip.json',DEST/'Trimix_Enclosure_A3_SystemReview_FinalLocal.f3d')},
            'matching_physical_property_method':'Explicit High and VeryHigh for native/imported, actual returned accuracy recorded. Prior full-assembly check already used VeryHigh on both sides.',
            'documented_API_accuracy':{'high_fraction':.001,'very_high_fraction':.0001,
                'source':'https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/CalculationAccuracy.htm',
                'interpretation':'Highest documented VeryHigh is +/-0.01% (100ppm); a1ppm difference test is finer than this documented computational accuracy. This is not a part manufacturing tolerance.'},
            'surface_sampling_method':'Each face point plus up to120 deterministic mesh nodes per face in both directions; requested chord0.001mm and maxedge1mm. Actual Fusion point-to-body minimum distances; not exhaustive Hausdorff distance.',
            'section_method':'Transient native planeIntersection wires at named physical interface and thread stations. Compare placed section bounds/length, not nominal user parameters.',
            'dimensional_diagnostic_limit_mm':DIMENSIONAL_TOLERANCE_MM,
            'source_geometry_edited':False}
        for name in NAMES:
            target = manager.copy(actual[name]);p_native=native_properties[name];p_step=_properties(actual[name])
            row = {'component':name,'native_physical_properties':p_native,'STEP_physical_properties':p_step,
                   'native_bounds_mm':_bounds(native[name]),'STEP_bounds_mm':_bounds(target),
                   'surface_samples':[],'sections':[],
                   'analytic_datum_comparison':_compare_datums(_datums(native[name]),_datums(target))}
            for direction,points,destination in [('native_to_STEP',native_points[name],target),
                                                  ('STEP_to_native',_sample(target),native[name])]:
                worst = 0.;where = None
                for index,point in enumerate(points):
                    measurement = app.measureManager.measureMinimumDistance(point,destination)
                    if not measurement:raise RuntimeError('Point-to-body measure failed')
                    distance = measurement.value*10
                    if distance>worst:worst=distance;where=[x*10 for x in point.asArray()]
                    if index%200==0:adsk.doEvents()
                row['surface_samples'].append({'direction':direction,'count':len(points),
                    'maximum_distance_mm':worst,'worst_point_mm':where,'pass':worst<=DIMENSIONAL_TOLERANCE_MM})
            for axis,coordinate in sections[name]:
                a=_section(manager,native[name],axis,coordinate);b=_section(manager,target,axis,coordinate)
                error=max(abs(x-y)for aa,bb in zip(a['bounds_mm'],b['bounds_mm'])for x,y in zip(aa,bb))
                row['sections'].append({'native':a,'STEP':b,'maximum_bound_error_mm':error,
                    'edge_length_difference_mm':abs(a['edge_length_sum_mm']-b['edge_length_sum_mm']),
                    'bounds_pass':error<=DIMENSIONAL_TOLERANCE_MM})
            row['dimensional_diagnostics_pass']=all(r['pass']for r in row['surface_samples']+row['analytic_datum_comparison'])and all(r['bounds_pass']for r in row['sections'])
            result['parts'].append(row)
        result['all_selected_dimensional_diagnostics_pass']=all(row['dimensional_diagnostics_pass']for row in result['parts'])
    finally:
        try:
            if temporary and not temporary.close(False):raise RuntimeError('Temporary STEP diagnostic did not close')
        finally:
            if not doc.activate():raise RuntimeError('Could not reactivate SystemReview')
        preserved={'temporary_closed_without_save':temporary is not None,
                   'native_geometry_unchanged':audit._bodies(design)==before,
                   'native_poses_unchanged':step._poses(design)==poses,
                   'native_timeline_unchanged':design.timeline.count==timeline,
                   'native_modified_flag_unchanged':doc.isModified==modified,
                   'other_documents_unchanged':other_documents(app)==protected}
        if result:
            result['cleanup']=preserved
            (DEST/'step-precision-diagnostic.json').write_text(json.dumps(result,indent=2)+'\n')
            print(json.dumps({'report':str(DEST/'step-precision-diagnostic.json'),
                              'parts_completed':len(result['parts']),'cleanup':preserved}))
        if not all(preserved.values()):raise RuntimeError('STEP diagnostic altered protected state')
    return result

