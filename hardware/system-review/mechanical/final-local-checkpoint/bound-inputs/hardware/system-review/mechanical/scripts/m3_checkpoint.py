"""Explicit parent-reviewed exact-insert checkpoint; import and _proofs are offline.

save_m3()/verify_m3()/status_m3() alone access Fusion. No geometry changes,
overwrite, automatic adoption, or physical/manufacturing release. New M3 endpoint
proofs are required; retained M2 v9 evidence only establishes the prior baseline.
"""
from pathlib import Path
import hashlib
import json
import math
import zipfile
import review_checkpoint as prior

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
PROOFS = BASE/'verification/m3-implementation'
CANDIDATE = BASE/'verification/m3-candidate'
M2 = BASE/'short-m2-checkpoint'
TARGET = BASE/'exact-inserts-checkpoint'
ARCHIVE = 'Trimix_Enclosure_A3_SystemReview_ExactInserts.f3d'
APPROVED = '2e7f1b8ecf0a297322b3078df0882faa5a82a8f94236847e65178f67870e40ea'
INSERT = '9a9e695a44e1136ed39daa1b194bfff6342266593b003778e6307485c29edc37'
REVIEW = 'c3f14fe655dca0bf80772732eb47560f30bdf2617dd046eba64d7fb16d2c18fd'
M2_REVIEW = '394d44900415bccb1ca79542524e8b832846ed050c9e997aef9d280e936286ca'
M2_MAP = 'bf4967bff8d5fed908d89b679f0cfbe46ff592decf56a3f288aea1052bc26dab'
M2_NATIVE = '83270277664d9981b3d538d50971d0ee9288fa12d5ac8d2c35a303412b813927'
_require, _sha, _write = prior._require, prior._sha, prior._write


class _Inputs:
    def __init__(self):
        self.hashes = {}

    def bind(self, path, digest=None, parse=False):
        path = Path(path)
        path = (path if path.is_absolute() else ROOT/path).resolve()
        _require(path.is_relative_to(ROOT), 'Proof/source outside workspace: '+str(path))
        raw = path.read_bytes(); actual = hashlib.sha256(raw).hexdigest()
        _require(digest is None or actual == digest, 'Bound input changed: '+str(path))
        _require(str(path) not in self.hashes or self.hashes[str(path)] == actual,
                 'Input changed during proof collection: '+str(path))
        self.hashes[str(path)] = actual
        return json.loads(raw) if parse else actual

    def read(self, path, digest=None):
        return self.bind(path, digest, True)

    def mapping(self, values):
        for name, digest in values.items():
            self.bind(name, digest)

    def unchanged(self):
        _require(all(_sha(p) == h for p, h in self.hashes.items()), 'Proof/source drift')


def _small(value):
    return isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and 0 <= value < 1e-5


def _close(actual, expected):
    return len(actual) == len(expected) and all(math.isfinite(a) and abs(a-b) <= 1e-6 for a,b in zip(actual,expected))


def _positive(value):
    return isinstance(value, (int, float)) and math.isfinite(value) and value > 1e-5


def _unique(rows, field, expected):
    _require(len(rows) == len(expected) and {r[field] for r in rows} == set(expected), 'Missing/duplicate interface: '+field)
    return {r[field]: r for r in rows}


def _face(pair, width):
    x, y, z = pair['face_mm_at_W85']
    return [x+(width-85 if x == 77 else 0), y, z]


