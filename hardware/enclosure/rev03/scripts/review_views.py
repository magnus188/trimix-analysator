"""Styled assembly views and reversible exploded-pose exports from actual Fusion CAD."""
import json
import adsk.core as core
import build_rev03 as b

def camera(view='iso'):
    app,d=b.get()
    target=core.Point3D.create(b.mm(d,'CaseWidth')/20,b.mm(d,'CaseHeight')/20,b.mm(d,'CaseDepth')/20)
    directions={'front':(0,0,-50),'rear':(0,0,50),'left':(50,0,0),'right':(-50,0,0),
                'iso':(35,25,-45),'rear_iso':(-35,25,45)}
    dx,dy,dz=directions[view]
    cam=app.activeViewport.camera
    cam.cameraType=core.CameraTypes.OrthographicCameraType
    cam.eye=core.Point3D.create(target.x+dx,target.y+dy,target.z+dz)
    cam.target=target; cam.upVector=core.Vector3D.create(0,1,0)
    cam.isFitView=True; cam.isSmoothTransition=False
    app.activeViewport.camera=cam; app.activeViewport.refresh()

def capture(view,filename):
    app,d=b.get(); camera(view)
    path=b.BASE/'views'/filename; path.parent.mkdir(parents=True,exist_ok=True)
    opts=core.SaveImageFileOptions.create(str(path))
    opts.width=1500; opts.height=1700
    opts.isBackgroundTransparent=True; opts.isAntiAliased=True
    if not app.activeViewport.saveAsImageFileWithOptions(opts): raise RuntimeError('Viewport export failed')
    print(str(path))

def style():
    app,d=b.get()
    lib=app.materialLibraries.itemByName('Fusion Appearance Library')
    ap={}
    for key,ident in [('case','Prism-116'),('dark','Prism-113'),('blue','Prism-115'),
                      ('green','Prism-117'),('red','Prism-120'),('brass','Prism-040')]:
        name='Rev03 '+key
        a=d.appearances.itemByName(name)
        if not a: a=d.appearances.addByCopy(lib.appearances.itemById(ident),name)
        ap[key]=a
    for c in d.allComponents:
        c.isOriginFolderLightBulbOn=False
        if c.attributes.itemByName(b.GROUP,'preserve_appearance'): continue
        n=c.name.lower()
        key='case'
        if 'glass' in n or 'factory casing' in n or 'button body' in n: key='dark'
        if 'pcb' in n or 'humidity' in n: key='green'
        if 'chamber' in n or 'active 4.3' in n: key='blue'
        if 'insert' in n or 'ao2' in n or 'md62' in n: key='brass'
        if 'green momentary' in n: key='green'
        if 'seal' in n: key='dark'
        for body in c.bRepBodies:
            color=key
            if n.startswith('06 ') and body.name!='Guition PCB outline reference': color='dark'
            body.appearance=ap[color]
    d.rootComponent.isOriginFolderLightBulbOn=False
    app.activeViewport.visualStyle=core.VisualStyles.ShadedWithVisibleEdgesOnlyVisualStyle
    grid=app.userInterface.commandDefinitions.itemById('ViewLayoutGridOnCommand').controlDefinition
    if hasattr(grid,'isChecked') and grid.isChecked: grid.isChecked=False
    camera('iso')

def closed_views():
    app,d=b.get()
    for analysis in d.analyses.sectionAnalyses: analysis.isLightBulbOn=False
    for c in d.allComponents:
        for body in c.bRepBodies: body.isLightBulbOn=True
    for o in d.rootComponent.occurrences: o.isLightBulbOn=True
    for view in ('front','rear','left','right'): capture(view,view+'.png')
    capture('iso','assembled.png')

def open_view():
    _,d=b.get()
    hide=[]
    for o in d.rootComponent.occurrences:
        n=o.component.name
        kind=o.component.attributes.itemByName(b.GROUP,'hardware_definition')
        is_rear_screw=kind and json.loads(kind.value)['kind']=='screw' and json.loads(kind.value)['size']=='M3'
        if n=='02 Single rear cover' or is_rear_screw: hide.append(o)
    try:
        for o in hide: o.isLightBulbOn=False
        capture('rear_iso','rear-open.png')
    finally:
        for o in hide: o.isLightBulbOn=True

def section_view():
    _,d=b.get(); name='A-A measured battery and display stack'
    a=next((a for a in d.analyses.sectionAnalyses if a.name==name),None)
    # Recreate this owned display analysis so a previous flip state cannot
    # reverse a later export. Analyses do not modify the design's solid bodies.
    if a: a.deleteMe()
    plane=d.rootComponent.yZConstructionPlane
    a=d.analyses.sectionAnalyses.add(d.analyses.sectionAnalyses.createInput(plane,
        (b.mm(d,'CaseWidth')/20)*plane.geometry.normal.x))
    a.name=name
    d.analyses.isLightBulbOn=True
    # Remove the viewer-facing (-X) half for the right-side camera.
    a.flip()
    a.isLightBulbOn=True
    a.isHatchShown=True
    try: capture('right','section.png')
    finally: a.isLightBulbOn=False

