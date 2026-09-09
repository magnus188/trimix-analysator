"""Continuous conservative cable/card volumes against native ConnectorReview.

No native mutations. Unknown wire diameter, bend radius and remote mates are
engineering allocations, never asserted supplier dimensions or qualified fit.
"""
import json, math, sys
from pathlib import Path
import adsk.core as core
import adsk.fusion as fusion
import connector_photo_review as review
from connector_basefeature_review import snapshot


def setup():
    app,doc,d=review.owned();review.helpers()
    import verification_a3 as v
    manager=fusion.TemporaryBRepManager.get();rows=[]
    for o in d.rootComponent.allOccurrences:
        if o.component.attributes.itemByName(review.GROUP,'geometry_role') and o.component.attributes.itemByName(review.GROUP,'geometry_role').value=='clearance_envelope':continue
        group=o.component.attributes.itemByName('TrimixRev04','physical_group')
        if group and group.value=='alternative_oxygen_reference':continue
        for body in o.bRepBodies:
            if not body.isSolid:continue
            rows.append({'name':o.fullPathName+' / '+body.name,'component':o.component.name,'occurrence':o.fullPathName,
                         'body':body,'bounds':review.box_bounds(body),'group':group.value if group else None})
    incoming=json.loads((review.BASE/'verification/incoming-boards.json').read_text())
    p=Path(incoming['main']['height_contract_file'])
    if review.sha(p)!=incoming['main']['height_contract_sha256']:raise RuntimeError('Maximumcontract source hash differs')
    contract=json.loads(p.read_text())
    for r in contract['rows']:
        if r['DNP']:continue
        low=[r['Fusion_x_min_mm'],r['Fusion_y_min_mm'],r['Fusion_z_bottom_mm']]
        high=[r['Fusion_x_max_mm'],r['Fusion_y_max_mm'],r['Fusion_z_top_mm']]
        probe=box(manager,'MAX/'+r['reference'],low,high)
        rows.append({'name':'MAX/'+r['reference'],'component':'PCB maxima','occurrence':'MAX/'+r['reference'],
                     'body':probe['body'],'bounds':[low,high],'group':'pcb_maximum','transient':True})
    return app,doc,d,manager,rows,v,{'main_step_sha256':incoming['main']['sha256'],
           'board_sha256':contract['board_sha256'],'height_contract_sha256':review.sha(p),
           'height_rows':len(contract['rows']),'maximum_allocations':sum(not x['DNP'] for x in contract['rows'])}


def point(x):return core.Point3D.create(*[n/10 for n in x])


def box(manager,name,low,high):
    body=manager.createBox(core.OrientedBoundingBox3D.create(point([(a+b)/2 for a,b in zip(low,high)]),
         core.Vector3D.create(1,0,0),core.Vector3D.create(0,1,0),*[(b-a)/10 for a,b in zip(low,high)]))
    if not body or not body.isSolid:raise RuntimeError('No box '+name)
    return {'name':name,'body':body,'bounds':[low,high]}


def capsule_route(manager,name,points,diameter):
    result=[]
    for i,p in enumerate(points):
        body=manager.createSphere(point(p),diameter/20)
        result.append({'name':name+'/bend-clearance'+str(i),'body':body,'bounds':review.box_bounds(body)})
    for i,(p,q) in enumerate(zip(points,points[1:])):
        if math.dist(p,q)<1e-8:raise RuntimeError('Zero segment')
        body=manager.createCylinderOrCone(point(p),diameter/20,point(q),diameter/20)
        result.append({'name':name+'/segment'+str(i),'body':body,'bounds':review.box_bounds(body)})
    return result


def annular_bend(manager, name, center, axis, radius, radial_width,
                 axial_thickness, clip_low, clip_high):
    """Exact circular bend of a rectangular section, clipped to one quadrant."""
    p = list(center)
    q = list(center)
    p[axis] -= axial_thickness / 2
    q[axis] += axial_thickness / 2
    outer = manager.createCylinderOrCone(point(p), (radius + radial_width / 2) / 10,
                                         point(q), (radius + radial_width / 2) / 10)
    inner_radius = radius - radial_width / 2
    if inner_radius <= 0:
        raise RuntimeError('Bend has no positive inner radius')
    inner = manager.createCylinderOrCone(point(p), inner_radius / 10,
                                         point(q), inner_radius / 10)
    if not manager.booleanOperation(outer, inner, fusion.BooleanTypes.DifferenceBooleanType):
        raise RuntimeError('Annular bend subtraction failed')
    clip = box(manager, name + '/quadrant', clip_low, clip_high)
    if not manager.booleanOperation(outer, clip['body'], fusion.BooleanTypes.IntersectionBooleanType):
        raise RuntimeError('Annular bend clipping failed')
    return {'name': name, 'body': outer, 'bounds': review.box_bounds(outer)}


