"""Render an exploded guide image using an unsaved imported Fusion archive copy.

Explicit root-owned execution only. Every moved occurrence and suppressed joint
belongs to the temporary imported document. The original PrintReview geometry,
poses and Animation storyboard are never used as the transform target. This is
a real Fusion viewport image but is not the separately required native Animation
storyboard or Drawing document.
"""
from __future__ import annotations

from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
ARCHIVE = BASE / "Trimix_Enclosure_A3_PrintReview.f3d"
DELTAS_MM = {
    "housing": [0, 0, 0], "rear_cover": [95, 0, 105],
    "display": [0, 0, -45], "display_retainers": [-45, -5, 20],
    "carrier": [50, -10, 40], "pcb": [50, -10, 55],
    "battery": [-40, -15, 40], "disconnect": [-40, -15, 45],
    "button": [40, 0, 0], "usb": [0, -45, 5],
    "chamber": [0, 35, 30], "chamber_lid": [0, 35, 75],
    "gas_fittings": [0, 35, 30],
}
PURCHASED_PARENTS = {"TMX-A3-C01": "display", "TMX-A3-C04": "button", "TMX-A3-C05": "usb"}


def _attribute(entity, name):
    for namespace in ("TrimixRev04", "TrimixPrintReview"):
        value = entity.attributes.itemByName(namespace, name)
        if value:
            return value.value
    return None


def _report(value):
    path = BASE / "verification" / "guide-exploded-copy.json"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2) + "\n")


def signature_differences(expected, actual):
    """Return exact mismatches and numeric magnitudes; never relax acceptance."""
    result = {
        "exact_match": expected == actual,
        "timeline": {"expected": expected["timeline"], "actual": actual["timeline"]},
        "solid_count": {"expected": expected["solid_count"], "actual": actual["solid_count"]},
        "parameter_differences": [], "missing_occurrences": [], "extra_occurrences": [],
        "changed_occurrences": [], "maximum_matrix_element_difference": 0.0,
        "maximum_bound_difference_mm": 0.0, "maximum_body_volume_difference_mm3": 0.0,
        "acceptance": "Exact signature equality is required. Numeric magnitudes are diagnostic only.",
    }
    for name in sorted(set(expected["parameters"]) | set(actual["parameters"])):
        a, b = expected["parameters"].get(name), actual["parameters"].get(name)
        if a != b:
            result["parameter_differences"].append({"name": name, "expected": a, "actual": b})
    wanted = {row["path"]: row for row in expected["occurrences"]}
    found = {row["path"]: row for row in actual["occurrences"]}
    result["missing_occurrences"] = sorted(wanted.keys() - found.keys())
    result["extra_occurrences"] = sorted(found.keys() - wanted.keys())
    for path in sorted(wanted.keys() & found.keys()):
        a, b = wanted[path], found[path]
        if a == b:
            continue
        row = {"path": path, "matrix_differences": [], "body_differences": [],
               "body_counts": {"expected": len(a["bodies"]), "actual": len(b["bodies"])}}
        for index, (v, w) in enumerate(zip(a["transform"], b["transform"])):
            if v != w:
                row["matrix_differences"].append({"index": index, "expected": v, "actual": w, "delta": w - v})
                result["maximum_matrix_element_difference"] = max(result["maximum_matrix_element_difference"], abs(w - v))
        for index in range(max(len(a["bodies"]), len(b["bodies"]))):
            expected_body = a["bodies"][index] if index < len(a["bodies"]) else None
            actual_body = b["bodies"][index] if index < len(b["bodies"]) else None
            if expected_body == actual_body:
                continue
            body_row = {"body_index": index, "expected": expected_body, "actual": actual_body}
            if expected_body and actual_body:
                bound_deltas = {key: [(w - v) * 10 for v, w in zip(expected_body[key], actual_body[key])]
                                for key in ("min_cm", "max_cm")}
                volume_delta = (actual_body["volume_cm3"] - expected_body["volume_cm3"]) * 1000
                body_row.update({"bound_deltas_mm": bound_deltas, "volume_delta_mm3": volume_delta})
                result["maximum_bound_difference_mm"] = max(
                    result["maximum_bound_difference_mm"],
                    max(abs(value) for values in bound_deltas.values() for value in values))
                result["maximum_body_volume_difference_mm3"] = max(
                    result["maximum_body_volume_difference_mm3"], abs(volume_delta))
            row["body_differences"].append(body_row)
        result["changed_occurrences"].append(row)
    return result