def exploded():
    """Explode physical groups, separate each screw on its true axis, restore poses.

    Inserts stay with their receiving housing/cartridge. Service metadata has
    priority over reusable hardware definition names. Retained JSON contains
    every installed and exploded transform for future animation/review work.
    """
    from datetime import datetime, timezone
    app,d=b.get()
    original_camera=app.activeViewport.camera
    base={
        'housing':[0,0,0], 'rear_cover':[80,0,125],
        'display':[0,0,-45], 'display_retainers':[-60,15,10],
        'carrier':[-55,-5,65], 'pcb':[-55,-5,73],
        'battery':[0,-25,35], 'chamber':[18,30,25], 'chamber_lid':[18,30,75],
        'usb':[50,-15,10], 'usb_clamp':[50,-15,35], 'button':[-35,0,15],
    }

    def attr(entity,name):
        a=entity.attributes.itemByName(b.GROUP,name)
        return a.value if a else None

    def plus(one,two):
        return [a+v for a,v in zip(one,two)]

    def screw_delta(o,owner,separation):
        axis=core.Vector3D.create(0,0,1)
        if not axis.transformBy(o.transform2):
            raise RuntimeError('Cannot resolve installed screw axis: '+o.fullPathName)
        direction=[axis.x,axis.y,axis.z]
        return plus(base[owner],[v*separation for v in direction]),direction

    snapshots=[]; manifest=[]; plans=[]
    # Resolve all roles and installed poses before changing any geometry pose.
    for o in d.rootComponent.occurrences:
        c=o.component; n=c.name
        service=attr(o,'service_group') or attr(c,'service_group')
        sub=attr(o,'subassembly') or attr(c,'subassembly')
        role=attr(o,'service_role') or attr(c,'service_role')
        raw=attr(c,'hardware_definition'); hardware=json.loads(raw) if raw else None
        installed=o.transform2.copy(); translation=installed.translation
        installed_mm=[translation.x*10,translation.y*10,translation.z*10]
        owner='housing'; delta=list(base[owner]); axis=None; source='fixed housing/default'
        if hardware:
            kind=hardware['kind']
            # An insert belongs to its receiving part, not to a detached screw.
            if service=='chamber_lid_fastener':
                owner='chamber_lid' if kind=='screw' else 'chamber'
                source='service_group=chamber_lid_fastener'
            elif service=='chamber_mount_screw':
                owner='chamber'; source='service_group=chamber_mount_screw'
            elif service=='chamber_mount_insert':
                owner='housing'; source='stationary chamber mounting insert'
            elif sub=='removable USB insert':
                owner='usb'; source='subassembly=removable USB insert'
            elif role=='USB housing clamp screw' or sub=='USB housing clamp':
                owner='usb_clamp'; source='USB removable clamp metadata'
            elif sub=='USB housing fixed retention':
                owner='housing'; source='USB fixed housing insert metadata'
            elif kind=='insert':
                owner='housing'; source='installed housing insert; no movable-owner metadata'
            elif kind=='screw' and hardware['size']=='M3' and abs(installed_mm[2]-b.mm(d,'CaseDepth'))<1e-4:
                owner='rear_cover'; source='M3 rear-cover seating datum'
            elif kind=='screw' and abs(installed_mm[2]-47.25)<1e-4 and any(
                abs(installed_mm[0]-x)<1e-4 and abs(installed_mm[1]-y)<1e-4
                for x,y in [(6,18),(6,77),(40,14)]):
                owner='pcb'; source='three shared carrier/PCB M2 seating datums'
            elif kind=='screw' and abs(installed_mm[2]-22.3)<1e-4 and any(
                abs(installed_mm[0]-x)<1e-4 and abs(installed_mm[1]-y)<1e-4
                for x,y in [(52,11),(14,119)]):
                owner='display_retainers'; source='two display-retainer M2 seating datums'
            else:
                raise RuntimeError('Unclassified exploded hardware occurrence: '+o.fullPathName)
            if kind=='screw':
                delta,axis=screw_delta(o,owner,14 if owner=='rear_cover' else 12)
            else:
                delta=list(base[owner])
        elif n=='02 Single rear cover':
            owner='rear_cover'; delta=list(base[owner]); source='rear cover component'
        elif n.startswith(('03 ','04 ','05 ','06 ')):
            owner='display'; delta=list(base[owner]); source='complete factory display grouping'
        elif n.startswith('Display /'):
            owner='display_retainers'; delta=list(base[owner]); source='removable display-retainer component'
        elif n.startswith('Carrier /'):
            owner='pcb' if 'PCB' in n else 'carrier'
            delta=list(base[owner]); source='carrier/PCB component role'
        elif n.startswith('Battery /'):
            owner='battery'; delta=list(base[owner]); source='protected pack and disconnect grouping'
            if attr(c,'battery_role')=='disconnect_mate':
                delta=plus(delta,[0,0,6]); source+='; mate separated 6 mm rearward'
        elif service=='closed_chamber':
            owner='chamber_lid' if n=='Chamber / removable internal lid' else 'chamber'
            delta=list(base[owner]); source='service_group=closed_chamber'
        elif service=='external_gas_fitting':
            owner='chamber'; delta=plus(base[owner],[25 if 'left' in n.lower() else -25,0,0])
            source='detached gas fitting, kept aligned with translated cartridge'
        elif sub=='USB housing clamp' or n=='USB — removable rear housing clamp':
            owner='usb_clamp'; delta=list(base[owner]); source='removable USB clamp component'
        elif sub=='removable USB insert' or n.startswith('USB —'):
            owner='usb'; delta=list(base[owner]); source='USB cartridge metadata/prefix'
        elif n.startswith('Controls /'):
            owner='button'; delta=list(base[owner]); source='right-side button assembly'
        exploded_pose=installed.copy()
        exploded_pose.translation=core.Vector3D.create(*[(p+q)/10 for p,q in zip(installed_mm,delta)])
        plans.append((o,exploded_pose))
        snapshots.append((o,installed,o.isLightBulbOn))
        manifest.append({
            'occurrence':o.fullPathName,'component':n,'part_number':c.partNumber,
            'physical_group':owner,'classification_basis':source,
            'service_group':service,'subassembly':sub,'hardware':hardware,
            'position_expressions':attr(o,'position_expressions'),
            'installed_transform_cm':list(installed.asArray()),
            'installed_translation_mm':installed_mm,'exploded_delta_mm':delta,
            'exploded_transform_cm':list(exploded_pose.asArray()),'screw_separation_axis':axis,
        })
    joint_states=[(j,j.isSuppressed) for j in d.rootComponent.joints]
    analysis_states=[(a,a.isLightBulbOn) for a in d.analyses.sectionAnalyses]
    destination=b.BASE/'verification'/'exploded-poses.json'
    destination.parent.mkdir(parents=True,exist_ok=True)
    report={
        'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':app.activeDocument.name,
        'view':'views/exploded.png','status':'prepared; capture not yet attempted',
        'capture_error':None,'installed_poses_restored':False,'joints_restored':False,
        'physical_group_deltas_mm':base,'occurrences':manifest,
        'original_joint_states':[{'name':j.name,'is_suppressed':state} for j,state in joint_states],
        'original_occurrence_visibility':[{'occurrence':o.fullPathName,'visible':visible} for o,_,visible in snapshots],
        'original_section_visibility':[{'name':a.name,'visible':state} for a,state in analysis_states],
        'notes':['Visual exploded arrangement, not a service motion or collision-free assembly sequence.',
                 'All screw occurrences are independently separated along their actual installed axes.',
                 'Cartridge and USB inserts move with their receiving assemblies; fixed housing inserts remain installed.',
                 'Transforms use Fusion centimetres; explicit translation vectors are millimetres.'],
    }
    # Save recovery poses before any joint suppression or instance movement.
    destination.write_text(json.dumps(report,indent=2)+'\n')
    failure=None; restored=False
    try:
        for j,_ in joint_states: j.isSuppressed=True
        for a,_ in analysis_states: a.isLightBulbOn=False
        for o,pose in plans:
            o.isLightBulbOn=True; o.transform2=pose
        capture('rear_iso','exploded.png')
    except Exception as error:
        failure=str(error)
        raise
    finally:
        for o,pose,visible in snapshots:
            o.transform2=pose; o.isLightBulbOn=visible
        for j,state in joint_states: j.isSuppressed=state
        for a,state in analysis_states: a.isLightBulbOn=state
        if not d.computeAll():
            raise RuntimeError('Fusion did not regenerate after restoring exploded poses')
        changed=[o.fullPathName for o,pose,_ in snapshots if max(
            abs(a-v) for a,v in zip(o.transform2.asArray(),pose.asArray()))>1e-7]
        if changed:
            raise RuntimeError('Exploded export did not restore installed poses: '+', '.join(changed))
        restored=True
        app.activeViewport.camera=original_camera; app.activeViewport.refresh()
        report.update({'status':'capture failed; installed poses restored' if failure else 'captured and restored',
                       'capture_error':failure,'installed_poses_restored':restored,
                       'joints_restored':all(j.isSuppressed==state for j,state in joint_states)})
        destination.write_text(json.dumps(report,indent=2)+'\n')

def export_final():
    app,d=b.get()
    b.checkpoint('reviewed compact assembly')
    path=b.BASE/(b.NAME+'.step')
    if not d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(path))):
        raise RuntimeError('STEP export failed')
    if not app.activeDocument.save('Revision 03 compact assembly; fit review and measurement checklist attached locally'):
        raise RuntimeError('Fusion cloud save failed')
    print(json.dumps({'step':str(path),'cloud_document':app.activeDocument.name,
                      'folder':app.activeDocument.dataFile.parentFolder.name}))
