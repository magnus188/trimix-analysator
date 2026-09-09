"""Import the exact delivered STEP into a temporary unsaved Fusion document.

Call verify() explicitly through the official Fusion MCP. No work occurs on
import. Fusion interprets the STEP unit declarations; no manual scaling is
applied. The imported document is closed without saving and the original A3
document is reactivated in finally, including after comparison failures.
"""

from datetime import datetime, timezone
import hashlib
import json

import adsk.fusion as fusion
import build_a3 as b
from audit_a3 import _bodies, _combined_bounds, _instances, _bounds


LENGTH_TOLERANCE_MM = 0.02
RELATIVE_VOLUME_TOLERANCE = 1e-6
MINIMUM_VOLUME_TOLERANCE_MM3 = 0.01
ACCURACY_LEVELS = {
    'high': fusion.CalculationAccuracy.HighCalculationAccuracy,
    'very_high': fusion.CalculationAccuracy.VeryHighCalculationAccuracy,
}


def _accurate_bodies(design, requested_accuracy):
    """Read every placed body's physical properties at an explicit accuracy.

    Local Fusion API documentation leaves BRepBody.volume accuracy unspecified.
    getPhysicalProperties defaults toLow (+/-1% documented), so the desired
    accuracy must be requested explicitly for a1ppm comparison. The returned
    accuracy is recorded and must be at least the requested enum level. High
    accuracy itself is not asserted to guarantee1ppm; that remains a measured
    roundtrip criterion, unchanged from the original checker.
    """
    records=[]
    for occurrence,component,index,body in _instances(design):
        record={'component':component.name,
                'occurrence':occurrence.fullPathName if occurrence else None,
                'body_index':index,'name':body.name,'solid':body.isSolid,
                'bounds_mm':_bounds(body.boundingBox),
                'volume_mm3':0.0,'physical_properties_accuracy':None}
        if body.isSolid:
            properties=body.getPhysicalProperties(requested_accuracy)
            if properties is None:
                raise RuntimeError('No explicit-accuracy physical properties: '+body.name)
            if properties.accuracy < requested_accuracy:
                raise RuntimeError('Fusion returned lower physical-property accuracy than requested: '+body.name)
            record['volume_mm3']=properties.volume*1000
            record['area_mm2']=properties.area*100
            record['physical_properties_accuracy']=int(properties.accuracy)
        records.append(record)
    return records


def _identity(records):
    """Geometry identity without mixing precision-dependent volume estimates."""
    return [{key:value for key,value in record.items() if key!='volume_mm3'} for record in records]


def _poses(design):
    return {o.fullPathName:o.transform2.asArray() for o in design.rootComponent.allOccurrences}


def _per_body_comparison(actual,expected):
    """Diagnostic one-to-one bounds matching, preserving ambiguous cases.

    STEP may rename assembly paths. Matching therefore uses placed bounds,
    followed by the closest volume only to order equivalent candidates. Every
    native/imported record is also retained independently in the report.
    This diagnostic does not replace the unchanged total-volume/count gate.
    """
    remaining={index:r for index,r in enumerate(actual) if r['solid']}
    result=[]
    for native in (r for r in expected if r['solid']):
        candidates=[]
        for index,imported in remaining.items():
            error=max(abs(native['bounds_mm'][kind][axis]-imported['bounds_mm'][kind][axis])
                      for kind in ('min','max') for axis in range(3))
            if error <= LENGTH_TOLERANCE_MM:
                candidates.append((error,abs(native['volume_mm3']-imported['volume_mm3']),index))
        candidates.sort()
        row={'native_occurrence':native['occurrence'],'native_body':native['name'],
             'native_volume_mm3':native['volume_mm3'],'matching_bound_candidate_count':len(candidates)}
        if candidates:
            bound_error,volume_error,index=candidates[0];imported=remaining.pop(index)
            row.update({'imported_occurrence':imported['occurrence'],'imported_body':imported['name'],
                        'imported_volume_mm3':imported['volume_mm3'],
                        'maximum_bound_error_mm':bound_error,'volume_difference_mm3':volume_error,
                        'signed_volume_difference_mm3':imported['volume_mm3']-native['volume_mm3']})
        result.append(row)
    return {'method':'Placed bounds within0.02mm; minimum bound error then volume error; diagnostic only',
            'pairs':result,'unmatched_imported_bodies':list(remaining.values()),
            'ambiguous_native_matches':sum(r['matching_bound_candidate_count']>1 for r in result),
            'unmatched_native_count':sum(r['matching_bound_candidate_count']==0 for r in result)}


