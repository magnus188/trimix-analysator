"""Read-only inventory with actual instance bounds and component materials."""
import re
import adsk.fusion as fusion
from runtime import owned,report,bounds,attrs,other_documents

def inspect():
    app,doc,d=owned();rows=[]
    for c in d.allComponents:
        rows.append({'name':c.name,'id':c.id,'part':c.partNumber,'description':c.description,
                     'material':c.material.name if c.material else None,
                     'material_id':c.material.id if c.material else None,
                     'attributes':attrs(c),'bodies':[{'name':b.name,'solid':b.isSolid,'material':b.material.name if b.material else None,'bounds_mm':bounds(b),'volume_mm3':b.volume*1000,'attributes':attrs(b)}for b in c.bRepBodies]})
    instances=[{'name':o.fullPathName,'component':o.component.name,'part':o.component.partNumber,'bounds_mm':bounds(o),'transform':o.transform2.asArray(),'attributes':attrs(o)}for o in d.rootComponent.allOccurrences]
    health=[];groups=[]
    for i in range(d.timeline.count):
        t=d.timeline.item(i)
        if t.healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState:
            row={'index':i,'name':t.name,'state':t.healthState,'message':t.errorOrWarningMessage,'type':t.objectType,'entity_type':t.entity.objectType if t.entity else None}
            (groups if t.objectType==fusion.TimelineGroup.classType() else health).append(row)
    materials=[]
    for lib in app.materialLibraries:
        for m in lib.materials:
            if re.search(r'PET|Polylactic|ABS|FR.?4|Epoxy|Copper|Brass|Glass|Silicon|Steel|Polycarbonate|Nylon|Polyamide',m.name,re.I):materials.append({'library':lib.name,'name':m.name,'id':m.id})
    report('detailed-state.json',{'document':doc.name,'id':doc.dataFile.id,'version':app.version,'timeline':d.timeline.count,
        'components':rows,'instances':instances,'nonhealthy_timeline_entities':health,'timeline_group_rollups':groups,
        'material_candidates':materials,'preserved_other_documents':other_documents(app)})
