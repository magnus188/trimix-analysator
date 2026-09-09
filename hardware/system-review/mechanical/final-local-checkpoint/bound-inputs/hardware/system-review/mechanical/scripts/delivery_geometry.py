"""Owned native/STEP exports and isolated numerical roundtrip checks.

Only the default physical AO2 assembly enters STEP; the hidden JJ alternative
remains editable in the native archive. No print jobs or animations are made.
"""
from datetime import datetime,timezone
from pathlib import Path
import hashlib,json,zipfile
import adsk
import adsk.fusion as fusion
from runtime import owned,configure,report,BASE,other_documents

STEM='Trimix_Enclosure_A3_SystemReview'


def _sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def export():
    app,doc,d=owned();configure()
    import review_a3 as views
    import review_checks as checks
    if not checks.health(d)['pass']:raise RuntimeError('Cannot export unhealthy model')
    before_other=other_documents(app);timeline=d.timeline.count
    state=views._visibility(d);paths={suffix:BASE/(STEM+'.'+suffix) for suffix in ('step','f3d')}
    try:
        # STEP only needs physical occurrence/body visibility; leave sketches,
        # origins, construction planes and active-component context untouched.
        for c in d.allComponents:
            for body in c.bRepBodies:body.isLightBulbOn=True
        for o in d.rootComponent.allOccurrences:o.isLightBulbOn=True
        for o in d.rootComponent.occurrences:
            if o.component.partNumber=='REF-JJ-O2':o.isLightBulbOn=False
        adsk.doEvents();app.activeViewport.refresh()
        options=d.exportManager.createSTEPExportOptions(str(paths['step']),d.rootComponent)
        if not d.exportManager.execute(options):raise RuntimeError('STEP export failed')
    finally:
        views._restore_visibility(d,state);adsk.doEvents();app.activeViewport.refresh()
    options=d.exportManager.createFusionArchiveExportOptions(str(paths['f3d']))
    if not d.exportManager.execute(options):raise RuntimeError('Native archive export failed')
    with zipfile.ZipFile(paths['f3d']) as archive:
        error=archive.testzip();members=len(archive.namelist())
    if error:raise RuntimeError('Native ZIP CRC failure '+error)
    if d.timeline.count!=timeline or other_documents(app)!=before_other:raise RuntimeError('Export changed source timeline or protected documents')
    if not doc.save('SystemReview mechanical corrections and latest populated board integration; physical interfaces remain qualification gates'):raise RuntimeError('SystemReview cloud save failed')
    report('geometry-export.json',{'document':doc.name,'cloud_id':doc.dataFile.id,'timeline':timeline,
       'files':{k:{'file':str(v),'bytes':v.stat().st_size,'sha256':_sha(v)}for k,v in paths.items()},
       'native_archive_zip_crc_pass':True,'native_archive_members':members,
       'step_configuration':'Default physical AO2 assembly; alternative JJ envelope hidden/excluded',
       'native_configuration':'AO2 physical assembly plus hidden editable JJ comparative envelope',
       'source_visibility_restored':True,'other_documents_preserved':before_other,
       'status':'exported_pending_roundtrip','physical_or_manufacturing_release':False})


