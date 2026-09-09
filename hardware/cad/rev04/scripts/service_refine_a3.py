"""A3 service refinements and transient obstruction localization."""
import json,re
import adsk.core as core
import adsk.fusion as fusion
import build_a3 as b
from verification_a3 import _records,_at,_numeric_bounds,_numeric_overlap,_record_bounds,_label

def locate():
    _,d=b.get();m=fusion.TemporaryBRepManager.get();rs=_records(d,m)
    house=next(r for r in rs if r['component']=='01 Shape A housing')
    out=[]
    for group,offset in [('chamber',12),('display_retainers',17)]:
        for r in rs:
            if r['physical_group']!=group:continue
            a=_at(m,r['body'],[0,0,offset])
            if not _numeric_overlap(_numeric_bounds(a.boundingBox),_record_bounds(house)):continue
            if not m.booleanOperation(a,m.copy(house['body']),fusion.BooleanTypes.IntersectionBooleanType):raise RuntimeError('Boolean failed')
            if a.faces.count and a.volume*1000>1e-5:
                out.append({'moving':_label(r),'offset_mm':offset,'volume_mm3':a.volume*1000,'bounds_cm':_numeric_bounds(a.boundingBox)})
    (b.BASE/'verification/service-blocker-locations.json').write_text(json.dumps(out,indent=2)+'\n')
    print(json.dumps(out))

def lower_retainer():
    _,d=b.get(); changed=[]
    pattern=re.compile(r'CaseWidth\s*-\s*14\s*mm')
    for p in d.allParameters:
        if pattern.search(p.expression):
            old=p.expression;p.expression=pattern.sub('CaseWidth-16 mm',old)
            changed.append({'name':p.name,'before':old,'after':p.expression})
    for o in d.rootComponent.allOccurrences:
        attr=o.attributes.itemByName(b.GROUP,'position_expressions')
        if attr:
            e=json.loads(attr.value)
            if pattern.search(e[0]):
                e[0]=pattern.sub('CaseWidth-16 mm',e[0])
                o.attributes.add(b.GROUP,'position_expressions',json.dumps(e))
    if len(changed)!=7:raise RuntimeError('Unexpected lower-retainer parameter count: '+json.dumps(changed))
    b.checkpoint('Lower retainer clears the rear boss and driver path')
    print(json.dumps(changed))

def join_holder_rail():
    _,d=b.get();c=b.comp('01 Shape A housing')
    if c.bRepBodies.count!=2:raise RuntimeError('Expected the isolated holder support rail')
    found=[]
    for sk in c.sketches:
        if sk.name.startswith('Holder front support rail sketch') and 'HolderWidth' in sk.sketchDimensions.item(0).parameter.expression:
            found.append(sk)
    if len(found)!=1:raise RuntimeError('Cannot isolate the holder support sketch')
    found[0].sketchDimensions.item(2).parameter.expression='3 mm'
    d.computeAll()
    if c.bRepBodies.count==2:
        a,bodies=c.bRepBodies.item(0),core.ObjectCollection.create()
        bodies.add(c.bRepBodies.item(1))
        req=c.features.combineFeatures.createInput(a,bodies)
        req.operation=fusion.FeatureOperations.JoinFeatureOperation
        req.isKeepToolBodies=False
        f=c.features.combineFeatures.add(req);f.name='Join widened holder support to fixed divider'
    if not d.computeAll() or c.bRepBodies.count!=1:raise RuntimeError('Holder support did not join divider')
    b.checkpoint('Holder support rail joined into the fixed divider')

def upper_web_relief():
    _,d=b.get();c=b.comp('01 Shape A housing');selected=[]
    for sk in c.sketches:
        if not sk.name.startswith('Rear boss end-wall web sketch'):continue
        dims=sk.sketchDimensions
        if 'CaseWidth' in dims.item(0).parameter.expression and 'CaseHeight' in dims.item(1).parameter.expression:
            selected.append(sk)
    if len(selected)!=1:raise RuntimeError('Expected one upper inlet-side boss web')
    sk=selected[0]
    sk.sketchDimensions.item(1).parameter.expression='CaseHeight-10.5 mm'
    sk.sketchDimensions.item(3).parameter.expression='8.2 mm'
    b.checkpoint('Upper rear boss web clears closed chamber withdrawal')

def bind_upper_retainer_to_display():
    _,d=b.get();c=b.comp('01 Shape A housing')
    for name in ('Display retainer support sketch (1)','Display retainer insert pilot sketch (1)'):
        c.sketches.itemByName(name).sketchDimensions.item(0).parameter.expression='DisplayX+2.65 mm'
    c=b.comp('Display / upper rear-release retainer')
    for name,expression in [('Removable display retainer plate sketch','DisplayX-0.85 mm'),
                            ('Frame contact provision sketch','DisplayX+0.65 mm'),
                            ('Retainer M2 clearance sketch','DisplayX+2.65 mm')]:
        c.sketches.itemByName(name).sketchDimensions.item(0).parameter.expression=expression
    count=0
    for origin in d.rootComponent.jointOrigins:
        if abs(origin.offsetX.value*10-10.5)<1e-6 and abs(origin.offsetY.value*10-126)<1e-6:
            origin.offsetX.expression='DisplayX+2.65 mm';count+=1
    if count!=2:raise RuntimeError('Expected both upper retainer hardware datums')
    for o in d.rootComponent.allOccurrences:
        a=o.attributes.itemByName(b.GROUP,'position_expressions')
        if a:
            e=json.loads(a.value)
            if e[0]=='10.5 mm' and e[1]=='126 mm':
                e[0]='DisplayX+2.65 mm'
                o.attributes.add(b.GROUP,'position_expressions',json.dumps(e))
    b.checkpoint('Upper display retainer follows the measured screen seat')
