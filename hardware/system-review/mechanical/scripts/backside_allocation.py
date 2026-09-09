"""Bounded underside-component allocation; extend an existing carrier opening.

No PCB STEP is refreshed here. The component cluster and Q112 are explicit
allocation probes, not purchased geometry or an assembly release.
"""
import hashlib
import json
import zipfile
from pathlib import Path
import adsk
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, report, BASE, bounds, other_documents

CARRIER = 'Carrier / removable electronics tray'
CLUSTER = [57.9,25.5,18.55,70.4,36.0,20.5]
CUT = [50.0,33.70,18.4,70.925,36.30,20.6]
Q112 = [73.25,21.60,22.1,76.55,24.90,23.60]


def _box(manager, values):
    low, high = values[:3], values[3:]
    oriented = core.OrientedBoundingBox3D.create(
        core.Point3D.create(*[(a+b)/20 for a,b in zip(low,high)]),
        core.Vector3D.create(1,0,0), core.Vector3D.create(0,1,0),
        *[(b-a)/10 for a,b in zip(low,high)])
    result = manager.createBox(oriented)
    if not result or not result.isTransient:
        raise RuntimeError('No temporary allocation box')
    return result


def _record(body, name, group='pcb'):
    return {'uid': ('ALLOCATION/'+name,0), 'body':body, 'name':name,
            'component':'Pending routed PCB component allocation', 'occurrence':'ALLOCATION/'+name,
            'physical_group':group, 'service_role':None, 'battery_role':None,
            'hardware':None,'screw_axis':None,'head_seat_mm':None}


def _sections(body):
    """Sample selected retained material strips; not a global minimum wall."""
    specs = [('Web to J103 tail window',[54.4,36.3,19.5],[54.4,38.385,19.5]),
             ('Carrier thickness above opening',[62,37,18.5],[62,37,20.5]),
             ('Material from opening to lower M2 hole',[70.925,28,19.5],[74.85,28,19.5])]
    out=[]
    for name,start,end in specs:
        length=sum((a-b)**2 for a,b in zip(start,end))**.5
        points=[[a+(b-a)*i/100 for a,b in zip(start,end)]for i in range(1,100)]
        states=[body.pointContainment(core.Point3D.create(*[v/10 for v in p]))for p in points]
        okay=all(s in (fusion.PointContainment.PointInsidePointContainment,fusion.PointContainment.PointOnPointContainment)for s in states)
        out.append({'name':name,'start_mm':start,'end_mm':end,'length_mm':length,
                    'interior_samples':99,'all_samples_in_material':okay,'nominal_at_least_2mm':length>=2-1e-7,
                    'pass':okay and length>=2-1e-7})
    return out


def probe():
    """Exact transient candidate subtraction, installed allocation and shaft tests."""
    app,doc,d=owned();configure()
    import review_checks as checks
    import verification_a3 as v
    before=d.timeline.count
    manager,records=checks.records()
    physical=[r for r in records if r['physical_group']!='alternative_oxygen_reference']
    carrier=next(r for r in physical if r['component']==CARRIER)
    candidate=manager.copy(carrier['body'])
    original_volume=candidate.volume*1000
    if not manager.booleanOperation(candidate,_box(manager,CUT),fusion.BooleanTypes.DifferenceBooleanType):
        raise RuntimeError('Candidate through-opening subtraction failed')
    if not candidate.isSolid or candidate.lumps.count!=1:
        raise RuntimeError('Candidate carrier is not one connected solid')
    replaced={**carrier,'body':candidate}
    replaced.pop('bounds_cm',None)
    fixed=[r for r in physical if r is not carrier and not r['occurrence'].startswith('PCB A3 - main four-layer placement:')]+[replaced]
    cluster=_record(_box(manager,CLUSTER),'B.Cu cluster max1.95 below PCB back')
    q=_record(_box(manager,Q112),'Q112 tentative SOT23 3.3-square by1.5-height allocation')
    before_hit=v._test(manager,'Requested cluster versus unmodified carrier',[cluster],[carrier],[(0,0,0)],[])
    cluster_test=v._test(manager,'Backside cluster with candidate through-opening',[cluster],fixed,[(0,0,0)],[])
    q_test=v._test(manager,'Q112 front allocation against enclosure',[q],fixed,[(0,0,0)],[])
    driver=manager.createCylinderOrCone(core.Point3D.create(7.6,2.8,2.415),.25,
                                        core.Point3D.create(7.6,2.8,7.415),.25)
    driver_hit=v._intersection_volume(manager,driver,q['body'])
    sections=_sections(candidate)
    if d.timeline.count!=before:
        raise RuntimeError('Candidate probe modified CAD')
    result={'status':'candidate_go' if not cluster_test['collision_count'] and not q_test['collision_count']
            and driver_hit<=v.VOLUME_TOLERANCE_MM3 and all(r['pass']for r in sections) else 'requires_review',
            'document':doc.name,'cluster_KiCad_mm':{'x':[7.5,20.0],'y':[84.0,94.5],'deepest_below_back':1.95},
            'cluster_world_bounds_mm':CLUSTER,'existing_opening_mm':[50,20.3,70.925,33.75],
            'extension_cut_world_mm':CUT,'candidate_lumps':candidate.lumps.count,
            'removed_material_mm3':original_volume-candidate.volume*1000,
            'baseline_cluster_carrier_hits':before_hit,'candidate_cluster_test':cluster_test,
            'Q112_test':q_test,'Q112_allocation_world_mm':Q112,
            'Q112_lower_M2_driver_intersection_mm3':driver_hit,'selected_sections':sections,
            'nominal_clearances_mm':{'top_of_cluster_to_opening':.3,'right_of_cluster_to_opening':.525,
                                     'cluster_to_nominal_display_back':4.45},
            'limits':['Allocation only; final routed PCB/contract must include actual backside footprints and solder.',
                      'Selected >=2mm carrier strips, unchanged mounting holes; not global wall or structural qualification.',
                      'Q112 probe conservatively encloses current SOT23 request; final package orientation and courtyard need PCB verification.',
                      'Old front-side STEP is excluded from allocation tests because the board is currently being revised.']}
    report('backside-allocation-probe.json',result)
    return result


