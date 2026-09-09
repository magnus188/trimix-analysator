"""Transient-only Revision 03 BRep extraction and rear driver-access checks.

Call audit_paths() or audit_drivers() explicitly inside the owned Fusion model.
audit_paths(stages=[...]) supports bounded runs: cover, disconnect, carrier,
chamber, pack_direct, pack_shifted, display, usb_clamp, usb. CAD is not mutated or saved. JSON
reports are written under rev03/verification. Sampled poses are not a continuous
swept-volume proof; physical retention and flexible wiring remain unvalidated.
"""

from datetime import datetime, timezone
from math import ceil, cos, dist, radians, sin
from pathlib import Path
import json

import adsk.core as core
import adsk.fusion as fusion

from audit_rev03 import _owned_design, _bodies


GROUP = "TrimixRev03"
OUTPUT = Path(__file__).resolve().parents[1] / "verification"
VOLUME_TOLERANCE_MM3 = 1e-5
LENGTH_TOLERANCE_CM = 1e-7
MAX_STEP_MM = 1.0
STAGES = ("cover", "disconnect", "carrier", "chamber", "pack_direct", "pack_shifted",
          "pack_button_off", "pack_lift_shift", "pack_rotated", "display", "usb_clamp", "usb")


def _attribute(entity, name):
    value = entity.attributes.itemByName(GROUP, name)
    return value.value if value else None


def _same_bounds(one, two):
    return all(abs(getattr(getattr(one, end), axis) - getattr(getattr(two, end), axis)) < 1e-6
               for end in ("minPoint", "maxPoint") for axis in "xyz")


def _numeric_bounds(box):
    return (box.minPoint.x,box.minPoint.y,box.minPoint.z,
            box.maxPoint.x,box.maxPoint.y,box.maxPoint.z)


def _record_bounds(record):
    # Records hold immutable world-space temporary copies throughout the audit.
    # One cached API lookup replaces thousands of per-pair boundingBox calls.
    if "bounds_cm" not in record:
        record["bounds_cm"]=_numeric_bounds(record["body"].boundingBox)
    return record["bounds_cm"]


def _numeric_overlap(one,two):
    return all(min(one[index+3],two[index+3])-max(one[index],two[index])>LENGTH_TOLERANCE_CM
               for index in range(3))


def _world_copy(manager, body):
    """Copy native geometry, apply its exact instance pose, verify root bounds."""
    context = body.assemblyContext
    native = body.nativeObject if context else body
    copied = manager.copy(native)
    if copied is None or not copied.isTransient:
        raise RuntimeError("Could not copy a native BRep body to transient geometry.")
    if context and not manager.transform(copied, context.transform2):
        raise RuntimeError("Could not apply occurrence transform to transient body.")
    if not _same_bounds(copied.boundingBox, body.boundingBox):
        raise RuntimeError("Native-to-instance copy bounds differ from root-context proxy: " + body.name)
    return copied


def _records(design, manager):
    records = []
    for occurrence in design.rootComponent.allOccurrences:
        component = occurrence.component
        hardware = _attribute(component, "hardware_definition")
        position = _attribute(occurrence, "hardware_position_mm")
        screw_axis, head_seat = None, None
        if hardware and json.loads(hardware)["kind"] == "screw":
            axis = core.Vector3D.create(0, 0, 1)
            if not axis.transformBy(occurrence.transform2):
                raise RuntimeError("Could not resolve screw instance axis.")
            screw_axis = [axis.x, axis.y, axis.z]
            translation = occurrence.transform2.translation
            head_seat = [translation.x * 10, translation.y * 10, translation.z * 10]
        for index, native_body in enumerate(component.bRepBodies):
            body = native_body.createForAssemblyContext(occurrence)
            if body is None or body.assemblyContext is None:
                raise RuntimeError("Could not create an explicit body proxy for " + occurrence.fullPathName)
            if not body.isSolid:
                continue
            records.append({
                "uid": (occurrence.fullPathName, index), "body": _world_copy(manager, body),
                "name": body.name, "component": component.name, "occurrence": occurrence.fullPathName,
                "battery_role": _attribute(component, "battery_role"),
                "subassembly": _attribute(occurrence, "subassembly") or _attribute(component, "subassembly"),
                "service_group": _attribute(occurrence, "service_group") or _attribute(component, "service_group"),
                "service_role": _attribute(occurrence, "service_role") or _attribute(component, "service_role"),
                "hardware": json.loads(hardware) if hardware else None,
                "hardware_position_mm": json.loads(position) if position else None,
                "screw_axis": screw_axis, "head_seat_mm": head_seat,
            })
    for index, body in enumerate(design.rootComponent.bRepBodies):
        if body.isSolid:
            records.append({"uid": ("ROOT", index), "body": _world_copy(manager, body),
                            "name": body.name, "component": design.rootComponent.name,
                            "occurrence": "ROOT", "battery_role": None, "subassembly": None,
                            "service_group": None, "service_role": None, "hardware": None,
                            "hardware_position_mm": None, "screw_axis": None, "head_seat_mm": None})
    for record in records:
        _record_bounds(record)
    return records