def shaped_wire_trial():
    """A bounded seven-wire corridor with finite bends; no sensor or native edit."""
    app, doc, d, m, rows, v, sources = setup()
    before = snapshot(d)
    timeline = d.timeline.count
    b = review.helpers()
    import chamber_a3
    gas = capsule_route(m, 'PROTECTED_5MM_GAS',
                        [[b.mm(d, s) for s in p] for p in chamber_a3.probe_route_expressions()], 5)
    obstacles = rows + [{'name': p['name'], 'component': 'Protected gas allocation',
                        'body': p['body'], 'bounds': p['bounds'], 'transient': True} for p in gas]
    # The section is 4.8 x 2.5 mm. Its broad axis follows each circular bend;
    # it does not silently remain in one global orientation at a corner.
    probes = [
        box(m, 'Front straight, broad axis Y', [35.125, 169.95, 5.25], [51, 174.75, 7.75]),
        annular_bend(m, 'XY left turn R5', [35.125, 167.35, 6.5], 2, 5, 4.8, 2.5,
                     [27.725, 167.35, 5.25], [35.125, 174.75, 7.75]),
        box(m, 'CO-side front straight, broad axis X', [27.725, 139, 5.25], [32.525, 167.35, 7.75]),
        annular_bend(m, 'YZ rise R3', [30.125, 139, 9.5], 0, 3, 2.5, 4.8,
                     [27.725, 134.75, 5.25], [32.525, 139, 9.5]),
        box(m, 'CO-side rise, broad axis X', [27.725, 134.75, 9.5], [32.525, 137.25, 26.5]),
        annular_bend(m, 'XZ left turn R5', [25.125, 136, 26.5], 1, 5, 4.8, 2.5,
                     [25.125, 134.75, 26.5], [32.525, 137.25, 33.9]),
        box(m, 'Above CO toward merge, broad axis Z', [20, 134.75, 29.1], [25.125, 137.25, 33.9]),
        annular_bend(m, 'XY toward outlet R3', [20, 133, 31.5], 2, 3, 2.5, 4.8,
                     [15.75, 133, 29.1], [20, 137.25, 33.9]),
        box(m, 'End before existing feedthrough, broad axis Z', [15.75, 132.2, 29.1], [18.25, 133, 33.9]),
    ]
    result = test(m, v, 'Seven-wire shaped corridor; original sensor positions', probes, obstacles,
                  ('Potted harness closure reference',))
    result['scope'] = 'Exact rectangular prisms and circular annular-sector sweeps, including finite centerline radii 3 and 5 mm.'
    # A separate negative control carries this exact section through the existing
    # circular hole. It may be rejected; it is never an implicit new hole.
    feed = box(m, 'Existing feedthrough section test', [15.75, 129.8, 29.1], [18.25, 132.2, 33.9])
    feed_test = test(m, v, 'Existing 4.4 mm circular feedthrough versus shaped section', [feed], obstacles,
                     ('Potted harness closure reference',))
    unchanged = before == snapshot(d) and timeline == d.timeline.count
    review.write('shaped-wire-trial.json', {
        'status': 'bounded_shaped_corridor_study_not_a_complete_harness',
        'sources': sources, 'persistent_geometry_unchanged': unchanged,
        'sensor_positions_changed': False, 'section_mm': [4.8, 2.5],
        'engineering_centerline_bend_radii_mm': [3, 5],
        'minimum_inner_surface_bend_radius_mm': 1.75,
        'tests': [result, feed_test],
        'packing_example_only': {
            'rows': [4, 3], 'individual_insulation_max_OD_mm': 1.1,
            'ideal_hexagonal_width_mm': 4.4,
            'ideal_hexagonal_height_mm': 1.1 * (1 + math.sqrt(3) / 2),
            'actual_wire_selected': False,
        },
        'limits': [
            'This tests the shared seven-wire corridor only. Sensor terminations, approach merges, eleven-wire outlet transition and dry branches remain unqualified.',
            'No supplier bend rating is available; finite engineering radii are a geometric allocation only.',
            'The seven-wire example is not a wire or terminal selection; actual maximum insulation OD, packing, retention and assembly need qualification.',
            'Existing circular feedthrough is tested separately without changing the printed wall or claiming a seal.',
            'All gas-route volumes, sensor bodies, mounting features and lid remain obstacles.',
        ],
    })
    if not unchanged:
        raise RuntimeError('Read-only shaped corridor study changed native geometry')


