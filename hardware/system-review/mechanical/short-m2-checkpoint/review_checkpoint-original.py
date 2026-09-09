"""Parent-reviewed M2 checkpoint API: save_m2(), verify_m2(), status_m2().

Import is offline-safe. Only explicit API calls access Fusion. No geometry edits,
automatic adoption, output overwrites, or mass/physical-qualification claims.
"""
from pathlib import Path
import hashlib
import json
import math
import zipfile

BASE = Path(__file__).resolve().parents[1]
PROOFS = BASE / 'verification/short-m2-implementation'
TARGET = BASE / 'short-m2-checkpoint'
APPROVED = '5bedc48c0226e6822b8fe5d2813a7520f025da666fddb8bf855ba65fecaa45ca'
INSERT = 'd63e8b5b81a9fc0e61255214afb673a78d7ae7a189ccbde9d55f5a58ed4e678d'
EXIT = '7976cded17aca71f3398440c3855cbb396e2de42b7ffbe696d6078bd00953b54'
FAILED_MATERIAL = '447f689de4c73365dd691cc6823e5c8da4b73319c7b7ce0d726f0f2e9e8e6246'
OLD_MAIN = 'bb3473f6b223e3f762e067c0f4af2c91c42548e4f2be2c63c10befc6c45885dd'
PATH_FILE = 'service-paths-cover-disconnect-battery-carrier-chamber-retainers-display-usb.json'
INSTALLED_TESTS = {name+str(t) for t in (1.6, 1.76) for name in (
    'Main maximum/allocation bounds finished thickness', 'J301 provisional mate finished thickness',
    'J301 inward cable/turn allocation finished thickness')} | {
    'J301 provisionalsocket axial6.1mm disengagement atmaximumPCBthickness',
    'USB maxima and unmeasured harness allocation', 'J402 supplemental drawing-tolerance tails'}
THIN_TESTS = {'Main maximum/allocation finished thickness1.44mm',
              'J301 mate finished thickness1.44mm', 'J301 cable/turn finished thickness1.44mm'}
MATE_TESTS = {'J301 provisional mate finished thickness1.6', 'J301 provisional mate finished thickness1.76',
              'J301 provisionalsocket axial6.1mm disengagement atmaximumPCBthickness', 'J301 mate finished thickness1.44mm'}


def _require(value, message):
    if not value:
        raise RuntimeError(message)


def _sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _baseline_bodies_match(actual, expected):
    """One-to-one identities plus mm/mm³ tolerance, not a mass estimate."""
    if len(actual) != len(expected):
        return False
    for a, b in zip(actual, expected):
        if any(a[k] != b[k] for k in ('name', 'component', 'occurrence')):
            return False
        if abs(a['volume_mm3']-b['volume_mm3']) > 1e-5 or any(
                abs(x-y) > 1e-5 for av, bv in zip(a['bounds_mm'], b['bounds_mm']) for x, y in zip(av, bv)):
            return False
    return True


def _health(value):
    _require(value['pass'] is True and not value['unhealthy_entities'] and
             not value['under_constrained_sketches'], 'Native health failed or incomplete')


def _empty_tests(tests, count=None):
    _require(bool(tests) and (count is None or len(tests) == count), 'Missing/extra tests')
    _require(all(t['collision_count'] == 0 and t['collisions'] == [] for t in tests),
             'Unresolved test intersection')


