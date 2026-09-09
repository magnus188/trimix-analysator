"""Stable CAD metadata, exact print meshes and actual Fusion review assets."""
import json,math,csv
import adsk,adsk.core as core,adsk.fusion as fusion
import build_a3 as b, print_runtime as rt
from audit_a3 import _bounds,_bodies,attribute

def mapping():
    return json.loads((rt.BASE/'docs/source/part-map.json').read_text())['parts']

def metadata():
    _,d=rt.owned();rows=mapping();matched=[]
    for row in rows:
        cs=[c for c in d.allComponents if c.name==row['original_component_name']]
        if len(cs)!=1:raise RuntimeError('Part mapping is not unique: '+row['original_component_name'])
        c=cs[0];c.partNumber=row['cad_part_id']
        current=c.description or ''
        c.description=row['description']+('; '+current if current and row['description'] not in current else '')
        for k,v in {'part_id':row['cad_part_id'],'procurement_group':row['procurement_id'],
                    'fabrication_category':row['category'],'legacy_name':row['original_component_name']}.items():
            c.attributes.add('TrimixPrintReview',k,v)
        if row['category']=='printed':
            c.attributes.add(b.GROUP,'purchased','false')
            c.attributes.add(b.GROUP,'material_target','PETG final target / PLA dry fit')
        matched.append({'part_id':c.partNumber,'component':c.name,'description':c.description,
                        'procurement_group':row['procurement_id'],'category':row['category'],
                        'quantity':sum(o.component.id==c.id for o in d.rootComponent.allOccurrences)})
    rt.save_report('native-part-map.json',{'document':d.parentDocument.name,'parts':matched})
    b.checkpoint('PrintReview stable fabrication and purchasing identifiers')

def purchased_assemblies():
    _,d=rt.owned();root=d.rootComponent;rows=mapping()
    if root.attributes.itemByName('TrimixPrintReview','purchased_assemblies'):raise RuntimeError('Purchased grouping already applied')
    before={(r['component'],r['body_index']):(r['bounds_mm'],r['volume_mm3']) for r in _bodies(d)}
    created=[]
    for group,physical,title in [('TMX-A3-C01','display','Guition 4.3 inch display assembly'),
                                  ('TMX-A3-C04','button','Momentary 1NO button assembly'),
                                  ('TMX-A3-C05','usb','GCT USB4720-03-A connector assembly')]:
        selected=[r for r in rows if r['procurement_id']==group]
        parent=root.occurrences.addNewComponent(core.Matrix3D.create());c=parent.component
        c.name=title;c.partNumber=group;c.description=title
        b.mark(c,physical);c.attributes.add(b.GROUP,'purchased','true')
        c.attributes.add(b.GROUP,'geometry_role','purchased_reference')
        c.attributes.add('TrimixPrintReview','procurement_group',group)
        c.attributes.add('TrimixPrintReview','assembly_role','Purchased complete module; child components are visual details, not extra purchases')
        for row in selected:
            occurrence=next(o for o in root.occurrences if o.component.partNumber==row['cad_part_id'])
            if not occurrence.moveToComponent(parent):raise RuntimeError('Cannot group '+row['cad_part_id'])
        created.append({'part_id':group,'name':title,'children':[r['cad_part_id'] for r in selected]})
    # Keep concise native drawing-table descriptions; detailed basis remains in attributes.
    for row in rows:
        c=next(c for c in d.allComponents if c.partNumber==row['cad_part_id'])
        c.attributes.add('TrimixPrintReview','detailed_description',c.description)
        c.description=row['description']
    if not d.computeAll():raise RuntimeError('Reparenting recompute failed')
    after={(r['component'],r['body_index']):(r['bounds_mm'],r['volume_mm3']) for r in _bodies(d)}
    if before!=after:raise RuntimeError('Grouping changed physical geometry')
    root.attributes.add('TrimixPrintReview','purchased_assemblies','true')
    rt.save_report('purchased-assemblies.json',{'assemblies':created,'physical_geometry_unchanged':True,'occurrences':root.allOccurrences.count})
    b.checkpoint('PrintReview real purchased assembly hierarchy')

