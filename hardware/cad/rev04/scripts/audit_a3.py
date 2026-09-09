"""A3 read-only native health, exact-instance geometry and collision audit.

No CAD entities/parameters/poses are created or edited. Recompute is explicit;
reports are written only beneath Revision04. Shared definitions remain separate
instances, and hidden bodies are included. No global minimum-wall claim.
"""
from datetime import datetime, timezone
from pathlib import Path
import json
import adsk.core as core
import adsk.fusion as fusion

GROUP = "TrimixRev04"
OUTPUT = Path(__file__).resolve().parents[1] / "verification"
VOLUME_TOLERANCE_MM3 = 1e-5

HEALTH_NAMES = {
    fusion.FeatureHealthStates.HealthyFeatureHealthState: "healthy",
    fusion.FeatureHealthStates.WarningFeatureHealthState: "warning",
    fusion.FeatureHealthStates.ErrorFeatureHealthState: "error",
    fusion.FeatureHealthStates.SuppressedFeatureHealthState: "suppressed",
    fusion.FeatureHealthStates.RolledBackFeatureHealthState: "rolled_back",
    fusion.FeatureHealthStates.UnknownFeatureHealthState: "unknown",
}

def _point_mm(point):
    return [round(value * 10, 6) for value in (point.x, point.y, point.z)]

def _bounds(box):
    minimum, maximum = _point_mm(box.minPoint), _point_mm(box.maxPoint)
    return {"min": minimum, "max": maximum,
            "size": [round(b - a, 6) for a, b in zip(minimum, maximum)]}

def _combined_bounds(records):
    if not records:
        return None
    minimum = [min(record["bounds_mm"]["min"][i] for record in records)
               for i in range(3)]
    maximum = [max(record["bounds_mm"]["max"][i] for record in records)
               for i in range(3)]
    return {"min": minimum, "max": maximum,
            "size": [round(b - a, 6) for a, b in zip(minimum, maximum)]}

def _health(design):
    features, sketches, planes = [], [], []
    for component in design.allComponents:
        for collection, output in ((component.features, features),
                                   (component.sketches, sketches),
                                   (component.constructionPlanes, planes)):
            for entity in collection:
                state = entity.healthState
                item = {"component": component.name, "name": entity.name,
                        "type": entity.objectType,
                        "health": HEALTH_NAMES.get(state, "unrecognized"),
                        "message": entity.errorOrWarningMessage}
                if output is sketches:
                    item["fully_constrained"] = entity.isFullyConstrained
                    item["profile_count"] = entity.profiles.count
                    item["curve_count"] = entity.sketchCurves.count
                output.append(item)
    unhealthy = [item for item in features + sketches + planes
                 if item["health"] != "healthy"]
    unconstrained = [item for item in sketches if not item["fully_constrained"]]
    return {"features": features, "sketches": sketches, "planes": planes,
            "unhealthy_entities": unhealthy,
            "under_constrained_sketches": unconstrained,
            "pass": not unhealthy and not unconstrained}


def attribute(entity, key):
    a = entity.attributes.itemByName(GROUP, key)
    return a.value if a else None


def _owned_design():
    app = core.Application.get()
    d = fusion.Design.cast(app.activeProduct)
    if not d or attribute(d.rootComponent, 'owned') != 'true':
        raise RuntimeError('Active design is not the owned A3 / TrimixRev04 model.')
    return app, d


def _instances(design):
    """Yield root bodies and explicit body proxies at each occurrence transform."""
    root = design.rootComponent
    for index, body in enumerate(root.bRepBodies):
        yield None, root, index, body
    for occurrence in root.allOccurrences:
        for index, native in enumerate(occurrence.component.bRepBodies):
            proxy = native.createForAssemblyContext(occurrence)
            if proxy is None or proxy.assemblyContext is None:
                raise RuntimeError('Cannot create instance proxy: '+occurrence.fullPathName)
            yield occurrence, occurrence.component, index, proxy


def _bodies(design):
    records = []
    for occurrence, component, index, body in _instances(design):
        records.append({'component': component.name, 'component_id': component.id,
                        'occurrence': occurrence.fullPathName if occurrence else None,
                        'body_index': index, 'name': body.name, 'solid': body.isSolid,
                        'bounds_mm': _bounds(body.boundingBox), 'volume_mm3': round(body.volume*1000, 6),
                        'physical_group': (attribute(occurrence, 'physical_group') if occurrence else None) or attribute(component, 'physical_group'),
                        'model_basis': attribute(component, 'model_basis'),
                        'geometry_role': attribute(component, 'geometry_role')})
    return records


def _body_description(entity):
    body = fusion.BRepBody.cast(entity)
    if body:
        context = body.assemblyContext
        return {'name': body.name, 'component': body.parentComponent.name,
                'component_id': body.parentComponent.id,
                'occurrence': context.fullPathName if context else None}
    occurrence = fusion.Occurrence.cast(entity)
    if occurrence:
        return {'name': occurrence.name, 'component': occurrence.component.name,
                'component_id': occurrence.component.id, 'occurrence': occurrence.fullPathName}
    raise TypeError('Unexpected interference entity: '+entity.objectType)


