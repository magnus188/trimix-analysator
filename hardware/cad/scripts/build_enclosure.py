"""Revision 02 concept builder. Execute stages through the official Fusion MCP.

Coordinates: X left as viewed from the front, Y up, Z rearward (right-handed).
Front is Z=0, viewed along positive Z. All lengths are mm.
Only this builder's new document is edited; Casing is never used as a target.
"""
from pathlib import Path
import json
import adsk.core as core
import adsk.fusion as fusion
from fusion_helpers import (new_component, rectangle_xy, circle_xy, rectangle_yz,
                            circle_yz, rectangle_xz, circle_xz, extrude, extrude_axis)

BASE = Path(__file__).resolve().parents[1]
NAME = 'Trimix_Enclosure_A1'
GROUP = 'TrimixRev02'
FOLDER_ID = 'urn:adsk.wipprod:fs.folder:co.JKY47Dq7TLqRq7kWq4yYEA'

PARAMETERS = [
 ('CaseWidth','95 mm','Provisional outer width'),
 ('CaseHeight','180 mm','Provisional outer height'),
 ('CaseDepth','60 mm','Provisional total depth including rear cover'),
 ('Wall','3 mm','Initial PLA shell wall'),
 ('Cover','3 mm','Single rear cover thickness'),
 ('CornerRadius','8 mm','Outside corner radius'),
 ('CoverGap','0.25 mm','Provisional cover seating clearance'),
 ('DisplayWidth','69.41 mm','Verified conservative Guition module outline'),
 ('DisplayHeight','117.01 mm','Verified conservative Guition module outline'),
 ('DisplayDepth','13.8 mm','PROVISIONAL: shell-variant depth; confirm purchased unit'),
 ('DisplayBottom','10 mm','Module lower edge'),
 ('ActiveWidth','56.16 mm','Verified active display width'),
 ('ActiveHeight','93.60 mm','Verified active display height'),
 ('WindowMargin','0.5 mm','Provisional margin around active area'),
 ('BossInset','7.5 mm','Rear-cover screw centre inset from left/right'),
 ('BossRadius','4.5 mm','Cover screw boss outer radius'),
 ('InsertRadius','2.1 mm','PROVISIONAL M3 insert pilot radius; fit coupon required'),
 ('InsertDepth','5 mm','PROVISIONAL M3 insert length'),
 ('ScrewClearance','1.7 mm','M3 rear-cover clearance radius'),
 ('ChamberWidth','70 mm','Removable chamber outside width'),
 ('ChamberHeight','43 mm','Removable chamber outside height'),
 ('ChamberTopGap','5 mm','Clearance to case top'),
 ('ChamberBottom','CaseHeight-ChamberTopGap-ChamberHeight','Derived chamber lower edge'),
 ('ChamberFront','3.5 mm','Chamber front wall position'),
 ('ChamberWall','2 mm','Concept chamber wall; seal details pending'),
 ('ChamberLid','2 mm','Internally accessible chamber lid'),
 ('ChamberRear','CaseDepth-Cover-0.5 mm','Rear of closed chamber'),
 ('GasY','ChamberBottom+ChamberHeight/2','Gas inlet/outlet elevation'),
 ('GasZ','12 mm','Gas path centre depth'),
 ('GasBoreRadius','2.5 mm','5 mm nominal tube ID'),
 ('GasPassRadius','4.5 mm','PROVISIONAL housing clearance for side fitting'),
 ('UsbY','68 mm','Left charging connector centre height'),
 ('UsbZ','34 mm','USB connector depth centre'),
 ('ButtonY','102 mm','Right-side power button centre height; clears rear screw boss'),
 ('ButtonZ','42 mm','Button depth centre'),
 ('ButtonRadius','6 mm','Owned nominal 12 mm mounting diameter; confirm'),
]


def app_design():
    app = core.Application.get()
    d = fusion.Design.cast(app.activeProduct)
    if not d or not d.rootComponent.attributes.itemByName(GROUP, 'owned'):
        raise RuntimeError('Active document is not this builder\'s enclosure; no changes made.')
    return app, d


def mm(d, expr):
    return d.unitsManager.evaluateExpression(expr, 'mm') * 10


def component(d, name):
    for occ in d.rootComponent.occurrences:
        if occ.component.name == name:
            return occ.component
    raise ValueError('Missing component: '+name)