def _show_all(design):
    if not design.activateRootComponent():
        raise RuntimeError("Cannot activate temporary assembly root.")
    design.analyses.isLightBulbOn = False
    for analysis in design.analyses.sectionAnalyses:
        analysis.isLightBulbOn = False
    for component in design.allComponents:
        component.isOriginFolderLightBulbOn = False
        for sketch in component.sketches:
            sketch.isLightBulbOn = False
        for plane in component.constructionPlanes:
            plane.isLightBulbOn = False
        for body in component.bRepBodies:
            body.isLightBulbOn = True
    for occurrence in design.rootComponent.allOccurrences:
        occurrence.isLightBulbOn = True


def _plans(design, core):
    root = design.rootComponent
    width_mm = design.userParameters.itemByName("CaseWidth").value * 10
    plans = []
    purchased_found = set()
    # Root occurrences only: moving a purchased parent moves its complete visual assembly once.
    for occurrence in root.occurrences:
        component = occurrence.component
        group = PURCHASED_PARENTS.get(component.partNumber)
        if group:
            purchased_found.add(component.partNumber)
        else:
            group = _attribute(occurrence, "physical_group") or _attribute(component, "physical_group")
        if group not in DELTAS_MM:
            raise RuntimeError("Unmapped root occurrence: " + occurrence.fullPathName)
        movement = list(DELTAS_MM[group])
        raw = _attribute(component, "hardware_definition")
        hardware = json.loads(raw) if raw else None
        screw_axis = None
        if hardware and hardware["kind"] == "screw":
            axis = core.Vector3D.create(0, 0, 1)
            axis.transformBy(occurrence.transform2)
            screw_axis = axis.asArray()
            movement = [amount + axis_component * 12
                        for amount, axis_component in zip(movement, screw_axis)]
        if _attribute(component, "battery_role") == "disconnect_mate":
            movement[2] += 8
        if group == "gas_fittings":
            bounds = occurrence.boundingBox
            centre_x_mm = (bounds.minPoint.x + bounds.maxPoint.x) * 5
            movement[0] += 25 if centre_x_mm > width_mm / 2 else -25
        installed = occurrence.transform2.copy()
        exploded = installed.copy()
        translation = exploded.translation
        exploded.translation = core.Vector3D.create(
            translation.x + movement[0] / 10,
            translation.y + movement[1] / 10,
            translation.z + movement[2] / 10,
        )
        plans.append((occurrence, exploded, {
            "occurrence": occurrence.fullPathName, "component": component.name,
            "part_number": component.partNumber, "physical_group": group,
            "delta_mm": movement, "installed_matrix": installed.asArray(),
            "exploded_matrix": exploded.asArray(), "separated_screw_axis": screw_axis,
            "purchased_parent_moved_as_whole": component.partNumber in PURCHASED_PARENTS,
            "direct_child_occurrences": component.occurrences.count,
        }))
    if purchased_found != set(PURCHASED_PARENTS):
        raise RuntimeError("Imported archive lacks an expected complete purchased parent assembly.")
    return plans


