"""Parametric mounting datums and reversible size checks for Revision03."""
import json
import adsk.core as core
import adsk.fusion as fusion
import build_rev03 as b
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

def regeneration_test():
    from audit_rev03 import _instance_interference
    from fusion_audit import _health, _bodies
    _,d=b.get()
    original={name:d.userParameters.itemByName(name).expression for name in ('CaseWidth','CaseHeight','CaseDepth')}
    d.computeAll(); before=_bodies(d)
    # Purchased envelopes and generic fasteners must translate, never scale.
    def purchased(records):
        result={}
        prefixes=('03 ','04 ','05 ','06 ','Battery /','Sensor /','Controls /',
                  'USB — GCT','USB — contact detail')
        for rec in records:
            if rec['component'].startswith(prefixes) or 'GEN-' in rec['component']:
                result[(rec['occurrence'],rec['name'])]=(rec['bounds_mm']['size'],rec['volume_mm3'])
        return result
    measured=purchased(before); tests=[]
    try:
        for name,expression in [('CaseWidth','77 mm'),('CaseHeight','127 mm'),('CaseDepth','58 mm')]:
            d.userParameters.itemByName(name).expression=expression
            if not d.computeAll(): raise RuntimeError('Regeneration failed for '+name)
            health=_health(d); overlap=_instance_interference(d)
            now=purchased(_bodies(d))
            changed=[key for key,value in measured.items() if key not in now or
                     any(abs(a-v)>1e-4 for a,v in zip(value[0],now[key][0])) or abs(value[1]-now[key][1])>1e-3]
            tests.append({'parameter':name,'test_expression':expression,'health_pass':health['pass'],
                          'unhealthy':health['unhealthy_entities'],'interference_count':overlap['collision_count'],
                          'collisions':overlap['collisions'],'purchased_dimensions_changed':[list(k) for k in changed]})
            d.userParameters.itemByName(name).expression=original[name]
            if not d.computeAll(): raise RuntimeError('Restoration failed for '+name)
    finally:
        for name,expression in original.items(): d.userParameters.itemByName(name).expression=expression
        d.computeAll()
    restored=_bodies(d)==before
    report={'tests':tests,'original_expressions':original,'geometry_restored':restored,
            'pass':restored and all(t['health_pass'] and not t['interference_count'] and not t['purchased_dimensions_changed'] for t in tests),
            'limits':'Three independent +2 mm trials; this does not establish arbitrary resizing ranges or physical fit.'}
    path=b.BASE/'verification'/'parameter-regeneration.json'
    path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'parameter_test':str(path),'pass':report['pass'],'tests':[{k:v for k,v in t.items() if k not in ('collisions','unhealthy')} for t in tests]}))