def box(c, name, x, y, z, w, h, depth, operation='new', target=None):
    s = rectangle_xy(c, name+' sketch', x, y, w, h, z)
    f = extrude(c, s, depth, name, operation, [target] if target else None)
    if operation == 'new':
        f.bodies.item(0).name = name
    return f.bodies.item(0)


def cylinder(c, name, x, y, z, radius, depth, operation='new', target=None):
    s = circle_xy(c, name+' sketch', x, y, radius, z)
    f = extrude(c, s, depth, name, operation, [target] if target else None)
    if operation == 'new':
        f.bodies.item(0).name = name
    return f.bodies.item(0)


def vertical_fillet(c, body, radius, name, select=None):
    edges = core.ObjectCollection.create()
    for e in body.edges:
        a, b = e.startVertex.geometry, e.endVertex.geometry
        if abs(a.x-b.x)<1e-7 and abs(a.y-b.y)<1e-7 and abs(a.z-b.z)>0.01:
            if select is None or select(a):
                edges.add(e)
    if not edges.count:
        raise RuntimeError('No vertical edges selected for '+name)
    inp = c.features.filletFeatures.createInput()
    inp.edgeSetInputs.addConstantRadiusEdgeSet(edges, core.ValueInput.createByString(radius), False)
    f = c.features.filletFeatures.add(inp)
    f.name = name
    return f


def side_circle(c,name,x,y,z,radius,length,target=None):
    s = circle_yz(c,name+' sketch',y,z,radius,x)
    f = extrude_axis(c,s,length,name,'x',operation='cut' if target else 'new',
                     participants=[target] if target else None)
    if not target:
        f.bodies.item(0).name = name
    return f.bodies.item(0)


def side_box(c,name,x,y,z,w,h,depth,target=None):
    s = rectangle_yz(c,name+' sketch',y,z,h,depth,x)
    f = extrude_axis(c,s,w,name,'x',operation='cut' if target else 'new',
                     participants=[target] if target else None)
    if not target:
        f.bodies.item(0).name = name
    return f.bodies.item(0)


def checkpoint(stage):
    app,d = app_design()
    d.rootComponent.attributes.add(GROUP,'stage',stage)
    BASE.mkdir(parents=True,exist_ok=True)
    opts=d.exportManager.createFusionArchiveExportOptions(str(BASE/(NAME+'.f3d')))
    if not d.exportManager.execute(opts):
        raise RuntimeError('Native archive export failed')
    print(json.dumps({'stage':stage,'components':d.rootComponent.occurrences.count,
                      'timeline':d.timeline.count,'archive':str(BASE/(NAME+'.f3d'))}))


def create_design():
    app=core.Application.get()
    folder=app.data.activeFolder
    if not folder or folder.id != FOLDER_ID:
        raise RuntimeError('Activate the verified Trimix analyzer destination folder first.')
    for document in app.documents:
        if document.name.startswith(NAME):
            raise RuntimeError('Enclosure document already open; resume it instead of creating a duplicate.')
    doc=app.documents.add(core.DocumentTypes.FusionDesignDocumentType)
    doc.name=NAME
    d=fusion.Design.cast(app.activeProduct)
    d.designType=fusion.DesignTypes.ParametricDesignType
    d.designIntent=fusion.DesignIntentTypes.HybridDesignIntentType
    d.fusionUnitsManager.distanceDisplayUnits=fusion.DistanceUnits.MillimeterDistanceUnits
    initialize_design()


def initialize_design():
    app=core.Application.get()
    doc=app.activeDocument
    d=fusion.Design.cast(app.activeProduct)
    if not doc.name.startswith(NAME) or d.rootComponent.occurrences.count or d.userParameters.count:
        raise RuntimeError('Initialization requires this builder\'s empty new document')
    folder=app.data.activeFolder
    if not folder or folder.id != FOLDER_ID:
        raise RuntimeError('Destination folder changed')
    d.rootComponent.attributes.add(GROUP,'owned','true')
    d.rootComponent.attributes.add(GROUP,'status','CONCEPT — fit and seals pending')
    for name,expr,comment in PARAMETERS:
        p=d.userParameters.add(name,core.ValueInput.createByString(expr),'mm',comment)
        p.isFavorite=True
    # The archive remains editable even before the first cloud save completes.
    if not doc.saveAs(NAME,folder,'Revision 02 enclosure concept; physical fit and sealing pending.',''):
        raise RuntimeError('Could not save the new design in Trimix analyzer')
    print(json.dumps({'created':doc.name,'folder':folder.name,'folder_id':folder.id}))


