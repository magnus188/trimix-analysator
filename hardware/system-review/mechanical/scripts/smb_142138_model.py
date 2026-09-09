"""Build a datum-correct, drawing-derived SMB reference in an isolated document.

The source does not specify a complete mating profile. The detailed STEP is a
visual/mounting reconstruction, while a separate upper-envelope STEP supports
conservative nominal occupied-space checks. Neither qualifies the owned cable.
"""
from pathlib import Path
import hashlib
import json
import sys
import zipfile

import adsk
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, BASE, ROOT, other_documents, report

sys.path.insert(0, str(ROOT / 'hardware/cad/scripts'))
import fusion_helpers as h

OUT = BASE / 'components'
STEM = 'Amphenol_RF_142138_Drawing_Reconstruction'
GROUP = 'Trimix142138'


def _sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _box(c, name, x, y, width, height, z, depth, op='new'):
    s = h.rectangle_xy(c, name + ' profile', x, y, width, height, z)
    return h.extrude(c, s, depth, name, op)


def _cyl(c, name, radius, z, length, op='new', bodies=None):
    s = h.circle_xy(c, name + ' profile', '0 mm', '0 mm', radius, z)
    return h.extrude(c, s, length, name, op, bodies)


def _build(design, app):
    design.unitsManager.distanceDisplayUnits = fusion.DistanceUnits.MillimeterDistanceUnits
    root = design.rootComponent
    parameters = {
        'BaseSide': ('7 mm', 'Rev B: square base side.'),
        'OverallLength': ('11.5 mm', 'Rev B: nose to tail tip.'),
        'TailProjection': ('3.9 mm', 'Rev B: PCB seating plane to tail tip.'),
        'BarrelLength': ('5.8 mm', 'Rev B: front base face to nose.'),
        'BaseThickness': ('OverallLength-TailProjection-BarrelLength', 'Derived, not independently toleranced: 1.8 mm.'),
        'AbovePCB': ('OverallLength-TailProjection', 'Derived nominal above-PCB height: 7.6 mm.'),
        'ShellPitch': ('5.08 mm', 'Rev B: square shell-leg centre pitch.'),
        'ShellLegSide': ('1.02 mm', 'Rev B: four square shell legs.'),
        'SignalTailDiameter': ('0.96 mm', 'Rev B: signal solder tail diameter.'),
        'BarrelReferenceDiameter': ('3.7084 mm', 'REFERENCE ONLY. Generic SMB interface maximum, extended as a simplified visual barrel; complete 142138 profile is undimensioned.'),
        'BoreReferenceDiameter': ('2.0828 mm', 'REFERENCE ONLY. Generic SMB interface minimum; axial bore extent is unverified.'),
        'MatingPinReferenceDiameter': ('0.508 mm', 'REFERENCE ONLY. Midpoint of generic SMB .019-.021 inch pin range.'),
        'MatingPinReferenceTop': ('6.9 mm', 'REFERENCE ONLY. Pin projection not dimensioned by Rev B; not a mating/clearance datum.'),
        'InsulatorReferenceTop': ('5.8 mm', 'REFERENCE ONLY. Internal PTFE extent not dimensioned by Rev B.'),
    }
    for name, (expression, comment) in parameters.items():
        design.userParameters.add(name, core.ValueInput.createByString(expression), 'mm', comment)
    c = h.new_component(root, 'Amphenol RF 142138 - drawing reconstruction; mating details reference')
    c.partNumber = '142138'
    c.description = 'Manufacturer Rev B mounting dimensions; no scaled SMA. Undimensioned mating barrel/internal details are visual references. See provenance JSON.'
    c.attributes.add(GROUP, 'origin', 'PCB top/seating plane Z=0; centre pin X=Y=0; nose +Z; tails -Z; mm; scale 1.')
    shell = _box(c, '7 mm square base', '-BaseSide/2', '-BaseSide/2', 'BaseSide', 'BaseSide', '0 mm', 'BaseThickness').bodies.item(0)
    for sx in (-1, 1):
        for sy in (-1, 1):
            _box(c, 'Drawing square shell leg %s %s' % (sx, sy),
                 '%s*ShellPitch/2-ShellLegSide/2' % sx, '%s*ShellPitch/2-ShellLegSide/2' % sy,
                 'ShellLegSide', 'ShellLegSide', '-TailProjection', 'TailProjection', 'join')
    _cyl(c, 'Simplified reference barrel - full profile unverified', 'BarrelReferenceDiameter/2', 'BaseThickness', 'BarrelLength', 'join')
    _cyl(c, 'Reference insulator bore - undimensioned depth', 'BoreReferenceDiameter/2', '0 mm', 'AbovePCB', 'cut', [shell])
    shell.name = 'Brass shell and four 1.02 mm square tails - barrel profile reference'
    pin = _cyl(c, 'Drawing diameter 0.96 signal solder tail', 'SignalTailDiameter/2', '-TailProjection', 'TailProjection+BaseThickness').bodies.item(0)
    _cyl(c, 'Reference mating pin - projection unverified', 'MatingPinReferenceDiameter/2', 'BaseThickness', 'MatingPinReferenceTop-BaseThickness', 'join')
    pin.name = 'Signal contact - exact solder tail; mating end reference'
    insulator = _cyl(c, 'Reference natural PTFE insulator', '(BoreReferenceDiameter-0.01 mm)/2', '0 mm', 'InsulatorReferenceTop').bodies.item(0)
    _cyl(c, 'Reference insulator centre relief', '(SignalTailDiameter+0.01 mm)/2', '0 mm', 'InsulatorReferenceTop', 'cut', [insulator])
    insulator.name = 'PTFE insulator reference - internal dimensions unverified'
    appearances = app.materialLibraries.itemByName('Fusion Appearance Library')
    if not appearances:
        raise RuntimeError('Fusion Appearance Library unavailable')
    gold = design.appearances.addByCopy(appearances.appearances.itemById('Prism-040'), 'Gold-finished brass visual reference')
    natural = design.appearances.addByCopy(appearances.appearances.itemById('Prism-116'), 'Natural PTFE visual reference')
    shell.appearance = gold
    pin.appearance = gold
    insulator.appearance = natural
    shell.attributes.add(GROUP, 'material_source', 'Brass, gold finish per Rev B; appearance only; no plating thickness or mass qualification.')
    pin.attributes.add(GROUP, 'material_source', 'Brass, gold finish per Rev B; appearance only; no plating thickness or mass qualification.')
    insulator.attributes.add(GROUP, 'material_source', 'PTFE natural per Rev B; internal geometry reference; no material-property/mass qualification.')
    envelope = h.new_component(root, '142138 nominal upper occupied-space envelope - no mating geometry')
    envelope.partNumber = 'REF-142138-UPPER-ENVELOPE'
    envelope.description = '7 x 7 x 7.6 mm conservative nominal upper envelope within the drawing base footprint; excludes tolerances, mated cable and solder tails.'
    envelope_body = _box(envelope, 'Nominal 7 x 7 x 7.6 upper envelope', '-BaseSide/2', '-BaseSide/2', 'BaseSide', 'BaseSide', '0 mm', 'AbovePCB').bodies.item(0)
    envelope_body.name = 'Reference upper envelope - nominal dimensions only'
    for comp in design.allComponents:
        comp.isOriginFolderLightBulbOn = False
        for item in list(comp.sketches) + list(comp.constructionPlanes):
            item.isLightBulbOn = False
    root.occurrences.itemByName(envelope.name + ':1').isLightBulbOn = False
    design.computeAll()
    problems = []
    for comp in design.allComponents:
        problems += ['underconstrained ' + s.name for s in comp.sketches if not s.isFullyConstrained]
        problems += [f.name + ': ' + f.errorOrWarningMessage for f in comp.features if f.healthState != fusion.FeatureHealthStates.HealthyFeatureHealthState]
    if problems:
        raise RuntimeError(json.dumps(problems))
    if c.bRepBodies.count != 3 or envelope.bRepBodies.count != 1:
        raise RuntimeError('Expected three physical reference bodies and one separate envelope')
    return c, envelope


