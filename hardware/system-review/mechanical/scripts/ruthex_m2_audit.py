"""Read-only exact M2 candidate review. Imports only an own unsaved STEP document.

No saved assembly features, hardware, parameter, material or BOM is changed.
Actual temporary solids are tested; installed pilot interference is reported,
never globally excluded from a design interference gate.
"""
from datetime import datetime, timezone
from pathlib import Path
import hashlib, json, math
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE, owned, configure, other_documents, bounds, attrs, report

SOURCE=BASE/'components/ruthex-review/ruthex_RX-M2x4.step'
SOURCE_SHA='4fe0b584d0f9473ff9dc4afbf08bf6a3c951bf32e81e595a912bb1f1f71dd3ce'


def cylinders(body):
    out=[]
    for f in body.faces:
        c=core.Cylinder.cast(f.geometry)
        if c:
            out.append({'radius_mm':c.radius*10,'origin_mm':[x*10 for x in c.origin.asArray()],
                        'axis':list(c.axis.asArray()),'bounds_mm':bounds(f)})
    return out


def _guard():
    app,doc,d=owned()
    if doc.dataFile.versionNumber!=8 or doc.isModified or d.timeline.count!=1199:
        raise RuntimeError('Requires unchanged saved SystemReview v8, timeline1199')
    if abs(d.userParameters.itemByName('CaseWidth').value*10-85)>1e-7:
        raise RuntimeError('Requires approved85mm baseline')
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest()!=SOURCE_SHA:
        raise RuntimeError('Ruthex source STEP hash changed')
    return app,doc,d


def inventory():
    configure()
    import audit_a3 as a
    import wall_fastener_checks as w
    import review_checks as r
    import verification_a3 as v
    app,doc,d=_guard(); before=a._bodies(d); others=other_documents(app)
    params={p.name:p.expression for p in d.allParameters}
    manager,rows=r.records(); hw=w._hardware_records(d,rows)
    m2=[q for q in hw if q['hardware']['kind']=='insert' and q['hardware']['size']=='M2']
    if len(m2)!=10:raise RuntimeError('Expected10installed M2 inserts')
    printed=[q for q in rows if q['component'] in ['01 Shape A housing','USB A3 — removable printed support frame','Chamber / A3 top manifold with serial return']]
    native=[]
    for q in m2:
        x,y,z=q['head_seat_mm']; faces=[]
        for rec in printed:
            for face in cylinders(rec['body']):
                if abs(abs(face['axis'][2])-1)<1e-7 and math.hypot(face['origin_mm'][0]-x,face['origin_mm'][1]-y)<.001:
                    lo,hi=face['bounds_mm']
                    if hi[2]>=z-7 and lo[2]<=z+.1:
                        faces.append(dict(face,component=rec['component'],body=rec['name']))
        screw=[]
        for h in hw:
            if h['hardware']['kind']=='screw' and h['hardware']['size']=='M2' and math.dist(h['head_seat_mm'][:2],[x,y])<.001:
                screw.append({'name':h['occurrence'],'definition':h['hardware'],'seat':h['head_seat_mm'],
                              'axis':h['axis'],'actual_axial_limits':h['actual_axial_limits_mm'],
                              'position_expressions':h['position_expressions']})
        native.append({'occurrence':q['occurrence'],'definition':q['hardware'],'face_mm':[x,y,z],
                       'bounds_mm':bounds(q['body']),'axis':q['axis'],'position_expressions':q['position_expressions'],
                       'coaxial_printed_cylinders':faces,'screws':screw})
    features=[]
    parameter_owners={}
    for p in d.allParameters:
        creator=getattr(p,'createdBy',None)
        if creator:parameter_owners.setdefault(creator.entityToken,[]).append({'name':p.name,'expression':p.expression,'value_mm':p.value*10})
    for c in [o.component for o in d.rootComponent.occurrences if o.component.name in [p['component']for p in printed]]:
        for sketch in c.sketches:
            if any(s in sketch.name.lower() for s in ('pilot','insert boss','retainer support','fixed support web')):
                ps=parameter_owners.get(sketch.entityToken,[])
                features.append({'component':c.name,'name':sketch.name,'timeline_index':sketch.timelineObject.index,'parameters':ps})
        for f in c.features.extrudeFeatures:
            if any(s in f.name.lower() for s in ('pilot','insert boss','retainer support','fixed support web')):
                ps=parameter_owners.get(f.entityToken,[])
                features.append({'component':c.name,'name':f.name,'timeline_index':f.timelineObject.index,'parameters':ps})
    temp=None; candidate={}
    try:
        options=app.importManager.createSTEPImportOptions(str(SOURCE));options.isViewFit=False
        temp=app.importManager.importToNewDocument(options)
        if not temp or temp.isSaved:raise RuntimeError('Expected own unsaved candidate inspection document')
        td=fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
        candidate['bodies']=[]
        for o,c,i,b in a._instances(td):
            if b.isSolid:
                body=v._world_copy(manager,b)
                candidate['bodies'].append({'name':b.name,'bounds_mm':bounds(body),'volume_mm3':body.getPhysicalProperties(fusion.CalculationAccuracy.HighCalculationAccuracy).volume*1000,'cylinders':cylinders(body)})
    finally:
        try:
            if temp and not temp.close(False):raise RuntimeError('Could not close own candidate document')
        finally:
            if not doc.activate():raise RuntimeError('Cannot restore source active document')
    preserved=(a._bodies(d)==before and other_documents(app)==others and not doc.isModified and d.timeline.count==1199 and params=={p.name:p.expression for p in d.allParameters})
    result={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,'data_id':doc.dataFile.id,
            'version':doc.dataFile.versionNumber,'timeline':d.timeline.count,'status':'read_only_inventory',
            'source_step':str(SOURCE),'source_step_sha256':SOURCE_SHA,'native_m2_interfaces':native,'features':features,
            'candidate_step':candidate,'source_preserved':preserved,'other_documents':others,'candidate_adopted':False}
    report('ruthex-m2-native-inventory.json',result)
    if not preserved:raise RuntimeError('Source/document state changed during read-only inspection')
    return result