def build_shell():
    app,d=app_design()
    if d.rootComponent.occurrences.count:
        raise RuntimeError('Shell stage requires an empty new enclosure design')
    c=new_component(d.rootComponent,'01 Main housing')
    b=box(c,'Main housing','-CaseWidth/2','0 mm','0 mm','CaseWidth','CaseHeight','CaseDepth-Cover')
    vertical_fillet(c,b,'CornerRadius','Outside corner rounds')
    box(c,'Rear-open cavity','-CaseWidth/2+Wall','Wall','Wall',
        'CaseWidth-2*Wall','CaseHeight-2*Wall','CaseDepth',operation='cut',target=b)
    ix=(mm(d,'CaseWidth/2-Wall'))/10
    iy0=mm(d,'Wall')/10; iy1=mm(d,'CaseHeight-Wall')/10
    vertical_fillet(c,b,'CornerRadius-Wall','Inside corner rounds',
                    lambda p:abs(abs(p.x)-ix)<1e-5 and (abs(p.y-iy0)<1e-5 or abs(p.y-iy1)<1e-5))
    box(c,'Screen aperture','-(ActiveWidth+2*WindowMargin)/2',
        'DisplayBottom+(DisplayHeight-ActiveHeight)/2-WindowMargin','-1 mm',
        'ActiveWidth+2*WindowMargin','ActiveHeight+2*WindowMargin','Wall+2 mm','cut',b)
    # Six rear-facing bosses are tied into the sidewalls and clear the display envelope.
    for side in (-1,1):
        x=('-CaseWidth/2+BossInset' if side<0 else 'CaseWidth/2-BossInset')
        for idx,y in enumerate(('8 mm','CaseHeight/2','CaseHeight-8 mm')):
            key=f'{side}_{idx}'
            cylinder(c,'Boss '+key,x,y,'Wall','BossRadius','CaseDepth-Cover-Wall','join')
            bridge_x=('-CaseWidth/2+Wall' if side<0 else 'CaseWidth/2-BossInset')
            box(c,'Boss web '+key,bridge_x,'('+y+')-BossRadius','Wall',
                'BossInset-Wall','2*BossRadius','CaseDepth-Cover-Wall','join')
            cylinder(c,'Insert pilot '+key,x,y,'CaseDepth-Cover-InsertDepth',
                     'InsertRadius','InsertDepth+0.1 mm','cut',b)
    side_circle(c,'Upper side gas passages','-CaseWidth/2-1 mm','GasY','GasZ',
                'GasPassRadius','CaseWidth+2 mm',b)
    side_circle(c,'Right power button mounting hole','-CaseWidth/2-1 mm','ButtonY','ButtonZ',
                'ButtonRadius','Wall+2 mm',b)
    side_box(c,'Left USB service-insert opening','CaseWidth/2-Wall-1 mm','UsbY-10 mm','UsbZ-8 mm',
             'Wall+2 mm','20 mm','16 mm',b)
    rear=new_component(d.rootComponent,'02 Single rear cover')
    lid=box(rear,'Single rear cover','-CaseWidth/2','0 mm','CaseDepth-Cover+CoverGap',
            'CaseWidth','CaseHeight','Cover-CoverGap')
    vertical_fillet(rear,lid,'CornerRadius','Cover corner rounds')
    for side in (-1,1):
        x=('-CaseWidth/2+BossInset' if side<0 else 'CaseWidth/2-BossInset')
        for idx,y in enumerate(('8 mm','CaseHeight/2','CaseHeight-8 mm')):
            cylinder(rear,f'M3 clearance {side}_{idx}',x,y,'CaseDepth-Cover',
                     'ScrewClearance','Cover+1 mm','cut',lid)
    checkpoint('shell')
    set_camera('iso')


