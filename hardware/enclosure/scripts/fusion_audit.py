"""Inspect the owned Revision 02 design inside Fusion without adding geometry.

audit() recomputes and reads the model, then writes model-audit.json. The optional
parameter_regeneration_test() is the only function that edits a design parameter;
it restores the original expression in a finally block. Neither function creates
interference bodies, hides geometry, changes components, or saves the CAD design.
"""

from datetime import datetime, timezone
from pathlib import Path
import json

import adsk.core as core
import adsk.fusion as fusion


OUTPUT = Path("/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator"
              "/hardware/enclosure/verification")
GROUP = "TrimixRev02"
HEALTH_NAMES = {
    fusion.FeatureHealthStates.HealthyFeatureHealthState: "healthy",
    fusion.FeatureHealthStates.WarningFeatureHealthState: "warning",
    fusion.FeatureHealthStates.ErrorFeatureHealthState: "error",
    fusion.FeatureHealthStates.SuppressedFeatureHealthState: "suppressed",
    fusion.FeatureHealthStates.RolledBackFeatureHealthState: "rolled_back",
    fusion.FeatureHealthStates.UnknownFeatureHealthState: "unknown",
}


def _design():
    app = core.Application.get()
    design = fusion.Design.cast(app.activeProduct)
    if not design or not design.rootComponent.attributes.itemByName(GROUP, "owned"):
        raise RuntimeError("Active Fusion design is not the owned Trimix enclosure.")
    return app, design


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


def _bodies(design):
    result = []
    root = design.rootComponent
    contexts = [(root, None, root.bRepBodies)]
    contexts.extend((occ.component, occ.fullPathName, occ.bRepBodies)
                    for occ in root.allOccurrences)
    for component, path, bodies in contexts:
        for body in bodies:
            result.append({"component": component.name,
                           "component_id": component.id,
                           "occurrence": path, "name": body.name,
                           "solid": body.isSolid,
                           "bounds_mm": _bounds(body.boundingBox),
                           "volume_mm3": round(body.volume * 1000, 6)})
    return result


def _entity_description(entity):
    occurrence = fusion.Occurrence.cast(entity)
    if occurrence:
        return {"type": "occurrence", "name": occurrence.name,
                "component": occurrence.component.name,
                "component_id": occurrence.component.id,
                "occurrence": occurrence.fullPathName}
    body = fusion.BRepBody.cast(entity)
    if body:
        context = body.assemblyContext
        return {"type": "body", "name": body.name,
                "component": body.parentComponent.name,
                "component_id": body.parentComponent.id,
                "occurrence": context.fullPathName if context else None}
    raise TypeError("Unexpected interference entity: " + entity.objectType)


def _interference(design):
    entities = core.ObjectCollection.create()
    for occurrence in design.rootComponent.occurrences:
        entities.add(occurrence)
    for body in design.rootComponent.bRepBodies:
        entities.add(body)
    if entities.count < 2:
        return {"input_count": entities.count, "pairs": [], "count": 0,
                "method": "not_needed_fewer_than_two_inputs",
                "coincident_faces_included": False}
    request = design.createInterferenceInput(entities)
    if request is None:
        raise RuntimeError("Fusion could not create the interference input.")
    request.areCoincidentFacesIncluded = False
    results = design.analyzeInterference(request)
    if results is None:
        raise RuntimeError("Fusion returned no interference result collection.")
    pairs = []
    for result in results:
        one = _entity_description(result.entityOne)
        two = _entity_description(result.entityTwo)
        overlap = result.interferenceBody
        if overlap is None or not overlap.isTransient:
            raise RuntimeError("Expected a transient interference-volume body.")
        pairs.append({"one": one, "two": two,
                      "same_component": one["component_id"] == two["component_id"],
                      "volume_mm3": round(overlap.volume * 1000, 6),
                      "bounds_mm": _bounds(overlap.boundingBox)})
    return {"input_count": entities.count,
            "method": "Fusion Design.analyzeInterference",
            "coincident_faces_included": False,
            "creates_model_bodies": False,
            "count": len(pairs), "pairs": pairs}


def _write(name, report):
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT / name
    path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    return str(path)


