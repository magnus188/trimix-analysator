"""Actual A3 Fusion view exports and reversible physical-group exploded poses.

Explicit calls only. style() assigns appearance; export_views() temporarily
changes visibility/camera and creates/deletes section analyses. exploded() moves
occurrences temporarily with joints suppressed, then verifies pose restoration.
Never treat generated PNGs as manufacturing or passed service evidence.
"""
from datetime import datetime, timezone
from pathlib import Path
import json
import adsk
import adsk.core as core
import adsk.fusion as fusion
from audit_a3 import _owned_design, _bodies, attribute, write_report

BASE = Path(__file__).resolve().parents[1]
DIRECTIONS = {'front': (0,0,-50), 'rear': (0,0,50), 'left': (50,0,0),
              'right': (-50,0,0), 'iso': (35,25,-45), 'rear_iso': (-35,25,45), 'top': (0,50,0)}


def _mm(design, expression):
    return design.unitsManager.evaluateExpression(expression, 'mm')*10


def camera(view='iso'):
    app, d = _owned_design(); delta = DIRECTIONS[view]
    target = core.Point3D.create(*[_mm(d, e)/20 for e in ('CaseWidth','CaseHeight','CaseDepth')])
    cam = app.activeViewport.camera; cam.cameraType = core.CameraTypes.OrthographicCameraType
    cam.target = target; cam.eye = core.Point3D.create(*[v+w for v,w in zip((target.x,target.y,target.z),delta)])
    cam.upVector = core.Vector3D.create(0,0,-1) if view == 'top' else core.Vector3D.create(0,1,0)
    cam.isFitView = True; cam.isSmoothTransition = False
    app.activeViewport.camera = cam; adsk.doEvents(); app.activeViewport.refresh()


def capture(view, filename):
    app, _ = _owned_design(); camera(view)
    path = BASE/'views'/filename; path.parent.mkdir(parents=True, exist_ok=True)
    options = core.SaveImageFileOptions.create(str(path))
    options.width = 1600; options.height = 1800
    options.isBackgroundTransparent = True; options.isAntiAliased = True
    if not app.activeViewport.saveAsImageFileWithOptions(options): raise RuntimeError('View capture failed: '+filename)
    return str(path)


def style():
    app, d = _owned_design(); lib = app.materialLibraries.itemByName('Fusion Appearance Library')
    if not d.activateRootComponent():raise RuntimeError('Cannot activate the complete assembly for review')
    appearances = {}
    for key, ident in (('case','Prism-116'),('dark','Prism-113'),('blue','Prism-115'),('green','Prism-117'),('red','Prism-120'),('brass','Prism-040')):
        a = d.appearances.itemByName('A3 '+key)
        if not a: a = d.appearances.addByCopy(lib.appearances.itemById(ident), 'A3 '+key)
        appearances[key] = a
    for c in d.allComponents:
        c.isOriginFolderLightBulbOn = False
        if attribute(c,'preserve_appearance') == 'true': continue
        group = attribute(c,'physical_group'); name = c.name.lower()
        key = {'chamber':'blue','chamber_lid':'blue','pcb':'green','display_retainers':'case','gas_fittings':'brass'}.get(group,'case')
        if 'factory casing' in name or 'glass' in name or 'button body' in name: key = 'dark'
        if 'pcb' in name: key = 'green'
        if 'active 4.3' in name: key = 'blue'
        if 'momentary power cap' in name: key = 'green'
        if attribute(c,'hardware_kind') == 'insert': key = 'brass'
        if attribute(c,'hardware_kind') == 'screw': key = 'dark'
        for body in c.bRepBodies:
            body_name = body.name.lower()
            color = 'dark' if name.startswith('06 ') and 'pcb outline' not in body_name else key
            # Distinguish purchased reference bodies from the blue manifold;
            # these review colours do not assert supplier material or finish.
            if name.startswith('sensor /'):
                color = 'case'
                if 'pcb' in body_name: color = 'green'
                elif 'lead' in body_name: color = 'brass'
                elif any(word in body_name for word in ('header','connector','regulator')): color = 'dark'
            if name.startswith('usb a3'):
                if any(word in name for word in ('gasket','insulator','tongue')): color = 'dark'
                elif 'contact' in name: color = 'brass'
            body.appearance = appearances[color]
    app.activeViewport.visualStyle = core.VisualStyles.ShadedWithVisibleEdgesOnlyVisualStyle
    command = app.userInterface.commandDefinitions.itemById('ViewLayoutGridOnCommand')
    if command and hasattr(command.controlDefinition, 'isChecked'): command.controlDefinition.isChecked = False
    camera('iso')


