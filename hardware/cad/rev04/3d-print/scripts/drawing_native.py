"""Native Fusion Drawing stages for the PrintReview documentation.

Run only inside Fusion, serially with the geometry work. Importing this module
does not touch Fusion. Drawing creation is a July 2026 preview API; the fallback
for an unavailable operation is the Drawing UI, never a raster imitation.

The installed API cannot set the projection angle, place a view, create a
section or balloon, or enumerate the native parts-list rows. Set First Angle
in the Fusion drawing preferences/template before creation and finish those
operations in the Drawing UI. export_pdf() verifies the resulting convention.
"""
from __future__ import annotations

from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re

BASE = Path(__file__).resolve().parents[1]
VERIFY = BASE / "verification"
OUTPUT = BASE / "drawings"
SOURCE_NAME = "Trimix_Enclosure_A3_PrintReview"


def _api():
    import adsk.core
    import adsk.fusion
    import adsk.drawing
    return adsk.core, adsk.fusion, adsk.drawing


def _stamp():
    return datetime.now(timezone.utc).isoformat()


def _write(name, value):
    VERIFY.mkdir(parents=True, exist_ok=True)
    path = VERIFY / name
    path.write_text(json.dumps(value, indent=2) + "\n")
    return str(path)


def _identity(doc):
    data = doc.dataFile
    return {
        "document_name": doc.name,
        "is_modified": doc.isModified,
        "data_file_id": data.id if data else None,
        "data_file_version_id": data.versionId if data else None,
        "data_file_name": data.name if data else None,
        "version": data.versionNumber if data else None,
        "cloud_complete": data.isComplete if data else None,
    }


def _source(expected_id=None, require_saved=True):
    core, fusion, _ = _api()
    app = core.Application.get()
    doc = app.activeDocument
    if not doc or not doc.dataFile:
        raise RuntimeError("Open the saved PrintReview design before this stage.")
    if doc.dataFile.name != SOURCE_NAME:
        raise RuntimeError(f"Expected {SOURCE_NAME}, got {doc.dataFile.name!r}.")
    if expected_id and doc.dataFile.id != expected_id:
        raise RuntimeError("Active source DataFile ID does not match the requested source.")
    design = fusion.Design.cast(doc.products.itemByProductType("DesignProductType"))
    if not design:
        raise RuntimeError("The active PrintReview document is not a Fusion design.")
    if require_saved and (doc.isModified or not doc.dataFile.isComplete):
        raise RuntimeError("Save PrintReview and wait for cloud processing before creating linked drawings.")
    return app, doc, design


def _drawing(expected_id=None):
    core, _, drawing_api = _api()
    app = core.Application.get()
    doc = drawing_api.DrawingDocument.cast(app.activeDocument)
    if not doc:
        raise RuntimeError("Activate the native Fusion Drawing document first.")
    if expected_id and (not doc.dataFile or doc.dataFile.id != expected_id):
        raise RuntimeError("Active drawing DataFile ID does not match the requested drawing.")
    return app, doc, doc.drawing


def inspect_source():
    """Read-only report; safe for an enforced readOnly MCP script."""
    app, doc, design = _source(require_saved=False)
    _, _, da = _api()
    definitions = {}
    for occurrence in design.rootComponent.allOccurrences:
        component = occurrence.component
        key = component.entityToken
        row = definitions.setdefault(key, {
            "name": component.name, "part_number": component.partNumber,
            "description": component.description, "occurrence_paths": [],
            "bodies": component.bRepBodies.count,
        })
        row["occurrence_paths"].append(occurrence.fullPathName)
    manager = da.DrawingManager.get()
    return {
        "checked_at": _stamp(), "source": _identity(doc),
        "app_version": app.version,
        "drawing_manager_valid": bool(manager and manager.isValid),
        "timeline_items": design.timeline.count,
        "occurrences": design.rootComponent.allOccurrences.count,
        "definitions": sorted(definitions.values(), key=lambda row: row["name"]),
        "does_not_certify": "Manufacturing readiness, tolerances, materials or purchase quantities",
    }


def _design_signature(design):
    occurrences = []
    for occurrence in design.rootComponent.allOccurrences:
        bodies = [{"name": body.name, "volume_cm3": body.volume,
                   "min_cm": body.boundingBox.minPoint.asArray(),
                   "max_cm": body.boundingBox.maxPoint.asArray()}
                  for body in occurrence.bRepBodies]
        occurrences.append({"path": occurrence.fullPathName,
                            "transform": occurrence.transform2.asArray(),
                            "bodies": bodies})
    return {"timeline": design.timeline.count,
            "parameters": {p.name: p.expression for p in design.userParameters},
            "occurrences": sorted(occurrences, key=lambda row: row["path"]),
            "solid_count": sum(len(row["bodies"]) for row in occurrences)}


