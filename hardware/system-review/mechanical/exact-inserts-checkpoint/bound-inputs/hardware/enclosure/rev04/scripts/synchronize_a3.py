"""Parametric mounting datums and reversible size checks for Revision04 / A3."""
import json
import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
from fusion_helpers import circle_xy

def bind_display_details():
    """Keep illustrative components at fixed offsets within the purchased screen."""
    _,d=b.get()
    c=b.comp('06 Guition PCB and connectors — illustrative detail')
    positions=[('ESP32-P4 visual reference',15,75),
               ('ESP32-C6 radio module reference',47,90),
               ('Memory package reference',34,79),('Power inductor reference',14,18),
               ('Board IC reference',24,23),('Rear USB connector reference',30,9),
               ('Display FPC latch reference',23,62),('Expansion header reference',52,34)]
    for name,x,y in positions:
        sk=c.sketches.itemByName(name+' sketch')
        if not sk or sk.sketchDimensions.count!=4:
            raise RuntimeError('Unexpected screen detail sketch: '+name)
        sk.sketchDimensions.item(0).parameter.expression=f'{x} mm+DisplayX-2.85 mm'
        sk.sketchDimensions.item(1).parameter.expression=f'{y} mm+DisplayY-4.1 mm'
    c.attributes.add(b.GROUP,'display_details_bound','Fixed offsets from DisplayX/DisplayY; sizes unchanged')
    if not d.computeAll(): raise RuntimeError('Display detail binding failed')
    b.checkpoint('purchased display detail positioning')

def bind_rear_hardware():
    _,d=b.get(); root=d.rootComponent; count=0
    for o in root.occurrences:
        attr=o.attributes.itemByName(b.GROUP,'position_expressions')
        if not attr or o.attributes.itemByName(b.GROUP,'joint_bound'): continue
        expressions=json.loads(attr.value)
        axis=o.attributes.itemByName(b.GROUP,'mount_axis')
        axis=axis.value if axis else 'z'
        if axis=='x':
            sk=circle_xy(root,'USB parametric mounting point '+str(count+1),
                         expressions[0],expressions[1],'0.1 mm',expressions[2])
            geom=fusion.JointGeometry.createByPoint(sk.sketchCurves.sketchCircles.item(0).centerSketchPoint)
            direction=root.sketches.add(root.xZConstructionPlane)
            direction.name='Negative Z orientation datum '+str(count+1)
            end=direction.modelToSketchSpace(core.Point3D.create(0,0,-1))
            line=direction.sketchCurves.sketchLines.addByTwoPoints(direction.originPoint,end)
            line.isFixed=True
            line.startSketchPoint.isFixed=True
            line.endSketchPoint.isFixed=True
            ji=root.jointOrigins.createInput(geom)
            ji.xAxisEntity=line; ji.zAxisEntity=root.xConstructionAxis
            sk.isLightBulbOn=False; direction.isLightBulbOn=False
        else:
            geom=fusion.JointGeometry.createByPoint(root.originConstructionPoint)
            ji=root.jointOrigins.createInput(geom)
            ji.offsetX=core.ValueInput.createByString(expressions[0])
            ji.offsetY=core.ValueInput.createByString(expressions[1])
            ji.offsetZ=core.ValueInput.createByString(expressions[2])
        origin=root.jointOrigins.add(ji); origin.name='Parametric mounting datum '+str(count+1)
        source=fusion.JointGeometry.createByPoint(o.component.originConstructionPoint.createForAssemblyContext(o))
        inp=root.joints.createInput(source,origin)
        inp.setAsRigidJointMotion(); inp.isFlipped=False
        joint=root.joints.add(inp); joint.name='Parametric '+o.name
        expected=core.Matrix3D.create()
        if axis=='x':
            from math import pi
            expected.setToRotation(pi/2,core.Vector3D.create(0,1,0),core.Point3D.create(0,0,0))
        expected.translation=core.Vector3D.create(*[b.mm(d,e)/10 for e in expressions])
        actual=o.transform2.asArray()
        if max(abs(a-v) for a,v in zip(actual,expected.asArray()))>1e-6:
            raise RuntimeError('Unexpected joint orientation: '+o.name+' '+str(actual))
        o.attributes.add(b.GROUP,'joint_bound','true')
        origin.isLightBulbOn=False; joint.isLightBulbOn=False
        count+=1
    b.checkpoint('parametric hardware mounting datums')
    print(json.dumps({'bound_occurrences':count}))

