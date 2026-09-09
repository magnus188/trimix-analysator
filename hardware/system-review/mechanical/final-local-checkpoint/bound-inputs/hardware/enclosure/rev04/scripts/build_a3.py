"""Shape A / Revision04 parametric enclosure. Explicitly staged, no import mutation.

Millimetres: +X viewer's left, +Y up, +Z rearwards. Owned A3 documents only.
"""
from pathlib import Path
import json,sys
import adsk.core as core
import adsk.fusion as fusion
BASE=Path(__file__).resolve().parents[1]
HELPERS=BASE.parent/'scripts'
if str(HELPERS) not in sys.path:sys.path.insert(0,str(HELPERS))
from fusion_helpers import (new_component,rectangle_xy,circle_xy,rectangle_yz,
    circle_yz,rectangle_xz,circle_xz,extrude,extrude_axis)
NAME='Trimix_Enclosure_A3'; GROUP='TrimixRev04'
FOLDER_ID='urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'
PARAMS=[
 ('CaseWidth','85 mm','Accepted maximum starting width; test narrower packaging'),
 ('CaseHeight','180 mm','Taller top sampling pod accepted for a slimmer grip'),
 ('CaseDepth','43 mm','Body including flush rear screw heads'),
 ('Wall','2.4 mm','Nominal printed structural wall, selected sections minimum2mm'),
 ('RearInset','0.25 mm','Small rearward taper per side; Shape A straight-sided intent'),
 ('CornerRadius','8 mm','Restrained Shape A outline rounds'),
 ('Cover','2.4 mm','Single rear cover nominal thickness'),
 ('CoverGap','0.2 mm','Assembly gap, not a qualified weather seal'),
 ('DisplayWidth','69.3 mm','Owner measured retained factory casing'),
 ('DisplayHeight','116.8 mm','Owner measured retained factory casing'),
 ('DisplayDepth','13.7 mm','Owner measured with factory back removed'),
 ('DisplayX','(CaseWidth-DisplayWidth)/2','Purchased assembly remains centred'),
 ('DisplayY','5.2 mm','Fixed lower front border'),
 ('DisplayFront','0.4 mm','Front recess'),
 ('DisplayFit','0.4 mm','Provisional fit clearance per side'),
 ('GlassWidth','66.8 mm','Manufacturer drawing reference'),
 ('GlassHeight','114.4 mm','Manufacturer drawing reference'),
 ('ActiveWidth','56.16 mm','Manufacturer active-area reference'),
 ('ActiveHeight','93.60 mm','Manufacturer active-area reference'),
 ('HolderWidth','42 mm','Owner measured occupied protected FMA holder'),
 ('HolderHeight','80.4 mm','Owner measured occupied protected FMA holder'),
 ('HolderDepth','20.35 mm','Owner measured occupied protected FMA holder'),
 ('HolderX','5.4 mm','Right-hand rear battery bay'),
 ('HolderY','27 mm','Clear bottom USB cartridge and cable region'),
 ('HolderZ','16.5 mm','2.4mm beyond maximum purchased display depth'),
 ('PcbX','50.4 mm','PCB strip beside holder; no stack behind battery'),
 ('PcbY','21 mm','Low end of PCB strip'),
 ('PcbWidth','CaseWidth-PcbX-4.6 mm','Future PCB allocation; routed fit pending'),
 ('PcbHeight','99 mm','Future PCB strip height before button notch'),
 ('PcbZ','20.5 mm','PCB front plane; carrier and support below'),
 ('ButtonY','113 mm','Viewer-left button above pack; PCB notch'),
 ('ButtonZ','31 mm','Unmeasured button assembly depth centre'),
 ('UsbX','CaseWidth/2','Centred bottom USB socket'),
 ('UsbZ','26 mm','Bottom USB socket depth centre'),
 ('GasY','CaseHeight-17.5 mm','Upper opposed sample ports clear the internal return web'),
 ('GasZ','22 mm','Sample port depth centre'),
]

