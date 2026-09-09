"""PCB integration in a separate Fusion design; never enters Animation."""
from pathlib import Path
import sys,json,hashlib
import adsk.core as core
import adsk.fusion as fusion
BASE=Path(__file__).resolve().parents[1]
HW=BASE.parent
NAME='Trimix_Enclosure_A3_PCBFit'
FOLDER='urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'

def report(name,data):
    path=BASE/'verification'/name
    path.write_text(json.dumps(data,indent=2)+'\n')
    compact=json.dumps(data)
    print(compact if len(compact)<10000 else json.dumps({'report':str(path),'keys':list(data),'list_counts':{k:len(v) for k,v in data.items() if isinstance(v,list)}}))

def owned():
    app=core.Application.get();doc=app.activeDocument
    if not doc or not doc.name.startswith(NAME):
        matches=[q for q in app.documents if q.name.startswith(NAME)]
        if len(matches)!=1:raise RuntimeError('Expected one separate PCBFit design')
        doc=matches[0]
        if not doc.activate():raise RuntimeError('Could not activate PCB fit document')
    design=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    if not design:raise RuntimeError('No Design product')
    return app,doc,design

def clone():
    app=core.Application.get()
    if any(d.name.startswith(NAME) for d in app.documents):raise RuntimeError('PCBFit already open; resume it')
    source=HW/'cad/rev04/3d-print/Trimix_Enclosure_A3_PrintReview.f3d'
    expected='4b96520e53cada5e54fdb7040b42f5d6c936345fef0a05a021a3819fd364bebb'
    if hashlib.sha256(source.read_bytes()).hexdigest()!=expected:raise RuntimeError('Unexpected source archive')
    folder=app.data.findFolderById(FOLDER)
    if not folder:raise RuntimeError('Trimix analyzer folder not found')
    doc=app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(source)))
    if not doc:raise RuntimeError('Archive import failed')
    app.userInterface.workspaces.itemById('FusionSolidEnvironment').activate()
    d=fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    if d.timeline.count!=1078 or d.rootComponent.allOccurrences.count!=69:raise RuntimeError('Unexpected source geometry')
    doc.name=NAME
    d.rootComponent.attributes.add('TrimixPcbFit','source_archive_sha256',expected)
    d.rootComponent.attributes.add('TrimixPcbFit','scope','Main PCB and USB daughterboard integration; showcase deferred')
    if not doc.saveAs(NAME,folder,'PCB enclosure fit development; preserves PrintReview and A3 v3',''):raise RuntimeError('SaveAs failed')
    report('fusion-fit-baseline.json',{'name':doc.name,'data_file_id':doc.dataFile.id,'version':doc.dataFile.versionNumber,
        'folder':folder.name,'timeline':d.timeline.count,'occurrences':d.rootComponent.allOccurrences.count,'source_sha256':expected})

def inspect():
    app,doc,d=owned()
    report('fusion-fit-state.json',{'name':doc.name,'modified':doc.isModified,'timeline':d.timeline.count,
        'occurrences':d.rootComponent.allOccurrences.count,
        'components':[{'name':o.component.name,'part':o.component.partNumber,'bodies':o.component.bRepBodies.count,
          'bounds':[o.boundingBox.minPoint.asArray(),o.boundingBox.maxPoint.asArray()]} for o in d.rootComponent.occurrences]})

