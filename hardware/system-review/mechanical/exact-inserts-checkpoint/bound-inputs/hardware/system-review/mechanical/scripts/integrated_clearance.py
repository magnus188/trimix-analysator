"""Transient maximum/allocation envelopes for the synchronized SystemReview boards.

No persistent maximum boxes are added. Source-derived maxima, generic footprint
bounds, solder allowances and unmeasured harness allocations remain distinct.
"""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, BASE, ROOT, GROUP, report, other_documents, bounds

MAIN_PREFIX='PCB A3 - main four-layer placement:'
USB_PREFIX='PCB A3 - routed USB daughterboard:'


def _manifest(require_main=True):
    manifest=json.loads((BASE/'verification/incoming-boards.json').read_text())
    _,_,d=owned()
    for key,number in [('main','TMX-A3-B01'),('usb','TMX-A3-B02')]:
        spec=manifest[key]
        for p,k in [('file','sha256'),('height_contract_file','height_contract_sha256')]:
            if hashlib.sha256(Path(spec[p]).read_bytes()).hexdigest()!=spec[k]:
                raise RuntimeError('Staged source hash changed: '+key+'/'+p)
        if key=='main':
            source_contract=json.loads(Path(spec['height_contract_file']).read_text())
            if source_contract['board_sha256']!=spec['board_sha256']:raise RuntimeError('Mainboard/heightcontract hash mismatch')
            if not require_main:continue
        wrapper=next(o for o in d.rootComponent.occurrences if o.component.partNumber==number)
        expected=(50.4,120,20.5529) if key=='main' else (34.5,18,24.945)
        translation=[v*10 for v in wrapper.transform2.translation.asArray()]
        if max(abs(a-b)for a,b in zip(translation,expected))>1e-5:raise RuntimeError('Maximumcontracts require reviewedboardregistration '+key)
        source=wrapper.component.attributes.itemByName(GROUP,'source_step_sha256')
        if not source or source.value!=spec['sha256']:raise RuntimeError('Installed STEP source differs: '+key)
    return manifest


def _box(manager, reference, low, high, group, basis):
    import verification_a3 as v
    if min(b-a for a,b in zip(low,high))<=0:raise RuntimeError('Nonpositive box '+reference)
    body=manager.createBox(core.OrientedBoundingBox3D.create(
        core.Point3D.create(*[(a+b)/20 for a,b in zip(low,high)]),
        core.Vector3D.create(1,0,0),core.Vector3D.create(0,1,0),
        *[(b-a)/10 for a,b in zip(low,high)]))
    if not body or not body.isTransient or not body.isSolid:raise RuntimeError('Invalid transient box')
    record={'uid':('MAX_'+reference,0),'body':body,'name':reference+' maximum/allocation',
            'component':'REFERENCE '+reference,'occurrence':'MAX/'+reference,'physical_group':group,
            'service_role':None,'battery_role':None,'hardware':None,'screw_axis':None,'head_seat_mm':None,
            'basis':basis,'bounds_mm':[low,high]}
    v._record_bounds(record)
    return record


def _main(manager, contract, front_shift=0):
    import board_clearance_review as old
    rows=[]
    for original in contract['rows']:
        row=dict(original)
        if row['side']=='F.Cu':
            row['Fusion_z_bottom_mm']+=front_shift;row['Fusion_z_top_mm']+=front_shift
            if not row['assembly_allowance_mm']:
                row['Fusion_z_top_mm']+=.0321
                row['CAD_extra_standoff_allowance_mm']=.0321
        elif row['side']!='B.Cu':raise RuntimeError('Unknown fitted side')
        rows.append(row)
    return old._envelopes(manager, {'rows':rows})