def _cylinder(manager,x,y,z0,z1,r):
    body=manager.createCylinderOrCone(core.Point3D.create(x/10,y/10,z0/10),r/10,
                                     core.Point3D.create(x/10,y/10,z1/10),r/10)
    if not body or not body.isTransient:raise RuntimeError('Temporary cylinder failed')
    return body


def _intersections(manager,body,rows):
    import verification_a3 as v
    bb=v._numeric_bounds(body.boundingBox);hits=[]
    for row in rows:
        if not v._numeric_overlap(bb,v._record_bounds(row)):continue
        volume=v._intersection_volume(manager,body,row['body'],True)
        if volume>1e-5:hits.append({'occurrence':row['occurrence'],'component':row['component'],
                                  'body':row['name'],'volume_mm3':volume})
    return hits


def _radial_sections(host,x,y,z,depths=(.2,1,2,3,3.8)):
    """72 rays in each of5 axial planes; values are sampled lower bounds."""
    results=[]
    def inside(r,angle,zz):
        state=host.pointContainment(core.Point3D.create((x+r*math.cos(angle))/10,(y+r*math.sin(angle))/10,zz/10))
        if state==fusion.PointContainment.UnknownPointContainment:raise RuntimeError('Unknown radial material containment')
        return state in (fusion.PointContainment.PointInsidePointContainment,fusion.PointContainment.PointOnPointContainment)
    for depth in depths:
        rays=[]
        for degrees in range(0,360,5):
            angle=math.radians(degrees);last=1.8001
            if not inside(last,angle,z-depth): outer=last
            else:
                first=None
                for i in range(1,126):
                    r=1.8001+i*.05
                    if not inside(r,angle,z-depth):first=r;break
                    last=r
                if first is None:outer=last
                else:
                    while first-last>.001:
                        mid=(first+last)/2
                        if inside(mid,angle,z-depth):last=mid
                        else:first=mid
                    outer=last
            rays.append({'angle_deg':degrees,'continuous_material_after_crest_lower_mm':max(0,outer-1.8)})
        results.append({'depth_from_insert_face_mm':depth,'minimum_sampled_lower_mm':min(q['continuous_material_after_crest_lower_mm']for q in rays),'rays':rays})
    return results


