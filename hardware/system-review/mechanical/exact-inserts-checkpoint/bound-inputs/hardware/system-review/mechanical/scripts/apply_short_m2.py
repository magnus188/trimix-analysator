"""Apply only the root-approved TC-M2x3.0 manifest; no save on application."""
from pathlib import Path
import hashlib,json
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE,GROUP,owned,configure,other_documents,attrs,report,bounds
APPROVED='5bedc48c0226e6822b8fe5d2813a7520f025da666fddb8bf855ba65fecaa45ca'
OUT=BASE/'verification/short-m2-implementation'


def _write(name,data):
    OUT.mkdir(parents=True,exist_ok=True);(OUT/name).write_text(json.dumps(data,indent=2)+'\n');return data


def apply():
    configure()
    import insert_proposal_guard as guard
    import cnckitchen_m2_audit as candidate
    import review_checks
    from width_contract_proposal import _snapshots,compare_physical
    manifest=BASE/'verification/cnckitchen-m2-proposal.json'
    if hashlib.sha256(manifest.read_bytes()).hexdigest()!=APPROVED:raise RuntimeError('Approved insert manifest changed')
    guard.cnckitchen();spec=json.loads(manifest.read_text());app,doc,d=owned()
    if d.rootComponent.attributes.itemByName(GROUP,'short_m2_proposal_sha256'):raise RuntimeError('Short M2 already applied')
    manager,before=_snapshots();protected=other_documents(app);timeline=d.timeline.count
    occurrences={o.fullPathName:o for o in d.rootComponent.occurrences}
    instances=[occurrences[q['original_occurrence']]for q in spec['replacement_occurrences']]
    definitions={o.component.id for o in instances}
    if len(definitions)!=1:raise RuntimeError('Expected one shared M2 definition')
    component=instances[0].component
    if component.partNumber!='TMX-A3-F05' or component.bRepBodies.count!=1:raise RuntimeError('Unexpected insert definition/part ID')
    if len([o for o in d.rootComponent.allOccurrences if o.component.id==component.id])!=10:raise RuntimeError('Shared insert definition has unexpected usages')
    old_name=component.name;old_paths=[o.fullPathName for o in instances]
    old_poses=[o.transform2.asArray()for o in instances];old_occ_attrs=[attrs(o)for o in instances]
    old_body=component.bRepBodies.item(0);appearance=old_body.appearance
    old_component_attrs=attrs(component)
    exact,source=candidate._official(manager)
    matrix=core.Matrix3D.create();matrix.translation=core.Vector3D.create(0,0,-.3)
    if not manager.transform(exact,matrix):raise RuntimeError('Cannot register manufacturer face datum')
    if abs(bounds(exact)[0][2]+3)>1e-6 or abs(bounds(exact)[1][2])>1e-6:raise RuntimeError('Manufacturer datum mismatch')
    changes=[r for g in spec['parameter_groups']for r in g['changes']]
    _write('apply-started.json',{'source_document':doc.name,'source_version':doc.dataFile.versionNumber,'source_timeline':timeline,'proposal_sha256':APPROVED,'changes':changes,'old_insert_component':old_name,'old_occurrences':old_paths,'protected_documents':protected})
    for row in changes:d.allParameters.itemByName(row['name']).expression=row['proposed_expression']
    if not d.computeAll():raise RuntimeError('Printed support update failed')
    removed=component.features.removeFeatures.add(old_body)
    if not removed:raise RuntimeError('Cannot retire generic insert body')
    removed.name='Retire generic M2 insert reference — exact TC-M2x3.0 replacement'
    base=component.features.baseFeatures.add();base.name='TC-M2x3.0 exact manufacturer STEP, open-face datum'
    if not base.startEdit():raise RuntimeError('Cannot edit purchased insert base feature')
    try:
        body=component.bRepBodies.add(exact,base)
        if not body:raise RuntimeError('Cannot add exact manufacturer insert solid')
        body.name='TC-M2x3.0 manufacturer solid — internal thread visual reference'
        body.appearance=appearance
    finally:
        if not base.finishEdit():raise RuntimeError('Cannot finish purchased insert base feature')
    component.name='M2 insert — CNC Kitchen TC-M2x3.0'
    component.description='CNC Kitchen TC-M2x3.0 heat-set insert, EAN4262391010013; exact unscaled manufacturer external CAD. Internal thread visual/reference only; printed retention and actual usable thread require physical qualification.'
    raw=component.attributes.itemByName('TrimixRev04','hardware_definition')
    hardware=json.loads(raw.value)
    hardware.update(length_mm=3.0,outer_diameter_mm=3.6,required_boss_outer_diameter_mm=7.6,
       bore_diameter_mm=2.0755,manufacturer_part_number='TC-M2x3.0',manufacturer='CNC Kitchen / TwoChefs GmbH',
       model_internal_thread_reference_only=True,nominal_thread_major_diameter_mm=2.0,external_step_sha256=candidate.SHA)
    component.attributes.add('TrimixRev04','hardware_definition',json.dumps(hardware))
    for name,value in {'manufacturer':'CNC Kitchen / TwoChefs GmbH','manufacturer_part_number':'TC-M2x3.0',
         'part_number':'TC-M2x3.0','quantity':'10','source_step_sha256':candidate.SHA,'source_step_file':str(candidate.SOURCE),
         'geometry_basis':'Exact manufacturer STEP rigidly translated -3mm to put openface at componentZ0; no scaling.',
         'thread_model_limits':'Source bore minimumØ2.0755 is not a faithful M2engagement model; internal thread visual/reference only. Nominal axial allocation and actual tip clearance checked separately.',
         'installation_limits':'Three non-gas through-pilots, seven blindpilots; electronics/display removed for heatsetting. Printed retention/torque/pullout and actual usablethread physically pending.'}.items():
        component.attributes.add('TrimixRev04',name,value)
    if not d.computeAll():raise RuntimeError('Exact insert replacement recompute failed')
    if component.bRepBodies.count!=1 or not component.bRepBodies.item(0).isSolid:raise RuntimeError('Expected one new shared insert solid')
    if old_poses!=[o.transform2.asArray()for o in instances] or old_occ_attrs!=[attrs(o)for o in instances]:raise RuntimeError('Existing hardware placement or binding attributes changed')
    newrows=[]
    for oldpath,o,row in zip(old_paths,instances,spec['replacement_occurrences']):
        newrows.append({'old_occurrence':oldpath,'occurrence':o.fullPathName,'face_mm':row['original_face_mm'],
                        'position_expressions':row['position_expressions'],'paired_screw':row['paired_screw'],
                        'host':('USB A3 — removable printed support frame' if row['original_face_mm'][2]>25 and row['original_face_mm'][2]<35 else'Chamber / A3 top manifold with serial return'if row['original_face_mm'][2]>=35 else'01 Shape A housing'),
                        'pilot_type':row['pilot_type']})
    d.rootComponent.attributes.add(GROUP,'short_m2_proposal_sha256',APPROVED)
    d.rootComponent.attributes.add(GROUP,'short_m2_source_sha256',candidate.SHA)
    d.rootComponent.attributes.add(GROUP,'short_m2_interfaces',json.dumps(newrows))
    _,after=_snapshots()
    allowed_printed={'01 Shape A housing','USB A3 — removable printed support frame','Chamber / A3 top manifold with serial return'}
    old_unchanged={k:r for k,r in before.items()if r['component']not in allowed_printed and r['occurrence']not in old_paths}
    new_paths={o.fullPathName for o in instances}
    new_unchanged={k:r for k,r in after.items()if r['component']not in allowed_printed and r['occurrence']not in new_paths}
    invariant=compare_physical(old_unchanged,new_unchanged,manager)
    health=review_checks.health(d)
    if not invariant['pass'] or not health['pass']or protected!=other_documents(app):raise RuntimeError('Unchanged geometry, native health or protected documents failed')
    result={'status':'applied_unsaved_validation_required','proposal_sha256':APPROVED,'source_step_sha256':candidate.SHA,
       'source_version_preserved':8,'timeline_before':timeline,'timeline_after':d.timeline.count,'parameter_changes':changes,
       'source_model':source,'insert_component':component.name,'stable_part_id':component.partNumber,'manufacturer_part_number':'TC-M2x3.0',
       'interfaces':newrows,'occurrence_poses_and_binding_attributes_unchanged':True,'unchanged_physical_solids':invariant,
       'health':health,'protected_documents':protected,'old_component_attributes':old_component_attrs,'native_saved':False}
    _write('applied.json',result)
    print(json.dumps({'status':result['status'],'timeline':d.timeline.count,'unchanged_solids_pass':invariant['pass'],'interfaces':len(newrows),'health_pass':health['pass']}))
