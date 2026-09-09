"""Replace only an owned PCB wrapper's STEP children using an explicit manifest.

Prepare verification/incoming-boards.json from the PCB owner's delivered paths
and SHA-256 values. Geometry is never resized to fit. The wrapper XY transform is preserved and any reviewed stack-dependent Z datum
correction is explicit; every imported descendant is rigidly grounded to its parent. This
stage must run inside the official fusion_mcp_execute script feature transaction.
If a call fails, inspect its actual resulting state; do not assume every metadata
or model operation rolled back. It is not a standalone file-invocation API.
The stage establishes source identity and stack datum, then requires fresh BRep fit
checks. It does not approve fabrication, nets, assembly or physical fit.
"""
import hashlib,json
from pathlib import Path
import adsk
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned,configure,report,bounds,BASE,GROUP,other_documents

IDS={'main':'TMX-A3-B01','usb':'TMX-A3-B02'}
EXPECTED={'main':{'core_mm':1.4942,'translation_mm':[50.4,120,20.545],
                  'allowed_current_translations_mm':[[50.4,120,20.545],[50.4,120,20.5529]],
                  'new_translation_mm':[50.4,120,20.5529],'nominal_stack_mm':[20.5,22.1]},
          'usb':{'core_mm':.51,'translation_mm':[34.5,18,24.945],'nominal_stack_mm':[24.9,25.5]}}