def _material(data, pairs, width):
    _require(data['pass'] is True and data['proposal_sha256'] == APPROVED and
             data['source_step_sha256'] == INSERT and abs(data['width_mm']-width) <= 1e-6 and
             data['housing_solid_lumps'] == 1 and data['whole_assembly_minimum_wall_proven'] is False and
             data['physical_thread_retention_or_torque_qualified'] is False, 'Actual native M3 material/source gate failed')
    by_name = {p['occurrence']: p for p in pairs}
    rows = _unique(data['interfaces'], 'insert', by_name)
    hosts = data['heatset_interfaces']
    _require(len(hosts) == 4 and len({h['explicit_interface']['occurrence'] for h in hosts}) == 4,
             'Require four unique M3 pilot displacement proofs')
    hosts = {h['explicit_interface']['occurrence']: h for h in hosts}
    threads = _unique(data['thread_interfaces'], 'insert', by_name)
    _require(set(hosts) == set(by_name), 'M3 host coverage changed')
    for name, pair in by_name.items():
        row, host, thread = rows[name], hosts[name], threads[name]
        face = _face(pair, width); z = face[2]
        annulus, bore, floor = row['whole_crest_annulus'], row['full_circular_pilot_depth'], row['preserved_annular_floor']
        _require(row['pass'] is True and _close(row['face_mm'], face) and
                 annulus['pass'] is True and annulus['radii_mm'] == [2.5,4.5] and annulus['Z_mm'] == [z-4,z] and
                 _small(annulus['missing_material_mm3']) and bore['pass'] is True and bore['nominal_mm'] == 5 and
                 bore['proved_interior_depth_mm'] >= 4.9998 and bore['actual_surface_depth_mm'] >= 5-1e-5 and
                 abs(bore['actual_surface']['radius_mm']-2.2) < 1e-5 and bore['probe_radius_mm'] == 2.1999 and bore['intersections'] == [] and
                 floor['pass'] is True and floor['radii_mm'] == [1.6001,2.1999] and floor['Z_mm'] == [z-7,z-5] and
                 floor['nominal_thickness_mm'] == 2 and _small(floor['missing_material_mm3']) and
                 row['tip_probe']['passes_selected_nominal_gap'] is True, 'M3 annulus/pilot/floor/tip failed: '+name)
        _require(host['pass'] is True and host['explicit_interface'] == pair and host['source_step_sha256'] == INSERT and
                 host['pilot_radius_mm'] == 2.2 and host['source_crest_radius_mm'] == 2.5 and
                 host['expected_Z_mm'] == [z-4,z] and host['boolean_boundary_padding_mm'] == .0001 and
                 _positive(host['volume_mm3']) and _small(host['outside_expected_displacement_band_mm3']) and
                 host['one'].startswith(name+' / ') and host['two'].startswith(pair['host']+':1 / '),
                 'M3 pilot heat-set pair/confinement changed: '+name)
        band, root = thread['expected_engagement_annulus'], thread['shaft_within_manufacturer_thread_root_envelope']
        _require(thread['screw'] == pair['paired_screw'] and thread['source_step_sha256'] == INSERT and
                 _close(thread['face_mm'], face) and thread['pass_representation_confinement'] is True and
                 thread['physical_thread_engagement_qualified'] is False and _positive(thread['explicit_intersection_volume_mm3']) and
                 band['inner_radius_mm'] == 1.2645 and band['outer_radius_mm'] == 1.45 and band['Z_mm'] == [z-4,z] and
                 band['boolean_boundary_padding_mm'] == .0001 and _small(band['intersection_outside_band_mm3']) and
                 root['source_root_radius_mm'] == 1.543 and root['actual_smooth_shaft_radius_mm'] == 1.45 and
                 _small(root['shaft_outside_root_envelope_mm3']) and thread['nominal_axial_overlap_mm'] == 4,
                 'M3 exact shaft/thread representation confinement failed: '+name)
    return hosts, threads


def _intersections(data, material, pairs, m2_pairs, m2_expected, width):
    _require(data['collisions'] == [] and data['all_positive_intersection_count'] == 18,
             'Require 10 M2 + 4 M3 pilot + 4 M3 thread pairs and zero unrelated intersections')
    prior._heatsets(dict(data, all_positive_intersection_count=10), m2_pairs, m2_expected)
    hosts, threads = _material(material, pairs, width)
    for key, expected, identity in (('M3_heatset_interfaces', hosts, lambda q:q['explicit_interface']['occurrence']),
                                     ('M3_thread_representation_interfaces', threads, lambda q:q['insert'])):
        hits = data[key]; seen = set()
        _require(len(hits) == 4, 'M3 collision classification count changed')
        for hit in hits:
            proof = hit['confinement']; name = identity(proof)
            _require(name in expected and name not in seen and proof == expected[name] and _positive(hit['volume_mm3']),
                     'M3 raw collision not bound to exact material proof')
            seen.add(name); labels = (hit['one'], hit['two'])
            second = proof['explicit_interface']['host']+':1' if key == 'M3_heatset_interfaces' else proof['screw']
            _require(any(s.startswith(name+' / ') for s in labels) and any(s.startswith(second+' / ') for s in labels),
                     'M3 raw pair differs from confined pair')
        _require(seen == set(expected), 'M3 classified pair coverage changed')