def _label(record):
    return record["occurrence"] + " / " + record["name"]


def _select(records, predicate, label, required=True):
    selected = [record for record in records if predicate(record)]
    if required and not selected:
        raise RuntimeError("Required service group missing: " + label)
    return selected


def _without(records, *groups):
    excluded = {record["uid"] for group in groups for record in group}
    return [record for record in records if record["uid"] not in excluded]


def _hardware_at(records, size, positions, kind="screw", required=True):
    found = []
    for point in positions:
        matched = [record for record in records if record["hardware"]
                   and record["hardware"]["kind"] == kind and record["hardware"]["size"] == size
                   and (record["head_seat_mm"] if kind=="screw" else record["hardware_position_mm"])
                   and dist(record["head_seat_mm"] if kind=="screw" else record["hardware_position_mm"], point) < 1e-5]
        occurrences = {record["occurrence"] for record in matched}
        if required and len(occurrences) != 1:
            raise RuntimeError(f"Expected one {kind} {size} occurrence at {point}; found {len(occurrences)}")
        found.extend(matched)
    return found


def _groups(design, records):
    evaluate = lambda name: design.unitsManager.evaluateExpression(name, "mm") * 10
    width, height, depth = (evaluate(name) for name in ("CaseWidth", "CaseHeight", "CaseDepth"))
    cover_screws=[]
    for x in (6.0,width-6):
        for y in (6.0,height-6):
            matches=[r for r in records if r['hardware'] and r['hardware']['kind']=='screw'
                     and r['hardware']['size']=='M3' and r['head_seat_mm']
                     and abs(r['head_seat_mm'][0]-x)<1e-5 and abs(r['head_seat_mm'][1]-y)<1e-5
                     and min(abs(r['head_seat_mm'][2]-depth),abs(r['head_seat_mm'][2]-(depth-1.65)))<1e-5]
            if len({r['occurrence'] for r in matches})!=1:
                raise RuntimeError(f'Expected one rear M3 screw at X{x:g}/Y{y:g}; found an ambiguous or missing instance')
            cover_screws.extend(matches)
    carrier_positions = [(6, 18, 47.25), (6, 77, 47.25), (40, 14, 47.25)]
    retainer_positions = [(52, 11, 22.3), (14, 119, 22.3)]
    groups = {
        "cover": _select(records, lambda r: r["component"].startswith("02 Single rear cover"), "single rear cover"),
        "cover_screws": cover_screws,
        "mate": _select(records, lambda r: r["battery_role"] == "disconnect_mate", "battery disconnect mate"),
        "pack": _select(records, lambda r: r["battery_role"] in ("holder", "cell", "disconnect_body"), "holder, cells and attached plug"),
        "carrier": _select(records, lambda r: r["component"].startswith("Carrier /"), "carrier and future PCB"),
        "carrier_screws": _hardware_at(records, "M2", carrier_positions),
        "display": _select(records, lambda r: r["component"].startswith(("03 Guition", "04 Guition", "05 Active", "06 Guition")), "complete factory display"),
        "retainers": _select(records, lambda r: r["component"].startswith("Display /"), "display retainers"),
        "retainer_screws": _hardware_at(records, "M2", retainer_positions),
        "lower_retainer": _select(records, lambda r: r["component"].startswith("Display / lower"), "lower display retainer"),
        "lower_retainer_screws": _hardware_at(records, "M2", [(52, 11, 22.3)]),
        "button": _select(records, lambda r: r["component"].startswith("Controls /"), "button and cap", False),
    }
    # Chamber selectors are deliberately explicit metadata. If the builder has
    # not tagged its closed cartridge, fail rather than omit an unknown solid.
    groups["chamber"] = _select(records, lambda r: r["service_group"] in ("closed_chamber", "chamber_lid_fastener"), "closed gas cartridge including lid hardware", False)
    groups["fittings"] = _select(records, lambda r: r["service_group"] == "external_gas_fitting", "external gas fittings", False)
    groups["chamber_screws"] = _select(records, lambda r: r["hardware"] and r["hardware"]["kind"] == "screw"
                                       and r["service_group"] == "chamber_mount_screw", "chamber housing attachment screws", False)
    groups["lid_screws"] = _select(records, lambda r: r["hardware"] and r["hardware"]["kind"] == "screw"
                                   and r["service_group"] == "chamber_lid_fastener", "internal chamber lid screws", False)
    groups["usb"] = _select(records, lambda r: r["subassembly"] == "removable USB insert", "removable USB cartridge", False)
    groups["usb_screws"] = _select(records, lambda r: r["subassembly"] == "removable USB insert"
                                   and r["hardware"] and r["hardware"]["kind"] == "screw", "USB cartridge screws", False)
    groups["usb_clamp"] = _select(records, lambda r: r["subassembly"] == "USB housing clamp"
                                  and not r["hardware"], "removable USB housing clamp", False)
    groups["usb_clamp_screws"] = _select(records, lambda r: r["service_role"] == "USB housing clamp screw"
                                         and r["hardware"] and r["hardware"]["kind"] == "screw", "USB clamp screw", False)
    return groups


