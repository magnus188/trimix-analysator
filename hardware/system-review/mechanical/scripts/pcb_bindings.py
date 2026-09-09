"""Rigid board placement follows enclosure datums without scaling PCB geometry."""
import json
import re
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned,report,GROUP

def main_mount_datums():
    """Keep the physical PCB hole spacing rigid as enclosure width changes."""
    _,doc,d=owned();root=d.rootComponent
    if root.attributes.itemByName(GROUP,'main_mount_datums'):raise RuntimeError('Main mount datums already corrected')
    from audit_a3 import _bodies
    from review_checks import health
    before=_bodies(d);pattern=re.compile(r'CaseWidth\s*-\s*9\s*mm');changes=[]
    for p in d.allParameters:
        if not pattern.search(p.expression):continue
        owner=getattr(p,'createdBy',None)
        if not owner or not owner.name.startswith(('Carrier fixed support web','Carrier M2 insert pilot','Shared carrier M2 hole','Parametric mounting datum')):
            raise RuntimeError('Unexpected parameter uses carrier-only expression: '+p.name)
        new=pattern.sub('(PcbX + 25.6 mm)',p.expression)
        old_value=d.unitsManager.evaluateExpression(p.expression,'mm');new_value=d.unitsManager.evaluateExpression(new,'mm')
        if abs(old_value-new_value)>1e-8:raise RuntimeError('Retargeting would alter baseline geometry')
        changes.append({'name':p.name,'owner':owner.name,'old':p.expression,'new':new})
    if not 6<=len(changes)<=12:raise RuntimeError('Unexpected carrier datum parameter count '+str(len(changes)))
    for row in changes:d.allParameters.itemByName(row['name']).expression=row['new']
    occurrences=[]
    for o in root.occurrences:
        a=o.attributes.itemByName('TrimixRev04','position_expressions')
        if a and pattern.search(a.value):
            old=a.value;a.value=pattern.sub('(PcbX + 25.6 mm)',old)
            occurrences.append({'occurrence':o.fullPathName,'old':old,'new':a.value})
    if len(occurrences)!=2:raise RuntimeError('Expected lower carrier screw and insert metadata')
    if not d.computeAll():raise RuntimeError('Main mount datum recompute failed')
    after=_bodies(d)
    if before!=after:raise RuntimeError('Retargeting changed baseline physical geometry')
    if not health(d)['pass']:raise RuntimeError('Mount datum feature health failed')
    root.attributes.add(GROUP,'main_mount_datums','Lower mounting centre=PcbX+25.6,Y28. Actual PCB and hole spacing remain fixed as CaseWidth changes.')
    report('main-mount-datum-correction.json',{'document':doc.name,'parameters':changes,'hardware_metadata':occurrences,
        'baseline_physical_geometry_unchanged':True,'PCB_hole_centres_mm':[[76,28],[54.8,114]],
        'PCB_scaled':False,'reason':'Former allocation tied lower mounting hole to CaseWidth; real imported board has fixed hole spacing.'})

def usb():
    _,doc,d=owned();root=d.rootComponent
    o=next(q for q in root.occurrences if q.component.partNumber=='TMX-A3-B02')
    if o.attributes.itemByName(GROUP,'board_datum_joint'):raise RuntimeError('USB board is already bound')
    values=['UsbX - 8 mm','18 mm','UsbZ - 1.055 mm']
    expected=core.Matrix3D.create();expected.translation=core.Vector3D.create(*(d.unitsManager.evaluateExpression(e,'mm')for e in values))
    if max(abs(a-b)for a,b in zip(o.transform2.asArray(),expected.asArray()))>1e-7:raise RuntimeError('Unexpected board registration before binding')
    origin_geo=fusion.JointGeometry.createByPoint(root.originConstructionPoint)
    request=root.jointOrigins.createInput(origin_geo)
    request.offsetX=core.ValueInput.createByString(values[0]);request.offsetY=core.ValueInput.createByString(values[1]);request.offsetZ=core.ValueInput.createByString(values[2])
    origin=root.jointOrigins.add(request);origin.name='SystemReview USB PCB stack datum'
    source=fusion.JointGeometry.createByPoint(o.component.originConstructionPoint.createForAssemblyContext(o))
    request=root.joints.createInput(source,origin);request.setAsRigidJointMotion();request.isFlipped=False
    joint=root.joints.add(request);joint.name='SystemReview USB PCB parametric placement'
    if max(abs(a-b)for a,b in zip(o.transform2.asArray(),expected.asArray()))>1e-7:raise RuntimeError('USB joint altered purchased geometry registration')
    origin.isLightBulbOn=False;joint.isLightBulbOn=False
    o.attributes.add(GROUP,'board_datum_joint',joint.name);o.attributes.add(GROUP,'position_expressions',json.dumps(values))
    report('usb-pcb-parametric-binding.json',{'document':doc.name,'joint':joint.name,'expressions':values,'geometry_scaled':False,
      'intent':'Whole PCB moves with UsbX/UsbZ. Finished purchased PCB dimensions remain fixed.'})

def ground_usb_children():
    """Imported board is one rigid assembly; fix ungrounded STEP descendants."""
    from runtime import configure
    configure()
    from audit_a3 import _bodies
    from review_checks import health
    _,doc,d=owned();root=d.rootComponent
    parent=next(o for o in root.occurrences if o.component.partNumber=='TMX-A3-B02')
    before=_bodies(d);changed=[]
    for occurrence in root.allOccurrences:
        if not occurrence.fullPathName.startswith(parent.fullPathName+'+'):continue
        local=occurrence.nativeObject or occurrence
        if not local.isGroundToParent:
            changed.append(occurrence.fullPathName)
            local.isGroundToParent=True
    if not changed:raise RuntimeError('No ungrounded USB STEP descendants to correct')
    if not d.computeAll():raise RuntimeError('USB child grounding failed')
    if before!=_bodies(d):raise RuntimeError('Grounding changed baseline PCB shape or pose')
    if not health(d)['pass']:raise RuntimeError('Grounding introduced an unhealthy feature')
    parent.attributes.add(GROUP,'rigid_import_basis','Every descendant grounded to its parent. PCB, pads and packages move together; no geometry scaling.')
    report('usb-import-rigid-assembly.json',{'document':doc.name,'grounded_children':changed,
        'baseline_geometry_unchanged':True,'PCB_scaled':False,
        'reason':'STEP import left pads, dielectric and one resistor occurrence free while other children were grounded. Native parent motion previously left those parts behind.'})