def _usb(manager, contract, top_shift=0):
    result=[]
    for row in contract['components']:
        ref=row['ref'];x,y,angle=row['KiCad_XY_rotation'];cx,cy=34.5+x-100,18-(y-100)
        if ref in ('U901','D901'):
            # Installed XY maxima in source already include placement rotation.
            width,height=row['purchased_installed_XY_max']
            top=row['max_plus_allowance_top_Z']+top_shift
            basis='Source package maximum plus declared0.10mm assembly allowance; installed XY already oriented.'
        elif ref=='J902':
            width,height=10.8,2.0;top=row['allowance_top_Z']+top_shift
            basis='Provisional10.8x2mm footprint/F.Fab by4.5mm harness allocation; actual wires,solder,insulation,bends and strain relief unmeasured.'
        else:raise RuntimeError('Unclassified USB contract reference '+ref)
        result.append(_box(manager,'USB_'+ref,[cx-width/2,cy-height/2,25.5+top_shift],
                           [cx+width/2,cy+height/2,top],'usb',basis))
    if len(result)!=3:raise RuntimeError('Expected3 USB allocations plus separately modeled GCT connector')
    return result


def _mate(manager, contract, front_shift=0):
    r=next(row for row in contract['rows'] if row['reference']=='J301')
    # Nominal mating centre from two-row header; pin1 centre plus1.27X,12pitches/2Y.
    angle=r['rotation_deg']%360
    if min(abs(angle),abs(angle-180),abs(angle-360))>1e-6:raise RuntimeError('Only reviewed0/180degree J301 orientations supported')
    sign=-1 if abs(angle-180)<1e-6 else 1
    cx=50.4+r['PCB_x_mm']+sign*1.27;cy=120-r['PCB_y_mm']-sign*15.24
    return _box(manager,'J301_MATED_PROVISIONAL',[cx-2.75,cy-17.5,22.1+front_shift],
                [cx+2.75,cy+17.5,34.6321+front_shift],'pcb',
                'Root-approved35x5.5x12.5mm abovePCB allowance for SamtecHTSW/IDSD mating assembly; source dimensional bounds are incomplete. Includes male header; ribbon exit follows evenrow; final180degree footprint directs itworld−X. Actual cable bend and free-end harness unmeasured; an extra0.0321mm exporter-reference allowance is added above the12.5mm box.')


def _cable(manager, contract, front_shift=0):
    source=next(r for r in contract['rows'] if r['reference']=='J301')
    if abs(source['rotation_deg']%360-180)>1e-6:raise RuntimeError('Inward cable allocation requires reviewed180degree footprint')
    mate=_mate(manager,contract,front_shift);low,high=mate['bounds_mm']
    return _box(manager,'J301_INWARD_CABLE_TURN',[low[0]-10,low[1],30.5+front_shift],
                [low[0],high[1],37.8+front_shift],'pcb',
                'Engineeringaccessallocation35mmwide,10mminward;Z30.5..34.8plus3mmrearwardturnspace. Not actualribbon geometry or supplierbendradius; entirebandshifted withboardthickness.')


def _rows():
    import review_checks as checks
    manager,records=checks.records()
    return manager,[r for r in records if r['physical_group']!='alternative_oxygen_reference']


def usb_only():
    configure();import verification_a3 as v
    from review_checks import health
    app,doc,d=owned();before=d.timeline.count;other=other_documents(app)
    manifest=_manifest(False);contract=json.loads(Path(manifest['usb']['height_contract_file']).read_text())
    manager,physical=_rows();moving=[r for r in physical if r['occurrence'].startswith(USB_PREFIX)]
    fixed=[r for r in physical if not r['occurrence'].startswith(USB_PREFIX)]
    tests=[v._test(manager,'Frozen USB actual PCB versus installed enclosure/GCT',moving,fixed,[(0,0,0)],[]),
           v._test(manager,'USB source maxima and provisional6wire allocation',_usb(manager,contract),fixed,[(0,0,0)],[])]
    if before!=d.timeline.count or other!=other_documents(app):raise RuntimeError('Source state changed')
    return report('final-usb-clearance.json',{'document':doc.name,'source':manifest['usb'],'tests':tests,
        'health':health(d),'status':'bounded_clear' if all(not t['collision_count'] for t in tests) else 'requires_correction',
        'limits':['Existing native GCT connector remains an obstacle and is not duplicated by STEP.','J902 harness is allocation only, and finished0.5..0.7mm PCB fit/printedcapture tolerance remains a physical interface hold.','Fabrication edge/annular/cutout holds remain separate.'],'source_state_preserved':True})


