"""Assembly selection sets, truthful model provenance and reusable-parts BOM."""
import csv
import json
import build_rev03 as b

def _attr(entity,key):
    a=entity.attributes.itemByName(b.GROUP,key)
    return a.value if a else None

def organize_and_export():
    app,d=b.get(); root=d.rootComponent
    # Names describe a reusable definition; installed roles remain occurrence
    # metadata, rather than calling every M2x5 a display-retainer screw.
    for c in d.allComponents:
        attr=c.attributes.itemByName(b.GROUP,'hardware_definition')
        if attr:
            h=json.loads(attr.value)
            c.name=(f"{h['size']} x {h['length_mm']:g} {h['head_style']} screw" if h['kind']=='screw'
                    else f"{h['size']} insert OD{h['outer_diameter_mm']:g} x {h['length_mm']:g}")+' — '+c.partNumber
    groups={name:[] for name in ['01 Housing and installed inserts','02 Rear cover and screws',
        '03 Complete factory display','04 Rear display retainers','05 Protected battery and disconnect',
        '06 Electronics carrier and future PCB','07 Closed sampling cartridge','08 USB service module','09 Side power button']}
    for o in root.occurrences:
        c=o.component; n=c.name
        h=_attr(c,'hardware_definition'); h=json.loads(h) if h else None
        sg=_attr(o,'service_group') or _attr(c,'service_group')
        sub=_attr(o,'subassembly') or _attr(c,'subassembly')
        key='01 Housing and installed inserts'
        if n=='02 Single rear cover' or (h and h['kind']=='screw' and h['size']=='M3'): key='02 Rear cover and screws'
        elif n.startswith(('03 ','04 ','05 ','06 ')): key='03 Complete factory display'
        elif n.startswith('Display /'): key='04 Rear display retainers'
        elif n.startswith('Battery /'): key='05 Protected battery and disconnect'
        elif n.startswith('Carrier /'): key='06 Electronics carrier and future PCB'
        elif sg in ('closed_chamber','chamber_lid_fastener','chamber_mount_screw') or n.startswith('Gas /'): key='07 Closed sampling cartridge'
        elif n.startswith('USB') or sub=='removable USB insert' or 'usb' in (sg or '').lower(): key='08 USB service module'
        elif n.startswith('Controls /'): key='09 Side power button'
        elif h and h['kind']=='screw':
            z=o.transform2.translation.z*10
            key='04 Rear display retainers' if abs(z-22.3)<1e-5 else '06 Electronics carrier and future PCB'
        groups[key].append(o)
    for name,items in groups.items():
        previous=next((s for s in d.selectionSets if s.name==name),None)
        if previous: previous.deleteMe()
        if items and not d.selectionSets.add(items,name): raise RuntimeError('Selection set failed: '+name)
    rows=[]
    for index,c in enumerate((c for c in d.allComponents if c!=root),1):
        if not c.partNumber: c.partNumber=f'TRX-A2-{index:03d}-REF'
        occurrences=[o for o in root.allOccurrences if o.component.id==c.id]
        basis=_attr(c,'model_basis') or _attr(c,'provenance') or 'Designed concept; procurement and physical fit pending'
        c.description=basis
        rows.append({'part_number':c.partNumber,'component':c.name,'quantity':len(occurrences),
                     'basis':basis,'source':_attr(c,'source') or '',
                     'occurrences':[o.fullPathName for o in occurrences],
                     'service_group':_attr(c,'service_group') or '',
                     'clearance_envelope_mm':_attr(c,'clearance_envelope_mm')})
    with (b.BASE/'PARTS.csv').open('w',newline='') as stream:
        writer=csv.DictWriter(stream,fieldnames=['part_number','component','quantity','basis','source'])
        writer.writeheader()
        for row in rows: writer.writerow({k:row[k] for k in writer.fieldnames})
    (b.BASE/'verification'/'parts-and-assemblies.json').write_text(json.dumps({
        'parts':rows,'selection_sets':{k:[o.fullPathName for o in v] for k,v in groups.items()},
        'note':'Native selection sets support assembly selection. Generic part numbers are internal identifiers, not verified purchase SKUs.'},indent=2)+'\n')
    print(json.dumps({'part_definitions':len(rows),'selection_sets':len(groups),'parts_csv':str(b.BASE/'PARTS.csv')}))