def _retained_m2(inputs):
    approval = inputs.read(M2/'root-archive-review.json', M2_REVIEW)
    _require(approval['status'] == 'passed_digitally_for_saved_M2_checkpoint_only' and
             approval['native_sha256'] == M2_NATIVE and approval['all_34_archived_inputs_match'] is True and
             approval['zip_crc_bad_member'] is None and all(approval['input_checks'].values()), 'M2 v9 root archive review failed')
    checkpoint = inputs.read(M2/'checkpoint.json')
    export = inputs.read(M2/'export.json', checkpoint['export_sha256'])
    _require(export['sha256'] == checkpoint['native_sha256'] == M2_NATIVE and export['state']['timeline'] == 1201,
             'Retained M2 native archive identity changed')
    native = M2/'Trimix_Enclosure_A3_SystemReview_ShortM2.f3d'
    _require(Path(checkpoint['native_archive']).resolve() == native.resolve(), 'M2 archive path changed')
    inputs.bind(native, M2_NATIVE)
    reopen = inputs.read(M2/'native-reopen.json', approval['native_reopen_receipt_sha256'])
    _require(reopen['pass'] is True and all(reopen['matches'].values()) and reopen['native_sha256'] == M2_NATIVE,
             'Retained M2 archive reopen failed')
    cloud = inputs.read(M2/'cloud-status-20260908T005623Z.json', approval['cloud_v9_receipt_sha256'])
    _require(cloud['new_cloud_version_complete'] is True and cloud['cloud_version'] == 9 and cloud['cloud_id'] == export['source_id'],
             'M2 v9 cloud checkpoint not complete')
    mapping = inputs.read(M2/'bound-inputs-map.json', M2_MAP)
    _require(mapping['source_export_sha256'] == checkpoint['export_sha256'] and mapping['source_file_count'] == len(mapping['files']) == 34,
             'M2 input snapshot coverage changed')
    originals = {}
    for row in mapping['files']:
        path = (M2/row['snapshot']).resolve()
        _require(path.is_relative_to(M2/'bound-inputs') and path.stat().st_size == row['bytes'], 'M2 snapshot path/size changed')
        inputs.bind(path, row['sha256']); originals[row['original']] = path
    _require(len(originals) == 34, 'Duplicate M2 snapshot original')
    def frozen(path):
        return inputs.read(originals[str(path.resolve())])
    applied = frozen(BASE/'verification/short-m2-implementation/applied.json')
    evaluation = frozen(BASE/'verification/cnckitchen-m2-proposal-evaluation.json')
    expected = {q['insert']:q['exact_candidate_host_heatset_overlap'][0]['volume_mm3'] for q in evaluation['interfaces']}
    return dict(export=export, pairs=applied['interfaces'], expected=expected)


def _oxygen(inputs):
    directory = PROOFS/'oxygen-variants'; summary = inputs.read(directory/'summary.json')
    _require(summary['pass'] is True and summary['restored_compute'] is True and
             summary['all_physical_geometry_restored']['pass'] is True and summary['all_parameters_and_poses_restored'] is True and
             summary['source_and_protected_documents_preserved'] is True and summary['source_files_unchanged'] is True,
             'Oxygen variant native restoration/source gate failed')
    prior._health(summary['health']); inputs.mapping(summary['source_sha256'])
    outcomes = _unique(summary['tests'], 'width_mm', (85,87))
    for width,row in outcomes.items():
        path = directory/('W'+str(width))/'oxygen-variant-checks.json'
        _require(Path(row['report']).resolve() == path.resolve() and row['pass'] is True and
                 row['status'] == 'bounded_reference_checks_clear', 'Oxygen endpoint identity/status failed')
        data = inputs.read(path,row['sha256'])
        _require(data['status'] == 'bounded_reference_checks_clear' and data['AO2_geometry_scaled'] is False and
                 data['manufacturing_or_seal_qualification'] is False and {q['name'] for q in data['tests']} ==
                 {'JJ dry-body and provisional cable installed','JJ closed sampling cartridge rear removal'},
                 'Oxygen endpoint scope changed')
        prior._empty_tests(data['tests'],2)