def mate_proposal():
    """Early mating-space test against actual enclosure and latest contract poses."""
    configure();import verification_a3 as v
    app,doc,d=owned();before=d.timeline.count;other=other_documents(app)
    path=ROOT/'hardware/system-review/electrical/component-height-contract.json'
    contract=json.loads(path.read_text());manager,physical=_rows()
    fixed=[r for r in physical if not r['occurrence'].startswith(MAIN_PREFIX)]
    maxima=[r for r in _main(manager,contract) if r['contract']['reference']!='J301']
    mate=_mate(manager,contract)
    test=v._test(manager,'Proposed J301 mated header/socket bounding allocation',[mate],fixed+maxima,[(0,0,0)],[])
    low,high=mate['bounds_mm']
    # Full side-face translational clearance probe is a geometric access slab,
    # explicitly not ribbon or bend geometry. Thin slab spans the whole box side.
    slab=_box(manager,'J301_EXIT_SIDE_ACCESS',[high[0],low[1],low[2]],
              [high[0]+.001,high[1],high[2]],'probe','0.001mm side-face slab; not cable geometry.')
    access=[]
    for shift in (0,.5,1,1.5,2,2.5,3,3.5,4):
        result=v._test(manager,'J301 sideface clearance at +X'+str(shift),[slab],fixed+maxima,[(shift,0,0)],[])
        access.append({'offset_mm':shift,'collision_count':result['collision_count'],'collisions':result['collisions']})
        if result['collision_count']:break
    if before!=d.timeline.count or other!=other_documents(app):raise RuntimeError('Source state changed')
    return report('j301-mated-clearance-proposal.json',{'document':doc.name,'contract_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'mated_bounds_mm':mate['bounds_mm'],'basis':mate['basis'],'installed_test':test,'full_sideface_access_probe':access,
        'cable_exit_world_direction':[1,0,0],'status':'mated_allocation_clear_cable_bend_unqualified' if not test['collision_count'] else 'requires_placement_review',
        'limits':['Current frozen STEP may predate Samtec header; this uses latest source contract poses plus separately provisional mating allocation.','Thin whole-side-face slab tests gross free space only; cable thickness, exit height, fold/bend radius and strain relief remain unmeasured.','No reversed socket installation is proposed; pin1/pin2orientation retained.'],'source_state_preserved':True})


