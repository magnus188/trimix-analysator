"""Guarded right-wall PCB-datum proposal; no operation runs on import.

preflight() is read-only. apply_reviewed(digest) is a prepared future mutation,
not invoked by the preparation workflow. It requires the exact reviewed manifest
SHA and saves no cloud document. The prior v7 remains available as a saved version.
A successful baseline retarget still needs the separate width/fit regression suite.
"""
from pathlib import Path
import hashlib
import json
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, report, BASE, GROUP, other_documents, bounds

MANIFEST = BASE/'verification/width-contract-proposal.json'
BODY_VOLUME_TOLERANCE_MM3 = 1e-5
BODY_LENGTH_TOLERANCE_MM = 1e-5


def _load():
    return json.loads(MANIFEST.read_text()), hashlib.sha256(MANIFEST.read_bytes()).hexdigest()


def _main(design):
    matches = [o for o in design.rootComponent.occurrences if o.component.partNumber == 'TMX-A3-B01']
    if len(matches) != 1:
        raise RuntimeError('Expected one owned main PCB wrapper')
    return matches[0]


def _children(design, parent):
    return [o for o in design.rootComponent.allOccurrences if o.fullPathName.startswith(parent.fullPathName+'+')]


def _guard():
    spec, digest = _load()
    app, doc, design = owned()
    source = spec['document_guard']
    if (doc.name, doc.dataFile.id, doc.isModified, design.timeline.count) != (
            source['name'], source['id'], source['modified'], source['timeline']):
        raise RuntimeError('Proposal requires the exact saved/unmodified v7 source; inspect before rebasing')
    for name, expression in spec['frozen_parameters'].items():
        parameter = design.userParameters.itemByName(name)
        if not parameter or parameter.expression != expression:
            raise RuntimeError('Frozen source parameter changed: '+name)
    errors = []
    for row in spec['parameter_changes']:
        parameter = design.allParameters.itemByName(row['name'])
        owner = getattr(parameter, 'createdBy', None) if parameter else None
        if not parameter or parameter.expression != row['expression'] or (owner.name if owner else None) != row['owner']:
            errors.append(row['name']+' identity/expression')
            continue
        if abs(design.unitsManager.evaluateExpression(row['new_expression'], 'mm')-parameter.value) > 1e-8:
            errors.append(row['name']+' would alter the85mm baseline')
    parent = _main(design)
    if parent.fullPathName != spec['main_wrapper']['name'] or max(abs(a-b) for a,b in zip(
            parent.transform2.asArray(), spec['main_wrapper']['expected_transform'])) > 1e-8:
        errors.append('Main wrapper registration')
    source_step = parent.component.attributes.itemByName(GROUP, 'source_step_sha256')
    if not source_step or source_step.value != spec['main_step_sha256']:
        errors.append('Installed main STEP identity')
    if any((j.occurrenceOne and j.occurrenceOne.fullPathName == parent.fullPathName) or
           (j.occurrenceTwo and j.occurrenceTwo.fullPathName == parent.fullPathName)
           for j in design.rootComponent.joints):
        errors.append('Main wrapper gained an unexpected joint')
    occurrences = {o.fullPathName: o for o in design.rootComponent.occurrences}
    for row in spec['hardware_bindings']:
        occurrence = occurrences.get(row['occurrence'])
        attribute = occurrence.attributes.itemByName('TrimixRev04','position_expressions') if occurrence else None
        if not attribute or json.loads(attribute.value) != row['expected_position_expressions']:
            errors.append(row['instance_label']+' position expressions')
        if occurrence and max(abs(a-b) for a,b in zip(occurrence.transform2.asArray(), row['expected_transform'])) > 1e-8:
            errors.append(row['instance_label']+' current pose')
    if errors:
        raise RuntimeError('Width proposal guard failed: '+json.dumps(errors))
    return app, doc, design, spec, digest