def set_camera(view='iso'):
    app,d=app_design()
    target=core.Point3D.create(0,mm(d,'CaseHeight')/20,mm(d,'CaseDepth')/20)
    vectors={'front':(0,0,-50),'rear':(0,0,50),'left':(50,0,0),
             'right':(-50,0,0),'top':(0,50,0),'iso':(35,25,-45),'rear_iso':(-35,25,45)}
    dx,dy,dz=vectors[view]
    cam=app.activeViewport.camera
    cam.cameraType=core.CameraTypes.OrthographicCameraType
    cam.eye=core.Point3D.create(target.x+dx,target.y+dy,target.z+dz)
    cam.target=target
    cam.upVector=core.Vector3D.create(0,0,-1) if view=='top' else core.Vector3D.create(0,1,0)
    cam.isFitView=True
    cam.isSmoothTransition=False
    app.activeViewport.camera=cam
    app.activeViewport.refresh()


def build_chamber():
    app,d=app_design()
    if d.rootComponent.attributes.itemByName(GROUP,'stage').value!='shell':
        raise RuntimeError('Chamber stage requires completed shell')
    c=new_component(d.rootComponent,'03 Removable sampling chamber')
    b=box(c,'Sampling chamber body','-ChamberWidth/2','ChamberBottom','ChamberFront',
          'ChamberWidth','ChamberHeight','ChamberRear-ChamberFront-ChamberLid')
    box(c,'Chamber cavity','-ChamberWidth/2+ChamberWall','ChamberBottom+ChamberWall',
        'ChamberFront+ChamberWall','ChamberWidth-2*ChamberWall','ChamberHeight-2*ChamberWall',
        'ChamberRear-ChamberFront','cut',b)
    side_circle(c,'Gas fitting clearance — seal TBD','-ChamberWidth/2-1 mm','GasY','GasZ',
                '4.1 mm','ChamberWidth+2 mm',b)
    for x in ('-ChamberWidth/2+5 mm','ChamberWidth/2-5 mm'):
        for y in ('ChamberBottom+4 mm','ChamberBottom+ChamberHeight-4 mm'):
            cylinder(c,'Internal lid boss',x,y,'ChamberFront+ChamberWall','3 mm',
                     'ChamberRear-ChamberLid-ChamberFront-ChamberWall','join')
            cylinder(c,'Internal lid pilot — M2 insert TBD',x,y,'ChamberRear-ChamberLid-4 mm',
                     '1.3 mm','4.1 mm','cut',b)
    # Separate attachment ears make it possible to remove the closed chamber as a cartridge.
    housing=component(d,'01 Main housing')
    for sign in (-1,1):
        xx=('-ChamberWidth/2-3 mm' if sign<0 else 'ChamberWidth/2+3 mm')
        earx=('-ChamberWidth/2-6 mm' if sign<0 else 'ChamberWidth/2-0.5 mm')
        for yy in ('ChamberBottom+5 mm','ChamberBottom+ChamberHeight-12 mm'):
            box(c,'Cartridge attachment ear',earx,'('+yy+')-3 mm','47 mm',
                '6.5 mm','6 mm','3 mm','join')
            cylinder(c,'Cartridge clearance',xx,yy,'46.9 mm','1.2 mm','3.2 mm','cut',b)
            post=cylinder(housing,'Cartridge support post',xx,yy,'Wall','2.5 mm','47 mm-Wall','join')
            cylinder(housing,'Cartridge support pilot — M2 TBD',xx,yy,'42 mm','1.3 mm',
                     '5.1 mm','cut',post)
    lid=new_component(d.rootComponent,'04 Internal chamber lid')
    lb=box(lid,'Internal chamber lid — gasket groove TBD','-ChamberWidth/2','ChamberBottom',
           'ChamberRear-ChamberLid','ChamberWidth','ChamberHeight','ChamberLid')
    for x in ('-ChamberWidth/2+5 mm','ChamberWidth/2-5 mm'):
        for y in ('ChamberBottom+4 mm','ChamberBottom+ChamberHeight-4 mm'):
            cylinder(lid,'Internal lid M2 clearance',x,y,'ChamberRear-ChamberLid-0.1 mm',
                     '1.2 mm','ChamberLid+0.2 mm','cut',lb)
    # Feedthrough occupies a small lower-wall opening; seal material and strain relief remain provisional.
    s=rectangle_xz(c,'Sealed wire feedthrough opening','-5 mm','48 mm','10 mm','5 mm',
                   y_expr='ChamberBottom-0.1 mm')
    extrude_axis(c,s,'ChamberWall+0.2 mm','Wire feedthrough cut','y','cut',[b])
    feed=new_component(d.rootComponent,'05 Feedthrough seal envelope TBD')
    fb=box(feed,'Potted wire seal envelope TBD','-5 mm','ChamberBottom','48 mm',
           '10 mm','ChamberWall','5 mm')
    feed.attributes.add(GROUP,'provisional','Seal material, wire holes and potting process unverified')
    fittings=new_component(d.rootComponent,'06 Gas fitting envelopes TBD')
    for label,x,length in (
        ('Right exhaust','-CaseWidth/2-6 mm','CaseWidth/2+6 mm-ChamberWidth/2+ChamberWall'),
        ('Left inlet','ChamberWidth/2-ChamberWall','CaseWidth/2+6 mm-ChamberWidth/2+ChamberWall')):
        f=side_circle(fittings,label+' fitting envelope',x,'GasY','GasZ','4 mm',length)
        side_circle(fittings,label+' bore',x,'GasY','GasZ','GasBoreRadius',length,f)
    fittings.attributes.add(GROUP,'provisional','8 mm OD / 5 mm ID passage representation; exact fittings and seals pending')
    checkpoint('chamber')


