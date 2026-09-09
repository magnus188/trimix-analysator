"""Native parametric PrintReview refinements; explicit serial stages only."""
import json, math
import adsk.core as core, adsk.fusion as fusion
import build_a3 as b
import print_runtime as rt
import usb_a3 as usb
import chamber_a3 as ch

def _once(c,key):
    if c.attributes.itemByName('TrimixPrintReview',key):raise RuntimeError('Already applied '+key)

def cover_leadins():
    _,d=rt.owned();c=b.comp('02 Single rear cover');_once(c,'locating_leadins')
    body=c.bRepBodies.item(0);z=b.mm(d,'CaseDepth-Cover-2 mm')/10
    xs=[b.mm(d,e)/10 for e in ('Wall+0.25 mm','CaseWidth-Wall-2.25 mm')]
    ys=[5.5,9.8];selected=core.ObjectCollection.create();locations=[]
    for edge in body.edges:
        bb=edge.boundingBox
        if abs(bb.minPoint.z-z)>1e-6 or abs(bb.maxPoint.z-z)>1e-6:continue
        if any(bb.minPoint.x>=x-1e-6 and bb.maxPoint.x<=x+.2+1e-6 and
               bb.minPoint.y>=y-1e-6 and bb.maxPoint.y<=y+1.2+1e-6 for x in xs for y in ys):
            selected.add(edge);locations.append([[v*10 for v in (bb.minPoint.x,bb.minPoint.y,bb.minPoint.z)],[v*10 for v in (bb.maxPoint.x,bb.maxPoint.y,bb.maxPoint.z)]])
    if selected.count!=16:raise RuntimeError('Expected four rectangular tab ends; got '+str(selected.count))
    req=c.features.chamferFeatures.createInput2()
    req.chamferEdgeSets.addEqualDistanceChamferEdgeSet(selected,core.ValueInput.createByString('0.30 mm'),False)
    f=c.features.chamferFeatures.add(req);f.name='PrintReview four rear locating tab lead-ins 0.30mm'
    if not d.computeAll() or f.healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState:raise RuntimeError('Lead-in chamfer unhealthy')
    c.attributes.add('TrimixPrintReview','locating_leadins','Four0.30mm x45degree tab-entry chamfers;2mm structural core;1.4mm nose is intentional non-loadbearing guide interface')
    rt.save_report('cover-leadins.json',{'part_id':'TMX-A3-P02','entry_chamfer_mm':.3,'tab_count':4,
      'selected_edges':locations,'core_thickness_mm':2,'tip_width_mm':1.4,'exception':'Insertion guide nose only; structural tab core retained at2mm','timeline_count':d.timeline.count})
    b.checkpoint('PrintReview four rear-cover locating lead-ins')

def usb_printed():
    _,d=rt.owned()
    bezel=b.comp(usb.NAMES['bezel']);bridge=b.comp(usb.NAMES['bridge'])
    _once(bezel,'printed_mount')
    bb=bezel.bRepBodies.item(0);rb=bridge.bRepBodies.item(0)
    # Remove the sub-layer metal sealing lips. This printed clearance throat
    # clears the purchased gasket; sealing is explicitly not established.
    usb._rounded(bezel,'PrintReview clean printable USB clearance throat','-.05 mm','1.90 mm',9.9,4.1,1.60,'cut',bb)
    # Top bridge lip grows inward/upward within the former reserved cartridge
    # envelope; preserve hidden M2 seats and nominal flange contact.
    b.box(bridge,'PrintReview PETG capture lip reinforcement','UsbX-10 mm','3.6 mm','UsbZ+6 mm',
          '20 mm','2.8 mm','2 mm','join',rb)
    for c in (bezel,bridge):
        c.attributes.add('TrimixPrintReview','printed_mount','true')
        c.attributes.add(b.GROUP,'purchased','false')
        c.attributes.add(b.GROUP,'geometry_role','printed_prototype')
        c.attributes.add(b.GROUP,'material_target','PETG; PLA dry fit prototype')
    bezel.description='Printed PETG USB bezel; clean 9.9 x4.1 clearance opening, 1.8 mm local panel exception; no gasket compression/IP claim.'
    bridge.description='Printed PETG concealed USB retaining bridge; strengthened2mm capture lip; physical insertion-load test pending.'
    bezel.attributes.add(b.GROUP,'seal_limits','Metal micro-lips removed. Printed clearance mouth9.9x4.1 R1.6; local1.8mm panel is an explicit interface exception. GCT gasket not compressed; weather sealing unqualified.')
    b.checkpoint('PrintReview printable USB mount and 2mm capture lip')