def _summary(records):
    solids = [record for record in records if record['solid']]
    return {
        'placed_solid_count': len(solids),
        'non_solid_count': len(records)-len(solids),
        'bounds_mm': _combined_bounds(solids),
        'sum_placed_solid_volume_mm3': sum(record['volume_mm3'] for record in solids),
    }


def _compare(actual, expected):
    if actual['bounds_mm'] is None or expected['bounds_mm'] is None:
        return {'pass': False, 'reason': 'No placed solid bounds available.'}
    errors = [abs(actual['bounds_mm'][kind][axis]-expected['bounds_mm'][kind][axis])
              for kind in ('min', 'max') for axis in range(3)]
    volume_error = abs(actual['sum_placed_solid_volume_mm3']
                       - expected['sum_placed_solid_volume_mm3'])
    volume_tolerance = max(MINIMUM_VOLUME_TOLERANCE_MM3,
                           expected['sum_placed_solid_volume_mm3']*RELATIVE_VOLUME_TOLERANCE)
    count_pass = actual['placed_solid_count'] == expected['placed_solid_count']
    bounds_pass = max(errors) <= LENGTH_TOLERANCE_MM
    volume_pass = volume_error <= volume_tolerance
    return {
        'placed_solid_count_matches': count_pass,
        'maximum_bound_coordinate_error_mm': max(errors),
        'length_tolerance_mm': LENGTH_TOLERANCE_MM,
        'bounds_pass': bounds_pass,
        'total_volume_absolute_error_mm3': volume_error,
        'total_volume_tolerance_mm3': volume_tolerance,
        'total_volume_pass': volume_pass,
        'size_ratio_imported_to_expected': [actual['bounds_mm']['size'][axis]
                                            /expected['bounds_mm']['size'][axis]
                                            for axis in range(3)],
        'volume_ratio_imported_to_expected': actual['sum_placed_solid_volume_mm3']
                                            /expected['sum_placed_solid_volume_mm3'],
        'pass': count_pass and bounds_pass and volume_pass and actual['non_solid_count'] == 0,
    }