def import_usb():
    app,doc,d=owned();name='PCB A3 - routed USB daughterboard'
    if any(o.component.name==name for o in d.rootComponent.occurrences):raise RuntimeError('USB PCB already imported')
    path=BASE/'exports/Trimix_USB_Input.step'
    o=d.rootComponent.occurrences.addNewComponent(core.Matrix3D.create());c=o.component;c.name=name;c.partNumber='TMX-A3-C11'
    c.description='Actual KiCad 0.60 mm daughterboard and fitted resistors; GCT connector modeled separately'
    options=app.importManager.createSTEPImportOptions(str(path))
    if not app.importManager.importToTarget(options,c):raise RuntimeError('USB STEP import failed')
    c.attributes.add('TrimixPcbFit','source_step',str(path));c.attributes.add('TrimixPcbFit','source_step_sha256',hashlib.sha256(path.read_bytes()).hexdigest())
    report('usb-step-raw.json',{'occurrence':o.fullPathName,'bounds_mm':[[v*10 for v in o.boundingBox.minPoint.asArray()],[v*10 for v in o.boundingBox.maxPoint.asArray()]],
        'bodies':[{'path':q.fullPathName,'name':b.name,'bounds_mm':[[v*10 for v in b.boundingBox.minPoint.asArray()],[v*10 for v in b.boundingBox.maxPoint.asArray()]]} for q in c.allOccurrences for b in q.bRepBodies]})

def _bounds(body):
    b=body.boundingBox
    return [[v*10 for v in b.minPoint.asArray()],[v*10 for v in b.maxPoint.asArray()]]

def place_usb():
    app,doc,d=owned();root=d.rootComponent
    o=next(q for q in root.occurrences if q.component.name=='PCB A3 - routed USB daughterboard')
    # STEP has -Y for KiCad +Y. Its dielectric is .51 mm; align the nominal
    # .60 mm stack centre, not the dielectric bottom, to enclosure UsbZ=26.
    m=core.Matrix3D.create();m.translation=core.Vector3D.create(3.45,1.8,2.5745)
    o.transform2=m
    if d.snapshots.hasPendingSnapshot:d.snapshots.add()
    o.component.partNumber='TMX-A3-B02'
    o.component.attributes.add('TrimixPcbFit','registration_mm','X34.5 Y18 Z25.745; nominal stack centre Z26')
    old=next(q for q in root.occurrences if q.component.name.startswith('USB A3') and 'daughterboard provisional' in q.component.name)
    old.isLightBulbOn=False
    old.component.attributes.add('TrimixPcbFit','superseded_by','TMX-A3-B02 actual KiCad import; exclude this reference from BOM and fit checks')
    report('usb-position.json',{'occurrence':o.fullPathName,'bounds_mm':_bounds(o),'translation_mm':[34.5,18,25.745],
        'nominal_stack_mm':[25.7,26.3],'source_dielectric_mm':[0,.51],
        'superseded_reference':old.fullPathName,'reference_connector_warning':'Existing GCT visual is not exact manufacturer CAD; its shell wings and rear insulator need drawing-derived correction.'})

def audit_usb():
    _audit_board('PCB A3 - routed USB daughterboard','usb-fusion-interference.json')

def audit_main():
    _audit_board('PCB A3 - main four-layer placement','main-fusion-interference.json')

def _audit_board(prefix,filename):
    app,doc,d=owned();root=d.rootComponent
    sources=[];targets=[]
    for o in root.allOccurrences:
        name=o.fullPathName
        if 'daughterboard provisional' in name or 'future PCB allocation' in name:continue
        for native in o.component.bRepBodies:
            if not native.isSolid:continue
            b=native.createForAssemblyContext(o)
            item=(name,b)
            (sources if name.startswith(prefix+':') else targets).append(item)
    pairs=0;hits=[];errors=[]
    for sn,sb in sources:
        a=_bounds(sb)
        for tn,tb in targets:
            b=_bounds(tb)
            if any(a[1][i]<=b[0][i] or b[1][i]<=a[0][i] for i in range(3)):continue
            pairs+=1;objects=core.ObjectCollection.create();objects.add(sb);objects.add(tb)
            request=d.createInterferenceInput(objects);request.areCoincidentFacesIncluded=False
            result=d.analyzeInterference(request)
            if result is None:errors.append([sn,tn]);continue
            for h in result:
                volume=h.interferenceBody.volume*1000
                if volume>1e-5:hits.append({'pcb_path':sn,'pcb_body':sb.name,'target_path':tn,'target_body':tb.name,'volume_mm3':volume})
    report(filename,{'sources':len(sources),'candidate_pairs':pairs,'hits':hits,'errors':errors,
       'scope':'Exact solid tests between imported PCB/pads/components and existing enclosure instances; contact only is excluded. Some purchased-part bodies are approximate reference models.'})