def _proofs(require_capture=True):
    """Offline complete M3 gate; final-validation.json must bind fresh endpoint states."""
    inputs = _Inputs()
    for directory in (BASE/'scripts', ROOT/'hardware/cad/rev04/scripts'):
        for path in sorted(directory.glob('*.py')):
            inputs.bind(path)
    spec = inputs.read(CANDIDATE/'proposal.json', APPROVED); inputs.mapping(spec['source_sha256'])
    approval = inputs.read(CANDIDATE/'root-adoption-review.json', REVIEW)
    _require(approval['status'] == 'approved_for_guarded_native_implementation_and_regeneration_checks_only' and
             approval['proposal_sha256'] == APPROVED and approval['eight_changes'] == spec['parameter_changes'] and
             approval['four_unscaled_manufacturer_insert_models'] is True and
             approval['existing_screw_and_exterior_geometry_preserved'] is True and approval['order_release'] is False,
             'Root native M3 adoption scope changed')
    for path, key in ((CANDIDATE/'transient-core.json','core_sha256'),
                      (CANDIDATE/'service-and-thread/summary.json','service_sha256')):
        inputs.mapping(inputs.read(path, approval[key])['source_sha256'])
    note = inputs.read(CANDIDATE/'thread-source-note.json'); inputs.mapping(note['local_source_sha256'])
    inputs.bind(CANDIDATE/'thread-source-note.md', note['note_markdown_sha256'])
    retained = _retained_m2(inputs)
    incoming = inputs.read(BASE/'verification/incoming-boards.json')
    width_digest = inputs.bind(BASE/'verification/width-contract-proposal.json')
    for source in (incoming['main'], incoming['usb']):
        inputs.bind(source['file'], source['sha256']); inputs.bind(source['height_contract_file'], source['height_contract_sha256'])
    applied = inputs.read(PROOFS/'applied.json'); pairs = applied['interfaces']
    started = inputs.read(PROOFS/'apply-started.json')
    _require(started['source_version'] == 9 and started['source_timeline'] == 1201 and
             started['root_review_sha256'] == REVIEW and started['proposal_sha256'] == APPROVED and
             started['parameter_changes'] == spec['parameter_changes'], 'Actual apply-start source changed')
    _require(applied['pass'] is True and applied['proposal_sha256'] == APPROVED and applied['root_review_sha256'] == REVIEW and
             applied['source_step_sha256'] == INSERT and applied['source_version_preserved'] == 9 and
             applied['timeline_before'] == 1201 and applied['timeline_after'] == 1203 and
             applied['parameter_changes'] == spec['parameter_changes'] and len(applied['parameter_changes']) == 8 and
             applied['stable_part_id'] == 'TMX-A3-F04' and applied['source_model']['scale'] == [1,1,1] and
             applied['source_model']['source_step_sha256'] == INSERT and
             applied['occurrence_poses_and_binding_attributes_unchanged'] is True and
             applied['unchanged_physical_solids']['pass'] is True and
             applied['native_housing_matches_reviewed_transient']['pass'] is True, 'Applied native M3 identity/invariants failed')
    prior._health(applied['health'])
    _unique(pairs, 'old_occurrence', [p['original_occurrence'] for p in spec['candidate_placements_for_later_review']])
    _require(len({p['occurrence'] for p in pairs}) == len({p['paired_screw'] for p in pairs}) == 4, 'M3 occurrence/screw count changed')
    placements = {p['original_occurrence']:p for p in spec['candidate_placements_for_later_review']}
    for pair in pairs:
        placement = placements[pair['old_occurrence']]; index = pair['old_occurrence'].rsplit(':',1)[1]
        face = placement['open_face_mm_at_width85']
        expected_expressions = ['CaseWidth-8 mm' if face[0] == 77 else '8 mm',
                                'CaseHeight-8 mm' if face[1] == 172 else '8 mm', 'CaseDepth-4 mm']
        _require(pair['occurrence'] == 'M3 insert — CNC Kitchen VORON M3x5x4:'+index and
                 pair['face_mm_at_W85'] == face and pair['paired_screw'] == placement['paired_screw'] and
                 pair['host'] == '01 Shape A housing' and pair['position_expressions'] == expected_expressions,
                 'Applied source-bound M3 interface mapping changed')
    exact = _unique(applied['native_inserts_match_reviewed_transients'], 'occurrence', [p['occurrence'] for p in pairs])
    _require(all(q['match']['pass'] is True for q in exact.values()), 'Actual manufacturer geometry mismatch')
    main_pairs = {p['paired_screw']:p['occurrence'] for p in retained['pairs'] if 'PcbX' in p['position_expressions'][0]}
    material85 = None
    for width in (85,87):
        folder = PROOFS/'width-tests'/('W'+str(width)); trial = inputs.read(folder/'trial-summary.json')
        t, r = trial['trial'], trial['restoration']; prior._health(t['health']); prior._health(r['health'])
        _require(t['width_mm'] == width and abs(t['datums']['CaseWidth']-width) <= 1e-6 and t['core_width_contract_pass'] is True and
                 t['all_main_children_rigid_local_poses_preserved'] is True and t['actual_hole_alignment']['pass'] is True and
                 t['selected_sections']['pass'] is True and t['selected_sections']['M3_actual_material_pass'] is True and
                 t['selected_sections']['gas_pass'] is True and t['purchased_geometry']['pass'] is True and
                 all(r[k] is True for k in ('compute_success','all_parameter_expressions_restored','timeline_unchanged','other_documents_preserved')) and
                 r['all_physical_geometry_restored']['pass'] is True, 'Fresh M3 width/restoration failed')
        material = inputs.read(folder/'native-M3-material.json'); _material(material, pairs, width)
        _require(inputs.read(folder/'gas.json')['pass'] is True, 'Fresh width gas geometry failed')
        actual = inputs.read(folder/'final-integrated-clearance.json'); prior._health(actual['health'])
        _require(actual['source_state_preserved'] is True and actual['geometry_scaled'] is False and
                 actual['source_manifest'] == incoming, 'Fresh integrated clearance source changed')
        _intersections(actual['actual_cross_assembly'], material, pairs, retained['pairs'], retained['expected'], width)
        prior._allocations(actual['tests'], incoming['main']['sha256'], prior.INSTALLED_TESTS)
        prior._allocations(inputs.read(folder/'minimum-thickness-allocations.json')['tests'], incoming['main']['sha256'], prior.THIN_TESTS)
        paths = inputs.read(folder/prior.PATH_FILE)
        _require(paths['status'] == 'sampled_paths_clear_with_prerequisites' and paths['persistent_geometry_unchanged'] is True and
                 paths['timeline_count'] == 1203 and {t['name'] for t in paths['tests']} ==
                 {'cover','disconnect','battery','carrier','chamber','retainers','display','usb'}, 'Fresh M3 service coverage/status failed')
        prior._empty_tests(paths['tests'], 8)
        subtests = next(t for t in paths['tests'] if t['name'] == 'retainers')['subtests']
        _require({t['name'] for t in subtests} == {'upper_staged','lower_after_upper'}, 'Retainer sequence missing')
        prior._empty_tests(subtests, 2)
        drivers = inputs.read(folder/'service-drivers.json')
        _require(drivers['status'] == 'clear_for_nominal_shafts' and drivers['persistent_geometry_unchanged'] is True and
                 drivers['timeline_count'] == 1203 and drivers['screw_occurrence_count'] ==
                 len({t['occurrence'] for t in drivers['tests']}) == 14, 'Fresh M3 driver coverage/status failed')
        prior._empty_tests(drivers['tests'], 14)
        prior._thickness(inputs.read(folder/'board-thickness-fasteners.json'), incoming['main']['sha256'], main_pairs)
        if width == 85:
            material85 = material
    _oxygen(inputs)
    result = dict(hashes=inputs.hashes, applied=applied, pairs=pairs, retained=retained, incoming=incoming,
                  width_digest=width_digest, material85=material85)
    if require_capture:
        final = inputs.read(PROOFS/'final-validation.json')
        _require(final['status'] == 'fresh_endpoint_proofs_bound_to_restored_native_state' and
                 final['pass'] is True and final['proposal_sha256'] == APPROVED and final['source_step_sha256'] == INSERT and
                 final['source_version_preserved'] == 9 and final['source_id'] == retained['export']['source_id'] and
                 final['timeline'] == 1203 and final['width_mm'] == 85 and final['source_and_protected_documents_preserved'] is True and
                 final['source_sha256_before'] == final['source_sha256_after'], 'Final native validation binding failed')
        required = {p:h for p,h in inputs.hashes.items() if Path(p) != PROOFS/'final-validation.json'}
        _require(final['proof_sha256'] == required and final['source_sha256_before'] == required,
                 'Final validation lacks exact fresh proof/source/script coverage')
        inputs.mapping(final['proof_sha256']); prior._health(final['health'])
        _state_contract(final['state'], result)
        result['final'] = final
    inputs.unchanged()
    return result