def intended_mates():
    """Include all intended existing Harwin/JST cable housings, without adoption."""
    app, doc, d, m, rows, v, sources = setup()
    before = snapshot(d)
    timeline = d.timeline.count
    incoming = json.loads((review.BASE / 'verification/incoming-boards.json').read_bytes())
    contract = json.loads(Path(incoming['main']['height_contract_file']).read_bytes())
    by_ref = {r['reference']: r for r in contract['rows']}
    entries = []
    tests = []
    for reference in ['J103', 'J401', 'J501', 'J601', 'J701', 'J801', 'J802']:
        row = by_ref[reference]
        x = (row['Fusion_x_min_mm'] + row['Fusion_x_max_mm']) / 2
        y = (row['Fusion_y_min_mm'] + row['Fusion_y_max_mm']) / 2
        if reference in ['J601', 'J701']:
            width = row['Fusion_x_max_mm'] - row['Fusion_x_min_mm']
            depth = row['Fusion_y_max_mm'] - row['Fusion_y_min_mm']
            height = 9.8
            housing_base = 2.3
            identity = 'JST XHP-4 / SXH-001T-P0.6 candidate'
            basis = '9.8 mm complete seated height is a manufacturer reference, not a guaranteed maximum; existing board-header XY envelope encloses the nominal 12.3 x 5.7 housing.'
        else:
            positions = 3 if reference in ['J401', 'J501'] else 2
            length = 2.54 * positions + 0.20 + 0.30
            width, depth = (length, 2.7) if row['rotation_deg'] == 90 else (2.7, length)
            height = 16.84
            housing_base = 2.44
            identity = 'Harwin M20-106%02d00 / M20-1180046 candidate' % positions
            basis = 'Conditional maximum: housing 14.2 plus header base 2.64. Existing post maximum6.35 exceeds housing allowed6.30; no controlled stand-off is included or qualified.'
        variants = []
        for shift in [0, 0.8]:
            low = [x - width / 2 - .15, y - depth / 2 - .15, 22.1 + housing_base + shift]
            high = [x + width / 2 + .15, y + depth / 2 + .15, 22.1 + height + .15 + .16 + shift]
            probe = box(m, reference + ' mate; PCB shift ' + str(shift), low, high)
            # In the +0.8 trial, use only fixed case/chamber/cover/battery obstacles.
            # Unmoved neighbouring PCB models would otherwise be a false comparison.
            fixed = rows if shift == 0 else [r for r in rows if r['group'] != 'pcb_maximum' and
                    not r['name'].startswith('PCB A3 - main four-layer placement')]
            tested = test(m, v, probe['name'], [probe], fixed, (reference, 'MAX/' + reference))
            tested['scope'] = 'Conditional mated housing plus .15 mm assembly and +.16 mm PCB thickness allowances; excludes only its named mating header. No wires, bend or withdrawal sweep.'
            tests.append(tested)
            variants.append({'pcb_shift_mm': shift, 'bounds_mm': [low, high],
                             'nominal_flat_cover_gap_mm': 40.8 - high[2],
                             'clearance_status': tested['status'],
                             'scope': 'Actual installed neighbours' if shift == 0 else 'Fixed enclosure obstacles only; not complete shifted PCB assembly acceptance'})
        entries.append({'reference': reference, 'board_header_MPN': row['MPN'], 'candidate_mate': identity,
                        'pin1_world_mm': [50.4 + row['PCB_x_mm'], 120 - row['PCB_y_mm']],
                        'housing_center_world_mm': [x, y], 'full_stack_above_PCB_mm': height,
                        'XY_body_envelope_mm': [width, depth], 'wire_exit': 'axial +Z',
                        'basis': basis, 'variants': variants})
    unchanged = before == snapshot(d) and timeline == d.timeline.count
    review.write('intended-mate-allowances.json', {
        'status': 'all_intended_existing_small_header_mates_included_as_candidates',
        'sources': sources, 'source_memo': str(review.PHOTO / 'connector-candidates.md'),
        'source_memo_sha256': review.sha(review.PHOTO / 'connector-candidates.md'),
        'source_receipt_sha256': review.sha(review.PHOTO / 'connector-source-receipt.json'),
        'persistent_geometry_unchanged': unchanged, 'entries': entries, 'tests': tests,
        'J104': 'Open charge-arm header: no female cable allocation added.',
        'J401_AO2_actual_cable_mate': 'Unknown existing cable identity, termination and bending; Harwin candidate does not establish its identity.',
        'remaining_other_interfaces': ['J301 keyed main / unkeyed remote ribbon harness',
            'J402 actual SMB elbow and cable', 'USB six-wire harness and solder bends',
            'Battery input connection and RCY lead allowances', 'SD socket mechanism and retained factory rim'],
        'limits': ['No new purchased parts adopted or scaled.',
            'Axial wire bend, service withdrawal, stand-off and crimp construction remain open.',
            'The .15 mm allowance is an engineering allocation, not a supplier tolerance.',
            'Pin1 coordinates and housing centre are different; both are explicitly reported.'],
    })
    if not unchanged:
        raise RuntimeError('Mate inventory changed native geometry')


def overlap(a,b):return all(min(a[1][i],b[1][i])-max(a[0][i],b[0][i])>1e-7 for i in range(3))


def test(manager,v,name,probes,rows,exclude=()):
    hits=[];tests=0;excluded=[]
    for r in rows:
        if any(s in r['name'] or s in r['component'] for s in exclude):
            excluded.append(r['name']);continue
        candidates=[p for p in probes if overlap(p['bounds'],r['bounds'])]
        if not candidates:continue
        native=r['body'] if r.get('transient') else v._world_copy(manager,r['body'])
        for p in candidates:
            tests+=1
            intersection=manager.copy(p['body'])
            if not manager.booleanOperation(intersection,manager.copy(native),fusion.BooleanTypes.IntersectionBooleanType):
                raise RuntimeError('Native intersection failed; clearance unknown')
            vol=intersection.volume*1000 if intersection.faces.count else 0
            if vol>1e-5:hits.append({'probe':p['name'],'fixed':r['name'],'volume_mm3':vol,
                                     'intersection_bounds_mm':review.box_bounds(intersection)})
    return {'name':name,'status':'clear_continuous_allocation' if not hits else 'blocked',
            'collision_count':len(hits),'collisions':hits,'excluded':excluded,'boolean_tests':tests,
            'probes':[{'name':p['name'],'bounds_mm':p['bounds']}for p in probes],
            'scope':'Continuous fullsolid prism/cylinder/sphere allocations; actualwire/finger/bend/source-mate stillunmeasured'}