def checkpoint():
    app,doc,d=owned()
    if not d.computeAll():raise RuntimeError('Recompute failed')
    path=BASE/'verification/PCBFit-in-progress.f3d'
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):raise RuntimeError('Native checkpoint failed')
    if not doc.save('PCB fit development checkpoint; main routing and physical connector checks pending'):raise RuntimeError('Cloud save failed')
    report('fusion-checkpoint.json',{'name':doc.name,'native':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'timeline':d.timeline.count})

def remove_replaced_allocations():
    app,doc,d=owned();removed=[]
    names=[q for q in d.rootComponent.occurrences if 'daughterboard provisional' in q.component.name or 'future PCB allocation' in q.component.name]
    for o in names:
        is_main='future PCB allocation' in o.component.name
        actual='PCB A3 - main four-layer placement' if is_main else 'PCB A3 - routed USB daughterboard'
        if not any(q.component.name==actual for q in d.rootComponent.occurrences):continue
        name=o.fullPathName
        f=d.rootComponent.features.removeFeatures.add(o)
        if not f:raise RuntimeError('Could not retire '+name)
        f.name='Replace obsolete PCB clearance allocation with KiCad geometry'
        removed.append(name)
    report('replaced-allocations.json',{'removed_from_current_assembly':removed,'history_preserved':True})

def import_main():
    app,doc,d=owned();name='PCB A3 - main four-layer placement'
    if any(o.component.name==name for o in d.rootComponent.occurrences):raise RuntimeError('Main PCB already imported')
    candidates=list((BASE/'exports').glob('Trimix_Analyzer*.step'))
    if len(candidates)!=1:raise RuntimeError('Expected exactly one main PCB STEP')
    path=candidates[0]
    o=d.rootComponent.occurrences.addNewComponent(core.Matrix3D.create());c=o.component
    c.name=name;c.partNumber='TMX-A3-B01'
    c.description='Actual KiCad four-layer1.60mm placement, not routed. Some generic part models and connector selections remain provisional.'
    if not app.importManager.importToTarget(app.importManager.createSTEPImportOptions(str(path)),c):raise RuntimeError('Main STEP import failed')
    c.attributes.add('TrimixPcbFit','source_step',str(path));c.attributes.add('TrimixPcbFit','source_step_sha256',hashlib.sha256(path.read_bytes()).hexdigest())
    records=[]
    for q in d.rootComponent.allOccurrences:
        if not q.fullPathName.startswith(name+':'):continue
        for native in q.component.bRepBodies:
            b=native.createForAssemblyContext(q)
            records.append({'path':q.fullPathName,'name':b.name,'bounds_mm':_bounds(b),'volume_mm3':b.volume*1000})
    report('main-step-raw.json',{'path':str(path),'occurrence':o.fullPathName,'bounds_mm':_bounds(o),'bodies':records})

def place_main():
    app,doc,d=owned();root=d.rootComponent;name='PCB A3 - main four-layer placement'
    o=next(q for q in root.occurrences if q.component.name==name)
    raw=json.loads((BASE/'verification/main-step-raw.json').read_text())
    boards=[b for b in raw['bodies'] if '_PCB:' in b['path']]
    if len(boards)!=1:raise RuntimeError('Ambiguous main dielectric body')
    box=boards[0]['bounds_mm'];mid=(box[0][2]+box[1][2])/2
    if abs(box[1][0]-box[0][0]-30)>.05 or abs(box[1][1]-box[0][1]-99)>.05:raise RuntimeError('Unexpected STEP outline datum')
    shift=21.3-mid
    m=core.Matrix3D.create();m.translation=core.Vector3D.create(5.04,12,shift/10);o.transform2=m
    if d.snapshots.hasPendingSnapshot:d.snapshots.add()
    o.component.attributes.add('TrimixPcbFit','registration_mm',json.dumps([50.4,120,shift]))
    old=next(q for q in root.occurrences if 'future PCB allocation' in q.component.name)
    old.isLightBulbOn=False
    report('main-position.json',{'occurrence':o.fullPathName,'bounds_mm':_bounds(o),'translation_mm':[50.4,120,shift],
      'nominal_stack_mm':[20.5,22.1],'dielectric_source_bounds_mm':box,'datum_mapping':'FusionX=50.4+KiCadLocalX; FusionY=120-KiCadLocalY; F.Cu faces rear +Z',
      'model_limitations':'J301, J402 and several passive packages retain provisional generic body models; this import does not qualify their actual parts.'})