def _instance_interference(design):
    entities = core.ObjectCollection.create(); nonsolid = []
    for _, _, _, body in _instances(design):
        if body.isSolid: entities.add(body)
        else: nonsolid.append(_body_description(body))
    collisions = []; small = []
    if entities.count >= 2:
        request = design.createInterferenceInput(entities)
        if request is None: raise RuntimeError('No interference input')
        request.areCoincidentFacesIncluded = False
        results = design.analyzeInterference(request)
        if results is None: raise RuntimeError('No interference result; clearance unknown')
        for hit in results:
            body = hit.interferenceBody
            if body is None or not body.isTransient: raise RuntimeError('Expected transient intersection volume')
            volume = body.volume*1000
            one, two = _body_description(hit.entityOne), _body_description(hit.entityTwo)
            record = {'one': one, 'two': two, 'volume_mm3': round(volume, 9),
                      'bounds_mm': _bounds(body.boundingBox),
                      'same_component_definition': one['component_id'] == two['component_id']}
            (collisions if volume > VOLUME_TOLERANCE_MM3 else small).append(record)
    return {'method': 'Fusion analyzeInterference on explicit root-context body proxies',
            'input_body_count': entities.count, 'collision_count': len(collisions),
            'collisions': collisions, 'sub_tolerance_results': small,
            'non_solid_bodies_not_tested': nonsolid, 'volume_tolerance_mm3': VOLUME_TOLERANCE_MM3,
            'coincident_faces_included': False, 'creates_model_bodies': False}


def _hardware(design):
    instances = []
    for o in design.rootComponent.allOccurrences:
        raw = attribute(o.component, 'hardware_definition')
        if not raw: continue
        axis = core.Vector3D.create(0, 0, 1)
        if not axis.transformBy(o.transform2): raise RuntimeError('Cannot transform fastener axis')
        instances.append({'occurrence': o.fullPathName, 'component': o.component.name,
                          'part_number': o.component.partNumber, 'definition': json.loads(raw),
                          'physical_group': attribute(o, 'physical_group') or attribute(o.component, 'physical_group'),
                          'instance_label': attribute(o, 'instance_label'),
                          'installed_origin_mm': _point_mm(o.transform2.translation),
                          'installed_axis': [axis.x, axis.y, axis.z]})
    return instances


def write_report(name, report):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT/name; path.write_text(json.dumps(report, indent=2)+'\n')
    return str(path)


def audit(expected_screws=14):
    app, d = _owned_design()
    if not d.computeAll(): raise RuntimeError('A3 recompute failed')
    timeline = d.timeline.count; bodies = _bodies(d)
    poses = {o.fullPathName: o.transform2.asArray() for o in d.rootComponent.allOccurrences}
    health = _health(d); overlap = _instance_interference(d); hardware = _hardware(d)
    totals = {kind: sum(x['definition']['kind'] == kind for x in hardware) for kind in ('screw','insert')}
    missing_groups = [o.fullPathName for o in d.rootComponent.allOccurrences
                      if not (attribute(o, 'physical_group') or attribute(o.component, 'physical_group'))]
    params = [{'name': p.name, 'expression': p.expression, 'unit': p.unit, 'value_internal': p.value,
               'value_mm': p.value*10 if p.unit in ('mm','cm','m','in','ft') else None,
               'comment': p.comment} for p in d.userParameters]
    unchanged = timeline == d.timeline.count and bodies == _bodies(d) and poses == {
        o.fullPathName: o.transform2.asArray() for o in d.rootComponent.allOccurrences}
    if not unchanged: raise AssertionError('Read-only audit changed model geometry or poses')
    count_pass = expected_screws is None or totals['screw'] == expected_screws
    printed_names=['01 Shape A housing','02 Single rear cover',
                   'Carrier / removable electronics tray',
                   'Display / lower rear-release retainer','Display / upper rear-release retainer',
                   'Chamber / A3 top manifold with serial return','Chamber / A3 four-screw service lid',
                   'USB A3 — removable printed support frame']
    printed=[]
    for name in printed_names:
        components=[c for c in d.allComponents if c.name==name]
        printed.append({'component':name,'definition_count':len(components),
                        'body_count':components[0].bRepBodies.count if len(components)==1 else None,
                        'pass':len(components)==1 and components[0].bRepBodies.count==1 and components[0].bRepBodies.item(0).isSolid})
    printed_pass=all(x['pass'] for x in printed)
    result = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': app.activeDocument.name,
              'ownership_group': GROUP, 'root_component': d.rootComponent.name,
              'status': 'cad_checks_passed' if health['pass'] and not overlap['collision_count'] and not overlap['non_solid_bodies_not_tested'] and count_pass and printed_pass and not missing_groups else 'needs_review',
              'timeline_count': timeline, 'occurrence_count': d.rootComponent.allOccurrences.count,
              'component_definition_count': d.allComponents.count, 'body_instance_count': len(bodies),
              'assembly_body_bounds_mm': _combined_bounds(bodies), 'bodies': bodies,
              'health': health, 'interference': overlap, 'parameters': params,
              'hardware_instances': hardware, 'hardware_totals': totals,
              'expected_screw_count': expected_screws, 'screw_count_matches': count_pass,
              'selected_printed_parts_one_solid':printed,'selected_printed_parts_pass':printed_pass,
              'occurrences_without_physical_group': missing_groups, 'persistent_geometry_unchanged': unchanged,
              'minimum_printed_wall_status': 'not_globally_verified',
              'limits': ['Same-definition repeated instances are not ignored; hidden solids are tested.',
                         'Clearance envelope solids are included; any intentional overlap requires explicit engineering classification.',
                         'Zero static overlaps does not prove extraction, minimum gaps/walls, actual retention, sealing, wiring or manufacturability.',
                         'Purchased-part detail may be provisional; basis metadata is reported without upgrading its authority.']}
    path = write_report('model-audit.json', result)
    print(json.dumps({'audit': path, 'status': result['status'], 'bodies': len(bodies),
                      'interferences': overlap['collision_count'], 'hardware': totals, 'health_pass': health['pass']}))
    return result


def run(_context):
    return audit()