def interfaces():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d);timeline=d.timeline.count
    b=review.helpers();front=b.mm(d,'DisplayFront');hx=b.mm(d,'DisplayX')+35.178;hy=b.mm(d,'DisplayY')+100.8025;pcb=front+4.86
    mate=box(m,'REMOTE_JP1_MATE',[hx-17.5,hy-2.75,front+13.4-6.223],[hx+17.5,hy+2.75,front+17.8])
    tests=[test(m,v,'Unkeyed remoteJP1 candidate installed',[mate],rows,('JP1 pin ','JP1 reference insulator'))]
    # Exact envelope of a pure axial translation: a single enlarged rectangular prism.
    unmate=box(m,'REMOTE_JP1_UNMATE',[hx-17.5,hy-2.75,front+13.4-6.223],[hx+17.5,hy+2.75,front+17.8+6.223])
    tests.append(test(m,v,'RemoteJP1 axialunmate aftercoverandbatteryremoved',[unmate],rows,
                     ('JP1 pin ','JP1 reference insulator','Rear cover','rear cover','Battery /','Battery holder','Battery occupied','Rear M3')))
    dx=b.mm(d,'DisplayX');dy=b.mm(d,'DisplayY')
    low=[dx+4.859,dy+62.679,pcb+.4];high=[low[0]+15,low[1]+11,low[2]+1]
    card=box(m,'SD_FULL_LEFT_EXTRACTION',[low[0]-15.5,low[1],low[2]],high)
    tests.append(test(m,v,'SD15.5mmstraightleftwithdrawal coveroff',[card],rows,
                     ('Guition / installed microSD','microSD left-facing holder','Rear cover','rear cover','Rear M3')))
    # This distinguishes case blockage from the still-unmeasured retained factoryrim.
    shifted=box(m,'SD_FRONT_RELEASE_LEFT_EXTRACTION',[low[0]-15.5,low[1],low[2]-15],
                [high[0],high[1],high[2]-15])
    tests.append(test(m,v,'SDcaseclearanceafter15mmfrontdisplayrelease',[shifted],rows,
                     ('Guition /','03 Guition','04 Guition','05 Active','Rear cover','rear cover','Rear M3')))
    for label,x,y in [('left',26.608,95.450),('right',37.922,95.149)]:
        plug=box(m,label+'_USB_SERVICE_PLUG',[dx+x-7,dy+y-4,pcb+6],[dx+x+7,dy+y+4,pcb+31])
        tests.append(test(m,v,label+'rearUSBplug14x8x25allowance',[plug],rows,
                         ('Guition / '+label+' rear-facing USB-C','Rear cover','rear cover','Rear M3')))
    # First simple comparative allocation only; no battery position mutation.
    moved=[];moved_names=[]
    for r in rows:
        q=dict(r)
        if r['component'].startswith('Battery /') and 'occupied' in r['name'].lower():
            moved_names.append(r['name'])
            q['body']=v._at(m,v._world_copy(m,r['body']),[0,0,2]);q['transient']=True
            q['bounds']=[[a+(2 if i==2 else 0)for i,a in enumerate(end)]for end in r['bounds']]
        moved.append(q)
    if moved_names:
        trial=test(m,v,'RemoteJP1againstprospectivepackplus2Zonly',[mate],moved,('JP1 pin ','JP1 reference insulator'))
        trial['translated_exact_bodies']=moved_names;tests.append(trial)
    else:
        tests.append({'name':'RemoteJP1againstprospectivepackplus2Zonly','status':'not_tested_no_exact_pack_selector','translated_exact_bodies':[]})
    unchanged=timeline==d.timeline.count and before==snapshot(d)
    result={'document':doc.name,'sources':sources,'persistent_geometry_unchanged':unchanged,'tests':tests,
            'measured_bare_tip_depth_mm':13.4,'conditional_mated_cap_depth_mm':[16.321,17.337],
            'engineering_mate_depth_mm':17.8,'SD_direction':[-1,0,0],'SD_mechanism_measured':False,
            'card_service_limit':'Front-releasecaseprobeexcludesdisplayassembly; it DOES NOT prove cardclearsretainedfactoryrim or unknownsocket latch. Directleftpulltest includescurrentfactoryrim.',
            'battery_trial_limit':'Onlyoccupied-packallocationtranslatedtransientlyifexactselectorfound; no support/retainer/cover or otherbatteryassemblyacceptance implied.',
            'status':'interface_review_complete_with_open_findings' if unchanged else 'preservation_failed'}
    review.write('interface-checks.json',result)
    if not unchanged:raise RuntimeError('Transientinterfacecheckchangednativegeometry')