def capture(view='iso', filename=None):
    app,d=app_design()
    set_camera(view)
    dest=BASE/'views'/(filename or (view+'.png'))
    dest.parent.mkdir(parents=True,exist_ok=True)
    opts=core.SaveImageFileOptions.create(str(dest))
    opts.width=1500
    opts.height=1700
    opts.isBackgroundTransparent=True
    opts.isAntiAliased=True
    if not app.activeViewport.saveAsImageFileWithOptions(opts):
        raise RuntimeError('Viewport export failed')
    print(str(dest))


def style_model():
    app,d=app_design()
    lib=app.materialLibraries.itemByName('Fusion Appearance Library')
    appearances={}
    for key,base_id in [('case','Prism-116'),('dark','Prism-113'),('blue','Prism-115'),
                        ('green','Prism-117'),('red','Prism-120'),('brass','Prism-040')]:
        a=d.appearances.itemByName('Trimix '+key)
        if not a:
            a=d.appearances.addByCopy(lib.appearances.itemById(base_id),'Trimix '+key)
        appearances[key]=a
    colors={'01':'case','02':'case','03':'blue','04':'blue','05':'dark','06':'dark',
            '07':'dark','08':'dark','09':'case','10':'green','11':'dark','12':'blue',
            '13':'red','14':'case','15':'green','16':'dark','17':'brass','18':'red','19':'brass'}
    for occ in d.rootComponent.occurrences:
        occ.component.isOriginFolderLightBulbOn=False
        for body in occ.component.bRepBodies:
            body.appearance=appearances[colors.get(occ.component.name[:2],'case')]
    d.rootComponent.isOriginFolderLightBulbOn=False
    app.activeViewport.visualStyle=core.VisualStyles.ShadedWithVisibleEdgesOnlyVisualStyle
    grid=app.userInterface.commandDefinitions.itemById('ViewLayoutGridOnCommand')
    control=grid.controlDefinition
    print('grid definition',control.objectType)
    if hasattr(control,'isChecked') and control.isChecked:
        control.isChecked=False
    set_camera('iso')
    capture('iso','assembled.png')


def correct_front_reference():
    app,d=app_design()
    if d.rootComponent.attributes.itemByName(GROUP,'front_reference'):
        raise RuntimeError('Front reference already corrected')
    c=component(d,'01 Main housing')
    for name,expr in (
        ('Right power button mounting hole sketch / plane','-CaseWidth/2-1 mm'),
        ('Left USB service-insert opening sketch / plane','CaseWidth/2-Wall-1 mm')):
        plane=c.constructionPlanes.itemByName(name)
        sign=c.yZConstructionPlane.geometry.normal.x
        plane.definition.offset.expression=expr if sign>0 else '-('+expr+')'
    fittings=component(d,'06 Gas fitting envelopes TBD')
    for collection in (fittings.bRepBodies,fittings.features,fittings.sketches,fittings.constructionPlanes):
        for obj in collection:
            obj.name=obj.name.replace('Left inlet','TEMP_IN').replace('Right exhaust','Left inlet').replace('TEMP_IN','Right exhaust')
    d.rootComponent.attributes.add(GROUP,'front_reference','X increases toward the viewer\'s left; USB +X, button -X')
    d.computeAll()
    print('Side assignments verified against the front viewing direction')