def _thickness(data, main_sha=None, main_pairs=None):
    _require(data['status'] == 'selected_thickness_cases_geometrically_clear' and
             all(data[k] is True for k in ('nominal_pose_preflight_passed',
                 'source_state_preserved', 'persistent_geometry_unchanged')), 'Thickness proof failed')
    _require(sorted(c['finished_board_thickness_mm'] for c in data['cases']) == [1.44, 1.6, 1.76],
             'Thickness cases changed')
    screws = {q['occurrence'] for q in data['measured_nominal_screws']}
    inserts = {q['occurrence'] for q in data['measured_fixed_inserts']}
    _require(len(screws) == len(inserts) == 2, 'Nominal fastener identities changed')
    if main_sha is not None:
        _require(len(data['installed_main_sources']) == 1 and
                 data['installed_main_sources'][0]['source_step_sha256'] == main_sha, 'Thickness source mismatch')
    for case in data['cases']:
        _require(len(case['pairs']) == 2 and {p['screw'] for p in case['pairs']} == screws and
                 {p['insert'] for p in case['pairs']} == inserts, 'Expected both unique main PCB screw pairs')
        for p in case['pairs']:
            _require(main_pairs is None or main_pairs.get(p['screw']) == p['insert'], 'Assigned screw/insert changed')
            _require(p['status'] == 'selected_geometric_checks_passed' and p['same_insert_as_nominal']
                     and p['engagement_meets_one_nominal_diameter'] and p['coaxial_offset_mm'] <= .02
                     and p['tip_clearance']['passes_selected_nominal_gap']
                     and p['moved_screw_solid_collisions'] == [], 'Thickness screw check failed')


def _heatsets(data, pairs, expected):
    hits = data['engaged_heatset_interfaces']
    _require(data['collisions'] == [] and data['all_positive_intersection_count'] == 10 and
             len(hits) == 10, 'Require exactly ten classified pairs and zero unrelated intersections')
    by_name = {p['occurrence']: p for p in pairs}
    seen = set()
    for hit in hits:
        p = hit['explicit_interface']; name = p['occurrence']
        _require(name in by_name and name not in seen, 'Unexpected/duplicate insert overlap')
        seen.add(name)
        labels = (hit['one'], hit['two'])
        _require(any(label.startswith(name+' / ') for label in labels) and
                 any(label.startswith(p['host']+':1 / ') for label in labels), 'Raw hit differs from classified pair')
        _require(all(p[k] == by_name[name][k] for k in ('old_occurrence', 'host', 'paired_screw',
                     'position_expressions')), 'Heat-set pair binding changed')
        volume = expected[p['old_occurrence']]
        _require(math.isfinite(hit['volume_mm3']) and abs(hit['volume_mm3']-volume) < 1e-4 and
                 abs(hit['expected_transient_volume_mm3']-volume) < 1e-9, 'Heat-set overlap volume changed')
    _require(seen == set(by_name), 'Incomplete heat-set witness')


def _allocations(tests, main_sha, names=None):
    """Only the parent-approved historical placement-v2 mate allocation may remain."""
    _require(bool(tests), 'Missing allocation tests')
    if names is not None:
        _require(len(tests) == len(names) and {t['name'] for t in tests} == names, 'Allocation test coverage changed')
    for test in tests:
        _require(test['collision_count'] == len(test['collisions']), 'Filtered allocation report')
        _require(len(test['collisions']) <= 1, 'Duplicate/unexpected allocation conflicts')
        for h in test['collisions']:
            _require(main_sha == OLD_MAIN and test['name'] in MATE_TESTS and
                     h['moving'] == 'MAX/J301_MATED_PROVISIONAL / J301_MATED_PROVISIONAL maximum/allocation' and
                     h['fixed'] == 'MAX_MAIN/R301 / R301 maximum/allocation envelope' and
                     abs(h['volume_mm3']-.2135625) < 1e-6, 'Unapproved maximum-envelope conflict')