def capture():
    import adsk
    import adsk.core as core
    import adsk.fusion as fusion
    from drawing_native import _design_signature

    app = core.Application.get()
    original_doc = app.activeDocument
    if not original_doc or not original_doc.dataFile or original_doc.dataFile.name != "Trimix_Enclosure_A3_PrintReview":
        raise RuntimeError("Activate the original PrintReview Design/Animation document before this stage.")
    original_design = fusion.Design.cast(original_doc.products.itemByProductType("DesignProductType"))
    if not original_design or not ARCHIVE.is_file():
        raise RuntimeError("Original PrintReview design or final local archive is missing.")
    before = _design_signature(original_design)
    original_camera = app.activeViewport.camera
    original_style = app.activeViewport.visualStyle
    original_modified = original_doc.isModified
    manager = original_design.animationManager
    was_animation = manager.isAnimationWorkspaceActive
    original_storyboard = manager.activeStoryboard if was_animation else None
    original_playhead = original_storyboard.playheadPosition if original_storyboard else None
    original_recording = original_storyboard.isViewRecordingOn if original_storyboard else None
    original_storyboard_end = original_storyboard.end if original_storyboard else None
    original_documents = [app.documents.item(i) for i in range(app.documents.count)]
    temporary_doc = None
    path = BASE / "views" / "exploded.png"
    result = {
        "started_at": datetime.now(timezone.utc).isoformat(),
        "source_archive": str(ARCHIVE),
        "source_archive_sha256": hashlib.sha256(ARCHIVE.read_bytes()).hexdigest(),
        "original_data_file_id": original_doc.dataFile.id,
        "original_source_version": original_doc.dataFile.versionNumber,
        "original_animation_playhead_seconds": original_playhead,
        "original_storyboard_end_seconds": original_storyboard_end,
        "render_method": "Actual Fusion viewport of a temporary imported native archive copy",
        "is_native_animation_storyboard": False,
        "interpretation": "Separated physical assembly relationships; these offsets are not removal trajectories.",
        "status": "pending_import",
    }
    _report(result)
    try:
        # At a positive Animation time, occurrence transforms/bounds can represent
        # that storyboard pose. Read the assembled reference at time zero, then
        # immediately restore the original playhead/camera before importing.
        # Keep `before` as the original current-pose signature for final recovery.
        if original_storyboard:
            try:
                original_storyboard.isViewRecordingOn = False
                original_storyboard.playheadPosition = 0
                adsk.doEvents()
                app.activeViewport.refresh()
                assembled_signature = _design_signature(original_design)
            finally:
                original_storyboard.playheadPosition = original_playhead
                adsk.doEvents()
                app.activeViewport.camera = original_camera
                app.activeViewport.refresh()
                original_storyboard.isViewRecordingOn = original_recording
            result["assembled_reference_method"] = "Current native storyboard at time zero, then original playhead/camera immediately restored"
            restored = _design_signature(original_design)
            result["pre_import_playhead_restoration"] = signature_differences(before, restored)
            if before != restored:
                _report(result)
                raise RuntimeError("Time-zero inspection did not restore the original Animation pose; see detailed pre_import_playhead_restoration.")
        else:
            assembled_signature = before
            result["assembled_reference_method"] = "Current assembled Design workspace signature"
        result["original_pose_vs_assembled_reference"] = signature_differences(assembled_signature, before)
        options = app.importManager.createFusionArchiveImportOptions(str(ARCHIVE))
        temporary_doc = app.importManager.importToNewDocument(options)
        if not temporary_doc or any(temporary_doc == doc for doc in original_documents):
            raise RuntimeError("Import did not create a distinct temporary document.")
        if temporary_doc.dataFile:
            raise RuntimeError("The imported copy unexpectedly has a saved DataFile; stop before changing it.")
        temporary_design = fusion.Design.cast(temporary_doc.products.itemByProductType("DesignProductType"))
        if not temporary_design:
            raise RuntimeError("Imported archive has no Design product.")
        copy_signature = _design_signature(temporary_design)
        result["archive_vs_assembled_source"] = signature_differences(assembled_signature, copy_signature)
        _report(result)
        if copy_signature != assembled_signature:
            diff = result["archive_vs_assembled_source"]
            raise RuntimeError(
                "Archive differs from the time-zero assembled source: "
                f"{len(diff['changed_occurrences'])} changed occurrences; "
                f"max bound delta {diff['maximum_bound_difference_mm']:.12g} mm; "
                f"max body volume delta {diff['maximum_body_volume_difference_mm3']:.12g} mm3. "
                "See guide-exploded-copy.json for exact paths, bodies, matrices and parameter differences. No differences were waived.")
        result.update({"temporary_document": temporary_doc.name,
                       "temporary_solid_count": copy_signature["solid_count"],
                       "temporary_timeline_count": temporary_design.timeline.count,
                       "temporary_root_occurrences": temporary_design.rootComponent.occurrences.count,
                       "temporary_all_occurrences": temporary_design.rootComponent.allOccurrences.count})
        plans = _plans(temporary_design, core)
        result["poses"] = [record for _, _, record in plans]
        _report(result)
        _show_all(temporary_design)
        for component in temporary_design.allComponents:
            for joint in component.joints:
                joint.isSuppressed = True
            for joint in component.asBuiltJoints:
                joint.isSuppressed = True
        for occurrence, _, _ in plans:
            if occurrence.isGrounded:
                occurrence.isGrounded = False
        for occurrence, matrix, _ in plans:
            occurrence.transform2 = matrix
        adsk.doEvents()
        app.activeViewport.visualStyle = core.VisualStyles.ShadedWithVisibleEdgesOnlyVisualStyle
        target = [temporary_design.userParameters.itemByName(name).value / 2
                  for name in ("CaseWidth", "CaseHeight", "CaseDepth")]
        camera = app.activeViewport.camera
        camera.cameraType = core.CameraTypes.OrthographicCameraType
        camera.target = core.Point3D.create(*target)
        camera.eye = core.Point3D.create(target[0] - 35, target[1] + 25, target[2] + 45)
        camera.upVector = core.Vector3D.create(0, 1, 0)
        camera.isSmoothTransition = False
        camera.isFitView = True
        app.activeViewport.camera = camera
        adsk.doEvents()
        app.activeViewport.refresh()
        path.parent.mkdir(parents=True, exist_ok=True)
        image_options = core.SaveImageFileOptions.create(str(path))
        image_options.width = 2200
        image_options.height = 1900
        image_options.isBackgroundTransparent = True
        image_options.isAntiAliased = True
        if not app.activeViewport.saveAsImageFileWithOptions(image_options):
            raise RuntimeError("Fusion could not save the temporary-copy exploded image.")
        result["path"] = str(path)
        result["image_bytes"] = path.stat().st_size
        result["image_sha256"] = hashlib.sha256(path.read_bytes()).hexdigest()
    finally:
        # Never save the imported document or copy any exploded poses to the original.
        if temporary_doc and temporary_doc.isValid and temporary_doc != original_doc:
            result["temporary_copy_closed_without_save"] = temporary_doc.close(False)
        else:
            result["temporary_copy_closed_without_save"] = temporary_doc is None
        if not original_doc.activate():
            raise RuntimeError("Could not reactivate the original PrintReview document.")
        if was_animation:
            if not manager.isAnimationWorkspaceActive and not manager.activateAnimationWorkspace():
                raise RuntimeError("Could not restore the original Animation workspace.")
            if original_storyboard and original_storyboard.isValid:
                if not original_storyboard.isActive and not original_storyboard.activate():
                    raise RuntimeError("Could not restore the original active storyboard.")
                original_storyboard.isViewRecordingOn = False
                if original_storyboard.playheadPosition != original_playhead:
                    original_storyboard.playheadPosition = original_playhead
        app.activeViewport.visualStyle = original_style
        app.activeViewport.camera = original_camera
        app.activeViewport.refresh()
        if original_storyboard and original_storyboard.isValid:
            original_storyboard.isViewRecordingOn = original_recording
            result["original_storyboard_end_unchanged"] = original_storyboard.end == original_storyboard_end
            result["original_playhead_restored"] = original_storyboard.playheadPosition == original_playhead
        after = _design_signature(original_design)
        result["original_restoration_differences"] = signature_differences(before, after)
        result["original_geometry_poses_parameters_timeline_unchanged"] = before == after
        result["original_modified_before"] = original_modified
        result["original_modified_after"] = original_doc.isModified
        result["original_document_active"] = app.activeDocument == original_doc
        result["original_animation_workspace_restored"] = (manager.isAnimationWorkspaceActive == was_animation)
        storyboard_restored = (result.get("original_storyboard_end_unchanged", True)
                               and result.get("original_playhead_restored", True))
        result["status"] = ("captured_from_temporary_copy_pending_visual_QA"
                            if result.get("path") and before == after and result["temporary_copy_closed_without_save"] and storyboard_restored
                            else "incomplete_or_cleanup_failed")
        _report(result)
        if before != after or not result["temporary_copy_closed_without_save"] or not storyboard_restored:
            raise RuntimeError("Temporary-copy render did not preserve the original or close its copy.")
    return {key: result[key] for key in ("status", "path", "image_bytes",
            "original_geometry_poses_parameters_timeline_unchanged", "temporary_copy_closed_without_save")}
