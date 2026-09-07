"""Serialized preparation helpers for a real native Fusion Animation storyboard.

The public May 2026 preview API can manage storyboards and their playhead, but
does not expose creation of component-transform actions. Root must create those
actions through the Animation UI. This module never substitutes Design-space
Occurrence.transform2 changes for persistent Animation actions.
"""
from __future__ import annotations

from datetime import datetime, timezone
import json
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
VERIFY = BASE / "verification"
SOURCE_NAME = "Trimix_Enclosure_A3_PrintReview"


def _get(expected_id=None):
    import adsk.core
    import adsk.fusion
    app = adsk.core.Application.get()
    doc = app.activeDocument
    if not doc or not doc.dataFile or doc.dataFile.name != SOURCE_NAME:
        raise RuntimeError("Activate the saved PrintReview design before Animation work.")
    if expected_id and doc.dataFile.id != expected_id:
        raise RuntimeError("The active source does not match the requested DataFile ID.")
    design = adsk.fusion.Design.cast(doc.products.itemByProductType("DesignProductType"))
    if not design:
        raise RuntimeError("No Design product is available in the active document.")
    return app, doc, design, design.animationManager


def inspect(expected_id=None):
    """Read-only; avoids the known assetRoot error outside initialized Animation."""
    _, doc, design, manager = _get(expected_id)
    result = {
        "data_file_id": doc.dataFile.id, "version": doc.dataFile.versionNumber,
        "is_modified": doc.isModified, "timeline_items": design.timeline.count,
        "workspace_active": manager.isAnimationWorkspaceActive,
    }
    if not manager.isAnimationWorkspaceActive:
        result["status"] = "Animation workspace inactive; storyboard collection not accessed"
        return result
    result["storyboards"] = [{
        "index": i, "active": manager.storyboards.item(i).isActive,
        "end_seconds": manager.storyboards.item(i).end,
        "playhead_seconds": manager.storyboards.item(i).playheadPosition,
    } for i in range(manager.storyboards.count)]
    return result


def prepare_clean_storyboard(expected_id=None, requested_name="PrintReview service exploded"):
    """Create a genuine blank storyboard. Rename and add transform actions in UI.

    A receipt prevents an accidental duplicate. No positive-duration actions are
    reported as created here; those are deliberately a subsequent UI operation.
    """
    _, doc, _, manager = _get(expected_id)
    receipt = VERIFY / "drawing-animation-created.json"
    if receipt.exists():
        previous = json.loads(receipt.read_text())
        if previous.get("data_file_id") == doc.dataFile.id:
            return {"already_prepared": True, **previous}
        raise RuntimeError("An Animation receipt exists for another source. Inspect it before proceeding.")
    if doc.isModified:
        raise RuntimeError("Save source design work before starting its new Animation storyboard.")
    if not manager.isAnimationWorkspaceActive and not manager.activateAnimationWorkspace():
        raise RuntimeError("Fusion could not activate its Animation workspace.")
    storyboard = manager.storyboards.add(True)
    if not storyboard:
        raise RuntimeError("Fusion did not create a clean native storyboard.")
    if not storyboard.activate():
        raise RuntimeError("Fusion could not activate the new storyboard.")
    storyboard.isViewRecordingOn = False
    storyboard.playheadPosition = 0
    result = {
        "created_at": datetime.now(timezone.utc).isoformat(),
        "data_file_id": doc.dataFile.id, "source_version": doc.dataFile.versionNumber,
        "requested_ui_name": requested_name,
        "storyboard_index": manager.storyboards.count - 1,
        "status": "native_empty_storyboard_created_UI_name_and_transform_actions_pending",
        "design_occurrence_transforms_modified_by_script": False,
    }
    VERIFY.mkdir(parents=True, exist_ok=True)
    receipt.write_text(json.dumps(result, indent=2) + "\n")
    return result


def set_playhead(seconds):
    """Prepare a positive-time UI action; camera recording stays off."""
    if float(seconds) < 0:
        raise ValueError("Use zero or positive time; the scratch zone is not an action timeline.")
    _, _, _, manager = _get()
    if not manager.isAnimationWorkspaceActive:
        raise RuntimeError("Activate Animation before changing its playhead.")
    storyboard = manager.activeStoryboard
    if not storyboard:
        raise RuntimeError("No active native storyboard.")
    storyboard.isViewRecordingOn = False
    storyboard.playheadPosition = float(seconds)
    return inspect()


def select_occurrences(full_paths):
    """Select exact existing assembly instances for the next Animation UI command."""
    app, _, design, manager = _get()
    if not manager.isAnimationWorkspaceActive:
        raise RuntimeError("Selection helper is reserved for the Animation workspace.")
    requested = list(full_paths)
    if not requested or len(requested) != len(set(requested)):
        raise ValueError("Provide a nonempty list of unique occurrence full paths.")
    found = {o.fullPathName: o for o in design.rootComponent.allOccurrences}
    missing = set(requested) - found.keys()
    if missing:
        raise ValueError(f"Requested occurrence paths were not found: {sorted(missing)}")
    app.userInterface.activeSelections.clear()
    for path in requested:
        if not app.userInterface.activeSelections.add(found[path]):
            raise RuntimeError(f"Fusion could not select {path!r}.")
    return {"selected_occurrence_paths": requested,
            "next_step": "Use Animation Transform Components in UI at a positive playhead time"}


def verify_named_storyboard(name="PrintReview service exploded"):
    """Verify persistence and nonempty timeline, not geometry or action semantics."""
    _, doc, _, manager = _get()
    if not manager.isAnimationWorkspaceActive:
        raise RuntimeError("Activate Animation to inspect the saved storyboard.")
    storyboard = manager.storyboards.itemByName(name)
    if not storyboard:
        raise RuntimeError(f"Native storyboard {name!r} was not found.")
    if storyboard.end <= 0:
        raise RuntimeError("Native storyboard has no positive-duration timeline.")
    return {
        "data_file_id": doc.dataFile.id, "version": doc.dataFile.versionNumber,
        "is_modified": doc.isModified, "name": name,
        "end_seconds": storyboard.end, "playhead_seconds": storyboard.playheadPosition,
        "native_storyboard_found": True,
        "ui_review_required": "Verify actual component-transform actions, service order, separate screws, trails and assembled pose at time zero. Camera actions alone are insufficient.",
    }
