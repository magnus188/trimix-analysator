"""Assembly metadata and explicit native/neutral delivery for owned A3 only."""
import csv,json
from datetime import datetime,timezone
import build_a3 as b
from audit_a3 import attribute,_bodies,_combined_bounds

def organize():
    _,d=b.get();root=d.rootComponent
    group_names={
      'housing':'01 Housing and fixed inserts','rear_cover':'02 Single rear cover and screws',
      'display':'03 Complete factory display','display_retainers':'04 Rear-release display retainers',
      'battery':'05 Protected battery holder','disconnect':'06 Accessible battery disconnect',
      'carrier':'07 Removable electronics carrier','pcb':'08 Future main PCB allocation',
      'chamber':'09 Closed sampling cartridge','chamber_lid':'10 Independent chamber lid and screws',
      'gas_fittings':'11 Removable gas fittings','usb':'12 Bottom USB cartridge','button':'13 Left power button'}
    groups={g:[] for g in group_names}
    for c in d.allComponents:
        if c==root:continue
        h=attribute(c,'hardware_definition')
        if h:
            h=json.loads(h)
            c.name=(f"{h['size']} x {h['length_mm']:g} {h['head_style']} screw" if h['kind']=='screw' else f"{h['size']} insert OD{h['outer_diameter_mm']:g} x{h['length_mm']:g}")+' — '+c.partNumber
            c.attributes.add(b.GROUP,'purchased','true')
            c.attributes.add(b.GROUP,'geometry_role','nominal_hardware')
        elif c.name.startswith(('03 ','04 ','05 ','06 ','Sensor /','Controls /','Battery /')) or 'GCT' in c.name or 'tongue' in c.name or 'contact stripe' in c.name:
            c.attributes.add(b.GROUP,'purchased','true')
            if not attribute(c,'geometry_role'):c.attributes.add(b.GROUP,'geometry_role','purchased_reference')
        else:
            if not attribute(c,'geometry_role'):c.attributes.add(b.GROUP,'geometry_role','designed_concept')
    for o in root.allOccurrences:
        g=attribute(o,'physical_group') or attribute(o.component,'physical_group')
        if g not in groups:raise RuntimeError('Missing assembly group: '+o.fullPathName)
        groups[g].append(o)
    for key,occs in groups.items():
        label=group_names[key]
        old=next((x for x in d.selectionSets if x.name==label),None)
        if old:old.deleteMe()
        if occs:d.selectionSets.add(occs,label)
    rows=[]
    for i,c in enumerate((x for x in d.allComponents if x!=root),1):
        if not c.partNumber:c.partNumber=f'TRX-A3-{i:03d}-REF'
        occs=[o for o in root.allOccurrences if o.component.id==c.id]
        basis=attribute(c,'model_basis') or attribute(c,'provenance') or 'Designed concept; physical qualification pending'
        c.description=basis
        rows.append({'part_number':c.partNumber,'component':c.name,'quantity':len(occs),'basis':basis,
                     'source':attribute(c,'source') or '',
                     'instances':[{'name':o.fullPathName,'group':attribute(o,'physical_group') or attribute(c,'physical_group'),
                                   'label':attribute(o,'instance_label')} for o in occs]})
    with (b.BASE/'PARTS.csv').open('w',newline='') as f:
        w=csv.DictWriter(f,fieldnames=['part_number','component','quantity','basis','source']);w.writeheader()
        for row in rows:w.writerow({k:row[k] for k in w.fieldnames})
    report={'parts':rows,'selection_sets':{group_names[k]:[o.fullPathName for o in v] for k,v in groups.items()},
            'note':'Reusable hardware definitions have individual occurrences and recorded installed roles. Internal reference numbers are not manufacturer order codes.'}
    (b.BASE/'verification/parts-and-assemblies.json').write_text(json.dumps(report,indent=2)+'\n')
    b.checkpoint('Named physical assembly selection sets')

def export():
    app,d=b.get()
    if not d.computeAll():raise RuntimeError('Cannot export unhealthy recompute')
    dimensions={n:b.mm(d,n) for n in ('CaseWidth','CaseHeight','CaseDepth','Wall')}
    bb=_combined_bounds(_bodies(d))
    record={'date_utc':datetime.now(timezone.utc).isoformat(),'body_mm':dimensions,
      'assembly_bounds_mm':bb,'display_assembly_front_area_percent':69.3*116.8/(dimensions['CaseWidth']*dimensions['CaseHeight'])*100,
      'active_display_front_area_percent':56.16*93.6/(dimensions['CaseWidth']*dimensions['CaseHeight'])*100,
      'thickness_reduction_from_A2_percent':(1-dimensions['CaseDepth']/56)*100,
      'box_volume_change_from_A2_percent':(dimensions['CaseWidth']*dimensions['CaseHeight']*dimensions['CaseDepth']/(125*75*56)-1)*100,
      'status':'Fit concept. Geometry and service verification reports carry individual results; no manufacturing release.'}
    paths={}
    for ext in ('f3d','step'):
        path=b.BASE/(b.NAME+'.'+ext)
        opt=d.exportManager.createFusionArchiveExportOptions(str(path)) if ext=='f3d' else d.exportManager.createSTEPExportOptions(str(path),d.rootComponent)
        if not d.exportManager.execute(opt):raise RuntimeError('Export failed: '+ext)
        paths[ext]=str(path)
    if not app.activeDocument.save('A3 Shape A: top chamber, side-by-side battery and PCB, hidden bottom USB; reviewed fit concept'):
        raise RuntimeError('Cloud save failed')
    record.update({'paths':paths,'cloud_document':app.activeDocument.name,
      'cloud_file_id':app.activeDocument.dataFile.id if app.activeDocument.dataFile else None,
      'native_units':d.unitsManager.defaultLengthUnits,'other_open_documents':[x.name for x in app.documents if x!=app.activeDocument]})
    (b.BASE/'verification/final-delivery-export.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record))