def _capture(app, path):
    camera = app.activeViewport.camera
    camera.cameraType = core.CameraTypes.OrthographicCameraType
    camera.target = core.Point3D.create(0, 0, .15)
    camera.eye = core.Point3D.create(2.5, -3, 2.8)
    camera.upVector = core.Vector3D.create(0, 0, 1)
    camera.isFitView = True
    camera.isSmoothTransition = False
    app.activeViewport.camera = camera
    adsk.doEvents()
    app.activeViewport.refresh()
    options = core.SaveImageFileOptions.create(str(path))
    options.width = 1400
    options.height = 1400
    options.isAntiAliased = True
    if not app.activeViewport.saveAsImageFileWithOptions(options):
        raise RuntimeError('Native diagnostic image export failed')


def build():
    """Export STEP/F3D and validate a unit-aware STEP reimport; close owned temps."""
    app, original, native = owned()
    configure()
    import audit_a3 as audit
    import step_a3 as step
    before = audit._bodies(native)
    poses = step._poses(native)
    timeline = native.timeline.count
    protected = other_documents(app)
    original_modified = original.isModified
    camera = app.activeViewport.camera
    temporary = None
    imported_doc = None
    result = None
    OUT.mkdir(parents=True, exist_ok=True)
    step_path = OUT / (STEM + '.step')
    envelope_path = OUT / 'Amphenol_RF_142138_Nominal_Upper_Envelope.step'
    native_path = OUT / (STEM + '.f3d')
    try:
        temporary = app.documents.add(core.DocumentTypes.FusionDesignDocumentType)
        design = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        design.designType = fusion.DesignTypes.ParametricDesignType
        c, envelope = _build(design, app)
        accuracy = fusion.CalculationAccuracy.VeryHighCalculationAccuracy
        records = step._accurate_bodies(design, accuracy)
        expected = [r for r in records if r['component'] == c.name]
        if not design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(step_path), c)):
            raise RuntimeError('142138 STEP export failed')
        for occurrence in design.rootComponent.occurrences:
            if occurrence.component == envelope:
                occurrence.isLightBulbOn = True
        if not design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(envelope_path), envelope)):
            raise RuntimeError('142138 envelope STEP export failed')
        for occurrence in design.rootComponent.occurrences:
            if occurrence.component == envelope:
                occurrence.isLightBulbOn = False
        _capture(app, OUT / (STEM + '.png'))
        if not design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native_path))):
            raise RuntimeError('142138 native archive export failed')
        with zipfile.ZipFile(native_path) as archive:
            if archive.testzip():
                raise RuntimeError('142138 native archive CRC failed')
        options = app.importManager.createSTEPImportOptions(str(step_path))
        options.isViewFit = False
        imported_doc = app.importManager.importToNewDocument(options)
        if not imported_doc or imported_doc.isSaved:
            raise RuntimeError('Expected isolated unsaved STEP check')
        imported = fusion.Design.cast(imported_doc.products.itemByProductType('DesignProductType'))
        actual = step._accurate_bodies(imported, accuracy)
        comparison = step._compare(step._summary(actual), step._summary(expected))
        result = {
            'status': 'pass' if comparison['pass'] else 'numerical_or_geometry_exception',
            'geometry_kind': 'Drawing-derived nominal mounting reconstruction; undimensioned mating details reference-only; not manufacturer CAD.',
            'origin': {'x_y': 'Centre signal tail / footprint pad 1', 'z_mm': 0, 'z_plane': 'PCB top / connector seating plane', 'nose_direction': '+Z', 'tail_direction': '-Z', 'scale_xyz': [1, 1, 1], 'rotation_xyz_deg': [0, 0, 0]},
            'files': {k: {'file': str(p), 'bytes': p.stat().st_size, 'sha256': _sha(p)} for k, p in [('step', step_path), ('upper_envelope_step', envelope_path), ('native', native_path)]},
            'native_summary': step._summary(expected), 'imported_summary': step._summary(actual),
            'roundtrip': comparison, 'native_bodies': expected,
            'parameters': {p.name: {'expression': p.expression, 'value_mm': p.value*10, 'comment': p.comment} for p in design.userParameters},
            'source': {'part': 'Amphenol RF 142138', 'revision': 'B', 'date': '2011-11-21', 'drawing': str(ROOT/'hardware/system-review/electrical/smb-research/amphenol-142138-drawing.pdf'), 'sha256': '2f7ac0a3c7bd072ff08ca070da6b44f3e991bbaa37e3fb885ed243e78c261c9c', 'manufacturer_url': 'https://www.amphenolrf.com/en-us/part/142138/883/', 'drawing_mirror': 'https://assets.testequity.com/te1/Documents/pdf/amphenol/amphenol_142138-connector_customer-drawing.pdf', 'generic_interface': 'https://www.amphenolrf.com/en-us/assets/file/4067456646/', 'manufacturer_step': 'https://www.amphenolrf.com/en-us/assets/file/4066922863/', 'manufacturer_step_status': 'Public listing found; file download HTTP 403; not obtained.'},
            'limitations': [
                'Barrel OD, snap groove, shoulders, bore registration, PTFE shape and mating pin projection are not dimensioned by the product drawing. Simplified visual geometry is explicitly reference-only; it cannot qualify mating clearance.',
                'The nominal upper envelope contains the body footprint and full nominal above-PCB height. It excludes manufacturing tolerances, mated cable/elbow and wire bends.',
                'Undimensioned underside base recess and lead chamfers are omitted conservatively; 1.02 square shell tails and 0.96 centre tail retain exact drawing nominal sizes.',
                'Derived 7.6 mm above-PCB and 1.8 mm base thickness are nominal differences, not separately toleranced dimensions.',
                'Existing J402 board pose, footprint and nets are not edited. Shell remains O2_B_RAW_N, not chassis or ground.',
                'No exact owned cable identity, seating force, mated envelope, solder allowance, plating thickness, mass or manufacturing fit is qualified.'
            ],
        }
        if not comparison['pass']:
            raise RuntimeError('142138 STEP roundtrip mismatch: ' + json.dumps(comparison))
    finally:
        try:
            try:
                if imported_doc and not imported_doc.close(False):
                    raise RuntimeError('Could not close own STEP check document')
            finally:
                if temporary and not temporary.close(False):
                    raise RuntimeError('Could not close own 142138 build document')
        finally:
            if not original.activate():
                raise RuntimeError('Could not reactivate SystemReview')
            app.activeViewport.camera = camera
            adsk.doEvents()
            app.activeViewport.refresh()
        preserved = {'geometry': audit._bodies(native) == before, 'poses': step._poses(native) == poses,
                     'timeline': native.timeline.count == timeline, 'modified_flag': original.isModified == original_modified,
                     'other_documents': other_documents(app) == protected, 'reactivated': app.activeDocument == original}
        if result:
            result['source_preservation'] = preserved
            (OUT / (STEM + '.json')).write_text(json.dumps(result, indent=2) + '\n')
            report('smb-142138-model.json', result)
        if not all(preserved.values()):
            raise RuntimeError('142138 export did not preserve source/document state: ' + json.dumps(preserved))
    return result
