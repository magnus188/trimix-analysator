"""Scoped actual native checks for exact TC inserts, without broad clash waivers."""
from pathlib import Path
from contextlib import contextmanager
import hashlib,json,math,importlib
import adsk.core as core
import adsk.fusion as fusion
from runtime import BASE,GROUP,owned,configure,report,bounds,other_documents
from apply_short_m2 import APPROVED
ROOT=BASE/'verification/short-m2-implementation'


def write(directory,name,data):
    directory.mkdir(parents=True,exist_ok=True);(directory/name).write_text(json.dumps(data,indent=2)+'\n');return data


def interfaces():
    _,_,d=owned();root=d.rootComponent
    marker=root.attributes.itemByName(GROUP,'short_m2_proposal_sha256')
    if not marker or marker.value!=APPROVED:raise RuntimeError('Approved short-M2 marker missing')
    source=root.attributes.itemByName(GROUP,'short_m2_source_sha256')
    if not source or source.value!='d63e8b5b81a9fc0e61255214afb673a78d7ae7a189ccbde9d55f5a58ed4e678d':raise RuntimeError('M2 source marker changed')
    rows=json.loads(root.attributes.itemByName(GROUP,'short_m2_interfaces').value)
    if len(rows)!=10:raise RuntimeError('Exact10 M2interface contract missing')
    return rows


