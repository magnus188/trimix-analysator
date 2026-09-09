"""Drawing-derived USB4720 assembly; call build_usb() inside owned Rev03 Fusion.

No supplier STEP was obtainable. Purchased-part dimensions below are nominal
references from GCT USB4720 Rev B, not supplier-authenticated solid geometry.
Execute build_usb(), add_housing_clamp(), then fix_usb_geometry() for the
corrected geometry. The initial values intentionally remain in the first two
stages so the correction stage can replay. Daughterboard layout and physical
qualification remain pending. Importing this module never changes the design.
"""

import json
from math import sqrt, tan, radians, pi

import adsk.core as core
import adsk.fusion as fusion

from build_rev03 import new, get, comp, box, cyl, xbox, xcyl, GROUP, checkpoint
from fusion_helpers import _axis_sketch, evaluate_cm, extrude_axis
from hardware_details import screw_instances, insert_instances

SOURCE = "https://gct.co/files/drawings/usb4720.pdf"
MODEL_BASIS = ("GCT USB4720 Rev B drawing-derived reconstruction; manufacturer STEP "
               "download blocked. Simplified shell, tongue and gasket; not exact supplier CAD.")
NAMES = {
    "insert": "USB — removable panel insert and board supports",
    "panel": "USB — removable metal faceplate — local 1.80 mm seat",
    "shell": "USB — GCT USB4720 metal shell — drawing reconstruction",
    "insulator": "USB — GCT tongue and rear insulator — illustrative",
    "gasket": "USB — GCT LIM gasket — drawing reference",
    "contacts": "USB — contact detail — illustrative only",
    "pcb": "USB — 0.60 mm daughterboard — layout provisional",
}


def _length(value):
    return f"{float(value):.9g} mm"


def _component(key, basis):
    component = new(NAMES[key], basis)
    component.attributes.add(GROUP, "source", SOURCE)
    component.attributes.add(GROUP, "supplier_model_obtained", "false")
    component.attributes.add(GROUP, "subassembly", "removable USB insert")
    component.attributes.add(GROUP, "removal", "After battery, lower display retainer and housing clamp removal: candidate 11.7 mm inward (-X), then rear (+Z); validate complete path")
    return component


def _rounded_profile(component, name, x, width_y, height_z, radius,
                     center_y=16.0, center_z=27.0):
    """Exact nominal rounded rectangle on YZ; fixed drawing-reference curves.

    The X plane stays expression-backed. Y/Z dimensions are purchased-part
    reference constants. Fixed curves intentionally preserve those dimensions.
    """
    if radius <= 0 or 2 * radius >= min(width_y, height_z):
        raise ValueError("Rounded rectangle requires four non-degenerate straight sides")
    sketch, _ = _axis_sketch(component, name, "x", x)
    xx = evaluate_cm(component, x)
    left, right = center_y - width_y / 2, center_y + width_y / 2
    bottom, top = center_z - height_z / 2, center_z + height_z / 2
    r, k = radius, radius / sqrt(2)

    def pt(y, z):
        return sketch.modelToSketchSpace(core.Point3D.create(xx, y / 10, z / 10))

    lines = sketch.sketchCurves.sketchLines
    arcs = sketch.sketchCurves.sketchArcs
    # Share actual SketchPoint objects. Repeating numerical endpoints lets
    # Fusion create independent arc/line vertices and under-constrained points.
    points = [sketch.sketchPoints.add(pt(y, z)) for y, z in (
        (left + r, bottom), (right - r, bottom), (right, bottom + r),
        (right, top - r), (right - r, top), (left + r, top),
        (left, top - r), (left, bottom + r))]
    elements = [
        lines.addByTwoPoints(points[0], points[1]),
        arcs.addByThreePoints(points[1], pt(right - r + k, bottom + r - k), points[2]),
        lines.addByTwoPoints(points[2], points[3]),
        arcs.addByThreePoints(points[3], pt(right - r + k, top - r + k), points[4]),
        lines.addByTwoPoints(points[4], points[5]),
        arcs.addByThreePoints(points[5], pt(left + r - k, top - r + k), points[6]),
        lines.addByTwoPoints(points[6], points[7]),
        arcs.addByThreePoints(points[7], pt(left + r - k, bottom + r - k), points[0]),
    ]
    for curve in elements:
        curve.isFixed = True
    if not sketch.isFullyConstrained or sketch.profiles.count != 1:
        raise RuntimeError(f"Drawing-reference profile {name!r}: profiles={sketch.profiles.count}, "
                           f"fullyConstrained={sketch.isFullyConstrained}, "
                           f"points={sketch.sketchPoints.count}, curves={sketch.sketchCurves.count}")
    return sketch


