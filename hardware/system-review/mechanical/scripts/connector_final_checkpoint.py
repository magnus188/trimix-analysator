"""Freeze the adopted photo correction while retaining explicit interface failures.

This checkpoint does not adopt any transient carrier, battery, sensor or wire
proposal, and does not repeat the older STEP conversion investigation.
"""
import hashlib
import json
from pathlib import Path
import adsk.core as core
import adsk.fusion as fusion
import connector_photo_review as review

TARGET = review.OUT / 'interface-checkpoint'
NATIVE = TARGET / 'Trimix_Enclosure_A3_ConnectorReview_Interfaces.f3d'
LINEAGE = 'urn:adsk.wipprod:dm.lineage:5M736I5UQDqcDS_xgq9lMQ'


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def write(name, value):
    TARGET.mkdir(exist_ok=True)
    p = TARGET / name
    p.write_text(json.dumps(value, indent=2) + '\n')
    print(json.dumps({'report': str(p), 'sha256': review.sha(p),
                      'status': value.get('status'), 'pass': value.get('pass')}))


def state(design):
    def numbers(values):
        return [round(x, 8) for x in values]
    bodies = []
    occurrences = []
    for occurrence in design.rootComponent.allOccurrences:
        component = occurrence.component
        occurrences.append({'path': occurrence.fullPathName,
                            'transform': numbers(occurrence.transform2.asArray()),
                            'part_number': component.partNumber,
                            'visible': occurrence.isLightBulbOn})
        for body in occurrence.bRepBodies:
            if not body.isSolid:
                continue
            bodies.append({'path': occurrence.fullPathName, 'name': body.name,
                           'bounds_mm': [numbers(x) for x in review.box_bounds(body)],
                           'faces': body.faces.count, 'edges': body.edges.count,
                           'vertices': body.vertices.count})
    return {'parameters': {p.name: p.expression for p in design.userParameters},
            'timeline': design.timeline.count,
            'occurrences': sorted(occurrences, key=lambda x: x['path']),
            'solids': sorted(bodies, key=lambda x: (x['path'], x['name'])),
            'health': review._health(design)}


def save():
    app, doc, design = review.owned()
    require(doc.dataFile and doc.dataFile.id == LINEAGE, 'Exact review lineage required')
    require(design.timeline.count == 1224, 'No transient alternative may have been adopted')
    require(not NATIVE.exists(), 'Preserve existing final interface archive')
    original = json.loads((review.OUT / 'photo-checkpoint.json').read_bytes())
    require(review.sha(original['native_file']) == original['native_sha256'], 'Original photo archive changed')
    mapping = json.loads((review.OUT / 'photo-bound-inputs/map.json').read_bytes())
    require(len(mapping['bindings']) == 10 and all(review.sha(x['snapshot']) == x['sha256'] for x in mapping['bindings']),
            'Original photo stage input snapshots changed')
    source_files = [review.OUT / name for name in [
        'photo-checkpoint.json', 'photo-bound-inputs/map.json', 'photo-model.json',
        'photo-inspection-views.json', 'guition-photo-rear.png', 'guition-photo-oblique.png',
        'interface-checks.json', 'mate-localization.json', 'chamber-cable-checks.json',
        'wet-front-route-candidates.json', 'larger-wire-trial.json', 'shaped-wire-trial.json',
        'carrier-sidebridge-trial.json', 'hardware-offset-trial.json',
        'intended-mate-allowances.json',
    ]] + [review.BASE / 'scripts' / name for name in [
        'connector_photo_review.py', 'connector_basefeature_review.py',
        'connector_cable_checks.py', 'connector_final_checkpoint.py',
    ]]
    source_files += [review.PHOTO / name for name in ['registration.json', 'connector-candidates.md',
                                                     'connector-source-receipt.json', 'current-host-pose.json']]
    for p in source_files:
        require(p.exists(), 'Missing final evidence ' + str(p))
    before_docs = review.docs(app)
    current = state(design)
    require(current['health']['healthy'], 'Native health failed')
    attrs = design.rootComponent.attributes
    attrs.add(review.GROUP, 'current_interface_status',
              'PHOTO CORRECTION ADOPTED; FULL CABLE, REMOTE MATE AND SD SERVICE FIT UNRESOLVED')
    attrs.add(review.GROUP, 'transient_alternatives_not_adopted',
              'Carrier +0.8Z sidebrace, holder repositioning, MD62 shift and shaped/round wiring proposals remain external receipts only.')
    require(doc.save('Photo-correct Guition connector/SD checkpoint; retain measured13.4mm tips, both USB and pin1. Explicit remote-mate, complete cable and SD-service conflicts remain; no internal trial adopted.'),
            'Cloud save failed')
    TARGET.mkdir(exist_ok=True)
    require(design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(NATIVE))),
            'Native archive export failed')
    after = state(design)
    require(current == after, 'Saving metadata changed geometry, poses or visibility')
    other_before = [x for x in before_docs if x['id'] != LINEAGE]
    other_after = [x for x in review.docs(app) if x['id'] != LINEAGE]
    require(other_before == other_after, 'Other document state changed')
    # Copies preserve the actual code/evidence used by this new checkpoint.
    snapshot_dir = TARGET / 'bound-inputs'
    snapshot_dir.mkdir(exist_ok=True)
    bindings = []
    for i, path in enumerate(source_files):
        data = path.read_bytes()
        destination = snapshot_dir / ('%02d-' % i + path.name)
        destination.write_bytes(data)
        bindings.append({'original': str(path), 'snapshot': str(destination),
                         'sha256': hashlib.sha256(data).hexdigest(), 'bytes': len(data)})
    write('saved-state.json', current)
    write('export.json', {
        'status': 'saved_photo_correction_with_open_interface_findings',
        'document': doc.name, 'cloud_id': doc.dataFile.id,
        'reported_cloud_version': doc.dataFile.versionNumber,
        'cloud_is_complete_at_export': doc.dataFile.isComplete,
        'native_file': str(NATIVE), 'native_sha256': review.sha(NATIVE),
        'native_bytes': NATIVE.stat().st_size,
        'state_file': str(TARGET / 'saved-state.json'),
        'state_sha256': review.sha(TARGET / 'saved-state.json'),
        'original_photo_native_sha256': original['native_sha256'],
        'original_v11_native_sha256': review.ARCHIVE_SHA,
        'bound_inputs': bindings, 'other_documents_preserved': True,
        'adopted_geometry_scope': 'Only photo-corrected Guition supplied details and separate card/candidate-mate references; original measured casing and exterior retained.',
        'unadopted_scope': 'No carrier, main PCB, holder, sensor, feedthrough or wire-routing trial applied.',
        'signature_scope': 'Every solid count, topology counts and world bounds; every occurrence pose/visibility, parameter expression and timeline. No new all-body volume or STEP-equivalence claim.',
        'checks': {'health': current['health']['healthy'], 'timeline_1224': current['timeline'] == 1224,
                   'save_preserved_geometry_and_poses': current == after, 'other_documents_preserved': True},
    })