def begin_documentation():
    _, doc, design = _source()
    path = VERIFY / "drawing-source-baseline.json"
    if path.exists():
        raise RuntimeError("Documentation baseline already exists; compare it instead of overwriting.")
    record = {"source": _identity(doc), "signature": _design_signature(design)}
    _write(path.name, record)
    return {"source": record["source"], "solid_count": record["signature"]["solid_count"],
            "occurrence_count": len(record["signature"]["occurrences"]),
            "timeline": record["signature"]["timeline"]}


def verify_source_unchanged():
    _, doc, design = _source(require_saved=False)
    baseline = json.loads((VERIFY / "drawing-source-baseline.json").read_text())
    current = _design_signature(design)
    result = {"checked_at": _stamp(), "source": _identity(doc),
              "geometry_poses_parameters_timeline_unchanged": current == baseline["signature"],
              "solid_count": current["solid_count"], "occurrences": len(current["occurrences"]),
              "timeline": current["timeline"]}
    _write("drawing-source-unchanged.json", result)
    if not result["geometry_poses_parameters_timeline_unchanged"]:
        raise RuntimeError("Source geometry/poses/parameters/timeline differs from the documentation baseline.")
    return result


def save_source():
    _, doc, _ = _source(require_saved=False)
    if not doc.save("Native documentation named views and Animation storyboard"):
        raise RuntimeError("Fusion did not save the documentation source.")
    return _identity(doc)


def _part_omissions(design, selected_names):
    """Validate the API's substring omission rule against every actual part name."""
    names = {o.component.name for o in design.rootComponent.allOccurrences}
    selected = set(selected_names or [])
    if not selected:
        raise ValueError("Provide the exact final fabricated component names for detail sheets.")
    missing = selected - names
    if missing:
        raise ValueError(f"Detail components not found in current source: {sorted(missing)}")
    omitted = sorted(names - selected)
    if any("," in name or not name.strip() for name in omitted):
        raise ValueError("A component name cannot be represented safely in the API's comma-separated omission rule; use Drawing UI selection.")
    conflicts = [(omit, keep) for omit in omitted for keep in selected
                 if omit.casefold() in keep.casefold()]
    if conflicts:
        raise ValueError(f"Name omission would also remove selected details: {conflicts}")
    return omitted


def _configure_input(manager, data_file, kind, selected_names, omitted, include_animation):
    _, _, da = _api()
    drawing_input = manager.createDrawingInput(
        data_file, da.DrawingCreationModes.AutomaticDrawingCreationMode)
    if not drawing_input:
        raise RuntimeError("DrawingManager did not create an automatic drawing input.")
    drawing_input.baseDocumentType = da.BaseDocumentTypes.FromScratchBaseDocumentType
    drawing_input.standard = da.DrawingStandardTypes.ISODrawingStandardType
    drawing_input.units = da.DrawingUnitTypes.MillimeterDrawingUnitType
    drawing_input.sheetSize = da.SheetSizes.A3ISOSheetSize
    drawing_input.orientationType = da.SheetOrientationTypes.LandscapeSheetOrientationType
    drawing_input.content = da.DrawingContentTypes.FullAssemblyDrawingContentType
    drawing_input.sheetCreationType = da.SheetCreationTypes.AllLevelsSheetCreationType
    # A3 is not a configured design. Leave configuration at its documented empty default.
    preferences = drawing_input.automationPreferences
    global_preferences = preferences.globalPreferences
    is_details = kind == "details"
    global_preferences.omitComponentsWithKeywords = ",".join(omitted) if is_details else ""
    global_preferences.isDetectAndOmitFasteners = False
    global_preferences.isMainAssemblySheetGenerated = not is_details
    global_preferences.isSubAssemblySheetGenerated = False
    global_preferences.isAnimationSheetGenerated = bool(include_animation and not is_details)
    global_preferences.isComponentSheetGenerated = is_details
    global_preferences.isFoldedModelSheetGenerated = False
    global_preferences.isFlatPatternSheetGenerated = False
    global_preferences.isAutoDimensionEnabled = is_details
    assembly = preferences.mainAssemblyPreferences
    assembly.isoViewSheetPreferences.isSheetCreated = True
    assembly.isoViewSheetPreferences.isPartsListIncluded = True
    assembly.isoViewSheetPreferences.partsListLocationType = da.TableLocationTypes.TopRightTableLocationType
    assembly.orthogonalViewSheetPreferences.isSheetCreated = True
    assembly.orthogonalViewSheetPreferences.isPartsListIncluded = False
    assembly.autoDimensionPreferences.isAutoDimensionEnabled = False
    assembly.drawingViewPreferences.style = da.DrawingViewStyleTypes.VisibleEdgesDrawingViewStyleType
    component = preferences.componentPreferences
    component.sheetViewPreferences.isOrthogonalViewAdded = True
    component.sheetViewPreferences.isIsometricViewAdded = True
    component.autoDimensionPreferences.isAutoDimensionEnabled = True
    component.autoDimensionPreferences.dimensionStrategyType = da.DimensionStrategyTypes.OverallDimensionStrategyType
    component.drawingViewPreferences.style = da.DrawingViewStyleTypes.VisibleAndHiddenEdgesDrawingViewStyleType
    component.drawingViewPreferences.centerMarkOptions.isAppliedToHoles = True
    component.drawingViewPreferences.centerLineOptions.isAppliedToHoles = True
    return drawing_input