def _visibility(design):
    return ([(o,o.isLightBulbOn) for o in design.rootComponent.allOccurrences],
            [(body,body.isLightBulbOn) for c in design.allComponents for body in c.bRepBodies],
            [(a,a.isLightBulbOn) for a in design.analyses.sectionAnalyses], design.analyses.isLightBulbOn)


def _restore_visibility(design, snapshot):
    for entity, state in snapshot[0]+snapshot[1]+snapshot[2]:
        if entity.isValid: entity.isLightBulbOn = state
    design.analyses.isLightBulbOn = snapshot[3]


def _show_assembly(design):
    if not design.activateRootComponent():raise RuntimeError('Cannot show the complete assembly')
    for a in design.analyses.sectionAnalyses: a.isLightBulbOn = False
    for c in design.allComponents:
        c.isOriginFolderLightBulbOn = False
        for s in c.sketches:s.isLightBulbOn=False
        for p in c.constructionPlanes:p.isLightBulbOn=False
        for body in c.bRepBodies: body.isLightBulbOn = True
    for o in design.rootComponent.allOccurrences: o.isLightBulbOn = True


def _section(design, plane, coordinate_mm, axis, view, name):
    normal = plane.geometry.normal
    coordinate = {'x':normal.x,'y':normal.y,'z':normal.z}[axis]
    analysis = design.analyses.sectionAnalyses.add(design.analyses.sectionAnalyses.createInput(plane, coordinate_mm/10*coordinate))
    analysis.name = 'A3 review temporary '+name
    try:
        design.analyses.isLightBulbOn = True; analysis.isLightBulbOn = True; analysis.isHatchShown = True
        direction = DIRECTIONS[view]
        if sum(v*w for v,w in zip((normal.x,normal.y,normal.z),direction)) < 0: analysis.flip()
        adsk.doEvents()
        path = capture(view, name+'.png')
    finally:
        if analysis.isValid: analysis.deleteMe()
    return path


def export_views():
    app, d = _owned_design(); before = _bodies(d); timeline = d.timeline.count
    visibility = _visibility(d); original_camera = app.activeViewport.camera
    paths = {}; success = False
    try:
        _show_assembly(d)
        for v in ('front','rear','left','right','iso'):
            paths['assembled' if v=='iso' else v] = capture(v, ('assembled' if v=='iso' else v)+'.png')
        hidden = [o for o in d.rootComponent.allOccurrences if (attribute(o,'physical_group') or attribute(o.component,'physical_group')) == 'rear_cover']
        if not hidden: raise RuntimeError('No tagged rear cover to hide')
        for o in hidden: o.isLightBulbOn = False
        paths['rear-open'] = capture('rear_iso','rear-open.png')
        _show_assembly(d)
        paths['section-aa'] = _section(d, d.rootComponent.yZConstructionPlane, _mm(d,'HolderX+HolderWidth/2'), 'x','right','section-aa')
        paths['section-bb'] = _section(d, d.rootComponent.xZConstructionPlane, _mm(d,'GasY'), 'y','top','section-bb')
        success = True
    finally:
        _restore_visibility(d, visibility); app.activeViewport.camera = original_camera; adsk.doEvents(); app.activeViewport.refresh()
    unchanged = _bodies(d) == before and d.timeline.count == timeline
    if not unchanged: raise AssertionError('Section/view export changed persistent solid geometry')
    report = {'created_utc':datetime.now(timezone.utc).isoformat(), 'status':'captured_pending_visual_QA' if success else 'incomplete',
              'paths':paths, 'section_aa':'X=HolderX+HolderWidth/2; camera from -X; screen left, rear cover right',
              'section_bb':'Y=GasY; top camera from +Y; front at image top, rear at image bottom',
              'left_right':'Viewed from screen, +X is left; left view camera from +X',
              'persistent_geometry_unchanged':unchanged, 'section_analyses_deleted_after_capture':True}
    write_report('view-exports.json',report); print(json.dumps(report)); return report