def carrier_relief():
    app,doc,d=owned()
    c=next(o.component for o in d.rootComponent.occurrences if o.component.name=='Carrier / removable electronics tray')
    if c.attributes.itemByName('TrimixPcbFit','tail_relief'):raise RuntimeError('Carrier relief already applied')
    path=BASE/'verification/carrier-relief-independent-review.json';data=json.loads(path.read_text())
    sys.path.insert(0,str(HW/'cad/rev04/scripts'))
    import build_a3 as b
    before=c.bRepBodies.item(0).volume*1000
    values=lambda xs:[f'{x:.6f} mm' for x in xs]
    x0,y0,x1,y1=data['J301_local_extension']['join_bounds_mm']
    b.box(c,'PCB J301 supported rim extension',*values([x0,y0,18.5,x1-x0,y1-y0,2]),'join')
    for window in data['proposed_windows']:
        x0,y0,x1,y1=window['bounds'];body=c.bRepBodies.item(0)
        b.box(c,'PCB solder-tail clearance '+' + '.join(window['references']),*values([x0,y0,18.4,x1-x0,y1-y0,2.2]),'cut',body)
    if c.bRepBodies.count!=1 or not c.bRepBodies.item(0).isSolid:raise RuntimeError('Carrier must remain one connected solid')
    c.attributes.add('TrimixPcbFit','tail_relief',hashlib.sha256(path.read_bytes()).hexdigest())
    c.attributes.add('TrimixPcbFit','model_basis','Eleven through-windows for14 provisional THT packages; pad outline+0.50mm solder allowance, physical fit pending')
    if not d.computeAll():raise RuntimeError('Carrier recompute failed')
    report('carrier-relief-applied.json',{'component':c.name,'windows':data['proposed_windows'],
        'source_receipt_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'solids':c.bRepBodies.count,
        'volume_before_mm3':before,'volume_after_mm3':c.bRepBodies.item(0).volume*1000,
        'nominal_plate_thickness_mm':2,'new_right_rim_mm':2.185,'nominal_shell_gap_mm':1.4,
        'global_wall_or_stiffness_validation':False,'physical_solder_fit':'pending'})

def audit_carrier():
    _audit_board('Carrier / removable electronics tray','carrier-fusion-interference.json')

def refresh_main():
    app,doc,d=owned()
    o=next(q for q in d.rootComponent.occurrences if q.component.name=='PCB A3 - main four-layer placement');c=o.component
    path=BASE/'exports/Trimix_Analyzer_A3_Placement.step';sha=hashlib.sha256(path.read_bytes()).hexdigest()
    previous=c.attributes.itemByName('TrimixPcbFit','source_step_sha256').value
    if sha==previous:raise RuntimeError('Main STEP is already current')
    before=_bounds(o)
    for child in list(c.occurrences):
        f=c.features.removeFeatures.add(child)
        if not f:raise RuntimeError('Could not retire earlier STEP children')
        f.name='Refresh PCB STEP after final schematic metadata reconciliation'
    if not app.importManager.importToTarget(app.importManager.createSTEPImportOptions(str(path)),c):raise RuntimeError('Refresh import failed')
    after=_bounds(o)
    if any(abs(a-b)>.0001 for aa,bb in zip(before,after) for a,b in zip(aa,bb)):raise RuntimeError('Refreshed PCB envelope changed unexpectedly')
    c.attributes.add('TrimixPcbFit','source_step_sha256',sha)
    report('main-step-refresh.json',{'old_sha256':previous,'current_sha256':sha,'before_mm':before,'after_mm':after,
      'registration_mm':[50.4,120,20.545],'max_allowed_bbox_difference_mm':.0001})

