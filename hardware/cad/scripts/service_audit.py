"""Bounded service-path and free-air point checks, executed only inside Fusion.

All translations and Boolean intersections operate on temporary BRep copies.
This script never transforms occurrences, adds geometry, or saves the design.
Sampled paths are concept checks, not continuous swept-volume validation,
manufacturing release, CFD, or evidence of leak-tightness.
"""

from datetime import datetime, timezone
from math import ceil, dist
from pathlib import Path
import json

import adsk.core as core
import adsk.fusion as fusion
from fusion_audit import _design, _bodies, _write


SOURCE = Path("/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator"
              "/hardware/cad/verification/model-audit.json")
VOLUME_TOL_MM3 = 1e-5
LENGTH_TOL_CM = 1e-7


def _records(design):
    return [{"body": body, "component": occurrence.component.name,
             "name": body.name, "occurrence": occurrence.fullPathName}
            for occurrence in design.rootComponent.allOccurrences
            for body in occurrence.bRepBodies]


def _select(records, prefixes, exclude_name=None):
    result = [record for record in records
              if any(record["component"].startswith(prefix + " ")
                     for prefix in prefixes)
              and (exclude_name is None or exclude_name not in record["name"])]
    for prefix in prefixes:
        if not any(record["component"].startswith(prefix + " ") for record in result):
            raise ValueError("Required component prefix not found: " + prefix)
    return result


def _named(records, name_start):
    found = [record for record in records if record["name"].startswith(name_start)]
    if len(found) != 1:
        raise ValueError("Expected one body matching " + name_start)
    return found[0]["body"]


def _body_label(record):
    return record["component"] + " / " + record["name"]


def _positive_bbox_overlap(one, two):
    return all(min(getattr(one.maxPoint, axis), getattr(two.maxPoint, axis))
               - max(getattr(one.minPoint, axis), getattr(two.minPoint, axis))
               > LENGTH_TOL_CM for axis in "xyz")


def _copy_at(manager, body, translation_mm):
    copied = manager.copy(body)
    if copied is None or not copied.isTransient:
        raise RuntimeError("Could not create transient body copy.")
    transform = core.Matrix3D.create()
    transform.translation = core.Vector3D.create(*(value / 10 for value in translation_mm))
    if not manager.transform(copied, transform):
        raise RuntimeError("Transient translation failed.")
    return copied


def _intersection_volume(manager, moving_copy, obstacle):
    if not _positive_bbox_overlap(moving_copy.boundingBox, obstacle.boundingBox):
        return 0.0
    target = manager.copy(moving_copy)
    if not manager.booleanOperation(target, obstacle, fusion.BooleanTypes.IntersectionBooleanType):
        raise RuntimeError("Temporary Boolean intersection failed; cannot infer clearance.")
    # A successful empty intersection contains no faces. No persistent bodies are
    # ever created, even for a collision result.
    if target.faces.count == 0:
        return 0.0
    return target.volume * 1000


def _steps(final_mm):
    return sorted(set([0.0, 0.25, 1.0, 2.0] +
                      [float(value) for value in range(5, int(ceil(final_mm)) + 1, 5)] +
                      [float(final_mm)]))


def _rear_path(moving, housing, x_offset=0.0):
    minimum_z = min(item["body"].boundingBox.minPoint.z for item in moving) * 10
    housing_rear = max(item["body"].boundingBox.maxPoint.z for item in housing) * 10
    final = ceil(max(1, housing_rear - minimum_z + 1) / 5) * 5
    return [(x_offset, 0.0, z) for z in _steps(final)]


def _path_test(manager, name, moving, fixed, translations, prerequisites):
    collisions, samples = [], []
    for translation in translations:
        sample_pairs = []
        for part in moving:
            copied = _copy_at(manager, part["body"], translation)
            for obstacle in fixed:
                volume = _intersection_volume(manager, copied, obstacle["body"])
                if volume > VOLUME_TOL_MM3:
                    collision = {"translation_mm": list(translation),
                                 "moving": _body_label(part),
                                 "fixed": _body_label(obstacle),
                                 "volume_mm3": round(volume, 6)}
                    collisions.append(collision)
                    sample_pairs.append({"moving": collision["moving"],
                                         "fixed": collision["fixed"]})
        samples.append({"translation_mm": list(translation),
                        "collision_count": len(sample_pairs)})
    return {"name": name,
            "status": "clear_at_sampled_positions" if not collisions else "blocked_at_sampled_positions",
            "moving_bodies": [_body_label(item) for item in moving],
            "fixed_bodies": [_body_label(item) for item in fixed],
            "prerequisites": prerequisites, "sample_count": len(samples),
            "samples": samples, "collision_count": len(collisions),
            "collisions": collisions,
            "method": "Temporary BRep translation and Boolean intersection at discrete poses",
            "continuous_swept_volume_checked": False}


