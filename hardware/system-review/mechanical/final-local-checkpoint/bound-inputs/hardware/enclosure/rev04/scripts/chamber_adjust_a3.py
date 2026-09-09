"""Edit the existing A3 inlet and AO2 sketch parameters for rear extraction.

No rebuilding, duplicate parts or CAD actions on import. Root calls apply()
before adding the revised spherical gas elbows. Existing features are retained.
"""
import json
import re
import adsk.fusion as fusion
import build_a3 as b
import chamber_a3 as ch


def _replace(expression, old, new):
    # Fusion may normalize spacing and wrap signed sketch coordinates. Replace
    # only the reviewed expression fragment, preserving every outer sign.
    pattern = r'\s*'.join(re.escape(token) for token in re.findall(r'[A-Za-z]+|\d+(?:\.\d+)?|[-+()]', old))
    result, count = re.subn(pattern, new, expression)
    if count != 1:
        raise RuntimeError('Expected one expression fragment '+old+' in '+expression)
    return result


def _sketch_change(plan, component, name, old, new):
    matches = [s for s in component.sketches if s.name == name]
    if len(matches) != 1:
        raise RuntimeError('Expected one sketch '+component.name+' / '+name)
    candidates = []
    for dimension in matches[0].sketchDimensions:
        p = dimension.parameter
        try:
            expression = _replace(p.expression, old, new)
        except RuntimeError:
            continue
        candidates.append((p, expression))
    if len(candidates) != 1:
        raise RuntimeError('Expected one reviewed dimension in '+name+', found '+str(len(candidates)))
    parameter, expression = candidates[0]
    plan.append((component.name+' / '+name, parameter, parameter.expression, expression))


def _plane_change(plan, component, name, old, new):
    planes = [p for p in component.constructionPlanes if p.name == name]
    if len(planes) != 1:
        raise RuntimeError('Expected one offset plane '+name)
    definition = fusion.ConstructionPlaneOffsetDefinition.cast(planes[0].definition)
    if not definition:
        raise RuntimeError('Expected native offset-plane definition: '+name)
    p = definition.offset
    plan.append((component.name+' / '+name, p, p.expression, _replace(p.expression, old, new)))


def _length_change(plan, component, name, expected_mm, new_expression):
    features = [f for f in component.features.extrudeFeatures if f.name == name]
    if len(features) != 1:
        raise RuntimeError('Expected one extrusion '+name)
    extent = fusion.DistanceExtentDefinition.cast(features[0].extentOne)
    if not extent:
        raise RuntimeError('Expected one-sided distance extrusion '+name)
    p = extent.distance
    if abs(p.value*10-expected_mm) > 1e-6:
        raise RuntimeError('Unexpected original distance for '+name+': '+p.expression)
    plan.append((component.name+' / '+name, p, p.expression, new_expression))


def apply():
    """Lower AO23 mm and move inlet turn5 mm inward; retain all part sizes."""
    _, d = b.get()
    body = b.comp(ch.BODY)
    if body.attributes.itemByName(b.GROUP, 'inlet_service_adjusted'):
        raise RuntimeError('A3 inlet service adjustment already applied.')
    if body.attributes.itemByName(b.GROUP, 'gas_elbows_added'):
        raise RuntimeError('Apply the inlet coordinate correction before the spherical elbow stage.')
    plan = []
    # Move all eight AO2 coordinate definitions, including its wall aperture.
    for component_name, sketch_name in [
        (ch.BODY, 'AO2 nose clearance through wet wall sketch'),
        (ch.AO2, 'AO2 Ø29.3 dry body sketch'),
        (ch.AO2, 'AO2 nominal threaded nose sketch'),
        (ch.ADAPTER, 'Hand-tight adapter shoulder sketch'),
        (ch.ADAPTER, 'Simplified female M16 clearance surface sketch'),
        ('Chamber / AO2 face-seal allowance', 'AO2 face seal allowance sketch'),
        ('Chamber / AO2 face-seal allowance', 'AO2 face seal bore sketch')]:
        _sketch_change(plan, b.comp(component_name), sketch_name,
                       'CaseHeight-34.5 mm', 'CaseHeight-37.5 mm')
    _sketch_change(plan, b.comp('Sensor / AO2 cable connector allowance'),
                   'AO2 connector and wire origin allowance sketch',
                   'CaseHeight-39.5 mm', 'CaseHeight-42.5 mm')
    # Extend the existing horizontal inlet before moving its start inward.
    _length_change(plan, body, 'Viewer-left inlet duct', 6.25, '11.25 mm')
    _plane_change(plan, body, 'Viewer-left inlet duct sketch / plane',
                  'CaseWidth-9.25 mm', 'CaseWidth-14.25 mm')
    _sketch_change(plan, body, 'Inlet rise outside dry AO2 connector sketch',
                   'CaseWidth-9.25 mm', 'CaseWidth-14.25 mm')
    _length_change(plan, body, 'Upper sensor row inlet turn', 7.75, '2.75 mm')
    _length_change(plan, body, 'Inlet bore', 6.45, '11.45 mm')
    _plane_change(plan, body, 'Inlet bore sketch / plane',
                  'CaseWidth-9.35 mm', 'CaseWidth-14.35 mm')
    _sketch_change(plan, body, 'Inlet rise bore sketch',
                   'CaseWidth-9.25 mm', 'CaseWidth-14.25 mm')
    _length_change(plan, body, 'Upper inlet turn bore', 7.95, '2.95 mm')
    if len(plan) != 16:
        raise RuntimeError('Expected exactly16 reviewed native parameter edits.')
    # Preflight above resolves every target before the first mutation.
    for label, parameter, old, new in plan:
        parameter.expression = new
    if not d.computeAll() or body.bRepBodies.count != 1:
        raise RuntimeError('Inlet adjustment did not recompute to one manifold solid.')
    record = {'method':'Existing sketch dimensions, offset-plane parameters and distance extents',
              'ao2_centre_expression':['CaseWidth-46 mm','CaseHeight-37.5 mm','21.75 mm'],
              'inlet_elbow_x_expression':'CaseWidth-14.25 mm',
              'parameter_edits':[{'target':label,'old':old,'new':new} for label,p,old,new in plan],
              'validation':'Native interference, complete-cartridge rear path and Ø5 gas probe must be re-run'}
    body.attributes.add(b.GROUP, 'inlet_service_adjusted', json.dumps(record))
    b.comp(ch.AO2).attributes.add(b.GROUP, 'wetted_face',
        'Nose plane X=CaseWidth-52.5, centre Y=CaseHeight-37.5,Z21.75')
    b.checkpoint('A3 inward inlet turn and lower dry AO2 for rear service')