def preflight():
    """Verify every proposed edit numerically, without changing Fusion state."""
    app, doc, design, spec, digest = _guard()
    protected = other_documents(app)
    parent = _main(design)
    descendants = [{'path': o.fullPathName, 'local_transform': (o.nativeObject or o).transform2.asArray(),
                    'ground_to_parent': (o.nativeObject or o).isGroundToParent,
                    'solid_count': sum(body.isSolid for body in o.bRepBodies)}
                   for o in _children(design, parent)]
    if not descendants:
        raise RuntimeError('Main imported descendants are missing')
    configure()
    import review_checks
    manager, records = review_checks.records()
    physical = [r for r in records if r['physical_group'] != 'alternative_oxygen_reference']
    rows = [{'key': [r['occurrence'],r['name']], 'bounds_mm': bounds(r['body']),
             'volume_mm3': r['body'].volume*1000, 'faces': r['body'].faces.count,
             'edges': r['body'].edges.count} for r in physical]
    if other_documents(app) != protected or doc.isModified or design.timeline.count != spec['document_guard']['timeline']:
        raise RuntimeError('Read-only preparation changed document state')
    report('width-contract-preflight.json', {'status': 'PREPARED_NOT_APPLIED',
        'document': doc.name, 'manifest_sha256': digest, 'exact_parameter_edits': len(spec['parameter_changes']),
        'all_new_expressions_preserve_baseline_value': True, 'hardware_instances': len(spec['hardware_bindings']),
        'main_descendants': descendants, 'physical_bodies': rows,
        'baseline_total_physical_volume_mm3': sum(r['volume_mm3'] for r in rows),
        'health': review_checks.health(design), 'protected_documents_before_after': protected,
        'cloud_saved': False, 'persistent_geometry_modified': False})


def _snapshots():
    import review_checks
    manager, rows = review_checks.records()
    records = {}
    for row in rows:
        if row['physical_group'] == 'alternative_oxygen_reference':
            continue
        key = row['occurrence']+'/'+row['name']
        if key in records:
            raise RuntimeError('Nonunique physical body identity: '+key)
        records[key] = row
    return manager, records


def compare_physical(before, after, manager):
    """Compare every actual placed solid using volume, pose and both Boolean residuals."""
    if set(before) != set(after):
        raise RuntimeError('Physical body identities/count changed')
    result = []
    for key in sorted(before):
        one, two = before[key]['body'], after[key]['body']
        volume_error = abs(one.volume-two.volume)*1000
        position_error = max(abs(a-b) for aa,bb in zip(bounds(one), bounds(two)) for a,b in zip(aa,bb))
        residuals = []
        for source, subtract in ((one,two),(two,one)):
            target, tool = manager.copy(source), manager.copy(subtract)
            if target is None or tool is None or not manager.booleanOperation(target,tool,fusion.BooleanTypes.DifferenceBooleanType):
                raise RuntimeError('Baseline Boolean comparison failed: '+key)
            residuals.append(target.volume*1000 if target.faces.count else 0.0)
        passed = (volume_error <= BODY_VOLUME_TOLERANCE_MM3 and
                  position_error <= BODY_LENGTH_TOLERANCE_MM and
                  max(residuals) <= BODY_VOLUME_TOLERANCE_MM3)
        result.append({'body':key,'volume_error_mm3':volume_error,'max_bound_error_mm':position_error,
                       'bilateral_boolean_residuals_mm3':residuals,'pass':passed})
    return {'pass': all(row['pass'] for row in result), 'bodies':result,
            'scope':'Actual placed physical solids; alternative JJ reference is tested separately, not co-installed.'}