def _run(key):
    app,doc,d=owned();configure();root=d.rootComponent
    manifest=json.loads((BASE/'verification/incoming-boards.json').read_text())
    spec=manifest[key];path=Path(spec['file']);source_hash=hashlib.sha256(path.read_bytes()).hexdigest()
    if source_hash!=spec['sha256']:raise RuntimeError('Incoming STEP SHA mismatch')
    matches=[o for o in root.occurrences if o.component.partNumber==IDS[key]]
    if len(matches)!=1:raise RuntimeError('Expected unique PCB wrapper '+key)
    parent=matches[0];component=parent.component;before_transform=parent.transform2.asArray()
    expected=EXPECTED[key]
    translation=[v*10 for v in parent.transform2.translation.asArray()]
    allowed=expected.get('allowed_current_translations_mm',[expected['translation_mm']])
    if not any(max(abs(a-b)for a,b in zip(translation,pose))<=1e-5 for pose in allowed):
        raise RuntimeError('Unexpected current PCB transform; inspect actual stack datums before replacement')
    prior=component.attributes.itemByName(GROUP,'source_step_sha256') or component.attributes.itemByName('TrimixPcbFit','source_step_sha256')
    old_hash=prior.value if prior else None
    if source_hash==old_hash:raise RuntimeError('Incoming STEP already installed')
    other_before=other_documents(app);retired=[]
    report('pcb-refresh-'+key+'-preflight.json',{'document':doc.name,'document_id':doc.dataFile.id,
        'source_file':str(path),'incoming_sha256':source_hash,'installed_sha256':old_hash,
        'current_wrapper_transform':before_transform,'current_translation_mm':translation,
        'allowed_current_translations_mm':allowed,'timeline_before':d.timeline.count,
        'other_documents_before':other_before,'persistent_model_mutation_started':False})
    for child in list(component.occurrences):
        retired.append(child.fullPathName)
        feature=component.features.removeFeatures.add(child)
        if not feature:raise RuntimeError('Could not retire old STEP child')
        feature.name='SystemReview replace '+key+' PCB STEP child'
    options=app.importManager.createSTEPImportOptions(str(path))
    if not app.importManager.importToTarget(options,component):raise RuntimeError('STEP import failed')
    # Ground child definitions at their imported local positions. Mixed grounded
    # and free descendants otherwise do not follow a moving assembly wrapper.
    grounded=[]
    for occurrence in root.allOccurrences:
        if not occurrence.fullPathName.startswith(parent.fullPathName+'+'):continue
        local=occurrence.nativeObject or occurrence
        if not local.isGroundToParent:
            local.isGroundToParent=True;grounded.append(occurrence.fullPathName)
    if not d.computeAll():raise RuntimeError('Refreshed PCB recompute failed')
    adsk.doEvents();app.activeViewport.refresh()
    if parent.transform2.asArray()!=before_transform:raise RuntimeError('PCB wrapper registration changed before explicit stack correction')
    new_translation=expected.get('new_translation_mm',translation)
    datum_changed=max(abs(a-b)for a,b in zip(new_translation,translation))>1e-5
    if datum_changed:
        # Main wrapper uses a captured rigid occurrence pose, not a joint.
        # Refuse to overwrite any later assembly constraint unexpectedly.
        related=[j.name for j in root.joints if (j.occurrenceOne and j.occurrenceOne.fullPathName==parent.fullPathName) or (j.occurrenceTwo and j.occurrenceTwo.fullPathName==parent.fullPathName)]
        if related:raise RuntimeError('PCB gained a joint; update its datum instead: '+str(related))
        matrix=parent.transform2;matrix.translation=core.Vector3D.create(*(x/10 for x in new_translation));parent.transform2=matrix
        if d.snapshots.hasPendingSnapshot:d.snapshots.add()
        if not d.computeAll():raise RuntimeError('Stack datum recompute failed')
        if max(abs(a-b)for a,b in zip([v*10 for v in parent.transform2.translation.asArray()],new_translation))>1e-5:raise RuntimeError('Explicit stack translation did not persist')
    substrate=[];solids=[]
    for occurrence in root.allOccurrences:
        if not occurrence.fullPathName.startswith(parent.fullPathName+'+'):continue
        for body in occurrence.bRepBodies:
            if not body.isSolid:continue
            row={'occurrence':occurrence.fullPathName,'name':body.name,'bounds_mm':bounds(body)};solids.append(row)
            if '_PCB' in occurrence.component.name:substrate.append(row)
    if len(substrate)!=1:raise RuntimeError('Expected one placed dielectric substrate')
    low,high=substrate[0]['bounds_mm'];thickness=high[2]-low[2]
    if abs(thickness-expected['core_mm'])>1e-4:raise RuntimeError('STEP dielectric thickness changed; review exporter/stack registration')
    centre=(low[2]+high[2])/2;nominal=expected['nominal_stack_mm']
    if abs(centre-sum(nominal)/2)>1e-4:raise RuntimeError('STEP substrate not centred in nominal stack')
    if other_documents(app)!=other_before:raise RuntimeError('Protected unrelated document changed')
    component.attributes.add(GROUP,'source_step_sha256',source_hash)
    component.attributes.add('TrimixPcbFit','source_step_sha256',source_hash)
    component.attributes.add('TrimixPcbFit','source_step',str(path))
    component.attributes.add(GROUP,'source_step_file',str(path))
    component.attributes.add('TrimixPcbFit','registration_mm',json.dumps(new_translation))
    component.attributes.add(GROUP,'stack_registration_basis','Detailed STEP substrate centred in nominal finished-board allocation; no scaling, no inferred mask. Main detailedlayer1.5642 differs fromfinishednominal1.6; max/minthicknessenvelopescheckedseparately.')
    component.attributes.add(GROUP,'placed_pcb_solids',str(len(solids)))
    component.attributes.add(GROUP,'integration_status',spec.get('status','updated_source_pending_fit_checks'))
    component.attributes.add(GROUP,'geometry_qualification','Latest supplied populated electrical STEP; cross-assembly fit and purchased-geometry fidelity require separate receipts')
    report('pcb-refresh-'+key+'.json',{'document':doc.name,'source_file':str(path),'old_sha256':old_hash,'source_sha256':source_hash,
        'retired_import_children':retired,'grounded_import_children':grounded,'wrapper_transform_unchanged':not datum_changed,'previous_registration_translation_mm':translation,
        'registration_translation_mm':new_translation,'nominal_stack_mm':nominal,'dielectric_thickness_mm':thickness,
        'dielectric_bounds_mm':substrate[0]['bounds_mm'],'placed_solids':solids,'geometry_scaled':False,
        'status':'imported_pending_new_fit_checks','protected_documents_preserved':other_before})


def main():return _run('main')
def usb():return _run('usb')