def _state_contract(state, proof):
    baseline = proof['retained']['export']['state']
    parameters = dict(baseline['parameters'])
    for row in proof['applied']['parameter_changes']:
        parameters[row['name']] = row['proposed_expression']
    _require(state['timeline'] == 1203 and state['parameters'] == parameters,
             'Current model differs beyond eight approved native parameters')
    rename = {p['old_occurrence']:p['occurrence'] for p in proof['pairs']}
    expected_poses = {rename.get(name,name):pose for name,pose in baseline['poses'].items()}
    expected_joints = [dict(q, one=rename.get(q['one'],q['one']), two=rename.get(q['two'],q['two']))
                       for q in baseline['joints']]
    _require(state['joints'] == expected_joints and state['poses'] == expected_poses and state['main_descendants'] == baseline['main_descendants'],
             'Rigid source or main descendant poses changed')
    _require(len(state['bodies']) == len(baseline['bodies']) and
             sum(r['component'] == '01 Shape A housing' for r in state['bodies']) == 1 and
             len([r for r in state['bodies'] if r['occurrence'] in rename.values()]) == 4,
             'Native physical body/instance counts changed')
    def unchanged(rows, excluded):
        return [r for r in rows if r['component'] != '01 Shape A housing' and r['occurrence'] not in excluded]
    actual = unchanged(state['bodies'],set(rename.values())); expected = unchanged(baseline['bodies'],set(rename))
    _require(len(actual) == len(expected), 'Unrelated body coverage changed')
    for a,b in zip(actual,expected):
        metadata = lambda r:{k:v for k,v in r.items() if k not in ('bounds_mm','volume_mm3')}
        _require(metadata(a) == metadata(b) and math.isfinite(a['volume_mm3']) and
                 abs(a['volume_mm3']-b['volume_mm3']) <= 1e-5 and
                 all(_close(a['bounds_mm'][key],b['bounds_mm'][key]) for key in ('min','max','size')),
                 'Physical solid outside housing/four M3 instances changed: '+a['occurrence'])