def _rounded(component, name, x, length, width, height, radius, operation="new", target=None):
    sketch = _rounded_profile(component, name + " profile", x, width, height, radius)
    feature = extrude_axis(component, sketch, length, name, "x", operation,
                           [target] if target is not None else None)
    if operation == "new":
        feature.bodies.item(0).name = name
    return feature.bodies.item(0)


def _combine(component, target, tool, name):
    tools = core.ObjectCollection.create()
    tools.add(tool)
    request = component.features.combineFeatures.createInput(target, tools)
    request.operation = fusion.FeatureOperations.CutFeatureOperation
    request.isKeepToolBodies = False
    component.features.combineFeatures.add(request).name = name


def _tapered_mouth(component, target):
    # Local panel X=73.1..74.9 is the drawing's 1.80 mm reference.
    # Inner 0.17 mm lip, 0.50 mm gasket seat, then 1.13 mm 10-degree entry.
    a = _rounded_profile(component, "GCT throat at 0.67 mm from inner panel",
                         "CaseWidth-1.23 mm", 8.44, 2.66, 1.05)
    expansion = 2 * 1.13 * tan(radians(10))
    b = _rounded_profile(component, "GCT nominal 10-degree external lead-in",
                         "CaseWidth-0.1 mm", 8.44 + expansion, 2.66 + expansion,
                         1.05 + expansion / 2)
    request = component.features.loftFeatures.createInput(fusion.FeatureOperations.NewBodyFeatureOperation)
    request.loftSections.add(a.profiles.item(0))
    request.loftSections.add(b.profiles.item(0))
    feature = component.features.loftFeatures.add(request)
    feature.name = "GCT reference tapered entry cutting tool"
    _combine(component, target, feature.bodies.item(0), "Nominal 10-degree USB entry")
    a.isLightBulbOn = False
    b.isLightBulbOn = False


