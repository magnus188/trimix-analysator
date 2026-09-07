"""Explicit leaf selection and CAD-read-only Animation diagnostics.

This module does not change the recorded Animation plan, playhead, actor state
or geometry. select_for_native_transform() changes only the UI selection. It
does not open/commit a command. Native actor creation remains a separate root
operation whose success cannot be inferred from Design occurrence transforms.
"""
from __future__ import annotations

from datetime import datetime, timezone
import json
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
PURCHASED_PARENT_IDS = {"TMX-A3-C01", "TMX-A3-C04", "TMX-A3-C05"}


def _attribute(entity, name):
    for group in ("TrimixRev04", "TrimixPrintReview"):
        value = entity.attributes.itemByName(group, name)
        if value:
            return value.value
    return None


def expand_purchased_parents(design, selected_occurrences):
    """Replace the three purchased parents with actual root-context leaf proxies.

    Native occurrences are never manufactured from matrices. Every returned
    object comes from rootComponent.allOccurrences, preserving its true assembly
    context. Duplicate leaves are selected once. Any remaining parent/descendant
    pair is an error, rather than a potentially double-transformed selection.
    """
    all_occurrences = {o.fullPathName: o for o in design.rootComponent.allOccurrences}
    selected = {}
    for requested in selected_occurrences:
        path = requested.fullPathName
        if path not in all_occurrences:
            raise ValueError("Selection does not belong to the current root assembly: " + path)
        occurrence = all_occurrences[path]
        if occurrence.component.partNumber not in PURCHASED_PARENT_IDS:
            selected[path] = occurrence
            continue
        prefix = path + "+"
        leaves = [o for child_path, o in all_occurrences.items()
                  if child_path.startswith(prefix) and o.component.occurrences.count == 0]
        if not leaves:
            raise RuntimeError("Purchased parent has no leaf occurrences: " + path)
        for leaf in leaves:
            if leaf.nativeObject is None or leaf.assemblyContext is None:
                raise RuntimeError("Purchased leaf is not an assembly-context proxy: " + leaf.fullPathName)
            if leaf.component.bRepBodies.count == 0:
                raise RuntimeError("Purchased leaf has no physical BRep actor geometry: " + leaf.fullPathName)
            selected[leaf.fullPathName] = leaf
    paths = sorted(selected)
    for parent in paths:
        for child in paths:
            if child.startswith(parent + "+"):
                raise RuntimeError("Selection contains both parent and descendant: " + parent + " / " + child)
    if not paths:
        raise ValueError("The resolved selection is empty.")
    return [selected[path] for path in paths]


def _root_matches(design, selector):
    """Match the existing operator's selectors without editing its plan or time."""
    selected = []
    for occurrence in design.rootComponent.occurrences:
        component = occurrence.component
        group = _attribute(occurrence, "physical_group") or _attribute(component, "physical_group")
        match = group == selector
        if selector in ("gas_inlet", "gas_outlet") and group == "gas_fittings":
            centre_x_mm = (occurrence.boundingBox.minPoint.x + occurrence.boundingBox.maxPoint.x) * 5
            match = ((centre_x_mm > design.userParameters.itemByName("CaseWidth").value * 5)
                     == (selector == "gas_inlet"))
        if selector == "screws":
            match = _attribute(component, "hardware_kind") == "screw"
        if selector == "mate":
            match = _attribute(component, "battery_role") == "disconnect_mate"
        if match:
            selected.append(occurrence)
    return selected


def _record(occurrence):
    return {
        "path": occurrence.fullPathName,
        "component": occurrence.component.name,
        "part_number": occurrence.component.partNumber,
        "is_assembly_context_proxy": occurrence.nativeObject is not None,
        "assembly_context_path": occurrence.assemblyContext.fullPathName if occurrence.assemblyContext else None,
        "direct_child_count": occurrence.component.occurrences.count,
        "design_api_transform": occurrence.transform2.asArray(),
    }


def selection_plan(selector):
    """Read-only selection resolution; no selection, command or playhead changes."""
    from drawing_animation import _get
    _, doc, design, _ = _get()
    roots = _root_matches(design, selector)
    leaves = expand_purchased_parents(design, roots)
    return {
        "selector": selector, "source_data_file_id": doc.dataFile.id,
        "original_root_paths": [o.fullPathName for o in roots],
        "selected": [o.fullPathName for o in leaves],
        "selection_records": [_record(o) for o in leaves],
        "parent_and_child_selected_together": False,
        "native_animation_actor_creation_verified": False,
    }