def audit():
    """Recompute and audit the owned design; return and write a JSON-ready report."""
    app, design = _design()
    if not design.computeAll():
        raise RuntimeError("Fusion computeAll failed before the model audit.")
    health = _health(design)
    bodies = _bodies(design)
    interference = _interference(design)
    parameters = []
    for parameter in design.userParameters:
        length = design.unitsManager.isValidExpression(parameter.expression, "mm")
        parameters.append({"name": parameter.name,
                           "expression": parameter.expression,
                           "unit": parameter.unit,
                           "value_mm": round(design.unitsManager.evaluateExpression(
                               parameter.expression, "mm") * 10, 6) if length else None,
                           "comment": parameter.comment})
    report = {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "document": app.activeDocument.name,
        "root_component": design.rootComponent.name,
        "status": "cad_checks_passed" if health["pass"] and not interference["count"]
                  else "pending_review",
        "manufacturing_status": "concept; physical fit and seal validation pending",
        "units": {"length": "mm", "volume": "mm^3"},
        "timeline_count": design.timeline.count,
        "component_count": design.allComponents.count,
        "body_count": len(bodies), "bodies": bodies,
        "assembly_body_bounds_mm": _combined_bounds(bodies),
        "health": health, "interference": interference, "parameters": parameters,
        "interpretation": "Interference pairs include clearance envelopes and intentional "
                          "overlaps; every reported pair requires engineering classification.",
    }
    path = _write("model-audit.json", report)
    print(json.dumps({"audit": path, "status": report["status"],
                      "body_count": len(bodies),
                      "health_pass": health["pass"],
                      "interference_count": interference["count"]}))
    return report


def _housing_width(design):
    housing = [body for body in _bodies(design)
               if body["component"] == "01 Main housing"]
    if not housing:
        raise RuntimeError("Cannot test width without the main housing body.")
    return _combined_bounds(housing)["size"][0]


def parameter_regeneration_test():
    """Explicit optional 95→97→95 mm test; always restore original expression.

    This edits CaseWidth only when directly called. It does not run from audit()
    or run(). API exceptions and failed geometric assertions propagate after the
    restoration attempt. The test writes its report only after successful checks.
    """
    _, design = _design()
    parameter = design.userParameters.itemByName("CaseWidth")
    if parameter is None:
        raise RuntimeError("CaseWidth parameter is missing.")
    original_expression = parameter.expression
    if abs(parameter.value * 10 - 95) > 1e-6:
        raise ValueError("Width test expects the approved 95 mm starting value.")
    if not design.computeAll():
        raise RuntimeError("Fusion computeAll failed before parameter test.")
    baseline = {"case_width_mm": parameter.value * 10,
                "housing_width_mm": _housing_width(design),
                "health_pass": _health(design)["pass"]}
    try:
        parameter.expression = "97 mm"
        if not design.computeAll():
            raise RuntimeError("Fusion computeAll failed at CaseWidth=97 mm.")
        changed = {"case_width_mm": parameter.value * 10,
                   "housing_width_mm": _housing_width(design),
                   "health_pass": _health(design)["pass"]}
        if not baseline["health_pass"] or not changed["health_pass"]:
            raise AssertionError("Feature or sketch health failed during width test.")
        if abs(baseline["housing_width_mm"] - 95) > 1e-4:
            raise AssertionError("Baseline housing width does not equal 95 mm.")
        if abs(changed["housing_width_mm"] - 97) > 1e-4:
            raise AssertionError("Housing did not regenerate to 97 mm width.")
    finally:
        parameter.expression = original_expression
        if not design.computeAll():
            raise RuntimeError("Fusion failed to recompute the restored CaseWidth.")
    restored = {"case_width_mm": parameter.value * 10,
                "housing_width_mm": _housing_width(design),
                "health_pass": _health(design)["pass"]}
    if not restored["health_pass"] or abs(restored["housing_width_mm"] - 95) > 1e-4:
        raise AssertionError("Restored housing did not return to healthy 95 mm width.")
    report = {"generated_at_utc": datetime.now(timezone.utc).isoformat(),
              "status": "pass", "original_expression_restored": original_expression,
              "baseline": baseline, "changed": changed, "restored": restored}
    path = _write("parameter-regeneration.json", report)
    print(json.dumps({"parameter_regeneration": path, "status": "pass"}))
    return report


def run(_context: str):
    audit()
