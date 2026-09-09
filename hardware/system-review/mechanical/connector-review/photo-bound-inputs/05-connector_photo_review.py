"""Separate, source-bound Guition/cable engineering review; explicit stages only.

The v11 archive and unrelated open documents are never edited. Photo positions,
unmeasured component Z and cable allowances remain separate from measured facts.
"""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, importlib, json, math, sys

BASE = Path(__file__).resolve().parents[1]
ROOT = BASE.parents[2]
OUT = BASE / 'connector-review'
PHOTO = ROOT / 'hardware/system-review/integration-photo'
NAME = 'Trimix_Enclosure_A3_ConnectorReview'
GROUP = 'TrimixConnectorPhotoReview'
ARCHIVE = BASE / 'final-local-checkpoint/Trimix_Enclosure_A3_SystemReview_FinalLocal.f3d'
ARCHIVE_SHA = 'ff54c4b6a6a844830fb079617210f0c61bc46e416712e56d8a636c9e695a2309'
FOLDER_ID = 'urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def write(name, data):
    OUT.mkdir(parents=True, exist_ok=True)
    path = OUT / name
    path.write_text(json.dumps(data, indent=2) + '\n')
    print(json.dumps({'report': str(path), 'sha256': sha(path),
                      'status': data.get('status'), 'checks': data.get('checks')}))
    return data


def docs(app):
    return [{'name': q.name, 'id': q.dataFile.id if q.dataFile else None,
             'modified': q.isModified} for q in app.documents]


def box_bounds(body):
    bb = body.boundingBox
    return [[x*10 for x in bb.minPoint.asArray()], [x*10 for x in bb.maxPoint.asArray()]]


def owned():
    import adsk.core as core
    import adsk.fusion as fusion
    app = core.Application.get(); doc = app.activeDocument
    if not doc or not doc.name.startswith(NAME):
        raise RuntimeError('Activate only the owned ConnectorReview copy; no other design edits allowed')
    d = fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    attr = d.rootComponent.attributes.itemByName(GROUP, 'source_sha256') if d else None
    if not attr or attr.value != ARCHIVE_SHA:
        raise RuntimeError('Exact v11 source ownership marker missing')
    return app, doc, d


def helpers():
    path = str(ROOT / 'hardware/cad/rev04/scripts')
    if path not in sys.path: sys.path.insert(0, path)
    import build_a3 as b
    importlib.reload(b)
    b.get = lambda: (owned()[0], owned()[2])
    return b


def inspect():
    import adsk.core as core
    import adsk.fusion as fusion
    app = core.Application.get()
    rows = []
    for doc in app.documents:
        d = fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
        rows.append({'name': doc.name, 'id': doc.dataFile.id if doc.dataFile else None,
                     'modified': doc.isModified, 'active': doc == app.activeDocument,
                     'timeline': d.timeline.count if d else None})
    write('startup-documents.json', {'documents': rows, 'status': 'read_only_inventory'})


def recover_saved_v1():
    import adsk.core as core
    import adsk.fusion as fusion
    app=core.Application.get();before=docs(app)
    if any(x.name.startswith(NAME) for x in app.documents):
        raise RuntimeError('Review copy already open; inspect exact state first')
    source=app.data.findFileById('urn:adsk.wipprod:dm.lineage:5M736I5UQDqcDS_xgq9lMQ')
    if not source or source.name!=NAME or source.versionNumber!=1 or not source.isComplete:
        raise RuntimeError('Saved review v1 identity changed')
    doc=app.documents.open(source,True)
    app,doc,d=owned()
    count=sum(body.isSolid for o in d.rootComponent.allOccurrences for body in o.bRepBodies)
    checks={'timeline_1211':d.timeline.count==1211,'solid_count_2546':count==2546,
            'unmodified':not doc.isModified,
            'other_documents_preserved':[x for x in docs(app) if not x['name'].startswith(NAME)]==before}
    write('recovery-opened-v1.json',{'status':'saved_v1_reopened' if all(checks.values()) else 'unexpected_recovery_state',
        'checks':checks,'documents':docs(app),'cloud_id':doc.dataFile.id,'version':doc.dataFile.versionNumber,
        'timeline':d.timeline.count,'solid_count':count,
        'recovery_dialog_disposition':'Root closed recovery dialog; recovery files retained, none opened or deleted',
        'termination':'SIGTERM exact PID47809; process exited after8second wait; SIGKILL identity guard aborted before any signal'})
    if not all(checks.values()):raise RuntimeError('Recovered state differs; do not build')