def thread_probe():
    rt.owned();q=fusion.ThreadDataQuery.create(False);kind=q.defaultMetricThreadType
    info={'type':kind,'designations':q.allDesignations(kind,'16.0')}
    if not info['designations']:info['sizes']=q.allSizes(kind)
    info['classes_internal']=q.allClasses(True,kind,'M16x1')
    rt.save_report('thread-catalog.json',info)

def thread_adapter():
    _,d=rt.owned();adapter=b.comp(ch.ADAPTER);sensor=b.comp(ch.AO2)
    _once(adapter,'modeled_thread')
    def cylinder(component,radius):
        faces=[]
        for f in component.bRepBodies.item(0).faces:
            cy=core.Cylinder.cast(f.geometry)
            if cy and abs(cy.radius*10-radius)<1e-4:faces.append(f)
        if len(faces)!=1:raise RuntimeError('Ambiguous thread cylinder '+component.name+':'+str(len(faces)))
        return faces[0]
    query=fusion.ThreadDataQuery.create(False);kind=query.defaultMetricThreadType
    designations=query.allDesignations(kind,'16.0')
    designation=next((x for x in designations if x.replace(' ','').lower()=='m16x1'),None)
    if not designation:raise RuntimeError('M16x1 missing: '+repr(designations))
    inf=fusion.ThreadInfo.create(False,True,kind,designation,'6H',True)
    req=adapter.features.threadFeatures.createInput(cylinder(adapter,8.1),inf)
    req.isModeled=True;req.isFullLength=True
    f=adapter.features.threadFeatures.add(req);f.name='PrintReview modeled M16x1-6H female thread'
    # Model the nominal manufacturer's external thread too, instead of treating
    # its full major-diameter reference cylinder as physical mating material.
    ext=fusion.ThreadInfo.create(False,False,kind,designation,'6g',True)
    req=sensor.features.threadFeatures.createInput(cylinder(sensor,8),ext)
    req.isModeled=True;req.isFullLength=False
    req.threadLength=core.ValueInput.createByString('6.3 mm')
    req.threadOffset=core.ValueInput.createByString('0.2 mm')
    req.threadLocation=fusion.ThreadLocations.HighEndThreadLocation
    f=sensor.features.threadFeatures.add(req);f.name='AO2 nominal modeled mating thread; supplier fit unverified'
    adapter.attributes.add('TrimixPrintReview','modeled_thread','M16x1-6H RH modeled; coupon/actual sensor fit pending')
    adapter.attributes.add(b.GROUP,'thread','M16x1-6H modeled; PETG prototype, actual fit and face seal pending')
    adapter.attributes.add(b.GROUP,'material_target','PETG; test coupon before hand-tight installation')
    adapter.attributes.add(b.GROUP,'geometry_role','printed_prototype')
    adapter.description='PETG AO2 M16x1-6H adapter. Nominal thread only; hand-tight fit coupon and actual face seal remain unverified.'
    sensor.attributes.add(b.GROUP,'thread','Nominal M16x1-6g modeled for mating CAD; manufacturer class/phase not measured')
    b.checkpoint('PrintReview modeled AO2 mating threads')

def gas_open_return():
    _,d=rt.owned();c=b.comp(ch.BODY);_once(c,'open_return');body=c.bRepBodies.item(0)
    b.box(c,'PrintReview rear return open to removable lid','5 mm','CaseHeight-34.6 mm','33.5 mm',
          '5 mm','17.2 mm','CaseDepth-40.4 mm','cut',body)
    c.attributes.add('TrimixPrintReview','open_return','5 mm return channel open beneath removable lid; no trapped support; seal land prototype')
    b.checkpoint('PrintReview rear return accessible beneath chamber lid')