def _proofs():
    """Read-only offline gate. Missing endpoint/approval evidence blocks saving."""
    hashes = {}
    def read(path, digest=None):
        path = Path(path).resolve(); raw = path.read_bytes()
        actual = hashlib.sha256(raw).hexdigest()
        _require(digest is None or actual == digest, 'Source/receipt hash changed: '+str(path))
        hashes[str(path)] = actual
        return json.loads(raw)
    spec = read(BASE/'verification/cnckitchen-m2-proposal.json', APPROVED)
    for name, digest in spec['source_sha256'].items():
        _require(_sha(name) == digest, 'Approved source changed: '+name)
        hashes[name] = digest
    read(BASE/'verification/width-contract-proposal.json')
    incoming = read(BASE/'verification/incoming-boards.json')
    main_sha = incoming['main']['sha256']
    for source in (incoming['main'], incoming['usb']):
        for filename, digest in (('file', 'sha256'), ('height_contract_file', 'height_contract_sha256')):
            _require(_sha(source[filename]) == source[digest], 'Incoming source hash changed')
            hashes[str(Path(source[filename]).resolve())] = source[digest]
    applied = read(PROOFS/'applied.json')
    _require(applied['proposal_sha256'] == APPROVED and applied['source_step_sha256'] == INSERT and
             applied['source_version_preserved'] == 8 and applied['occurrence_poses_and_binding_attributes_unchanged']
             and applied['unchanged_physical_solids']['pass'], 'Applied M2 identity/invariant failed')
    _health(applied['health'])
    pairs = applied['interfaces']; _require(len(pairs) == len({p['occurrence'] for p in pairs}) == 10, 'M2 count changed')
    main_pairs = {p['paired_screw']: p['occurrence'] for p in pairs if 'PcbX' in p['position_expressions'][0]}
    _require(len(main_pairs) == 2, 'Expected two source-bound PCB fastener pairs')
    material = read(PROOFS/'baseline/actual-M2-material.json')
    rows = material['interfaces']
    _require(len(rows) == 10 and {r['insert'] for r in rows} == {p['occurrence'] for p in pairs}, 'Material coverage changed')
    bad = [r for r in rows if not r['pass']]
    for r in rows:
        _require(r['native_axis_and_pose_error_mm'] <= .02 and len(r['radial_sections']) == 4 and
                 all(q['minimum_sampled_lower_mm'] >= 1.999 for q in r['radial_sections']), 'Material radial/axis failure')
    if bad or material['status'] != 'selected_actual_material_passed':
        _require(hashes[str((PROOFS/'baseline/actual-M2-material.json').resolve())] == FAILED_MATERIAL and
                 len(bad) == 1 and bad[0]['insert'] == 'M2 insert — CNC Kitchen TC-M2x3.0:1' and
                 bad[0]['expected_open_end'] is True and bad[0]['opening_below_pilot_is_void'] is False,
                 'Only the frozen lower-PCB partly-open exit is reviewed')
        exit_proof = read(PROOFS/'lower-pilot-exit-disposition.json', EXIT)
        _require(exit_proof['status'] == 'accepted_geometric_partly_open_pilot' and exit_proof['pass'] and
                 exit_proof['source_preserved'] and not exit_proof['geometry_changed'] and
                 exit_proof['lower_PCB_insert_face_mm'] == [76, 28, 18.5] and
                 exit_proof['full_unobstructed_circular_depth_lower_bound_mm'] >= 4 and
                 Path(exit_proof['failed_stricter_control_retained']).resolve() ==
                     (PROOFS/'baseline/actual-M2-material.json').resolve(), 'Exit disposition failed')
    summary = read(PROOFS/'baseline/summary.json'); _health(summary['health'])
    _require(summary['source_preserved'] and summary['gas_pass'] and summary['hole_axes']['pass'] and
             summary['hole_axes']['carrier_lumps'] == summary['hole_axes']['housing_lumps'] == 1 and
             summary['fastener_status'] == 'selected_thickness_cases_geometrically_clear', 'Baseline failed')
    _require(read(PROOFS/'baseline/gas.json')['pass'], 'Gas receipt failed')
    mechanical = read(PROOFS/'baseline/mechanical-audit.json'); _health(mechanical['health'])
    _require(mechanical['status'] == 'bounded_checks_clear' and mechanical['collisions'] == [] and
             mechanical['real_nonhealthy_timeline_entities'] == [], 'Baseline mechanical failure')
    _thickness(read(PROOFS/'baseline/board-thickness-fasteners.json'), main_sha, main_pairs)
    evaluation = read(BASE/'verification/cnckitchen-m2-proposal-evaluation.json')
    expected = {q['insert']: q['exact_candidate_host_heatset_overlap'][0]['volume_mm3'] for q in evaluation['interfaces']}
    for width in (85, 87):
        folder = PROOFS/'width-tests'/('W'+str(width))
        trial = read(folder/'trial-summary.json'); t, r = trial['trial'], trial['restoration']
        _require(t['width_mm'] == width and t['core_width_contract_pass'] and
                 t['all_main_children_rigid_local_poses_preserved'] and t['actual_hole_alignment']['pass'] and
                 t['selected_sections']['pass'] and t['purchased_geometry']['pass'], 'Width trial failed')
        _health(t['health']); _health(r['health'])
        _require(all(r[k] for k in ('compute_success', 'all_parameter_expressions_restored',
                 'timeline_unchanged', 'other_documents_preserved')) and
                 r['all_physical_geometry_restored']['pass'], 'Width restoration failed')
        actual = read(folder/'final-integrated-clearance.json'); _health(actual['health'])
        _require(actual['source_state_preserved'] and not actual['geometry_scaled'] and
                 actual['source_manifest'] == incoming, 'Clearance state/source changed')
        _heatsets(actual['actual_cross_assembly'], pairs, expected)
        _require(len(actual['tests']) == 9, 'Allocation coverage changed')
        _allocations(actual['tests'], main_sha, INSTALLED_TESTS)
        thin = read(folder/'minimum-thickness-allocations.json')
        _allocations(thin['tests'], main_sha, THIN_TESTS)
        paths = read(folder/PATH_FILE)
        _require(paths['status'] == 'sampled_paths_clear_with_prerequisites' and paths['persistent_geometry_unchanged'] and
                 {q['name'] for q in paths['tests']} == {'cover','disconnect','battery','carrier','chamber','retainers','display','usb'},
                 'Service path coverage/status failed')
        _empty_tests(paths['tests'], 8)
        retained = next(q for q in paths['tests'] if q['name'] == 'retainers')
        _require({q['name'] for q in retained['subtests']} == {'upper_staged', 'lower_after_upper'}, 'Retainer sequence missing')
        _empty_tests(retained['subtests'], 2)
        drivers = read(folder/'service-drivers.json')
        _require(drivers['status'] == 'clear_for_nominal_shafts' and drivers['persistent_geometry_unchanged'] and
                 drivers['screw_occurrence_count'] == len({q['occurrence'] for q in drivers['tests']}) == 14, 'Driver coverage failed')
        _empty_tests(drivers['tests'], 14); _thickness(read(folder/'board-thickness-fasteners.json'), main_sha, main_pairs)
    stricter = read(PROOFS/'retainer-full-allocations-W85/service-paths-retainers.json')
    _require(stricter['status'] == 'sampled_paths_clear_with_prerequisites' and
             stricter['persistent_geometry_unchanged'] and stricter['timeline_count'] == mechanical['timeline'] and
             [t['name'] for t in stricter['tests']] == ['retainers'], 'Stricter W85 retainer receipt failed')
    _empty_tests(stricter['tests'], 1)
    subtests = stricter['tests'][0]['subtests']
    _require({q['name'] for q in subtests} == {'upper_staged', 'lower_after_upper'}, 'Stricter retainer sequence changed')
    _empty_tests(subtests, 2)
    _require(all(_sha(p) == h for p, h in hashes.items()), 'Inputs changed while reading proofs')
    return dict(hashes=hashes, applied=applied, mechanical=mechanical, pairs=pairs,
                expected=expected, main_sha=main_sha, incoming=incoming, material_exception=bool(bad))