def _bbox_overlap(one, two):
    return all(min(getattr(one.maxPoint, axis), getattr(two.maxPoint, axis))
               - max(getattr(one.minPoint, axis), getattr(two.minPoint, axis)) > LENGTH_TOLERANCE_CM
               for axis in "xyz")


def _intersection_volume(manager, moving, obstacle, bounds_checked=False):
    if not bounds_checked and not _bbox_overlap(moving.boundingBox, obstacle.boundingBox):
        return 0.0
    target, tool = manager.copy(moving), manager.copy(obstacle)
    if target is None or tool is None:
        raise RuntimeError("Transient Boolean copy failed.")
    if not manager.booleanOperation(target, tool, fusion.BooleanTypes.IntersectionBooleanType):
        raise RuntimeError("Transient Boolean intersection failed; clearance is unknown.")
    return target.volume * 1000 if target.faces.count else 0.0


def _at(manager, body, offset_mm):
    copied = manager.copy(body)
    transform = core.Matrix3D.create()
    transform.translation = core.Vector3D.create(*(value / 10 for value in offset_mm))
    if copied is None or not manager.transform(copied, transform):
        raise RuntimeError("Temporary BRep pose transform failed.")
    return copied


def _path(waypoints, max_step_mm=MAX_STEP_MM):
    poses = [tuple(waypoints[0])]
    for start, end in zip(waypoints, waypoints[1:]):
        count = max(1, ceil(dist(start, end) / max_step_mm))
        poses.extend(tuple(a + (b - a) * index / count for a, b in zip(start, end))
                     for index in range(1, count + 1))
    return poses


def _full_z_path(moving, fixed, direction=1):
    if direction > 0:
        end = max(_record_bounds(record)[5] for record in fixed) * 10
        start = min(_record_bounds(record)[2] for record in moving) * 10
        travel = ceil(max(1, end - start + 2))
    else:
        end = min(_record_bounds(record)[2] for record in fixed) * 10
        start = max(_record_bounds(record)[5] for record in moving) * 10
        travel = -ceil(max(1, start - end + 2))
    return [(0, 0, 0), (0, 0, travel)]


