"""Parametric Revision 03 builder, executed in stages via Autodesk's official MCP.

X=0 is the user's right; +X points left, +Y up, +Z rearward. Millimetres.
Purchased parts retain their dimensions when enclosure parameters change.
"""
from pathlib import Path
import json
import sys
import adsk.core as core
import adsk.fusion as fusion

BASE=Path(__file__).resolve().parents[1]
HELPERS=BASE.parent/'scripts'
if str(HELPERS) not in sys.path:
    sys.path.insert(0,str(HELPERS))
from fusion_helpers import (new_component, rectangle_xy, circle_xy, rectangle_yz,
                            circle_yz, rectangle_xz, circle_xz, extrude, extrude_axis)
NAME='Trimix_Enclosure_A2'
GROUP='TrimixRev03'
FOLDER_ID='urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'
PARAMS=[
 ('CaseWidth','75 mm','Initial compact housing width'),
 ('CaseHeight','125 mm','Initial compact housing height'),
 ('CaseDepth','52 mm','Housing including one rear cover'),
 ('Wall','2.4 mm','Nominal printed shell wall; minimum check >=2 mm'),
 ('RearInset','0.25 mm','Gentle inward taper per outer edge'),
 ('CornerRadius','6 mm','Soft longitudinal corner radius'),
 ('Cover','2.4 mm','Single rear cover thickness'),
 ('CoverGap','0.2 mm','Provisional seating gap; not a weather seal'),
 ('DisplayWidth','69.3 mm','Owner measured; remaining factory casing retained'),
 ('DisplayHeight','116.8 mm','Owner measured'),
 ('DisplayDepth','13.7 mm','Owner measured with only factory rear panel removed'),
 ('DisplayX','(CaseWidth-DisplayWidth)/2','Centred factory display'),
 ('DisplayY','(CaseHeight-DisplayHeight)/2','Centred factory display'),
 ('DisplayFront','0.4 mm','Slightly recessed from printed front rim'),
 ('DisplayFit','0.4 mm','Provisional clearance per side of front removable display'),
 ('GlassWidth','66.8 mm','Published glass reference; physical confirmation pending'),
 ('GlassHeight','114.4 mm','Published glass reference'),
 ('ActiveWidth','56.16 mm','Published active screen width'),
 ('ActiveHeight','93.60 mm','Published active screen height'),
 ('HolderWidth','42 mm','Owner measured occupied FMA holder'),
 ('HolderHeight','80.4 mm','Owner measured occupied FMA holder'),
 ('HolderDepth','20.35 mm','Owner measured maximum occupied thickness'),
 ('HolderX','3 mm','Battery is behind lower right portion of screen'),
 ('HolderY','3.2 mm','Occupied battery lower edge'),
 ('HolderZ','15.2 mm','Display and battery clearance'),
 ('ChamberWall','2 mm','Concept chamber wall; seal qualification pending'),
 ('ChamberFront','15 mm','Front of independent rear sampling cartridge'),
 ('ChamberRear','CaseDepth-Cover-0.3 mm','Rear of closed sampling cartridge'),
 ('ChamberLid','2 mm','Independent internal chamber lid'),
 ('ChamberSideX','45.6 mm','Start of viewer-left vertical gas chamber column'),
 ('ChamberLeft','2.9 mm','Upper chamber inner-case margin'),
 ('ChamberRight','CaseWidth-2.9 mm','Upper and side chamber extent'),
 ('ChamberBottom','30 mm','Lower gas column clears USB mounting region'),
 ('ChamberTop','CaseHeight-2.9 mm','Top clearance to housing'),
 ('ChamberBarY','87 mm','Lower edge of horizontal upper gas chamber'),
 ('GasY','105 mm','Upper cross-flow port height'),
 ('GasZ','23 mm','Side-fitting depth centre'),
 ('GasBore','2.5 mm','5 mm ID nominal sample ports'),
 ('UsbY','16 mm','Low on viewer-left side, below gas column'),
 ('UsbZ','27 mm','USB connector centre depth'),
 ('ButtonY','45 mm','Right-side power button, behind holder'),
 ('ButtonZ','43 mm','Button clearance behind measured thin holder'),
]

