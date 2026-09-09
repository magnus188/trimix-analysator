"""Exact TC-M2x3.0 candidate audit. No saved native geometry is changed."""
from datetime import datetime,timezone
import hashlib,json,math
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE,owned,configure,other_documents,bounds,report
import ruthex_m2_audit as rx
import importlib
importlib.reload(rx)
SOURCE=BASE/'components/cnckitchen-m2-review/TC-M2x3.0_manufacturer.step'
SHA='d63e8b5b81a9fc0e61255214afb673a78d7ae7a189ccbde9d55f5a58ed4e678d'


def _official(manager):
    import audit_a3 as a
    import verification_a3 as v
    app,doc,d=owned();temp=None
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest()!=SHA:raise RuntimeError('TC source hash changed')
    try:
        opts=app.importManager.createSTEPImportOptions(str(SOURCE));opts.isViewFit=False
        temp=app.importManager.importToNewDocument(opts)
        if not temp or temp.isSaved:raise RuntimeError('Expected own unsaved TC candidate document')
        td=fusion.Design.cast(temp.products.itemByProductType('DesignProductType'))
        bodies=[b for _,_,_,b in a._instances(td)if b.isSolid]
        if len(bodies)!=1:raise RuntimeError('Expected one manufacturer solid')
        body=bodies[0];copy=v._world_copy(manager,body)
        planes=[];cones=[]
        for face in copy.faces:
            plane=core.Plane.cast(face.geometry);cone=core.Cone.cast(face.geometry)
            if plane:planes.append({'origin_mm':[x*10 for x in plane.origin.asArray()],'normal':list(plane.normal.asArray()),'bounds_mm':bounds(face)})
            if cone:cones.append({'origin_mm':[x*10 for x in cone.origin.asArray()],'axis':list(cone.axis.asArray()),'bounds_mm':bounds(face)})
        info={'source_step_sha256':SHA,'bounds_mm':bounds(copy),'volume_mm3':body.volume*1000,
              'high_accuracy_volume_mm3':body.getPhysicalProperties(fusion.CalculationAccuracy.HighCalculationAccuracy).volume*1000,
              'is_solid':copy.isSolid,'face_count':copy.faces.count,'cylinders':rx.cylinders(copy),'planes':planes,'cones':cones}
        if copy.volume<=0:raise RuntimeError('Candidate has no positive volume')
        return copy,info
    finally:
        try:
            if temp and not temp.close(False):raise RuntimeError('Cannot close own candidate document')
        finally:
            if not doc.activate():raise RuntimeError('Cannot restore SystemReview')


def inspect():
    configure();import audit_a3 as a
    app,doc,d=rx._guard();before=a._bodies(d);others=other_documents(app)
    manager=fusion.TemporaryBRepManager.get();body,info=_official(manager)
    preserved=a._bodies(d)==before and other_documents(app)==others and not doc.isModified and d.timeline.count==1199
    info.update({'document':doc.name,'source_preserved':preserved,'candidate_adopted':False,'other_documents':others})
    report('cnckitchen-m2-model-inspection.json',info)
    if not preserved:raise RuntimeError('Source state changed')
    return info


