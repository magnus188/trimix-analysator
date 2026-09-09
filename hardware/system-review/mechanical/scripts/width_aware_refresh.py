"""Prepared future PCB refresh preserving the reviewed width datum joint.

No operation runs on import. This stage is not used by the width trials, and
must wait for the PCB owner's next immutable geometry/height contract. The
legacy importer retires only STEP descendants; this wrapper forbids a wrapper
pose or joint change and retains all existing stack-thickness guards.
"""
import json
import hashlib
from pathlib import Path
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, GROUP, report, BASE, ROOT


def _bundle_preflight():
    """Require source-hashed coverage and unit-aware datums before any retirement."""
    path=BASE/'verification/incoming-boards.json'
    manifest=json.loads(path.read_text());spec=manifest['main'];captured={path:hashlib.sha256(path.read_bytes()).hexdigest()}
    for filename,digest in (('file','sha256'),('height_contract_file','height_contract_sha256'),
                           ('checkpoint_file','checkpoint_sha256'),('coverage_file','coverage_sha256'),
                           ('datum_receipt_file','datum_receipt_sha256')):
        source=Path(spec[filename]);actual=hashlib.sha256(source.read_bytes()).hexdigest()
        if actual!=spec[digest]:raise RuntimeError('Frozen main bundle hash mismatch '+filename)
        captured[source]=actual
    checkpoint=json.loads(Path(spec['checkpoint_file']).read_text())
    for relative,digest in checkpoint['files'].items():
        source=ROOT/relative;actual=hashlib.sha256(source.read_bytes()).hexdigest()
        if actual!=digest:raise RuntimeError('Frozen checkpoint member changed '+relative)
        captured[source]=actual
    boards=[ROOT/k for k in checkpoint['files'] if k.endswith('.kicad_pcb')]
    if len(boards)!=1 or captured[boards[0]]!=spec['board_sha256']:
        raise RuntimeError('Exactly one source-bound main PCB is required')
    for key in ('file','height_contract_file'):
        if Path(spec[key]) not in [ROOT/k for k in checkpoint['files']]:
            raise RuntimeError('Main STEP/height JSON must belong to the same immutable checkpoint')
    contract=json.loads(Path(spec['height_contract_file']).read_text())
    if contract['board_sha256']!=spec['board_sha256']:raise RuntimeError('Height/board source identity mismatch')
    coverage=json.loads(Path(spec['coverage_file']).read_text())
    if coverage['status']!='source_coverage_and_pose_pass' or coverage['checkpoint_sha256']!=spec['checkpoint_sha256'] or coverage['errors']:
        raise RuntimeError('Matching native reference/pose/MPN/side/DNP height coverage is required')
    if any('MPN' not in row for row in coverage['rows'] if row['classification'] in ('DNP_excluded','populated_maximum_or_allocation')):
        raise RuntimeError('Re-run the strengthened MPN-aware coverage checker')
    datum=json.loads(Path(spec['datum_receipt_file']).read_text())
    measured=datum['sources']['main']
    if not datum['source_preserved'] or measured['source_sha256']!=spec['sha256']:
        raise RuntimeError('Matching unit-aware temporary STEP datum measurement is required')
    expected=[[0,-99,0],[30,0,1.4942]]
    if max(abs(a-b) for pair,want in zip(measured['substrate']['bounds_mm'],expected) for a,b in zip(pair,want))>1e-4:
        raise RuntimeError('Incoming main substrate local origin/outline/stack changed; review before retirement')
    if abs(measured['proposed_centre_aligned_translation_Z_mm']-20.5529)>1e-4:
        raise RuntimeError('Incoming STEP needs a separately reviewed stack datum change')
    for expected_xy in ((25.6,-92),(4.4,-6)):
        if not any(abs(h['radius_mm']-1.15)<1e-4 and max(abs(a-b) for a,b in zip(h['axis_XY_mm'],expected_xy))<1e-4
                   for h in measured['substrate_cylindrical_axes']):
            raise RuntimeError('Incoming STEP M2 NPTH axis/diameter changed; inspect before retiring current PCB')
    return captured