def basefeature_model():
    import connector_basefeature_review as implementation
    importlib.reload(implementation)
    implementation.build()


def clone():
    import adsk.core as core
    import adsk.fusion as fusion
    app = core.Application.get()
    if sha(ARCHIVE) != ARCHIVE_SHA: raise RuntimeError('v11 native archive changed')
    if any(x.name.startswith(NAME) for x in app.documents):
        raise RuntimeError('ConnectorReview already open; inspect before resuming')
    before = docs(app)
    folder = app.data.findFolderById(FOLDER_ID)
    if not folder or folder.name != 'Trimix analyzer': raise RuntimeError('Wrong destination folder')
    doc = app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(ARCHIVE)))
    if not doc: raise RuntimeError('v11 import failed')
    doc.name = NAME
    d = fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    d.rootComponent.attributes.add(GROUP, 'source_sha256', ARCHIVE_SHA)
    d.rootComponent.attributes.add(GROUP, 'status', 'PHOTO-REGISTERED CONNECTOR AND LOOM REVIEW; NOT PHYSICAL FIT QUALIFICATION')
    bodies = [body for occurrence in d.rootComponent.allOccurrences for body in occurrence.bRepBodies if body.isSolid]
    checks = {'timeline_1211': d.timeline.count == 1211, 'solid_count_2546': len(bodies) == 2546,
              'other_documents_preserved': [x for x in docs(app) if not x['name'].startswith(NAME)] == before}
    if not all(checks.values()):
        write('clone-failed.json', {'checks': checks, 'before': before, 'after': docs(app), 'status': 'guard_failed'})
        raise RuntimeError('Imported archive identity/preservation check failed; do not save')
    saved = doc.saveAs(NAME, folder, 'Separate Guition photo/connector/SD and complete cable-route review; preserves SystemReview v11', '')
    write('clone.json', {'checks': checks, 'saved': saved, 'source_file': str(ARCHIVE), 'source_sha256': ARCHIVE_SHA,
                         'document': doc.name, 'id': doc.dataFile.id if doc.dataFile else None,
                         'before': before, 'after': docs(app), 'timeline': d.timeline.count,
                         'solid_count': len(bodies), 'status': 'separate_review_created' if saved else 'cloud_save_pending'})


def _health(d):
    import adsk.fusion as fusion
    bad=[]; rollups=[]; retired=[]
    for i in range(d.timeline.count):
        t=d.timeline.item(i)
        if t.healthState != fusion.FeatureHealthStates.HealthyFeatureHealthState:
            row={'index':i,'name':t.name,'message':t.errorOrWarningMessage}
            if (t.healthState == fusion.FeatureHealthStates.SuppressedFeatureHealthState
                    and t.name.startswith('USB grounding wing reference')
                    and i in (567,570,573,576)):
                retired.append(row)
                continue
            (rollups if t.objectType==fusion.TimelineGroup.classType() and not row['message'] else bad).append(row)
    return {'healthy':not bad,'unhealthy':bad,'empty_group_rollups':rollups,
            'historically_retired_USB_wing_features':retired}


def _legacy(c):
    return c.name == '06 Guition PCB and connectors — illustrative detail'


def _fingerprint(d, omit_photo=False):
    rows=[]
    for o in d.rootComponent.allOccurrences:
        if omit_photo and (_legacy(o.component) or o.component.attributes.itemByName(GROUP,'photo_geometry')):continue
        for body in o.bRepBodies:
            if body.isSolid:
                rows.append({'path':o.fullPathName,'body':body.name,'bounds_mm':box_bounds(body),
                             'volume_mm3':body.volume*1000})
    return sorted(rows,key=lambda r:(r['path'],r['body']))