def create_assembly(expected_id=None, include_animation=False):
    return create_drawing("assembly", expected_id=expected_id, include_animation=include_animation)


def create_details(selected_component_names, expected_id=None):
    return create_drawing("details", selected_component_names, expected_id)


def create_printed_details(expected_id=None):
    """Use root's current part map, then validate every selected name in live CAD."""
    part_map = json.loads((VERIFY / "native-part-map.json").read_text())
    selected = [row["component"] for row in part_map["parts"] if row["category"] == "printed"]
    return create_details(selected, expected_id)


def prepare_named_views():
    """Save unambiguous drawing orientations without changing any solid pose.

    +X is the viewer's left, +Y is up, +Z is rear. A screen-front view therefore
    has its eye on -Z, looks toward +Z and uses +Y as up. Use these names when
    creating base views: an existing base view's orientation cannot be edited.
    """
    app, _, design = _source(require_saved=False)
    core, _, _ = _api()
    import adsk
    target_values = [design.userParameters.itemByName(name).value / 2
                     for name in ("CaseWidth", "CaseHeight", "CaseDepth")]
    previous_camera = app.activeViewport.camera
    directions = {
        "PRINT Screen front": (0, 0, -50),
        "PRINT Rear": (0, 0, 50),
        "PRINT Viewer left": (50, 0, 0),
        "PRINT Viewer right": (-50, 0, 0),
        "PRINT Top": (0, 50, 0),
        "PRINT Front isometric": (35, 25, -45),
        "PRINT Rear isometric": (-35, 25, 45),
    }
    created = []
    try:
        for name, offset in directions.items():
            camera = app.activeViewport.camera
            camera.cameraType = core.CameraTypes.OrthographicCameraType
            camera.target = core.Point3D.create(*target_values)
            camera.eye = core.Point3D.create(*[x + d for x, d in zip(target_values, offset)])
            camera.upVector = core.Vector3D.create(0, 0, -1) if name == "PRINT Top" else core.Vector3D.create(0, 1, 0)
            camera.isSmoothTransition = False
            camera.isFitView = True
            app.activeViewport.camera = camera
            adsk.doEvents()
            app.activeViewport.refresh()
            # This build throws for a missing itemByName despite the stub's null contract.
            saved = next((design.namedViews.item(i) for i in range(design.namedViews.count)
                          if design.namedViews.item(i).name == name), None)
            if saved:
                saved.camera = app.activeViewport.camera
            else:
                saved = design.namedViews.add(app.activeViewport.camera, name)
            if not saved:
                raise RuntimeError(f"Could not create named view {name!r}.")
            created.append(name)
    finally:
        app.activeViewport.camera = previous_camera
        app.activeViewport.refresh()
    return {"named_views": created, "source_save_required": True,
            "screen_plane": "XY", "front_camera_eye_direction": "-Z", "up": "+Y"}