def _main_joint(design, wrapper):
    origins=[o for o in design.rootComponent.jointOrigins
             if o.name=='SystemReview main PCB stack datum']
    joints=[j for j in design.rootComponent.joints
            if j.name=='SystemReview main PCB parametric placement']
    if len(origins)!=1 or len(joints)!=1:
        raise RuntimeError('Expected the reviewed main PCB origin and rigid joint')
    origin,joint=origins[0],joints[0]
    if joint.isSuppressed or joint.healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState:
        raise RuntimeError('Reviewed PCB joint is suppressed or unhealthy')
    attached=[o.fullPathName for o in (joint.occurrenceOne,joint.occurrenceTwo) if o]
    if wrapper.fullPathName not in attached:
        raise RuntimeError('Named PCB joint does not constrain this wrapper')
    expressions=[origin.offsetX.expression,origin.offsetY.expression,origin.offsetZ.expression]
    if expressions!=['PcbX','PcbY + PcbHeight','PcbZ + 0.0529 mm']:
        raise RuntimeError('Main stack datum changed; review the source before import')
    return {'origin_name':origin.name,'joint_name':joint.name,
            'origin_token':origin.entityToken,'joint_token':joint.entityToken,
            'expressions':expressions,'attached_occurrences':attached}


def main():
    """Future main-only refresh at its evaluated rigid datum; does not save."""
    captured=_bundle_preflight()
    configure()
    import refresh_boards as legacy
    from width_contract_checks import datums
    from width_contract_proposal import _load,_main
    _,_,design=owned();root=design.rootComponent
    _,digest=_load();marker=root.attributes.itemByName(GROUP,'width_contract_manifest_sha256')
    if not marker or marker.value!=digest:
        raise RuntimeError('Reviewed width contract marker missing')
    parent=_main(design);datum=datums();joint_before=_main_joint(design,parent)
    expected=core.Matrix3D.create()
    expected.translation=core.Vector3D.create(*(x/10 for x in datum['main_pose']))
    before=parent.transform2.asArray()
    if max(abs(a-b) for a,b in zip(before,expected.asArray()))>1e-7:
        raise RuntimeError('Actual main wrapper matrix does not match the width datum')
    prior=legacy.EXPECTED['main']
    legacy.EXPECTED['main']={
        **prior,'translation_mm':datum['main_pose'],
        'allowed_current_translations_mm':[datum['main_pose']],
        'new_translation_mm':datum['main_pose']}
    try:
        legacy._run('main')
    finally:
        legacy.EXPECTED['main']=prior
    after=_main_joint(design,parent)
    # Autodesk tokens may change their string representation for the same
    # entity; resolve tokens rather than comparing token strings as identities.
    # Fusion Python wrappers compare unequal even for repeated resolution of
    # the identical entity token (native read-only experiment retained). Resolve
    # both stored tokens now, require unique typed entities and compare their
    # current canonical tokens plus timeline identity. No name-only fallback.
    resolved_identity={}
    for key in ('origin_token','joint_token'):
        left=design.findEntityByToken(joint_before[key]);right=design.findEntityByToken(after[key])
        valid=len(left)==len(right)==1
        detail={'old_token_resolution_count':len(left),'new_token_resolution_count':len(right)}
        if valid:
            one,two=left[0],right[0]
            detail.update(old_resolution_current_token=one.entityToken,new_resolution_current_token=two.entityToken,
                old_type=one.objectType,new_type=two.objectType,
                old_timeline_index=one.timelineObject.index,new_timeline_index=two.timelineObject.index)
            valid=(one.entityToken==two.entityToken and one.objectType==two.objectType and
                   one.timelineObject.index==two.timelineObject.index)
        detail['same_unique_current_entity']=valid;resolved_identity[key]=detail
    same_entities=all(r['same_unique_current_entity']for r in resolved_identity.values())
    fields=('origin_name','joint_name','expressions','attached_occurrences')
    if not same_entities or any(after[k]!=joint_before[k] for k in fields) or max(abs(a-b) for a,b in zip(parent.transform2.asArray(),before))>1e-7:
        raise RuntimeError('Future import changed the reviewed main joint or pose; inspect native state')
    descendants=[o for o in root.allOccurrences if o.fullPathName.startswith(parent.fullPathName+'+')]
    if not descendants or any(not(o.nativeObject or o).isGroundToParent for o in descendants):
        raise RuntimeError('Future imported descendants are not all rigidly grounded')
    if any(hashlib.sha256(path.read_bytes()).hexdigest()!=digest for path,digest in captured.items()):
        raise RuntimeError('Immutable source bundle changed while importing; inspect native state')
    report('pcb-refresh-main-width-contract.json',{
        'status':'imported_at_reviewed_datum_fresh_geometry_checks_required',
        'manifest_sha256':digest,'joint_preserved':after,'registration_mm':datum['main_pose'],
        'grounded_descendants':len(descendants),'purchased_geometry_scaled':False,
        'resolved_joint_identity':resolved_identity,
        'saved':False,'final_routed_release':False,
        'required_followup':'Run width-aware maximum, service, thickness and physical checks on the new immutable height contract.'})
