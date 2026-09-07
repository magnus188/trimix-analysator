import adsk.core
import adsk.fusion
import json
import sys
def run(_context: str):
    sys.path.insert(0,'/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/enclosure/scripts')
    import fusion_helpers as h
    d=adsk.fusion.Design.cast(adsk.core.Application.get().activeProduct)
    if d.rootComponent.occurrences.count:
        raise RuntimeError('Expected empty owned enclosure')
    c=h.new_component(d.rootComponent,'TEMP constraint diagnostic')
    s=h._xy_sketch(c,'Diagnostic','0 mm')
    p=h._positioned_point(c,s,'-CaseWidth/2','0 mm')
    s.sketchCurves.sketchLines.addTwoPointRectangle(p,adsk.core.Point3D.create(4.75,18,0))
    print('sketch',s.name,'constraints',s.geometricConstraints.count,'dims',s.sketchDimensions.count)
    for p in s.sketchPoints:
        print('point',p.geometry.asArray(),'fixed',p.isFixed,'constrained',p.isFullyConstrained)
    for l in s.sketchCurves.sketchLines:
        print('line',l.startSketchPoint.geometry.asArray(),l.endSketchPoint.geometry.asArray(),l.isFullyConstrained)
    print('constraints',[x.objectType for x in s.geometricConstraints])
    d.rootComponent.occurrences.item(0).deleteMe()