def _native():
    from runtime import owned, configure
    app, doc, design = owned(); configure()
    return app, doc, design


def _state(design):
    import audit_a3 as audit
    import step_a3 as step
    import review_checks as review
    from width_contract_proposal import _main, _children
    parent = _main(design); children = _children(design, parent)
    joints = [{'name': j.name, 'one': j.occurrenceOne.fullPathName if j.occurrenceOne else None,
               'two': j.occurrenceTwo.fullPathName if j.occurrenceTwo else None} for j in design.rootComponent.joints]
    descendants = {o.fullPathName: {'local_pose': (o.nativeObject or o).transform2.asArray(),
                   'grounded_to_parent': bool((o.nativeObject or o).isGroundToParent)} for o in children}
    _require(children and all(q['grounded_to_parent'] for q in descendants.values()) and
             sum(j['name'] == 'SystemReview main PCB parametric placement' and j['one'] == parent.fullPathName
                 for j in joints) == 1, 'Main rigid descendant/joint contract failed')
    _health(review.health(design))
    return {'bodies': audit._bodies(design), 'poses': step._poses(design),
            'parameters': {p.name: p.expression for p in design.allParameters}, 'timeline': design.timeline.count,
            'joints': joints, 'main_descendants': descendants}


def _documents(app, owned_doc):
    """Includes every other document, even another SystemReview-named document."""
    return [{'name': q.name, 'id': q.dataFile.id if q.dataFile else None, 'modified': q.isModified}
            for q in app.documents if q != owned_doc]