def apply():
    """Extend the old bottom/left opening upward by2.55mm; preserve all else."""
    app,doc,d=owned();b=configure()
    import review_checks as checks
    candidate=json.loads((BASE/'verification/backside-allocation-probe.json').read_text())
    if candidate['status']!='candidate_go':
        raise RuntimeError('No passing candidate probe')
    c=next(o.component for o in d.rootComponent.occurrences if o.component.name==CARRIER)
    if c.attributes.itemByName('TrimixSystemReview','backside_allocation'):
        raise RuntimeError('Backside opening already applied')
    other=other_documents(app);before=c.bRepBodies.item(0).volume*1000
    if c.bRepBodies.count!=1:
        raise RuntimeError('Expected one carrier body')
    b.box(c,'Backside cluster through-opening extension','50 mm','33.70 mm','18.4 mm',
          '20.925 mm','2.60 mm','2.2 mm','cut',c.bRepBodies.item(0))
    if not d.computeAll():raise RuntimeError('Carrier recompute failed')
    body=c.bRepBodies.item(0)
    if c.bRepBodies.count!=1 or not body.isSolid or body.lumps.count!=1:
        raise RuntimeError('Carrier must remain one connected solid')
    sections=_sections(body)
    if not all(r['pass']for r in sections) or not checks.health(d)['pass']:
        raise RuntimeError('Carrier selected material or feature health failed')
    c.attributes.add('TrimixSystemReview','backside_allocation',json.dumps({'PCB_bounds_mm':[7.5,84,20,94.5],
       'lowest_Z_mm':18.55,'opening_top_Y_mm':36.3,'right_X_mm':70.925,'status':'allocated_pending_final_PCB_and_physical_fit'}))
    if other_documents(app)!=other:raise RuntimeError('Protected documents changed')
    report('backside-allocation-applied.json',{'status':'native_through_opening_applied','component':c.name,
          'native_bounds_mm':bounds(body),'removed_material_mm3':before-body.volume*1000,'lumps':body.lumps.count,
          'timeline':d.timeline.count,'selected_sections':sections,'health_pass':True,
          'exterior_and_mount_positions_changed':False,'other_documents_preserved':True})


def _adapter():
    configure()
    import verification_a3 as v
    original=v._records
    def adapted(d,manager):
        rows=original(d,manager)
        rows=[r for r in rows if r['physical_group']!='alternative_oxygen_reference']
        for r in rows:
            if r['occurrence'].startswith('PCB A3 - main four-layer placement:'):r['physical_group']='pcb'
            elif r['occurrence'].startswith('PCB A3 - routed USB daughterboard:'):r['physical_group']='usb'
        return rows+[_record(_box(manager,CLUSTER),'B.Cu cluster max1.95 below PCB back'),
                     _record(_box(manager,Q112),'Q112 front allocation')]
    v._records=adapted
    return v,original


def service():
    v,original=_adapter();previous=v.OUTPUT;v.OUTPUT=BASE/'verification/backside-allocation'
    try:result=v.audit_paths(stages=['carrier','usb'])
    finally:v._records=original;v.OUTPUT=previous
    return result


def mesh():
    """Export only modified P03 for local diagnostic slicing; never send a job."""
    import math
    app,doc,d=owned();c=next(o.component for o in d.rootComponent.occurrences if o.component.name==CARRIER)
    path=BASE/'diagnostic-printing/backside-allocation/TMX-A3-P03.stl';path.parent.mkdir(parents=True,exist_ok=True)
    body=c.bRepBodies.item(0);options=d.exportManager.createSTLExportOptions(body,str(path))
    options.isBinaryFormat=True;options.sendToPrintUtility=False;options.unitType=fusion.DistanceUnits.MillimeterDistanceUnits
    options.surfaceDeviation=.001;options.normalDeviation=math.radians(3)
    if not d.exportManager.execute(options):raise RuntimeError('Carrier diagnostic STL failed')
    report('backside-allocation-mesh.json',{'part_id':'TMX-A3-P03','file':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
          'native_bounds_mm':bounds(body),'native_volume_mm3':body.volume*1000,'units':'mm','scale':1,
          'status':'diagnostic_only_pending_slice_review','print_job_sent':False})


