"""Import the exact delivered STEP into a temporary unsaved Fusion document.

Call verify() explicitly through the official Fusion MCP. No work occurs on
import. Fusion interprets the STEP unit declarations; no manual scaling is
applied. The imported document is closed without saving and the original A2
document is reactivated in finally, including after comparison failures.
"""

from datetime import datetime, timezone
import hashlib
import json

import adsk.fusion as fusion
import build_rev03 as b
from fusion_audit import _bodies, _combined_bounds


LENGTH_TOLERANCE_MM = 0.02
RELATIVE_VOLUME_TOLERANCE = 1e-6
MINIMUM_VOLUME_TOLERANCE_MM3 = 0.01


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


def verify():
    """Return/write the roundtrip report; raise if import, cleanup or checks fail.

    Internal Fusion lengths are centimetres and volumes are cubic centimetres.
    The shared body reader converts them to mm and mm³ exactly as for the native
    audit. This checks unit-aware geometry transfer, not parametric history,
    manufacturing suitability, supplier provenance or thread accuracy.
    """
    app, native_design = b.get()  # Only owned-design lookup; never used after import.
    native_document = app.activeDocument
    step_path = b.BASE/'Trimix_Enclosure_A2.step'
    audit_path = b.BASE/'verification/model-audit.json'
    output_path = b.BASE/'verification/step-roundtrip.json'
    if not step_path.is_file() or not audit_path.is_file():
        raise FileNotFoundError('Delivered STEP and native audit must both exist.')
    step_bytes = step_path.read_bytes()
    audit_bytes = audit_path.read_bytes()
    audit = json.loads(audit_bytes)
    expected = _summary(audit['bodies'])
    if expected['placed_solid_count'] != 118:
        raise RuntimeError('Expected the reviewed118 placed solids in the source audit.')
    before = _bodies(native_design)
    native_summary = _summary(before)
    native_comparison = _compare(native_summary, expected)
    if not native_comparison['pass']:
        raise RuntimeError('Active native design no longer matches the delivered audit: '
                           +json.dumps(native_comparison))
    native_timeline = native_design.timeline.count
    report = {
        'generated_at_utc': datetime.now(timezone.utc).isoformat(),
        'status': 'pending',
        'native_document': native_document.name,
        'step_path': str(step_path), 'step_sha256': hashlib.sha256(step_bytes).hexdigest(),
        'step_bytes': len(step_bytes),
        'source_audit_path': str(audit_path),
        'source_audit_generated_at_utc': audit['generated_at_utc'],
        'source_audit_sha256': hashlib.sha256(audit_bytes).hexdigest(),
        'unit_handling': 'Fusion STEP importer reads file units. API cm and cm³ are converted to mm and mm³ by the same reader as the native audit. No manual scaling.',
        'step_contains_centi_metre_declaration': b'SI_UNIT(.CENTI.,.METRE.)' in step_bytes,
        'expected_native': expected,
        'native_before_import': native_summary,
        'native_before_matches_audit': native_comparison,
        'temporary_document_closed_without_save': False,
        'native_document_reactivated': False,
        'limits': 'Checks all placed solid counts, total solid volume and overall bounds. STEP carries geometry/assembly placement, not the native parametric feature history or manufacturing qualification.',
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
        imported = _summary(_bodies(imported_design))
        report['imported_document'] = imported_document.name
        report['imported'] = imported
        report['imported_occurrence_count'] = imported_design.rootComponent.allOccurrences.count
        report['comparison'] = _compare(imported, expected)
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
                    raise RuntimeError('Could not reactivate the original A2 document.')
                report['native_document_reactivated'] = True
                report['native_geometry_unchanged'] = _bodies(native_design) == before
                report['native_timeline_unchanged'] = native_design.timeline.count == native_timeline
                if not report['native_geometry_unchanged'] or not report['native_timeline_unchanged']:
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