def _new(b,name,basis,role='display',envelope=False):
    c=b.new(name,basis);c.description=basis
    c.attributes.add(GROUP,'photo_geometry','true')
    c.attributes.add(GROUP,'geometry_role','clearance_envelope' if envelope else 'photo_positioned_reference')
    c.attributes.add('TrimixRev04','physical_group',role)
    c.attributes.add(GROUP,'precision','Photo XY reference; only26contactcount/2.54pitch and13.4glass-to-baretip are established')
    return c


def photo_model():
    """Replace the complete obsolete display PCB/detail body set in this copy only."""
    import adsk.core as core
    app,doc,d=owned();b=helpers()
    if d.rootComponent.attributes.itemByName(GROUP,'photo_model_added'):raise RuntimeError('Photo stage already applied')
    reg=json.loads((PHOTO/'registration.json').read_text())
    if reg['schema']!=2 or reg['owner_depth_measurement']['distance_mm']!=13.4:raise RuntimeError('Wrong registration/depth source')
    if sha(PHOTO/'guition-manufacturer/JC4880P443C_I_W_Y.pdf') != reg['manufacturer_dimension_source_sha256']:
        raise RuntimeError('Manufacturer drawing changed')
    protected_before=_fingerprint(d,True)
    old=[c for c in d.allComponents if _legacy(c)]
    if len(old)!=1:raise RuntimeError('Expected one obsolete Guition detail definition')
    old=old[0]; removed=[]
    for body in list(old.bRepBodies):
        removed.append({'name':body.name,'bounds_mm':box_bounds(body),'volume_mm3':body.volume*1000})
        feature=old.features.removeFeatures.add(body)
        feature.name='Remove obsolete Guition illustration: '+body.name
    # Native tip height is independently measured. These base dimensions are
    # deliberately explicit references and do not determine the socket-height proof.
    params=[('GuitionTipDepth','13.4 mm','Owner measured frontglass to26barepin tips; uncertainty unspecified'),
            ('GuitionPostReference','6 mm','Unmeasured exposedpost reference; changes PCB/bodyvisualZ only'),
            ('GuitionHeaderBaseReference','2.54 mm','Unmeasured standardheaderbody reference, notselectedGuitionMPN'),
            ('GuitionPcbTopReference','DisplayFront+GuitionTipDepth-GuitionPostReference-GuitionHeaderBaseReference','Derived visualization datum only; PCBtop NOT measured'),
            ('GuitionHeaderX','DisplayX+35.178 mm','Photo hole-grid registered centre; +/-2mm engineeringposition collar'),
            ('GuitionHeaderY','DisplayY+100.8025 mm','Photo registeredcentre, rows retain exact2.54pitch'),
            ('GuitionMateDepthAllowance','17.8 mm','From13.4tips +3.937maxconditionalcap +.463engineeringallowance; remotemateunqualified')]
    for name,expression,comment in params:
        if d.userParameters.itemByName(name):raise RuntimeError('Parameter already exists '+name)
        d.userParameters.add(name,core.ValueInput.createByString(expression),'mm',comment)
    c=_new(b,'Guition / PCB and core photo reference','IllustrativePCBoutline65.06x108; exposedPCBdimensions, thickness1.6 andfrontstackareunmeasuredreferences. Caseeargrid60x108 is a distinct registration datum.')
    pcb=b.box(c,'Guition photo PCB - Z reference only','DisplayX+(DisplayWidth-65.06 mm)/2','DisplayY+(DisplayHeight-108 mm)/2',
              'GuitionPcbTopReference-1.6 mm','65.06 mm','108 mm','1.6 mm')
    # Illustrative PCB fixing holes only: the drawing does not dimension these; 60x108 is the casing-ear grid.
    for x in ('DisplayX+4.65 mm','DisplayX+64.65 mm'):
        for y in ('DisplayY+7.1 mm','DisplayY+109.7 mm'):
            b.cyl(c,'Guition PCB mounting reference',x,y,'GuitionPcbTopReference-1.7 mm','2.5 mm','1.8 mm','cut',pcb)
    for name,x,y,w,h,z in [('Core shield',22,31,25,25,3.0),('LCD FPC latch',24,19,23,5,2.0),('Touch FPC latch',53,90,7,5,1.8)]:
        b.box(c,name+' photo reference',f'DisplayX+{x} mm',f'DisplayY+{y} mm','GuitionPcbTopReference',f'{w} mm',f'{h} mm',f'{z} mm')
    h=_new(b,'Guition / JP1 26-pin header photo reference','All26pins fitted including7. Exact2.54pitch; pin1atlower-left inownerrearphoto. Squarepost.64/base33.02x5.08 areunmeasuredreferences; tipsanchoredtoowner13.4mm.')
    b.box(h,'JP1 reference insulator','GuitionHeaderX-16.51 mm','GuitionHeaderY-2.54 mm','GuitionPcbTopReference','33.02 mm','5.08 mm','GuitionHeaderBaseReference')
    for i in range(13):
        for row in range(2):
            pin=2*i+row+1
            b.box(h,f'JP1 pin {pin:02d}'+(' - pin1 orientation datum' if pin==1 else ''),
                  f'GuitionHeaderX+{(i-6)*2.54-.32:.4f} mm',f'GuitionHeaderY+{(-1.27 if row==0 else 1.27)-.32:.4f} mm',
                  'DisplayFront+GuitionTipDepth-GuitionPostReference','.64 mm','.64 mm','GuitionPostReference')
    usb=[]
    for label,x,y in [('left',26.608,95.450),('right',37.922,95.149)]:
        u=_new(b,'Guition / '+label+' rear-facing USB-C photo reference','Ownerphoto andmanufacturerrearview showrear-facing(+Z)mouth.9.5x4.5shell/6mmheightareunmeasuredclearancereferences; exactGuitionconnectorMPNunknown.')
        shell=b.box(u,label+' upright USB-C shell reference',f'DisplayX+{x-4.75} mm',f'DisplayY+{y-2.25} mm','GuitionPcbTopReference','9.5 mm','4.5 mm','6 mm')
        b.box(u,label+' USB-C mouth aperture',f'DisplayX+{x-4.2} mm',f'DisplayY+{y-1.3} mm','GuitionPcbTopReference+2 mm','8.4 mm','2.6 mm','4.1 mm','cut',shell)
        b.box(u,label+' USB-C tongue reference',f'DisplayX+{x-3.35} mm',f'DisplayY+{y-.35} mm','GuitionPcbTopReference+2 mm','6.7 mm','.7 mm','3.3 mm')
        usb.append({'component':u.name,'mouth_normal':[0,0,1]})
    sd=_new(b,'Guition / left microSD holder photo reference','PhotoXYshell15.184x15.513;2.3mmholderheightreference. Card11x15x1format, userconfirmsinstalled. Ejecttype/travel/fingerclearanceunmeasured.')
    shell=b.box(sd,'microSD holder reference','DisplayX+5.284 mm','DisplayY+60.202 mm','GuitionPcbTopReference','15.184 mm','15.513 mm','2.3 mm')
    b.box(sd,'microSD left-facing card cavity','DisplayX+4.659 mm','DisplayY+62.479 mm','GuitionPcbTopReference+.3 mm','15.8 mm','11.4 mm','1.2 mm','cut',shell)
    card=_new(b,'Guition / installed microSD format reference','Installedcardformatexact11x15x1; .5mmprojectionandcardseatZreferenceonly. No brand/capacity/suppliedMPN inferred.',role='display_card')
    b.box(card,'Installed microSD 15x11x1','DisplayX+4.859 mm','DisplayY+62.679 mm','GuitionPcbTopReference+.4 mm','15 mm','11 mm','1 mm')
    mate=_new(b,'Guition / candidate unkeyed JP1 socket allocation','Remoteunkeyedfemale candidateonly: sourceIDSDmatinginsertion5.588..6.223 andheight9.144..9.525, conditionalcap16.321..17.337fromglass; allowance17.8. Guitionpin7exists; NEVERapplymainendblockedcavity7.',role='display_harness_mate',envelope=True)
    b.box(mate,'Guition remote socket engineering allowance','GuitionHeaderX-17.5 mm','GuitionHeaderY-2.75 mm',
          'DisplayFront+GuitionTipDepth-6.223 mm','35 mm','5.5 mm','GuitionMateDepthAllowance-GuitionTipDepth+6.223 mm')
    for o in d.rootComponent.allOccurrences:
        if o.component==mate:o.isLightBulbOn=False
    if not d.computeAll():raise RuntimeError('Photo geometry recompute failed')
    protected_after=_fingerprint(d,True)
    checks={'other_geometry_exact_scalar_identity':protected_before==protected_after,'native_health':_health(d)['healthy'],
            'all26pins_including7':len([q for q in h.bRepBodies if q.name.startswith('JP1 pin ')])==26,
            'measured_bare_tip_mm':abs(max(q.boundingBox.maxPoint.z*10 for q in h.bRepBodies)-(b.mm(d,'DisplayFront')+13.4))<1e-6}
    d.rootComponent.attributes.add(GROUP,'photo_model_added',sha(PHOTO/'registration.json'))
    write('photo-model.json',{'document':doc.name,'status':'photo_model_created' if all(checks.values()) else 'needs_review',
          'checks':checks,'source_registration':reg,'source_registration_sha256':sha(PHOTO/'registration.json'),
          'removed_obsolete_bodies':removed,'parameters':[{'name':x,'expression':y,'basis':z}for x,y,z in params],
          'new_bodies':[{'component':o.component.name,'name':q.name,'bounds_mm':box_bounds(q)}for o in d.rootComponent.allOccurrences if o.component.attributes.itemByName(GROUP,'photo_geometry') for q in o.bRepBodies],
          'health':_health(d),'usb':usb,'unqualified':['PCBstack/Z','postdimensions/usableinsertion','allGuitionconnectorMPNs','remotemate','USBserviceplugs','SDholderheight/eject/grip','photoparallax']})
    if not all(checks.values()):raise RuntimeError('Photo-model preservation/health check failed')