def inspect():
    app=core.Application.get();d=fusion.Design.cast(app.activeProduct)
    print(json.dumps({'open_documents':[{'name':x.name,'modified':x.isModified} for x in app.documents],
      'active':app.activeDocument.name if app.activeDocument else None,
      'folder':{'name':app.data.activeFolder.name,'id':app.data.activeFolder.id} if app.data.activeFolder else None,
      'timeline':d.timeline.count if d else None,'units':d.unitsManager.defaultLengthUnits if d else None,
      'components':[o.component.name for o in d.rootComponent.occurrences] if d else []}))

def get():
    app=core.Application.get();d=fusion.Design.cast(app.activeProduct)
    if not d or not d.rootComponent.attributes.itemByName(GROUP,'owned'):
        raise RuntimeError('Active document is not the owned A3 design; preserve other documents')
    return app,d

def mm(d,expression):return d.unitsManager.evaluateExpression(expression,'mm')*10
def comp(name):
    _,d=get()
    return next(o.component for o in d.rootComponent.occurrences if o.component.name==name)
def new(name,status='Designed concept; physical qualification pending'):
    _,d=get()
    if any(o.component.name==name for o in d.rootComponent.occurrences):raise RuntimeError('Already exists: '+name)
    c=new_component(d.rootComponent,name);c.attributes.add(GROUP,'model_basis',status)
    c.isOriginFolderLightBulbOn=False
    return c
