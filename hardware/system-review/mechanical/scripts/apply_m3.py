"""Apply only the root-reviewed eight M3 dimensions and four exact inserts."""
from pathlib import Path
import json
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE, GROUP, owned, configure, other_documents, attrs, bounds
import m3_candidate_audit as candidate

APPROVED = candidate.PROPOSAL_SHA
REVIEW = 'c3f14fe655dca0bf80772732eb47560f30bdf2617dd046eba64d7fb16d2c18fd'
OUT = BASE/'verification/m3-implementation'


def write(name, data):
    OUT.mkdir(parents=True, exist_ok=True)
    with (OUT/name).open('x') as stream:
        stream.write(json.dumps(data, indent=2)+'\n')
    return data


def apply():
    configure()
    import review_checks as review
    import m3_service_audit as service
    from width_contract_proposal import _snapshots, compare_physical
    path = candidate.OUT/'root-adoption-review.json'
    candidate._require(candidate._sha(path) == REVIEW, 'Root adoption review changed')
    approval = json.loads(path.read_text())
    app, doc, design, spec, checkpoint = candidate._guard()
    candidate._require(approval['proposal_sha256'] == APPROVED and approval['eight_changes'] == spec['parameter_changes'], 'Eight approved edits differ')
    candidate._require(approval['status'] == 'approved_for_guarded_native_implementation_and_regeneration_checks_only', 'Native scope not approved')
    core_receipt = json.loads((candidate.OUT/'transient-core.json').read_text())
    service_receipt = json.loads((candidate.OUT/'service-and-thread/summary.json').read_text())
    candidate._require(candidate._sha(candidate.OUT/'transient-core.json') == approval['core_sha256'] and
                       candidate._sha(candidate.OUT/'service-and-thread/summary.json') == approval['service_sha256'] and
                       service_receipt['pass'] and service_receipt['source_and_protected_documents_preserved'], 'Reviewed native evidence changed')
    candidate._require(all(candidate._sha(p) == h for receipt in (core_receipt, service_receipt) for p,h in receipt['source_sha256'].items()), 'Reviewed bound input changed')
    candidate._require(not design.rootComponent.attributes.itemByName(GROUP, 'm3_proposal_sha256'), 'M3 update already applied')
    manager, before = _snapshots()
    protected = other_documents(app)
    timeline = design.timeline.count
    occurrences = {o.fullPathName: o for o in design.rootComponent.occurrences}
    instances = [occurrences[p['original_occurrence']] for p in spec['candidate_placements_for_later_review']]
    candidate._require(len({o.component.id for o in instances}) == 1, 'Expected one shared generic M3 definition')
    component = instances[0].component
    candidate._require(component.partNumber == 'TMX-A3-F04' and component.bRepBodies.count == 1 and
                       len([o for o in design.rootComponent.allOccurrences if o.component.id == component.id]) == 4, 'M3 shared definition changed')
    old_paths = [o.fullPathName for o in instances]
    old_poses = [list(o.transform2.asArray()) for o in instances]
    old_attributes = [attrs(o) for o in instances]
    old_body = component.bRepBodies.item(0)
    appearance = old_body.appearance
    # Independent copied-host construction is a prediction to compare after
    # native recompute; later timeline cuts may otherwise differ unnoticed.
    proposed, replacements, source, hardware = service._proposed(manager, design, spec)
    predicted_host = next(r for r in replacements.values() if r['component'] == '01 Shape A housing')
    world_insert = replacements[old_paths[0]]['body']
    exact = manager.copy(world_insert)
    x,y,z = spec['candidate_placements_for_later_review'][0]['open_face_mm_at_width85']
    matrix = core.Matrix3D.create()
    matrix.translation = core.Vector3D.create(-x/10, -y/10, -z/10)
    candidate._require(manager.transform(exact, matrix) and abs(bounds(exact)[0][2]+4) < 1e-6 and abs(bounds(exact)[1][2]) < 1e-6, 'Exact source open-face registration failed')
    write('apply-started.json', {'source_document': doc.name, 'source_version': doc.dataFile.versionNumber,
          'source_timeline': timeline, 'root_review_sha256': REVIEW, 'proposal_sha256': APPROVED,
          'parameter_changes': spec['parameter_changes'], 'old_occurrences': old_paths, 'protected_documents': protected})
    for row in spec['parameter_changes']:
        design.allParameters.itemByName(row['name']).expression = row['proposed_expression']
    candidate._require(design.computeAll(), 'Eight native M3 dimensions failed recompute')
    removed = component.features.removeFeatures.add(old_body)
    candidate._require(removed, 'Cannot retire generic M3 insert solid')
    removed.name = 'Retire generic M3 insert reference — exact VORON M3x5x4'
    feature = component.features.baseFeatures.add()
    feature.name = 'VORON M3x5x4 exact manufacturer STEP, open-face datum'
    candidate._require(feature.startEdit(), 'Cannot edit exact M3 base feature')
    try:
        body = component.bRepBodies.add(exact, feature)
        candidate._require(body, 'Cannot add exact M3 manufacturer solid')
        body.name = 'VORON M3x5x4 exact manufacturer solid — mating fit unqualified'
        body.appearance = appearance
    finally:
        candidate._require(feature.finishEdit(), 'Cannot finish exact M3 base feature')
    component.name = 'M3 insert — CNC Kitchen VORON M3x5x4'
    component.description = 'CNC Kitchen / TwoChefs GmbH VORON M3x5x4, EAN4262391010051. Exact unscaled manufacturer STEP. Nominal M3x0.5 identity; smooth screw CAD overlaps are representation pairs only. Actual mating thread, print retention and torque require physical qualification.'
    raw = component.attributes.itemByName('TrimixRev04', 'hardware_definition')
    hardware_definition = json.loads(raw.value)
    hardware_definition.update(length_mm=4.0, outer_diameter_mm=5.0, required_boss_outer_diameter_mm=9.0,
        bore_diameter_mm=2.529, model_thread_root_diameter_mm=3.086, nominal_thread_major_diameter_mm=3.0,
        nominal_thread_pitch_mm=.5, manufacturer='CNC Kitchen / TwoChefs GmbH',
        manufacturer_product_name='VORON M3x5x4', EAN='4262391010051',
        manufacturer_part_number=None, external_step_sha256=candidate.SOURCE_SHA,
        model_internal_thread_physical_fit_qualified=False)
    component.attributes.add('TrimixRev04', 'hardware_definition', json.dumps(hardware_definition))
    for name,value in {'manufacturer':'CNC Kitchen / TwoChefs GmbH', 'manufacturer_product_name':'VORON M3x5x4',
        'EAN':'4262391010051', 'quantity':'4', 'source_step_sha256':candidate.SOURCE_SHA, 'source_step_file':str(candidate.SOURCE),
        'geometry_basis':'Exact manufacturer STEP rigidly translated to openfaceZ0; no scaling or thread remodeling.',
        'nominal_thread':'M3x0.5 ISO coarse designation; actual product tolerance class and screw MPN unqualified.',
        'installation_limits':'Nominal5mm blind pilot, preserved narrow screw-tip relief; heatset displacement at assigned pilot only. Actual heat-set retention and torque unqualified.',
        'thread_model_limits':'Four smooth GEN-M3-BHCS-L8-AF2 shafts overlap modeled female-thread crests within the expected annulus and axial allocation; physical thread fit is not proven.'}.items():
        component.attributes.add('TrimixRev04',name,value)
    candidate._require(design.computeAll(), 'Exact M3 component recompute failed')
    candidate._require(component.bRepBodies.count == 1 and component.bRepBodies.item(0).isSolid, 'Expected one exact shared M3 solid')
    candidate._require(old_poses == [list(o.transform2.asArray()) for o in instances] and
                       old_attributes == [attrs(o) for o in instances], 'M3 original poses/bindings changed')
    pairs = []
    for old, occurrence, placement in zip(old_paths, instances, spec['candidate_placements_for_later_review']):
        pairs.append({'old_occurrence':old, 'occurrence':occurrence.fullPathName,
                      'face_mm_at_W85':placement['open_face_mm_at_width85'], 'paired_screw':placement['paired_screw'],
                      'host':'01 Shape A housing', 'position_expressions':json.loads(occurrence.attributes.itemByName('TrimixRev04','position_expressions').value)})
    design.rootComponent.attributes.add(GROUP,'m3_proposal_sha256',APPROVED)
    design.rootComponent.attributes.add(GROUP,'m3_source_sha256',candidate.SOURCE_SHA)
    design.rootComponent.attributes.add(GROUP,'m3_interfaces',json.dumps(pairs))
    _, after = _snapshots()
    new_paths = {o.fullPathName for o in instances}
    unchanged_before = {k:r for k,r in before.items() if r['component'] != '01 Shape A housing' and r['occurrence'] not in old_paths}
    unchanged_after = {k:r for k,r in after.items() if r['component'] != '01 Shape A housing' and r['occurrence'] not in new_paths}
    invariant = compare_physical(unchanged_before, unchanged_after, manager)
    actual_host = next(r for r in after.values() if r['component'] == '01 Shape A housing')
    predicted_vs_actual = compare_physical({'housing':predicted_host}, {'housing':actual_host}, manager)
    exact_checks = []
    for old, occurrence in zip(old_paths, instances):
        actual = next(r for r in after.values() if r['occurrence'] == occurrence.fullPathName)
        exact_checks.append({'occurrence':occurrence.fullPathName,
            'match':compare_physical({'insert':replacements[old]}, {'insert':actual}, manager)})
    health = review.health(design)
    result = {'status':'applied_unsaved_validation_required', 'proposal_sha256':APPROVED, 'root_review_sha256':REVIEW,
              'source_step_sha256':candidate.SOURCE_SHA, 'source_version_preserved':9,
              'timeline_before':timeline, 'timeline_after':design.timeline.count, 'parameter_changes':spec['parameter_changes'],
              'source_model':source, 'stable_part_id':component.partNumber, 'insert_component':component.name,
              'manufacturer_product_name':'VORON M3x5x4', 'EAN':'4262391010051', 'manufacturer_part_number':None,
              'interfaces':pairs, 'occurrence_poses_and_binding_attributes_unchanged':True,
              'unchanged_physical_solids':invariant, 'native_housing_matches_reviewed_transient':predicted_vs_actual,
              'native_inserts_match_reviewed_transients':exact_checks, 'health':health,
              'protected_documents':protected, 'native_saved':False}
    result['pass'] = (invariant['pass'] and predicted_vs_actual['pass'] and all(q['match']['pass'] for q in exact_checks)
                     and health['pass'] and protected == other_documents(app))
    write('applied.json',result)
    candidate._require(result['pass'], 'M3 source invariants/native prediction/health/protected document check failed')
    print(json.dumps({'pass':result['pass'],'timeline':design.timeline.count,'source_version_preserved':9}))
    return result
