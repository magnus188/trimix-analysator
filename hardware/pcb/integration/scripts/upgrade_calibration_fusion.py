"""Refresh only the main PCB import for the ADS122C04 calibration revision."""
from pathlib import Path
import hashlib, json
import adsk.core as core
import adsk.fusion as fusion
import fusion_fit as fit
BASE=Path(__file__).resolve().parents[1]
OUT=BASE/'verification/software-calibration'

def refresh():
    app,doc,d=fit.owned()
    o=next(q for q in d.rootComponent.occurrences if q.component.name=='PCB A3 - main four-layer placement')
    c=o.component;path=BASE/'exports/Trimix_Analyzer_A3_Placement.step'
    sha=hashlib.sha256(path.read_bytes()).hexdigest()
    previous=c.attributes.itemByName('TrimixPcbFit','source_step_sha256').value
    if sha==previous:raise RuntimeError('Current PCB already imported')
    if previous!='aeffd7cddb89af1afc04b4360170b779812ec393a376732e6e819d9a0b8490c5':raise RuntimeError('Unreviewed source PCB import')
    transform=o.transform2.asArray();before=fit._bounds(o)
    if len(c.occurrences)!=1:raise RuntimeError('Expected one previous STEP assembly')
    for child in list(c.occurrences):
        f=c.features.removeFeatures.add(child)
        if not f:raise RuntimeError('Cannot retire previous import')
        f.name='Replace ADS1115 and trimmer PCB with ADS122C04 and matched divider'
    if not app.importManager.importToTarget(app.importManager.createSTEPImportOptions(str(path)),c):raise RuntimeError('STEP import failed')
    if o.transform2.asArray()!=transform:raise RuntimeError('Purchased geometry registration changed')
    after=fit._bounds(o)
    if any(abs(before[k][axis]-after[k][axis])>.0001 for k in (0,1) for axis in (0,1)):raise RuntimeError('Board XY envelope changed')
    if after[0][2]<before[0][2]-.0001 or after[1][2]>before[1][2]+.0001:raise RuntimeError('Board Z envelope grew')
    bodies=[b for q in c.allOccurrences for b in q.component.bRepBodies if b.isSolid]
    if not 600<len(bodies)<750:raise RuntimeError('Unexpected imported solid count')
    c.attributes.add('TrimixPcbFit','source_step_sha256',sha)
    c.attributes.add('TrimixSoftwareCalibration','main_solid_count',str(len(bodies)))
    c.description='Actual unrouted four-layer PCB: two ADS122C04IPWR converters, fixed matched2k divider; existing gas sensors retained'
    receipt={'status':'imported_pending_fit_checks','before_sha256':previous,'after_sha256':sha,'before_mm':before,'after_mm':after,'registration_mm':[50.4,120,20.545],'transformation_unchanged':True,'main_solid_count':len(bodies),'no_purchased_component_scaling':True}
    (OUT/'fusion-refresh.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt))

def static():
    fit._audit_board('PCB A3 - main four-layer placement','software-calibration/pcb-static.json')
    fit._audit_board('Carrier / removable electronics tray','software-calibration/carrier-static.json')

def service():
    app,doc,d=fit.owned()
    c=next(q.component for q in d.rootComponent.occurrences if q.component.name=='PCB A3 - main four-layer placement')
    count=int(c.attributes.itemByName('TrimixSoftwareCalibration','main_solid_count').value)
    receipt=json.loads((OUT/'fusion-refresh.json').read_text())
    if count!=receipt['main_solid_count']:raise RuntimeError('Solid-count receipt mismatch')
    source=Path(fit.__file__).read_text()
    replacements={
      'len(moving)!=686':f'len(moving)!={count+1}',
      '[50.2,103,18.5,59,120.5,top]':'[50.2,103,18.5,59.4,120.5,top]',
      '[80.5,47.4,18.5,81.2,84.6,top]]':'[80.5,47.4,18.5,81.2,84.6,top], [50.2,96.99,15,59.4,109.81,top]]',
      "report('pcb-service-check.json'":"report('software-calibration/service-check.json'"}
    for old,new in replacements.items():
        if source.count(old)!=1:raise RuntimeError('Helper changed: '+old)
        source=source.replace(old,new)
    ns={'__file__':fit.__file__,'__name__':'software_calibration_service'}
    exec(compile(source,fit.__file__,'exec'),ns);ns['service_check']()

def deliver():
    for name in ('pcb-static.json','carrier-static.json'):
        r=json.loads((OUT/name).read_text())
        if r['hits'] or r['errors']:raise RuntimeError('Static fit failed '+name)
    if json.loads((OUT/'service-check.json').read_text())['status']!='clear_for_modeled_geometry':raise RuntimeError('Service failed')
    fit.deliver()

def reopen():fit.reopen_check()

def finish_import_after_shrunk_envelope_review():
    """Resume the completed import after correcting the min-Z shrink assertion."""
    app,doc,d=fit.owned()
    o=next(q for q in d.rootComponent.occurrences if q.component.name=='PCB A3 - main four-layer placement');c=o.component
    old=json.loads((BASE/'verification/main-step-refresh.json').read_text())
    previous=c.attributes.itemByName('TrimixPcbFit','source_step_sha256').value
    if previous!=old['current_sha256']:raise RuntimeError('Prior import identity changed')
    before=old['after_mm'];after=fit._bounds(o)
    if any(abs(before[k][axis]-after[k][axis])>.0001 for k in (0,1) for axis in (0,1)):raise RuntimeError('XY grew')
    if after[0][2]<before[0][2]-.0001 or after[1][2]>before[1][2]+.0001:raise RuntimeError('Z grew')
    if list(o.transform2.asArray())!=[1.,0.,0.,5.04,0.,1.,0.,12.,0.,0.,1.,2.0545,0.,0.,0.,1.]:raise RuntimeError('Registration changed')
    count=sum(b.isSolid for q in c.allOccurrences for b in q.component.bRepBodies)
    if count!=690:raise RuntimeError('Expected690 inspected new solids')
    path=BASE/'exports/Trimix_Analyzer_A3_Placement.step';sha=hashlib.sha256(path.read_bytes()).hexdigest()
    c.attributes.add('TrimixPcbFit','source_step_sha256',sha)
    c.attributes.add('TrimixSoftwareCalibration','main_solid_count',str(count))
    c.description='Actual unrouted four-layer PCB: two ADS122C04IPWR converters, fixed matched2k divider; existing gas sensors retained'
    receipt={'status':'imported_pending_fit_checks','before_sha256':previous,'after_sha256':sha,'before_mm':before,'after_mm':after,'registration_mm':[50.4,120,20.545],'transformation_unchanged':True,'main_solid_count':count,'no_purchased_component_scaling':True,'envelope_review':'MinZ rises2.52mm and maxZ falls2.51mm because the through-hole trimmer was removed. XYunchanged. Initial assertion rejected this reduction; no failed import was repeated.'}
    (OUT/'fusion-refresh.json').write_text(json.dumps(receipt,indent=2)+'\n');print(json.dumps(receipt))
