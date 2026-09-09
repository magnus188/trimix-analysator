"""Guarded0962 local-refinement import; no component scaling or carrier edits."""
from pathlib import Path
import json
import hashlib
from runtime import BASE, GROUP, owned, configure

DIRECTORY=BASE/'verification/final-local-inputs'
DRAFT_SHA='2bb3fd19b0708be576b41ca073f98b1f189ffbba8d5fca210b6632ef7c0eaf9c'
STEP_SHA='81eef0182d0d3bbaaf1a433cf43dce3e70f975c9ccd6d8d94bd196aa00c99014'
BOARD_SHA='0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788'


def _sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _require(value,message):
    if not value:raise RuntimeError(message)


def _write(name,value):
    with (DIRECTORY/name).open('x')as stream:stream.write(json.dumps(value,indent=2)+'\n')
    return value


def _source():
    draft=DIRECTORY/'incoming-boards.json'
    _require(_sha(draft)==DRAFT_SHA,'Frozen local input draft changed')
    manifest=json.loads(draft.read_text());main=manifest['main']
    _require(main['sha256']==STEP_SHA and main['board_sha256']==BOARD_SHA,'Wrong frozen PCB/STEP')
    for row in manifest.values():
        for path,digest in (('file','sha256'),('height_contract_file','height_contract_sha256')):
            _require(_sha(row[path])==row[digest],'Input source file changed')
    for path,digest in (('checkpoint_file','checkpoint_sha256'),('coverage_file','coverage_sha256')):
        _require(_sha(main[path])==main[digest],'Input source proof changed')
    import runtime
    bundle=json.loads(Path(main['checkpoint_file']).read_text())
    _require(all(_sha(runtime.ROOT/p)==h for p,h in bundle['files'].items()),'Frozen source bundle member changed')
    coverage=json.loads(Path(main['coverage_file']).read_text())
    _require(coverage['status']=='source_coverage_and_pose_pass' and coverage['footprints']==169 and
             coverage['contract_rows']==153 and not coverage['errors'],'Full reference/pose/side/MPN/height coverage required')
    return manifest


def _before_refresh():
    import m3_checkpoint as checkpoint
    import review_checkpoint as state
    receipt,export=checkpoint._checkpoint()
    reopened=json.loads((checkpoint.TARGET/'native-reopen.json').read_text())
    _require(reopened['pass'] and reopened['native_sha256']==receipt['native_sha256'],'Exact insert archive must be reopened first')
    app,doc,d=owned();configure()
    now=state._state(d)
    dirty_flag_only=False
    if doc.isModified:
        receipt_path=DIRECTORY/'cached-legacy-import-error-state.json'
        if receipt_path.exists() and _sha(receipt_path)=='75b90178229a06bfaec74885332b44305b075ef65d05fb77d6f541388e65e211':
            failed=json.loads(receipt_path.read_text())
            dirty_flag_only=(failed['modified'] is True and failed['matches_verified_v10_state'] and
                failed['matches_verified_protected_documents'] and now==failed['state']==export['state'] and
                state._documents(app,doc)==failed['protected_documents']==export['protected_documents'])
    _require(doc.dataFile.versionNumber==10 and doc.dataFile.isComplete and
             (not doc.isModified or dirty_flag_only) and now==export['state'],
             'Require unchanged verified exact-insertsv10; only the exact proved dirty-flag-only exception is accepted')
    return app,doc,d