def box(c,name,x,y,z,w,h,t,op='new',target=None):
    sk=rectangle_xy(c,name+' sketch',x,y,w,h,z)
    f=extrude(c,sk,t,name,op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def cyl(c,name,x,y,z,r,t,op='new',target=None):
    sk=circle_xy(c,name+' sketch',x,y,r,z)
    f=extrude(c,sk,t,name,op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def xbox(c,name,x,y,z,w,h,t,op='new',target=None):
    sk=rectangle_yz(c,name+' sketch',y,z,h,t,x)
    f=extrude_axis(c,sk,w,name,'x',op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def xcyl(c,name,x,y,z,r,t,op='new',target=None):
    sk=circle_yz(c,name+' sketch',y,z,r,x)
    f=extrude_axis(c,sk,t,name,'x',op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def ybox(c,name,x,y,z,w,h,t,op='new',target=None):
    sk=rectangle_xz(c,name+' sketch',x,z,w,t,y)
    f=extrude_axis(c,sk,h,name,'y',op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def ycyl(c,name,x,y,z,r,t,op='new',target=None):
    sk=circle_xz(c,name+' sketch',x,z,r,y)
    f=extrude_axis(c,sk,t,name,'y',op,[target] if target and op=="cut" else None)
    if op=='new':f.bodies.item(0).name=name
    return f.bodies.item(0)
def fillet_long(c,body,radius,name,min_span=1.0,select=None):
    edges=core.ObjectCollection.create()
    for e in body.edges:
        if not e.startVertex or not e.endVertex:continue
        p,q=e.startVertex.geometry,e.endVertex.geometry
        if abs(p.z-q.z)>min_span and (select is None or select(p,q)):edges.add(e)
    if not edges.count:raise RuntimeError('No edges for '+name)
    inp=c.features.filletFeatures.createInput()
    inp.edgeSetInputs.addConstantRadiusEdgeSet(edges,core.ValueInput.createByString(radius),False)
    f=c.features.filletFeatures.add(inp);f.name=name
    return f
def mark(c,group):c.attributes.add(GROUP,'physical_group',group)
def cut_tool(c,target,tool,name):
    objects=core.ObjectCollection.create();objects.add(tool)
    inp=c.features.combineFeatures.createInput(target,objects)
    inp.operation=fusion.FeatureOperations.CutFeatureOperation;inp.isKeepToolBodies=False
    f=c.features.combineFeatures.add(inp);f.name=name
    return f
def retry_shell():
    _,d=get()
    if d.rootComponent.occurrences.count!=1 or d.rootComponent.occurrences.item(0).component.name!='01 Shape A housing':
        raise RuntimeError('Retry only applies to incomplete first housing stage')
    d.rootComponent.occurrences.item(0).deleteMe()
    shell()
def checkpoint(stage):
    app,d=get();d.rootComponent.attributes.add(GROUP,'stage',stage)
    if not d.computeAll():raise RuntimeError('Recompute failed: '+stage)
    path=BASE/(NAME+'.f3d')
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):raise RuntimeError('Native checkpoint failed')
    print(json.dumps({'stage':stage,'occurrences':d.rootComponent.occurrences.count,'timeline':d.timeline.count,'native':str(path)}))
def create():
    app=core.Application.get();folder=app.data.activeFolder
    if not folder or folder.id!=FOLDER_ID:raise RuntimeError('Select saved Trimix analyzer destination folder first')
    if any(doc.name.startswith(NAME) for doc in app.documents):raise RuntimeError('A3 already open; resume without duplication')
    doc=app.documents.add(core.DocumentTypes.FusionDesignDocumentType);doc.name=NAME
    d=fusion.Design.cast(app.activeProduct);d.designType=fusion.DesignTypes.ParametricDesignType
    d.designIntent=fusion.DesignIntentTypes.HybridDesignIntentType
    d.fusionUnitsManager.distanceDisplayUnits=fusion.DistanceUnits.MillimeterDistanceUnits
    d.rootComponent.attributes.add(GROUP,'owned','true')
    d.rootComponent.attributes.add(GROUP,'status','Shape A fit concept; physical retention/seals/PCB layout validation pending')
    for n,e,c in PARAMS:
        p=d.userParameters.add(n,core.ValueInput.createByString(e),'mm',c);p.isFavorite=True
    if not doc.saveAs(NAME,folder,'A3 Shape A slimmer enclosure; preserves A2',''):raise RuntimeError('Initial cloud save failed')
    print(json.dumps({'created':doc.name,'folder':folder.name}))

def shell():
    _,d=get()
    if d.rootComponent.occurrences.count:raise RuntimeError('Shell requires empty A3 design')
    c=new('01 Shape A housing');mark(c,'housing')
    fsk=rectangle_xy(c,'Flat front Shape A outline','0 mm','0 mm','CaseWidth','CaseHeight','0 mm')
    rsk=rectangle_xy(c,'Gently tapered rear outline','RearInset','RearInset','CaseWidth-2*RearInset','CaseHeight-2*RearInset','CaseDepth-Cover')
    inp=c.features.loftFeatures.createInput(fusion.FeatureOperations.NewBodyFeatureOperation)
    inp.loftSections.add(fsk.profiles.item(0));inp.loftSections.add(rsk.profiles.item(0))
    f=c.features.loftFeatures.add(inp);f.name='Shape A restrained taper';body=f.bodies.item(0);body.name='Printed main housing'
    fsk.isLightBulbOn=False;rsk.isLightBulbOn=False
    fillet_long(c,body,'CornerRadius','Shape A soft outer corners',2)
    tool=box(c,'Rear cavity cutting tool','Wall','Wall','14.5 mm','CaseWidth-2*Wall','CaseHeight-2*Wall','CaseDepth')
    fillet_long(c,tool,'CornerRadius-Wall','Inner cavity corner rounds',2)
    cut_tool(c,body,tool,'Rounded rear electronics cavity')
    tool=box(c,'Upper sensor cavity cutting tool','Wall','128 mm','Wall','CaseWidth-2*Wall','CaseHeight-Wall-128 mm','CaseDepth')
    fillet_long(c,tool,'CornerRadius-Wall','Upper pod inner top corner rounds',1,
       lambda p,q:p.y>mm(d,'CaseHeight-Wall-1 mm')/10)
    cut_tool(c,body,tool,'Upper sensor pod front clearance')
    box(c,'Front removable factory display aperture','DisplayX-DisplayFit','DisplayY-DisplayFit','-1 mm',
        'DisplayWidth+2*DisplayFit','DisplayHeight+2*DisplayFit','16 mm','cut',body)
    x1=mm(d,'DisplayX-DisplayFit')/10;x2=mm(d,'DisplayX+DisplayWidth+DisplayFit')/10
    y1=mm(d,'DisplayY-DisplayFit')/10;y2=mm(d,'DisplayY+DisplayHeight+DisplayFit')/10
    fillet_long(c,body,'2.4 mm','Display aperture corner rounds',1,
       lambda p,q:abs(p.x-q.x)<1e-7 and abs(p.y-q.y)<1e-7 and min(abs(p.x-x1),abs(p.x-x2))<1e-6 and min(abs(p.y-y1),abs(p.y-y2))<1e-6)
    xcyl(c,'Opposed upper gas fitting clearances','-1 mm','GasY','GasZ','4.5 mm','CaseWidth+2 mm','cut',body)
    xcyl(c,'Left-side power button opening','CaseWidth-Wall-1 mm','ButtonY','ButtonZ','6 mm','Wall+2 mm','cut',body)
    cover=new('02 Single rear cover');mark(cover,'rear_cover')
    cb=box(cover,'Single rear cover','RearInset','RearInset','CaseDepth-Cover+CoverGap',
           'CaseWidth-2*RearInset','CaseHeight-2*RearInset','Cover-CoverGap')
    fillet_long(cover,cb,'CornerRadius','Soft rear cover corners',.1)
    # Slight edge rolls retain the broad, simple rear of Shape A.
    edges=core.ObjectCollection.create()
    for e in cb.edges:
        bb=e.boundingBox
        if abs(bb.minPoint.z-mm(d,'CaseDepth')/10)<1e-6 and abs(bb.maxPoint.z-mm(d,'CaseDepth')/10)<1e-6:edges.add(e)
    if edges.count:
        fi=cover.features.filletFeatures.createInput();fi.edgeSetInputs.addConstantRadiusEdgeSet(edges,core.ValueInput.createByString('0.8 mm'),False)
        cover.features.filletFeatures.add(fi).name='Soft rear edge roll'
    checkpoint('Shape A shell')

def rear_fasteners():
    from hardware_a3 import screw_instances,insert_instances
    _,d=get();root=d.rootComponent;c=comp('01 Shape A housing');body=c.bRepBodies.item(0)
    cover=comp('02 Single rear cover');cb=cover.bRepBodies.item(0)
    pts=[('8 mm','8 mm'),('CaseWidth-8 mm','8 mm'),('8 mm','CaseHeight-8 mm'),('CaseWidth-8 mm','CaseHeight-8 mm')]
    for x,y in pts:
        # Boss support pads join the adjacent end wall, beyond all removal lanes.
        inlet_upper=x=='CaseWidth-8 mm' and y=='CaseHeight-8 mm'
        yy='Wall-0.1 mm' if y=='8 mm' else ('CaseHeight-10.5 mm' if inlet_upper else 'CaseHeight-11.5 mm')
        box(c,'Rear boss end-wall web',f'({x})-3.7 mm',yy,'CaseDepth-13 mm','7.4 mm','8.2 mm' if inlet_upper else '9.2 mm','9 mm','join')
        cyl(c,'Rear M3 boss',x,y,'CaseDepth-13 mm','4.2 mm','9 mm','join')
        cyl(c,'M3 insert pilot',x,y,'CaseDepth-9 mm','2.15 mm','5.1 mm','cut',body)
        cyl(cover,'Reinforced rear screw seat',x,y,'CaseDepth-3.8 mm','4.8 mm','2.15 mm','join')
        cyl(cover,'M3 screw clearance',x,y,'CaseDepth-3.9 mm','1.65 mm','4.1 mm','cut',cb)
        cyl(cover,'Flush M3 head recess',x,y,'CaseDepth-1.65 mm','3 mm','1.8 mm','cut',cb)
        cyl(c,'M3 blind screw tip clearance',x,y,'CaseDepth-10 mm','1.6 mm','2 mm','cut',body)
    fasteners(root,'M3',8,pts,'CaseDepth-1.65 mm','CaseDepth-4 mm','rear_cover','housing')
    # Discrete registration tabs, not seal compression or snap latches.
    for side in ('Wall+0.25 mm','CaseWidth-Wall-2.25 mm'):
        for y in ('55 mm','98 mm'):
            box(cover,'Rear cover locating lip',side,y,'CaseDepth-Cover-2 mm','2 mm','12 mm','2.3 mm','join')
    checkpoint('Four recessed rear screws')

def fasteners(root,size,length,points,seat,insert,owner,insertowner):
    from hardware_a3 import screw_instances,insert_instances
    _,d=get()
    pp=[(mm(d,x),mm(d,y),mm(d,seat)) for x,y in points]
    ss=screw_instances(root,size,length,pp,label=owner+' '+size+' screws')
    ii=insert_instances(root,size,[(x,y,mm(d,insert)) for x,y,z in pp])
    for kind,occs,z,g in [('screw',ss,seat,owner),('insert',ii,insert,insertowner)]:
        for index,(o,(x,y)) in enumerate(zip(occs,points),1):
            o.attributes.add(GROUP,'position_expressions',json.dumps([x,y,z]))
            o.attributes.add(GROUP,'physical_group',g)
            o.attributes.add(GROUP,'instance_label',f'{owner} {kind} {index}')
    return ss,ii

def display():
    c=new('03 Guition factory casing — measured envelope','Owner measured retained116.8x69.3x13.7mm casing; local details drawing references');mark(c,'display')
    body=box(c,'Retained factory frame','DisplayX','DisplayY','DisplayFront','DisplayWidth','DisplayHeight','DisplayDepth')
    fillet_long(c,body,'2 mm','Factory corner reference',1)
    box(c,'Factory open rear','DisplayX+(DisplayWidth-65.4 mm)/2','DisplayY+(DisplayHeight-108 mm)/2','DisplayFront+3 mm','65.4 mm','108 mm','12 mm','cut',body)
    box(c,'Factory glass recess','DisplayX+(DisplayWidth-GlassWidth)/2','DisplayY+(DisplayHeight-GlassHeight)/2','DisplayFront-0.1 mm','GlassWidth','GlassHeight','1.3 mm','cut',body)
    glass=new('04 Guition front glass — drawing reference');mark(glass,'display')
    gb=box(glass,'Factory glass black border','DisplayX+(DisplayWidth-GlassWidth)/2','DisplayY+(DisplayHeight-GlassHeight)/2','DisplayFront','GlassWidth','GlassHeight','1.2 mm')
    box(glass,'Active face recess','DisplayX+(DisplayWidth-ActiveWidth)/2','DisplayY+(DisplayHeight-ActiveHeight)/2','DisplayFront-0.1 mm','ActiveWidth','ActiveHeight','0.2 mm','cut',gb)
    active=new('05 Active 4.3 inch screen');mark(active,'display')
    box(active,'Active480x800 screen','DisplayX+(DisplayWidth-ActiveWidth)/2','DisplayY+(DisplayHeight-ActiveHeight)/2','DisplayFront','ActiveWidth','ActiveHeight','0.1 mm')
    pcb=new('06 Guition PCB and connectors — illustrative detail','Manufacturer outline reference; local connector locations provisional');mark(pcb,'display')
    pb=box(pcb,'Guition PCB outline','DisplayX+(DisplayWidth-65.06 mm)/2','DisplayY+(DisplayHeight-108 mm)/2','8 mm','65.06 mm','108 mm','1.6 mm')
    for x in ('DisplayX+4.65 mm','DisplayX+64.65 mm'):
        for y in ('DisplayY+7.1 mm','DisplayY+109.7 mm'):cyl(pcb,'Factory mounting-hole reference',x,y,'7.9 mm','2.5 mm','1.8 mm','cut',pb)
    for n,x,y,w,h,t in [('ESP32-P4',12.15,70.9,16,16,3),('ESP32-C6',44.15,85.9,14,19,2.8),('Memory',31.15,74.9,7,9,1.2),('Power inductor',11.15,13.9,6,6,3.4),('Power IC',21.15,18.9,5,5,1.5),('Factory USB',27.15,4.9,9,7,3.8),('FPC latch',20.15,57.9,28,4,1.8),('Expansion header',49.15,29.9,5,33,4)]:
        box(pcb,n+' visual reference',f'DisplayX+{x} mm',f'DisplayY+{y} mm','9.6 mm',f'{w} mm',f'{h} mm',f'{t} mm')
    checkpoint('Measured display assembly')

def carrier():
    _,d=get();root=d.rootComponent;shellc=comp('01 Shape A housing');sb=shellc.bRepBodies.item(0)
    # The divider acts as a guide. Two screws fix the removable carrier to shell webs.
    box(shellc,'Lower battery cradle and divider anchor','Wall-0.1 mm','24.5 mm','14.3 mm','50.2 mm-Wall+0.1 mm','2 mm','4.2 mm','join')
    box(shellc,'Battery to PCB guide divider','48.2 mm','25 mm','14.3 mm','2 mm','92.6 mm','21.7 mm','join')
    pts=[('CaseWidth-9 mm','28 mm'),('54.8 mm','114 mm')]
    for i,(x,y) in enumerate(pts):
        xx=f'({x})-3.6 mm' if i==0 else '48.2 mm'
        ww='CaseWidth-Wall+0.1 mm-('+xx+')' if i==0 else '10.2 mm'
        box(shellc,'Carrier fixed support web',xx,f'({y})-3.6 mm','14.3 mm',ww,'7.2 mm','4.2 mm','join')
        cyl(shellc,'Carrier M2 insert pilot',x,y,'14.4 mm','1.65 mm','4.2 mm','cut',sb)
    c=new('Carrier / removable electronics tray');mark(c,'carrier')
    cb=box(c,'PCB carrier plate','PcbX-0.2 mm','PcbY-0.5 mm','18.5 mm','PcbWidth+0.4 mm','PcbHeight+1 mm','2 mm')
    p=new('Carrier / future PCB allocation — layout pending','Mechanical allocation only; footprint audit separate, routing and thermal layout pending');mark(p,'pcb')
    pb=box(p,'Future shaped PCB','PcbX','PcbY','PcbZ','PcbWidth','PcbHeight','1.6 mm')
    for cc,bb in ((c,cb),(p,pb)):
        box(cc,'Button terminal and finger access notch','CaseWidth-26 mm','103 mm','18.4 mm','30 mm','18 mm','4 mm','cut',bb)
        for x,y in pts:cyl(cc,'Shared carrier M2 hole',x,y,'18.4 mm','1.15 mm','4 mm','cut',bb)
    for n,x,y,w,h,t in [('Charger power zone','54 mm','37 mm','20 mm','23 mm','5 mm'),('Sensor analog zone','54 mm','68 mm','20 mm','20 mm','4 mm'),('Digital interface zone','54 mm','94 mm','18 mm','8 mm','3 mm')]:
        box(p,n,x,y,'PcbZ+1.6 mm',w,h,t)
    fasteners(root,'M2',7,pts,'PcbZ+1.6 mm','18.5 mm','pcb','housing')
    checkpoint('PCB beside battery')

def retainers():
    _,d=get();root=d.rootComponent;c=comp('01 Shape A housing');body=c.bRepBodies.item(0)
    pts=[('CaseWidth-16 mm','12.3 mm'),('DisplayX+2.65 mm','126 mm')]
    box(c,'Lower display retainer side-wall bracket','CaseWidth-17.7 mm','8.5 mm','14.3 mm','15.4 mm','7.5 mm','4.2 mm','join')
    for x,y in pts:
        # Stops are rooted in the flat front/frame region, outside occupied pack.
        cyl(c,'Display retainer support',x,y,'14.3 mm','3.7 mm','4.2 mm','join')
        cyl(c,'Display retainer insert pilot',x,y,'14.4 mm','1.65 mm','4.2 mm','cut',body)
    for index,(x,y) in enumerate(pts):
        cc=new('Display / '+('lower' if index==0 else 'upper')+' rear-release retainer','Factory frame contact and capture surfaces still require owner measurement');mark(cc,'display_retainers')
        plate_y='7.4 mm' if index==0 else '121.5 mm'
        plate_h='8.6 mm' if index==0 else '8 mm'
        bb=box(cc,'Removable display retainer plate',f'({x})-3.5 mm',plate_y,'18.5 mm','7 mm',plate_h,'2 mm')
        # Flat pad is a provisional frame-contact surface; no clamping force asserted.
        py='DisplayY+0.5 mm' if index==0 else 'DisplayY+DisplayHeight-2.2 mm'
        px=f'({x})-3 mm' if index==0 else f'({x})-2 mm'
        pw='6 mm' if index==0 else '4 mm'
        box(cc,'Frame contact provision',px,py,'14.1 mm',pw,'2 mm','6.4 mm','join')
        cyl(cc,'Retainer M2 clearance',x,y,'18.4 mm','1.15 mm','2.2 mm','cut',bb)
    fasteners(root,'M2',5,pts,'20.5 mm','18.5 mm','display_retainers','housing')
    checkpoint('Two rear-release display retainers')

def button():
    c=new('Controls / left 1NO button body','Unmeasured12mm button, nut and terminal dimensions provisional');mark(c,'button')
    xcyl(c,'Button barrel','CaseWidth-18 mm','ButtonY','ButtonZ','5.8 mm','17.85 mm')
    xcyl(c,'External button bezel','CaseWidth','ButtonY','ButtonZ','7 mm','1.3 mm')
    xbox(c,'Button terminal block allowance','CaseWidth-25 mm','ButtonY-4 mm','ButtonZ-4 mm','7 mm','8 mm','8 mm')
    cap=new('Controls / left momentary power cap');mark(cap,'button')
    xcyl(cap,'Momentary push face','CaseWidth+1.3 mm','ButtonY','ButtonZ','4.5 mm','0.2 mm')
    nut=new('Controls / button retaining nut reference','Illustrative annular nut; actual hardware unmeasured');mark(nut,'button')
    nb=xcyl(nut,'Internal button nut reference','CaseWidth-4.5 mm','ButtonY','ButtonZ','7.2 mm','2 mm')
    xcyl(nut,'Nut clearance over barrel','CaseWidth-4.6 mm','ButtonY','ButtonZ','6 mm','2.2 mm','cut',nb)
    checkpoint('Left power button')

def battery_cradle():
    c=comp('01 Shape A housing');body=c.bRepBodies.item(0)
    cover=comp('02 Single rear cover')
    box(c,'Holder right guide rail','Wall-0.1 mm','HolderY','14.3 mm','HolderX-Wall-0.4 mm','HolderHeight','21.7 mm','join')
    for y in ('HolderY-2.5 mm','HolderY+HolderHeight+0.5 mm'):
        box(c,'Holder end stop','Wall-0.1 mm',y,'14.3 mm','50.2 mm-Wall+0.1 mm','2 mm','4.2 mm','join')
    # Fixed rails support only the holder frame, outside its occupied cell pocket.
    for x in ('HolderX','HolderX+HolderWidth-2 mm'):
        box(c,'Holder front support rail',x,'HolderY','14.3 mm','2 mm' if x=='HolderX' else '3 mm','HolderHeight','2.2 mm','join')
        box(cover,'Holder rear capture pad',x,'HolderY+12 mm','HolderZ+HolderDepth+0.5 mm','2 mm','54 mm',
            'CaseDepth-Cover+CoverGap-HolderZ-HolderDepth-0.5 mm+0.2 mm','join')
    checkpoint('Straight-removal battery cradle')

def usb_service_relief():
    for name in ('Carrier / removable electronics tray','Carrier / future PCB allocation — layout pending'):
        c=comp(name);body=c.bRepBodies.item(0)
        box(c,'USB cartridge removal corner relief','PcbX-0.2 mm','20.4 mm','18.4 mm',
            'UsbX+13.9 mm-PcbX','4.8 mm','4 mm','cut',body)
    checkpoint('USB service clearance in PCB and carrier')

def integration_datums():
    _,d=get()
    d.userParameters.itemByName('GasY').expression='CaseHeight-17.5 mm'
    c=comp('01 Shape A housing')
    sk=c.sketches.itemByName('Holder right guide rail sketch')
    sk.sketchDimensions.item(2).parameter.expression='HolderX-Wall-0.4 mm'
    checkpoint('Final cartridge port and battery guide datums')

def refine_first_audit():
    _,d=get();c=comp('01 Shape A housing');body=c.bRepBodies.item(0)
    for f in reversed(list(c.features)):
        if f.name.startswith('Cover bearing-pad clearance'):f.deleteMe()
    for x in ('8 mm','CaseWidth-8 mm'):
        for y in ('8 mm','CaseHeight-8 mm'):
            cyl(c,'M3 blind screw tip clearance',x,y,'CaseDepth-10 mm','1.6 mm','2 mm','cut',body)
    sk=c.sketches.itemByName('Lower display retainer side-wall bracket sketch')
    sk.sketchDimensions.item(1).parameter.expression='8.5 mm'
    sk.sketchDimensions.item(3).parameter.expression='7.5 mm'
    for index,y in enumerate(('12.3 mm','126 mm')):
        suffix='' if index==0 else ' (1)'
        for n in ('Display retainer support sketch','Display retainer insert pilot sketch'):
            c.sketches.itemByName(n+suffix).sketchDimensions.item(1).parameter.expression=y
        cc=comp('Display / '+('lower' if index==0 else 'upper')+' rear-release retainer')
        sk=cc.sketches.itemByName('Removable display retainer plate sketch')
        sk.sketchDimensions.item(1).parameter.expression='7.4 mm' if index==0 else '121.5 mm'
        sk.sketchDimensions.item(3).parameter.expression='8.6 mm' if index==0 else '8 mm'
        cc.sketches.itemByName('Retainer M2 clearance sketch').sketchDimensions.item(1).parameter.expression=y
        if index==1:
            sk=cc.sketches.itemByName('Frame contact provision sketch')
            sk.sketchDimensions.item(0).parameter.expression='8.5 mm'
            sk.sketchDimensions.item(1).parameter.expression='DisplayY+DisplayHeight-2.2 mm'
            sk.sketchDimensions.item(2).parameter.expression='4 mm'
    for o in d.rootComponent.occurrences:
        a=o.attributes.itemByName(GROUP,'position_expressions')
        if not a:continue
        e=json.loads(a.value)
        if e[0]=='CaseWidth-14 mm' and e[1]=='11 mm':e[1]='12.3 mm'
        elif e[0]=='10.5 mm' and e[1]=='125 mm':e[1]='126 mm'
        else:continue
        o.attributes.add(GROUP,'position_expressions',json.dumps(e))
        m=o.transform2.copy();m.translation=core.Vector3D.create(*[mm(d,v)/10 for v in e]);o.transform2=m
    checkpoint('First assembly interference corrections')
