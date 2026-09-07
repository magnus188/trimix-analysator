"""Reusable nominal fasteners for the Revision 03 Fusion assembly.

Call inside Fusion; this module does nothing on import. Each part variant has
one component definition and independently positioned occurrences. Screws have
a single joined body with a recessed hex drive. Threads and knurls are cosmetic
simplifications, not manufacturing geometry or a claim of a supplier CAD model.

Positions are absolute (X, Y, Z) millimetres. Positive Z points rearward. Screw
position Z is its under-head seating plane; the shaft extends toward -Z. Insert
position Z is its rear/open face and its body also extends toward -Z.
"""

import json
from math import cos, sin, pi, sqrt

import adsk.core as core
import adsk.fusion as fusion
from fusion_helpers import circle_xy, offset_plane, extrude


GROUP = "TrimixRev03"
SCREWS = {
    "M3": {"head_style": "button", "head_diameter_mm": 5.7,
           "head_height_mm": 1.65, "shaft_diameter_mm": 2.9,
           "hex_af_mm": 2.0, "hex_depth_mm": 1.0, "crown_radius_mm": 0.95},
    "M2": {"head_style": "socket_cap", "head_diameter_mm": 3.8,
           "head_height_mm": 2.0, "shaft_diameter_mm": 1.9,
           "hex_af_mm": 1.5, "hex_depth_mm": 1.0, "crown_radius_mm": 0.15},
}
INSERTS = {
    "M3": {"outer_diameter_mm": 4.2, "length_mm": 5.0, "bore_diameter_mm": 3.1},
    "M2": {"outer_diameter_mm": 3.2, "length_mm": 4.0, "bore_diameter_mm": 2.1},
}


def _mm(value):
    return f"{float(value):.9g} mm"


def _position(position):
    if len(position) != 3:
        raise ValueError("A fastener position must contain X, Y and Z in mm.")
    transform = core.Matrix3D.create()
    transform.translation = core.Vector3D.create(*(float(value) / 10 for value in position))
    return transform


def _part(root, number, label, definition, first_position):
    for component in root.parentDesign.allComponents:
        attribute = component.attributes.itemByName(GROUP, "hardware_definition")
        if component.partNumber == number and attribute:
            if json.loads(attribute.value) != definition:
                raise ValueError("Part number already exists with different dimensions: " + number)
            return component, None
    occurrence = root.occurrences.addNewComponent(_position(first_position))
    component = occurrence.component
    component.name = label + " — " + number
    component.partNumber = number
    component.description = ("Nominal generic hardware; supplier selection and dimensions must be "
                             "confirmed. Simplified unthreaded geometry for assembly and animation.")
    component.attributes.add(GROUP, "hardware_definition", json.dumps(definition, sort_keys=True))
    component.attributes.add(GROUP, "hardware_kind", definition["kind"])
    component.attributes.add(GROUP, "provenance", "nominal generic hardware; not supplier-authenticated CAD")
    component.isOriginFolderLightBulbOn = False
    return component, occurrence


def _instances(root, component, first, positions):
    result = []
    for index, position in enumerate(positions):
        occurrence = first if index == 0 and first else root.occurrences.addExistingComponent(
            component, _position(position))
        occurrence.attributes.add(GROUP, "hardware_position_mm", json.dumps(list(position)))
        occurrence.attributes.add(GROUP, "animation_axis", "+Z removal; installed position recorded in mm")
        result.append(occurrence)
    quantity = sum(1 for occurrence in root.allOccurrences if occurrence.component.id == component.id)
    component.attributes.add(GROUP, "quantity", str(quantity))
    return result


def _cylinder(component, name, radius_mm, z_mm, length_mm, operation="new", target=None):
    sketch = circle_xy(component, name + " sketch", "0 mm", "0 mm",
                       _mm(radius_mm), _mm(z_mm))
    feature = extrude(component, sketch, _mm(length_mm), name, operation,
                      [target] if target is not None else None)
    body = feature.bodies.item(0)
    if operation == "new":
        body.name = name
    return body