def get():
    app=core.Application.get()
    d=fusion.Design.cast(app.activeProduct)
    if not d or not d.rootComponent.attributes.itemByName(GROUP,'owned'):
        raise RuntimeError('Active document is not the owned Revision 03 design')
    return app,d

def mm(d,expression):
    return d.unitsManager.evaluateExpression(expression,'mm')*10

def comp(name):
    _,d=get()
    return next(o.component for o in d.rootComponent.occurrences if o.component.name==name)

def new(name,status='designed concept'):
    _,d=get()
    c=new_component(d.rootComponent,name)
    c.attributes.add(GROUP,'model_basis',status)
    return c

def box(c,name,x,y,z,w,h,t,op='new',target=None):
    sk=rectangle_xy(c,name+' sketch',x,y,w,h,z)
    f=extrude(c,sk,t,name,op,[target] if target else None)
    if op=='new': f.bodies.item(0).name=name
    return f.bodies.item(0)

def cyl(c,name,x,y,z,r,t,op='new',target=None):
    sk=circle_xy(c,name+' sketch',x,y,r,z)
    f=extrude(c,sk,t,name,op,[target] if target else None)
    if op=='new': f.bodies.item(0).name=name
    return f.bodies.item(0)

def xbox(c,name,x,y,z,w,h,t,op='new',target=None):
    sk=rectangle_yz(c,name+' sketch',y,z,h,t,x)
    f=extrude_axis(c,sk,w,name,'x',op,[target] if target else None)
    if op=='new': f.bodies.item(0).name=name
    return f.bodies.item(0)

def xcyl(c,name,x,y,z,r,t,op='new',target=None):
    sk=circle_yz(c,name+' sketch',y,z,r,x)
    f=extrude_axis(c,sk,t,name,'x',op,[target] if target else None)
    if op=='new': f.bodies.item(0).name=name
    return f.bodies.item(0)

def fillet_long(c,body,radius,name,min_span=1.0,select=None):
    edges=core.ObjectCollection.create()
    for e in body.edges:
        if not e.startVertex or not e.endVertex: continue
        p,q=e.startVertex.geometry,e.endVertex.geometry
        if abs(p.z-q.z)>min_span and (select is None or select(p,q)):
            edges.add(e)
    if not edges.count: raise RuntimeError('No edges for '+name)
    request=c.features.filletFeatures.createInput()
    request.edgeSetInputs.addConstantRadiusEdgeSet(edges,core.ValueInput.createByString(radius),False)
    c.features.filletFeatures.add(request).name=name

def checkpoint(stage):
    _,d=get()
    d.rootComponent.attributes.add(GROUP,'stage',stage)
    path=BASE/(NAME+'.f3d')
    if not d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path))):
        raise RuntimeError('Native checkpoint failed')
    print(json.dumps({'stage':stage,'occurrences':d.rootComponent.occurrences.count,
                      'timeline':d.timeline.count,'native':str(path)}))

def create():
    app=core.Application.get()
    folder=app.data.activeFolder
    if not folder or folder.id!=FOLDER_ID: raise RuntimeError('Destination folder changed')
    if any(doc.name.startswith(NAME) for doc in app.documents):
        raise RuntimeError('Revision03 already open; resume instead of duplicating')
    doc=app.documents.add(core.DocumentTypes.FusionDesignDocumentType)
    doc.name=NAME
    d=fusion.Design.cast(app.activeProduct)
    d.designType=fusion.DesignTypes.ParametricDesignType
    d.designIntent=fusion.DesignIntentTypes.HybridDesignIntentType
    d.fusionUnitsManager.distanceDisplayUnits=fusion.DistanceUnits.MillimeterDistanceUnits
    d.rootComponent.attributes.add(GROUP,'owned','true')
    d.rootComponent.attributes.add(GROUP,'status','Compact concept; physical fit and seals pending')
    for name,expr,comment in PARAMS:
        p=d.userParameters.add(name,core.ValueInput.createByString(expr),'mm',comment)
        p.isFavorite=True
    if not doc.saveAs(NAME,folder,'Revision03 measured compact concept; not released for manufacture',''):
        raise RuntimeError('Initial cloud save failed')
    print(json.dumps({'created':doc.name,'folder':folder.name}))