def evaluate():
    """Transient same-datum substitution and minimum local printed corrections."""
    configure()
    import audit_a3 as a
    import verification_a3 as v
    import review_checks as review
    import wall_fastener_checks as w
    import integrated_clearance as ic
    import gas_checks_a3 as gas
    app,doc,d=rx._guard();before=a._bodies(d);others=other_documents(app);params={p.name:p.expression for p in d.allParameters}
    manager,rows=review.records();physical=[r for r in rows if r['physical_group']!='alternative_oxygen_reference'];hw=w._hardware_records(d,rows)
    original,source=_official(manager)
    lo,hi=source['bounds_mm']
    if abs(lo[2])>1e-6 or abs(hi[2]-3)>1e-6:raise RuntimeError('Candidate source datum changed')
    m2=[r for r in hw if r['hardware']['kind']=='insert' and r['hardware']['size']=='M2']
    if len(m2)!=10:raise RuntimeError('Expected10 M2 inserts')
    inv=json.loads((BASE/'verification/ruthex-m2-native-inventory.json').read_text());byname={r['occurrence']:r for r in inv['native_m2_interfaces']}
    hosts={}
    for n in ('01 Shape A housing','USB A3 — removable printed support frame','Chamber / A3 top manifold with serial return'):
        found=[r for r in physical if r['component']==n]
        if len(found)!=1:raise RuntimeError('Expected one receiving host '+n)
        hosts[n]=dict(found[0],body=manager.copy(found[0]['body']))
    installed={};definitions=[]
    for insert in m2:
        key=insert['occurrence'];x,y,z=insert['head_seat_mm'];entry=byname[key]
        pilot=next(p for p in entry['coaxial_printed_cylinders']if p['radius_mm']<2);name=pilot['component'];host=hosts[name]
        screwname=entry['screws'][0]['name'];screw=next(r for r in hw if r['occurrence']==screwname)
        through=(screw['physical_group']=='pcb' or (screw['physical_group']=='display_retainers' and y<20))
        if screw['physical_group']=='pcb':
            px=d.userParameters.itemByName('PcbX').value*10;W=d.userParameters.itemByName('CaseWidth').value*10;wall=d.userParameters.itemByName('Wall').value*10
            low=[x-3.8,y-3.8,14.3]if y<50 else[48.2,y-3.8,14.3]
            high=[W-wall+.1,y+3.8,18.5]if y<50 else[px+8.2,y+3.8,18.5]
            outer=ic._box(manager,'PROPOSED WEB',low,high,'housing','Source-exact box proposal')['body']
            shape={'kind':'box','bounds_mm':[low,high]}
        else:
            start=14.3 if screw['physical_group']=='display_retainers' else 19 if screw['physical_group']=='usb' else 30
            outer=rx._cylinder(manager,x,y,start,z,3.8);shape={'kind':'cylinder','centre_XY_mm':[x,y],'radius_mm':3.8,'Z_mm':[start,z]}
        if not manager.booleanOperation(host['body'],outer,fusion.BooleanTypes.UnionBooleanType):raise RuntimeError('Cannot join transient host correction')
        bottom=14.2 if through else pilot['bounds_mm'][0][2]
        bore=rx._cylinder(manager,x,y,bottom,z+.1,1.6)
        if not manager.booleanOperation(host['body'],bore,fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Cannot cut transient pilot')
        candidate=manager.copy(original);t=core.Matrix3D.create();t.translation=core.Vector3D.create(x/10,y/10,(z-3)/10)
        if not manager.transform(candidate,t):raise RuntimeError('TC translation failed')
        installed[key]=dict(insert,body=candidate,hardware=dict(insert['hardware'],length_mm=3,part_number='TC-M2x3.0'))
        definitions.append({'insert':key,'screw':screwname,'group':screw['physical_group'],'face_mm':[x,y,z],
                            'host':name,'pilot_type':'through_non_gas'if through else'blind_retained',
                            'pilot_diameter_mm':3.2,'pilot_cut_Z_mm':[bottom,z+.1],
                            'remaining_blind_depth_mm':None if through else z-bottom,
                            'continuous_through_support_length_mm':4.2 if through else None,
                            'proposed_outer_material':shape})
    for r in list(hosts.values())+list(installed.values()):r.pop('bounds_cm',None);v._record_bounds(r)
    replacement={r['occurrence']:r for r in list(hosts.values())+list(installed.values())}
    proposed=[replacement.get(r['occurrence'],r)for r in physical]
    interface_results=[]
    for entry in definitions:
        key=entry['insert'];candidate=installed[key];host=hosts[entry['host']];screw=next(r for r in hw if r['occurrence']==entry['screw']);x,y,z=entry['face_mm']
        foreign=[r for r in proposed if r['occurrence']not in (key,host['occurrence'],screw['occurrence'])]
        cases=[]
        for thickness in ((1.44,1.6,1.76)if entry['group']=='pcb'else(None,)):
            delta=(thickness-1.6)if thickness else 0;body=manager.copy(screw['body']);t=core.Matrix3D.create();t.translation=core.Vector3D.create(0,0,delta/10)
            if not manager.transform(body,t):raise RuntimeError('Screw translation failed')
            moved=dict(screw,body=body,head_seat_mm=[screw['head_seat_mm'][0],screw['head_seat_mm'][1],screw['head_seat_mm'][2]+delta])
            moved.pop('bounds_cm',None);v._record_bounds(moved)
            obstacles=[moved if r['occurrence']==moved['occurrence'] else r for r in proposed
                       if not(entry['group']=='pcb' and r['occurrence'].startswith('PCB A3 - main four-layer placement:'))]
            tip=w._tip_probe(manager,moved,obstacles)
            seat=moved['head_seat_mm'][2];end=seat-screw['hardware']['length_mm']
            full=max(0,min(seat,z)-max(end,z-3));central=max(0,min(seat,z-.2)-max(end,z-2.8))
            cases.append({'finished_PCB_thickness_mm':thickness,'screw_tip_Z_mm':end,'insert_bottom_Z_mm':z-3,
                          'tip_projection_beyond_insert_mm':max(0,z-3-end),'whole_insert_axial_overlap_mm':full,
                          'axial_overlap_excluding_source0p2mm_end_chamfers_mm':central,
                          'tip_probe':tip,'actual_screw_unrelated_parts_overlap':rx._intersections(manager,body,[r for r in obstacles if r['occurrence']not in (key,screw['occurrence'])]),
                          'nominal_main_STEP_excluded_for_hypothetical_board_thickness':entry['group']=='pcb',
                          'geometric_only_not_full_thread_engagement':True})
        section=rx._radial_sections(host['body'],x,y,z,(.2,1,2,2.8))
        interface_results.append(dict(entry,radial_sections=section,
          minimum_sampled_material_beyond_crest_mm=min(q['minimum_sampled_lower_mm']for q in section),
          exact_candidate_host_heatset_overlap=rx._intersections(manager,candidate['body'],[host]),
          exact_candidate_nominal_screw_overlap=rx._intersections(manager,candidate['body'],[screw]),
          exact_candidate_unrelated_parts_overlap=rx._intersections(manager,candidate['body'],foreign),
          screw_cases=cases))
    # Test changed PRINTED solids against every unrelated installed solid.
    host_checks=[]
    for name,host in hosts.items():
        own_inserts={q['insert']for q in definitions if q['host']==name}
        foreign=[r for r in proposed if r['occurrence']!=host['occurrence'] and r['occurrence']not in own_inserts]
        hits=rx._intersections(manager,host['body'],foreign)
        previous=next(r for r in physical if r['occurrence']==host['occurrence'])
        added=manager.copy(host['body']);removed=manager.copy(previous['body'])
        if not manager.booleanOperation(added,previous['body'],fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Added material comparison failed')
        if not manager.booleanOperation(removed,host['body'],fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Removed material comparison failed')
        host_checks.append({'host':name,'actual_proposed_bounds_mm':bounds(host['body']),
                            'added_material_mm3':added.volume*1000,'removed_material_mm3':removed.volume*1000,'unrelated_intersections':hits})
    # Gas verifier consumes copies with only the three proposed printed hosts
    # and the ten exact purchased inserts replaced. Source geometry is untouched.
    original_records=gas._records
    try:
        gas._records=lambda design,manager_: proposed
        gas_result=gas._gas_result(d)
    finally:gas._records=original_records
    # Manufacturer CAD thread is explicitly not assumed geometrically exact.
    test_pin=rx._cylinder(manager,0,0,.001,2.999,1.0)
    m2_pin_overlap=rx._intersections(manager,test_pin,[{'occurrence':'manufacturer TC model','component':'manufacturer TC model','name':'TC-M2x3.0','body':original, 'bounds_cm':v._numeric_bounds(original.boundingBox)}])
    preserved=a._bodies(d)==before and other_documents(app)==others and not doc.isModified and d.timeline.count==1199 and params=={p.name:p.expression for p in d.allParameters}
    radial_pass=all(q['minimum_sampled_material_beyond_crest_mm']>=1.999 for q in interface_results)
    cases=[c for q in interface_results for c in q['screw_cases']]
    passed=(not any(q['unrelated_intersections']for q in host_checks) and not any(q['exact_candidate_unrelated_parts_overlap']for q in interface_results)
            and all(not c['actual_screw_unrelated_parts_overlap'] and c['tip_probe']['passes_selected_nominal_gap']for c in cases)and radial_pass and gas_result['pass'])
    data={'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,'version':8,'timeline':1199,
          'status':'transient_proposal_checks_passed_not_adopted'if passed else'transient_proposal_needs_review',
          'source_step_sha256':SHA,'source_model':source,'interfaces':interface_results,'printed_host_checks':host_checks,
          'all_selected_radial_sections_at_least2mm':radial_pass,'gas_probe':gas_result,
          'source_thread_geometry_issue':{'minimum_coaxial_cylinder_diameter_mm':2.0755,
              'nominal_M2_major_diameter_mm':2.0,'full3mm_nominal_M2_cylinder_intersections':m2_pin_overlap,
              'disposition':'Exact external purchasedCAD is retained unscaled. Internal thread is a visual/reference model; its oversized bore cannot prove M2 engagement. Manufacturer part identity is from theprimaryM2 product/poster. Actual usablethread/runout/class remains a physical gate.'},
          'source_preserved':preserved,'other_documents':others,'native_adopted':False,
          'limits':['This is a transient static and selected gas/radial/tip check. Native feature regeneration, service/driver paths, width endpoints and final newPCB maximumcontracts still must be checked after authorized adoption.',
                    'The factory frame is itself a recorded reference; its real dimensions and heatset installation clearances remain subject to measurement. Install heat sets with display/electronics removed.',
                    'Nominal axial allocation excluding0.2mm source chamfers is not guaranteed fullthread engagement, clampforce, torque, pullout or printprocess qualification.']}
    report('cnckitchen-m2-proposal-evaluation.json',data)
    if not preserved:raise RuntimeError('Source preservation failed')
    return data