def _crown(component, body, head_radius_mm, head_height_mm, radius_mm):
    edges = core.ObjectCollection.create()
    for edge in body.edges:
        circle = core.Circle3D.cast(edge.geometry)
        if (circle and abs(circle.radius * 10 - head_radius_mm) < 1e-6
                and abs(circle.center.z * 10 - head_height_mm) < 1e-6):
            edges.add(edge)
    if edges.count != 1:
        raise RuntimeError("Could not identify the single fastener crown edge.")
    request = component.features.filletFeatures.createInput()
    request.edgeSetInputs.addConstantRadiusEdgeSet(edges, core.ValueInput.createByString(_mm(radius_mm)), False)
    component.features.filletFeatures.add(request).name = "Rounded head crown"


def _hex_recess(component, body, across_flats_mm, head_height_mm, depth_mm):
    plane = offset_plane(component, _mm(head_height_mm - depth_mm), "Hex drive bottom")
    sketch = component.sketches.add(plane)
    sketch.name = f"Hex drive {across_flats_mm:g} mm across flats"
    radius_cm = across_flats_mm / sqrt(3) / 10
    first = sketch.sketchPoints.add(core.Point3D.create(radius_cm, 0, 0))
    previous = first
    lines = []
    for index in range(1, 6):
        angle = index * pi / 3
        line = sketch.sketchCurves.sketchLines.addByTwoPoints(
            previous, core.Point3D.create(radius_cm * cos(angle), radius_cm * sin(angle), 0))
        lines.append(line)
        previous = line.endSketchPoint
    lines.append(sketch.sketchCurves.sketchLines.addByTwoPoints(previous, first))
    for line in lines:
        line.isFixed = True
    if not sketch.isFullyConstrained:
        raise RuntimeError("Nominal hex-drive sketch is not fully constrained.")
    extrude(component, sketch, _mm(depth_mm + 0.1), "Hex drive recess", "cut", [body])


def screw_instances(root, size, length_mm, positions_mm, part_number=None, label=None,
                    appearance=None):
    """Create/reuse a screw definition and return independent occurrence objects.

    length_mm is the under-head shaft length (e.g. M3x6 or M3x8). The default
    part number is deliberately generic. The nominal shaft is unthreaded and
    slightly below nominal major diameter to avoid false overlap with inserts.
    """
    if size not in SCREWS or float(length_mm) <= 0:
        raise ValueError("Use M3 or M2 with a positive shaft length.")
    positions = [tuple(float(value) for value in item) for item in positions_mm]
    if not positions:
        return []
    definition = dict(SCREWS[size], kind="screw", size=size, length_mm=float(length_mm))
    style = "BHCS" if size == "M3" else "SHCS"
    number = part_number or f"GEN-{size}-{style}-L{float(length_mm):g}-AF{definition['hex_af_mm']:g}"
    component, first = _part(root, number, label or f"{size} {definition['head_style']} screw",
                             definition, positions[0])
    if first:
        body = _cylinder(component, "Joined screw", definition["shaft_diameter_mm"] / 2,
                         -float(length_mm), float(length_mm))
        _cylinder(component, "Screw head", definition["head_diameter_mm"] / 2,
                  0, definition["head_height_mm"], "join")
        _crown(component, body, definition["head_diameter_mm"] / 2,
               definition["head_height_mm"], definition["crown_radius_mm"])
        _hex_recess(component, body, definition["hex_af_mm"],
                    definition["head_height_mm"], definition["hex_depth_mm"])
        body.name = number + " — joined head and shaft"
        if appearance:
            body.appearance = appearance
        if component.bRepBodies.count != 1:
            raise RuntimeError("A physical screw must be one joined body.")
    return _instances(root, component, first, positions)