def chamber_routes():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d);timeline=d.timeline.count
    tests=[];routes=[]
    # A3outlet/sealingcollar source: centreX17,Z31.5,exitY128.7.
    paths=[('Drychambertrunk',[[17,132,31.5],[17,127.5,31.5],[17,124,34],[57,124,34],[57,99,34],[57,91,34],[54.4,82.5,34]],3.8,('sealed harness feedthrough',)),
           ('BMEbranch',[[57,99,34],[73.1,99,34],[73.1,99,29.4]],2.4,('J601','MAX/J601')),
           ('CObranch',[[57,91,34],[73.1,91,34],[73.1,91,29.4]],2.4,('J701','MAX/J701')),
           ('MD62branch',[[54.4,82.5,34],[54.4,82.5,31.05]],2.2,('J501','MAX/J501')),
           ('WetBMEtocommonoutlet',[[61.5,169,13],[52,169,16],[35,169,16],[30,164,27],[30,147,27],[17,147,28],[17,132,31.5]],2.4,('sealed harness feedthrough',)),
           ('WetMD62tocommonoutlet',[[60,171.3,24],[55,173.5,26],[35,173.5,28],[30,164,27],[30,147,27],[17,147,28],[17,132,31.5]],2.2,('MD62 full-length lead','sealed harness feedthrough')),
           ('WetCOtocommonoutlet',[[7.2,134.3,22.6],[7.2,135,30.5],[17,135,31.5],[17,132,31.5]],2.4,('sealed harness feedthrough',))]
    import chamber_a3
    b=review.helpers();gaspoints=[[b.mm(d,s)for s in p]for p in chamber_a3.probe_route_expressions()]
    gas=capsule_route(m,'PROTECTED_5MM_GAS',gaspoints,5)
    gasrows=[{'name':p['name'],'component':'Protectedgasallocation','occurrence':'Protectedgasallocation','body':p['body'],'bounds':p['bounds'],'group':'gas_clearance','transient':True}for p in gas]
    for name,pts,diam,excluded in paths:
        probes=capsule_route(m,name,pts,diam)
        result=test(m,v,name,probes,rows+gasrows,excluded)
        result.update({'centreline_mm':pts,'allocated_diameter_mm':diam,'centreline_length_mm':sum(math.dist(a,b)for a,b in zip(pts,pts[1:])),
                       'bend_radius_qualified':False,'actualwiregauges_insulation_andtermination_unmeasured':True})
        tests.append(result);routes.append({'name':name,'points_mm':pts,'diameter_mm':diam,'status':result['status']})
    unchanged=timeline==d.timeline.count and before==snapshot(d)
    review.write('chamber-cable-checks.json',{'document':doc.name,'status':'routes_tested_no_fullfit_claim','sources':sources,
                 'persistent_geometry_unchanged':unchanged,'tests':tests,'routes':routes,
                 'logical_connector_contacts':{'BME':4,'CO':4,'MD62':3},
                 'MD62_basis':'Manufacturer joins two middle physicalleads; outercompensatorpositive,outerdetectormarkednegative. CADrodnumbersnotassigned.',
                 'limits':['No installedwires or pottingqualification','Spherejunctions ensure continuousallocatedvolume, not supplier bend-radiuscompliance','Intendedconnectorengagement excludedonlyatnamed endpoints; gas5mmroute retainedasobstacle']})
    if not unchanged:raise RuntimeError('Transientchambercheckchangednativegeometry')


def mate_localization():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    mate=box(m,'REMOTE_JP1_MATE',[25.528,103.2525,7.577],[60.528,108.7525,18.2])
    targets=[r for r in rows if r['component'] in ('01 Shape A housing','Carrier / removable electronics tray',
                   'Battery / FMA protected holder - owner-measured envelope')]
    tests=[test(m,v,'Installed mate exact local intersections',[mate],targets)]
    slices=[]
    for lo,hi in [(7.577,14.3),(14.3,15),(15,17),(17,18.2)]:
        q=box(m,'Z_%g_%g'%(lo,hi),[25.528,103.2525,lo],[60.528,108.7525,hi])
        slices.append(test(m,v,q['name'],[q],targets))
    # Compare two rigid pack positions and a rigid main/carrier rearward move.
    # These do not include new supports, wiring or revised screw dimensions.
    trials=[]
    for delta in ([0,0,2],[0,-4.5,0]):
        pack=[r for r in rows if r['component'].startswith('Battery /') and ('holder' in r['component'] or '18650' in r['component'])]
        shifted=[]
        for r in pack:
            q=dict(r);q['body']=v._at(m,v._world_copy(m,r['body']),delta);q['transient']=True
            q['bounds']=review.box_bounds(q['body']);shifted.append(q)
        tests.append(test(m,v,'Remote mate vs whole measured pack shift '+str(delta),[mate],shifted))
        other=[r for r in rows if r not in pack and r['component']!='01 Shape A housing']
        probes=[{'name':r['name'],'body':r['body'],'bounds':r['bounds']}for r in shifted]
        trials.append(test(m,v,'Pack rigid shift '+str(delta)+' vs other installed parts',probes,other))
        trials[-1]['excluded_housing_reason']='Existing holder supports/stops require a separately checked redesign; exclusion is not fit acceptance.'
    shift=[0,0,3.5]
    carrier=next(r for r in rows if r['component']=='Carrier / removable electronics tray')
    q={'name':'Carrier rearward3.5','body':v._at(m,v._world_copy(m,carrier['body']),shift)};q['bounds']=review.box_bounds(q['body'])
    moved_max=[]
    for r in rows:
        if r['group']=='pcb_maximum':
            p={'name':r['name']+' rearward3.5','body':v._at(m,r['body'],shift)};p['bounds']=review.box_bounds(p['body']);moved_max.append(p)
    fixed=[r for r in rows if r['group']!='pcb_maximum' and not r['name'].startswith('PCB A3 - main four-layer placement') and r['component']!='Carrier / removable electronics tray']
    fixed.append({'name':mate['name'],'component':'remote_mate','body':mate['body'],'bounds':mate['bounds'],'transient':True})
    trials.append(test(m,v,'Carrier and all fitted main maxima rearward3.5',[q]+moved_max,fixed))
    review.write('mate-localization.json',{'status':'transient_design_alternatives_only','sources':sources,'tests':tests,'intersection_Z_bands':slices,
        'trials':trials,'persistent_state_unchanged':before==snapshot(d),
        'limits':['No support or purchased pose adopted','Main comparison covers exact carrier plus all fitted source maximum envelopes; final actual-body/driver/service checks still required',
                  'Photo +/-2mm XY collar is not included in nominal mate trial; source registration uncertainty remains a fit gate',
                  'Carrier floor15..17 is the existing2mm coax return bridge; cutting it away is not automatically an acceptable relief']})