def build_usb():
    """Build the removable insert, referenced connector and provisional board.

    Entry is toward +X. Root must add/review the housing-side retainers and
    validate insertion loads and rear extraction. No Fusion UI or MCP calls.
    """
    _, design = get()
    if any(o.component.name in NAMES.values() for o in design.rootComponent.occurrences):
        raise RuntimeError("USB subassembly already exists; do not duplicate")
    if abs(design.unitsManager.evaluateExpression("UsbY", "mm") * 10 - 16) > 1e-6:
        raise RuntimeError("Drawing-reference USB stage expects UsbY=16 mm")
    if abs(design.unitsManager.evaluateExpression("UsbZ", "mm") * 10 - 27) > 1e-6:
        raise RuntimeError("Drawing-reference USB stage expects UsbZ=27 mm")

    panel = _component("panel", "Designed metal faceplate reference: 2.3 mm bulk, locally 1.80 mm; material/process and sealing unqualified; not a printed-wall exception")
    panel_body = xbox(panel, "Metal panel insert with 0.25 mm perimeter clearance",
                "CaseWidth-2.4 mm", "6.25 mm", "19.25 mm", "2.3 mm", "19.5 mm", "15.5 mm")
    insert = _component("insert", "Designed removable printed support with >=2 mm nominal flange and boss walls; housing retention and physical fit unqualified")
    body = xbox(insert, "Interior printed USB backing flange", "CaseWidth-4.4 mm", "4 mm", "17 mm",
                "2 mm", "24 mm", "20 mm")
    # Broad inner relief clears the shell grounding wings and exposes a 1.8 mm
    # local panel section. The flange remains around this removable cartridge.
    xbox(insert, "Printed frame connector interior relief", "CaseWidth-4.5 mm", "9.5 mm", "23.5 mm",
         "2.2 mm", "13 mm", "7 mm", "cut", body)
    xbox(panel, "Metal faceplate local 1.80 mm seat relief", "CaseWidth-2.5 mm", "9.5 mm", "23.5 mm",
         "0.6 mm", "13 mm", "7 mm", "cut", panel_body)
    _rounded(panel, "GCT 8.44 x 2.66 throat R1.05", "CaseWidth-1.91 mm", "1.92 mm",
             8.44, 2.66, 1.05, "cut", panel_body)
    _rounded(panel, "GCT 9.14 x 3.35 inner lip R1.39", "CaseWidth-1.91 mm", "0.18 mm",
             9.14, 3.35, 1.39, "cut", panel_body)
    _rounded(panel, "GCT 9.64 x 3.86 gasket seat R1.65", "CaseWidth-1.73 mm", "0.50 mm",
             9.64, 3.86, 1.65, "cut", panel_body)
    _tapered_mouth(panel, panel_body)
    panel.attributes.add(GROUP, "aperture_limits", "Nominal rounded sections and 10-degree entry from Rev B. R0.20 transitions omitted. Drawing tolerances and gasket compression are not qualified by this model.")
    insert.attributes.add(GROUP, "retention_status", "Board screws included. Housing-side clamps/fasteners remain an assembly integration gate.")
    # Joined rails and two 7.2 mm diameter support bosses preserve 2 mm radial
    # plastic wall around nominal OD3.2 heat-set inserts.
    board_mounts = (("CaseWidth-11.3 mm", 10.4, 8.0, "CaseWidth-14.9 mm", "10.5 mm"),
                    ("CaseWidth-15.5 mm", 21.6, 20.4, "CaseWidth-17.5 mm", "13.1 mm"))
    for x, y, rail_y, rail_x, rail_w in board_mounts:
        box(insert, "USB board support rail", rail_x, _length(rail_y),
            "22.7 mm", rail_w, "3.6 mm", "4 mm", "join")
        cyl(insert, "USB board M2 support boss", x, _length(y),
            "22.7 mm", "3.6 mm", "4 mm", "join")
        cyl(insert, "USB board insert pilot reference", x, _length(y),
            "22.6 mm", "1.6 mm", "4.2 mm", "cut", body)
    panel_mounts = ((8.25, 21.25), (23.75, 32.75))
    for y, z in panel_mounts:
        xcyl(insert, "Metal panel M2 printed support boss", "CaseWidth-6.4 mm", _length(y), _length(z),
             "3.6 mm", "4 mm", "join")
        xcyl(insert, "Metal panel insert pilot reference", "CaseWidth-6.5 mm", _length(y), _length(z),
             "1.6 mm", "4.2 mm", "cut", body)
        xcyl(panel, "Metal panel M2 clearance", "CaseWidth-2.5 mm", _length(y), _length(z),
             "1.1 mm", "2.5 mm", "cut", panel_body)

    pcb = _component("pcb", "Provisional 13.6 x 16 x 0.60 mm board; connector straddle relief and mounting references only; no final circuit layout")
    pb = box(pcb, "USB 0.60 mm daughterboard", "CaseWidth-18 mm", "8 mm", "26.7 mm",
             "13.6 mm", "16 mm", "0.6 mm")
    box(pcb, "Connector straddle clearance — footprint to reconcile",
        "CaseWidth-8.7 mm", "11.37 mm", "26.6 mm", "4.4 mm", "9.26 mm", "0.8 mm", "cut", pb)
    for x, y, _, _, _ in board_mounts:
        cyl(pcb, "M2 daughterboard clearance", x, _length(y),
            "26.6 mm", "1.1 mm", "0.8 mm", "cut", pb)

    shell = _component("shell", MODEL_BASIS)
    sb = _rounded(shell, "USB stainless shell body reference", "CaseWidth-7.5 mm", "5.4 mm",
                  8.34, 3.26, 1.05)
    _rounded(shell, "USB nose 8.34 x 2.56 reference", "CaseWidth-2.1 mm", "1.1 mm",
             8.34, 2.56, 1.05, "join")
    _rounded(shell, "Shell rear cavity — illustrative wall", "CaseWidth-7.6 mm", "5.5 mm",
             7.94, 2.86, 0.85, "cut", sb)
    _rounded(shell, "Mating shell opening — illustrative wall", "CaseWidth-2.2 mm", "1.3 mm",
             7.94, 2.16, 0.85, "cut", sb)
    for x in ("CaseWidth-7.2 mm", "CaseWidth-5.2 mm"):
        for y in (10.35, 20.12):
            box(shell, "Grounding wing — placement illustrative", x, _length(y), "27.3 mm",
                "1.3 mm", "1.53 mm", "0.30 mm", "join")
    shell.partNumber = "USB4720-03-A-DRAWING-REFERENCE"

    insulator = _component("insulator", MODEL_BASIS)
    _rounded(insulator, "Insulator rear block — visual reference", "CaseWidth-7.6 mm", "1.0 mm",
             7.8, 2.1, 0.50)
    box(insulator, "USB tongue — 6.69 x 0.70 nominal reference", "CaseWidth-6.6 mm", "12.655 mm", "26.65 mm",
        "5.4 mm", "6.69 mm", "0.7 mm", "join")

    gasket = _component("gasket", MODEL_BASIS + " Gasket is an uncompressed visual clearance reference, not seal simulation.")
    gb = _rounded(gasket, "LIM gasket nominal reference", "CaseWidth-1.70 mm", "0.40 mm",
                  9.50, 3.72, 1.50)
    _rounded(gasket, "Gasket shell clearance", "CaseWidth-1.71 mm", "0.42 mm",
             8.38, 2.60, 1.07, "cut", gb)

    contacts = _component("contacts", "Illustrative contact stripes; not electrical pin geometry or PCB footprint")
    for z in (26.62, 27.35):
        for index in range(8):
            box(contacts, "USB contact visual stripe", "CaseWidth-4.0 mm", _length(14.125 + index * 0.5),
                _length(z), "2.7 mm", "0.25 mm", "0.03 mm")

    width = design.unitsManager.evaluateExpression("CaseWidth", "mm") * 10
    board_xy = [(width - 11.3, 10.4), (width - 15.5, 21.6)]
    seats = [(x, y, 27.3) for x, y in board_xy]
    screws = screw_instances(design.rootComponent, "M2", 4.0, seats,
                              label="USB board M2x4 screw")
    inserts = insert_instances(design.rootComponent, "M2",
                               [(x, y, 26.7) for x, y in board_xy],
                               label="USB board M2 insert")
    panel_screws = screw_instances(design.rootComponent, "M2", 6.0,
                                   [(width - 0.1, y, z) for y, z in panel_mounts],
                                   label="USB metal faceplate M2x6 screw")
    panel_inserts = insert_instances(design.rootComponent, "M2",
                                    [(width - 2.4, y, z) for y, z in panel_mounts],
                                    label="USB panel M2 insert")
    for occurrence in panel_screws + panel_inserts:
        transform = core.Matrix3D.create()
        transform.setToRotation(pi / 2, core.Vector3D.create(0, 1, 0), core.Point3D.create(0, 0, 0))
        transform.translation = occurrence.transform2.translation
        occurrence.transform2 = transform
        occurrence.attributes.add(GROUP, "animation_axis", "+X removal for metal faceplate hardware")
    for occurrence in screws + inserts + panel_screws + panel_inserts:
        occurrence.attributes.add(GROUP, "subassembly", "removable USB insert")
    # Assembly placement is intentionally separate from geometric source truth.
    design.rootComponent.attributes.add(GROUP, "usb_reference", json.dumps({
        "source": SOURCE, "manufacturer_cad": False, "drawing_revision": "B",
        "entry_axis": "+X", "center_yz_mm": [16, 27],
        "local_panel_mm": 1.8, "board_thickness_mm": 0.6,
        "housing_retention": "integration required", "seal_validation": "pending"}))
    checkpoint("USB drawing-derived insert and daughterboard")