def _point_inside_bbox(point, box):
    return all(getattr(box.minPoint, axis) - LENGTH_TOL_CM <= getattr(point, axis)
               <= getattr(box.maxPoint, axis) + LENGTH_TOL_CM for axis in "xyz")


def _gas_route(design, records):
    """Sample a segmented air centerline around the AO2 neck at GasZ depth."""
    evaluate = lambda name: design.unitsManager.evaluateExpression(name, "mm") * 10
    gas_y, gas_z = evaluate("GasY"), evaluate("GasZ")
    inside_half = evaluate("ChamberWidth") / 2 - evaluate("ChamberWall")
    inlet = _named(records, "Left inlet fitting envelope")
    exhaust = _named(records, "Right exhaust fitting envelope")
    humidity = _named(records, "GYBMEP humidity module envelope")
    neck = _named(records, "AO2 M16 neck envelope")
    co = _named(records, "ZE07-CO total envelope")
    # Keep the inlet turn between the humidity-board edge and chamber sidewall.
    turn_x = (inside_half + humidity.boundingBox.maxPoint.x * 10) / 2
    detour_y = max(humidity.boundingBox.maxPoint.y, neck.boundingBox.maxPoint.y) * 10 + 3.5
    route = [
        (inlet.boundingBox.maxPoint.x * 10 + 1, gas_y, gas_z),
        (turn_x, gas_y, gas_z),
        (turn_x, detour_y, gas_z),
        (-turn_x, detour_y, gas_z),
        (-turn_x, gas_y, gas_z),
        (exhaust.boundingBox.minPoint.x * 10 - 1, gas_y, gas_z),
    ]
    obstacles = _select(records, ["01", "03", "04", "05", "06", "17"])
    sampled, blocked, unknown = [], [], []
    for index, (start, end) in enumerate(zip(route, route[1:])):
        subdivisions = max(1, ceil(dist(start, end)))
        for step in range(subdivisions + 1):
            if index and step == 0:
                continue
            coordinate = tuple(a + (b - a) * step / subdivisions for a, b in zip(start, end))
            point = core.Point3D.create(*(value / 10 for value in coordinate))
            hits, uncertain = [], []
            for obstacle in obstacles:
                body = obstacle["body"]
                if not _point_inside_bbox(point, body.boundingBox):
                    continue
                containment = body.pointContainment(point)
                if containment in (fusion.PointContainment.PointInsidePointContainment,
                                   fusion.PointContainment.PointOnPointContainment):
                    hits.append(_body_label(obstacle))
                elif containment == fusion.PointContainment.UnknownPointContainment:
                    uncertain.append(_body_label(obstacle))
            item = {"point_mm": [round(value, 6) for value in coordinate],
                    "segment": index, "solid_hits": hits, "unknown": uncertain}
            sampled.append(item)
            if hits:
                blocked.append(item)
            if uncertain:
                unknown.append(item)
    return {"status": "free_air_at_sampled_points" if not blocked and not unknown else "needs_review",
            "route_waypoints_mm": route, "sample_spacing_max_mm": 1.0,
            "sample_count": len(sampled), "blocked_points": blocked,
            "unknown_points": unknown,
            "gas_bore_nominal_diameter_mm": 2 * evaluate("GasBoreRadius"),
            "co_front_clearance_above_bore_top_mm": round(
                co.boundingBox.minPoint.z * 10 - gas_z - evaluate("GasBoreRadius"), 6),
            "method": "Point containment against all modeled chamber solids and sensor envelopes",
            "limitations": [
                "Only centerline points were tested; a continuous free tube or 5 mm flow area was not proven.",
                "Sensor envelopes do not represent membrane openings or internal gas paths.",
                "No CFD, pressure drop, dead-volume, mixing, humidity response, leak or seal test performed.",
            ]}