@contextmanager
def adapted(directory):
    configure()
    import review_checks as review
    import verification_a3 as v
    import width_contract_checks as width
    import thickness_fasteners as tf
    import wall_fastener_checks as w
    importlib.reload(width);importlib.reload(tf)
    pairs=interfaces();_,_,d=owned()
    expected=json.loads((BASE/'verification/cnckitchen-m2-proposal-evaluation.json').read_text())
    expected={q['insert']:q['exact_candidate_host_heatset_overlap'][0]['volume_mm3']for q in expected['interfaces']}
    old_collision=review.collision_report;old_sections=width.selected_sections;native_test=v._test
    import service_enclosing_proof
    importlib.reload(service_enclosing_proof)
    old_test=service_enclosing_proof.run
    prior=(width.HOUSING_PILOT_RADIUS_MM,width.TRIAL_ROOT,tf.EXPECTED_INSERT_LENGTH_MM,tf.report,review.report,w._owned_design)
    def collision(manager,physical):
        raw=old_collision(manager,physical);labels={v._label(r):r for r in physical}
        binding={}
        for pair in pairs:
            ins=[r for r in physical if r['occurrence']==pair['occurrence']]
            host=[r for r in physical if r['component']==pair['host']]
            if len(ins)!=1 or len(host)!=1:raise RuntimeError('Exact heat-set pair absent/ambiguous')
            hardware=ins[0]['hardware']
            if not hardware or hardware.get('manufacturer_part_number')!='TC-M2x3.0' or hardware['length_mm']!=3:raise RuntimeError('M2hardware identity mismatch')
            binding[frozenset((v._label(ins[0]),v._label(host[0])))]=(pair,expected[pair['old_occurrence']])
        engaged=[];unrelated=[]
        for hit in raw['collisions']:
            entry=binding.get(frozenset((hit['one'],hit['two'])))
            if entry and abs(hit['volume_mm3']-entry[1])<1e-4:
                engaged.append(dict(hit,expected_transient_volume_mm3=entry[1],explicit_interface=entry[0],interpretation='Exact assigned metal/pilot pair; intended heat-set displacement, physical retention unqualified'))
            else:unrelated.append(hit)
        if len(engaged)!=10:raise RuntimeError('Expected10 exact measured heat-set overlaps; unexpected geometry cannot be waived')
        raw.update(collisions=unrelated,engaged_heatset_interfaces=engaged,all_positive_intersection_count=len(raw['collisions']),
                   heatset_classification='Only ten source/occurrence-bound pairs within0.0001mm³ of independently predicted overlap. No other interference is waived.')
        return raw
    def sections():
        result=old_sections();result['existing_pilot_Y_ligament_mm']=2.2
        result['nominal_material_beyond_TC_crest_mm']=2
        result['limits']='Updated source7.6mm support minusØ3.2pilot gives2.2mm; minusØ3.6crest gives2mm. Dedicated actual cylindrical/radial checks supplement this selected carrier subset; no global wall or retention claim.'
        return result
    def staged_test(manager,name,moving,fixed,waypoints,prerequisites,diagnostic=False):
        from datetime import datetime,timezone
        write(directory,'latest-native-progress.json',{'stage':name,'state':'running','at_utc':datetime.now(timezone.utc).isoformat()})
        if name!='retainers':
            result=old_test(manager,name,moving,fixed,waypoints,prerequisites,diagnostic)
            write(directory,'latest-native-progress.json',{'stage':name,'state':'finished','collision_count':result['collision_count'],'at_utc':datetime.now(timezone.utc).isoformat()})
            return result
        upper=[q for q in moving if q['component']=='Display / upper rear-release retainer']
        lower=[q for q in moving if q['component']=='Display / lower rear-release retainer']
        if len(upper)!=1 or len(lower)!=1 or len(moving)!=2:raise RuntimeError('Retainer service selection changed')
        import integrated_clearance as ic
        manifest=ic._manifest();contract=json.loads(Path(manifest['main']['height_contract_file']).read_text())
        fixed=fixed+[ic._mate(manager,contract,.16),ic._cable(manager,contract,.16)]
        old_path=v._path;old_step=v.MAX_STEP_MM
        v._path=lambda points,max_step_mm=.25:old_path(points,max_step_mm);v.MAX_STEP_MM=.25
        try:
            end=v._full_z_path(upper,fixed+lower)[-1][2]
            tests=[old_test(manager,'upper_staged',upper,fixed+lower,[(0,0,0),(0,0,6),(-1.5,0,6),(-1.5,0,end)],prerequisites+['Lift upper clip rearward6mm, shift negativeX1.5mm, then withdraw rearward; lower retainer remains.'])]
            tests.append(old_test(manager,'lower_after_upper',lower,fixed,v._full_z_path(lower,fixed),prerequisites+['Upper retainer removed; lower retainer withdraws rearward.']))
        finally:v._path=old_path;v.MAX_STEP_MM=old_step
        hits=[h for t in tests for h in t['collisions']]
        return {'name':name,'status':'blocked_at_sampled_poses'if hits else'clear_at_sampled_poses','collision_count':len(hits),'collisions':hits,'blocked_by':sorted({h['fixed']for h in hits}),
            'sample_count':sum(t['sample_count']for t in tests),'maximum_sample_step_mm':.25,'subtests':tests,'continuous_swept_volume_checked':False,
            'method':'Actual upper clip +Z6/-X1.5/rearward, then lower straight rearward; exact BRep samples every<=.25mm; source geometry unchanged.'}
    v._test=staged_test
    review.collision_report=collision;width.selected_sections=sections;width.HOUSING_PILOT_RADIUS_MM=1.6;width.TRIAL_ROOT=directory
    tf.EXPECTED_INSERT_LENGTH_MM=3.0;tf.report=lambda name,data:write(directory,name,data);review.report=lambda name,data:write(directory,name,data)
    try:yield
    finally:
        review.collision_report=old_collision;width.selected_sections=old_sections;v._test=native_test
        width.HOUSING_PILOT_RADIUS_MM,width.TRIAL_ROOT,tf.EXPECTED_INSERT_LENGTH_MM,tf.report,review.report,w._owned_design=prior


