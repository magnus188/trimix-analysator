"""Final frozen0962 native width/service checks after source-bound carrier cuts."""
from pathlib import Path
import json,importlib
from runtime import BASE,owned,configure
from final_local_integration import STEP_SHA,BOARD_SHA,_require
OUT=BASE/'verification/final-local-checks'


def _guard():
    configure()
    import width_contract_checks as width
    source=width._inputs()
    _require(source['main']['sha256']==STEP_SHA and source['main']['board_sha256']==BOARD_SHA,'Wrong installed source')
    result=json.loads((BASE/'verification/final-local-carrier/native-applied.json').read_text())
    _require(result['pass'],'Native carrier proof must pass')
    return source


def trial(value):
    import m3_validation as exact
    import width_contract_checks as width
    import carrier_local_refinement as carrier
    _guard();directory=OUT/'width-tests'
    _require(not(directory/('W'+str(value))/'trial-summary.json').exists(),'Preserve endpoint proof')
    with exact.adapted(directory):
        previous=width.selected_sections
        def sections():
            result=previous()
            import review_checks as review
            _,_,d=owned();manager,rows=review.records()
            body=next(r['body']for r in rows if r['component']==carrier.CARRIER)
            rings=carrier.sections(manager,body,d)
            result['new_carrier_whole_material_rings']=rings
            result['pass']=result['pass'] and all(r['pass']for r in rings)
            return result
        width.selected_sections=sections
        try:outcome=width.trial(value)
        finally:width.selected_sections=previous
    proof=json.loads((directory/('W'+str(value))/'trial-summary.json').read_text())
    trial=proof['trial'];restored=proof['restoration']
    passed=(trial is not None and trial['core_width_contract_pass'] and trial['clearance_status']=='bounded_geometry_clear' and
        trial['minimum_thickness_allocation_collisions']==0 and trial['path_status']=='sampled_paths_clear_with_prerequisites' and
        trial['driver_status']=='clear_for_nominal_shafts' and trial['fastener_thickness_status']=='selected_thickness_cases_geometrically_clear' and restored['compute_success'] and restored['all_parameter_expressions_restored'] and
        restored['all_physical_geometry_restored']['pass'] and restored['timeline_unchanged'] and restored['other_documents_preserved'] and restored['health']['pass'])
    # Exact status strings for driver/path APIs are verified against the receipt
    # before disposition; there is no historical R301 exception for this source.
    proof['final0962_source']={'board_sha256':BOARD_SHA,'step_sha256':STEP_SHA,'historical_R301_exception_allowed':False}
    proof['final0962_all_endpoint_gates_pass']=passed
    proof['review_note']='Evaluate every actual result; the source-dependent former R301/mate collision is required to be absent.'
    (directory/('W'+str(value))/'trial-summary.json').write_text(json.dumps(proof,indent=2)+'\n')
    _require(passed,'Final0962 endpoint has an unresolved fit/service/restoration gate')
    return outcome