def static():
    """Confirm the applied native cut, all fixed-part intersections and allocations."""
    app,doc,d=owned();configure()
    import review_checks as checks
    import verification_a3 as v
    manager,records=checks.records()
    physical=[r for r in records if r['physical_group']!='alternative_oxygen_reference']
    fixed=[r for r in physical if not r['occurrence'].startswith('PCB A3 - main four-layer placement:')]
    allocations=[_record(_box(manager,CLUSTER),'B.Cu cluster'),_record(_box(manager,Q112),'Q112 SOT23 allocation')]
    tests=v._test(manager,'Applied native carrier and provisional new components',allocations,fixed,[(0,0,0)],[])
    actual=checks.collision_report(manager,physical)
    carrier=next(r for r in physical if r['component']==CARRIER)
    sections=_sections(carrier['body'])
    result={'status':'applied_geometry_clear' if not tests['collision_count'] and not actual['collisions'] and all(s['pass']for s in sections) else 'requires_review',
            'document':doc.name,'timeline':d.timeline.count,'physical_solids':len(physical),
            'actual_interferences':actual,'allocation_test':tests,'selected_sections':sections,
            'health':checks.health(d),'final_routed_PCB_not_yet_imported':True}
    report('backside-allocation-static.json',result)
    return result


def checkpoint():
    """Save this internal carrier refinement separately from earlier checkpoints."""
    app,doc,d=owned();configure()
    other=other_documents(app)
    path=BASE/'inputs/backside-allocation/Trimix_Enclosure_A3_SystemReview_BacksideAllocation.f3d'
    path.parent.mkdir(parents=True,exist_ok=True)
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):
        raise RuntimeError('Backside allocation archive failed')
    with zipfile.ZipFile(path)as archive:
        if archive.testzip():raise RuntimeError('Backside allocation archive CRC failed')
    if not doc.save('Carrier through-opening extended for approved B.Cu cluster; exact final routed PCB and USB fit remain pending.'):
        raise RuntimeError('Backside allocation cloud save failed')
    if other_documents(app)!=other:raise RuntimeError('Protected documents changed')
    report('backside-allocation-checkpoint.json',{'file':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
       'bytes':path.stat().st_size,'timeline':d.timeline.count,'archive_crc_pass':True,
       'status':'carrier_allocation_checkpoint_not_final_PCB_release','other_documents_preserved':True})


def capture():
    """One actual-carrier diagnostic view; restore all source display state."""
    app,doc,d=owned();configure()
    import review_a3 as views
    state=views._visibility(d);camera=app.activeViewport.camera;active=d.activeOccurrence
    extra=[(c,'isOriginFolderLightBulbOn',c.isOriginFolderLightBulbOn)for c in d.allComponents]
    extra += [(q,'isLightBulbOn',q.isLightBulbOn)for c in d.allComponents for q in list(c.sketches)+list(c.constructionPlanes)]
    path=BASE/'views/carrier-backside-allocation.png'
    try:
        views._show_assembly(d)
        for o in d.rootComponent.occurrences:o.isLightBulbOn=o.component.name==CARRIER
        cam=app.activeViewport.camera;cam.cameraType=core.CameraTypes.OrthographicCameraType
        cam.target=core.Point3D.create(6.5,7,1.9);cam.eye=core.Point3D.create(10,3,17)
        cam.upVector=core.Vector3D.create(0,1,0);cam.isFitView=True;cam.isSmoothTransition=False
        app.activeViewport.camera=cam;adsk.doEvents();app.activeViewport.refresh()
        options=core.SaveImageFileOptions.create(str(path));options.width=1200;options.height=1700;options.isAntiAliased=True
        if not app.activeViewport.saveAsImageFileWithOptions(options):raise RuntimeError('Carrier diagnostic capture failed')
    finally:
        views._restore_visibility(d,state)
        for entity,prop,value in extra:
            if entity.isValid:setattr(entity,prop,value)
        if active:active.activate()
        else:d.activateRootComponent()
        app.activeViewport.camera=camera;adsk.doEvents();app.activeViewport.refresh()
    report('backside-allocation-view.json',{'file':str(path),'actual_Fusion_geometry':True,'source_display_state_restored':True})


def finish():
    """Serial native static check, diagnostic capture and owned checkpoint."""
    result=static()
    if result['status']!='applied_geometry_clear' or not result['health']['pass']:
        raise RuntimeError('Applied backside allocation is not verified')
    capture()
    checkpoint()