def reopen():
    app, doc, design = review.owned()
    require(doc.dataFile.id == LINEAGE, 'Exact review lineage required')
    receipt = json.loads((TARGET / 'export.json').read_bytes())
    require(review.sha(NATIVE) == receipt['native_sha256'], 'Archive changed')
    require(review.sha(TARGET / 'saved-state.json') == receipt['state_sha256'], 'Saved state changed')
    expected = json.loads((TARGET / 'saved-state.json').read_bytes())
    require(all(review.sha(x['snapshot']) == x['sha256'] for x in receipt['bound_inputs']), 'Bound source changed')
    before = state(design)
    require(before == expected, 'Live source differs from saved archive checkpoint')
    docs_before = review.docs(app)
    modified_before = doc.isModified
    identity = lambda q: (q.name, q.dataFile.id if q.dataFile else None)
    original_ids = [identity(q) for q in app.documents]
    temporary = None
    own = False
    result = None
    try:
        temporary = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(NATIVE)))
        own = bool(temporary and not temporary.isSaved and not temporary.dataFile and
                   app.documents.count == len(original_ids) + 1 and identity(temporary) not in original_ids)
        require(own, 'Expected one new unsaved archive test document')
        imported = fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        require(imported is not None, 'Imported archive lacks design')
        actual = state(imported)
        matches = {key: actual[key] == expected[key] for key in expected}
        result = {'status': 'native_archive_reopened', 'native_sha256': receipt['native_sha256'],
                  'matches': matches, 'solid_count': len(actual['solids']),
                  'occurrence_count': len(actual['occurrences']), 'timeline': actual['timeline'],
                  'signature_scope': receipt['signature_scope']}
    finally:
        closed = bool(temporary.close(False)) if own else False
        activated = bool(doc.activate())
        preserved = before == state(design) and review.docs(app) == docs_before and doc.isModified == modified_before
        if result is not None:
            result.update(temporary_closed_without_save=closed, source_reactivated=activated,
                          source_and_other_documents_preserved=preserved,
                          current_document=doc.name, cloud_id=doc.dataFile.id,
                          cloud_version=doc.dataFile.versionNumber,
                          cloud_is_complete=doc.dataFile.isComplete)
            result['pass'] = closed and activated and preserved and all(result['matches'].values())
            write('native-reopen.json', result)
        require(closed and activated and preserved, 'Archive cleanup or source preservation failed')
    require(result and result['pass'], 'Native archive state mismatch')