def shell():
    _,d=get()
    if d.rootComponent.occurrences.count: raise RuntimeError('Shell requires empty new design')
    c=new('01 Tapered printed housing')
    front=rectangle_xy(c,'Front silhouette','0 mm','0 mm','CaseWidth','CaseHeight','0 mm')
    rear=rectangle_xy(c,'Rear silhouette','RearInset','RearInset',
                      'CaseWidth-2*RearInset','CaseHeight-2*RearInset','CaseDepth-Cover')
    inp=c.features.loftFeatures.createInput(fusion.FeatureOperations.NewBodyFeatureOperation)
    inp.loftSections.add(front.profiles.item(0)); inp.loftSections.add(rear.profiles.item(0))
    f=c.features.loftFeatures.add(inp); f.name='Gentle rearward taper'
    body=f.bodies.item(0); body.name='Tapered housing'
    front.isLightBulbOn=False; rear.isLightBulbOn=False
    fillet_long(c,body,'CornerRadius','Soft housing corners',2.0)
    box(c,'Rear service cavity','Wall','Wall','14.5 mm','CaseWidth-2*Wall',
        'CaseHeight-2*Wall','CaseDepth','cut',body)
    # Rounded cavity corners retain material around the outside rounds.
    fillet_long(c,body,'CornerRadius-Wall','Inside cavity corner rounds',2.0,
                lambda p,q:abs(p.x-q.x)<1e-7 and abs(p.y-q.y)<1e-7)
    box(c,'Front-removable factory display opening','DisplayX-DisplayFit','DisplayY-DisplayFit',
        '-1 mm','DisplayWidth+2*DisplayFit','DisplayHeight+2*DisplayFit','16 mm','cut',body)
    xcyl(c,'Gas fitting wall passages','-1 mm','GasY','GasZ','4.5 mm','CaseWidth+2 mm','cut',body)
    xcyl(c,'Right button panel opening','-1 mm','ButtonY','ButtonZ','6 mm','Wall+2 mm','cut',body)
    xbox(c,'Left USB insert opening','CaseWidth-Wall-1 mm','UsbY-10 mm','UsbZ-8 mm',
         'Wall+2 mm','20 mm','16 mm','cut',body)
    cover=new('02 Single rear cover')
    b=box(cover,'Single screw-fastened rear cover','RearInset','RearInset','CaseDepth-Cover+CoverGap',
          'CaseWidth-2*RearInset','CaseHeight-2*RearInset','Cover-CoverGap')
    fillet_long(cover,b,'CornerRadius','Rear cover corner rounds',0.1)
    checkpoint('shell')