def run(_context):
    raise RuntimeError("Call build_usb() explicitly inside the owned Revision03 design")


def add_housing_clamp():
    """Rear-accessible M2 clamp preventing inward movement of the USB cartridge.

    Fixed post joins the housing. Remove the battery, lower display retainer,
    and this clamp first; move the USB assembly 11.7 mm inward, then rearward.
    This is a designed concept, not a claim of a physically tested latch.
    """
    _, design = get()
    clamp_name = "USB — removable rear housing clamp"
    if any(o.component.name == clamp_name for o in design.rootComponent.occurrences):
        raise RuntimeError("USB housing clamp already exists")
    if not any(o.component.name == NAMES["insert"] for o in design.rootComponent.occurrences):
        raise RuntimeError("Build the USB cartridge before its housing clamp")
    housing = comp("01 Tapered printed housing")
    housing_body = housing.bRepBodies.item(0)
    # R4.3 rather than R3.8 preserves >=2 mm around the eccentric OD3.2 insert.
    # Eccentric screw X69.3 leaves >=2 mm between its clearance hole and the
    # clamp's X72.4 edge, which itself clears the X72.6 inner housing wall.
    cyl(housing, "USB clamp fixed housing post", "CaseWidth-5 mm", "16 mm",
        "37.2 mm", "4.3 mm", "6 mm", "join")
    cyl(housing, "USB clamp insert pilot reference", "CaseWidth-5.7 mm", "16 mm",
        "39.2 mm", "1.6 mm", "4.1 mm", "cut", housing_body)
    housing.attributes.add(GROUP, "usb_fixed_post", json.dumps({
        "center_xy_mm_at_width75": [70, 16], "radius_mm": 4.3,
        "z_mm": [37.2, 43.2], "insert_axis_x_mm_at_width75": 69.3,
        "post_is_fixed": True, "supplier_insert_confirmation": "pending"}))

    clamp = new(clamp_name, "Designed printed L-clamp; 2 mm strap/stalk, 0.2 mm lateral stop clearance; physical fit and hand access pending")
    clamp.attributes.add(GROUP, "subassembly", "USB housing clamp")
    clamp.attributes.add(GROUP, "service_role", "remove before USB cartridge translation")
    clamp.attributes.add(GROUP, "removal", "+Z after releasing the rear M2x6 screw")
    cb = box(clamp, "USB rear clamp strap", "CaseWidth-9.3 mm", "8.5 mm", "43.2 mm",
             "6.7 mm", "11.8 mm", "2 mm")
    box(clamp, "USB inward stop and offset stalk", "CaseWidth-6.6 mm", "8.5 mm", "35 mm",
        "2 mm", "2 mm", "8.3 mm", "join")
    cyl(clamp, "USB clamp M2 clearance", "CaseWidth-5.7 mm", "16 mm", "43.1 mm",
        "1.1 mm", "2.2 mm", "cut", cb)
    clamp.attributes.add(GROUP, "stop_geometry", json.dumps({
        "x_mm_at_width75": [68.4, 70.4], "y_mm": [8.5, 10.5],
        "effective_stop_z_mm": [35, 37], "flange_inner_x_mm_at_width75": 70.6,
        "lateral_clearance_mm": 0.2}))

    width = design.unitsManager.evaluateExpression("CaseWidth", "mm") * 10
    screws = screw_instances(design.rootComponent, "M2", 6,
                              [(width - 5.7, 16, 45.2)], label="USB rear housing clamp M2x6 screw")
    inserts = insert_instances(design.rootComponent, "M2",
                               [(width - 5.7, 16, 43.2)], label="USB housing clamp fixed M2 insert")
    for occurrence in screws:
        occurrence.attributes.add(GROUP, "subassembly", "USB housing clamp")
        occurrence.attributes.add(GROUP, "service_role", "USB housing clamp screw")
        occurrence.attributes.add(GROUP, "animation_axis", "+Z screw removal before clamp")
    for occurrence in inserts:
        occurrence.attributes.add(GROUP, "subassembly", "USB housing fixed retention")
        occurrence.attributes.add(GROUP, "service_role", "fixed housing insert; remains during service")
    sequence = ("Disconnect loom and remove battery holder; remove lower display retainer; "
                "remove USB housing clamp screw and clamp in +Z; translate entire USB "
                "cartridge 11.7 mm inward (-X), then rearward (+Z). Physical access pending.")
    for occurrence in design.rootComponent.occurrences:
        if occurrence.component.name in NAMES.values():
            occurrence.component.attributes.add(GROUP, "removal", sequence)
    design.rootComponent.attributes.add(GROUP, "usb_service", json.dumps({
        "sequence": sequence, "inward_translation_mm": 11.7,
        "fixed_post_min_x_mm_at_width75": 65.7,
        "translated_usb_max_x_mm_at_width75": 65.2,
        "translated_usb_min_x_mm_at_width75": 44.2,
        "nominal_post_clearance_mm": 0.5,
        "nominal_carrier_clearance_mm": 0.6,
        "bounds_basis": "derived from current geometry inputs; actual BRep path audit pending"}))
    checkpoint("USB rear housing clamp — service path audit pending")