def capture_validated_state():
    """Explicit serial call after endpoint and oxygen restoration; never runs trials.

    Binds completed fresh endpoints and current source/script bytes before and
    after this capture. This does not claim those hashes were sampled before
    the earlier trials. Parent must keep serial ownership between trial/capture.
    """
    path = PROOFS/'final-validation.json'
    _require(not path.exists(), 'Preserve final validated-state receipt; no overwrite')
    proof = _proofs(require_capture=False); app, doc, design = prior._native()
    import review_checks as review
    from width_contract_checks import datums, _inputs
    _markers(design,proof); before = prior._state(design); others = prior._documents(app,doc); modified = doc.isModified
    _state_contract(before, proof)
    _require(doc.dataFile.versionNumber == 9 and doc.dataFile.id == proof['retained']['export']['source_id'] and
             _inputs() == proof['incoming'] and abs(datums()['CaseWidth']-85) < 1e-6,
             'Require restored native M3 source on retained v9 with exact incoming boards')
    health = review.health(design); prior._health(health)
    after_hashes = {p:_sha(p) for p in proof['hashes']}
    preserved = before == prior._state(design) and others == prior._documents(app,doc) and modified == doc.isModified
    _require(preserved and after_hashes == proof['hashes'], 'Validated-state capture/source drift')
    result = dict(status='fresh_endpoint_proofs_bound_to_restored_native_state', pass_=True,
                  proposal_sha256=APPROVED, source_step_sha256=INSERT, source_version_preserved=9,
                  source_id=doc.dataFile.id, timeline=1203, width_mm=85, state=before, health=health,
                  proof_sha256=proof['hashes'], source_sha256_before=proof['hashes'], source_sha256_after=after_hashes,
                  source_and_protected_documents_preserved=preserved, protected_documents=others,
                  capture_scope='Explicit serial parent call after fresh W85/W87 and oxygen restoration; hashes bracket this capture.',
                  physical_or_manufacturing_release=False)
    result['pass'] = result.pop('pass_')
    _write(path,result); print(json.dumps({'pass':True,'receipt':str(path),'sha256':_sha(path)})); return result


def _snapshot(hashes):
    rows = []
    for name, digest in sorted(hashes.items()):
        original = Path(name); relative = original.resolve().relative_to(ROOT)
        target = TARGET/'bound-inputs'/relative; raw = original.read_bytes()
        _require(hashlib.sha256(raw).hexdigest() == digest, 'Input changed before snapshot: '+name)
        target.parent.mkdir(parents=True, exist_ok=True)
        with target.open('xb') as stream:
            stream.write(raw)
        _require(_sha(target) == digest, 'Input snapshot mismatch')
        rows.append(dict(original=name, snapshot=str(target.relative_to(TARGET)), sha256=digest, bytes=len(raw)))
    _require(all(_sha(p) == h for p,h in hashes.items()), 'Input changed during snapshot')
    _write(TARGET/'bound-inputs-map.json', dict(files=rows, source_file_count=len(rows), proposal_sha256=APPROVED))
    return _sha(TARGET/'bound-inputs-map.json')