def select_for_native_transform(selector):
    """Change only UI selection, before root opens PublisherMoveComponentsCommand."""
    from drawing_animation import _get
    app, _, design, manager = _get()
    if not manager.isAnimationWorkspaceActive:
        raise RuntimeError("Activate Animation before selecting its component-transform targets.")
    roots = _root_matches(design, selector)
    selected = expand_purchased_parents(design, roots)
    app.userInterface.activeSelections.clear()
    for occurrence in selected:
        if not app.userInterface.activeSelections.add(occurrence):
            app.userInterface.activeSelections.clear()
            raise RuntimeError("Fusion could not select the leaf occurrence: " + occurrence.fullPathName)
    return {
        "selector": selector,
        "original_root_paths": [o.fullPathName for o in roots],
        "selected": [o.fullPathName for o in selected],
        "selection_records": [_record(o) for o in selected],
        "parent_and_child_selected_together": False,
        "native_animation_actor_creation_verified": False,
        "command_opened": False, "plan_or_playhead_changed": False,
    }


def inspect_current_transforms():
    """CAD-read-only report; never scrub time or interpret Design values as actors.

    Root can run this function in enforced readOnly mode, then save the returned
    JSON on the host. To compare an assembled state, root must already have
    selected Design or time zero before invoking it. At another Animation time,
    the numerical comparison is diagnostic only and cannot pass that gate.
    """
    from drawing_animation import _get
    from drawing_native import _design_signature
    from drawing_guide_exploded import signature_differences

    _, doc, design, manager = _get()
    baseline_path = BASE / "verification" / "drawing-source-baseline.json"
    baseline = json.loads(baseline_path.read_text())
    current = _design_signature(design)
    animation_active = manager.isAnimationWorkspaceActive
    storyboard = manager.activeStoryboard if animation_active else None
    playhead = storyboard.playheadPosition if storyboard else None
    assembled_context = not animation_active or playhead == 0
    comparison = signature_differences(baseline["signature"], current)
    source_matches = doc.dataFile.id == baseline["source"]["data_file_id"]
    return {
        "checked_at": datetime.now(timezone.utc).isoformat(),
        "source": {"id": doc.dataFile.id, "name": doc.dataFile.name,
                   "version": doc.dataFile.versionNumber, "modified": doc.isModified},
        "baseline_file": str(baseline_path), "baseline_source": baseline["source"],
        "source_lineage_matches": source_matches,
        "animation_workspace_active": animation_active,
        "playhead_seconds": playhead,
        "storyboard_end_seconds": storyboard.end if storyboard else None,
        "assembled_context_selected": assembled_context,
        "cad_assembled_signature_matches_baseline": source_matches and assembled_context and comparison["exact_match"],
        "comparison": comparison,
        "actual_current_root_transforms": [_record(o) for o in design.rootComponent.occurrences],
        "actual_current_leaf_transforms": [_record(o) for o in design.rootComponent.allOccurrences
                                           if o.component.occurrences.count == 0],
        "native_animation_actor_transforms_measured": False,
        "interpretation": "Matrices and body bounds come from the Design occurrence API. They do not establish the native Animation actor transforms, action contents, or visible storyboard pose. Exact equality is not proof that the animation moves are correct.",
        "playhead_camera_geometry_or_plan_modified_by_diagnostic": False,
    }


def save_current_diagnostic():
    """CAD-read-only inspection plus an explicitly requested local JSON report."""
    result = inspect_current_transforms()
    path = BASE / "verification" / "drawing-animation-transform-diagnostic.json"
    path.write_text(json.dumps(result, indent=2) + "\n")
    return {"path": str(path),
            "source_lineage_matches": result["source_lineage_matches"],
            "assembled_context_selected": result["assembled_context_selected"],
            "cad_assembled_signature_matches_baseline": result["cad_assembled_signature_matches_baseline"],
            "root_count": len(result["actual_current_root_transforms"]),
            "leaf_count": len(result["actual_current_leaf_transforms"]),
            "native_animation_actor_transforms_measured": False}