def export_meshes():
    _,d=rt.owned();out=rt.BASE/'printing/source-stl';out.mkdir(parents=True,exist_ok=True)
    parts=[]
    for row in mapping():
        if row['category']!='printed':continue
        c=b.comp(row['original_component_name'])
        if c.bRepBodies.count!=1 or not c.bRepBodies.item(0).isSolid:raise RuntimeError('Printable must be one solid: '+c.name)
        body=c.bRepBodies.item(0);path=out/(row['cad_part_id']+'.stl')
        opts=d.exportManager.createSTLExportOptions(body,str(path))
        opts.isBinaryFormat=True;opts.sendToPrintUtility=False
        opts.unitType=fusion.DistanceUnits.MillimeterDistanceUnits
        opts.surfaceDeviation=.001;opts.normalDeviation=math.radians(3)
        if not d.exportManager.execute(opts):raise RuntimeError('STL export failed '+c.name)
        parts.append({'part_id':row['cad_part_id'],'component':c.name,'description':row['description'],
                      'file':str(path),'bounds_mm':_bounds(body.boundingBox),'volume_mm3':body.volume*1000,
                      'material':'PETG / PLA fit','surface_deviation_mm':opts.surfaceDeviation*10,
                      'normal_deviation_degrees':math.degrees(opts.normalDeviation),'units':'mm',
                      'coordinate_system':'assembly X width, Y up, Z rear; no scaling'})
    rt.save_report('print-mesh-manifest.json',{'document':d.parentDocument.name,'parts':parts,'status':'native_meshes_exported_pending_slicer_QA'})

def extra_views():
    import review_a3 as v
    app,d=rt.owned();before=_bodies(d);vis=v._visibility(d);cam=app.activeViewport.camera
    v.DIRECTIONS['bottom']=(0,-50,0)
    groups={'display_install':['display','display_retainers'], 'usb_cartridge':['usb'],
            'button_carrier':['button','carrier','pcb'], 'battery':['battery','disconnect'],
            'sensor_layout':['chamber','chamber_lid'], 'lid_adapter':['chamber','chamber_lid'],
            'insert_detail':['housing'], 'rear_cable_space':None}
    files={}
    try:
        v._show_assembly(d)
        files['bottom']=v.capture('bottom','bottom.png')
        for name,show in groups.items():
            v._show_assembly(d)
            for o in d.rootComponent.allOccurrences:
                group=attribute(o,'physical_group') or attribute(o.component,'physical_group')
                if show is None:o.isLightBulbOn=group!='rear_cover'
                else:o.isLightBulbOn=group in show
                if name=='sensor_layout' and group=='chamber_lid':o.isLightBulbOn=False
                if name=='lid_adapter' and not ('adapter' in o.component.name.lower() or 'service lid' in o.component.name.lower()):o.isLightBulbOn=False
            files[name]=v.capture('rear_iso',name+'.png')
        v._show_assembly(d)
        for o in d.rootComponent.allOccurrences:
            g=attribute(o,'physical_group') or attribute(o.component,'physical_group')
            o.isLightBulbOn=g in ('chamber','chamber_lid','gas_fittings')
        files['gas_section']=v._section(d,d.rootComponent.xZConstructionPlane,b.mm(d,'GasY'),'y','top','gas_section')
        for row in mapping():
            if row['category']!='printed':continue
            for o in d.rootComponent.allOccurrences:o.isLightBulbOn=o.component.partNumber==row['cad_part_id']
            files[row['cad_part_id']]=v.capture('rear_iso',row['cad_part_id']+'.png')
    finally:
        v._restore_visibility(d,vis);app.activeViewport.camera=cam;adsk.doEvents()
    if before!=_bodies(d):raise RuntimeError('View export modified solid geometry')
    rt.save_report('extra-views.json',files)