def _markers(design, proof):
    from runtime import GROUP
    attrs = design.rootComponent.attributes
    for name, expected in (('m3_proposal_sha256', APPROVED),('m3_source_sha256', INSERT),
                           ('short_m2_proposal_sha256', prior.APPROVED),('short_m2_source_sha256', prior.INSERT),
                           ('short_m2_exit_disposition_sha256', prior.EXIT),
                           ('width_contract_manifest_sha256', proof['width_digest'])):
        item = attrs.itemByName(GROUP,name)
        _require(item and item.value == expected, 'Native source marker mismatch: '+name)
    item = attrs.itemByName(GROUP,'m3_interfaces')
    _require(item and json.loads(item.value) == proof['pairs'], 'Native M3 interface marker changed')
    if 'retained' in proof:
        item = attrs.itemByName(GROUP,'short_m2_interfaces')
        expected = [dict(p, pilot_type='partly_open_non_gas', exit_disposition_sha256=prior.EXIT) if p['occurrence'] ==
                    'M2 insert — CNC Kitchen TC-M2x3.0:1' else p for p in proof['retained']['pairs']]
        _require(item and json.loads(item.value) == expected, 'Retained M2 exact interface/exit classification changed')


def save_m3():
    """Parent-only explicit call: snapshot inputs/export, then request next cloud version."""
    _require(not TARGET.exists(), 'Preserve existing exact-inserts checkpoint; no overwrite')
    proof = _proofs(); app, doc, design = prior._native()
    from width_contract_checks import datums, _inputs
    _markers(design, proof)
    before = prior._state(design); others = prior._documents(app,doc)
    _require(doc.dataFile.versionNumber == 9 and doc.dataFile.id == proof['final']['source_id'] and
             before == proof['final']['state'], 'Current source differs from final validated M3 state on retained v9')
    datum = datums()
    _require(abs(datum['CaseWidth']-85) < 1e-6 and abs(datum['PcbX']-50.4) < 1e-6 and
             _inputs() == proof['incoming'], 'Restored width or installed board sources changed')
    _require(all(_sha(p) == h for p,h in proof['hashes'].items()), 'Proof/source drift before export')
    TARGET.mkdir(parents=False, exist_ok=False); map_hash = _snapshot(proof['hashes'])
    native = TARGET/ARCHIVE
    _require(design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native))), 'Native export failed')
    with zipfile.ZipFile(native) as archive:
        _require(archive.testzip() is None, 'Native archive CRC failed')
    _require(before == prior._state(design) and others == prior._documents(app,doc) and
             all(_sha(p) == h for p,h in proof['hashes'].items()), 'Export/source/proof drift; cloud save blocked')
    _write(TARGET/'export.json', dict(native_archive=str(native), sha256=_sha(native), state=before,
           source_version=9, source_id=doc.dataFile.id, proof_sha256=proof['hashes'], bound_inputs_map_sha256=map_hash,
           native_markers=dict(proposal_sha256=APPROVED, source_step_sha256=INSERT, interfaces=proof['pairs'],
                               width_digest=proof['width_digest'], retained_m2_pairs=proof['retained']['pairs']), protected_documents=others))
    _require(doc.save('Reviewed exact CNC Kitchen M2/M3 inserts; 85/87mm native regeneration, material, service and driver checks. Four M3 nominal shaft/thread representation pairs are source-bound. Historical R301/J301 allocation and physical insert/thread qualification remain explicit; revised routed PCB import pending.'), 'Cloud save request failed')
    _require(before == prior._state(design) and others == prior._documents(app,doc) and
             all(_sha(p) == h for p,h in proof['hashes'].items()), 'Save changed source/protected state or bound inputs')
    result = dict(status='save_requested_exact_inserts_intermediate_not_release', source_version_preserved=9,
                  cloud_id=doc.dataFile.id, cloud_version_observed=doc.dataFile.versionNumber,
                  native_archive=str(native), native_sha256=_sha(native), export_sha256=_sha(TARGET/'export.json'),
                  bound_inputs_map_sha256=map_hash, proposal_sha256=APPROVED, source_step_sha256=INSERT,
                  retained_m2_native_sha256=M2_NATIVE, physical_or_manufacturing_release=False)
    _write(TARGET/'checkpoint.json', result); print(json.dumps(result)); return result