def _driver_access(design, records, manager):
    """Check a nominal 4 mm shaft extending 50 mm rearward from each screw seat."""
    evaluate = lambda name: design.unitsManager.evaluateExpression(name, "mm") * 10
    case_x = evaluate("CaseWidth") / 2 - evaluate("BossInset")
    chamber_x = evaluate("ChamberWidth") / 2
    chamber_y = evaluate("ChamberBottom")
    chamber_height = evaluate("ChamberHeight")
    sets = [
        ("Rear cover screws", (-case_x, case_x),
         (8.0, evaluate("CaseHeight") / 2, evaluate("CaseHeight") - 8),
         evaluate("CaseDepth"), False),
        ("Carrier mounting screws", (-38.0, 38.0), (20.0, 124.0), 22.0, True),
        ("Chamber cartridge screws", (-chamber_x - 3, chamber_x + 3),
         (chamber_y + 5, chamber_y + chamber_height - 12), 50.0, True),
        ("Internal chamber lid screws", (-chamber_x + 5, chamber_x - 5),
         (chamber_y + 4, chamber_y + chamber_height - 4), evaluate("ChamberRear"), True),
    ]
    checks = []
    for label, xs, ys, z_seat, remove_cover in sets:
        fixed = [item for item in records
                 if not (remove_cover and (
                     item["component"].startswith("02 ") or
                     (item["component"].startswith("19 ")
                      and "insert" not in item["name"].lower())))]
        for x in xs:
            for y in ys:
                z_start = z_seat + 0.1
                shaft = manager.createCylinderOrCone(
                    core.Point3D.create(x / 10, y / 10, z_start / 10), 0.2,
                    core.Point3D.create(x / 10, y / 10, (z_start + 50) / 10), 0.2)
                if shaft is None or not shaft.isTransient:
                    raise RuntimeError("Could not create transient screwdriver cylinder.")
                collisions = []
                for obstacle in fixed:
                    volume = _intersection_volume(manager, shaft, obstacle["body"])
                    if volume > VOLUME_TOL_MM3:
                        collisions.append({"fixed": _body_label(obstacle),
                                           "volume_mm3": round(volume, 6)})
                checks.append({"group": label, "start_mm": [x, y, z_start],
                               "rear_cover_removed": remove_cover,
                               "status": "clear" if not collisions else "blocked",
                               "collisions": collisions})
    return {"status": "clear_for_nominal_shaft" if all(not item["collisions"] for item in checks)
                      else "needs_review",
            "shaft_diameter_mm": 4.0, "shaft_length_mm": 50.0,
            "start_above_seat_mm": 0.1, "direction": "+Z", "checks": checks,
            "limitations": ["Only the nominal straight shaft was checked; handle clearance and practical reach are unknown.",
                            "Actual screw heads, driver bits, insert dimensions and engagement depth must be verified."]}