def fix_usb_geometry():
    """Apply the first assembled-audit corrections without rebuilding USB.

    Captures the four side-facing hardware poses, tags all ten USB hardware
    occurrences for native parametric joints, and preserves the housing wall
    by trimming/widening the removable flange rather than cutting the shell.
    """
    _, design = get()
    root = design.rootComponent
    if root.attributes.itemByName(GROUP, "usb_geometry_fix_v1"):
        raise RuntimeError("USB geometry fix already applied")
    insert = comp(NAMES["insert"])
    panel = comp(NAMES["panel"])
    clamp = comp("USB — removable rear housing clamp")

    # Move the upper faceplate mounting axis down enough to clear the upper
    # clamp stalk, while keeping its printed boss 0.05 mm above the PCB.
    changes = []
    prefixes = ("Metal panel M2 printed support boss sketch",
                "Metal panel insert pilot reference sketch",
                "Metal panel M2 clearance sketch")
    for component in (insert, panel):
        for sketch in component.sketches:
            if not any(sketch.name.startswith(prefix) for prefix in prefixes):
                continue
            for dimension in sketch.sketchDimensions:
                parameter = dimension.parameter
                if abs(parameter.value * 10 - 32.75) < 1e-6:
                    parameter.expression = "30.95 mm"
                    changes.append(component.name + " / " + sketch.name)
    if len(changes) != 3:
        raise RuntimeError(f"Expected three upper faceplate dimensions, changed {len(changes)}: {changes}")

    ib = insert.bRepBodies.item(0)
    # Widen inward before trimming the outside corner. At Y4 the new outer
    # boundary is X=69+sqrt(3.5^2-2^2)=71.872; the inner edge at69.8 leaves
    # 2.072 mm of local flange thickness, with clearance to the case R3.6.
    box(insert, "USB flange inward corner reinforcement", "CaseWidth-5.2 mm", "4 mm", "17 mm",
        "0.9 mm", "2.1 mm", "20 mm", "join")
    tool = box(insert, "USB outside-cavity corner trim tool", "CaseWidth-5.3 mm", "3.99 mm", "16.9 mm",
               "3.5 mm", "2.01 mm", "20.2 mm")
    cyl(insert, "Retain USB flange inside R3.50 reference", "CaseWidth-6 mm", "6 mm", "16.8 mm",
        "3.5 mm", "20.4 mm", "cut", tool)
    _combine(insert, ib, tool, "USB flange relief follows rounded housing cavity")
    insert.attributes.add(GROUP, "corner_fit", "Outer corner R3.50 inside housing R3.60; inward extension to CaseWidth-5.2 preserves 2.072 mm minimum nominal flange thickness at Y4")

    cb = clamp.bRepBodies.item(0)
    box(clamp, "USB clamp upper strap extension", "CaseWidth-9.3 mm", "19.7 mm", "43.2 mm",
        "6.7 mm", "5.3 mm", "2 mm", "join")
    box(clamp, "USB clamp upper inward-stop stalk", "CaseWidth-6.6 mm", "23 mm", "35 mm",
        "2 mm", "2 mm", "8.3 mm", "join")
    box(clamp, "Clear lower rear-cover boss from USB clamp", "CaseWidth-9.4 mm", "8.4 mm", "34.9 mm",
        "6.9 mm", "3.6 mm", "10.4 mm", "cut", cb)
    clamp.attributes.add(GROUP, "stop_geometry", json.dumps({
        "x_mm_at_width75": [68.4, 70.4], "y_mm": [23, 25],
        "effective_stop_z_mm": [35, 37], "flange_inner_x_mm_at_width75": 70.6,
        "lateral_clearance_mm": 0.2, "strap_y_mm": [12, 25]}))

    tagged, side_occurrences = [], []
    for occurrence in root.occurrences:
        group_attr = occurrence.attributes.itemByName(GROUP, "subassembly")
        if not group_attr or group_attr.value not in (
                "removable USB insert", "USB housing clamp", "USB housing fixed retention"):
            continue
        definition_attr = occurrence.component.attributes.itemByName(GROUP, "hardware_definition")
        if not definition_attr:
            continue
        definition = json.loads(definition_attr.value)
        recorded = occurrence.attributes.itemByName(GROUP, "hardware_position_mm")
        if not recorded:
            raise RuntimeError("USB hardware is missing its recorded position: " + occurrence.name)
        position = json.loads(recorded.value)
        y = position[1]
        is_insert = definition["kind"] == "insert"
        axis = "z"
        if group_attr.value != "removable USB insert":
            expressions = ["CaseWidth-5.7 mm", "16 mm", "43.2 mm" if is_insert else "45.2 mm"]
        elif abs(y - 10.4) < 1e-6:
            expressions = ["CaseWidth-11.3 mm", "10.4 mm", "26.7 mm" if is_insert else "27.3 mm"]
        elif abs(y - 21.6) < 1e-6:
            expressions = ["CaseWidth-15.5 mm", "21.6 mm", "26.7 mm" if is_insert else "27.3 mm"]
        elif abs(y - 8.25) < 1e-6 or abs(y - 23.75) < 1e-6:
            expressions = ["CaseWidth-2.4 mm" if is_insert else "CaseWidth-0.1 mm",
                           _length(y), "21.25 mm" if y < 10 else "30.95 mm"]
            axis = "x"
        else:
            raise RuntimeError("Unexpected USB hardware position: " + repr(position))
        occurrence.attributes.add(GROUP, "position_expressions", json.dumps(expressions))
        occurrence.attributes.add(GROUP, "mount_axis", axis)
        if axis == "x":
            if occurrence.attributes.itemByName(GROUP, "joint_bound"):
                raise RuntimeError("Bind native joints only after this geometry fix: " + occurrence.name)
            transform = core.Matrix3D.create()
            transform.setToRotation(pi / 2, core.Vector3D.create(0, 1, 0), core.Point3D.create(0, 0, 0))
            position = [design.unitsManager.evaluateExpression(e, "mm") * 10 for e in expressions]
            transform.translation = core.Vector3D.create(*(value / 10 for value in position))
            occurrence.transform2 = transform
            occurrence.attributes.add(GROUP, "hardware_position_mm", json.dumps(position))
            side_occurrences.append((occurrence, transform.asArray()))
        tagged.append(occurrence.name)
    if len(tagged) != 10 or len(side_occurrences) != 4:
        raise RuntimeError(f"Expected ten USB hardware and four side poses; got {len(tagged)}, {len(side_occurrences)}")
    if design.snapshots.hasPendingSnapshot:
        snapshot = design.snapshots.add()
        snapshot.name = "Capture four USB faceplate hardware poses"
    if not design.computeAll():
        raise RuntimeError("USB geometry correction did not recompute")
    for occurrence, expected in side_occurrences:
        if max(abs(a - b) for a, b in zip(occurrence.transform2.asArray(), expected)) > 1e-7:
            raise RuntimeError("USB side pose did not survive captured recomputation: " + occurrence.name)
    root.attributes.add(GROUP, "usb_geometry_fix_v1", json.dumps({
        "upper_faceplate_mount_z_mm": 30.95, "side_poses_captured": 4,
        "parametric_hardware_tags": 10, "clamp_stop_y_mm": [23, 25],
        "flange_housing_relief": "removable flange only; housing unchanged",
        "static_and_service_audit": "pending"}))
    checkpoint("USB geometry corrections and captured side fasteners")