def inspect_main():
    """Measure only the new main STEP; unchanged USB has its own frozen proof."""
    import inspect_step_datums as inspect
    import importlib
    importlib.reload(inspect)
    import review_checkpoint as state
    manifest=_source();app,doc,d=_before_refresh()
    before=state._state(d);protected=state._documents(app,doc);modified=doc.isModified
    path=DIRECTORY/'datum-input-main-only.json'
    _require(not(DIRECTORY/'frozen-step-datums.json').exists(),'Preserve existing datum evidence')
    if path.exists():
        _require(json.loads(path.read_text())=={'main':manifest['main']},'Existing datum source changed')
    else:
        _write(path.name,{'main':manifest['main']})
    inspect.inspect(path,DIRECTORY/'frozen-step-datums.json')
    result=json.loads((DIRECTORY/'frozen-step-datums.json').read_text());main=result['sources']['main']
    expected=[[0,-99,0],[30,0,1.4942]]
    bounds_error=max(abs(a-b)for pair,want in zip(main['substrate']['bounds_mm'],expected)for a,b in zip(pair,want))
    holes=main['substrate_cylindrical_axes']
    correct_holes=all(any(abs(h['radius_mm']-1.15)<1e-4 and max(abs(a-b)for a,b in zip(h['axis_XY_mm'],p))<1e-4 for h in holes)for p in ((25.6,-92),(4.4,-6)))
    preserved=before==state._state(d) and protected==state._documents(app,doc) and modified==doc.isModified
    proof={'source_step_sha256':STEP_SHA,'source_board_sha256':BOARD_SHA,
           'datum_receipt_sha256':_sha(DIRECTORY/'frozen-step-datums.json'),
           'substrate_bounds_error_mm':bounds_error,'actual_NPTH_datums_match':correct_holes,
           'actual_translation_Z_mm':main['proposed_centre_aligned_translation_Z_mm'],
           'source_and_protected_documents_preserved':preserved,
           'pass':preserved and result['source_preserved'] and main['source_sha256']==STEP_SHA and bounds_error<1e-4 and
               correct_holes and abs(main['proposed_centre_aligned_translation_Z_mm']-20.5529)<1e-4,
           'geometry_scaled':False,'USB_reimported':False}
    _write('datum-integrity.json',proof)
    _require(proof['pass'],'New STEP datum/preservation mismatch; current main retained')
    return proof


def activate_inputs():
    """File-only update after measured source datums; both prior checkpoints retain snapshots."""
    manifest=_source()
    proof=json.loads((DIRECTORY/'datum-integrity.json').read_text())
    _require(proof['pass'] and proof['source_step_sha256']==STEP_SHA and
             proof['datum_receipt_sha256']==_sha(DIRECTORY/'frozen-step-datums.json'),'Datum proof mismatch')
    active=BASE/'verification/incoming-boards.json'
    old=json.loads(active.read_text())
    _require(old['main']['sha256']=='bb3473f6b223e3f762e067c0f4af2c91c42548e4f2be2c63c10befc6c45885dd' and old['usb']==manifest['usb'],'Unexpected active source; preserve USB')
    _write('previous-active-incoming-boards.json',old)
    main=manifest['main']
    main.update(datum_receipt_file=str(DIRECTORY/'frozen-step-datums.json'),
                datum_receipt_sha256=_sha(DIRECTORY/'frozen-step-datums.json'),native_STEP_datum_measurement_pending=False,
                status='frozen_local_routing_refinement_pending_native_fit_and_canonical_adoption_not_order_release')
    _write('activated-incoming-boards.json',manifest)
    active.write_text(json.dumps(manifest,indent=2)+'\n')
    _require(_sha(active)==_sha(DIRECTORY/'activated-incoming-boards.json'),'Active manifest write mismatch')
    return manifest


def import_main():
    """Retire only old STEP descendants through the approved width-aware importer."""
    import importlib,inspect,marshal
    loaded=[]
    for name,functions in (
        ('runtime',['owned','configure']),
        ('width_contract_proposal',['_main','_load']),
        ('width_contract_checks',['datums','_inputs']),
        ('refresh_boards',['_run']),
        ('width_aware_refresh',['_bundle_preflight','_main_joint','main'])):
        module=importlib.reload(importlib.import_module(name))
        loaded.append({'module':name,'file':module.__file__,'file_sha256':_sha(module.__file__),
            'functions':{f:{'signature':str(inspect.signature(getattr(module,f))),
                'loaded_code_sha256':hashlib.sha256(marshal.dumps(getattr(module,f).__code__)).hexdigest()}
                for f in functions}})
    import width_aware_refresh as refresh
    import review_checkpoint as state
    app,doc,d=_before_refresh()
    manifest=json.loads((BASE/'verification/incoming-boards.json').read_text())
    _require(manifest['main']['sha256']==STEP_SHA and manifest['main']['board_sha256']==BOARD_SHA and
             _sha(BASE/'verification/incoming-boards.json')==_sha(DIRECTORY/'activated-incoming-boards.json'),'Local source not activated/changed')
    protected=state._documents(app,doc)
    _write('loaded-import-chain-token-corrected.json',{'modules_in_reload_order':loaded,'guarded_v10_state_matches':True,'document_modified_flag':doc.isModified,'protected_documents':protected})
    refresh.main()
    _require(protected==state._documents(app,doc),'PCB refresh changed protected documents')
    _write('native-import-completed.json',{'document':doc.name,'source_step_sha256':STEP_SHA,'source_board_sha256':BOARD_SHA,
        'timeline':d.timeline.count,'protected_documents_preserved':True,'importer':'width_aware_refresh.main',
        'status':'source_registered_native_fit_and_carrier_review_required','saved':False,'geometry_scaled':False})