def installed():
    configure();import verification_a3 as v
    import review_checks as checks
    app,doc,d=owned();before=d.timeline.count;other=other_documents(app)
    manifest=_manifest();main=json.loads(Path(manifest['main']['height_contract_file']).read_text());usb=json.loads(Path(manifest['usb']['height_contract_file']).read_text())
    manager,physical=_rows();mainfixed=[r for r in physical if not r['occurrence'].startswith(MAIN_PREFIX)]
    usbfixed=[r for r in physical if not r['occurrence'].startswith(USB_PREFIX)]
    tests=[]
    for shift in (0,.16):
        maxima=_main(manager,main,shift)
        tests.append(v._test(manager,'Main maximum/allocation bounds finished thickness'+str(1.6+shift),maxima,mainfixed,[(0,0,0)],[]))
        tests.append(v._test(manager,'J301 provisional mate finished thickness'+str(1.6+shift),[_mate(manager,main,shift)],mainfixed+[r for r in maxima if r['contract']['reference']!='J301'],[(0,0,0)],[]))
        tests.append(v._test(manager,'J301 inward cable/turn allocation finished thickness'+str(1.6+shift),[_cable(manager,main,shift)],mainfixed+[r for r in maxima if r['contract']['reference']!='J301'],[(0,0,0)],[]))
    unplug_fixed=[r for r in mainfixed if r['physical_group']!='rear_cover']
    unplug_fixed += [r for r in _main(manager,main,.16) if r['contract']['reference']!='J301']
    tests.append(v._test(manager,'J301 provisionalsocket axial6.1mm disengagement atmaximumPCBthickness',[_mate(manager,main,.16)],unplug_fixed,[(0,0,0),(0,0,6.1)],['Rearcoverandscrewsremoved;releasecableslack;fixedJ301maleheaderisintendedmatinginterfaceexcluded. No realfingergrip oractualcablebendqualification.']))
    tests.append(v._test(manager,'USB maxima and unmeasured harness allocation',_usb(manager,usb),usbfixed,[(0,0,0)],[]))
    import board_clearance_review as old
    tails=[r for r in old._coax_tolerance(manager,main) if '_UPPER' not in r['contract']['reference']]
    tests.append(v._test(manager,'J402 supplemental drawing-tolerance tails',tails,mainfixed,[(0,0,0)],[]))
    actual=checks.collision_report(manager,physical);feature_health=checks.health(d)
    if before!=d.timeline.count or other!=other_documents(app):raise RuntimeError('Source state changed')
    return report('final-integrated-clearance.json',{'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,
        'source_manifest':manifest,'status':'bounded_geometry_clear' if not actual['collisions'] and all(not t['collision_count'] for t in tests) and feature_health['pass'] else 'requires_correction',
        'physical_solid_count':len(physical),'health':feature_health,'actual_cross_assembly':actual,'tests':tests,
        'main_contract_rows':len(main['rows']),'main_populated_envelopes':sum(not r['DNP'] for r in main['rows']),
        'main_backside_references':[r['reference'] for r in main['rows'] if not r['DNP'] and r['side']=='B.Cu'],
        'source_state_preserved':True,'geometry_scaled':False,'limits':[
            'Finished main PCB allocation1.6mm/backseatZ20.5 is distinct from actual detailed STEP layer sum1.5642mm. Imported copper/datums recorded separately; no invented physical mask.','Main maximum1.76mm thickness moves front-side bounds+0.16, back-side allocations stay registered to fixedbackseat20.5. GenericSTEPcomponentbases include~0.0321mm beyond nominal faces, inside declared0.15mm assembly allowance.','Maincontractincludesexactmaximaandprovisionalbody/wireallocations; no physical purchased fit release.','MatedJ30135x5.5x12.5mm box is provisional; actual ribbon exit bend and ownedSMBelbow absent.','USB0.5..0.7 finishedthickness captureandGCTfabedge/cutout/annular tolerancequalification remainopen.','No globalminimumwall,threadstrength,seal,gasresponseorassemblyloadclaim.']})


def _adapter(include_mate=False):
    configure();import verification_a3 as v
    manifest=_manifest();main=json.loads(Path(manifest['main']['height_contract_file']).read_text());usb=json.loads(Path(manifest['usb']['height_contract_file']).read_text())
    original=v._records
    def adapted(d,manager):
        records=original(d,manager)
        records=[r for r in records if r['physical_group']!='alternative_oxygen_reference']
        for row in records:
            if row['occurrence'].startswith(MAIN_PREFIX):row['physical_group']='pcb'
            elif row['occurrence'].startswith(USB_PREFIX):row['physical_group']='usb'
        # Contract envelopes move with source assemblies. Mate is unplugged for
        # carrier withdrawal; its installed envelope remains for other paths.
        return records+_main(manager,main,.16)+_usb(manager,usb)+([_mate(manager,main,.16),_cable(manager,main,.16)] if include_mate else [])
    v._records=adapted
    return v,original


