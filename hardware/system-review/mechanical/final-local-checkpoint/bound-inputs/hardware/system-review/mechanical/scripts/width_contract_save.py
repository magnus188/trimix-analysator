"""Save only the restored, checked85mm width-contract checkpoint; not PCB release."""
from pathlib import Path
import hashlib
import json
import zipfile
import adsk.fusion as fusion
from runtime import owned,configure,BASE,GROUP,other_documents,report


def _json(path):return json.loads(path.read_text())
def _sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()


def save():
    app,doc,design=owned();configure()
    from width_contract_proposal import _load,_snapshots,compare_physical
    from width_contract_checks import datums,hole_axes
    import review_checks
    spec,digest=_load();marker=design.rootComponent.attributes.itemByName(GROUP,'width_contract_manifest_sha256')
    if not marker or marker.value!=digest:raise RuntimeError('Width contract marker mismatch')
    if abs(datums()['CaseWidth']-85)>1e-6:raise RuntimeError('Only the restored85mm baseline may be saved')
    if not review_checks.health(design)['pass'] or not hole_axes()['pass']:
        raise RuntimeError('Current native health or mounting axes failed')
    proofs=[];root=BASE/'verification/width-contract-tests'
    for width in (85,85.5,86,86.5,87):
        path=root/('W'+str(width).replace('.','_'))/'trial-summary.json'
        data=_json(path);trial=data['trial'];r=data['restoration']
        if not trial or not trial['core_width_contract_pass'] or not all((r['compute_success'],r['all_parameter_expressions_restored'],
                r['all_physical_geometry_restored']['pass'],r['timeline_unchanged'],r['other_documents_preserved'],r['health']['pass'])):
            raise RuntimeError('Incomplete or failed width proof '+str(width))
        actual=_json(path.parent/'final-integrated-clearance.json')
        if actual['actual_cross_assembly']['collisions']:raise RuntimeError('Physical width collision unresolved')
        allocations=actual['tests']+_json(path.parent/'minimum-thickness-allocations.json')['tests']
        for test in allocations:
            for hit in test['collisions']:
                if (hit['moving']!='MAX/J301_MATED_PROVISIONAL / J301_MATED_PROVISIONAL maximum/allocation'
                    or hit['fixed']!='MAX_MAIN/R301 / R301 maximum/allocation envelope'
                    or abs(hit['volume_mm3']-.2135625)>1e-6):
                    raise RuntimeError('Unexpected unresolved maximum-allocation conflict')
        proofs.append({'width_mm':width,'file':str(path),'sha256':_sha(path)})
    path_proofs=[]
    for folder in ('retainer-path-diagnosis-W85','retainer-path-diagnosis'):
        path=root/folder/'diagnosis.json';data=_json(path);r=data['restoration']
        selected=[t for t in data['diagnosis']['tests'] if 'X-1.5mm' in t['name']]
        if len(selected)!=1 or selected[0]['collision_count'] or not all((r['compute'],r['physical']['pass'],
                r['parameters_restored'],r['timeline_preserved'],r['protected_documents_preserved'],r['health']['pass'])):
            raise RuntimeError('Adopted endpoint retainer sequence or restoration failed')
        path_proofs.append({'width_mm':data['diagnosis']['width_mm'],'file':str(path),'sha256':_sha(path)})
    for width in (85,87):
        directory=root/('W'+str(width))
        if _json(directory/'service-drivers.json')['status']!='clear_for_nominal_shafts':
            raise RuntimeError('Driver endpoint check failed')
        if _json(directory/'board-thickness-fasteners.json')['status']!='selected_thickness_cases_geometrically_clear':
            raise RuntimeError('Thickness/fastener endpoint check failed')
        paths=_json(directory/'service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json')
        if any(t['collision_count'] for t in paths['tests'] if t['name']!='retainers'):
            raise RuntimeError('Other endpoint removal path failed')
    protected=other_documents(app);timeline=design.timeline.count;manager,before=_snapshots()
    target=BASE/'width-checkpoint';target.mkdir(parents=True,exist_ok=True)
    native=target/'Trimix_Enclosure_A3_SystemReview_WidthContract.f3d'
    if native.exists():raise RuntimeError('Checkpoint already exists; preserve it before another save')
    status={
        'baseline_CaseWidth_mm':85,'static_sampled_widths_mm':[85,85.5,86,86.5,87],
        'full_service_endpoint_widths_mm':[85,87],
        'upper_retainer_sequence':'After cover/battery release and its screw removal, lift+Z6mm, shift-X1.5mm, then withdraw+Z; lower retainer and display remain installed during upper-clip removal.',
        'service_sampling_mm':{'general':1.0,'upper_retainer_staged':.25},
        'existing_pilot_ligament_mm':1.95,'pilot_retention_or_global_wall_qualified':False,
        'source_main_STEP_sha256':spec['main_step_sha256'],
        'source_status':'placement-checkpoint-v2; R301/J301 mated-envelope conflict retained; final routed PCB not integrated',
        'physical_or_manufacturing_release':False}
    design.rootComponent.attributes.add(GROUP,'width_contract_validation_scope',json.dumps(status))
    options=design.exportManager.createFusionArchiveExportOptions(str(native))
    if not design.exportManager.execute(options):raise RuntimeError('Width native checkpoint export failed')
    with zipfile.ZipFile(native) as archive:
        error=archive.testzip();members=len(archive.namelist())
    if error:raise RuntimeError('Native checkpoint CRC failure '+error)
    _,after=_snapshots();unchanged=compare_physical(before,after,manager)
    if not unchanged['pass'] or timeline!=design.timeline.count or protected!=other_documents(app):
        raise RuntimeError('Export changed geometry or protected state; do not cloud-save')
    if not doc.save('Width datum correction: restored85mm, rigid PCB/right-edge mounts, static85–87 samples and endpoint service including staged upper retainer. Placementv2 R301/mate remains; routed PCB and physical insert/cable fit pending.'):
        raise RuntimeError('Owned SystemReview cloud save failed')
    if protected!=other_documents(app):raise RuntimeError('Protected document state changed during save')
    result={'status':'saved_width_contract_checkpoint_not_full_fit_release','cloud_document':doc.name,
        'cloud_id':doc.dataFile.id,'cloud_version':doc.dataFile.versionNumber,'timeline':timeline,
        'native_archive':{'file':str(native),'bytes':native.stat().st_size,'sha256':_sha(native),
                          'zip_crc_pass':True,'zip_members':members},
        'manifest_sha256':digest,'scope':status,'width_receipts':proofs,'staged_retainer_receipts':path_proofs,
        'export_physical_geometry_unchanged':unchanged,'protected_documents_preserved':protected,
        'prior_v7_preserved_as_cloud_version':True,'new_STEP_exported':False,
        'STEP_basis':'Physical85mm solids remain identical to the saved placementv2 source; this checkpoint changes native dependencies. Final routed integration will supply its own refreshed STEP.'}
    (target/'checkpoint.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:v for k,v in result.items() if k!='export_physical_geometry_unchanged'}))


def verify_native():
    """Reopen only our archive in an unsaved temporary document, then close it."""
    app,doc,design=owned();configure()
    import audit_a3 as audit
    import step_a3 as step
    import review_checks
    target=BASE/'width-checkpoint';receipt=_json(target/'checkpoint.json')
    source=Path(receipt['native_archive']['file'])
    if _sha(source)!=receipt['native_archive']['sha256']:raise RuntimeError('Native checkpoint hash changed')
    parameters={p.name:p.expression for p in design.allParameters}
    bodies=audit._bodies(design);poses=step._poses(design);timeline=design.timeline.count
    protected=other_documents(app);source_modified=doc.isModified;temporary=None;result=None
    try:
        options=app.importManager.createFusionArchiveImportOptions(str(source))
        temporary=app.importManager.importToNewDocument(options)
        if not temporary or temporary.isSaved:raise RuntimeError('Expected an unsaved checkpoint inspection copy')
        imported=fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        if not imported:raise RuntimeError('Native checkpoint has no design')
        parent=[o for o in imported.rootComponent.occurrences if o.component.partNumber=='TMX-A3-B01']
        if len(parent)!=1:raise RuntimeError('Native imported checkpoint lost main PCB wrapper')
        children=[o for o in imported.rootComponent.allOccurrences if o.fullPathName.startswith(parent[0].fullPathName+'+')]
        result={'source_sha256':_sha(source),'geometry_match':audit._bodies(imported)==bodies,
            'poses_match':step._poses(imported)==poses,'all_parameter_expressions_match':parameters=={p.name:p.expression for p in imported.allParameters},
            'timeline_match':imported.timeline.count==timeline,'native_health_pass':review_checks.health(imported)['pass'],
            'main_descendants_grounded':bool(children) and all((o.nativeObject or o).isGroundToParent for o in children),
            'main_descendant_count':len(children),'source_timeline':timeline,
            'named_main_joint_present':len([j for j in imported.rootComponent.joints if j.name=='SystemReview main PCB parametric placement'])==1}
        result['pass']=all(result[k] for k in ('geometry_match','poses_match','all_parameter_expressions_match','timeline_match',
            'native_health_pass','main_descendants_grounded','named_main_joint_present'))
    finally:
        try:
            if temporary and not temporary.close(False):raise RuntimeError('Cannot close our temporary native check document')
        finally:
            if not doc.activate():raise RuntimeError('Cannot reactivate owned SystemReview')
        preserved=(bodies==audit._bodies(design) and poses==step._poses(design) and design.timeline.count==timeline
                   and parameters=={p.name:p.expression for p in design.allParameters}
                   and protected==other_documents(app) and doc.isModified==source_modified)
        if result:
            result['source_and_protected_documents_preserved']=preserved
            result['temporary_closed_without_save']=temporary is not None
            (target/'native-reopen.json').write_text(json.dumps(result,indent=2)+'\n')
        if not preserved:raise RuntimeError('Native inspection changed original or protected state')
    print(json.dumps(result))


def status():
    """Read-only asynchronous save completion and protected document inventory."""
    app,doc,design=owned();configure()
    from width_contract_checks import datums
    import review_checks
    data={'document':doc.name,'cloud_id':doc.dataFile.id,'cloud_version':doc.dataFile.versionNumber,
          'cloud_data_complete':doc.dataFile.isComplete,'document_modified':doc.isModified,
          'timeline':design.timeline.count,'datums':datums(),'health_pass':review_checks.health(design)['pass'],
          'protected_documents':other_documents(app),'active_document':app.activeDocument.name,
          'no_document_activated_or_modified':True}
    data['new_cloud_version_complete']=data['cloud_version']>=8 and data['cloud_data_complete'] and not data['document_modified']
    (BASE/'width-checkpoint/cloud-save-status.json').write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(data))