def _roof(c,name,axis,start,length,lateral,cz,radius,operation,target):
    from fusion_helpers import _axis_sketch,_positioned_point,extrude_axis
    sk,mapping=_axis_sketch(c,name+' sketch',axis,start)
    lateral_axis='y' if axis=='x' else 'x'
    dy=f'({radius})/sqrt(2)'
    locations=[{lateral_axis:f'({lateral})-({dy})','z':f'({cz})+({dy})'},
               {lateral_axis:f'({lateral})+({dy})','z':f'({cz})+({dy})'},
               {lateral_axis:lateral,'z':f'({cz})+sqrt(2)*({radius})'}]
    pts=[]
    for index,location in enumerate(locations):
        values=[location[a] if sign>0 else '-('+location[a]+')' for a,sign in mapping]
        # Initially separate points well beyond inference distance, then drive
        # them to expression coordinates. This avoids automatic point merging.
        from fusion_helpers import evaluate_cm,_dimension
        x,y=[evaluate_cm(c,v) for v in values]
        point=sk.sketchPoints.add(core.Point3D.create((30+index)*(1 if x>=0 else -1),(40+index)*(1 if y>=0 else -1),0))
        _dimension(sk,sk.originPoint,point,fusion.DimensionOrientations.HorizontalDimensionOrientation,
                   values[0] if x>=0 else '-('+values[0]+')',x/2,y-.5)
        _dimension(sk,sk.originPoint,point,fusion.DimensionOrientations.VerticalDimensionOrientation,
                   values[1] if y>=0 else '-('+values[1]+')',x-.5,y/2)
        pts.append(point)
    for p,q in zip(pts,pts[1:]+pts[:1]):sk.sketchCurves.sketchLines.addByTwoPoints(p,q)
    if not sk.isFullyConstrained:raise RuntimeError('Roof sketch unconstrained')
    f=extrude_axis(c,sk,length,name,axis,operation,[target] if operation=='cut' else None)
    return f.bodies.item(0)

def _corner_roof(c,name,x,y,z,radius,op):
    from fusion_helpers import circle_xy
    a=circle_xy(c,name+' base',x,y,f'({radius})/sqrt(2)+0.01 mm',f'({z})+({radius})/sqrt(2)-0.01 mm')
    ztop=f'({z})+sqrt(2)*({radius})-0.05 mm'
    top=circle_xy(c,name+' tiny printable crest',x,y,'0.05 mm',ztop)
    req=c.features.loftFeatures.createInput(fusion.FeatureOperations.JoinFeatureOperation if op=='join' else fusion.FeatureOperations.CutFeatureOperation)
    req.loftSections.add(a.profiles.item(0));req.loftSections.add(top.profiles.item(0))
    f=c.features.loftFeatures.add(req);f.name=name
    a.isLightBulbOn=False;top.isLightBulbOn=False
    return f.bodies.item(0)

def gas_roofs():
    _,d=rt.owned();c=b.comp(ch.BODY);_once(c,'gas_roofs');target=c.bRepBodies.item(0)
    paths=[('main inlet','x','CaseWidth-14.25 mm','11.25 mm','GasY'),
           ('inlet rise','y','GasY','2.5 mm','CaseWidth-14.25 mm'),
           ('upper turn','x','CaseWidth-20.1 mm','5.85 mm','CaseHeight-15 mm')]
    # Add outer roofs first. Each planar roof face is 45 degrees; corresponding
    # inner faces are offset by the original 2 mm radial wall.
    for label,axis,start,length,centre in paths:
        target=_roof(c,'PrintReview '+label+' outer support roof',axis,start,length,centre,'GasZ','4.5 mm','join',target)
    for yy in ('GasY','CaseHeight-15 mm'):
        target=_corner_roof(c,'PrintReview elbow outer self-support roof','CaseWidth-14.25 mm',yy,'GasZ','4.5 mm','join')
    for label,axis,start,length,centre in paths:
        target=_roof(c,'PrintReview '+label+' internal 45 degree roof',axis,start,length,centre,'GasZ','2.5 mm','cut',target)
    for yy in ('GasY','CaseHeight-15 mm'):
        target=_corner_roof(c,'PrintReview elbow internal self-support roof','CaseWidth-14.25 mm',yy,'GasZ','2.5 mm','cut')
    target=_roof(c,'PrintReview exhaust wall internal 45 degree roof','x','2.9 mm','4.7 mm','GasY','GasZ','2.5 mm','cut',target)
    c.attributes.add('TrimixPrintReview','gas_roofs','Support-free45degree inlet/exhaust crowns preserving inscribed5mmcircle. Rear return open beneath lid; internal supports prohibited. Slice/coupon qualification pending.')
    b.checkpoint('PrintReview support-free gas roofs with nominal2mm inlet walls')

def clean_incomplete_roof():
    rt.owned();c=b.comp(ch.BODY)
    sk=next((s for s in c.sketches if s.name=='PrintReview main inlet outer support roof sketch'),None)
    if sk:
        if any(f.name=='PrintReview main inlet outer support roof' for f in c.features):raise RuntimeError('Roof already has a feature')
        plane=sk.referencePlane
        sk.deleteMe()
        if plane and plane.isValid:plane.deleteMe()
    print('Removed only incomplete first roof sketch')