def _checkpoint():
    receipt = json.loads((TARGET/'checkpoint.json').read_bytes()); export_path = TARGET/'export.json'
    _require(_sha(export_path) == receipt['export_sha256'], 'Checkpoint export receipt changed')
    export = json.loads(export_path.read_bytes()); native = TARGET/ARCHIVE
    _require(Path(receipt['native_archive']).resolve() == native.resolve() == Path(export['native_archive']).resolve() and
             _sha(native) == receipt['native_sha256'] == export['sha256'] and receipt['proposal_sha256'] == APPROVED and
             receipt['source_step_sha256'] == INSERT and receipt['retained_m2_native_sha256'] == M2_NATIVE,
             'Checkpoint identity changed')
    mapping_path = TARGET/'bound-inputs-map.json'
    _require(_sha(mapping_path) == receipt['bound_inputs_map_sha256'] == export['bound_inputs_map_sha256'], 'Bound input map changed')
    mapping = json.loads(mapping_path.read_bytes())
    _require(mapping['source_file_count'] == len(mapping['files']) == len(export['proof_sha256']) and
             len({q['original'] for q in mapping['files']}) == len(mapping['files']), 'Bound input coverage changed')
    for row in mapping['files']:
        path = (TARGET/row['snapshot']).resolve()
        _require(path.is_relative_to(TARGET/'bound-inputs') and export['proof_sha256'].get(row['original']) == row['sha256'] and
                 path.stat().st_size == row['bytes'] and _sha(path) == row['sha256'], 'Archived input missing or changed')
    return receipt, export


def verify_m3():
    """Reopen our archive only; historical verification tolerates a later live PCB import."""
    _require(not (TARGET/'native-reopen.json').exists(), 'Preserve existing reopen receipt')
    receipt, export = _checkpoint(); app, doc, design = prior._native()
    before = prior._state(design); others = prior._documents(app,doc); modified = doc.isModified
    old_documents = list(app.documents); temporary = None; own_temporary = False; result = None
    try:
        import adsk.fusion as fusion
        temporary = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(TARGET/ARCHIVE)))
        own_temporary = bool(temporary and not temporary.isSaved and all(temporary != q for q in old_documents))
        _require(own_temporary, 'Expected our own new unsaved inspection document')
        imported = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        _require(imported is not None, 'Archive lacks design')
        markers = export['native_markers']
        _markers(imported, dict(pairs=markers['interfaces'], width_digest=markers['width_digest'],
                                retained=dict(pairs=markers['retained_m2_pairs'])))
        after = prior._state(imported)
        result = dict(native_sha256=receipt['native_sha256'], bound_inputs_verified=True,
                      matches={k:after[k] == value for k,value in export['state'].items()}, native_health_pass=True,
                      current_source_matches_checkpoint=before == export['state'])
    finally:
        closed = False; activated = False
        try:
            if own_temporary:
                closed = bool(temporary.close(False)); _require(closed, 'Cannot close own temporary archive copy')
        finally:
            try:
                activated = bool(doc.activate()); _require(activated, 'Cannot reactivate owned source')
            finally:
                preserved = before == prior._state(design) and others == prior._documents(app,doc) and modified == doc.isModified
                if result is not None:
                    result.update(temporary_closed_without_save=closed, source_reactivated=activated,
                                  source_and_protected_documents_preserved=preserved)
                _require(preserved, 'Archive inspection changed current source/protected documents')
    # A successful receipt is never written while an import/cleanup exception is
    # still propagating, or before the bound archive/input integrity recheck.
    _require(_checkpoint() == (receipt, export), 'Checkpoint inputs changed during archive reopen')
    _require(result is not None, 'No imported archive state captured')
    result['pass'] = closed and activated and preserved and all(result['matches'].values())
    _write(TARGET/'native-reopen.json',result)
    _require(result['pass'], 'Reopened exact-inserts archive mismatch'); print(json.dumps(result)); return result


def status_m3():
    """Read-only completion status; a later import cannot masquerade as this checkpoint."""
    receipt, export = _checkpoint(); app, doc, design = prior._native()
    result = dict(cloud_id=doc.dataFile.id, cloud_version=doc.dataFile.versionNumber,
                  cloud_data_complete=doc.dataFile.isComplete, document_modified=doc.isModified,
                  source_matches_export=prior._state(design) == export['state'], native_sha256_matches=True,
                  bound_inputs_verified=True, protected_documents_preserved=prior._documents(app,doc) == export['protected_documents'],
                  physical_or_manufacturing_release=False)
    result['new_cloud_version_complete'] = (result['cloud_id'] == receipt['cloud_id'] and result['cloud_version'] == 10 and
        result['cloud_data_complete'] and not result['document_modified'] and result['source_matches_export'] and result['protected_documents_preserved'])
    print(json.dumps(result)); return result


def status_receipt():
    from datetime import datetime, timezone
    result = status_m3()
    _write(TARGET/('cloud-status-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')+'.json'), result)
    return result