def evaluate():
    """Inspect all10 candidate interfaces; compare proposed7mm-tall/OD7.6 bosses transiently."""
    configure()
    import audit_a3 as a
    import wall_fastener_checks as w
    import review_checks as r
    import verification_a3 as v
    app,doc,d=_guard(); before=a._bodies(d);others=other_documents(app);params={p.name:p.expression for p in d.allParameters}
    manager,rows=r.records();physical=[q for q in rows if q['physical_group']!='alternative_oxygen_reference'];hw=w._hardware_records(d,rows)
    inserts=[q for q in hw if q['hardware']['kind']=='insert'and q['hardware']['size']=='M2']
    if len(inserts)!=10:raise RuntimeError('Expected10 M2 inserts')
    inventory=json.loads((BASE/'verification/ruthex-m2-native-inventory.json').read_text())
    inv={q['occurrence']:q for q in inventory['native_m2_interfaces']}
    temp=None;official=None;official_report={}
    try:
        opts=app.importManager.createSTEPImportOptions(str(SOURCE));opts.isViewFit=False
        temp=app.importManager.importToNewDocument(opts)
        if not temp or temp.isSaved:raise RuntimeError('Expected own unsaved candidate STEP')
        td=fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
        bodies=[b for _,_,_,b in a._instances(td)if b.isSolid]
        if len(bodies)!=1:raise RuntimeError('Official candidate no longer contains one solid')
        b=bodies[0];official=v._world_copy(manager,b)
        official_report={'persistent_volume_mm3':b.volume*1000,'transient_volume_mm3':official.volume*1000,
                         'persistent_high_accuracy_volume_mm3':b.getPhysicalProperties(fusion.CalculationAccuracy.HighCalculationAccuracy).volume*1000,
                         'persistent_very_high_accuracy_volume_mm3':b.getPhysicalProperties(fusion.CalculationAccuracy.VeryHighCalculationAccuracy).volume*1000,
                         'transient_is_solid':official.isSolid,'bounds_mm':bounds(official),
                         'faces':official.faces.count,'edges':official.edges.count,
                         'orientation':'Manufacturer file top face atZ0, body extends toZ-4; translation only to each insert face'}
        if official.volume<=0:raise RuntimeError('Official temporary solid has no positive volume')
    finally:
        try:
            if temp and not temp.close(False):raise RuntimeError('Cannot close own candidate STEP')
        finally:
            if not doc.activate():raise RuntimeError('Cannot restore SystemReview')
    result=[]
    for insert in inserts:
        key=insert['occurrence'];entry=inv[key];x,y,z=insert['head_seat_mm']
        if max(abs(a-b)for a,b in zip(insert['axis'],[0,0,1]))>1e-7:raise RuntimeError('Non-Z insert requires reviewed orientation')
        hostnames={q['component']for q in entry['coaxial_printed_cylinders']if q['radius_mm']<2}
        hosts=[q for q in physical if q['component']in hostnames]
        if len(hosts)!=1:raise RuntimeError('Expected one exact receiving printed solid')
        host=hosts[0];screws=[q for q in hw if q['occurrence']in [s['name']for s in entry['screws']]]
        if len(screws)!=1:raise RuntimeError('Expected one paired screw')
        screw=screws[0];candidate=manager.copy(official);t=core.Matrix3D.create();t.translation=core.Vector3D.create(x/10,y/10,z/10)
        if not manager.transform(candidate,t):raise RuntimeError('Candidate translation failed')
        excluded={host['occurrence'],insert['occurrence'],screw['occurrence']}
        foreign=[q for q in physical if q['occurrence']not in excluded]
        pilots=[q for q in entry['coaxial_printed_cylinders']if q['radius_mm']<2]
        pilot=pilots[0];depth=z-pilot['bounds_mm'][0][2]
        required_hole=_cylinder(manager,x,y,z-5,z-.0001,1.6)
        # The cylinder is a source-required VOID diagnostic, not an actual part.
        pilot_obstruction=_intersections(manager,required_hole,[host])
        void_foreign=_intersections(manager,required_hole,foreign)
        section=_radial_sections(host['body'],x,y,z)
        minimum=min(q['minimum_sampled_lower_mm']for q in section)
        proposed_front=(z-7 if z<20 or z>35 else 19.0)
        boss=_cylinder(manager,x,y,proposed_front,z,3.8)
        bore=_cylinder(manager,x,y,z-5,z+.01,1.6)
        if not manager.booleanOperation(boss,bore,fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Candidate boss subtraction failed')
        # Only proposed material not already present is treated as an addition.
        addition=manager.copy(boss)
        if not manager.booleanOperation(addition,host['body'],fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Proposed boss material delta failed')
        additions=_intersections(manager,addition,foreign)
        result.append({'insert':key,'screw':screw['occurrence'],'group':screw['physical_group'],'face_mm':[x,y,z],
                       'host':host['component'],'pilot_diameter_mm':2*pilot['radius_mm'],'actual_blind_depth_mm':depth,
                       'manufacturer_blind_depth_mm':5,'blind_depth_deficit_mm':max(0,5-depth),
                       'required_void_current_host_obstruction':pilot_obstruction,'required_void_foreign_overlap':void_foreign,
                       'sampled_radial_sections':section,'minimum_sampled_material_beyond_crest_mm':minimum,
                       'radial_target2mm_met_by_selected_samples':minimum>=1.999,
                       'official_candidate_receiver_interference':_intersections(manager,candidate,[host]),
                       'official_candidate_paired_screw_thread_overlap':_intersections(manager,candidate,[screw]),
                       'official_candidate_unrelated_parts_overlap':_intersections(manager,candidate,foreign),
                       'screw_geometry':{'definition':screw['hardware'],'seat_mm':screw['head_seat_mm'],
                         'nominal_insert_span_overlap_mm':max(0,min(z,screw['head_seat_mm'][2])-max(z-4,screw['head_seat_mm'][2]-screw['hardware']['length_mm']))},
                       'transient_proposed_boss':{'diameter_mm':7.6,'front_Z_mm':proposed_front,'rear_Z_mm':z,
                         'pilot_diameter_mm':3.2,'blind_depth_mm':5,'minimum_nominal_floor_mm':z-5-proposed_front,
                         'added_material_volume_mm3':addition.volume*1000,'added_material_foreign_overlaps':additions,
                         'status':'interference_blocked'if additions else'no_unrelated_solid_overlap_in_this_static_test'},
                       'interpretation':'Printed pilot and installed metal are distinct states. Exact paired heat-set and nominal thread overlap is quantified here, not accepted globally.'})
    preserved=(a._bodies(d)==before and other_documents(app)==others and not doc.isModified and d.timeline.count==1199 and params=={p.name:p.expression for p in d.allParameters})
    data={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,'data_id':doc.dataFile.id,'version':8,
          'status':'candidate_geometry_review_not_adopted','source_step_sha256':SOURCE_SHA,'official_candidate':official_report,
          'interfaces':result,'source_preserved':preserved,'other_documents':others,'candidate_adopted':False,
          'limits':['Radial material check samples72angles at5depths; not a global minimum-wall proof.',
                    'Candidate geometric threads are compared with unthreaded nominal screw shafts; their explicit paired overlap is not an unrelated collision.',
                    'Transient boss proposals are static only; gas, service, driver, width and tolerance checks must precede any native adoption.',
                    'Manufacturer tolerance and printed heat-set process remain unqualified.']}
    report('ruthex-m2-interface-evaluation.json',data)
    if not preserved:raise RuntimeError('Source state preservation failed')
    return data


def floors():
    """Bound existing blind-hole floor by whole Ø3.2 transient-cylinder coverage."""
    configure()
    import audit_a3 as a
    import review_checks as r
    import verification_a3 as v
    app,doc,d=_guard();before=a._bodies(d);others=other_documents(app)
    manager,rows=r.records();inv=json.loads((BASE/'verification/ruthex-m2-native-inventory.json').read_text())
    result=[]
    for entry in inv['native_m2_interfaces']:
        x,y,z=entry['face_mm'];pilot=next(p for p in entry['coaxial_printed_cylinders']if p['radius_mm']<2)
        bottom=pilot['bounds_mm'][0][2]
        hosts=[q for q in rows if q['component']==pilot['component']]
        if len(hosts)!=1:raise RuntimeError('Expected receiving body')
        host=hosts[0]
        def missing(depth):
            b=_cylinder(manager,x,y,bottom-depth,bottom-.001,1.6)
            if not manager.booleanOperation(b,host['body'],fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Floor coverage subtraction failed')
            return b.volume*1000
        lo=.001;hi=5.0
        maximum_missing=missing(hi)
        if maximum_missing<=1e-5:lo=hi;hi=None
        else:
            while hi-lo>.001:
                m=(lo+hi)/2
                if missing(m)<=1e-5:lo=m
                else:hi=m
        result.append({'insert':entry['occurrence'],'face_mm':entry['face_mm'],'host':host['component'],
                       'actual_pilot_bottom_Z_mm':bottom,'whole_pilot_diameter_floor_lower_bound_mm':lo,
                       'first_missing_material_upper_bound_mm':hi,'probe_diameter_mm':3.2,
                       'two_mm_floor_supported_by_selected_cylinder':lo>=1.999,'search_limit_mm':5})
    preserved=a._bodies(d)==before and other_documents(app)==others and not doc.isModified and d.timeline.count==1199
    data={'status':'read_only_selected_floor_coverage','interfaces':result,'source_preserved':preserved,
          'method':'Cumulative Ø3.2 cylinder below actual pilot floor; Boolean difference from actual host must be empty.0.001mm resolution, first0.001mm unprobed.',
          'manufacturing_or_global_wall_qualification':False}
    report('ruthex-m2-existing-floors.json',data)
    if not preserved:raise RuntimeError('Source/document state preservation failed')
    return data