def thread_phase_probe():
    _,d=rt.owned();adapter=b.comp(ch.ADAPTER);sensor=b.comp(ch.AO2)
    manager=fusion.TemporaryBRepManager.get();fixed=adapter.bRepBodies.item(0);moving=sensor.bRepBodies.item(0)
    center=core.Point3D.create(0,b.mm(d,'CaseHeight-37.5 mm')/10,2.175)
    values=[]
    for angle in range(0,360,5):
        target=manager.copy(fixed);tool=manager.copy(moving)
        mat=core.Matrix3D.create();mat.setToRotation(math.radians(angle),core.Vector3D.create(1,0,0),center)
        manager.transform(tool,mat)
        ok=manager.booleanOperation(target,tool,fusion.BooleanTypes.IntersectionBooleanType)
        values.append({'degrees':angle,'volume_mm3':target.volume*1000 if ok else 0})
    rt.save_report('thread-phase-probe.json',{'best':min(values,key=lambda x:x['volume_mm3']),'samples':values})

def thread_phase_apply():
    _,d=rt.owned();sensor=b.comp(ch.AO2)
    _once(sensor,'thread_phase')
    samples=json.loads((rt.BASE/'verification/thread-phase-probe.json').read_text())['samples']
    probe=min(samples,key=lambda x:(x['volume_mm3'],abs(x['degrees']-180)))
    if probe['volume_mm3']>1e-5:raise RuntimeError('No collision-free nominal thread phase')
    face=next(f for f in sensor.bRepBodies.item(0).faces if core.Cylinder.cast(f.geometry) and abs(core.Cylinder.cast(f.geometry).radius-1.465)<1e-6)
    # Use a fully constrained expression-driven sketch axis. A linear sketch
    # entity is accepted by Move without relying on circular-face axis inference.
    from fusion_helpers import _xy_sketch,_positioned_point,_dimension
    sk=_xy_sketch(sensor,'AO2 rotation centreline','21.75 mm')
    p=_positioned_point(sensor,sk,'0 mm','CaseHeight-37.5 mm')
    line=sk.sketchCurves.sketchLines.addByTwoPoints(p,core.Point3D.create(1,p.geometry.y,0))
    sk.geometricConstraints.addHorizontal(line)
    _dimension(sk,line.startSketchPoint,line.endSketchPoint,fusion.DimensionOrientations.HorizontalDimensionOrientation,'10 mm',.5,p.geometry.y+.5)
    if not sk.isFullyConstrained:raise RuntimeError('Thread rotation axis unconstrained')
    angle=probe['degrees']
    occ=next(o for o in d.rootComponent.occurrences if o.component.id==sensor.id)
    objects=core.ObjectCollection.create();objects.add(sensor.bRepBodies.item(0).createForAssemblyContext(occ))
    inp=d.rootComponent.features.moveFeatures.createInput2(objects)
    if not inp.defineAsRotate(line.createForAssemblyContext(occ),core.ValueInput.createByString(str(angle)+' deg')):raise RuntimeError('Cannot define thread rotation')
    f=d.rootComponent.features.moveFeatures.add(inp);f.name='AO2 nominal thread phase aligned for mating CAD'
    sk.isLightBulbOn=False
    sensor.attributes.add('TrimixPrintReview','thread_phase',json.dumps(probe))
    b.checkpoint('PrintReview nominal O2 thread phase alignment')

def thread_phase_root_move():
    _,d=rt.owned();sensor=b.comp(ch.AO2);_once(sensor,'thread_phase')
    occ=next(o for o in d.rootComponent.occurrences if o.component.id==sensor.id)
    sk=next(s for s in sensor.sketches if s.name=='AO2 rotation centreline')
    line=sk.sketchCurves.sketchLines.item(0).createForAssemblyContext(occ)
    objects=core.ObjectCollection.create();objects.add(sensor.bRepBodies.item(0).createForAssemblyContext(occ))
    inp=d.rootComponent.features.moveFeatures.createInput2(objects)
    if not inp.defineAsRotate(line,core.ValueInput.createByString('180 deg')):raise RuntimeError('Cannot define root-context rotation')
    f=d.rootComponent.features.moveFeatures.add(inp);f.name='AO2 nominal thread phase aligned 180deg about parametric axis'
    sk.isLightBulbOn=False
    sensor.attributes.add('TrimixPrintReview','thread_phase','180deg nominal phase; actual sensor alignment unmeasured')
    b.checkpoint('PrintReview root-context nominal O2 thread phase')