def create_drawing(kind, selected_component_names=None, expected_id=None, include_animation=False):
    """Create native linked drawings only; no view snapshots or model transforms.

    Creation and opening are separate stages because cloud drawing processing
    may still be in progress. A saved receipt prevents duplicate creation on a
    retry. The receipt does not assert first-angle settings or visual QA passed.
    """
    if kind not in {"assembly", "details"}:
        raise ValueError("kind must be assembly or details")
    app, doc, design = _source(expected_id)
    _, _, da = _api()
    selected = sorted(set(selected_component_names or []))
    omitted = _part_omissions(design, selected) if kind == "details" else []
    receipt_path = VERIFY / f"drawing-{kind}-created.json"
    source = _identity(doc)
    if receipt_path.exists():
        receipt = json.loads(receipt_path.read_text())
        if (receipt.get("source", {}).get("data_file_id") == source["data_file_id"]
                and receipt.get("source", {}).get("version") == source["version"]
                and receipt.get("selected_component_names") == selected
                and receipt.get("include_animation") == bool(include_animation)):
            return {"already_created": True, **receipt}
        raise RuntimeError("A drawing creation receipt already exists for different inputs. Review the existing native drawing instead of silently creating duplicates.")
    manager = da.DrawingManager.get()
    if not manager:
        raise RuntimeError("Native Drawing API unavailable; use Fusion Drawing UI.")
    drawing_input = _configure_input(manager, doc.dataFile, kind, selected, omitted, include_animation)
    created = manager.createDrawing(drawing_input)
    if not created:
        raise RuntimeError("Native automatic drawing creation returned no DataFile.")
    receipt = {
        "created_at": _stamp(), "source": source, "kind": kind,
        "drawing_data_file_id": created.id,
        "drawing_version_id": created.versionId,
        "drawing_name": created.name,
        "drawing_version": created.versionNumber,
        "cloud_complete": created.isComplete,
        "selected_component_names": selected,
        "omitted_component_names_for_detail_generation": omitted,
        "include_animation": bool(include_animation),
        "native_associative_parts_list_requested": kind == "assembly",
        "projection_requested_in_ui": "First angle; must be verified after creation",
        "status": "created_native_drawing_pending_open_and_review",
    }
    # Persist the actual returned ID immediately, before optional rename/open work.
    _write(receipt_path.name, receipt)
    if doc.isModified:
        raise RuntimeError("Source became modified during drawing creation; inspect before continuing. The drawing creation receipt has been preserved.")
    return receipt


def open_created(kind="assembly"):
    """Open the previously created cloud drawing; call again after processing if needed."""
    core, _, _ = _api()
    receipt = json.loads((VERIFY / f"drawing-{kind}-created.json").read_text())
    app = core.Application.get()
    # findFileById documents the fs.file:vf version ID, not the dm.lineage ID.
    data = app.data.findFileById(receipt["drawing_version_id"])
    if not data:
        raise RuntimeError("The recorded native drawing DataFile could not be found.")
    data = data.latestVersion
    if not data.isComplete:
        return {"status": "cloud_processing", "drawing_data_file_id": data.id}
    app.documents.open(data)
    return inspect_drawing(data.id)


def inspect_drawing(expected_id=None):
    """Read-only native settings/view inventory, not a visual approval."""
    app, doc, drawing = _drawing(expected_id)
    _, _, da = _api()
    settings = drawing.documentSettings
    sheet = drawing.activeSheet
    sheet_result = None
    if sheet:
        sheet_result = {
            "name": sheet.name, "width_native_drawing_units": sheet.width,
            "height_native_drawing_units": sheet.height,
            "is_a3": sheet.sheetSize == da.SheetSizes.A3ISOSheetSize,
            "is_landscape": sheet.orientation == da.SheetOrientationTypes.LandscapeSheetOrientationType,
            "view_types": [sheet.views.item(i).type for i in range(sheet.views.count)],
            "view_count": sheet.views.count,
        }
    return {
        "checked_at": _stamp(), "app_version": app.version,
        "drawing": _identity(doc),
        "is_iso": settings.standard == da.DrawingStandardTypes.ISODrawingStandardType,
        "is_mm": settings.units == da.DrawingUnitTypes.MillimeterDrawingUnitType,
        "is_first_angle": settings.projectionAngle == da.ProjectionAngleTypes.FirstAngleProjectionAngleType,
        "active_sheet": sheet_result,
        "inventory_limit": "Installed API exposes the active sheet, not Drawing.sheets or parts-list rows. Inspect each native sheet and its list/balloons through UI; verify all exported PDF pages separately.",
    }


def verify_drawing_association(expected_source_id="urn:adsk.wipprod:dm.lineage:l5zV9NCVS8ysJ6aeOO-4sw"):
    """Read the saved cloud drawing's actual referenced design identities."""
    _, doc, _ = _drawing()
    if not doc.dataFile or doc.isModified:
        raise RuntimeError("Save the native drawing before verifying its source association.")
    data = doc.dataFile
    if not data.isComplete:
        return {"status": "cloud_processing", "drawing": _identity(doc)}
    references = [{"id": child.id, "version_id": child.versionId,
                   "version": child.versionNumber, "name": child.name}
                  for child in data.childReferences]
    result = {"checked_at": _stamp(), "drawing": _identity(doc),
              "references": references, "expected_source_id": expected_source_id,
              "source_reference_found": any(row["id"] == expected_source_id for row in references)}
    _write("drawing-association-" + re.sub(r"[^A-Za-z0-9_-]", "_", data.name) + ".json", result)
    if not result["source_reference_found"]:
        raise RuntimeError("The saved drawing does not report the expected PrintReview source in its child references.")
    return result