def _test(manager, name, moving, fixed, waypoints, prerequisites, diagnostic=False):
    collisions, samples = [], []
    fixed_bounds=[(obstacle,_record_bounds(obstacle)) for obstacle in fixed]
    moving_bounds=[(part,_record_bounds(part)) for part in moving]
    for pose in _path(waypoints):
        count = 0
        for part,original_bounds in moving_bounds:
            translated_bounds=tuple(value+pose[index%3]/10 for index,value in enumerate(original_bounds))
            candidates=[obstacle for obstacle,bounds in fixed_bounds if _numeric_overlap(translated_bounds,bounds)]
            if not candidates:
                continue
            moved = _at(manager, part["body"], pose)
            for obstacle in candidates:
                volume = _intersection_volume(manager, moved, obstacle["body"],bounds_checked=True)
                if volume > VOLUME_TOLERANCE_MM3:
                    count += 1
                    collisions.append({"translation_mm": [round(value, 6) for value in pose],
                                       "moving": _label(part), "fixed": _label(obstacle),
                                       "volume_mm3": round(volume, 7)})
        samples.append({"translation_mm": [round(value, 6) for value in pose], "collision_count": count})
    return {"name": name, "diagnostic_only": diagnostic,
            "status": "blocked_at_sampled_poses" if collisions else "clear_at_sampled_poses",
            "moving": [_label(record) for record in moving], "fixed": [_label(record) for record in fixed],
            "prerequisites": prerequisites, "translation_waypoints_mm": waypoints,
            "maximum_sample_step_mm": MAX_STEP_MM, "sample_count": len(samples), "samples": samples,
            "collision_count": len(collisions), "collisions": collisions,
            "blocked_by": sorted({item["fixed"] for item in collisions}),
            "continuous_swept_volume_checked": False,
            "method": "Exact instance BRep copies; translated at <=1 mm intervals; AABB pruning then Boolean intersection"}


def _rigid_poses(waypoints):
    """Interpolate anchor translations <=1 mm and in-plane rotations <=1 degree."""
    poses = [waypoints[0]]
    for start, end in zip(waypoints, waypoints[1:]):
        count = max(1, ceil(dist(start[0], end[0]) / MAX_STEP_MM), ceil(abs(end[1] - start[1])))
        for index in range(1, count + 1):
            fraction = index / count
            anchor = tuple(a + (b - a) * fraction for a, b in zip(start[0], end[0]))
            angle = start[1] + (end[1] - start[1]) * fraction
            poses.append((anchor, angle))
    return poses


def _at_rigid_pose(manager, body, original_anchor, anchor, angle_degrees):
    angle = radians(angle_degrees)
    transform = core.Matrix3D.create()
    if not transform.setToRotation(angle, core.Vector3D.create(0, 0, 1), core.Point3D.create(0, 0, 0)):
        raise RuntimeError("Could not define transient in-plane pack rotation.")
    rotated_anchor = (cos(angle) * original_anchor[0] - sin(angle) * original_anchor[1],
                      sin(angle) * original_anchor[0] + cos(angle) * original_anchor[1], original_anchor[2])
    transform.translation = core.Vector3D.create(*((a - b) / 10 for a, b in zip(anchor, rotated_anchor)))
    copied = manager.copy(body)
    if copied is None or not manager.transform(copied, transform):
        raise RuntimeError("Temporary BRep rigid pack transform failed.")
    return copied


def _rigid_numeric_bounds(bounds,original_anchor,anchor,angle_degrees):
    """Conservative rotated AABB from the four XY corners of the original AABB.

    This can admit extra candidates for curved solids; the unchanged exact BRep
    Boolean decides every candidate. No overlap is inferred from this box alone.
    """
    angle=radians(angle_degrees); cosine,sine=cos(angle),sin(angle)
    points=[]
    for x in (bounds[0],bounds[3]):
        for y in (bounds[1],bounds[4]):
            dx,dy=x-original_anchor[0]/10,y-original_anchor[1]/10
            points.append((anchor[0]/10+cosine*dx-sine*dy,
                           anchor[1]/10+sine*dx+cosine*dy))
    dz=(anchor[2]-original_anchor[2])/10
    return (min(point[0] for point in points),min(point[1] for point in points),bounds[2]+dz,
            max(point[0] for point in points),max(point[1] for point in points),bounds[5]+dz)


