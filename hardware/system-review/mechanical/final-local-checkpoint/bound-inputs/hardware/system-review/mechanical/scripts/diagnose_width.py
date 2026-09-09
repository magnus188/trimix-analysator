"""Reversible width datum diagnostic; no authored geometry."""
import adsk
from runtime import owned,report,configure,bounds

def inspect():
    app,doc,d=owned();configure();p=d.userParameters.itemByName('CaseWidth');original=p.expression
    def snapshot():
        rows=[]
        for o in d.rootComponent.allOccurrences:
            if o.component.partNumber not in ('TMX-A3-B02','TMX-A3-C05','TMX-A3-P06','TMX-A3-P09','TMX-A3-B01') and not o.fullPathName.startswith('PCB A3 - routed USB daughterboard:'):continue
            rows.append({'occurrence':o.fullPathName,'part':o.component.partNumber,'grounded':o.isGrounded,'ground_to_parent':o.isGroundToParent,
                         'transform':o.transform2.asArray(),'bounds_mm':bounds(o)})
        joints=[{'name':j.name,'health':j.healthState,'suppressed':j.isSuppressed,'occ1':j.occurrenceOne.fullPathName if j.occurrenceOne else None,
                 'occ2':j.occurrenceTwo.fullPathName if j.occurrenceTwo else None}for j in d.rootComponent.joints if 'USB PCB' in j.name]
        parameters=[{'name':q.name,'expression':q.expression,'value_mm':q.value*10}for q in d.allParameters if 'UsbX' in q.expression or q.name=='UsbX']
        return {'width_mm':p.value*10,'occurrences':rows,'joints':joints,'parameters':parameters}
    before=snapshot()
    try:
        p.expression='87 mm';d.computeAll();adsk.doEvents();app.activeViewport.refresh();after=snapshot()
    finally:
        p.expression=original;d.computeAll();adsk.doEvents();app.activeViewport.refresh()
    report('width-datum-diagnosis.json',{'before':before,'trial':after,'restored':snapshot()})