def reopen_drawing():
    """Close a saved drawing and reopen the same saved native DataFile."""
    app, doc, _ = _drawing()
    if not doc.dataFile or doc.isModified or not doc.dataFile.isComplete:
        raise RuntimeError("Save the drawing and wait for cloud completion before reopening it.")
    data = doc.dataFile
    data_id = data.id
    if not doc.close(False):
        raise RuntimeError("Fusion did not close the saved drawing.")
    app.documents.open(data)
    return {"reopened": inspect_drawing(data_id), "association": verify_drawing_association()}


def configure_active_sheet(sheet_name=None, all_level_parts_list=False):
    """Set supported native sheet/table defaults. Projection remains an explicit UI step."""
    _, _, drawing = _drawing()
    _, _, da = _api()
    sheet = drawing.activeSheet
    if not sheet:
        raise RuntimeError("No active native drawing sheet.")
    sheet.sheetSize = da.SheetSizes.A3ISOSheetSize
    sheet.orientation = da.SheetOrientationTypes.LandscapeSheetOrientationType
    if sheet_name:
        sheet.name = sheet_name
    table = drawing.documentSettings.tableSettings.partsListSettings
    table.structure = (da.PartsListStructureTypes.AllLevelPartsListStructureType
                       if all_level_parts_list else da.PartsListStructureTypes.FirstLevelPartsListStructureType)
    table.tableDirection = da.TableDirectionTypes.DownTableDirectionType
    return inspect_drawing()


def tidy_active_sheet():
    """Optional UI-equivalent layout pass; always inspect its result visually."""
    _, _, drawing = _drawing()
    if not drawing.activeSheet.tidyUp():
        raise RuntimeError("Native drawing sheet tidy-up did not succeed.")
    return inspect_drawing()


def save_drawing(description="Native PrintReview drawing documentation"):
    _, doc, _ = _drawing()
    if not doc.dataFile:
        raise RuntimeError("Save the new native drawing into the project through Fusion UI first.")
    if not doc.save(description):
        raise RuntimeError("Fusion did not save the native drawing.")
    return inspect_drawing()


def export_pdf(output_stem, expected_id=None):
    """Export all sheets as a genuine Fusion vector drawing PDF.

    The PDF skill marker must have run once before the export phase. This stage
    records file existence/integrity only; rendered-page QA is a separate gate.
    """
    if not re.fullmatch(r"[A-Za-z0-9_-]+", output_stem):
        raise ValueError("Use a simple filename stem without a path or extension.")
    _, doc, drawing = _drawing(expected_id)
    _, _, da = _api()
    check = inspect_drawing(expected_id)
    if not all(check[key] for key in ("is_iso", "is_mm", "is_first_angle")):
        raise RuntimeError("Native drawing must report ISO, millimeters and First Angle before export.")
    if doc.isModified:
        raise RuntimeError("Save native drawing changes before exporting the delivery PDF.")
    if not check["active_sheet"] or check["active_sheet"]["view_count"] == 0:
        raise RuntimeError("The current native sheet contains no drawing views.")
    OUTPUT.mkdir(parents=True, exist_ok=True)
    path = OUTPUT / f"{output_stem}.pdf"
    options = drawing.exportManager.createPDFExportOptions(str(path))
    if not options:
        raise RuntimeError("Fusion did not create PDF export options.")
    options.sheetsToExport = da.PDFSheetsExport.AllPDFSheetsExport
    options.openPDF = False
    options.useLineWeights = True
    if not drawing.exportManager.execute(options):
        raise RuntimeError("Fusion native Drawing PDF export failed.")
    if not path.is_file() or path.stat().st_size == 0:
        raise RuntimeError("Fusion reported success but the exported PDF is missing or empty.")
    data = path.read_bytes()
    if not data.startswith(b"%PDF-"):
        raise RuntimeError("Exported output is not a PDF file.")
    result = {
        "exported_at": _stamp(), "drawing": _identity(doc),
        "path": str(path), "bytes": len(data),
        "sha256": hashlib.sha256(data).hexdigest(),
        "source": "Fusion Drawing.exportManager; native drawing views and tables",
        "all_sheets_requested": True, "native_settings": check,
        "visual_qa": "pending_render_and_inspection_of_every_page",
    }
    _write(f"{output_stem}-export.json", result)
    return result
