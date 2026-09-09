"""Prepared M3 transient core assessment; no operation or Fusion import on import.

evaluate() requires the reviewed, saved/reopened short-M2 checkpoint. It changes
only TemporaryBRep copies, never the eight native parameters or purchased CAD.
Native parameter regeneration and service-path assessment remain separate gates.
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
OUT = BASE/'verification/m3-candidate'
SOURCE = BASE/'components/cnckitchen-m3-review/M3x5x4_VORON_manufacturer.step'
SOURCE_SHA = '9a9e695a44e1136ed39daa1b194bfff6342266593b003778e6307485c29edc37'
PROPOSAL_SHA = '2e7f1b8ecf0a297322b3078df0882faa5a82a8f94236847e65178f67870e40ea'
VOLUME_TOLERANCE_MM3 = 1e-5


def _require(value, message):
    if not value:
        raise RuntimeError(message)


def _sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def _guard():
    import review_checkpoint as checkpoint
    app, doc, design = checkpoint._native()
    _require(_sha(OUT/'proposal.json') == PROPOSAL_SHA and _sha(SOURCE) == SOURCE_SHA, 'M3 source/proposal changed')
    spec = json.loads((OUT/'proposal.json').read_text())
    _require(spec['status'] == 'OFFLINE_PREPARED_FOR_TRANSIENT_ASSESSMENT_NOT_ADOPTED' and
             len(spec['parameter_changes']) == 8, 'M3 scope changed')
    _require(all(_sha(ROOT/path) == digest for path, digest in spec['source_sha256'].items()),
             'M3 proposal dependency changed')
    receipt = json.loads((checkpoint.TARGET/'checkpoint.json').read_text())
    export = json.loads((checkpoint.TARGET/'export.json').read_text())
    reopened = json.loads((checkpoint.TARGET/'native-reopen.json').read_text())
    _require(receipt['proposal_sha256'] == checkpoint.APPROVED and
             _sha(checkpoint.TARGET/'export.json') == receipt['export_sha256'] and
             _sha(receipt['native_archive']) == receipt['native_sha256'] == reopened['native_sha256'] and
             reopened['pass'] and doc.dataFile.id == receipt['cloud_id'] and doc.dataFile.versionNumber > 8 and
             doc.dataFile.isComplete and not doc.isModified, 'Require completed and reopened M2 checkpoint')
    _require(checkpoint._state(design) == export['state'], 'Current source differs from saved M2 checkpoint')
    _require(all(_sha(p) == h for p, h in export['proof_sha256'].items()), 'Saved M2 proof/source files changed')
    for row in spec['parameter_changes']:
        p = design.allParameters.itemByName(row['name']); owner = getattr(p, 'createdBy', None) if p else None
        _require(p and owner and owner.name == row['owner'] and
                 ''.join(p.expression.split()) == ''.join(row['expected_expression'].split()),
                 'Eight-parameter source guard failed: '+row['name'])
    _require(abs(design.userParameters.itemByName('CaseWidth').value*10-85) < 1e-6 and
             abs(design.userParameters.itemByName('CaseDepth').value*10-43) < 1e-6, 'M3 core source requires W85/D43')
    return app, doc, design, spec, receipt


def _official(manager):
    """Copy one unscaled manufacturer solid; close only this new unsaved import."""
    import adsk.core as core
    import adsk.fusion as fusion
    import audit_a3 as audit
    import verification_a3 as v
    import ruthex_m2_audit as rx
    import review_checkpoint as checkpoint
    from runtime import bounds
    app, doc, design = checkpoint._native()
    before = checkpoint._state(design); others = checkpoint._documents(app, doc); modified = doc.isModified
    prior = list(app.documents); temp = None; own_temp = False
    _require(_sha(SOURCE) == SOURCE_SHA, 'Manufacturer STEP changed')
    try:
        options = app.importManager.createSTEPImportOptions(str(SOURCE)); options.isViewFit = False
        temp = app.importManager.importToNewDocument(options)
        own_temp = bool(temp and not temp.isSaved and all(temp != q for q in prior))
        _require(own_temp, 'Expected our new unsaved manufacturer inspection document')
        imported = fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
        _require(imported is not None, 'Manufacturer import lacks design')
        solids = [body for _, _, _, body in audit._instances(imported) if body.isSolid]
        _require(len(solids) == 1, 'Expected one manufacturer solid')
        body = v._world_copy(manager, solids[0]); box = bounds(body)
        _require(body.isTransient and body.isSolid and body.volume > 0 and abs(box[0][2]) < 1e-5 and
                 abs(box[1][2]-4) < 1e-5 and abs(box[0][0]+2.5) < .02 and abs(box[1][0]-2.5) < .02,
                 'Exact M3 source units/datum/bounds changed')
        cones = []
        for face in body.faces:
            cone = core.Cone.cast(face.geometry)
            if cone:
                cones.append({'origin_mm': [q*10 for q in cone.origin.asArray()], 'axis': list(cone.axis.asArray()),
                              'bounds_mm': bounds(face)})
        return body, {'source_step_sha256': SOURCE_SHA, 'bounds_mm': box, 'volume_mm3': body.volume*1000,
                      'face_count': body.faces.count, 'cylinders': rx.cylinders(body), 'cones': cones,
                      'scale': [1, 1, 1], 'internal_thread_role': 'Source geometry; physical mating thread is unqualified'}
    finally:
        try:
            if own_temp:
                _require(temp.close(False), 'Cannot close own manufacturer inspection copy')
        finally:
            try:
                _require(doc.activate(), 'Cannot restore owned SystemReview')
            finally:
                _require(before == checkpoint._state(design) and others == checkpoint._documents(app, doc) and
                         modified == doc.isModified, 'Manufacturer inspection changed source/protected state')


def _ring(manager, x, y, z0, z1, inner, outer):
    import adsk.fusion as fusion
    import ruthex_m2_audit as rx
    ring = rx._cylinder(manager, x, y, z0, z1, outer)
    bore = rx._cylinder(manager, x, y, z0-.01, z1+.01, inner)
    _require(manager.booleanOperation(ring, bore, fusion.BooleanTypes.DifferenceBooleanType), 'Annular tool failed')
    return ring


def _difference_volume(manager, one, two):
    import adsk.fusion as fusion
    copy = manager.copy(one)
    _require(manager.booleanOperation(copy, two, fusion.BooleanTypes.DifferenceBooleanType), 'Transient difference failed')
    return copy.volume*1000


def evaluate(report_name='transient-core.json'):
    """Run only after parent review. No native parameter changes, export or save."""
    _require(Path(report_name).name == report_name and report_name.endswith('.json'), 'Output must be a local JSON filename')
    output = OUT/report_name; _require(not output.exists(), 'Preserve existing M3 report')
    app, doc, design, spec, checkpoint_receipt = _guard()
    import adsk.core as core
    import adsk.fusion as fusion
    import verification_a3 as v
    import review_checks as review
    import review_checkpoint as checkpoint
    import ruthex_m2_audit as rx
    import wall_fastener_checks as fasteners
    import gas_checks_a3 as gas
    import width_contract_checks as width
    from short_m2_validation import adapted
    from runtime import bounds
    before = checkpoint._state(design); others = checkpoint._documents(app, doc); modified = doc.isModified
    source_hashes = {str(OUT/'proposal.json'): PROPOSAL_SHA, str(SOURCE): SOURCE_SHA,
                     str(Path(__file__).resolve()): _sha(__file__),
                     str(checkpoint.TARGET/'checkpoint.json'): _sha(checkpoint.TARGET/'checkpoint.json'),
                     str(checkpoint.TARGET/'export.json'): _sha(checkpoint.TARGET/'export.json'),
                     str(checkpoint.TARGET/'native-reopen.json'): _sha(checkpoint.TARGET/'native-reopen.json')}
    source_hashes.update({str(ROOT/path): digest for path, digest in spec['source_sha256'].items()})
    result = None
    try:
        manager, rows = review.records(); physical = [r for r in rows if r['physical_group'] != 'alternative_oxygen_reference']
        hardware = fasteners._hardware_records(design, rows)
        by_occurrence = {r['occurrence']: r for r in physical}; hw_by_occurrence = {r['occurrence']: r for r in hardware}
        hosts = [r for r in physical if r['component'] == '01 Shape A housing']
        _require(len(hosts) == 1, 'Expected one P01 receiving solid')
        original_host = hosts[0]; host = dict(original_host, body=manager.copy(original_host['body']))
        original, source = _official(manager)
        placements = spec['candidate_placements_for_later_review']
        m3 = [r for r in hardware if r['hardware']['kind'] == 'insert' and r['hardware']['size'] == 'M3']
        _require(len(m3) == 4 and {r['occurrence'] for r in m3} == {p['original_occurrence'] for p in placements}, 'Original M3 instances changed')
        installed = {}; definitions = []
        for placement in placements:
            key = placement['original_occurrence']; old = hw_by_occurrence[key]
            face = old['head_seat_mm']; x, y, z = face
            _require(old['hardware']['length_mm'] == 5 and old['hardware']['outer_diameter_mm'] == 4.2 and
                     old['joint_bound'] and old['target_position_error_mm'] < .001 and
                     max(abs(a-b) for a, b in zip(old['axis'], [0, 0, 1])) < 1e-7 and
                     max(abs(a-b) for a, b in zip(face, placement['open_face_mm_at_width85'])) < 1e-6,
                     'Original M3 source pose/size changed')
            ring = _ring(manager, x, y, 30, 39, 4.2, 4.5)
            _require(manager.booleanOperation(host['body'], ring, fusion.BooleanTypes.UnionBooleanType), 'Cannot add copied-host outer annulus')
            bore = rx._cylinder(manager, x, y, 34, 39.1, 2.2)
            _require(manager.booleanOperation(host['body'], bore, fusion.BooleanTypes.DifferenceBooleanType), 'Cannot enlarge copied-host pilot')
            candidate = manager.copy(original); transform = core.Matrix3D.create()
            transform.translation = core.Vector3D.create(x/10, y/10, (z-4)/10)
            _require(manager.transform(candidate, transform), 'Cannot rigidly place M3 candidate')
            row = dict(by_occurrence[key], body=candidate,
                       hardware=dict(old['hardware'], length_mm=4, outer_diameter_mm=5,
                                     required_boss_outer_diameter_mm=9, source_step_sha256=SOURCE_SHA))
            row.pop('bounds_cm', None); v._record_bounds(row); installed[key] = row
            definitions.append({'insert': key, 'screw': placement['paired_screw'], 'face_mm': face,
                                'position_expressions': old['position_expressions'], 'host': host['occurrence'],
                                'candidate_bounds_mm': bounds(candidate), 'candidate_scale': [1, 1, 1],
                                'outer_addition': {'radii_mm': [4.2, 4.5], 'Z_mm': [30, 39]},
                                'pilot_cut': {'radius_mm': 2.2, 'Z_mm': [34, 39.1]}})
        host.pop('bounds_cm', None); v._record_bounds(host)
        replacements = dict(installed); replacements[host['occurrence']] = host
        proposed = [replacements.get(r['occurrence'], r) for r in physical]
        interfaces = []
        for entry in definitions:
            candidate = installed[entry['insert']]; screw = hw_by_occurrence[entry['screw']]; x, y, z = entry['face_mm']
            _require(screw['hardware']['kind'] == 'screw' and screw['hardware']['size'] == 'M3' and
                     screw['hardware']['length_mm'] == 8 and screw['hardware']['shaft_diameter_mm'] == 2.9 and
                     screw['physical_group'] == 'rear_cover' and screw['joint_bound'] and
                     screw['target_position_error_mm'] < .001 and screw['axial_extent_error_mm'] < .001 and
                     max(abs(a-b) for a, b in zip(screw['axis'], [0, 0, 1])) < 1e-7 and
                     max(abs(a-b) for a, b in zip(screw['head_seat_mm'], [x, y, 41.35])) < 1e-6,
                     'Retained M3x8 screw geometry/metadata/pose changed')
            annulus = _ring(manager, x, y, 35, 39, 2.5, 4.5)
            missing = _difference_volume(manager, annulus, host['body'])
            own_overlap = rx._intersections(manager, candidate['body'], [host])
            foreign = [r for r in proposed if r['occurrence'] not in (entry['insert'], host['occurrence'], entry['screw'])]
            interfaces.append(dict(entry, whole_annulus={'radii_mm': [2.5, 4.5], 'Z_mm': [35, 39],
                'missing_material_mm3': missing, 'tolerance_mm3': VOLUME_TOLERANCE_MM3, 'pass': missing < VOLUME_TOLERANCE_MM3},
                exact_candidate_host_heatset_overlap=own_overlap,
                exact_candidate_nominal_screw_overlap=rx._intersections(manager, candidate['body'], [screw]),
                candidate_unrelated_intersections=rx._intersections(manager, candidate['body'], foreign),
                tip_probe=fasteners._tip_probe(manager, screw, proposed),
                nominal_axial_allocation={'candidate_length_mm': 4, 'screw_under_head_Z_mm': screw['head_seat_mm'][2],
                    'screw_tip_Z_mm': screw['head_seat_mm'][2]-screw['hardware']['length_mm'],
                    'candidate_bottom_Z_mm': 35, 'thread_engagement_qualified': False},
                screw_model_semantics={'source': 'Retained nominal generic M3 x 8 screw',
                    'source_shaft_diameter_mm': screw['hardware']['shaft_diameter_mm'],
                    'manufacturer_insert_thread_reference': 'Exact source CAD retained; smooth screw/insert intersections stay explicit and cannot establish physical thread compatibility.'}))
        # Existing ten M2 pairs keep their exact approved classification; no new waiver is inferred.
        with adapted(OUT):
            raw_static = review.collision_report(manager, proposed)
        allowed = {frozenset((v._label(installed[q['insert']]), v._label(host))): q for q in interfaces}
        intended = []; unrelated = []
        for hit in raw_static['collisions']:
            entry = allowed.get(frozenset((hit['one'], hit['two'])))
            measured = entry['exact_candidate_host_heatset_overlap'] if entry else []
            if len(measured) == 1 and abs(hit['volume_mm3']-measured[0]['volume_mm3']) < 1e-4:
                intended.append(dict(hit, insert=entry['insert'], host=entry['host'], source_step_sha256=SOURCE_SHA,
                                     classification='Only this candidate and its assigned printed pilot; nominal heat-set displacement'))
            else:
                unrelated.append(hit)
        # Source-bound maxima against all five changed solids; preserve historical other-source findings.
        maximum_checks = []
        with width.allocations(OUT) as ic:
            manifest = width._inputs()
            for item in manifest.values():
                for name, digest in (('file', 'sha256'), ('height_contract_file', 'height_contract_sha256')):
                    source_hashes[item[name]] = item[digest]
            main = json.loads(Path(manifest['main']['height_contract_file']).read_text())
            usb = json.loads(Path(manifest['usb']['height_contract_file']).read_text())
            import board_clearance_review as old_clearance
            tools = []
            for shift in (-.16, 0, .16):
                tools += ic._main(manager, main, shift)+[ic._mate(manager, main, shift), ic._cable(manager, main, shift)]
            tools += ic._usb(manager, usb)
            tools += [r for r in old_clearance._coax_tolerance(manager, main) if '_UPPER' not in r['contract']['reference']]
            for name, changed in replacements.items():
                maximum_checks.append({'changed_occurrence': name, 'allocation_count': len(tools),
                    'source_intersections': rx._intersections(manager, by_occurrence[name]['body'], tools),
                    'proposed_intersections': rx._intersections(manager, changed['body'], tools)})
        prior_records = gas._records
        try:
            gas._records = lambda design_, manager_: proposed
            gas_result = gas._gas_result(design)
        finally:
            gas._records = prior_records
        delta = {'source_bounds_mm': bounds(original_host['body']), 'proposed_bounds_mm': bounds(host['body']),
                 'added_material_mm3': _difference_volume(manager, host['body'], original_host['body']),
                 'removed_material_mm3': _difference_volume(manager, original_host['body'], host['body']),
                 'printed_lumps_after': host['body'].lumps.count}
        added = manager.copy(host['body'])
        _require(manager.booleanOperation(added, original_host['body'], fusion.BooleanTypes.DifferenceBooleanType),
                 'Cannot isolate newly added housing material')
        delta['added_material_intersections_all_other_physical_solids'] = rx._intersections(
            manager, added, [r for r in proposed if r['occurrence'] != host['occurrence']])
        passed = (len(intended) == 4 and not unrelated and all(q['whole_annulus']['pass'] and
                  not q['candidate_unrelated_intersections'] and q['tip_probe']['passes_selected_nominal_gap'] for q in interfaces)
                  and not any(q['proposed_intersections'] for q in maximum_checks) and gas_result['pass'] and
                  not delta['added_material_intersections_all_other_physical_solids'] and delta['printed_lumps_after'] == 1)
        result = {'generated_at_utc': datetime.now(timezone.utc).isoformat(), 'document': doc.name,
                  'cloud_id': doc.dataFile.id, 'cloud_version': doc.dataFile.versionNumber, 'timeline': design.timeline.count,
                  'status': 'transient_core_passed_not_adopted' if passed else 'transient_core_needs_review',
                  'source_sha256': source_hashes, 'M2_checkpoint': checkpoint_receipt, 'manufacturer_model': source,
                  'eight_parameters_unchanged': spec['parameter_changes'], 'interfaces': interfaces, 'printed_host_delta': delta,
                  'existing_M2_intentional_pairs': raw_static['engaged_heatset_interfaces'],
                  'candidate_M3_intentional_pairs': intended, 'unrelated_intersections': unrelated,
                  'changed_solids_against_source_bound_maxima': maximum_checks, 'source_manifest': manifest,
                  'gas_probe': gas_result, 'native_adopted': False, 'native_parameter_regeneration_verified': False,
                  'whole_assembly_minimum_wall_proven': False, 'physical_qualification': False,
                  'pending': ['Native regeneration of the exact eight parameter changes after separate approval',
                              'Driver and cover/chamber/retainer service paths, width87 and restoration',
                              'Final routed PCB source when owner freezes its revised routing',
                              'Actual M3 bore/thread/screw fit, printed pilot process and retention'],
                  'limits': ['Outer annuli are added to copies of the final host. Later native feature cuts can produce a different result after parameter regeneration; this simulation does not prove timeline equivalence.',
                             'Whole-annulus Boolean proof concerns only R2.5..4.5 at Z35..39 in the proposed copy, not a global wall or structural claim. Receiving web connection also requires final native review.',
                             'All candidate/screw intersections remain explicit unrelated intersections, even if caused by simplified source thread CAD; no thread-fit waiver is applied.',
                             'Purchased modules, screws, exterior and tip-relief native geometry are untouched. Gas/max tests are geometric checks, not sealing, flow, mass, thermal or strength qualification.']}
    finally:
        preserved = (before == checkpoint._state(design) and others == checkpoint._documents(app, doc) and
                     modified == doc.isModified and all(_sha(p) == h for p, h in source_hashes.items()))
        if result is not None:
            result['source_and_protected_documents_preserved'] = preserved
            if not preserved:
                result['status'] = 'source_preservation_failed'
            with output.open('x') as stream:
                stream.write(json.dumps(result, indent=2)+'\n')
        _require(preserved, 'M3 transient assessment changed source/parameters/poses/health/protected documents')
    print(json.dumps({'path': str(output), 'sha256': _sha(output), 'status': result['status']}))
    return result