def _write(path, data):
    with path.open('x') as output:
        output.write(json.dumps(data, indent=2)+'\n')


def save_m2():
    """Export then request a new cloud version; explicit parent-reviewed call only."""
    _require(not TARGET.exists(), 'Preserve existing checkpoint folder; no overwrite')
    proof = _proofs(); app, doc, design = _native()
    from runtime import GROUP, bounds
    import review_checks as review
    from short_m2_validation import adapted, interfaces
    from width_contract_checks import datums, hole_axes, _inputs
    root = design.rootComponent
    marker = lambda name: root.attributes.itemByName(GROUP, name)
    for name, value in (('short_m2_proposal_sha256', APPROVED), ('short_m2_source_sha256', INSERT),
                        ('width_contract_manifest_sha256', _sha(BASE/'verification/width-contract-proposal.json'))):
        _require(marker(name) and marker(name).value == value, 'Native marker mismatch: '+name)
    _require(doc.dataFile.versionNumber == 8 and design.timeline.count == proof['applied']['timeline_after'] ==
             proof['mechanical']['timeline'], 'Source must remain the reviewed unsaved M2 changes on v8')
    datum = datums(); _require(abs(datum['CaseWidth']-85) < 1e-6 and
                              abs(datum['PcbX']-(85-30-4.6)) < 1e-6, 'Restored width failed')
    pairs = interfaces()
    for actual, expected in zip(pairs, proof['pairs']):
        _require(all(actual[k] == expected[k] for k in expected if k != 'pilot_type'), 'Native interface identity changed')
        wanted = 'partly_open_non_gas' if proof['material_exception'] and actual['occurrence'].endswith(':1') else expected['pilot_type']
        _require(actual['pilot_type'] == wanted, 'Native pilot classification must match approved disposition')
    before = _state(design); others = _documents(app, doc)
    with adapted(TARGET):
        _require(_inputs() == proof['incoming'], 'Live installed source identity/pose differs from proofs')
        axes = hole_axes()
        _require(axes['pass'] and axes['carrier_lumps'] == axes['housing_lumps'] == 1, 'Current M2 mounting axes failed')
        manager, rows = review.records()
        physical = [r for r in rows if r['physical_group'] != 'alternative_oxygen_reference']
        witness = review.collision_report(manager, physical)
    _heatsets(witness, pairs, proof['expected'])
    current = [{'name': r['name'], 'component': r['component'], 'occurrence': r['occurrence'],
                'bounds_mm': bounds(r['body']), 'volume_mm3': r['body'].volume*1000} for r in physical]
    _require(_baseline_bodies_match(current, proof['mechanical']['bodies']), 'Current solids differ from checked baseline')
    _require(before == _state(design) and others == _documents(app, doc) and
             all(_sha(p) == h for p, h in proof['hashes'].items()), 'Preflight/source drift')
    TARGET.mkdir(parents=False, exist_ok=False)
    native = TARGET/'Trimix_Enclosure_A3_SystemReview_ShortM2.f3d'
    _require(design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native))), 'Native export failed')
    with zipfile.ZipFile(native) as archive:
        _require(archive.testzip() is None, 'Native archive CRC failed')
    _require(before == _state(design) and others == _documents(app, doc) and
             all(_sha(p) == h for p, h in proof['hashes'].items()), 'Export/source/proof drift; cloud save blocked')
    _write(TARGET/'export.json', {'native_archive': str(native), 'sha256': _sha(native), 'state': before,
                                'source_version': 8, 'source_id': doc.dataFile.id, 'proof_sha256': proof['hashes'],
                                'native_heatset_witness': witness, 'protected_documents': others})
    _require(doc.save('Reviewed short TC-M2x3.0 intermediate checkpoint; exact ten heat-set interfaces, restored85mm and W85/W87 service checks. Lower PCB pilot is partly open. Historical placement-v2 R301/J301 allocation remains; routed PCB, M3 and physical qualification pending.'), 'Cloud save request failed')
    _require(before == _state(design) and others == _documents(app, doc), 'Save altered source/protected state')
    result = {'status': 'save_requested_short_m2_intermediate_not_release', 'source_version_preserved': 8,
              'cloud_id': doc.dataFile.id, 'cloud_version_observed': doc.dataFile.versionNumber,
              'native_archive': str(native), 'native_sha256': _sha(native), 'export_sha256': _sha(TARGET/'export.json'),
              'proposal_sha256': APPROVED, 'exit_disposition_sha256': EXIT if proof['material_exception'] else None,
              'historical_main_step_sha256': proof['main_sha'], 'physical_or_manufacturing_release': False}
    _write(TARGET/'checkpoint.json', result); print(json.dumps(result)); return result