def apply_reviewed(approved_manifest_sha256):
    """Future reviewed mutation. Does not change width, import a PCB, or save a document."""
    app, doc, design, spec, digest = _guard()
    if approved_manifest_sha256 != digest:
        raise RuntimeError('Exact manifest review digest is required')
    configure()
    import review_checks
    protected = other_documents(app)
    manager, before = _snapshots()
    parent = _main(design)
    children = _children(design, parent)
    child_poses = {o.fullPathName: (o.nativeObject or o).transform2.asArray() for o in children}
    report('width-contract-apply-started.json', {'status':'mutation_started_after_manifest_review',
        'manifest_sha256':digest,'source_document':doc.name,'source_timeline':design.timeline.count,
        'protected_documents':protected,'warning':'If the call fails, inspect actual state; do not assume rollback.'})
    # Manifest deliberately fixes physical PcbWidth first to avoid a temporary cycle.
    for row in spec['parameter_changes']:
        design.allParameters.itemByName(row['name']).expression = row['new_expression']
    occurrences = {o.fullPathName:o for o in design.rootComponent.occurrences}
    for row in spec['hardware_bindings']:
        occurrence = occurrences[row['occurrence']]
        occurrence.attributes.itemByName('TrimixRev04','position_expressions').value = json.dumps(row['new_position_expressions'])
        occurrence.attributes.add(GROUP,'position_metadata_basis',
            'position_expressions and native joint origins are authoritative; hardware_position_mm is the preserved85mm installation snapshot.')
    grounded = []
    for occurrence in children:
        local = occurrence.nativeObject or occurrence
        if not local.isGroundToParent:
            local.isGroundToParent = True
            grounded.append(occurrence.fullPathName)
    root = design.rootComponent
    target = root.jointOrigins.createInput(fusion.JointGeometry.createByPoint(root.originConstructionPoint))
    values = spec['main_wrapper']['new_position_expressions']
    target.offsetX = core.ValueInput.createByString(values[0])
    target.offsetY = core.ValueInput.createByString(values[1])
    target.offsetZ = core.ValueInput.createByString(values[2])
    origin = root.jointOrigins.add(target)
    origin.name = spec['main_wrapper']['new_origin_name']
    source = fusion.JointGeometry.createByPoint(parent.component.originConstructionPoint.createForAssemblyContext(parent))
    request = root.joints.createInput(source,origin)
    request.setAsRigidJointMotion()
    request.isFlipped = False
    joint = root.joints.add(request)
    joint.name = spec['main_wrapper']['new_joint_name']
    origin.isLightBulbOn = False
    joint.isLightBulbOn = False
    if not design.computeAll():
        raise RuntimeError('Width datum recompute failed')
    for occurrence in _children(design,parent):
        local = occurrence.nativeObject or occurrence
        if not local.isGroundToParent or max(abs(a-b) for a,b in zip(
                local.transform2.asArray(),child_poses[occurrence.fullPathName])) > 1e-8:
            raise RuntimeError('Imported PCB local pose or rigidity changed: '+occurrence.fullPathName)
    _, after = _snapshots()
    comparison = compare_physical(before,after,manager)
    health = review_checks.health(design)
    if not comparison['pass'] or not health['pass'] or other_documents(app) != protected:
        raise RuntimeError('Baseline retarget failed physical/health/protected-document invariant')
    parent.attributes.add(GROUP,'board_datum_joint',joint.name)
    parent.attributes.add(GROUP,'position_expressions',json.dumps(values))
    parent.component.attributes.add(GROUP,'pcb_width_datum_contract',
        'Rigid30mm PCB, right setback4.6mm, X=PcbX; local hole centres25.6/4.4. Baseline85mm archive metadata is historical; current joint is authoritative.')
    root.attributes.add(GROUP,'width_contract_manifest_sha256',digest)
    report('width-contract-baseline-applied.json', {'status':'baseline_retargeted_width_trials_pending',
        'manifest_sha256':digest,'parameter_edits':spec['parameter_changes'],'hardware_bindings':spec['hardware_bindings'],
        'new_joint':joint.name,'grounded_descendants':grounded,'child_local_poses_preserved':True,
        'all_physical_baseline_comparison':comparison,'health':health,'other_documents_preserved':protected,
        'saved':False,'purchased_geometry_scaled':False,'final_routed_PCB_integrated':False})
