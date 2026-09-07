# Native PrintReview drawing workflow

These helpers prepare **actual Fusion Drawing documents and Animation storyboards**. The earlier `rev04/views/exploded.png` and review PDF are visual reviews, not a native storyboard or associative drawing. None of the helpers execute when imported. Root must serialize every Fusion/UI operation with the geometry work.

## Execution order

1. Finish and save `Trimix_Enclosure_A3_PrintReview`; wait for its cloud DataFile to become complete. Record its DataFile ID/version. Preserve the validated A3 v3 baseline.
2. In Fusion's Drawing preferences, select **ISO, millimeters, First Angle**. Automatic API creation exposes ISO/mm/A3/landscape, but **does not expose a writable projection-angle setting**. Do this before creating projected views. Inspect the actual convention after creation; the export stage refuses Third Angle.
3. Import the modules from this directory through the root's existing serialized MCP dispatch. `drawing_native.inspect_source()` is read-only and returns exact component names, part numbers and occurrence paths. `drawing_animation.inspect()` is also read-only; it deliberately does not read the storyboard collection outside Animation because that accessor returned `InternalValidationError: assetRoot` in the active session.
4. Call `drawing_animation.prepare_clean_storyboard()`. In Animation UI, rename the new storyboard **PrintReview service exploded**. The API exposes creation but not a name setter. The helper leaves it at time zero with camera recording disabled. Its receipt says it is empty; it must not be counted as a finished exploded view yet.
5. Add native **Transform Components** actions in Animation UI at positive times. `set_playhead(seconds)` and `select_occurrences(exact_full_paths)` assist the UI without transforming Design occurrences. Use the finalized service groups/metadata from the updated PrintReview assembly. Keep purchased assemblies together, move screws separately, and retain inserts with their owning printed part. Show the verified service order; do not turn a separated presentation pose into an unsupported removal-path claim. Keep geometry clear of the cover in the final camera.
6. Verify time zero is assembled, the final time is exploded, and the timeline contains component-transform actions, not only camera actions. Save the source, reopen/inspect the named storyboard, and run `verify_named_storyboard()`. Its end-time check alone is not visual or service-path validation. Save before returning to drawing creation.
7. Activate the saved Design source. Call `drawing_native.create_assembly(include_animation=True)`. It requests native main-assembly isometric and orthographic sheets, a parts list on the isometric sheet, and Animation sheets. If automatic Animation layout fails or omits the desired storyboard, use **Drawing > From Animation** or **Create > Base View > Representation: Storyboard** to add it through UI.
8. `drawing_native.open_created("assembly")` opens the returned cloud drawing once processed. Inspect `inspect_drawing()` immediately. Rename the drawing in Fusion/Data panel to a clear assembly-drawing name if the automatic name needs improvement. Existing creation receipts prevent accidental duplicates after timeouts; inspect receipts/native documents before retrying a changed source version.
9. Finish the assembly drawing through Drawing UI: appropriate orthographic views; a battery/display section; a manifold section; identified cutting planes; overall body and fitting dimensions; native exploded base view; **Tables > Parts List** associated with that view; numbered balloons; a clear title block, revision and scale. All dimensions must originate from current model geometry. In first-angle projection the view arrangement must match the convention, including the symbol in the title block.
10. Create detail sheets only for the final fabricated components: activate the source and call `create_details([exact_component_names])`, then `open_created("details")`. The helper validates API name-omission rules against actual source names. It requests orthographic plus isometric views, initial overall dimensions and hole center marks. Review these automatically generated dimensions before adding manufacturing-critical dimensions, sections, hole/insert details and unresolved reference notes. Do not fabricate supplier tolerances or certify provisional interfaces.
11. For each active sheet, `configure_active_sheet(sheet_name=...)` sets A3 landscape and native table defaults. `tidy_active_sheet()` is an optional native layout operation that still needs visual review. The API does not expose full sheet enumeration, title-block editing, individual view placement, section/balloon creation or native parts-list row editing in this installed build; use the UI for those tasks.
12. Save through UI or `save_drawing()`. Immediately before the first PDF export, run the PDF skill's artifact-operation marker once for the planned PDF outputs. Then call `export_pdf("Trimix_A3_PrintReview_Assembly")` and, from the detail drawing, `export_pdf("Trimix_A3_PrintReview_Parts")`. The exported files go to `print-release/drawings/`; these are native Fusion Drawing exports, not generated screenshot pages.
13. Render **every exported page** with Poppler and inspect text, linework, sections, dimensions, balloons, table quantities, clipping and page boundaries. Check page sizes and text extraction using a PDF library. Record actual QA; the export receipt intentionally leaves visual QA pending. Save/reopen the native drawing and confirm its source association, then recheck the Design geometry/poses/joints remain unchanged.

## Associative list versus purchase roll-up

The native list follows actual Fusion component structure. The original A3 model contains visual subcomponents for purchased Guition/GCT/button assemblies and separate cell definitions. Its raw list cannot be called a purchasing BOM without reconciliation. Use the updated PrintReview assembly metadata supplied by root; do not infer one purchasable item per CAD body or merge different components merely by assigning identical part numbers. If a custom table is needed for the purchase roll-up, label it explicitly as maintained documentation, separate from the native associative assembly list. Check the real screw and insert quantities against the current inventory, rather than hardcoding historical counts.

## Known API boundaries

- Drawing creation: `adsk.drawing.DrawingManager`, July 2026 preview; current official documentation supports Automatic creation only, despite a Manual enum appearing in the installed stub.
- Drawing PDF export: `Drawing.exportManager.createPDFExportOptions()` and `execute()`; all-sheet export is supported.
- Projection: `DocumentSettings.projectionAngle` is read-only. The scripts verify First Angle instead of pretending to set it.
- Automatic parts lists are requested through `AssemblySheetPreferences.isPartsListIncluded`; their rows/balloons require UI inspection.
- `Drawing.activeSheet` and `Sheet.views` can be inspected; `Drawing.sheets` is absent from the inspected API. API inspection of one active sheet never proves the entire drawing is correct.
- Animation: `Design.animationManager`, `Storyboards.add`, activation, playhead and camera-recording controls exist. No public transform-action creation method was found. UI actions are required for a persistent exploded storyboard.
- Preview APIs are local authoring aids, not a stable distributed add-in interface.

## Primary references

- [DrawingManager API](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/DrawingManager.htm)
- [Create Automatic Drawing sample](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/CreateAutomaticDrawingSample_Sample.htm)
- [Storyboard API](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/Storyboard.htm)
- [Drawing from Animation](https://help.autodesk.com/cloudhelp/ENU/Fusion-Drawing/files/GUID-7B57F2B8-410C-464D-B27E-EE3F1B1F43FE.htm)
- [Create a native parts list](https://help.autodesk.com/cloudhelp/ENU/Fusion-Drawing/files/DWG-CREATE-PARTS-LIST.htm)
- Installed API definitions: `/Users/magnustrandokken/Library/Application Support/Autodesk/Autodesk Fusion 360/API/Python/defs/adsk/drawing.py`, `fusion.py`, `core.py`.

Status: preparation scripts only. Native creation, Animation actions, drawing layout and PDF QA are pending root execution.