def audit_service_paths():
    """Return and write bounded service and free-air checks without CAD mutation."""
    app, design = _design()
    source = json.loads(SOURCE.read_text(encoding="utf-8"))
    timeline_before = design.timeline.count
    bodies_before = _bodies(design)
    records = _records(design)
    manager = fusion.TemporaryBRepManager.get()
    housing = _select(records, ["01"])
    panel = _select(records, ["14", "15", "16"])
    button_obstacles = _select(records, ["16"])
    pack = _select(records, ["11", "12"])
    usb = _select(records, ["14", "15"])
    button_rigid = _select(records, ["16"], "terminal clearance")
    carrier = _select(records, ["09", "10"])
    display = _select(records, ["07", "08"])
    chamber = _select(records, ["03", "04", "05", "17"])
    fittings = _select(records, ["06"])
    base = ["Switch off, unplug USB, remove six rear-cover screws and the single rear cover.",
            "Disconnect the protected pack at the RCY/BEC plug before servicing electronics.",
            "Release actual retainers and free wires; unmodeled connectors/fasteners are not represented by these tests."]
    tests = []
    tests.append(_path_test(manager, "Protected pack rear extraction", pack, housing + panel,
                            _rear_path(pack, housing), base + ["Release holder retention; cells remain in the holder."]))
    usb_path = [(-x, 0.0, 0.0) for x in (0.0, 0.25, 1.0, 2.0, 3.1)]
    usb_path += _rear_path(usb, housing, x_offset=-3.1)[1:]
    tests.append(_path_test(manager, "USB assembly inward then rear extraction", usb,
                            housing + button_obstacles, usb_path,
                            base + ["Unplug external USB cable and internal USB power harness.",
                                    "Release USB insert retention; move 3.1 mm toward -X (inward from viewer-left wall), then +Z.",
                                    "GCT seal profile, hardware and compression remain provisional."]))
    button_end = max(item["body"].boundingBox.maxPoint.x for item in button_rigid) * 10
    housing_min = min(item["body"].boundingBox.minPoint.x for item in housing) * 10
    button_travel = ceil((button_end - housing_min + 1) / 5) * 5
    tests.append(_path_test(manager, "Button outward extraction after terminal disconnection",
                            button_rigid, housing,
                            [(-x, 0.0, 0.0) for x in _steps(button_travel)],
                            base + ["Disconnect button terminals and remove its interior retaining nut.",
                                    "Only barrel and bezel envelopes move through the hole; the terminal clearance cube represents disconnected wiring.",
                                    "Actual terminal geometry must be measured to confirm it can pass the 12 mm hole."]))
    for label, moving in (("Carrier and future PCB", carrier), ("Display module", display)):
        path = _rear_path(moving, housing)
        tests.append(_path_test(manager, label + " with side assemblies retained",
                                moving, housing + panel, path,
                                base + ["Diagnostic comparison: side USB and button assemblies remain in place.",
                                        "Pack removed; disconnect relevant harnesses and release mounting screws.",
                                        "For the display, remove carrier and future PCB first."]))
        tests.append(_path_test(manager, label + " after side assemblies removed",
                                moving, housing, path,
                                base + ["Remove pack, USB mounting assembly and button first.",
                                        "Disconnect the sensor, display and side-panel harnesses; release rear-accessible mounting screws.",
                                        "For the display, remove carrier and future PCB first; actual display retention is unmodeled."]))
    chamber_path = _rear_path(chamber, housing)
    tests.append(_path_test(manager, "Chamber with gas stubs retained", chamber,
                            housing + fittings, chamber_path,
                            base + ["Diagnostic comparison: external gas stubs remain fixed in the sidewalls."]))
    tests.append(_path_test(manager, "Closed chamber cartridge after gas disconnection", chamber,
                            housing, chamber_path,
                            base + ["Remove external gas inlet and exhaust stubs from both sidewalls.",
                                    "Disconnect sensor harness on the electronics side of the sealed feedthrough; leave the seal with the cartridge.",
                                    "Remove cartridge attachment screws, then withdraw the closed chamber, lid and sensor assembly toward +Z."]))
    gas = _gas_route(design, records)
    driver = _driver_access(design, records, manager)
    bodies_after = _bodies(design)
    if design.timeline.count != timeline_before or bodies_after != bodies_before:
        raise AssertionError("Model geometry changed during the transient-only service audit.")
    prior = {(item["component"], item["name"]): item["bounds_mm"] for item in source["bodies"]}
    stale = [item["component"] + " / " + item["name"] for item in bodies_before
             if prior.get((item["component"], item["name"])) != item["bounds_mm"]]
    final_tests = [test for test in tests if "retained" not in test["name"]]
    report = {"generated_at_utc": datetime.now(timezone.utc).isoformat(),
              "document": app.activeDocument.name,
              "status": "sampled_checks_passed_with_prerequisites"
                        if all(not test["collision_count"] for test in final_tests)
                        and gas["status"] == "free_air_at_sampled_points"
                        and driver["status"] == "clear_for_nominal_shaft" else "needs_review",
              "method_scope": "Sampled rigid-envelope service paths; no continuous swept-volume claim",
              "source_model_audit": str(SOURCE),
              "source_audit_timestamp": source["generated_at_utc"],
              "source_bounds_differing_from_live_model": stale,
              "live_body_count": len(bodies_before), "timeline_count": timeline_before,
              "persistent_geometry_unchanged": True,
              "translation_units": "mm; converted to Fusion cm before Matrix3D translation",
              "intersection_volume_units": "mm^3; Fusion cm^3 multiplied by 1000",
              "intersection_volume_tolerance_mm3": VOLUME_TOL_MM3,
              "tests": tests, "gas_route": gas, "screwdriver_access": driver,
              "routing_limitations": [
                  "Wiring boxes allocate space only; no actual harness bend radius, service loop or strain-relief validation.",
                  "After specified removals, housing is the only fixed obstacle for final carrier/display/chamber checks.",
                  "Screwdriver access, inserts, terminal fit, seals and physical component measurements require fit testing.",
              ]}
    path = _write("service-audit.json", report)
    print(json.dumps({"service_audit": path, "status": report["status"],
                      "tests": [{"name": test["name"], "status": test["status"],
                                 "collisions": test["collision_count"]} for test in tests],
                      "gas_status": gas["status"], "driver_status": driver["status"]}))
    return report


def run(_context: str):
    audit_service_paths()