def update_usb_metadata():
    """Refresh stale stage labels only; creates no geometry or timeline feature.

    Root may call after the correction and hardware-joint binding. Source wall
    calculations are deliberately not described as a whole-model wall audit.
    """
    _, design = get()
    root = design.rootComponent
    if not root.attributes.itemByName(GROUP, "usb_geometry_fix_v1"):
        raise RuntimeError("Apply USB geometry corrections before final metadata")
    insert = comp(NAMES["insert"])
    insert.attributes.add(GROUP, "retention_status", "Printed flange and rear M2 clamp included; nominal hardware; physical retention, plug forces and tolerances remain unqualified")
    reference = root.attributes.itemByName(GROUP, "usb_reference")
    data = json.loads(reference.value) if reference else {}
    data.update({
        "housing_retention": "flange and rear M2 clamp modelled; physical qualification pending",
        "manufacturer_cad": False,
        "drawing_revision": "B",
        "upper_faceplate_mount_z_mm": 30.95,
        "printed_wall_evidence": "components/USB_WALL_EVIDENCE.md — selected source-derived dimensions; not a whole-model minimum-thickness test",
    })
    root.attributes.add(GROUP, "usb_reference", json.dumps(data))
    result = []
    for occurrence in root.occurrences:
        group = occurrence.attributes.itemByName(GROUP, "subassembly")
        if not group or group.value not in ("removable USB insert", "USB housing clamp", "USB housing fixed retention"):
            continue
        if not occurrence.component.attributes.itemByName(GROUP, "hardware_definition"):
            continue
        axis = occurrence.attributes.itemByName(GROUP, "mount_axis")
        position = occurrence.attributes.itemByName(GROUP, "position_expressions")
        result.append({"occurrence": occurrence.name, "mount_axis": axis.value if axis else None,
                       "position_expressions": json.loads(position.value) if position else None,
                       "joint_bound": bool(occurrence.attributes.itemByName(GROUP, "joint_bound"))})
    print(json.dumps({"usb_metadata_updated": True, "hardware": result}))