def build_hardware():
    app,d=app_design()
    if d.rootComponent.attributes.itemByName(GROUP,'stage').value!='chamber':
        raise RuntimeError('Hardware stage requires chamber stage')
    display=new_component(d.rootComponent,'07 Guition 4.3in envelope — depth TBD')
    db=box(display,'Guition module envelope','-DisplayWidth/2','DisplayBottom','Wall+0.3 mm',
           'DisplayWidth','DisplayHeight','DisplayDepth')
    display.attributes.add(GROUP,'provisional','XY outline verified; depth, mounting and connector protrusions variant-dependent')
    screen=new_component(d.rootComponent,'08 Active display reference')
    box(screen,'4.3in active screen','-ActiveWidth/2','DisplayBottom+(DisplayHeight-ActiveHeight)/2',
        'Wall+0.2 mm','ActiveWidth','ActiveHeight','0.1 mm')
    # Removable carrier behind the display; open lower bay allows pack removal first.
    carrier=new_component(d.rootComponent,'09 Removable electronics carrier')
    for x in ('-35 mm','32 mm'):
        box(carrier,'Carrier side rail',x,'10 mm','19 mm','3 mm','117 mm','3 mm')
    rail=box(carrier,'Carrier top crossbar','-35 mm','124 mm','19 mm','70 mm','3 mm','3 mm','join')
    box(carrier,'Carrier middle crossbar','-35 mm','87 mm','19 mm','70 mm','3 mm','3 mm','join')
    # Carrier feet are supported by rear-accessible posts; actual display mount retained as TBD.
    shell=component(d,'01 Main housing')
    for x in ('-38 mm','38 mm'):
        for y in ('20 mm','124 mm'):
            footx='-41 mm' if x.startswith('-') else '32 mm'
            box(carrier,'Carrier mounting foot',footx,'('+y+')-3 mm','19 mm','9 mm','6 mm','3 mm','join')
            cylinder(carrier,'Carrier M3 clearance',x,y,'18.9 mm','1.7 mm','3.2 mm','cut',rail)
            post=cylinder(shell,'Carrier support',x,y,'Wall','3 mm','19 mm-Wall','join')
            cylinder(shell,'Carrier support pilot',x,y,'14 mm','InsertRadius','5.1 mm','cut',post)
    pcb=new_component(d.rootComponent,'10 Future PCB and component envelope TBD')
    box(pcb,'Future PCB envelope — not routed KiCad board','-32 mm','14 mm','23 mm','64 mm','108 mm','1.6 mm')
    box(pcb,'Lower PCB component allowance','-27 mm','18 mm','18.5 mm','54 mm','66 mm','4.5 mm')
    box(pcb,'Upper PCB component allowance','-27 mm','93 mm','18.5 mm','54 mm','28 mm','4.5 mm')
    pcb.attributes.add(GROUP,'provisional','64x108 board allocation is a packaging target only; component heights and circuit placement pending')
    holder=new_component(d.rootComponent,'11 Protected FMA holder envelope TBD')
    hb=box(holder,'FMA holder envelope TBD','-22 mm','12 mm','27 mm','44 mm','76 mm','28 mm')
    box(holder,'Two-cell cavity envelope','-20 mm','16 mm','29 mm','40 mm','68 mm','27 mm','cut',hb)
    cells=new_component(d.rootComponent,'12 Two 18650 cell envelopes')
    for x in ('-10 mm','10 mm'):
        s=circle_xz(cells,'18650 envelope',x,'39 mm','9.3 mm',y_expr='17 mm')
        f=extrude_axis(cells,s,'65.5 mm','18650 cell envelope','y')
        f.bodies.item(0).name='18650 — 3400mAh owner confirmed'
    holder.attributes.add(GROUP,'provisional','Actual FMA holder dimensions, latch, protection board and cable exit must be measured')
    plug=new_component(d.rootComponent,'13 Battery plug and cable clearance TBD')
    box(plug,'RCY BEC disconnect clearance','23 mm','18 mm','38 mm','10 mm','22 mm','14 mm')
    # Left-side USB insert sits inside the shell opening and is backed by an internal flange.
    usb=new_component(d.rootComponent,'14 Supported USB-C mounting insert TBD')
    ub=side_box(usb,'Replaceable USB insert','CaseWidth/2-Wall','UsbY-9.75 mm','UsbZ-7.75 mm',
                'Wall','19.5 mm','15.5 mm')
    flange=side_box(usb,'USB interior backing flange','CaseWidth/2-Wall-2 mm','UsbY-12 mm','UsbZ-10 mm',
                    '2 mm','24 mm','20 mm')
    side_box(usb,'USB aperture envelope — GCT step profile TBD','CaseWidth/2-Wall-2.1 mm','UsbY-4.82 mm',
             'UsbZ-1.93 mm','Wall+2.2 mm','9.64 mm','3.86 mm',ub)
    side_box(usb,'USB backing aperture','CaseWidth/2-Wall-2.1 mm','UsbY-4.82 mm','UsbZ-1.93 mm',
             '2.2 mm','9.64 mm','3.86 mm',flange)
    usbboard=new_component(d.rootComponent,'15 USB daughterboard envelope 0.60mm')
    box(usbboard,'USB daughterboard — layout TBD','29 mm','UsbY-8 mm','UsbZ-0.3 mm','12 mm','16 mm','0.60 mm')
    box(usbboard,'GCT connector envelope TBD','34 mm','UsbY-4.5 mm','UsbZ-1.5 mm','CaseWidth/2-34 mm','9 mm','3 mm')
    for yy in ('UsbY-8 mm','UsbY+6 mm'):
        box(usb,'USB board support ledge','29 mm',yy,'UsbZ-2.3 mm','CaseWidth/2-Wall-2 mm-29 mm','2 mm','2 mm')
    button=new_component(d.rootComponent,'16 Right momentary button envelope TBD')
    bb=side_circle(button,'12 mm button barrel envelope','-CaseWidth/2','ButtonY','ButtonZ','5.8 mm','18 mm')
    side_circle(button,'Power button bezel envelope','-CaseWidth/2-1.5 mm','ButtonY','ButtonZ','7 mm','1.5 mm')
    side_box(button,'Button terminal clearance TBD','-CaseWidth/2+18 mm','ButtonY-6 mm','ButtonZ-6 mm',
             '7 mm','12 mm','12 mm')
    build_sensors()
    harness=new_component(d.rootComponent,'18 Wiring route clearance envelopes')
    box(harness,'Sensor loom route','-5 mm','124 mm','48 mm','10 mm','8 mm','5 mm')
    box(harness,'Main cable route','26 mm','42 mm','48 mm','6 mm','80 mm','5 mm')
    for occ in d.rootComponent.occurrences:
        occ.isGrounded=True
    checkpoint('hardware')