def paths():
    v,original=_adapter();old=v.OUTPUT;v.OUTPUT=BASE/'verification/final-max-envelopes';v.OUTPUT.mkdir(parents=True,exist_ok=True)
    try:return v.audit_paths()
    finally:v._records=original;v.OUTPUT=old


def drivers():
    v,original=_adapter(True);old=v.OUTPUT;v.OUTPUT=BASE/'verification/final-max-envelopes';v.OUTPUT.mkdir(parents=True,exist_ok=True)
    try:return v.audit_drivers()
    finally:v._records=original;v.OUTPUT=old


def mate_rotation_proposal():
    """Compare wiring exit directions without rotating any persistent footprint.

    Whole-side-face volumes deliberately overbound the unknown exit height. A
    separately labeled elevated clearance band explores, but does not qualify,
    the drawing's near-cap cable exit and an extra3mm rearward turn volume.
    """
    configure();import verification_a3 as v
    app,doc,d=owned();before=d.timeline.count;other=other_documents(app)
    path=ROOT/'hardware/system-review/electrical/component-height-contract.json';contract=json.loads(path.read_text())
    manager,physical=_rows();fixed=[r for r in physical if not r['occurrence'].startswith(MAIN_PREFIX)]
    fixed += [r for r in _main(manager,contract,.16) if r['contract']['reference']!='J301']
    mate=_mate(manager,contract,.16);low,high=mate['bounds_mm'];tests=[]
    for direction in (1,-1):
        face=high[0] if direction==1 else low[0]
        for length in (5,10):
            xmin,xmax=sorted((face,face+direction*length))
            full=_box(manager,'J301_'+str(direction)+'_FULL_SIDE_'+str(length),
                      [xmin,low[1],low[2]],[xmax,high[1],high[2]],'probe','Full side-face extrusion; overbounds unknown cable exit and is not a physical harness.')
            tests.append(v._test(manager,'Exit'+str(direction)+' length'+str(length)+' full side-face',[full],fixed,[(0,0,0)],[]))
            # SourceSectionA-A dimension.093in is cap-top-to-cable underside;
            # nominal mate2.54+9.27−2.3622=9.4478 abovePCB. Exact cable
            # thickness/exit tol and minimum bend radius are not dimensioned.
            # Use a deliberately broader diagnostic bandZ30.5..34.8, then3mm
            # rearward space. This is an allocation, not a sourced cable model.
            elevated=_box(manager,'J301_'+str(direction)+'_ELEVATED_TURN_'+str(length),
                           [xmin,low[1],30.5],[xmax,high[1],37.8],'probe',
                           'Provisional full35mm ribbon-width access bandZ30.5..34.8 plus3mm rearwardturn volume; includesnominaldrawingcableundersideZ31.5478, but actualinsulation/exitdatum/bendradius unmeasured.')
            tests.append(v._test(manager,'Exit'+str(direction)+' length'+str(length)+' elevated band plus3mm rearward turn',[elevated],fixed,[(0,0,0)],[]))
    if before!=d.timeline.count or other!=other_documents(app):raise RuntimeError('Proposal test changed source')
    src=next(r for r in contract['rows'] if r['reference']=='J301')
    proposed={'PCB_reference_origin_mm':[src['PCB_x_mm']+2.54,src['PCB_y_mm']+30.48],
              'rotation_deg':180,'world_connector_centre_unchanged_mm':[(low[0]+high[0])/2,(low[1]+high[1])/2],
              'same_numbered_pins_rotate_with_footprint':True,'cable_exit_world_direction':[-1,0,0]}
    return report('j301-rotation-clearance-proposal.json',{'document':doc.name,'contract_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'proposed_180_degree_footprint':proposed,'actual_CAD_or_PCB_rotation_applied':False,'tests':tests,
        'source_section':'SamtecIDSX RevAE sheet1 SectionA-A .093in cap-top-to-cable underside; nominalbody9.27 plusheader2.54. Readingneedsvendor/physicalconfirmation; no source minimum bend radius supplied.',
        'diagnostic_elevated_band_Z_mm':[30.5,34.8],'additional_rearward_turn_allowance_mm':3,
        'status':'proposal_comparison_only','limits':['Full-face tests intentionally includeemptyspacebelowtheactualcable and can collidewithboardparts withoutdisprovingtheactualroute.','Elevatedbandclearance indicatesavailableallocation only; no actualwirethickness/radius/strainrelief orconnectorseating qualification.','RotationmustbeapprovedbyPCBowner andupdatedpin1silkscreen/netrouting; neverrotatea socketonunchangedpins.'],'source_state_preserved':True})