def save():
    app,d=rt.owned();b.checkpoint('PrintReview manufacturing review saved')
    step=rt.BASE/(rt.NAME+'.step')
    if not d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(step))):raise RuntimeError('STEP export failed')
    if not app.activeDocument.save('Print refinement and community assembly documentation'):raise RuntimeError('Cloud save failed')
    rt.save_report('saved-source.json',{'name':app.activeDocument.name,'data_file_id':app.activeDocument.dataFile.id,'folder':app.activeDocument.dataFile.parentFolder.name,'native':str(rt.BASE/(rt.NAME+'.f3d')),'step':str(step)})

def views_and_save():
    rt.owned()
    import review_a3 as v
    v.style();v.export_views();extra_views();save()

def clearer_details():
    import review_a3 as v
    app,d=rt.owned();vis=v._visibility(d);cam=app.activeViewport.camera;before=_bodies(d)
    paths={}
    try:
        v._show_assembly(d)
        for o in d.rootComponent.allOccurrences:
            o.isLightBulbOn=(attribute(o,'physical_group') or attribute(o.component,'physical_group'))=='usb'
        v.DIRECTIONS['usb_underside']=(25,-35,-25)
        paths['usb_front']=v.capture('usb_underside','usb_front.png')
        v._show_assembly(d)
        for o in d.rootComponent.allOccurrences:
            o.isLightBulbOn=o.component.name.startswith('Sensor /')
        paths['sensors_only']=v.capture('rear_iso','sensors_only.png')
        v._show_assembly(d)
        for o in d.rootComponent.allOccurrences:
            group=attribute(o,'physical_group') or attribute(o.component,'physical_group')
            o.isLightBulbOn=group=='chamber'
        paths['chamber_open_rear']=v.capture('rear','chamber_open_rear.png')
    finally:v._restore_visibility(d,vis);app.activeViewport.camera=cam;adsk.doEvents()
    if before!=_bodies(d):raise RuntimeError('View changed solids')
    rt.save_report('clearer-details.json',paths)

def export_cover():
    """Refresh only P02 so untouched native print meshes keep their identities."""
    import hashlib,review_a3 as v
    app,d=rt.owned();c=b.comp('02 Single rear cover');body=c.bRepBodies.item(0)
    path=rt.BASE/'printing/source-stl/TMX-A3-P02.stl'
    opts=d.exportManager.createSTLExportOptions(body,str(path))
    opts.isBinaryFormat=True;opts.sendToPrintUtility=False;opts.unitType=fusion.DistanceUnits.MillimeterDistanceUnits
    opts.surfaceDeviation=.001;opts.normalDeviation=math.radians(3)
    if not d.exportManager.execute(opts):raise RuntimeError('Cover STL export failed')
    manifest=rt.BASE/'verification/print-mesh-manifest.json';data=json.loads(manifest.read_text())
    row=next(r for r in data['parts'] if r['part_id']=='TMX-A3-P02')
    row.update({'bounds_mm':_bounds(body.boundingBox),'volume_mm3':body.volume*1000,'revision_note':'Four0.30mm locating-tab entry chamfers'})
    data['document']=app.activeDocument.name;manifest.write_text(json.dumps(data,indent=2)+'\n')
    vis=v._visibility(d);cam=app.activeViewport.camera
    try:
        v._show_assembly(d)
        for o in d.rootComponent.allOccurrences:o.isLightBulbOn=o.component.id==c.id
        v.capture('rear_iso','TMX-A3-P02.png')
        v.capture('iso','cover_leadins.png')
    finally:v._restore_visibility(d,vis);app.activeViewport.camera=cam;adsk.doEvents()
    rt.save_report('cover-export.json',{'part_id':'TMX-A3-P02','sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'source':str(path),'other_mesh_files_unchanged':True})