def verify_m2():
    """Reopen only our archive as an unsaved temporary, compare, close only it."""
    _require(not (TARGET/'native-reopen.json').exists(), 'Preserve existing reopen receipt')
    receipt = json.loads((TARGET/'checkpoint.json').read_text()); export = json.loads((TARGET/'export.json').read_text())
    native = Path(receipt['native_archive'])
    _require(native.resolve() == (TARGET/'Trimix_Enclosure_A3_SystemReview_ShortM2.f3d').resolve() and
             _sha(native) == receipt['native_sha256'] == export['sha256'] and
             _sha(TARGET/'export.json') == receipt['export_sha256'], 'Checkpoint identity changed')
    app, doc, design = _native(); before = _state(design); others = _documents(app, doc); modified = doc.isModified
    _require(before == export['state'], 'Current source differs from exported checkpoint')
    prior_documents = list(app.documents)
    temporary = None; own_temporary = False; result = None
    try:
        import adsk.fusion as fusion
        temporary = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(native)))
        own_temporary = bool(temporary and not temporary.isSaved and all(temporary != q for q in prior_documents))
        _require(own_temporary, 'Expected our own newly created unsaved inspection copy')
        imported = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        _require(imported is not None, 'Archive lacks design')
        after = _state(imported)
        result = {'native_sha256': _sha(native), 'matches': {key: after[key] == before[key] for key in before},
                  'native_health_pass': True, 'temporary_closed_without_save': False}
    finally:
        closed = False
        try:
            if own_temporary:
                closed = bool(temporary.close(False))
                _require(closed, 'Cannot close our inspection copy')
        finally:
            try:
                _require(doc.activate(), 'Cannot reactivate owned source')
            finally:
                preserved = before == _state(design) and others == _documents(app, doc) and modified == doc.isModified
                if result is not None:
                    result.update(temporary_closed_without_save=closed, source_and_protected_documents_preserved=preserved)
                    result['pass'] = closed and preserved and all(result['matches'].values())
                    _write(TARGET/'native-reopen.json', result)
                _require(preserved, 'Native reopen changed original/protected state')
    _require(result and result['pass'], 'Reopened checkpoint mismatch'); print(json.dumps(result)); return result


def status_m2():
    """Read-only cloud completion query; no output file is overwritten."""
    receipt = json.loads((TARGET/'checkpoint.json').read_text())
    app, doc, design = _native(); state = _state(design)
    export = json.loads((TARGET/'export.json').read_text())
    result = {'cloud_id': doc.dataFile.id, 'cloud_version': doc.dataFile.versionNumber,
              'cloud_data_complete': doc.dataFile.isComplete, 'document_modified': doc.isModified,
              'source_matches_export': state == export['state'], 'native_sha256_matches': _sha(receipt['native_archive']) == receipt['native_sha256'],
              'protected_documents_preserved': _documents(app, doc) == export['protected_documents'],
              'physical_or_manufacturing_release': False}
    result['new_cloud_version_complete'] = (result['cloud_id'] == receipt['cloud_id'] and result['cloud_version'] > 8 and
        result['cloud_data_complete'] and not result['document_modified'] and result['source_matches_export'] and
        result['native_sha256_matches'] and result['protected_documents_preserved'])
    print(json.dumps(result)); return result