def _rotated_pack_test(manager, records, groups):
    moving = groups["pack"]
    fixed = _without(records, moving, groups["cover"], groups["cover_screws"], groups["mate"],
                     groups["carrier"], groups["carrier_screws"], groups["chamber"],
                     groups["chamber_screws"], groups["fittings"])
    original_anchor = (3.0, 4.2, 16.7)
    waypoints = [
        (original_anchor, 0.0), ((3.0, 9.4, 16.7), 0.0), ((3.0, 9.4, 16.7), -9.0),
        ((3.0, 29.0, 16.7), -9.0), ((13.1, 29.0, 16.7), -9.0),
        ((13.1, 29.0, 16.7), 0.0), ((26.0, 29.0, 16.7), 0.0), ((26.0, 29.0, 76.7), 0.0),
    ]
    poses = _rigid_poses(waypoints)
    collisions, samples = [], []
    fixed_bounds=[(obstacle,_record_bounds(obstacle)) for obstacle in fixed]
    moving_bounds=[(part,_record_bounds(part)) for part in moving]
    for anchor, angle in poses:
        sample_collisions = []
        for part,original_bounds in moving_bounds:
            rotated_bounds=_rigid_numeric_bounds(original_bounds,original_anchor,anchor,angle)
            candidates=[obstacle for obstacle,bounds in fixed_bounds if _numeric_overlap(rotated_bounds,bounds)]
            if not candidates:
                continue
            moved = _at_rigid_pose(manager, part["body"], original_anchor, anchor, angle)
            for obstacle in candidates:
                volume = _intersection_volume(manager, moved, obstacle["body"],bounds_checked=True)
                if volume > VOLUME_TOLERANCE_MM3:
                    sample_collisions.append({"anchor_mm": [round(v, 6) for v in anchor],
                                              "angle_degrees": round(angle, 6), "moving": _label(part),
                                              "fixed": _label(obstacle), "volume_mm3": round(volume, 7)})
        samples.append({"anchor_mm": [round(v, 6) for v in anchor], "angle_degrees": round(angle, 6),
                        "collision_count": len(sample_collisions)})
        collisions.extend(sample_collisions)
        if sample_collisions:
            break  # Root requested a bounded first-blocker result, no speculative extra paths.
    return {
        "name": "pack_rotated", "diagnostic_only": False,
        "status": "blocked_at_sampled_pose" if collisions else "clear_at_sampled_poses",
        "moving": [_label(record) for record in moving], "fixed": [_label(record) for record in fixed],
        "original_lower_right_anchor_mm": original_anchor,
        "waypoints": [{"anchor_mm": list(anchor), "angle_degrees": angle} for anchor, angle in waypoints],
        "maximum_anchor_translation_step_mm": MAX_STEP_MM, "maximum_rotation_step_degrees": 1,
        "planned_sample_count": len(poses), "sample_count": len(samples), "samples": samples,
        "stopped_at_first_blocked_pose": bool(collisions), "collision_count": len(collisions), "collisions": collisions,
        "blocked_by": sorted({item["fixed"] for item in collisions}),
        "continuous_swept_volume_checked": False,
        "method": "Exact world-instance BRep copies with analytic rigid in-plane poses; <=1 mm anchor steps and <=1 degree rotation steps; Boolean intersections",
        "prerequisites": [
            "Cover, carrier/PCB and their screws removed; battery unplugged. Closed chamber, housing attachment screws and external gas fittings removed.",
            "Button, USB cartridge/clamp, display retainers and every fixed housing post/insert remain installed obstacles.",
            "Move +Y5.2; rotate -9 degrees about the translated lower-right pack corner; move +Y19.6, then +X10.1; rotate back +9 degrees; move +X12.9, then +Z60 mm.",
            "Holder, both cells and attached battery-side plug move as one rigid reference. Actual flexible wire slack, finger access and grip remain unvalidated.",
        ],
    }


def _require_chamber(groups):
    for name in ("chamber", "fittings", "chamber_screws"):
        if not groups[name]:
            raise RuntimeError("Chamber service metadata is not yet complete: " + name)


def _require_usb(groups):
    for name in ("usb", "usb_screws", "usb_clamp", "usb_clamp_screws"):
        if not groups[name]:
            raise RuntimeError("USB service metadata is not yet complete: " + name)


def _finish(design, before, timeline_before, report, filename):
    if design.timeline.count != timeline_before or _bodies(design) != before:
        raise AssertionError("Transient-only service checks changed persistent model geometry or instance placement.")
    report["persistent_geometry_unchanged"] = True
    report["timeline_count"] = timeline_before
    report["body_instance_count"] = len(before)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT / filename
    path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"report": str(path), "status": report["status"],
                      "tests": [{"name": test["name"], "status": test["status"],
                                 "collisions": test["collision_count"]} for test in report.get("tests", [])]}))
    return report