def build_sensors():
    app,d=app_design()
    sensors=new_component(d.rootComponent,'17 Chamber sensor envelopes TBD')
    # AO2 points toward front plenum; the rear connector allowance clears the internal lid.
    cylinder(sensors,'AO2 body diameter29.3 length31.75','9 mm','GasY','15.5 mm','14.65 mm','31.75 mm')
    cylinder(sensors,'AO2 M16 neck envelope — no final thread','9 mm','GasY','9 mm','8 mm','6.5 mm')
    box(sensors,'AO2 connector and cable allowance','4 mm','GasY-5 mm','47.25 mm','10 mm','10 mm','6.5 mm')
    box(sensors,'ZE07-CO total envelope','-32.4 mm','ChamberBottom+13 mm','16 mm','25.4 mm','22.4 mm','21.75 mm')
    box(sensors,'MD62 body envelope','-26 mm','ChamberBottom+3 mm','8 mm','19 mm','9.5 mm','14 mm')
    box(sensors,'MD62 untrimmed lead allowance','-26 mm','ChamberBottom+3 mm','22 mm','19 mm','9.5 mm','26 mm')
    box(sensors,'GYBMEP humidity module envelope TBD','18 mm','GasY-8.5 mm','6.5 mm','12 mm','17 mm','5 mm')
    sensors.attributes.add(GROUP,'provisional','Sensor retainers, actual BME board, gas distribution and thermal effects are unverified')