def wet_front_routes():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    b=review.helpers();import chamber_a3
    gas=capsule_route(m,'PROTECTED_5MM_GAS',[[b.mm(d,s)for s in p]for p in chamber_a3.probe_route_expressions()],5)
    obstacles=rows+[{'name':p['name'],'component':'Protectedgasallocation','body':p['body'],'bounds':p['bounds'],'transient':True}for p in gas]
    common=[[51,174,6.5],[30,174,6.5],[30,147,6.5],[30,147,27.7],[17,147,28.3],[17,132,31.5]]
    paths=[('Wet BME front-channel candidate',[[61.5,174,12.5],[51,174,12.5]]+common,2.4),
           ('Wet MD62 front-channel candidate',[[60,171.3,24],[51,174,24]]+common,2.2),
           ('Wet CO shifted header escape',[[7.2,138,22.6],[7.2,138,31.5],[17,138,31.5],[17,132,31.5]],2.4)]
    results=[]
    for name,points,diam in paths:
        q=test(m,v,name,capsule_route(m,name,points,diam),obstacles,('sealed harness feedthrough',))
        q.update(points_mm=points,diameter_mm=diam,centreline_length_mm=sum(math.dist(a,b)for a,b in zip(points,points[1:])))
        results.append(q)
    review.write('wet-front-route-candidates.json',{'status':'transient_routing_proposal','results':results,'sources':sources,
        'persistent_state_unchanged':before==snapshot(d),'limits':['Actual wire construction, sensor solder locations and strain relief unmeasured',
            'Front channel nominally uses the space between chamber floor and MD62body; native mounting feet remain obstacles',
            'Coincident common path segments are a shared route corridor, not proof two complete round bundles fit simultaneously',
            'Sphere joints provide continuous swept clearance but no specified wire bend radius']})


def wet_front_routes_refined():
    """One source-explained correction: move inward from Y175 and depart MD tips outward."""
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    b=review.helpers();import chamber_a3
    gas=capsule_route(m,'PROTECTED_5MM_GAS',[[b.mm(d,s)for s in p]for p in chamber_a3.probe_route_expressions()],5)
    obstacles=rows+[{'name':p['name'],'component':'Protectedgasallocation','body':p['body'],'bounds':p['bounds'],'transient':True}for p in gas]
    common=[[51,173.5,6.5],[30,173.5,6.5],[30,147,6.5],[30,147,27.7],[17,147,28.3],[17,132,31.5]]
    paths=[('BME four-wire approach',[[61.5,173.5,12.5],[51,173.5,12.5],[51,173.5,6.5]],2.4),
           ('MD62 three-wire approach',[[61.2,171.3,24],[61.2,173.5,24],[51,173.5,24],[51,173.5,6.5]],2.2),
           ('Shared seven-wire front corridor',common,2.4),
           ('CO four-wire approach',[[7.2,138,22.6],[7.2,138,31.5],[17,138,31.5],[17,132,31.5]],2.4)]
    results=[]
    for name,points,diam in paths:
        q=test(m,v,name,capsule_route(m,name,points,diam),obstacles,('sealed harness feedthrough',))
        q.update(points_mm=points,diameter_mm=diam,centreline_length_mm=sum(math.dist(a,b)for a,b in zip(points,points[1:])))
        results.append(q)
    review.write('wet-front-route-refined.json',{'status':'bounded_wire_allocations_checked','results':results,'sources':sources,
        'persistent_state_unchanged':before==snapshot(d),
        'packing_basis':{'individual_max_insulation_OD_mm':.8,'seven_wire_hex_pack_diameter_mm':2.4,
            'eleven_wire_4_3_4_hex_pack_diameter_mm':2*(math.hypot(1.2,math.sqrt(3)*.4)+.4),'dry_trunk_mm':3.8,
            'actual_wire_MPN_selected':False,'clearance_between_touching_insulated_wires_required':False},
        'limits':['Approaches end at explicit sensor terminal reference regions; actual solder joints/MD62 middle-lead joining and markings unmeasured',
            'Wire OD0.8mm is an engineering procurement constraint, not a claim about supplied wires',
            'The2.4mm merged path is one seven-wire bundle; do not overlay two independent round bundles',
            'Gas sealing, retention, insulation chemistry, source bend radii and channel assembly need physical validation']})