def audit_paths(stages=None):
    chosen = list(STAGES if stages is None else stages)
    if not chosen or any(stage not in STAGES for stage in chosen):
        raise ValueError("Choose one or more named stages: " + ", ".join(STAGES))
    app, design = _owned_design()
    before, timeline_before = _bodies(design), design.timeline.count
    manager = fusion.TemporaryBRepManager.get()
    records = _records(design, manager)
    g = _groups(design, records)
    tests = []
    for stage in chosen:
        if stage in ("chamber", "pack_shifted", "pack_button_off", "pack_lift_shift", "pack_rotated", "display", "usb_clamp", "usb"):
            _require_chamber(g)
        if stage in ("usb_clamp", "usb", "pack_rotated"):
            _require_usb(g)
        prerequisites = ["Switch off and unplug external USB; actual flexible wiring is not modelled by these rigid tests."]
        diagnostic = False
        if stage == "pack_rotated":
            if not g["button"]:
                raise RuntimeError("Rotated pack test requires the installed button geometry.")
            for parameter, expected in (("HolderX", 3.0), ("HolderY", 4.2), ("HolderZ", 16.7)):
                value = design.unitsManager.evaluateExpression(parameter, "mm") * 10
                if abs(value - expected) > 1e-6:
                    raise RuntimeError(f"Rotated pack path was specified for {parameter}={expected:g} mm, not {value:g}.")
            tests.append(_rotated_pack_test(manager, records, g))
            continue
        if stage == "cover":
            moving = g["cover"]
            fixed = _without(records, moving, g["cover_screws"])
            prerequisites += ["Remove all four M3 rear-cover screws first."]
            waypoints = _full_z_path(moving, fixed)
        elif stage == "disconnect":
            moving = g["mate"]
            fixed = _without(records, moving, g["cover"], g["cover_screws"])
            prerequisites += ["Rear cover removed; release the real battery-plug latch before rearward separation."]
            waypoints = _full_z_path(moving, fixed)
        elif stage == "carrier":
            moving = g["carrier"]
            fixed = _without(records, moving, g["cover"], g["cover_screws"], g["mate"], g["carrier_screws"])
            prerequisites += ["Cover removed and battery unplugged; free all carrier/PCB wiring and remove three shared M2 screws."]
            waypoints = _full_z_path(moving, fixed)
        elif stage == "chamber":
            moving = g["chamber"]
            fixed = _without(records, moving, g["cover"], g["cover_screws"], g["mate"],
                             g["carrier"], g["carrier_screws"], g["fittings"], g["chamber_screws"])
            prerequisites += ["Cover, carrier and PCB removed; battery unplugged; remove both external gas fittings and chamber-to-housing M2 attachments.",
                              "Disconnect sensor harness. Internal lid and its retained hardware move with the closed cartridge."]
            waypoints = _full_z_path(moving, fixed)
        elif stage in ("pack_direct", "pack_shifted", "pack_button_off", "pack_lift_shift"):
            moving = g["pack"]
            removed = [moving, g["cover"], g["cover_screws"], g["mate"], g["carrier"], g["carrier_screws"]]
            if stage != "pack_direct":
                removed += [g["chamber"], g["fittings"], g["chamber_screws"]]
            if stage in ("pack_button_off", "pack_lift_shift"):
                if not g["button"]:
                    raise RuntimeError("Button-removal diagnostic requires button geometry.")
                removed += [g["button"], g["retainers"], g["retainer_screws"],
                            g["usb"], g["usb_clamp"], g["usb_clamp_screws"]]
            fixed = _without(records, *removed)
            prerequisites += ["Cover, unplugged connector mate, carrier and PCB removed; cells stay in protected holder.",
                              "Attached battery-side plug is included as a rigid reference at its installed offset; actual wire slack and hand access remain unvalidated."]
            if stage == "pack_direct":
                diagnostic = True
                prerequisites += ["Diagnostic only: direct rear extraction with sealed chamber still installed; do not assume this path is usable."]
                waypoints = _full_z_path(moving, fixed)
            elif stage == "pack_shifted":
                prerequisites += ["First remove the closed chamber, its housing attachments and external gas fittings.",
                                  "Move the pack +Y24.8 mm first, then +X23 mm toward the viewer's left, then +Z60 mm through the rear.",
                                  "The ordered in-plane movements must clear fixed carrier posts, USB parts, button terminals and housing corners."]
                waypoints = [(0, 0, 0), (0, 24.8, 0), (23, 24.8, 0), (23, 24.8, 60)]
            else:
                diagnostic = True
                prerequisites += ["DIAGNOSTIC: button/cap, both display retainers and their screws, USB cartridge and its clamp have additionally been removed.",
                                  "All housing geometry and permanently fitted inserts remain fixed obstacles; removing unmodelled portions of the housing is not assumed.",
                                  "The physical removability of these extra prerequisites is not established by this pack-only test."]
                if stage == "pack_button_off":
                    waypoints = [(0, 0, 0), (0, 24.8, 0), (23, 24.8, 0), (23, 24.8, 60)]
                else:
                    waypoints = [(0, 0, 0), (0, 0, 4.2), (10.1, 0, 4.2),
                                 (10.1, 24.8, 4.2), (23, 24.8, 4.2), (23, 24.8, 64.2)]
        elif stage == "display":
            moving = g["display"]
            fixed = _without(records, moving, g["cover"], g["cover_screws"], g["mate"], g["carrier"],
                             g["carrier_screws"], g["chamber"], g["fittings"], g["chamber_screws"],
                             g["pack"], g["retainers"], g["retainer_screws"])
            prerequisites += ["Remove rear cover, pack, carrier, closed chamber and their required fittings/fasteners. Disconnect display wiring.",
                              "Release the two display retainer screws and remove the retainers from the rear; then remove the complete display toward -Z through the front.",
                              "Factory-frame capture lip, real contact/preload and mechanical retention have not been validated."]
            waypoints = _full_z_path(moving, fixed, -1)
        elif stage in ("usb_clamp", "usb"):
            moving = g["usb_clamp"] if stage == "usb_clamp" else g["usb"]
            removed = [moving, g["cover"], g["cover_screws"], g["mate"], g["carrier"], g["carrier_screws"],
                       g["chamber"], g["fittings"], g["chamber_screws"], g["pack"],
                       g["lower_retainer"], g["lower_retainer_screws"], g["usb_clamp_screws"]]
            if stage == "usb":
                removed += [g["usb_clamp"]]
            fixed = _without(records, *removed)
            prerequisites += ["Disconnect all USB wiring; remove cover, carrier, chamber and battery pack in their verified order.",
                              "Release the lower display retainer and remove the rear-facing USB housing-clamp screw.",
                              "The fixed USB housing post and its insert remain obstacles; cartridge faceplate/board hardware moves with the cartridge."]
            if stage == "usb_clamp":
                waypoints = _full_z_path(moving, fixed)
                prerequisites += ["Withdraw the removable housing clamp toward +Z before moving the USB cartridge."]
            else:
                travel = _full_z_path(moving, fixed)[-1][2]
                waypoints = [(0, 0, 0), (-12.4, 0, 0), (-12.4, 0, travel)]
                prerequisites += ["USB clamp removed; move the complete cartridge 12.4 mm inward (-X), then withdraw it rearward (+Z)."]
        tests.append(_test(manager, stage, moving, fixed, waypoints, prerequisites, diagnostic))
    required = [test for test in tests if not test["diagnostic_only"]]
    report = {"generated_at_utc": datetime.now(timezone.utc).isoformat(), "document": app.activeDocument.name,
              "status": "sampled_paths_clear_with_prerequisites" if required and all(not test["collision_count"] for test in required)
                        else "diagnostic_only" if not required else "blocked_or_needs_review",
              "scope": "Rigid service paths only; <=1 mm discrete poses, not continuous sweeps", "tests": tests,
              "volume_tolerance_mm3": VOLUME_TOLERANCE_MM3,
              "mechanical_retention": "NOT VALIDATED: actual factory display capture lip, preload and fastening detail require measurement",
              "limitations": ["No full swept volume, hand/handle access, flexible harness, latch release, seal or physical fit test.",
                              "A blocked direct pack diagnostic is not a passing extraction result; use only a separately clear documented sequence.",
                              "All fixed model solids remain obstacles unless explicitly listed as removed prerequisites."]}
    suffix = "all" if stages is None else "-".join(chosen)
    return _finish(design, before, timeline_before, report, "service-paths-" + suffix + ".json")


