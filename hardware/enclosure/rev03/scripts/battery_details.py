"""Revision 03 occupied battery and disconnect reference geometry.

Executed explicitly inside Fusion by build_battery(); no import-time mutation.
The purchased occupied-holder measurements govern the outer package. Individual
18.2 mm diameter x 69 mm cell cylinders and the red RCY/BEC-style connector are
visual clearance references, not manufacturer-authenticated purchased-part CAD.
"""

import json

import adsk.core as core

from build_rev03 import (GROUP, box, checkpoint, circle_xz, extrude_axis,
                         fillet_long, get, mm, new)


NAMES = {
    "holder": "Battery / FMA protected holder - owner-measured envelope",
    "cell_a": "Battery / 18650 cell A - owner-rated 3400 mAh",
    "cell_b": "Battery / 18650 cell B - owner-rated 3400 mAh",
    "plug": "Battery / red RCY disconnect body - provisional reference",
    "mate": "Battery / red RCY disconnect mate - provisional reference",
}


def _appearance(app, design, name, library_id):
    full_name = "Trimix Rev03 " + name
    appearance = design.appearances.itemByName(full_name)
    if appearance:
        return appearance
    library = app.materialLibraries.itemByName("Fusion Appearance Library")
    if not library:
        raise RuntimeError("Fusion Appearance Library unavailable for battery styling.")
    source = library.appearances.itemById(library_id)
    if not source:
        raise RuntimeError("Battery appearance source unavailable: " + library_id)
    return design.appearances.addByCopy(source, full_name)


def _mark(component, role, note, appearance):
    component.attributes.add(GROUP, "battery_role", role)
    component.attributes.add(GROUP, "geometry_limits", note)
    component.attributes.add(GROUP, "preserve_appearance", "true")
    component.isOriginFolderLightBulbOn = False
    for body in component.bRepBodies:
        body.appearance = appearance


def _cell(name, x, blue):
    component = new(name,
                    "Owner capacity 3400 mAh; 18.2 mm diameter x 69 mm cylinder is a dimensional visual reference, not measured cell CAD")
    sketch = circle_xz(component, "Cell axial cylinder sketch", x,
                       "HolderZ+10.25 mm", "9.1 mm", "HolderY+5 mm")
    feature = extrude_axis(component, sketch, "69 mm", "Blue 18650 reference cylinder", "y")
    feature.bodies.item(0).name = "18650 reference cylinder - 18.2 diameter x 69 length"
    _mark(component, "cell", "Keep inside measured occupied FMA envelope; actual cell dimensions and terminals are unmeasured", blue)
    component.attributes.add(GROUP, "owner_capacity_mAh", "3400")
    component.attributes.add(GROUP, "cell_axis", "+Y")
    return component


def build_battery():
    app, design = get()
    existing = {occurrence.component.name for occurrence in design.rootComponent.occurrences}
    duplicates = existing.intersection(NAMES.values())
    if duplicates:
        raise RuntimeError("Battery stage already started; inspect rather than duplicating: " + ", ".join(sorted(duplicates)))
    expected = {
        "HolderWidth": 42.0, "HolderHeight": 80.4, "HolderDepth": 20.35,
        "HolderX": 3.0, "HolderY": 4.2, "HolderZ": 16.7,
    }
    for parameter, value in expected.items():
        if abs(mm(design, parameter) - value) > 1e-6:
            raise RuntimeError(f"Battery stage requires {parameter}={value:g} mm; run compact fit revision first.")

    black = _appearance(app, design, "Battery Black", "Prism-113")
    blue = _appearance(app, design, "Battery Blue", "Prism-115")
    red = _appearance(app, design, "Battery Red", "Prism-120")

    holder = new(NAMES["holder"],
                 "Owner-measured occupied FMA FPML1S2P050C envelope 42 W x 80.4 H x 20.35 D mm; pocket and local frame details provisional")
    body = box(holder, "Measured occupied holder outer frame", "HolderX", "HolderY", "HolderZ",
               "HolderWidth", "HolderHeight", "HolderDepth")
    fillet_long(holder, body, "1 mm", "Provisional holder outer corner rounds", 1.0)
    # Cell minimum Z is 26.95 - 9.1 = 17.85 mm. A HolderZ+1.2 mm floor
    # would intersect it; HolderZ+1.1 mm leaves 0.05 mm nominal clearance.
    box(holder, "Open occupied cell pocket", "HolderX+1 mm", "HolderY+2 mm", "HolderZ+1.1 mm",
        "HolderWidth-2 mm", "HolderHeight-4 mm", "HolderDepth", "cut", body)
    _mark(holder, "holder",
          "Outer occupied envelope is owner-measured. Pocket, corner radii, contact retention and protection electronics are illustrative; no exact PCB or protection layout is claimed", black)
    holder.attributes.add(GROUP, "occupied_envelope_mm", json.dumps({"width": 42, "height": 80.4, "depth": 20.35}))
    holder.attributes.add(GROUP, "service_axis", "+Z rear withdrawal after battery unplugging and retention release")
    holder.attributes.add(GROUP, "protection_electronics", "Present in purchased holder; unmeasured geometry is not reconstructed")

    _cell(NAMES["cell_a"], "HolderX+10.8 mm", blue)
    _cell(NAMES["cell_b"], "HolderX+31.2 mm", blue)

    plug = new(NAMES["plug"],
               "RCY/BEC-style red two-wire battery disconnect retained by owner; provisional 12 x 10 x 4 mm reference body, not selected manufacturer CAD")
    body = box(plug, "Red battery disconnect reference body", "29 mm", "70 mm", "43 mm",
               "12 mm", "10 mm", "4 mm")
    # A shallow key channel suggests the connector family while staying wholly
    # within the reserved box. It is not the real latch/polarisation geometry.
    box(plug, "Illustrative disconnect key groove", "34.4 mm", "69.9 mm", "42.9 mm",
        "1.2 mm", "10.2 mm", "0.7 mm", "cut", body)
    _mark(plug, "disconnect_body", "Reference envelope X29..41 Y70..80 Z43..47; exact latch, contact and wire geometry unmeasured", red)

    mate = new(NAMES["mate"],
               "RCY/BEC-style red disconnect mating reference; provisional 12 x 10 x 2.2 mm, not selected manufacturer CAD")
    box(mate, "Red battery disconnect mating reference", "29 mm", "70 mm", "47 mm",
        "12 mm", "10 mm", "2.2 mm")
    _mark(mate, "disconnect_mate", "Reference envelope X29..41 Y70..80 Z47..49.2; rearward unplugging clearance requires final service audit", red)
    mate.attributes.add(GROUP, "service_axis", "+Z disconnect after rear cover removal")

    print(json.dumps({
        "battery_model_basis": "occupied holder owner-measured; cells and connector visual references",
        "holder_bounds_mm": {"min": [3, 4.2, 16.7], "max": [45, 84.6, 37.05]},
        "cell_centres_xz_mm": [[13.8, 26.95], [34.2, 26.95]],
        "cell_y_extent_mm": [9.2, 78.2],
        "pocket_floor_mm": 17.8,
        "cell_to_pocket_floor_clearance_mm": 0.05,
        "component_occurrences_added": 5,
        "static_and_service_checks": "pending root model audit",
    }))
    checkpoint("battery")


def run(_context: str):
    raise RuntimeError("Invoke build_battery() explicitly; this module does not rebuild on import.")