def display():
    c=new('03 Guition factory casing — measured envelope',
          'Owner measured 116.8x69.3x13.7; casing retained, factory back removed; interior drawing-derived')
    b=box(c,'Guition retained factory frame','DisplayX','DisplayY','DisplayFront',
          'DisplayWidth','DisplayHeight','DisplayDepth')
    fillet_long(c,b,'2 mm','Factory frame corner reference',1.0)
    box(c,'Factory open rear cavity','CaseWidth/2-32.7 mm','CaseHeight/2-54 mm',
        'DisplayFront+3 mm','65.4 mm','108 mm','12 mm','cut',b)
    box(c,'Factory glass recess','(CaseWidth-GlassWidth)/2','(CaseHeight-GlassHeight)/2',
        'DisplayFront-0.1 mm','GlassWidth','GlassHeight','1.3 mm','cut',b)
    glass=new('04 Guition front glass — drawing reference')
    gb=box(glass,'Black border glass','(CaseWidth-GlassWidth)/2','(CaseHeight-GlassHeight)/2',
           'DisplayFront','GlassWidth','GlassHeight','1.2 mm')
    box(glass,'Active face recess','(CaseWidth-ActiveWidth)/2','(CaseHeight-ActiveHeight)/2',
        'DisplayFront-0.1 mm','ActiveWidth','ActiveHeight','0.2 mm','cut',gb)
    active=new('05 Active 4.3 inch screen')
    box(active,'480x800 active area','(CaseWidth-ActiveWidth)/2','(CaseHeight-ActiveHeight)/2',
        'DisplayFront','ActiveWidth','ActiveHeight','0.1 mm')
    pcb=new('06 Guition PCB and connectors — illustrative detail',
            'Drawing-derived visual reconstruction; connector positions and factory mounting holes require confirmation')
    pb=box(pcb,'Guition PCB outline reference','CaseWidth/2-32.53 mm','CaseHeight/2-54 mm',
           '8 mm','65.06 mm','108 mm','1.6 mm')
    for x in ('CaseWidth/2-30 mm','CaseWidth/2+30 mm'):
        for y in ('CaseHeight/2-51.3 mm','CaseHeight/2+51.3 mm'):
            cyl(pcb,'Factory mounting clearance reference',x,y,'7.9 mm','2.5 mm','1.8 mm','cut',pb)
    details=[('ESP32-P4 visual reference','15 mm','75 mm','16 mm','16 mm','3 mm'),
             ('ESP32-C6 radio module reference','47 mm','90 mm','14 mm','19 mm','2.8 mm'),
             ('Memory package reference','34 mm','79 mm','7 mm','9 mm','1.2 mm'),
             ('Power inductor reference','14 mm','18 mm','6 mm','6 mm','3.4 mm'),
             ('Board IC reference','24 mm','23 mm','5 mm','5 mm','1.5 mm'),
             ('Rear USB connector reference','30 mm','9 mm','9 mm','7 mm','3.8 mm'),
             ('Display FPC latch reference','23 mm','62 mm','28 mm','4 mm','1.8 mm'),
             ('Expansion header reference','52 mm','34 mm','5 mm','33 mm','4 mm')]
    for name,x,y,w,h,t in details:
        box(pcb,name,f'({x})+DisplayX-2.85 mm',
            f'({y})+DisplayY-4.1 mm','9.6 mm',w,h,t)
    checkpoint('display')

def fit_revision():
    _,d=get()
    d.userParameters.itemByName('CaseDepth').expression='54 mm'
    d.userParameters.itemByName('ChamberRear').expression='CaseDepth-Cover-2.3 mm'
    d.userParameters.itemByName('HolderY').expression='4.2 mm'
    c=comp('01 Tapered printed housing'); b=c.bRepBodies.item(0)
    x1=mm(d,'DisplayX-DisplayFit')/10; x2=mm(d,'DisplayX+DisplayWidth+DisplayFit')/10
    y1=mm(d,'DisplayY-DisplayFit')/10; y2=mm(d,'DisplayY+DisplayHeight+DisplayFit')/10
    def opening_edge(p,q):
        return (abs(p.x-q.x)<1e-7 and abs(p.y-q.y)<1e-7 and
                min(abs(p.x-x1),abs(p.x-x2))<1e-6 and min(abs(p.y-y1),abs(p.y-y2))<1e-6)
    fillet_long(c,b,'2.4 mm','Radiused forward display aperture preserves corner walls',1.0,opening_edge)
    checkpoint('54 mm depth and front fit')

def run(_context: str):
    raise RuntimeError('Invoke a named stage; no implicit rebuild')