def check_interfaces():
    import connector_cable_checks as checks
    importlib.reload(checks)
    checks.interfaces()


def check_chamber_routes():
    import connector_cable_checks as checks
    importlib.reload(checks)
    checks.chamber_routes()


def save_photo_stage():
    """Retain the corrected purchased-reference checkpoint before cable redesign."""
    app,doc,d=owned()
    result=json.loads((OUT/'photo-model.json').read_text())
    if not all(result['checks'].values()) or not _health(d)['healthy']:
        raise RuntimeError('Only the healthy, preservation-checked photo stage may be saved')
    before=docs(app)
    if not doc.save('Registered Guition header/dual rear-facingUSB/SD from ownerphoto;13.4mm baretips measured. Remote mate/wiring/service remain under review.'):
        raise RuntimeError('Cloudsave failed')
    path=OUT/(NAME+'_Photo.f3d')
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):
        raise RuntimeError('Photo archive export failed')
    files=[ARCHIVE,PHOTO/'registration.json',PHOTO/'IMG_0571.png',
           PHOTO/'guition-manufacturer/JC4880P443C_I_W_Y.pdf',OUT/'photo-model.json',Path(__file__),
           BASE/'scripts/connector_basefeature_review.py',OUT/'basefeature-health-disposition.json',
           OUT/'basefeature-health-inspect.json',OUT/'recovery-v1-disposition.json']
    files=[p for p in files if p.exists()]
    other_before=[x for x in before if not x['name'].startswith(NAME)]
    other_after=[x for x in docs(app) if not x['name'].startswith(NAME)]
    write('photo-checkpoint.json',{'status':'photo_reference_checkpoint_saved_cables_pending',
          'document':doc.name,'id':doc.dataFile.id if doc.dataFile else None,'version':doc.dataFile.versionNumber if doc.dataFile else None,
          'native_file':str(path),'native_sha256':sha(path),'native_bytes':path.stat().st_size,
          'source_sha256':ARCHIVE_SHA,'source_bindings':[{'path':str(p),'sha256':sha(p)}for p in files],
          'other_documents_preserved':other_before==other_after,'other_documents':other_after,
          'timeline':d.timeline.count,'health':_health(d),
          'limits':'Photoregistered XY and conservativeunmeasuredZ/mates; completecable andSDservice proofs are subsequentexplicitstages. No productionorprintfit claim.'})