def service_check():
    """Conservative continuous straight extraction, plus nominal driver shafts."""
    import math
    app,doc,d=owned();timeline=d.timeline.count
    sys.path.insert(0,str(HW/'cad/rev04/scripts'))
    import verification_a3 as v
    from audit_a3 import _instances,attribute
    manager=fusion.TemporaryBRepManager.get();moving=[];fixed=[];removed=[];screws=[]
    for o,c,i,b in _instances(d):
        if not b.isSolid:continue
        name=o.fullPathName if o else 'ROOT'
        group=(attribute(o,'physical_group') if o else None) or attribute(c,'physical_group')
        raw=attribute(c,'hardware_definition');hardware=json.loads(raw) if raw else None
        item={'name':name,'body':b,'bounds':_bounds(b),'occ':o,'hardware':hardware}
        if name.startswith(('PCB A3 - main four-layer placement:','Carrier / removable electronics tray:')):moving.append(item)
        elif group=='rear_cover' or ('disconnect' in c.name.lower() and 'mate' in c.name.lower()):removed.append(name)
        elif group in ('pcb','carrier') and hardware and hardware['kind']=='screw':screws.append(item);removed.append(name)
        else:fixed.append(item)
    if len(moving)!=686 or len(screws)!=2:raise RuntimeError('Unexpected PCB/carrier/screw selection')
    top=max(r['bounds'][1][2] for r in moving)+.01
    regions=[[50.2,103,18.5,59,120.5,top], [50.2,25.2,18.5,80.6,103,top],
             [56.2,20.5,18.5,80.6,25.2,top], [80.5,47.4,18.5,81.2,84.6,top]]
    for r in moving:
        if r['name'].startswith('Carrier /'):continue
        a,b=r['bounds']
        if a[2]<18.49:regions.append([a[0]-.01,a[1]-.01,a[2]-.01,b[0]+.01,b[1]+.01,top])
    def box(values):
        a=values[:3];b=values[3:]
        oriented=core.OrientedBoundingBox3D.create(core.Point3D.create(*[(x+y)/20 for x,y in zip(a,b)]),
            core.Vector3D.create(1,0,0),core.Vector3D.create(0,1,0),*[(y-x)/10 for x,y in zip(a,b)])
        result=manager.createBox(oriented)
        if not result:raise RuntimeError('Transient envelope box failed')
        return result
    assembled=[box(r) for r in regions];outside=[];exact=0
    for r in moving:
        a,b=r['bounds']
        if any(all(region[i]<=a[i] and b[i]<=region[i+3] for i in range(3)) for region in regions):continue
        exact+=1;remainder=v._world_copy(manager,r['body'])
        for envelope in assembled:
            if not remainder.faces.count:break
            if not manager.booleanOperation(remainder,manager.copy(envelope),fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Containment Boolean failed')
        if remainder.faces.count and remainder.volume*1000>1e-5:outside.append({'part':r['name'],'volume_mm3':remainder.volume*1000})
    if outside:report('pcb-service-containment-failed.json',{'outside':outside,'regions':regions});raise RuntimeError('Service envelope does not contain all moving solids')
    travel=math.ceil(max(r['bounds'][1][2] for r in fixed)-min(r['bounds'][0][2] for r in moving)+2)
    hits=[];pairs=0
    for i,region in enumerate(regions):
        swept=list(region);swept[5]+=travel;envelope=box(swept)
        for r in fixed:
            if not v._bbox_overlap(envelope.boundingBox,r['body'].boundingBox):continue
            pairs+=1;obstacle=v._world_copy(manager,r['body'])
            volume=v._intersection_volume(manager,envelope,obstacle,True)
            if volume>1e-5:hits.append({'envelope':i,'fixed':r['name'],'volume_mm3':volume})
    drivers=[]
    driver_obstacles=fixed+moving
    for screw in screws:
        h=screw['hardware'];o=screw['occ'];axis=core.Vector3D.create(0,0,1);axis.transformBy(o.transform2)
        pos=o.transform2.translation;start=[p*10+a*(h['head_height_mm']+.05) for p,a in zip(pos.asArray(),axis.asArray())]
        end=[p+a*50 for p,a in zip(start,axis.asArray())]
        shaft=manager.createCylinderOrCone(core.Point3D.create(*[p/10 for p in start]),.25,core.Point3D.create(*[p/10 for p in end]),.25)
        sh=[]
        for r in driver_obstacles:
            if not v._bbox_overlap(shaft.boundingBox,r['body'].boundingBox):continue
            volume=v._intersection_volume(manager,shaft,v._world_copy(manager,r['body']),True)
            if volume>1e-5:sh.append({'fixed':r['name'],'volume_mm3':volume})
        drivers.append({'screw':screw['name'],'diameter_mm':5,'length_mm':50,'start_mm':start,'hits':sh})
    if d.timeline.count!=timeline:raise RuntimeError('Transient service check changed the timeline')
    report('pcb-service-check.json',{'status':'clear_for_modeled_geometry' if not hits and all(not t['hits'] for t in drivers) else 'needs_review',
      'moving_body_count':len(moving),'fixed_body_count':len(fixed),'removed_prerequisites':removed,
      'prerequisites':'Rear cover off, battery disconnected, all PCB harnesses detached, two carrier screws removed. Battery holder remains installed.',
      'continuous_translation_mm':[0,0,travel],'assembled_conservative_regions_mm':regions,
      'containment':'All moving solids contained: bounding boxes where possible, exact BRep differences for remaining bodies.',
      'native_difference_containment_count':exact,'envelope_obstacle_pairs':pairs,'hits':hits,'drivers':drivers,
      'limits':'Rigid CAD parts and nominal5mm driver shafts only. Generic component bodies, actual connectors, wire bends, solder, hands and fit tolerances remain unqualified.',
      'persistent_timeline_unchanged':True})

def deliver():
    import adsk
    app,doc,d=owned();root=d.rootComponent
    sys.path.insert(0,str(HW/'cad/rev04/scripts'))
    from audit_a3 import _instances,_health,attribute
    import verification_a3 as v
    if not d.computeAll():raise RuntimeError('Final recompute failed')
    health=_health(d);report('fusion-final-health.json',health)
    if health['unhealthy_entities']:raise RuntimeError('Final Fusion feature health is not clean')
    imported=[]
    for o in root.occurrences:
        a=o.component.attributes.itemByName('TrimixPcbFit','source_step')
        if not a:continue
        expected=o.component.attributes.itemByName('TrimixPcbFit','source_step_sha256').value
        actual=hashlib.sha256(Path(a.value).read_bytes()).hexdigest()
        if actual!=expected:raise RuntimeError('Imported STEP is stale: '+o.component.name)
        imported.append({'component':o.component.name,'path':a.value,'sha256':actual})
    # Check the two actual cylindrical mounting bores in root coordinates.
    pcb=[b for o,c,i,b in _instances(d) if o and o.fullPathName.startswith('PCB A3 - main four-layer placement:') and '_PCB' in c.name]
    if len(pcb)!=1:raise RuntimeError('Cannot identify main substrate')
    native=v._world_copy(fusion.TemporaryBRepManager.get(),pcb[0]);holes=set()
    for f in native.faces:
        cylinder=core.Cylinder.cast(f.geometry)
        if cylinder and abs(cylinder.radius-.115)<1e-7:
            holes.add(tuple(round(x*10,6) for x in cylinder.origin.asArray()[:2]))
    if holes!={(76.0,28.0),(54.8,114.0)}:raise RuntimeError('PCB holes are not on carrier datums: '+str(holes))
    d.activateRootComponent()
    visibility=[(o,o.isLightBulbOn) for o in root.allOccurrences];camera=app.activeViewport.camera
    image_path=BASE/'exports/PCB-in-enclosure-rear.png'
    try:
        for o in root.allOccurrences:
            if (attribute(o,'physical_group') or attribute(o.component,'physical_group'))=='rear_cover':o.isLightBulbOn=False
        cam=app.activeViewport.camera;cam.cameraType=core.CameraTypes.OrthographicCameraType
        cam.target=core.Point3D.create(4.25,9,2.15);cam.eye=core.Point3D.create(-30.75,34,47.15)
        cam.upVector=core.Vector3D.create(0,1,0);cam.isFitView=True;cam.isSmoothTransition=False
        app.activeViewport.camera=cam;app.activeViewport.visualStyle=core.VisualStyles.ShadedWithVisibleEdgesOnlyVisualStyle
        adsk.doEvents();app.activeViewport.refresh()
        options=core.SaveImageFileOptions.create(str(image_path));options.width=1400;options.height=1700
        options.isBackgroundTransparent=False;options.isAntiAliased=True
        if not app.activeViewport.saveAsImageFileWithOptions(options):raise RuntimeError('Technical fit view export failed')
    finally:
        for o,state in visibility:
            if o.isValid:o.isLightBulbOn=state
        app.activeViewport.camera=camera;adsk.doEvents();app.activeViewport.refresh()
    files=[]
    for suffix,options in [('f3d',d.exportManager.createFusionArchiveExportOptions),('step',d.exportManager.createSTEPExportOptions)]:
        path=BASE/'exports'/(NAME+'.'+suffix)
        if not d.exportManager.execute(options(str(path))):raise RuntimeError('Failed final '+suffix+' export')
        files.append({'path':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'bytes':path.stat().st_size})
    if not doc.save('Four-layer PCB mechanical placement and routed USB integration; carrier pin relief; routing and physical qualification pending'):raise RuntimeError('Cloud save failed')
    bodies=[b for o,c,i,b in _instances(d) if b.isSolid]
    report('fusion-delivery.json',{'status':'saved_pending_native_reopen_and_visual_review','name':doc.name,'cloud_id':doc.dataFile.id,'folder':doc.dataFile.parentFolder.name,
      'files':files,'technical_view':str(image_path),'imported_steps':imported,'actual_main_mounting_holes_mm':sorted(holes),
      'features_healthy':not health['unhealthy_entities'],'under_constrained_sketches':len(health['under_constrained_sketches']),
      'solid_body_count':len(bodies),'total_instance_volume_mm3':sum(b.volume*1000 for b in bodies),
      'timeline':d.timeline.count,'routing_status':'Main placement only; USB routed. Not a fabrication or print release.'})

def reopen_check():
    app,doc,d=owned();data=json.loads((BASE/'verification/fusion-delivery.json').read_text())
    path=BASE/'exports'/(NAME+'.f3d');created=None
    sys.path.insert(0,str(HW/'cad/rev04/scripts'))
    from audit_a3 import _instances
    try:
        created=app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(path)))
        if not created:raise RuntimeError('Native archive did not reopen')
        check=fusion.Design.cast(created.products.itemByProductType('DesignProductType'))
        bodies=[b for o,c,i,b in _instances(check) if b.isSolid];volume=sum(b.volume*1000 for b in bodies)
        if len(bodies)!=data['solid_body_count'] or abs(volume-data['total_instance_volume_mm3'])>1e-4:raise RuntimeError('Reopened native geometry differs')
        data['native_reopen']={'passed':True,'body_count':len(bodies),'volume_difference_mm3':volume-data['total_instance_volume_mm3']}
        data['status']='saved_and_native_reopened_visual_review_pending'
        report('fusion-delivery.json',data)
    finally:
        if created and created.isValid:created.close(False)
        if doc.isValid:doc.activate()