def verify(accuracy='high'):
    """Return/write the roundtrip report; raise if import, cleanup or checks fail.

    Internal Fusion lengths are centimetres and volumes are cubic centimetres.
    Legacy BRepBody.volume values are used only to establish the active native
    model still matches the source audit. The STEP comparison uses newly read
    native and imported getPhysicalProperties values at the same explicitly
    requested accuracy. Bounds/count and1ppm volume tolerances are unchanged.
    """
    app, native_design = b.get()  # Only owned-design lookup; never used after import.
    native_document = app.activeDocument
    step_path = b.BASE/'Trimix_Enclosure_A3_PrintReview.step'
    audit_path = b.BASE/'verification/model-audit.json'
    output_path = b.BASE/'verification/step-roundtrip.json'
    if accuracy not in ACCURACY_LEVELS:
        raise ValueError('Use high or very_high physical-property accuracy')
    requested_accuracy=ACCURACY_LEVELS[accuracy]
    if not step_path.is_file() or not audit_path.is_file():
        raise FileNotFoundError('Delivered STEP and native audit must both exist.')
    step_bytes = step_path.read_bytes()
    audit_bytes = audit_path.read_bytes()
    audit = json.loads(audit_bytes)
    expected = _summary(audit['bodies'])
    if expected['placed_solid_count'] < 1:
        raise RuntimeError('Source audit has no reviewed placed solids.')
    before = _bodies(native_design)
    native_summary = _summary(before)
    native_comparison = _compare(native_summary, expected)
    if not native_comparison['pass']:
        raise RuntimeError('Active native design no longer matches the delivered audit: '
                           +json.dumps(native_comparison))
    accurate_native_records=_accurate_bodies(native_design,requested_accuracy)
    accurate_native=_summary(accurate_native_records)
    native_timeline = native_design.timeline.count
    native_poses=_poses(native_design)
    prior_report=json.loads(output_path.read_text()) if output_path.is_file() else None
    report = {
        'generated_at_utc': datetime.now(timezone.utc).isoformat(),
        'status': 'pending',
        'native_document': native_document.name,
        'step_path': str(step_path), 'step_sha256': hashlib.sha256(step_bytes).hexdigest(),
        'step_bytes': len(step_bytes),
        'source_audit_path': str(audit_path),
        'source_audit_generated_at_utc': audit['generated_at_utc'],
        'source_audit_sha256': hashlib.sha256(audit_bytes).hexdigest(),
        'unit_handling': 'Fusion STEP importer reads file units. API cm/cm³ values convert to mm/mm³. No manual scaling.',
        'step_contains_centi_metre_declaration': b'SI_UNIT(.CENTI.,.METRE.)' in step_bytes,
        'expected_native': accurate_native,
        'legacy_native_audit_summary':expected,
        'native_before_import_legacy_reader':native_summary,
        'native_before_matches_audit': native_comparison,
        'physical_property_method':{
            'api':'BRepBody.getPhysicalProperties', 'requested_accuracy':accuracy,
            'requested_accuracy_enum':int(requested_accuracy),
            'actual_accuracy_recorded_per_body':True,
            'native_and_imported_use_same_method':True,
            'roundtrip_tolerances_changed':False,
            'documentation_scope':'BRepBody.volume docs specify units but no accuracy. getPhysicalProperties defaultLow documents+/-1%; explicitHigh/VeryHigh available. No1ppm guarantee is inferred from an accuracy enum.'},
        'native_explicit_accuracy_bodies':accurate_native_records,
        'prior_same_step_report':({'status':prior_report.get('status'),
                                  'generated_at_utc':prior_report.get('generated_at_utc'),
                                  'comparison':prior_report.get('comparison')}
                                 if prior_report and prior_report.get('step_sha256')==hashlib.sha256(step_bytes).hexdigest() else None),
        'temporary_document_closed_without_save': False,
        'native_document_reactivated': False,
        'limits': 'Checks all placed solid counts, explicit-accuracy total volume and overall bounds. Per-body bounds/volume matching is diagnostic. Unchanged1ppm is a numerical roundtrip criterion, not an accuracy guarantee or physical tolerance. STEP carries geometry/assembly placement, not parametric history or manufacturing qualification.',
    }
    imported_document = None
    try:
        options = app.importManager.createSTEPImportOptions(str(step_path))
        if not options:
            raise RuntimeError('Fusion could not create STEP import options.')
        options.isViewFit = False
        imported_document = app.importManager.importToNewDocument(options)
        if not imported_document:
            raise RuntimeError('Fusion returned no document from STEP import.')
        if imported_document.isSaved:
            raise RuntimeError('STEP verification unexpectedly produced a saved document.')
        if not imported_document.activate():
            raise RuntimeError('Could not activate the temporary STEP document.')
        imported_design = fusion.Design.cast(app.activeProduct)
        if not imported_design:
            raise RuntimeError('Imported STEP document has no Fusion Design product.')
        if not imported_design.computeAll():
            raise RuntimeError('Imported STEP failed to recompute.')
        accurate_imported_records=_accurate_bodies(imported_design,requested_accuracy)
        imported = _summary(accurate_imported_records)
        report['imported_document'] = imported_document.name
        report['imported'] = imported
        report['imported_occurrence_count'] = imported_design.rootComponent.allOccurrences.count
        report['imported_explicit_accuracy_bodies']=accurate_imported_records
        report['per_body_diagnostic']=_per_body_comparison(accurate_imported_records,accurate_native_records)
        report['comparison'] = _compare(imported, accurate_native)
        report['status'] = 'passed' if report['comparison']['pass'] else 'geometry_mismatch'
    except Exception as error:
        report['status'] = 'execution_error'
        report['error'] = str(error)
        raise
    finally:
        # Keep reactivation in its own finally so even a close failure returns
        # focus to the native design. Never close any pre-existing document.
        try:
            try:
                if imported_document is not None:
                    if imported_document.isSaved:
                        raise RuntimeError('Refusing to close an unexpectedly saved import document.')
                    if not imported_document.close(False):
                        raise RuntimeError('Could not close the temporary STEP document without saving.')
                    report['temporary_document_closed_without_save'] = True
            finally:
                if not native_document.activate():
                    raise RuntimeError('Could not reactivate the original A3 document.')
                report['native_document_reactivated'] = True
                report['native_geometry_unchanged'] = _identity(_bodies(native_design)) == _identity(before)
                report['native_instance_poses_unchanged'] = _poses(native_design)==native_poses
                accurate_after=_summary(_accurate_bodies(native_design,requested_accuracy))
                report['native_explicit_accuracy_before_after_comparison']=_compare(accurate_after,accurate_native)
                report['native_timeline_unchanged'] = native_design.timeline.count == native_timeline
                if (not report['native_geometry_unchanged'] or not report['native_timeline_unchanged']
                        or not report['native_instance_poses_unchanged']
                        or not report['native_explicit_accuracy_before_after_comparison']['pass']):
                    raise RuntimeError('Native design changed during STEP verification.')
        except Exception as error:
            report['status'] = 'cleanup_error'
            report['cleanup_error'] = str(error)
            raise
        finally:
            output_path.write_text(json.dumps(report, indent=2)+'\n', encoding='utf-8')
    if not report.get('comparison', {}).get('pass'):
        raise RuntimeError('STEP roundtrip geometry mismatch: '+json.dumps(report.get('comparison')))
    return report


verify_step_roundtrip = verify