def audit_drivers():
    app, design = _owned_design()
    before, timeline_before = _bodies(design), design.timeline.count
    manager = fusion.TemporaryBRepManager.get()
    records = _records(design, manager)
    g = _groups(design, records)
    _require_chamber(g)
    _require_usb(g)
    groups = [
        ("Rear cover M3", g["cover_screws"], [], "Exterior access; cover remains fitted."),
        ("Carrier and PCB M2", g["carrier_screws"], [g["cover"], g["cover_screws"], g["mate"]],
         "Cover removed and battery unplugged; pack and chamber remain installed."),
        ("Chamber housing M2", g["chamber_screws"], [g["cover"], g["cover_screws"], g["mate"], g["carrier"], g["carrier_screws"], g["fittings"]],
         "Cover, carrier and fittings removed; battery unplugged."),
        ("Display retainers M2", g["retainer_screws"], [g["cover"], g["cover_screws"], g["mate"], g["carrier"], g["carrier_screws"], g["chamber"], g["chamber_screws"], g["fittings"], g["pack"]],
         "Cover, carrier, chamber and pack removed before display retainer access."),
        ("Internal chamber lid M2", g["lid_screws"], [_without(records, g["chamber"])],
         "Closed cartridge already removed and supported on the bench; only other cartridge solids are obstacles."),
        ("USB housing clamp M2", g["usb_clamp_screws"], [g["cover"], g["cover_screws"], g["mate"], g["carrier"], g["carrier_screws"], g["chamber"], g["chamber_screws"], g["fittings"], g["pack"], g["lower_retainer"], g["lower_retainer_screws"]],
         "Cover, carrier, chamber, pack and lower display retainer removed; USB cartridge remains installed."),
        ("USB cartridge M2 on bench", g["usb_screws"], [_without(records, g["usb"])],
         "Complete USB cartridge already removed; board screws approach +Z and faceplate screws approach their actual +X instance axes."),
    ]
    tests = []
    seen = set()
    for group_name, screws, removed, prerequisites in groups:
        for screw in screws:
            if screw["occurrence"] in seen:
                continue
            seen.add(screw["occurrence"])
            hardware, position = screw["hardware"], screw["head_seat_mm"]
            axis = screw["screw_axis"]
            diameter = 6.0 if hardware["size"] == "M3" else 5.0
            start = [value + component * (hardware["head_height_mm"] + 0.05) for value, component in zip(position, axis)]
            end = [value + component * 50 for value, component in zip(start, axis)]
            shaft = manager.createCylinderOrCone(core.Point3D.create(*(value / 10 for value in start)), diameter / 20,
                                                  core.Point3D.create(*(value / 10 for value in end)), diameter / 20)
            if shaft is None or not shaft.isTransient:
                raise RuntimeError("Could not create transient driver shaft.")
            fixed = _without(records, *removed, [record for record in records if record["occurrence"] == screw["occurrence"]])
            collisions = []
            shaft_bounds=_numeric_bounds(shaft.boundingBox)
            for obstacle in fixed:
                if not _numeric_overlap(shaft_bounds,_record_bounds(obstacle)):
                    continue
                volume = _intersection_volume(manager, shaft, obstacle["body"],bounds_checked=True)
                if volume > VOLUME_TOLERANCE_MM3:
                    collisions.append({"fixed": _label(obstacle), "volume_mm3": round(volume, 7)})
            tests.append({"name": group_name + " / " + screw["occurrence"], "status": "blocked" if collisions else "clear_for_nominal_shaft",
                          "start_mm": start, "diameter_mm": diameter, "length_mm": 50, "direction_vector": axis,
                          "prerequisites": prerequisites, "collision_count": len(collisions), "collisions": collisions})
    report = {"generated_at_utc": datetime.now(timezone.utc).isoformat(), "document": app.activeDocument.name,
              "status": "clear_for_nominal_shafts" if all(not test["collision_count"] for test in tests) else "blocked_or_needs_review",
              "tests": tests, "method": "Transient cylinders against exact instance BRep solids; AABB pruning plus Boolean intersection",
              "limitations": ["Shaft starts 0.05 mm above nominal head top; the correctly sized bit inside the hex recess is not modelled.",
                              "M2 shaft diameter5 mm, M3 diameter6 mm, length50 mm; actual handle, hand access and practical torque remain untested.",
                              "Display capture lip and mechanical retention remain unvalidated even when driver access is clear."]}
    return _finish(design, before, timeline_before, report, "service-drivers.json")


def run(_context: str):
    raise RuntimeError("Call audit_paths(stages=[...]) or audit_drivers() explicitly for bounded checks.")