def verify_step():
    app,doc,d=owned();configure()
    import step_a3 as step
    import audit_a3 as audit
    source=BASE/(STEM+'.step')
    if not source.is_file():raise FileNotFoundError(source)
    accuracy=fusion.CalculationAccuracy.VeryHighCalculationAccuracy
    native_all=step._accurate_bodies(d,accuracy)
    expected=[r for r in native_all if r['component']!='Configuration reference — JJ oxygen sensor measurement envelope']
    baseline=audit._bodies(d);poses=step._poses(d);timeline=d.timeline.count
    protected=other_documents(app);temporary=None;result=None;cleanup={}
    try:
        options=app.importManager.createSTEPImportOptions(str(source));options.isViewFit=False
        temporary=app.importManager.importToNewDocument(options)
        if not temporary or temporary.isSaved:raise RuntimeError('Expected new unsaved STEP check document')
        imported=fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        if not imported:raise RuntimeError('STEP import has no design')
        actual=step._accurate_bodies(imported,accuracy)
        comparison=step._compare(step._summary(actual),step._summary(expected))
        pairs=step._per_body_comparison(actual,expected)
        result={'status':'pass' if comparison['pass'] else 'numerical_or_geometry_exception',
           'source_file':str(source),'source_sha256':_sha(source),'comparison':comparison,
           'native_summary':step._summary(expected),'imported_summary':step._summary(actual),
           'native_bodies':expected,'imported_bodies':actual,'per_body_diagnostic':pairs,
           'method':'Fusion unit-aware STEP import; explicit VeryHigh physical properties for both sides; no scaling.',
           'unchanged_numerical_criteria':{'bounds_mm':.02,'relative_total_volume':1e-6,'absolute_volume_floor_mm3':.01},
           'default_alternative_exclusion':'Only the three hidden JJ comparative solids are excluded from expected STEP.',
           'limits':'1 ppm volume is a numerical comparison criterion, not an API accuracy guarantee or manufacturing tolerance. Any exception remains recorded; native archive is authoritative.'}
    finally:
        try:
            if temporary and not temporary.close(False):raise RuntimeError('Could not close temporary STEP document without save')
        finally:
            if not doc.activate():raise RuntimeError('Could not reactivate SystemReview')
        cleanup={'temporary_closed_without_save':temporary is not None,'native_reactivated':app.activeDocument==doc,
          'native_geometry_unchanged':audit._bodies(d)==baseline,'native_poses_unchanged':step._poses(d)==poses,
          'native_timeline_unchanged':d.timeline.count==timeline,'protected_documents_unchanged':other_documents(app)==protected}
        if result:report('step-roundtrip.json',{**result,'cleanup':cleanup,'generated_at_utc':datetime.now(timezone.utc).isoformat()})
        if not all(cleanup.values()):raise RuntimeError('STEP check cleanup/source preservation failed')
    return result


def verify_native():
    app,doc,d=owned();configure()
    import audit_a3 as audit
    import step_a3 as step
    source=BASE/(STEM+'.f3d');baseline=audit._bodies(d);poses=step._poses(d);protected=other_documents(app)
    parameters={p.name:{'expression':p.expression,'value':p.value}for p in d.userParameters}
    timeline=d.timeline.count;temporary=None;result=None
    try:
        options=app.importManager.createFusionArchiveImportOptions(str(source))
        temporary=app.importManager.importToNewDocument(options)
        if not temporary or temporary.isSaved:raise RuntimeError('Expected new unsaved native archive copy')
        imported=fusion.Design.cast(temporary.products.itemByProductType('DesignProductType'))
        actual=audit._bodies(imported)
        imported_params={p.name:{'expression':p.expression,'value':p.value}for p in imported.userParameters}
        result={'file':str(source),'sha256':_sha(source),'placed_solid_count':sum(r['solid']for r in actual),
                'native_timeline':timeline,'imported_timeline':imported.timeline.count,'parameter_count':len(parameters),
                'geometry_match':actual==baseline,'parameter_match':imported_params==parameters,
                'timeline_match':imported.timeline.count==timeline,'poses_match':step._poses(imported)==poses}
        result['pass']=all(result[k]for k in ('geometry_match','parameter_match','timeline_match','poses_match'))
    finally:
        try:
            if temporary and not temporary.close(False):raise RuntimeError('Could not close native archive check copy')
        finally:
            if not doc.activate():raise RuntimeError('Could not reactivate SystemReview')
        preserved=audit._bodies(d)==baseline and step._poses(d)==poses and other_documents(app)==protected
        if result:report('native-roundtrip.json',{**result,'temporary_closed_without_save':temporary is not None,'source_and_other_documents_preserved':preserved})
        if not preserved:raise RuntimeError('Native archive check changed protected source state')
    return result