def exploded():
    app, d = _owned_design(); root = d.rootComponent
    if root.occurrences.count != root.allOccurrences.count: raise RuntimeError('Exploded export expects flat A3 root occurrences; nested groups need explicit transforms')
    before = _bodies(d); timeline = d.timeline.count
    visibility = _visibility(d); original_camera = app.activeViewport.camera
    delta = {'housing':[0,0,0], 'rear_cover':[95,0,105], 'display':[0,0,-45],
             'display_retainers':[-45,-5,20], 'carrier':[50,-10,40], 'pcb':[50,-10,55],
             'battery':[-40,-15,40], 'disconnect':[-40,-15,45], 'button':[40,0,0],
             'usb':[0,-45,5], 'chamber':[0,35,30], 'chamber_lid':[0,35,75], 'gas_fittings':[0,35,30]}
    plans=[]
    for o in root.occurrences:
        group=attribute(o,'physical_group') or attribute(o.component,'physical_group')
        if group not in delta: raise RuntimeError('No exploded physical group for '+o.fullPathName)
        move=list(delta[group]); raw=attribute(o.component,'hardware_definition'); h=json.loads(raw) if raw else None
        direction=None
        if h and h['kind']=='screw':
            v=core.Vector3D.create(0,0,1); v.transformBy(o.transform2); direction=[v.x,v.y,v.z]
            move=[a+b*12 for a,b in zip(move,direction)]
        if attribute(o.component,'battery_role')=='disconnect_mate': move[2]+=8
        if group=='gas_fittings':
            bounds=o.boundingBox; centre=(bounds.minPoint.x+bounds.maxPoint.x)*5
            move[0]+=25 if centre>_mm(d,'CaseWidth')/2 else -25
        pose=o.transform2.copy(); moved=pose.copy(); t=moved.translation
        moved.translation=core.Vector3D.create(t.x+move[0]/10,t.y+move[1]/10,t.z+move[2]/10)
        plans.append((o,pose,moved,{'occurrence':o.fullPathName,'component':o.component.name,'group':group,
                                  'delta_mm':move,'installed_matrix':pose.asArray(),'exploded_matrix':moved.asArray(),
                                  'separated_screw_axis':direction}))
    joints=[(j,j.isSuppressed) for j in root.joints]
    report={'created_utc':datetime.now(timezone.utc).isoformat(), 'status':'prepared_recovery_poses',
            'poses':[p[3] for p in plans], 'joint_states':[{'name':j.name,'suppressed':s} for j,s in joints],
            'interpretation':'Physical assembly relationships; separated poses are not removal trajectories.'}
    write_report('exploded-poses.json',report)
    try:
        _show_assembly(d)
        for j,_ in joints: j.isSuppressed=True
        for o,_,pose,_ in plans: o.transform2=pose
        adsk.doEvents(); app.activeViewport.refresh()
        report['path']=capture('rear_iso','exploded.png')
    finally:
        for o,pose,_,_ in plans: o.transform2=pose
        for j,state in joints: j.isSuppressed=state
        if not d.computeAll(): raise RuntimeError('Exploded pose restoration failed recompute')
        _restore_visibility(d,visibility); app.activeViewport.camera=original_camera; adsk.doEvents(); app.activeViewport.refresh()
        restored=all(max(abs(a-b) for a,b in zip(o.transform2.asArray(),pose.asArray()))<1e-7 for o,pose,_,_ in plans)
        report['poses_restored']=restored; report['persistent_geometry_unchanged']=before==_bodies(d) and timeline==d.timeline.count
        report['status']='captured_and_restored_pending_visual_QA' if restored and report['persistent_geometry_unchanged'] and report.get('path') else 'needs_review'
        write_report('exploded-poses.json',report)
        if not restored or not report['persistent_geometry_unchanged']: raise AssertionError('Exploded view did not restore installed geometry')
    print(json.dumps({'status':report['status'],'path':report.get('path')})); return report