def width85():
    """Full unchanged-baseline checks; no parameter mutation or redundant Boolean restoration."""
    import review_checkpoint as state
    import review_checks as review
    import m3_validation as exact
    import width_contract_checks as width
    import carrier_local_refinement as carrier
    import verification_a3 as v
    import thickness_fasteners as tf
    _guard();app,doc,d=owned();before=state._state(d);protected=state._documents(app,doc);modified=doc.isModified
    parent=OUT/'width-tests';directory=parent/'W85'
    _require(not(directory/'trial-summary.json').exists(),'Preserve completed W85 receipt')
    with exact.adapted(parent):
        health=review.health(d);axes=width.hole_axes();sections=width.selected_sections()
        manager,rows=review.records();body=next(r['body']for r in rows if r['component']==carrier.CARRIER)
        rings=carrier.sections(manager,body,d);sections['new_carrier_whole_material_rings']=rings
        sections['pass']=sections['pass'] and all(r['pass']for r in rings)
        with width.allocations(directory)as ic:
            clearance=ic.installed();manifest=ic._manifest()
            contract=json.loads(Path(manifest['main']['height_contract_file']).read_text())
            manager,physical=ic._rows();fixed=[r for r in physical if not r['occurrence'].startswith(width.MAIN)]
            thin=ic._main(manager,contract,-.16)
            thin_tests=[v._test(manager,'Main maxima finished thickness1.44',thin,fixed,[(0,0,0)],[]),
                v._test(manager,'J301 mate finished thickness1.44',[ic._mate(manager,contract,-.16)],fixed+[r for r in thin if r['contract']['reference']!='J301'],[(0,0,0)],[]),
                v._test(manager,'J301 cable finished thickness1.44',[ic._cable(manager,contract,-.16)],fixed+[r for r in thin if r['contract']['reference']!='J301'],[(0,0,0)],[])]
            width._save(directory,'minimum-thickness-allocations.json',{'tests':thin_tests,'status':'clear'if not any(r['collision_count']for r in thin_tests)else'needs_review'})
            adapted,old=ic._adapter(False);old_output=v.OUTPUT
            try:
                v.OUTPUT=directory;paths=adapted.audit_paths()
            finally:v._records=old;v.OUTPUT=old_output
            adapted,old=ic._adapter(True);old_output=v.OUTPUT
            try:
                v.OUTPUT=directory;drivers=adapted.audit_drivers()
            finally:v._records=old;v.OUTPUT=old_output
            prior=tf.report;tf.report=lambda name,data:width._save(directory,name,data)
            try:fasteners=tf.audit()
            finally:tf.report=prior
    after=state._state(d)
    preservation={'source_state_equal':before==after,'all_parameter_expressions_unchanged':before['parameters']==after['parameters'],
        'all_placed_body_records_unchanged':before['bodies']==after['bodies'],'all_occurrence_poses_unchanged':before['poses']==after['poses'],
        'timeline_unchanged':before['timeline']==after['timeline'],'joint_and_main_descendants_unchanged':before['joints']==after['joints']and before['main_descendants']==after['main_descendants'],
        'protected_documents_unchanged':protected==state._documents(app,doc),'owned_modified_flag_unchanged':modified==doc.isModified,
        'parameter_mutation_performed':False,'native_geometry_mutation_performed':False,
        'bilateral_Boolean_restoration_run':False,'scope':'Read-only full baseline checks. Full purchased-shape Boolean equivalence and changed-width restoration are performed separately atW87.'}
    outcome={'width_mm':85,'datums':width.datums(),'actual_hole_alignment':axes,'health':health,'selected_sections':sections,
        'clearance_status':clearance['status'],'minimum_thickness_allocation_collisions':sum(r['collision_count']for r in thin_tests),
        'fastener_thickness_status':fasteners['status'],'path_status':paths['status'],'driver_status':drivers['status'],
        'core_width_contract_pass':axes['pass']and health['pass']and sections['pass'],
        'service_scope':'Full read-only W85 installed/native/max/gas/material/service/driver/thickness endpoint; changed-width proof is separate W87.',
        'release':False}
    passed=(outcome['core_width_contract_pass']and clearance['status']=='bounded_geometry_clear'and
        not outcome['minimum_thickness_allocation_collisions']and fasteners['status']=='selected_thickness_cases_geometrically_clear'and
        paths['status']=='sampled_paths_clear_with_prerequisites'and drivers['status']=='clear_for_nominal_shafts'and
        all(preservation[k]for k in ('source_state_equal','all_parameter_expressions_unchanged','all_placed_body_records_unchanged',
            'all_occurrence_poses_unchanged','timeline_unchanged','joint_and_main_descendants_unchanged','protected_documents_unchanged','owned_modified_flag_unchanged')))
    width._save(directory,'trial-summary.json',{'trial':outcome,'read_only_preservation':preservation,
        'final0962_source':{'board_sha256':BOARD_SHA,'step_sha256':STEP_SHA,'historical_R301_exception_allowed':False},
        'final0962_all_endpoint_gates_pass':passed})
    _require(passed,'W85 final read-only endpoint failed')
    return outcome
def width87():return trial(87)


def oxygen():
    _guard()
    import m3_oxygen_checks as checks
    importlib.reload(checks)
    original=checks.OUT;checks.OUT=OUT/'oxygen-variants'
    try:return checks.run()
    finally:checks.OUT=original


def thickness_drivers():
    _guard()
    import width_contract_checks as width
    import integrated_clearance as checks
    from short_m2_validation import adapted
    directory=OUT/'thickness-drivers'
    _require(not(directory/'board-thickness-drivers.json').exists(),'Preserve thickness driver proof')
    with adapted(directory):
        with width.allocations(directory):return checks.thickness_drivers()
