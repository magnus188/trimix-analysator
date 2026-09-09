"""Final0962 review checkpoint. Import/_proofs are offline; native APIs are explicit.

capture_validated_state(), save_final(), verify_final(), status_final(),
status_receipt(), export_step(). No geometry edits, overwritten artifacts,
printer jobs, production/order release, or physical qualification.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib
import json
import math
import zipfile
import review_checkpoint as prior
import m3_checkpoint as inserts

BASE, ROOT = inserts.BASE, inserts.ROOT
INPUTS = BASE/'verification/final-local-inputs'
PROOFS = BASE/'verification/final-local-checks'
CARRIER = BASE/'verification/final-local-carrier'
TARGET = BASE/'final-local-checkpoint'
SLICES = BASE/'verification/final-local-slices'
ARCHIVE = 'Trimix_Enclosure_A3_SystemReview_FinalLocal.f3d'
BOARD = '0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788'
STEP = '81eef0182d0d3bbaaf1a433cf43dce3e70f975c9ccd6d8d94bd196aa00c99014'
CUT = 'caec62bf876ff07fa78836e5100941b4db2f7a654bb37b3061f50c0a7f6c4c2c'
CUT_REVIEW = '49dfe0a015667e070722677cc3ee5ccec4c06ce23d22b8b71d8b0a12e1e2a884'
V10_NATIVE = 'c4bf41ef168d99eefe3e63098a390383e4e7a91405429adc659bebd77726ac83'
V10_MAP = '7e8a11c4c2bfcaddead09d33a9cb359ccd5a7c493d896ca63d6f859baf1cd0c7'
V10_REVIEW = '5e0b7a97b997159fefc3fde0b897887e19e479b8ab1a4d58bb63b845a7780cff'
CARRIER_NAME = 'Carrier / removable electronics tray'
CUT_NAMES = {'C103 and C107 rear component aperture','R504 rear component aperture'}
_require, _sha, _write = prior._require, prior._sha, prior._write
LIMITS = [
    'Bounded digital geometry review only; not a production, purchase or print release.',
    'Physical printed fit/strength, heat-set retention, screw thread fit/torque, wiring and solder remain unqualified.',
    'Gas sealing, flow response and JJ shoulder/nose/cable interfaces remain unqualified.',
    'Service is sampled-path and nominal-driver geometry; no full swept-volume, hand/tool-handle or global wall proof.',
    '0962 is the frozen local CAD-review PCB source; canonical EDA adoption is separate.',
    'P03 native height is 5.5 mm; the diagnostic 0.2 mm profile quantizes its deposited top to 5.4 mm. Physical fit remains pending.',
]


class _Inputs(inserts._Inputs):
    def __init__(self):
        super().__init__(); self.dependencies = set()

    def dependency(self, path, digest=None, parse=False):
        path = Path(path); path = (path if path.is_absolute() else ROOT/path).resolve()
        _require(_dependency_allowed(path), 'Only retained checkpoints and scoped diagnostic artifacts may be external dependencies')
        result = self.bind(path, digest, parse)
        self.dependencies.add(str(path)); return result


def _dependency_allowed(path):
    return path.parent in (inserts.TARGET,inserts.M2) or path.is_relative_to(SLICES)


def _retained(inputs):
    """Bind old archive/map identities, without recursively copying their input trees."""
    folder = inserts.TARGET
    review = inputs.dependency(folder/'root-archive-review.json', V10_REVIEW, True)
    checkpoint = inputs.dependency(folder/'checkpoint.json', '0618e9028e13df84b9ef2dc0277e31d194d7812d2ccbd4e534f6042e2e1f5c2d', True)
    export = inputs.dependency(folder/'export.json', checkpoint['export_sha256'], True)
    mapping = inputs.dependency(folder/'bound-inputs-map.json', V10_MAP, True)
    inputs.dependency(folder/inserts.ARCHIVE, V10_NATIVE)
    reopened = inputs.dependency(folder/'native-reopen.json', '687e11d568d216ae85cc38f4aebafb6cdbefe86f36cb43a399b1269b240ade4d', True)
    cloud = inputs.dependency(folder/'cloud-status-20260908T014859Z.json',
        'aeb6790a5d9bdc2ca0e9754f08e7d5b44991075a34cae66099e58766b4b48d2b', True)
    _require(review['status'] == 'passed digitally' and review['native_sha256'] == V10_NATIVE and
        review['zip_crc_failed_member'] is None and review['cloud_version'] == 10 and
        review['native_reopen_all_matches'] is True and checkpoint['native_sha256'] == export['sha256'] == V10_NATIVE and
        checkpoint['bound_inputs_map_sha256'] == export['bound_inputs_map_sha256'] == V10_MAP and
        reopened['pass'] is True and all(reopened['matches'].values()) and reopened['native_sha256'] == V10_NATIVE and
        cloud['new_cloud_version_complete'] is True and cloud['cloud_version'] == 10 and
        cloud['cloud_id'] == export['source_id'] and export['state']['timeline'] == 1203 and
        mapping['source_file_count'] == len(mapping['files']) == 167, 'Retained v10 identity/reopen/completion failed')
    old = inserts.M2
    m2review = inputs.dependency(old/'root-archive-review.json', inserts.M2_REVIEW, True)
    m2mapping = inputs.dependency(old/'bound-inputs-map.json', inserts.M2_MAP, True)
    inputs.dependency(old/'Trimix_Enclosure_A3_SystemReview_ShortM2.f3d', inserts.M2_NATIVE)
    _require(m2review['all_34_archived_inputs_match'] is True and m2review['native_sha256'] == inserts.M2_NATIVE,
             'Retained v9 review changed')
    # Read only selected original proof sources whose hashes the frozen v10 map binds.
    by_original = {r['original']:r for r in m2mapping['files']+mapping['files']}
    def original(path):
        row = by_original[str(path.resolve())]
        return inputs.read(path, row['sha256'])
    evaluation = original(BASE/'verification/cnckitchen-m2-proposal-evaluation.json')
    expected = {q['insert']:q['exact_candidate_host_heatset_overlap'][0]['volume_mm3'] for q in evaluation['interfaces']}
    return dict(export=export, pairs=export['native_markers']['interfaces'],
        m2_pairs=export['native_markers']['retained_m2_pairs'], m2_expected=expected,
        old_incoming_sha256=by_original[str((BASE/'verification/incoming-boards.json').resolve())]['sha256'])


def _sources(inputs, retained):
    incoming = inputs.read(BASE/'verification/incoming-boards.json')
    _require(incoming == inputs.read(INPUTS/'activated-incoming-boards.json'), 'Activated/live input manifests differ')
    main = incoming['main']
    _require(main['sha256'] == STEP and main['board_sha256'] == BOARD and
             main['native_STEP_datum_measurement_pending'] is False, 'Wrong/unmeasured final source')
    old = inputs.read(INPUTS/'previous-active-incoming-boards.json', retained['old_incoming_sha256'])
    _require(old['main']['sha256'] == prior.OLD_MAIN and incoming['usb'] == old['usb'], 'USB source changed')
    for source in incoming.values():
        for f,h in (('file','sha256'),('height_contract_file','height_contract_sha256')):
            inputs.bind(source[f], source[h])
    checkpoint = inputs.read(main['checkpoint_file'], main['checkpoint_sha256'])
    coverage = inputs.read(main['coverage_file'], main['coverage_sha256'])
    inputs.mapping(checkpoint['files']); inputs.mapping(coverage['source_hashes'])
    _require(checkpoint['source_board_sha256'] == BOARD and coverage['status'] == 'source_coverage_and_pose_pass' and
        coverage['checkpoint_sha256'] == main['checkpoint_sha256'] and coverage['footprints'] == len(coverage['rows']) == 169 and
        coverage['contract_rows'] == 153 and len({r['reference'] for r in coverage['rows']}) == 169 and not coverage['errors'] and
        coverage['classification_counts'] == {'DNP_excluded':6,'mechanical_NPTH_no_component_height':2,
            'populated_maximum_or_allocation':147,'testpad_no_component_height':14}, 'Full 169 reference/153 height coverage failed')
    preflight = inputs.read(INPUTS/'preflight.json', 'a15785d84d849b8f67e60bf99b2c4470a7641c2ca348656908bdca02d1c1f7ed')
    _require(preflight['all153_height_rows_mandatory_checked'] is True and
        preflight['native_and_XML_MPN_footprint_DNP_correspondence'] is True and
        len(preflight['owner_nine_members_verified']) == 9, 'Frozen nine-member/full MPN correspondence failed')
    inputs.bind(checkpoint['source_manifest'], checkpoint['source_manifest_sha256'])
    datum = inputs.read(INPUTS/'datum-integrity.json')
    inputs.bind(main['datum_receipt_file'], main['datum_receipt_sha256'])
    _require(datum['pass'] is True and datum['source_step_sha256'] == STEP and datum['source_board_sha256'] == BOARD and
        datum['datum_receipt_sha256'] == main['datum_receipt_sha256'] and datum['actual_NPTH_datums_match'] is True and
        abs(datum['actual_translation_Z_mm']-20.5529) < 1e-6 and datum['geometry_scaled'] is False and
        datum['USB_reimported'] is False and datum['source_and_protected_documents_preserved'] is True, 'Measured source datum failed')
    imported = inputs.read(INPUTS/'native-import-completed.json')
    _require(imported['source_step_sha256'] == STEP and imported['source_board_sha256'] == BOARD and
        imported['geometry_scaled'] is False and imported['protected_documents_preserved'] is True, 'Native import source changed')
    for name in ('pcb-refresh-main.json','pcb-refresh-main-width-contract.json'):
        inputs.read(BASE/'verification'/name)
    return incoming


def _rings(rows):
    _require(len(rows) == 2 and {r['name'] for r in rows} == CUT_NAMES and all(r['pass'] is True and
        r['nominal_XY_ring_width_mm'] == r['nominal_plate_thickness_mm'] == 2 and
        inserts._small(r['missing_material_mm3']) for r in rows), 'Whole local carrier material rings failed')


def _carrier(inputs, incoming):
    review = inputs.read(CARRIER/'root-proposal-review.json', CUT_REVIEW)
    proposal = inputs.read(CARRIER/'proposal.json', CUT)
    inputs.bind(INPUTS/'carrier-source-envelope.json', proposal['courtyard_source_sha256'])
    inputs.mapping(inputs.read(INPUTS/'carrier-source-envelope.json')['source_sha256'])
    applied = inputs.read(CARRIER/'native-applied.json')
    started = inputs.read(CARRIER/'apply-started.json')
    _require(review['status'] == 'passed digitally' and review['proposal_sha256'] == CUT and review['board_sha256'] == BOARD and
        review['order_release'] is False and proposal['pass'] is True and proposal['source_board_sha256'] == BOARD and
        proposal['source_step_sha256'] == STEP and proposal['active_inputs_sha256'] == _sha(BASE/'verification/incoming-boards.json') and
        applied['pass'] is True and applied['proposal_sha256'] == CUT and applied['source_board_sha256'] == BOARD and
        applied['source_step_sha256'] == STEP and applied['actual_carrier_lumps'] == 1 and
        applied['timeline_before'] == started['timeline'] == proposal['source_state']['timeline'] == 1205 and
        applied['timeline_after'] == 1211 and applied['new_features'] == [c['name'] for c in proposal['cuts']] and
        len(applied['candidate_actual_bilateral_boolean_residuals_mm3']) == 2 and
        all(inserts._small(v) for v in applied['candidate_actual_bilateral_boolean_residuals_mm3']) and
        applied['all_other_physical_solid_equivalence']['pass'] is True and applied['protected_documents_preserved'] is True,
        'Exact native two-aperture carrier/source/equivalence failed')
    _require(all(r['pass'] is True for r in applied['all_other_physical_solid_equivalence']['bodies']), 'Filtered carrier equivalence')
    prior._health(applied['health']); _rings(applied['whole_local_material_rings'])
    return proposal, applied


def _clear(tests, names):
    _require(len(tests) == len(names) and {q['name'] for q in tests} == set(names), 'Test coverage changed')
    prior._empty_tests(tests, len(names))  # No legacy R301 exception on this source.


def _oxygen(inputs):
    directory = PROOFS/'oxygen-variants'; summary = inputs.read(directory/'summary.json')
    _require(summary['pass'] is True and summary['restored_compute'] is True and
        summary['all_physical_geometry_restored']['pass'] is True and summary['all_parameters_and_poses_restored'] is True and
        summary['source_and_protected_documents_preserved'] is True and summary['source_files_unchanged'] is True,
        'Final oxygen restoration failed')
    prior._health(summary['health']); inputs.mapping(summary['source_sha256'])
    rows = inserts._unique(summary['tests'], 'width_mm', (85,87))
    for width,row in rows.items():
        path = directory/('W'+str(width))/'oxygen-variant-checks.json'
        _require(Path(row['report']).resolve() == path and row['pass'] is True and
            row['status'] == 'bounded_reference_checks_clear', 'Oxygen endpoint source/status failed')
        data = inputs.read(path, row['sha256'])
        _require(data['status'] == 'bounded_reference_checks_clear' and data['AO2_geometry_scaled'] is False and
            data['manufacturing_or_seal_qualification'] is False, 'Oxygen endpoint scope failed')
        _clear(data['tests'], {'JJ dry-body and provisional cable installed','JJ closed sampling cartridge rear removal'})


def _slices(inputs, mesh):
    """Retain reviewed diagnostic evidence without copying large projects or old snapshot trees."""
    data = inputs.read(SLICES/'verification-receipt.json', '422d46e4a7000561473ee7a1b0fb9dc9ecd8a8727b5c86bdf07bb73835839aba')
    checks = data['checks']
    _require(data['status'] == 'EIGHT_SOURCE_BOUND_DIAGNOSTIC_SLICES_REVIEWED_PHYSICAL_VALIDATION_PENDING' and
        checks['parts'] == 4 and checks['reviewed_material_projects'] == 8 and checks['digital_slice_checks_passed'] == 50 and
        checks['digital_slice_checks_failed'] == 0 and checks['all_source_meshes_unchanged'] is True and
        checks['all_selected_contact_sheets_inspected'] is True and checks['production_print_release'] is False and
        checks['physical_print_jobs_sent'] is False, 'Reviewed diagnostic slicing evidence failed')
    _require(inputs.read(data['owner_handoff']['path'],data['owner_handoff']['sha256']) == mesh, 'Slice/native handoff differs')
    for row in data['tools']:
        inputs.bind(row['path'],row['sha256'])
    for row in data['files']:
        path = ROOT/row['path']
        if path.suffix == '.py' or path.parent == SLICES/'profiles':
            inputs.bind(path,row['sha256'])
        else:
            inputs.dependency(path,row['sha256'])


def _views(inputs):
    directory = PROOFS/'views'; data = inputs.read(directory/'views.json')
    _require(data['board_sha256'] == BOARD and data['step_sha256'] == STEP and data['timeline'] == 1211 and
        data['actual_Fusion_geometry'] is True and data['part_poses_changed'] is False and
        data['visibility_and_camera_restored'] is True and data['source_and_protected_documents_preserved'] is True,
        'Final native inspection view provenance/restoration failed')
    _require(len(data['files']) == 3 and {Path(r['file']).name for r in data['files']} ==
        {'assembled.png','rear-access.png','carrier-apertures.png'}, 'Final inspection image coverage changed')
    for row in data['files']:
        path = Path(row['file']).resolve()
        _require(path.parent == directory and path.suffix == '.png', 'Inspection view outside final proof directory')
        inputs.bind(path,row['sha256'])


def _endpoint(inputs, width, proof):
    folder = PROOFS/'width-tests'/('W'+str(width)); trial = inputs.read(folder/'trial-summary.json')
    t = trial['trial']; prior._health(t['health'])
    _require(trial['final0962_all_endpoint_gates_pass'] is True and trial['final0962_source'] ==
        {'board_sha256':BOARD,'step_sha256':STEP,'historical_R301_exception_allowed':False} and
        abs(t['width_mm']-width) < 1e-6 and abs(t['datums']['CaseWidth']-width) < 1e-6 and
        t['core_width_contract_pass'] is True and
        t['actual_hole_alignment']['pass'] is True and t['selected_sections']['pass'] is True and
        t['clearance_status'] == 'bounded_geometry_clear' and t['minimum_thickness_allocation_collisions'] == 0,
        'Final width/clearance failed')
    _rings(t['selected_sections']['new_carrier_whole_material_rings'])
    if width == 87:
        r = trial['restoration']; prior._health(r['health'])
        _require(t['purchased_geometry']['pass'] is True and t['all_main_children_rigid_local_poses_preserved'] is True and
            all(r[k] is True for k in ('compute_success','all_parameter_expressions_restored','timeline_unchanged','other_documents_preserved')) and
            r['all_physical_geometry_restored']['pass'] is True, 'W87 full purchased-geometry Boolean/restoration proof failed')
    else:
        # W85 is the explicitly scoped no-edit assessment, not a simulated width trial.
        readonly = trial['read_only_preservation']
        _require(all(readonly[k] is True for k in ('source_state_equal','all_parameter_expressions_unchanged',
            'all_placed_body_records_unchanged','all_occurrence_poses_unchanged','timeline_unchanged',
            'joint_and_main_descendants_unchanged','protected_documents_unchanged','owned_modified_flag_unchanged')) and
            all(readonly[k] is False for k in ('parameter_mutation_performed','native_geometry_mutation_performed',
                'bilateral_Boolean_restoration_run')), 'W85 explicit full-state read-only preservation failed')
    material = inputs.read(folder/'native-M3-material.json')
    actual = inputs.read(folder/'final-integrated-clearance.json'); prior._health(actual['health'])
    _require(actual['status'] == 'bounded_geometry_clear' and actual['source_state_preserved'] is True and
        actual['geometry_scaled'] is False and actual['source_manifest'] == proof['incoming'], 'Final clearance source/status changed')
    retained = proof['retained']
    inserts._intersections(actual['actual_cross_assembly'], material, retained['pairs'], retained['m2_pairs'], retained['m2_expected'], width)
    _clear(actual['tests'], prior.INSTALLED_TESTS)
    thin_names = {'Main maxima finished thickness1.44','J301 mate finished thickness1.44','J301 cable finished thickness1.44'} if width == 85 else prior.THIN_TESTS
    _clear(inputs.read(folder/'minimum-thickness-allocations.json')['tests'], thin_names)
    _require(inputs.read(folder/'gas.json')['pass'] is True, 'Final gas geometry failed')
    paths = inputs.read(folder/prior.PATH_FILE)
    _require(paths['status'] == t['path_status'] == 'sampled_paths_clear_with_prerequisites' and
        paths['persistent_geometry_unchanged'] is True and paths['timeline_count'] == 1211, 'Final path state/scope failed')
    _clear(paths['tests'], {'cover','disconnect','battery','carrier','chamber','retainers','display','usb'})
    _clear(next(q for q in paths['tests'] if q['name'] == 'retainers')['subtests'], {'upper_staged','lower_after_upper'})
    drivers = inputs.read(folder/'service-drivers.json')
    _require(drivers['status'] == t['driver_status'] == 'clear_for_nominal_shafts' and
        drivers['persistent_geometry_unchanged'] is True and drivers['timeline_count'] == 1211 and
        drivers['screw_occurrence_count'] == len({q['occurrence'] for q in drivers['tests']}) == 14, 'Final driver coverage failed')
    prior._empty_tests(drivers['tests'], 14)
    fasteners = inputs.read(folder/'board-thickness-fasteners.json'); inputs.mapping(fasteners['source_sha256'])
    main_pairs = {p['paired_screw']:p['occurrence'] for p in retained['m2_pairs'] if 'PcbX' in p['position_expressions'][0]}
    prior._thickness(fasteners, STEP, main_pairs)
    _require(t['fastener_thickness_status'] == fasteners['status'] and fasteners['timeline_count'] == 1211,
        'Final fastener status/timeline failed')


def _proofs(require_capture=True):
    """Offline only. Missing or failed final receipts block every save API."""
    inputs = _Inputs()
    for directory in (BASE/'scripts', ROOT/'hardware/cad/rev04/scripts'):
        for path in sorted(directory.glob('*.py')):
            inputs.bind(path)
    retained = _retained(inputs); incoming = _sources(inputs, retained)
    proposal, applied = _carrier(inputs, incoming)
    proof = dict(retained=retained, incoming=incoming, proposal=proposal, applied=applied,
        width_digest=inputs.bind(BASE/'verification/width-contract-proposal.json'))
    mesh = inputs.read(BASE/'diagnostic-printing/final-local/meshes/handoff.json')
    _require(mesh['source_board_sha256'] == BOARD and mesh['source_step_sha256'] == STEP and
        mesh['native_timeline'] == 1211 and mesh['cloud_lineage'] == retained['export']['source_id'] and
        mesh['exact_insert_archive_sha256'] == V10_NATIVE and mesh['protected_documents_preserved'] is True and
        mesh['print_job_sent'] is False, 'Native source-bound STL handoff failed')
    rows = inserts._unique(mesh['parts'], 'part_id', {'TMX-A3-P01','TMX-A3-P03','TMX-A3-P06','TMX-A3-P07'})
    for row in rows.values():
        _require(row['units'] == 'mm' and row['scale'] == 1 and row['geometry_scaled'] is False and row['native_part_lumps'] == 1,
            'Diagnostic STL source units/lump contract changed')
        inputs.bind(row['file'], row['sha256'])
    inputs.bind(mesh['carrier_apply_proof_file'], mesh['carrier_apply_proof_sha256'])
    for f,h in (('file','sha256'),('source_file','source_sha256')):
        inputs.bind(mesh['gas_support_blockers'][f], mesh['gas_support_blockers'][h])
    proof['mesh'] = mesh
    _slices(inputs, mesh)
    _views(inputs)
    for width in (85,87):
        _endpoint(inputs, width, proof)
    _oxygen(inputs)
    drivers = inputs.read(PROOFS/'thickness-drivers/board-thickness-drivers.json')
    _require(drivers['status'] == 'selected_driver_shafts_clear' and drivers['source_manifest'] == incoming and
        drivers['source_state_preserved'] is True and sorted(t['finished_board_thickness_mm'] for t in drivers['tests']) ==
        [1.44,1.44,1.76,1.76] and all(t['shaft_diameter_mm'] == 5 and t['shaft_length_mm'] == 50 for t in drivers['tests']),
        'Final four thickness-driver cases failed')
    screw_names = {p['paired_screw'] for p in retained['m2_pairs'] if 'PcbX' in p['position_expressions'][0]}
    _clear(drivers['tests'], {'MainM2driver '+name+' thickness'+str(thickness)
        for name in screw_names for thickness in (1.44,1.76)})
    if require_capture:
        final = inputs.read(PROOFS/'final-validation.json')
        required = {p:h for p,h in inputs.hashes.items() if Path(p) != PROOFS/'final-validation.json'}
        _require(final['pass'] is True and final['status'] == 'fresh_final0962_proofs_bound_to_restored_native_state' and
            final['board_sha256'] == BOARD and final['step_sha256'] == STEP and final['source_version_preserved'] == 10 and
            final['source_id'] == retained['export']['source_id'] and final['proof_sha256'] == required and
            final['source_sha256_after'] == required and final['source_and_protected_documents_preserved'] is True,
            'Final captured proof/source state changed')
        _state_contract(final['state'], proof); proof['final'] = final
    inputs.unchanged(); proof.update(hashes=inputs.hashes, dependencies=sorted(inputs.dependencies))
    return proof


def _visibility_state(design):
    """Primitive visibility identity; no entity-token or Python-wrapper equality."""
    return dict(occurrences={o.fullPathName:bool(o.isLightBulbOn) for o in design.rootComponent.allOccurrences},
        bodies={c.id+':'+str(i):bool(b.isLightBulbOn) for c in design.allComponents for i,b in enumerate(c.bRepBodies)},
        sections=[dict(name=a.name, visible=bool(a.isLightBulbOn)) for a in design.analyses.sectionAnalyses],
        analysis_folder=bool(design.analyses.isLightBulbOn))


def _state(design):
    """Full prior geometry state plus persistent source, occurrence and datum metadata."""
    from runtime import attrs
    state = prior._state(design); root = design.rootComponent
    state['root_attributes'] = attrs(root)
    state['component_sources'] = {c.id:dict(name=c.name, part_number=c.partNumber, attributes=attrs(c))
        for c in design.allComponents if c.id != root.id}
    state['occurrence_bindings'] = {o.fullPathName:dict(component_id=o.component.id,
        local_pose=list((o.nativeObject or o).transform2.asArray()), grounded_to_parent=bool((o.nativeObject or o).isGroundToParent),
        grounded=bool((o.nativeObject or o).isGrounded), attributes=attrs(o.nativeObject or o)) for o in root.allOccurrences}
    state['joint_details'] = [dict(name=j.name, suppressed=bool(j.isSuppressed),
        object_type=j.objectType, timeline_index=j.timelineObject.index, joint_type=int(j.jointMotion.jointType)) for j in root.joints]
    state['joint_origins'] = [dict(name=o.name, object_type=o.objectType, timeline_index=o.timelineObject.index,
        expressions=[o.offsetX.expression,o.offsetY.expression,o.offsetZ.expression]) for o in root.jointOrigins]
    state['visibility'] = _visibility_state(design)
    return state


def _state_contract(state, proof):
    baseline = proof['proposal']['source_state']
    retained = proof['retained']['export']['state']
    # Guard the import boundary as well as the later carrier-only boundary.
    main_prefix = next(iter(retained['main_descendants'])).split('+',1)[0]+'+'
    key = lambda r:(r['component_id'], r['occurrence'], r['body_index'])
    kept = lambda rows:{key(r):r for r in rows if not (r['occurrence'] or '').startswith(main_prefix)
        and r['component'] != CARRIER_NAME}
    _require(kept(state['bodies']) == kept(retained['bodies']) and len(kept(retained['bodies'])) == 198 and
        {n:v for n,v in state['poses'].items() if not n.startswith(main_prefix)} ==
        {n:v for n,v in retained['poses'].items() if not n.startswith(main_prefix)} and
        all(state['parameters'].get(n) == e for n,e in retained['parameters'].items()),
        'Import changed preserved v10 hardware, purchased solids, poses or parameters')
    raw = json.dumps({k:state[k] for k in baseline}, sort_keys=True, separators=(',',':')).encode()
    _require(hashlib.sha256(raw).hexdigest() == proof['mesh']['native_state_sha256'],
        'Full source state differs from independently exported native mesh handoff')
    _require(state['timeline'] == 1211 and all(state['parameters'].get(n) == e for n,e in baseline['parameters'].items()) and
        state['poses'] == baseline['poses'] and state['joints'] == baseline['joints'] and
        state['main_descendants'] == baseline['main_descendants'], 'State changed beyond the two carrier cuts')
    _require(state['parameters']['CaseWidth'] == '85 mm' and state['parameters']['PcbWidth'] == '30 mm' and
        state['parameters']['PcbX'] == 'CaseWidth - PcbWidth - 4.6 mm', 'Restored fixed-width PCB datum contract changed')
    expected = baseline['bodies']; actual = state['bodies']
    _require(len(actual) == len(expected) == 2546, 'Full native body inventory changed')
    for a,b in zip(actual,expected):
        _require({k:v for k,v in a.items() if k != 'volume_mm3'} == {k:v for k,v in b.items() if k != 'volume_mm3'},
            'Body identity/bounds changed: '+str(a['occurrence']))
        volume = proof['applied']['actual_carrier_volume_mm3'] if a['component'] == CARRIER_NAME else b['volume_mm3']
        _require(math.isfinite(a['volume_mm3']) and abs(a['volume_mm3']-volume) <= 1e-5, 'Unreviewed native body volume change')
    _require(state['joints'] == retained['joints'], 'Retained hardware joint names/endpoints changed')
    sources = state['component_sources']; main = [q for q in sources.values() if q['part_number'] == 'TMX-A3-B01']
    usb = [q for q in sources.values() if q['part_number'] == 'TMX-A3-B02']
    for rows,spec in ((main,proof['incoming']['main']),(usb,proof['incoming']['usb'])):
        _require(len(rows) == 1 and rows[0]['attributes']['TrimixSystemReview/source_step_sha256'] == spec['sha256'],
            'Native main/USB source identity changed')
    for number in ('TMX-A3-B01','TMX-A3-B02'):
        ids = {identifier for identifier,row in sources.items() if row['part_number'] == number}
        wrappers = [name for name,row in state['occurrence_bindings'].items() if row['component_id'] in ids]
        _require(len(wrappers) == 1, 'Expected unique installed board wrapper')
        children = [row for name,row in state['occurrence_bindings'].items() if name.startswith(wrappers[0]+'+')]
        _require(children and all(row['grounded_to_parent'] for row in children), 'Purchased board descendants are not rigidly grounded')
    carrier = [q for q in sources.values() if q['name'] == CARRIER_NAME]
    marker = json.loads(carrier[0]['attributes']['TrimixSystemReview/local_refinement_carrier'])
    _require(len(carrier) == 1 and marker['source_board_sha256'] == BOARD and marker['proposal_sha256'] == CUT and
        marker['cut_count'] == 2, 'Native carrier marker changed')
    origins = [q for q in state['joint_origins'] if q['name'] == 'SystemReview main PCB stack datum']
    _require(len(origins) == 1 and origins[0]['expressions'] == ['PcbX','PcbY + PcbHeight','PcbZ + 0.0529 mm'] and
        all(not q['suppressed'] for q in state['joint_details']), 'Native joints/origin changed')


def _markers(design, proof):
    inserts._markers(design, dict(pairs=proof['retained']['pairs'], width_digest=proof['width_digest'],
        retained=dict(pairs=proof['retained']['m2_pairs'])))


def capture_validated_state():
    """Parent calls serially after all final checks/restoration. No trials or edits."""
    path = PROOFS/'final-validation.json'; _require(not path.exists(), 'Preserve existing validation capture')
    proof = _proofs(False); app, doc, design = prior._native()
    _markers(design,proof); state = _state(design); _state_contract(state,proof)
    others = prior._documents(app,doc); modified = doc.isModified
    _require(doc.dataFile.id == proof['retained']['export']['source_id'] and doc.dataFile.versionNumber == 10,
        'Final capture requires owned unsaved changes on preserved v10')
    after = {p:_sha(p) for p in proof['hashes']}
    preserved = state == _state(design) and others == prior._documents(app,doc) and modified == doc.isModified
    _require(preserved and after == proof['hashes'], 'Capture/source/protected state drift')
    result = dict(status='fresh_final0962_proofs_bound_to_restored_native_state', board_sha256=BOARD, step_sha256=STEP,
        source_version_preserved=10, source_id=doc.dataFile.id, state=state, protected_documents=others,
        proof_sha256=proof['hashes'], source_sha256_after=after, source_and_protected_documents_preserved=preserved,
        capture_scope='Hashes bracket this serial capture after endpoint/O2/thickness checks; not retroactive trial-start hashes.',
        W85_scope='Read-only full assessment and exact state preservation; no width-change Boolean claim.',
        W87_scope='Actual width change, purchased geometry and restoration proofs.', physical_or_manufacturing_release=False, limits=LIMITS)
    result['pass'] = True; _write(path,result); return result


def _snapshot(proof):
    files, dependencies = [], []
    for name,digest in sorted(proof['hashes'].items()):
        original = Path(name); raw = original.read_bytes()
        _require(hashlib.sha256(raw).hexdigest() == digest, 'Snapshot source drift: '+name)
        row = dict(original=name, sha256=digest, bytes=len(raw))
        if name in proof['dependencies']:
            dependencies.append(row); continue
        _require('bound-inputs' not in original.parts, 'Do not recursively archive previous input trees')
        target = TARGET/'bound-inputs'/original.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        with target.open('xb') as stream: stream.write(raw)
        _require(_sha(target) == digest, 'Snapshot copy failed')
        row['snapshot'] = str(target.relative_to(TARGET)); files.append(row)
    _require(all(_sha(p) == h for p,h in proof['hashes'].items()), 'Source changed during snapshot')
    _write(TARGET/'bound-inputs-map.json', dict(files=files, dependencies=dependencies,
        source_file_count=len(files)+len(dependencies), board_sha256=BOARD, step_sha256=STEP))
    return _sha(TARGET/'bound-inputs-map.json')


def save_final():
    """Export native first, then request new cloud version; preserve v10 and all other documents."""
    _require(not TARGET.exists(), 'Preserve existing final checkpoint directory')
    proof = _proofs(); app, doc, design = prior._native(); _markers(design,proof)
    state = _state(design); others = prior._documents(app,doc)
    _require(state == proof['final']['state'] and others == proof['final']['protected_documents'] and
        doc.dataFile.id == proof['final']['source_id'] and doc.dataFile.versionNumber == 10,
        'Save requires exact captured source and protected documents on v10')
    TARGET.mkdir(exist_ok=False); mapping = _snapshot(proof); native = TARGET/ARCHIVE
    _require(design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native))), 'Native export failed')
    with zipfile.ZipFile(native) as archive: _require(archive.testzip() is None, 'Native archive CRC failed')
    _require(state == _state(design) and others == prior._documents(app,doc) and
        all(_sha(p) == h for p,h in proof['hashes'].items()), 'Export changed source or proof; cloud save blocked')
    _write(TARGET/'export.json', dict(native_archive=str(native), sha256=_sha(native), state=state,
        source_version=10, source_id=doc.dataFile.id, protected_documents=others, proof_sha256=proof['hashes'],
        bound_inputs_map_sha256=mapping, board_sha256=BOARD, step_sha256=STEP, limits=LIMITS))
    _require(doc.save('Final0962 local routed PCB and reviewed carrier apertures; exact M2/M3 inserts retained. W85 read-only fit, W87 regeneration, both oxygen variants, sampled service and nominal thickness/driver checks passed. Digital review checkpoint only; physical fit, seals, wiring, threads and production/order release remain unqualified.'), 'Cloud save request failed')
    _require(state == _state(design) and others == prior._documents(app,doc) and
        all(_sha(p) == h for p,h in proof['hashes'].items()), 'Save changed source/protected state')
    result = dict(status='save_requested_final_local_digital_review_not_release', source_version_preserved=10,
        expected_cloud_version=11, cloud_id=doc.dataFile.id, cloud_version_observed=doc.dataFile.versionNumber,
        native_archive=str(native), native_sha256=_sha(native), export_sha256=_sha(TARGET/'export.json'),
        bound_inputs_map_sha256=mapping, board_sha256=BOARD, step_sha256=STEP, physical_or_manufacturing_release=False)
    _write(TARGET/'checkpoint.json', result); return result


def _checkpoint():
    receipt = json.loads((TARGET/'checkpoint.json').read_bytes())
    _require(_sha(TARGET/'export.json') == receipt['export_sha256'], 'Export receipt changed')
    export = json.loads((TARGET/'export.json').read_bytes()); native = TARGET/ARCHIVE
    _require(Path(receipt['native_archive']).resolve() == native == Path(export['native_archive']).resolve() and
        _sha(native) == receipt['native_sha256'] == export['sha256'] and
        receipt['board_sha256'] == export['board_sha256'] == BOARD and receipt['step_sha256'] == export['step_sha256'] == STEP,
        'Native checkpoint identity changed')
    _require(_sha(TARGET/'bound-inputs-map.json') == receipt['bound_inputs_map_sha256'] == export['bound_inputs_map_sha256'], 'Snapshot map changed')
    mapping = json.loads((TARGET/'bound-inputs-map.json').read_bytes()); rows = mapping['files']+mapping['dependencies']
    _require(mapping['source_file_count'] == len(rows) == len(export['proof_sha256']) and
        len({r['original'] for r in rows}) == len(rows), 'Snapshot source coverage changed')
    for row in rows:
        if 'snapshot' in row:
            path = (TARGET/row['snapshot']).resolve()
            _require(path.is_relative_to(TARGET/'bound-inputs'), 'Snapshot escaped checkpoint')
        else:
            path = Path(row['original']).resolve()
            _require(_dependency_allowed(path), 'Invalid retained dependency path')
        _require(export['proof_sha256'].get(row['original']) == row['sha256'] and path.stat().st_size == row['bytes'] and
            _sha(path) == row['sha256'], 'Bound input/dependency missing or changed')
    return receipt, export


def verify_final():
    """Reopen only our unsaved archive copy, compare full state, close it and reactivate source."""
    _require(not (TARGET/'native-reopen.json').exists(), 'Preserve reopen receipt')
    receipt, export = _checkpoint(); app, doc, design = prior._native()
    before = _state(design); others = prior._documents(app,doc); modified = doc.isModified
    document_identity = lambda q:(q.name, q.dataFile.id if q.dataFile else None)
    old_documents = [document_identity(q) for q in app.documents]
    temporary = None; own = False; result = None
    try:
        import adsk.fusion as fusion
        temporary = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(TARGET/ARCHIVE)))
        own = bool(temporary and not temporary.isSaved and not temporary.dataFile and
            app.documents.count == len(old_documents)+1 and document_identity(temporary) not in old_documents)
        _require(own, 'Expected our own new unsaved archive document')
        imported = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        _require(imported is not None, 'Native archive lacks design')
        state = _state(imported)
        result = dict(native_sha256=receipt['native_sha256'], matches={k:state[k] == v for k,v in export['state'].items()},
            native_health_pass=True, bound_inputs_verified=True, current_source_matches_checkpoint=before == export['state'])
    finally:
        closed = activated = False
        try:
            if own:
                closed = bool(temporary.close(False)); _require(closed, 'Cannot close own archive copy')
        finally:
            try:
                activated = bool(doc.activate()); _require(activated, 'Cannot reactivate owned source')
            finally:
                preserved = before == _state(design) and others == prior._documents(app,doc) and modified == doc.isModified
                if result is not None:
                    result.update(temporary_closed_without_save=closed, source_reactivated=activated,
                        source_and_protected_documents_preserved=preserved)
                _require(preserved, 'Archive reopen changed source/protected documents')
    _require(_checkpoint() == (receipt,export), 'Archive/input drift during reopen')
    _require(result is not None, 'No reopened state')
    result['pass'] = closed and activated and preserved and all(result['matches'].values())
    _write(TARGET/'native-reopen.json',result); _require(result['pass'], 'Archive state mismatch'); return result


def status_final():
    receipt, export = _checkpoint(); app, doc, design = prior._native()
    result = dict(cloud_id=doc.dataFile.id, cloud_version=doc.dataFile.versionNumber,
        cloud_data_complete=doc.dataFile.isComplete, document_modified=doc.isModified,
        source_matches_export=_state(design) == export['state'], native_sha256=receipt['native_sha256'],
        bound_inputs_verified=True, protected_documents_preserved=prior._documents(app,doc) == export['protected_documents'],
        physical_or_manufacturing_release=False)
    result['new_cloud_version_complete'] = (result['cloud_id'] == receipt['cloud_id'] and result['cloud_version'] == 11 and
        result['cloud_data_complete'] and not result['document_modified'] and result['source_matches_export'] and result['protected_documents_preserved'])
    return result


def status_receipt():
    result = status_final(); stamp = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ')
    path = TARGET/('cloud-status-'+stamp+'.json'); _write(path,result)
    if result['new_cloud_version_complete'] and (TARGET/'native-reopen.json').exists() and not (TARGET/'summary.json').exists():
        reopen = json.loads((TARGET/'native-reopen.json').read_bytes())
        _require(reopen['pass'] is True and reopen['native_sha256'] == result['native_sha256'], 'Reopen must pass before summary')
        _write(TARGET/'summary.json', dict(status='saved_and_reopened_final_local_digital_review_checkpoint',
            board_sha256=BOARD, source_step_sha256=STEP, native_sha256=result['native_sha256'], cloud_version=11,
            cloud_status_receipt=str(path), source_and_file_manifest=str(TARGET/'bound-inputs-map.json'),
            W85_scope='Read-only final assessment', W87_scope='Actual width trial and restoration',
            reviewed_diagnostic_material_projects=8, diagnostic_print_release=False,
            historical_R301_exception_allowed=False, physical_or_manufacturing_release=False, limits=LIMITS,
            files={str(p.relative_to(TARGET)):_sha(p) for p in sorted(TARGET.iterdir()) if p.is_file()}))
    return result


def export_step():
    """Default AO2 assembly from an owned archive copy; never dirty the saved source.

    Only physical occurrence/body visibility is adjusted on that disposable
    copy. The three exact JJ comparative solids remain in the editable F3D.
    STEP reimport/equivalence is a separate parent-run assessment.
    """
    path = TARGET/ARCHIVE.replace('.f3d','.step'); receipt_path = TARGET/'step-export.json'
    _require(not path.exists() and not receipt_path.exists(), 'Preserve prior STEP export')
    receipt, export = _checkpoint(); status = status_final()
    reopened = json.loads((TARGET/'native-reopen.json').read_bytes())
    _require(status['new_cloud_version_complete'] and reopened['pass'] is True and
        reopened['native_sha256'] == receipt['native_sha256'], 'STEP requires exact completed and reopened native checkpoint')
    app, doc, design = prior._native(); state = _state(design); others = prior._documents(app,doc); modified = doc.isModified
    document_identity = lambda q:(q.name, q.dataFile.id if q.dataFile else None)
    old_documents = [document_identity(q) for q in app.documents]
    temporary = None; own = False; result = None
    try:
        import adsk.fusion as fusion
        import audit_a3 as audit
        temporary = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(TARGET/ARCHIVE)))
        own = bool(temporary and not temporary.isSaved and not temporary.dataFile and
            app.documents.count == len(old_documents)+1 and document_identity(temporary) not in old_documents)
        _require(own, 'Expected own new unsaved STEP-export archive copy')
        copied = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        _require(copied is not None and _state(copied) == export['state'], 'STEP export copy differs from native archive')
        refs = [o for o in copied.rootComponent.occurrences if o.component.partNumber == 'REF-JJ-O2']
        _require(len(refs) == 1, 'Expected one explicit JJ alternative occurrence')
        ref = refs[0]; attrs = {a.groupName+'/'+a.name:a.value for a in ref.component.attributes}
        _require(attrs['TrimixRev04/physical_group'] == 'alternative_oxygen_reference' and
            attrs['TrimixRev04/geometry_role'] == 'configuration_reference' and
            attrs['TrimixSystemReview/exclude_from_default_physical_assembly'] == 'true', 'JJ exclusion metadata changed')
        instances = list(audit._instances(copied))
        _require(len(instances) == 2546 and all(b.isSolid for o,c,i,b in instances), 'Expected 2546 placed native solids')
        excluded = [(o,c,i,b) for o,c,i,b in instances if o and o.fullPathName == ref.fullPathName]
        _require(len(excluded) == ref.component.bRepBodies.count == 3, 'Only the three JJ comparative solids may be excluded')
        expected_names = {'Sensor / AO2 dry body with wetted threaded nose','Sensor / AO2 cable connector allowance'}
        _require(len([1 for o,c,i,b in instances if c.name in expected_names]) == 2 and
            {c.name for o,c,i,b in instances if c.name in expected_names} == expected_names, 'Default AO2 body/connector coverage changed')
        for component in copied.allComponents:
            for body in component.bRepBodies:
                if not body.isLightBulbOn: body.isLightBulbOn = True
        for occurrence in copied.rootComponent.allOccurrences:
            if not occurrence.isLightBulbOn: occurrence.isLightBulbOn = True
        ref.isLightBulbOn = False
        visible = [(o,c,i,b) for o,c,i,b in instances if b.isVisible]
        _require(len(visible) == 2543 and all(not b.isVisible for o,c,i,b in excluded) and
            all(b.isVisible for o,c,i,b in instances if not o or o.fullPathName != ref.fullPathName),
            'Some physical solids are hidden, or JJ reference solids remain visible')
        _require(copied.exportManager.execute(copied.exportManager.createSTEPExportOptions(str(path),copied.rootComponent)), 'STEP export failed')
        _require(path.stat().st_size > 0, 'Empty STEP export')
        result = dict(file=str(path), sha256=_sha(path), native_sha256=receipt['native_sha256'], board_sha256=BOARD,
            source_step_sha256=STEP, units='native mm export; no scaling', expected_physical_solids=2543,
            all_expected_physical_solids_visible=True, default_oxygen_configuration='AO2 body and connector included',
            excluded_JJ_reference_solids=[dict(occurrence=o.fullPathName,body_index=i,name=b.name) for o,c,i,b in excluded],
            visibility_changes_scope='Own unsaved archive copy only; original saved source untouched.',
            STEP_reimport_or_per_body_equivalence_verified=False, physical_or_manufacturing_release=False, limits=LIMITS)
    finally:
        closed = activated = False
        try:
            if own:
                closed = bool(temporary.close(False)); _require(closed, 'Cannot close own STEP-export copy')
        finally:
            try:
                activated = bool(doc.activate()); _require(activated, 'Cannot reactivate saved source after STEP export')
            finally:
                preserved = state == _state(design) and others == prior._documents(app,doc) and modified == doc.isModified
                _require(preserved and _checkpoint() == (receipt,export), 'STEP export changed source, visibility or protected state')
                if result is not None:
                    result.update(source_state_preserved=preserved, source_visibility_preserved=True,
                        source_modified_flag_preserved=True, temporary_closed_without_save=closed, source_reactivated=activated)
    _require(result is not None and closed and activated, 'STEP export/cleanup did not complete')
    _write(receipt_path,result); return result