def _relief(component, body, outer_radius_mm, z_mm):
    sketch = circle_xy(component, "Cosmetic insert relief", "0 mm", "0 mm",
                       _mm(outer_radius_mm + 0.1), _mm(z_mm))
    circle = sketch.sketchCurves.sketchCircles.addByCenterRadius(
        sketch.originPoint, (outer_radius_mm - 0.1) / 10)
    dimension = sketch.sketchDimensions.addRadialDimension(
        circle, core.Point3D.create((outer_radius_mm + 0.5) / 10, 0.1, 0), True)
    dimension.parameter.expression = _mm(outer_radius_mm - 0.1)
    if not sketch.isFullyConstrained:
        raise RuntimeError("Insert-relief sketch is not fully constrained.")
    annuli = [profile for profile in sketch.profiles if profile.profileLoops.count == 2]
    if len(annuli) != 1:
        raise RuntimeError("Could not identify the insert-relief annulus.")
    extrude(component, annuli[0], "0.25 mm", "Cosmetic annular relief", "cut", [body])
    sketch.isLightBulbOn = False


def insert_instances(root, size, positions_mm, outer_diameter_mm=None, length_mm=None,
                     part_number=None, label=None, appearance=None):
    """Create/reuse hollow insert components; positions specify their rear faces.

    Annular relief grooves suggest insert hardware but are not actual knurling.
    The required boss outer diameter is recorded as insert OD + 4 mm, preserving
    a requested nominal 2 mm radial plastic wall before any grooves or holes.
    """
    if size not in INSERTS:
        raise ValueError("Use M3 or M2 inserts.")
    positions = [tuple(float(value) for value in item) for item in positions_mm]
    if not positions:
        return []
    definition = dict(INSERTS[size], kind="insert", size=size)
    if outer_diameter_mm is not None:
        definition["outer_diameter_mm"] = float(outer_diameter_mm)
    if length_mm is not None:
        definition["length_mm"] = float(length_mm)
    diameter, length = definition["outer_diameter_mm"], definition["length_mm"]
    if diameter <= definition["bore_diameter_mm"] + 0.4 or length <= 1:
        raise ValueError("Insert dimensions leave insufficient nominal wall or length.")
    definition["required_boss_outer_diameter_mm"] = diameter + 4.0
    number = part_number or f"GEN-{size}-HEATSET-OD{diameter:g}-L{length:g}"
    component, first = _part(root, number, label or f"{size} heat-set insert",
                             definition, positions[0])
    if first:
        body = _cylinder(component, "Hollow insert", diameter / 2, -length, length)
        _cylinder(component, "Unthreaded insert bore", definition["bore_diameter_mm"] / 2,
                  -length - 0.1, length + 0.2, "cut", body)
        for z in (-length * 0.75, -length * 0.25):
            _relief(component, body, diameter / 2, z)
        body.name = number + " — hollow simplified insert"
        if appearance:
            body.appearance = appearance
        component.attributes.add(GROUP, "boss_wall_requirement_mm", "2")
        component.attributes.add(GROUP, "required_boss_outer_diameter_mm", str(diameter + 4.0))
        if component.bRepBodies.count != 1:
            raise RuntimeError("An insert must be one hollow solid body.")
    return _instances(root, component, first, positions)


def hardware_manifest(root):
    """Return actual instance quantities and placement metadata, without changes."""
    rows = []
    for component in root.parentDesign.allComponents:
        attribute = component.attributes.itemByName(GROUP, "hardware_definition")
        if not attribute:
            continue
        occurrences = [occurrence for occurrence in root.allOccurrences
                       if occurrence.component.id == component.id]
        rows.append({"component": component.name, "part_number": component.partNumber,
                     "quantity": len(occurrences), "body_count_per_part": component.bRepBodies.count,
                     "definition": json.loads(attribute.value),
                     "occurrences": [{"path": occurrence.fullPathName,
                                      "translation_mm": [value * 10 for value in
                                                         (occurrence.transform2.translation.x,
                                                          occurrence.transform2.translation.y,
                                                          occurrence.transform2.translation.z)]}
                                     for occurrence in occurrences]})
    return rows