def carrier_sidebridge_trial():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    carrier=next(r for r in rows if r['component']=='Carrier / removable electronics tray')
    original=v._world_copy(m,carrier['body']);candidate=m.copy(original)
    additions=[box(m,'longitudinal 2.4mm side brace',[59.3,98.5,18.5],[61.7,111.8,20.5]),
               box(m,'upper tie 2.3mm',[57.3,109.5,18.5],[61.7,111.8,20.5])]
    removal=box(m,'retire dropped coax floor and end-wall portions',[50.1,98.89,14.9],[59.5,109.82,18.5])
    for p in additions:
        if not m.booleanOperation(candidate,m.copy(p['body']),fusion.BooleanTypes.UnionBooleanType):raise RuntimeError('Side brace union failed')
    if not m.booleanOperation(candidate,m.copy(removal['body']),fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Dropped-floor retirement failed')
    material=[]
    for name,lo,hi in [('longitudinal minimum2mm',[59.7,99,18.5],[61.7,111.7,20.5]),
                       ('upper tie minimum2mm',[57.3,109.7,18.5],[61.7,111.7,20.5])]:
        p=box(m,name,lo,hi);missing=m.copy(p['body'])
        if not m.booleanOperation(missing,m.copy(candidate),fusion.BooleanTypes.DifferenceBooleanType):raise RuntimeError('Material proof failed')
        material.append({'name':name,'bounds_mm':[lo,hi],'missing_mm3':missing.volume*1000 if missing.faces.count else 0})
    shift=[0,0,.8]
    q={'name':'Side-braced carrier rearward0.8','body':v._at(m,candidate,shift)};q['bounds']=review.box_bounds(q['body'])
    probes=[q]
    for r in rows:
        if r['group']=='pcb_maximum':
            p={'name':r['name']+' rearward0.8','body':v._at(m,r['body'],shift)};p['bounds']=review.box_bounds(p['body']);probes.append(p)
    mate=box(m,'REMOTE_MATE_WITH_2MM_XY_PHOTO_COLLAR',[23.528,101.2525,7.577],[62.528,110.7525,18.2])
    fixed=[r for r in rows if r['group']!='pcb_maximum' and not r['name'].startswith('PCB A3 - main four-layer placement') and r['component']!='Carrier / removable electronics tray']
    fixed.append({'name':mate['name'],'component':'remote_mate','body':mate['body'],'bounds':mate['bounds'],'transient':True})
    check=test(m,v,'Side-braced carrier and all fitted main maxima rearward0.8',probes,fixed)
    review.write('carrier-sidebridge-trial.json',{'status':'transient_proposal_not_adopted','sources':sources,
        'native_source_bounds_mm':carrier['bounds'],'native_source_volume_mm3':original.volume*1000,
        'candidate_bounds_mm':review.box_bounds(candidate),'candidate_volume_mm3':candidate.volume*1000,'candidate_lumps':candidate.lumps.count,
        'added_boxes':[{'name':p['name'],'bounds_mm':p['bounds']}for p in additions],
        'removed_box':{'name':removal['name'],'bounds_mm':removal['bounds']},'whole_material_witnesses':material,
        'check':check,'persistent_state_unchanged':before==snapshot(d),
        'limits':['Original M2 screws/supports remain unshifted obstacles; their revised binding/geometry requires separate proof',
            'Full actual imported PCB geometry and service/driver/cable/thickness trials still required before adoption',
            'Alternative preserves an explicit2mm connected side load path; no mechanical strength or printing qualification claimed']})


def hardware_offset_trial():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    collar=box(m,'REMOTE_MATE_XY_PLUS_MINUS2',[23.528,101.2525,7.577],[62.528,110.7525,18.2])
    actual=[r for r in rows if 'Amphenol_RF_142138' in r['name']]
    if len(actual)!=3:raise RuntimeError('Expected exact three-body J402 reconstruction')
    metal=[]
    for r in actual:
        p={'name':r['name']+' +0.8Z','body':v._at(m,v._world_copy(m,r['body']),[0,0,.8])}
        p['bounds']=review.box_bounds(p['body']);metal.append(p)
    obstacle={'name':collar['name'],'component':'remote_mate','body':collar['body'],'bounds':collar['bounds'],'transient':True}
    checks=[test(m,v,'Actual J402 metal +0.8Z vs full photo collar',metal,[obstacle]),
            test(m,v,'Full photo collar vs fixed housing',[collar],[r for r in rows if r['component']=='01 Shape A housing'])]
    screws=[r for r in rows if r['component'].startswith('M2 x 7 socket_cap screw')]
    if len(screws)!=2:raise RuntimeError('Expected two main M2x7 screws')
    stacks=[]
    for r in screws:
        for thickness in (1.44,1.6,1.76):
            dz=.8+(thickness-1.6)
            tip=r['bounds'][0][2]+dz
            insert_open=18.5;insert_bottom=15.5
            stacks.append({'screw':r['name'],'board_thickness_mm':thickness,
                'rigid_screw_deltaZ_mm':dz,'actual_tip_mm':tip,
                'nominal_M2_insert_open_face_mm':insert_open,'nominal_insert_bottom_mm':insert_bottom,
                'nominal_axial_thread_overlap_mm':max(0,insert_open-max(tip,insert_bottom)),
                'tip_above_insert_bottom_mm':tip-insert_bottom,
                'at_least_2mm_nominal_overlap':insert_open-max(tip,insert_bottom)>=2,
                'note':'Actual screw BRep tip; insert3mm axial identity from adopted TC-M2x3.0. Manufacturer CAD internal thread remains visual only.'})
    review.write('hardware-offset-trial.json',{'status':'transient_offset_evidence','sources':sources,'checks':checks,'M2x7_stacks':stacks,
        'J402_shifted_bounds_mm':[p['bounds']for p in metal],'persistent_state_unchanged':before==snapshot(d),
        'support_proposal':'Keep existing inserts fixed. Add integral0.8mm carrier bearing extensions to its2mm plate at both holes; screws follow the higher PCB seat. Not yet adopted or validated.',
        'limits':['M2 thread strength/runout and clamping remain physical tests','Housing photo collar conflict is evaluated separately; do not cut upper insert support blindly']})


def larger_wire_trial():
    app,doc,d,m,rows,v,sources=setup();before=snapshot(d)
    b=review.helpers();import chamber_a3
    gas=capsule_route(m,'PROTECTED_5MM_GAS',[[b.mm(d,s)for s in p]for p in chamber_a3.probe_route_expressions()],5)
    gasrows=[{'name':p['name'],'component':'Protectedgasallocation','body':p['body'],'bounds':p['bounds'],'transient':True}for p in gas]
    moved=[];shifted_md=[]
    for r in rows:
        q=dict(r)
        if r['component']=='Sensor / MD62 body and full-length lead references':
            q['body']=v._at(m,v._world_copy(m,r['body']),[0,0,.5]);q['bounds']=review.box_bounds(q['body']);q['transient']=True
            shifted_md.append({'name':r['name']+' +0.5Z','body':q['body'],'bounds':q['bounds']})
        moved.append(q)
    if len(shifted_md)!=5:raise RuntimeError('Expected MD62 body plus four full-length leads')
    tests=[test(m,v,'MD62 rigid +0.5Z vs other installed solids and protected gas',shifted_md,
           [r for r in rows if r['component']!='Sensor / MD62 body and full-length lead references']+gasrows)]
    routes=[('BME four-wire approach2.6',[[61.5,173,13],[51,173,13],[51,173,6.75]],2.6),
        ('MD62 three-wire approach2.4',[[61.2,171.3,24.5],[61.2,173,24.5],[51,173,24.5],[51,173,6.75]],2.4),
        ('Shared seven-wire front corridor3.0',[[51,173,6.75],[30,173,6.75],[30,133.75,6.75],[30,133.75,27.3],
                                              [17,133.75,27.3],[17,133.75,31.5],[17,132,31.5]],3.0),
        ('CO four-wire approach2.6',[[7.2,138,22.8],[7.2,138,31.5],[17,138,31.5],[17,132,31.5]],2.6),
        ('Dry eleven-wire trunk4.2',[[17,132,31.5],[17,127.5,31.5],[17,124,34],[57,124,34],[57,99,34],[57,91,34],[54.4,82.5,34]],4.2)]
    for name,points,diam in routes:
        q=test(m,v,name,capsule_route(m,name,points,diam),moved+gasrows,('sealed harness feedthrough',))
        q.update(points_mm=points,diameter_mm=diam,centreline_length_mm=sum(math.dist(a,b)for a,b in zip(points,points[1:])))
        tests.append(q)
    review.write('larger-wire-trial.json',{'status':'transient_sensor_and_wire_allocation_trial','sources':sources,'tests':tests,
        'MD62_rigid_offset_mm':[0,0,.5],'sensor_source_not_scaled':True,'persistent_state_unchanged':before==snapshot(d),
        'wire_example_only':{'OD_mm':.9,'seven_wire_hex_diameter_mm':2.7,'shared_allowance_mm':3.0,
             'eleven_wire_4_3_4_diameter_mm':2*(math.hypot(1.35,math.sqrt(3)*.45)+.45),'dry_allowance_mm':4.2,
             'MPN_selected':False},
        'limits':['Existing MD62 seats need0.5mm extension if the trial is adopted; no sensor or print geometry mutated',
            'Source OD0.9mm is illustrative minimum candidate from terminal review, not actual wire selection or a maximum assumption',
            'Complete installed JST/Harwin mates and wire-exit bends are additional obstacles not included in this routing-only test',
            'Seal annulus for4.2mm trunk in4.4mm bore is only0.1mm; no gas sealing qualification',
            'Different wires cannot occupy the common merge volume independently; it is a single reviewed seven-/eleven-wire corridor']})