def thickness_drivers():
    """Nominal Ø5x50mm shafts at both main-board thickness-limit screw seats."""
    configure();import verification_a3 as v
    app,doc,d=owned();before=d.timeline.count;other=other_documents(app)
    manifest=_manifest();contract=json.loads(Path(manifest['main']['height_contract_file']).read_text())
    manager,physical=_rows();g=v._groups(physical)
    screws=[r for r in physical if r['hardware'] and r['hardware']['kind']=='screw' and r['physical_group']=='pcb']
    if len(screws)!=2:raise RuntimeError('Expected2mainM2screws')
    maximum=_main(manager,contract,.16)+[_mate(manager,contract,.16),_cable(manager,contract,.16)]
    tests=[]
    for screw in screws:
        if screw['hardware']['size']!='M2' or abs(screw['head_seat_mm'][2]-22.1)>.001:raise RuntimeError('UnexpectednominalmainM2pose')
        if max(abs(a-b)for a,b in zip(screw['screw_axis'],(0,0,1)))>1e-6:raise RuntimeError('Unexpecteddriveraxis')
        for thickness in (1.44,1.76):
            seat=screw['head_seat_mm'][:];seat[2]=20.5+thickness
            start=seat[:];start[2]+=screw['hardware']['head_height_mm']+.05
            end=start[:];end[2]+=50
            body=manager.createCylinderOrCone(core.Point3D.create(*(x/10 for x in start)),.25,
                                               core.Point3D.create(*(x/10 for x in end)),.25)
            if not body or not body.isTransient:raise RuntimeError('Nodriverprobe')
            probe=dict(screw,body=body,uid=('THICKNESS_DRIVER_'+screw['occurrence']+'_'+str(thickness),0),
                       name='Thickness'+str(thickness)+' Ø5nominaldriver',occurrence='REFERENCEdriver/'+screw['occurrence'])
            probe.pop('bounds_cm',None);v._record_bounds(probe)
            fixed=v._without(physical,g['rear_cover'],g['rear_cover_screws'],g['mate'],[screw])+maximum
            test=v._test(manager,'MainM2driver '+screw['occurrence']+' thickness'+str(thickness),[probe],fixed,[(0,0,0)],
                         ['Rearcoverremoved,batterydisconnected;allotheractualassembliesandmaximumcomponent/cableallocationsremaininstalled.'])
            test.update(finished_board_thickness_mm=thickness,hypothetical_underhead_mm=seat,
                        shaft_start_mm=start,shaft_diameter_mm=5,shaft_length_mm=50)
            tests.append(test)
    if before!=d.timeline.count or other!=other_documents(app):raise RuntimeError('Drivercheckchangedsource')
    return report('board-thickness-drivers.json',{'document':doc.name,'source_manifest':manifest,'tests':tests,
        'status':'selected_driver_shafts_clear' if all(not t['collision_count'] for t in tests) else 'requires_review',
        'source_state_preserved':True,'limits':['Fourposesonly;nominalshaftgeometry,nohandle/finger/reachqualification.','AllFcomponentmaximumtopssimultaneouslyraised0.16mmforconservativeobstacles.Bsidefixedbackseat.','Hypotheticalseatedscrewtransformsarenotpersistent;physicalclamping/torqueremainsunqualified.']})