def actual_sections(directory):
    configure()
    import review_checks as review
    import wall_fastener_checks as w
    import ruthex_m2_audit as rx
    import verification_a3 as v
    _,_,d=owned();manager,rows=review.records();hardware=w._hardware_records(d,rows);byname={r['occurrence']:r for r in hardware}
    result=[]
    for pair in interfaces():
        insert=byname[pair['occurrence']];host=next(r for r in rows if r['component']==pair['host'])
        x,y,z=insert['head_seat_mm'];sections=rx._radial_sections(host['body'],x,y,z,(.2,1,2,2.8))
        holes=[f for f in rx.cylinders(host['body'])if abs(f['radius_mm']-1.6)<1e-5 and math.dist(f['origin_mm'][:2],[x,y])<1e-5 and abs(abs(f['axis'][2])-1)<1e-7 and f['bounds_mm'][1][2]>=z-.01]
        if len(holes)!=1:raise RuntimeError('M2 actual pilot not singular')
        bottom=holes[0]['bounds_mm'][0][2];depth=z-bottom
        # Confirm the intended open/closed end in actual material.
        disk=rx._cylinder(manager,x,y,bottom-.025,bottom-.001,1.59)
        overlap=rx._intersections(manager,disk,[host]);void=not overlap
        wanted_void=pair['pilot_type']=='through_non_gas'
        floor=None
        if not wanted_void:
            floorprobe=rx._cylinder(manager,x,y,bottom-2,bottom-.001,1.59)
            if not manager.booleanOperation(floorprobe,host['body'],fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Blind-floor material probe failed')
            floor={'required_depth_mm':2,'missing_material_mm3':floorprobe.volume*1000,'pass':floorprobe.volume*1000<1e-5}
        row={'insert':pair['occurrence'],'host':pair['host'],'face_mm':[x,y,z],'pilot_type':pair['pilot_type'],
             'actual_pilot_depth_mm':depth,'native_axis_and_pose_error_mm':insert['target_position_error_mm'],
             'opening_below_pilot_is_void':void,'expected_open_end':wanted_void,'blind_floor':floor,'radial_sections':sections,
             'pass':void==wanted_void and depth>=(3 if wanted_void else 4)-1e-5 and all(q['minimum_sampled_lower_mm']>=1.999 for q in sections) and(floor is None or floor['pass'])}
        result.append(row)
    data={'status':'selected_actual_material_passed'if all(r['pass']for r in result)else'needs_review','interfaces':result,'global_minimum_wall_proven':False,'physical_retention_qualified':False}
    return write(directory,'actual-M2-material.json',data)


def baseline():
    configure();directory=ROOT/'baseline'
    import review_checks as review
    import gas_checks_a3 as gas
    import thickness_fasteners as tf
    import width_contract_checks as width
    import audit_a3 as a
    app,doc,d=owned();before=a._bodies(d);protected=other_documents(app);timeline=d.timeline.count
    with adapted(directory):
        material=actual_sections(directory);review.mechanical();gas_result=gas._gas_result(d);write(directory,'gas.json',gas_result)
        fastener=tf.audit();axes=width.hole_axes()
    if before!=a._bodies(d)or protected!=other_documents(app)or timeline!=d.timeline.count:raise RuntimeError('Read-only baseline altered source')
    result={'material_status':material['status'],'gas_pass':gas_result['pass'],'fastener_status':fastener['status'],'hole_axes':axes,'health':review.health(d),'source_preserved':True}
    return write(directory,'summary.json',result)


def trial85():return trial(85,ROOT/'width-tests')
def trial87():return trial(87,ROOT/'width-tests')
def trial(width_mm,directory):
    import width_contract_checks as width
    with adapted(directory):return width.trial(width_mm)


def retainer85_with_mate():
    import width_contract_checks as width
    import integrated_clearance as ic
    import verification_a3 as v
    directory=ROOT/'retainer-full-allocations-W85'
    with adapted(directory):
        with width.allocations(directory)as probe:
            module,old=probe._adapter(False);old_out=module.OUTPUT;module.OUTPUT=directory
            try:return module.audit_paths(['retainers'])
            finally:module._records=old;module.OUTPUT=old_out
