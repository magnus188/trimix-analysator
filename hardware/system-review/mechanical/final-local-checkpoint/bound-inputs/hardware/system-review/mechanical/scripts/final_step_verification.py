"""Unit-aware final STEP comparison using matching highest property accuracy."""
from pathlib import Path
from datetime import datetime, timezone
import json,hashlib
import adsk.fusion as fusion
from runtime import BASE,owned,configure
from final_local_integration import BOARD_SHA,STEP_SHA,_require
OUT=BASE/'final-local-checkpoint'
SOURCE=OUT/'Trimix_Enclosure_A3_SystemReview_FinalLocal.step'


def run():
    import step_a3 as step
    import final_local_checkpoint as checkpoint
    import review_checkpoint as prior
    import review_checks as review
    app,doc,d=owned();configure()
    _require(SOURCE.is_file(),'Final STEP must exist')
    _require(not(OUT/'step-roundtrip.json').exists(),'Preserve final round-trip receipt')
    export=json.loads((OUT/'export.json').read_text())
    step_export=json.loads((OUT/'step-export.json').read_text())
    source_hash=hashlib.sha256(SOURCE.read_bytes()).hexdigest()
    _require(source_hash==step_export['sha256'],'Final STEP bytes differ from export receipt')
    _require(step_export['native_sha256']==export['sha256'] and
        hashlib.sha256(Path(export['native_archive']).read_bytes()).hexdigest()==export['sha256'],
        'Final native archive bytes differ from the STEP source checkpoint')
    before=checkpoint._state(d);protected=prior._documents(app,doc);modified=doc.isModified
    _require(before==export['state'],'Live source differs from archived final native')
    accuracy=fusion.CalculationAccuracy.VeryHighCalculationAccuracy
    expected=[r for r in step._accurate_bodies(d,accuracy)if r['component']!='Configuration reference — JJ oxygen sensor measurement envelope']
    _require(step._summary(expected)['placed_solid_count']==2543,'Unexpected final physical solid count')
    temp=None;result=None
    try:
        options=app.importManager.createSTEPImportOptions(str(SOURCE));options.isViewFit=False
        temp=app.importManager.importToNewDocument(options)
        _require(temp and not temp.isSaved,'Only own new unsaved STEP document is allowed')
        design=fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
        actual=step._accurate_bodies(design,accuracy)
        comparison=step._compare(step._summary(actual),step._summary(expected))
        pairs=step._per_body_comparison(actual,expected)
        result={'generated_at_utc':datetime.now(timezone.utc).isoformat(),
            'source_file':str(SOURCE),'source_sha256':source_hash,'native_sha256':export['sha256'],
            'source_board_sha256':BOARD_SHA,'input_main_STEP_sha256':STEP_SHA,
            'method':'Fusion unit-aware import, explicit VeryHighCalculationAccuracy for both native and imported placed solids; actual returned accuracy recorded. No manual scaling.',
            'native_summary':step._summary(expected),'imported_summary':step._summary(actual),
            'comparison':comparison,'per_body_diagnostic':pairs,'native_bodies':expected,'imported_bodies':actual,
            'status':'numerical_checks_pass'if comparison['pass']else'numerical_or_geometry_exception_requires_disposition',
            'numerical_criteria':{'bounds_mm':.02,'relative_total_volume':1e-6,'absolute_volume_floor_mm3':.01},
            'documented_VeryHigh_accuracy_fraction':.0001,
            'accuracy_source':'https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/CalculationAccuracy.htm',
            'limits':'One ppm is a strict numerical diagnostic below the API documented ±0.01% VeryHigh calculation accuracy. It is not a manufacturing tolerance. Any failure remains in this receipt and requires source-specific dimensional assessment; native archive remains authoritative.'}
    finally:
        try:
            if temp:_require(temp.close(False),'Failed to close own temporary STEP document')
        finally:_require(doc.activate(),'Failed to return to SystemReview')
        preserved=before==checkpoint._state(d) and protected==prior._documents(app,doc) and modified==doc.isModified
        if result:
            result['cleanup']={'temporary_closed_without_save':temp is not None,'source_and_protected_documents_preserved':preserved,
                'active_owned_cloud_lineage':app.activeDocument.dataFile.id,'owned_modified_flag_unchanged':modified==doc.isModified}
            (OUT/'step-roundtrip.json').write_text(json.dumps(result,indent=2)+'\n')
        _require(preserved,'STEP round-trip changed source or protected documents')
    return result