def first_fit():
    """Source-bound initial native/max/mate/cable assessment; no carrier changes."""
    import importlib
    import m3_validation as exact
    import width_contract_checks as width
    import integrated_clearance as ic
    import review_checkpoint as state
    app,doc,d=owned();configure()
    _require((DIRECTORY/'native-import-completed.json').exists(),'Main import completion required')
    folder=DIRECTORY/'first-fit'
    _require(not(folder/'final-integrated-clearance.json').exists(),'Preserve first fit evidence')
    before=state._state(d);protected=state._documents(app,doc)
    # The exact-insert adapter classifies only source/occurrence-bound intended
    # interfaces, retaining every unrelated actual positive-volume intersection.
    with exact.adapted(folder):
        with width.allocations(folder):
            ic.installed()
    result=json.loads((folder/'final-integrated-clearance.json').read_text())
    result['envelope_count_definition']='147 fitted maximum/allocation records, not a purchasing quantity; two records allocate wire/solder at J101/J102. Frozen purchasing ledger has145 populated purchased references.'
    (folder/'final-integrated-clearance.json').write_text(json.dumps(result,indent=2)+'\n')
    preserved=before==state._state(d) and protected==state._documents(app,doc)
    _write('first-fit-preservation.json',{'state_and_protected_documents_preserved':preserved,
        'status':result['status'],'source_step_sha256':STEP_SHA,'source_board_sha256':BOARD_SHA,
        'fit_receipt_sha256':_sha(folder/'final-integrated-clearance.json'),'no_carrier_edit':True})
    _require(preserved,'Read-only first fit changed source or other documents')
    return result


def inspect_after_failed_import():
    """Read actual post-error state; never infer transaction rollback."""
    import review_checkpoint as state
    import m3_checkpoint as checkpoint
    app,doc,d=owned();configure()
    receipt,export=checkpoint._checkpoint()
    now=state._state(d)
    proof={'current_document':doc.name,'cloud_version':doc.dataFile.versionNumber,'modified':doc.isModified,
        'state':now,'matches_verified_v10_state':now==export['state'],
        'protected_documents':state._documents(app,doc),
        'matches_verified_protected_documents':state._documents(app,doc)==export['protected_documents'] if 'protected_documents'in export else None,
        'source_step_sha256':next(o.component.attributes.itemByName(GROUP,'source_step_sha256').value for o in d.rootComponent.occurrences if o.component.partNumber=='TMX-A3-B01')}
    _write('cached-legacy-import-error-state.json',proof)
    return proof


def inspect_post_joint_guard():
    import review_checkpoint as state
    import m3_checkpoint as checkpoint
    import width_aware_refresh as refresh
    from width_contract_proposal import _main
    app,doc,d=owned();configure()
    _,export=checkpoint._checkpoint();now=state._state(d)
    parent=_main(d);joint=refresh._main_joint(d,parent)
    token_tests={}
    for field in ('origin_token','joint_token'):
        a=d.findEntityByToken(joint[field]);z=d.findEntityByToken(joint[field])
        token_tests[field]={'same_token_repeated_resolution_list_equal':a==z,
            'first_count':len(a),'second_count':len(z),
            'first':[{'name':e.name,'objectType':e.objectType,'token':e.entityToken}for e in a],
            'second':[{'name':e.name,'objectType':e.objectType,'token':e.entityToken}for e in z]}
    return _write('post-joint-guard-state.json',{'current_document':doc.name,'cloud_version':doc.dataFile.versionNumber,
        'modified':doc.isModified,'state':now,'matches_verified_v10_state':now==export['state'],
        'protected_documents':state._documents(app,doc),'matches_verified_protected_documents':state._documents(app,doc)==export['protected_documents'],
        'joint':joint,'same_entity_resolution_experiment':token_tests,
        'installed_source':parent.component.attributes.itemByName(GROUP,'source_step_sha256').value})
