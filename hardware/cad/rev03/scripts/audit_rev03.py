"""Read-only Revision 03 health, instance geometry and interference audit.

Execute inside Fusion after the owned TrimixRev03 design is active. Model
recomputation is the only CAD operation beyond reads. Interference volumes stay
transient; no model bodies, poses, features or parameters are created or changed.
"""

from datetime import datetime, timezone
from pathlib import Path
import json

import adsk.core as core
import adsk.fusion as fusion
from fusion_audit import _health, _bodies, _combined_bounds, _bounds
from hardware_details import hardware_manifest


GROUP = "TrimixRev03"
OUTPUT = Path("/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator"
              "/hardware/cad/rev03/verification")
VOLUME_TOLERANCE_MM3 = 1e-5


def _owned_design():
    app = core.Application.get()
    design = fusion.Design.cast(app.activeProduct)
    owned = design and design.rootComponent.attributes.itemByName(GROUP, "owned")
    if not owned:
        raise RuntimeError("Active design is not the owned Revision 03 enclosure.")
    return app, design


def _body_description(entity):
    body = fusion.BRepBody.cast(entity)
    if body:
        context = body.assemblyContext
        return {"name": body.name, "component": body.parentComponent.name,
                "component_id": body.parentComponent.id,
                "occurrence": context.fullPathName if context else None}
    occurrence = fusion.Occurrence.cast(entity)
    if occurrence:
        return {"name": occurrence.name, "component": occurrence.component.name,
                "component_id": occurrence.component.id,
                "occurrence": occurrence.fullPathName}
    raise TypeError("Unexpected interference entity: " + entity.objectType)


def _instance_interference(design):
    """Analyze each solid body proxy in root assembly context, including repeats."""
    root = design.rootComponent
    entities = core.ObjectCollection.create()
    nonsolid = []
    for body in root.bRepBodies:
        if body.isSolid:
            entities.add(body)
        else:
            nonsolid.append(_body_description(body))
    for occurrence in root.allOccurrences:
        # bRepBodies provides root-context proxies; do not substitute native
        # component bodies, which would put every screw at its local origin.
        for body in occurrence.bRepBodies:
            if body.isSolid:
                entities.add(body)
            else:
                nonsolid.append(_body_description(body))
    result = {"method": "Fusion analyzeInterference on root-context body proxies",
              "input_body_count": entities.count,
              "non_solid_bodies_not_tested": nonsolid,
              "coincident_faces_included": False,
              "volume_tolerance_mm3": VOLUME_TOLERANCE_MM3,
              "creates_model_bodies": False,
              "collisions": [], "sub_tolerance_results": []}
    if entities.count >= 2:
        request = design.createInterferenceInput(entities)
        if request is None:
            raise RuntimeError("Could not create root-context interference input.")
        request.areCoincidentFacesIncluded = False
        overlaps = design.analyzeInterference(request)
        if overlaps is None:
            raise RuntimeError("Fusion returned no interference result collection.")
        for overlap in overlaps:
            volume_body = overlap.interferenceBody
            if volume_body is None or not volume_body.isTransient:
                raise RuntimeError("Expected a transient interference volume.")
            one = _body_description(overlap.entityOne)
            two = _body_description(overlap.entityTwo)
            volume = volume_body.volume * 1000
            record = {"one": one, "two": two,
                      "same_component_definition": one["component_id"] == two["component_id"],
                      "same_occurrence": one["occurrence"] == two["occurrence"],
                      "volume_mm3": round(volume, 9),
                      "bounds_mm": _bounds(volume_body.boundingBox)}
            result["collisions" if volume > VOLUME_TOLERANCE_MM3
                   else "sub_tolerance_results"].append(record)
    result["collision_count"] = len(result["collisions"])
    result["status"] = "zero_positive_volume_overlaps" if not result["collisions"] else "overlaps_found"
    return result


def audit():
    """Return the report and write rev03/verification/model-audit.json."""
    app, design = _owned_design()
    timeline_before = design.timeline.count
    if not design.computeAll():
        raise RuntimeError("Revision 03 failed to recompute before auditing.")
    health = _health(design)
    bodies = _bodies(design)
    interference = _instance_interference(design)
    hardware = hardware_manifest(design.rootComponent)
    parameters = []
    for parameter in design.userParameters:
        is_length = design.unitsManager.isValidExpression(parameter.expression, "mm")
        parameters.append({"name": parameter.name, "expression": parameter.expression,
                           "unit": parameter.unit, "comment": parameter.comment,
                           "value_mm": round(design.unitsManager.evaluateExpression(
                               parameter.expression, "mm") * 10, 6) if is_length else None})
    if design.timeline.count != timeline_before:
        raise AssertionError("Read-only audit changed the timeline length.")
    if _bodies(design) != bodies:
        raise AssertionError("Body geometry or occurrence placements changed during the audit.")
    status = "cad_checks_passed" if (health["pass"] and not interference["collision_count"]
                                    and not interference["non_solid_bodies_not_tested"]) else "needs_review"
    report = {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "document": app.activeDocument.name, "root_component": design.rootComponent.name,
        "ownership_group": GROUP, "status": status,
        "manufacturing_status": "Prototype; physical fit, procurement, sealing and gas behavior require validation",
        "units": {"length": "mm", "volume": "mm^3"},
        "timeline_count": design.timeline.count,
        "component_definition_count": design.allComponents.count,
        "occurrence_count": design.rootComponent.allOccurrences.count,
        "body_instance_count": len(bodies), "bodies": bodies,
        "assembly_body_bounds_mm": _combined_bounds(bodies),
        "health": health, "interference": interference, "parameters": parameters,
        "hardware": hardware,
        "hardware_totals": {
            kind: sum(item["quantity"] for item in hardware if item["definition"]["kind"] == kind)
            for kind in ("screw", "insert")},
        "hardware_part_definition_count": len(hardware),
        "persistent_geometry_unchanged": True,
        "interpretation": [
            "Repeated component definitions are evaluated at each occurrence transform; same-definition collisions are not ignored.",
            "Hardware is nominal generic geometry with supplier selection pending; its part numbers are internal identifiers.",
            "Insert metadata declares a 2 mm radial boss-wall requirement; this audit does not measure minimum printed wall thickness.",
            "Zero assembled interference is not proof of service extraction, minimum clearances, seal compression or manufacturability.",
        ],
    }
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT / "model-audit.json"
    path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"audit": str(path), "status": status,
                      "body_instances": len(bodies), "occurrences": report["occurrence_count"],
                      "health_pass": health["pass"],
                      "interference_count": interference["collision_count"],
                      "hardware_totals": report["hardware_totals"]}))
    return report


def run(_context: str):
    audit()