def refine_fit():
    app,d=app_design()
    if d.rootComponent.attributes.itemByName(GROUP,'refined'):
        raise RuntimeError('Fit refinement already applied')
    d.userParameters.itemByName('ButtonY').expression='102 mm'
    usb=component(d,'15 USB daughterboard envelope 0.60mm')
    sk=usb.sketches.itemByName('GCT connector envelope TBD sketch')
    for dim in sk.sketchDimensions:
        if abs(dim.parameter.value-0.8)<1e-6:
            dim.parameter.expression='CaseWidth/2-34 mm'
    pcb=usb.bRepBodies.itemByName('USB daughterboard — layout TBD')
    box(usb,'USB straddle-mount board clearance TBD','33.9 mm','UsbY-4.6 mm','UsbZ-0.4 mm',
        '8 mm','9.2 mm','0.8 mm','cut',pcb)
    # Recreate only the owned sensor envelopes to place humidity upstream of the heater.
    old=[o for o in d.rootComponent.occurrences if o.component.name=='17 Chamber sensor envelopes TBD'][0]
    old.deleteMe()
    build_sensors()
    # Chamber attachment uses M2 pilots to retain wall around its small support posts.
    housing=component(d,'01 Main housing')
    for sk in housing.sketches:
        if sk.name.startswith('Cartridge support pilot'):
            for dim in sk.sketchDimensions:
                if isinstance(dim,fusion.SketchRadialDimension):
                    dim.parameter.expression='1.3 mm'
            sk.name=sk.name.replace('M3','M2')
    d.rootComponent.attributes.add(GROUP,'refined','Button clearance, USB slot and upstream humidity positioning')
    d.computeAll()
    checkpoint('refined')


def finish_mechanics():
    app,d=app_design()
    if d.rootComponent.attributes.itemByName(GROUP,'mechanics_finished'):
        raise RuntimeError('Mechanics stage already complete')
    chamber=component(d,'03 Removable sampling chamber')
    for sk in chamber.sketches:
        if sk.name.startswith('Cartridge clearance'):
            for dim in sk.sketchDimensions:
                if isinstance(dim,fusion.SketchRadialDimension):
                    dim.parameter.expression='1.2 mm'
    usb=component(d,'14 Supported USB-C mounting insert TBD')
    for sk in usb.sketches:
        if sk.name.startswith('USB board support ledge'):
            for dim in sk.sketchDimensions:
                if abs(dim.parameter.value-1.35)<1e-6:
                    dim.parameter.expression='CaseWidth/2-Wall-2 mm-29 mm'
    target=usb.bRepBodies.itemByName('Replaceable USB insert')
    bodies=core.ObjectCollection.create()
    for body in usb.bRepBodies:
        if body!=target:
            bodies.add(body)
    ci=usb.features.combineFeatures.createInput(target,bodies)
    ci.operation=fusion.FeatureOperations.JoinFeatureOperation
    ci.isKeepToolBodies=False
    usb.features.combineFeatures.add(ci).name='Unite USB insert, backing flange and board supports'
    target.name='USB mounting insert with integral board supports — seal TBD'
    rear=component(d,'02 Single rear cover')
    rb=rear.bRepBodies.item(0)
    metal=new_component(d.rootComponent,'19 Rear M3 fastener envelopes TBD')
    for side in (-1,1):
        x=('-CaseWidth/2+BossInset' if side<0 else 'CaseWidth/2-BossInset')
        for idx,y in enumerate(('8 mm','CaseHeight/2','CaseHeight-8 mm')):
            cylinder(rear,'M3 head recess',x,y,'CaseDepth-1.8 mm','3 mm','1.9 mm','cut',rb)
            ins=cylinder(metal,'M3 heat-set insert envelope',x,y,'CaseDepth-Cover-InsertDepth',
                         'InsertRadius','InsertDepth')
            cylinder(metal,'Insert thread clearance envelope',x,y,'CaseDepth-Cover-InsertDepth',
                     '1.55 mm','InsertDepth','cut',ins)
            cylinder(metal,'M3 screw shaft envelope',x,y,'CaseDepth-5.8 mm','1.45 mm','4 mm')
            cylinder(metal,'M3 low head envelope',x,y,'CaseDepth-1.8 mm','2.75 mm','1.8 mm')
    metal.attributes.add(GROUP,'provisional','Unthreaded hardware envelopes; actual insert and screw dimensions must be matched')
    d.rootComponent.attributes.add(GROUP,'mechanics_finished','true')
    checkpoint('mechanics')


def run(_context: str):
    raise RuntimeError('Invoke a named stage explicitly; no implicit rebuild.')
