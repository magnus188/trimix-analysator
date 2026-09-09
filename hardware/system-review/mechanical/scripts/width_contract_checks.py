"""Prepared width-aware temporary allocation and mechanical checks.

No operation runs on import. inspect_axes() is read-only on v7. trial(width_mm)
changes only CaseWidth after the reviewed contract is installed, restores it in
finally, and never saves/closes/activates documents. Existing source-bound fit
findings are retained; this module cannot turn a placement checkpoint into a
routed/manufacturing release.
"""
from contextlib import contextmanager
from pathlib import Path
import hashlib
import json
import math
import adsk
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned, configure, report, BASE, GROUP, bounds, other_documents

MAIN = 'PCB A3 - main four-layer placement:'
USB = 'PCB A3 - routed USB daughterboard:'
HOUSING_PILOT_RADIUS_MM = 1.65
TRIAL_ROOT = BASE/'verification/width-contract-tests'


def datums():
    _,_,design = owned()
    value = lambda name: design.userParameters.itemByName(name).value*10
    result = {name:value(name) for name in ('CaseWidth','PcbX','PcbWidth','PcbY','PcbHeight','PcbZ','UsbX','UsbZ')}
    if abs(result['PcbWidth']-30)>1e-6 or abs(result['PcbZ']-20.5)>1e-6:
        raise RuntimeError('This contract is for the fixed30mm PCB at reviewed backseatZ20.5')
    result['main_pose'] = [result['PcbX'],result['PcbY']+result['PcbHeight'],result['PcbZ']+.0529]
    result['usb_pose'] = [result['UsbX']-8,18,result['UsbZ']-1.055]
    result['main_xy_shift'] = [result['PcbX']-50.4,result['PcbY']+result['PcbHeight']-120]
    result['usb_xy_shift'] = [result['UsbX']-42.5,0]
    return result


def _inputs(require_main=True):
    manifest = json.loads((BASE/'verification/incoming-boards.json').read_text())
    _,_,design = owned();datum=datums()
    for key,number in (('main','TMX-A3-B01'),('usb','TMX-A3-B02')):
        source=manifest[key]
        for filename,digest in (('file','sha256'),('height_contract_file','height_contract_sha256')):
            if hashlib.sha256(Path(source[filename]).read_bytes()).hexdigest()!=source[digest]:
                raise RuntimeError('Input identity changed: '+key+'/'+filename)
        if key=='main':
            contract=json.loads(Path(source['height_contract_file']).read_text())
            if contract['board_sha256']!=source['board_sha256']:
                raise RuntimeError('Main component contract/board identity mismatch')
            if not require_main:continue
        wrappers=[o for o in design.rootComponent.occurrences if o.component.partNumber==number]
        if len(wrappers)!=1:raise RuntimeError('Expected one PCB wrapper '+key)
        wrapper=wrappers[0];expected=core.Matrix3D.create()
        expected.translation=core.Vector3D.create(*(x/10 for x in datum[key+'_pose']))
        if max(abs(a-b) for a,b in zip(expected.asArray(),wrapper.transform2.asArray()))>1e-7:
            raise RuntimeError('Width-aware full PCB transform mismatch '+key)
        item=wrapper.component.attributes.itemByName(GROUP,'source_step_sha256')
        if not item or item.value!=source['sha256']:raise RuntimeError('Installed STEP source mismatch '+key)
    return manifest


def _translate_records(manager, rows, shift):
    """Translate temporary solids and cached bounds together; never scale them."""
    import verification_a3 as v
    matrix=core.Matrix3D.create();matrix.translation=core.Vector3D.create(shift[0]/10,shift[1]/10,0)
    for row in rows:
        if not row['body'].isTransient or not manager.transform(row['body'],matrix):
            raise RuntimeError('Temporary allocation translation failed')
        row.pop('bounds_cm',None)
        row['bounds_mm']=bounds(row['body'])
        v._record_bounds(row)
    return rows


def _save(directory,name,data):
    directory.mkdir(parents=True,exist_ok=True)
    (directory/name).write_text(json.dumps(data,indent=2)+'\n')
    return data


@contextmanager
def allocations(directory):
    """Scoped adapters for all supplied maxima, mate, cable, tails and USB wires."""
    configure()
    import integrated_clearance as ic
    import board_clearance_review as old
    import verification_a3 as v
    prior={name:getattr(ic,name) for name in ('_manifest','_main','_usb','_mate','report')}
    prior_coax=old._coax_tolerance;prior_out=v.OUTPUT
    def main(manager,contract,front_shift=0):
        translated={'rows':[]}
        datum=datums();dx,dy=datum['main_xy_shift']
        for source in contract['rows']:
            row=dict(source)
            expected=(50.4+row['x_min_mm'],50.4+row['x_max_mm'],120-row['y_max_mm'],120-row['y_min_mm'])
            current=tuple(row[name] for name in ('Fusion_x_min_mm','Fusion_x_max_mm','Fusion_y_min_mm','Fusion_y_max_mm'))
            if max(abs(a-b) for a,b in zip(expected,current))>1e-6:
                raise RuntimeError('Source maxima no longer use the frozen baseline coordinate contract')
            for name in ('Fusion_x_min_mm','Fusion_x_max_mm'):row[name]+=dx
            for name in ('Fusion_y_min_mm','Fusion_y_max_mm'):row[name]+=dy
            translated['rows'].append(row)
        return prior['_main'](manager,translated,front_shift)
    def usb(manager,contract,top_shift=0):
        return _translate_records(manager,prior['_usb'](manager,contract,top_shift),datums()['usb_xy_shift'])
    def mate(manager,contract,front_shift=0):
        return _translate_records(manager,[prior['_mate'](manager,contract,front_shift)],datums()['main_xy_shift'])[0]
    def coax(manager,contract):
        return _translate_records(manager,prior_coax(manager,contract),datums()['main_xy_shift'])
    ic._manifest=_inputs;ic._main=main;ic._usb=usb;ic._mate=mate
    old._coax_tolerance=coax;ic.report=lambda name,data:_save(directory,name,data);v.OUTPUT=directory
    # ic._cable derives its complete volume from ic._mate, so it follows the
    # patched mate exactly once. Original axes/Z and physical allowances remain.
    try:
        yield ic
    finally:
        for name,value in prior.items():setattr(ic,name,value)
        old._coax_tolerance=prior_coax;v.OUTPUT=prior_out


def hole_axes():
    configure()
    import review_checks
    manager,rows=review_checks.records();datum=datums()
    candidates=[r for r in rows if r['occurrence'].startswith(MAIN) and
                abs(bounds(r['body'])[1][2]-bounds(r['body'])[0][2]-1.4942)<1e-4 and
                abs(bounds(r['body'])[1][0]-bounds(r['body'])[0][0]-30)<.1 and
                abs(bounds(r['body'])[1][1]-bounds(r['body'])[0][1]-99)<.1]
    if len(candidates)!=1:raise RuntimeError('Expected unique actual main dielectric substrate')
    carrier=[r for r in rows if r['component']=='Carrier / removable electronics tray']
    housing=[r for r in rows if r['component']=='01 Shape A housing']
    if len(carrier)!=1 or len(housing)!=1:raise RuntimeError('Expected one connected carrier and housing body')
    groups=[('actual_PCB_NPTH',candidates[0],1.15),('carrier_hole',carrier[0],1.15),('housing_pilot',housing[0],HOUSING_PILOT_RADIUS_MM)]
    expected=[(datum['PcbX']+25.6,28),(datum['PcbX']+4.4,114)]
    measured=[]
    for label,row,radius in groups:
        cylinders=[]
        for face in row['body'].faces:
            cylinder=core.Cylinder.cast(face.geometry)
            if cylinder and abs(cylinder.radius*10-radius)<1e-5 and abs(abs(cylinder.axis.z)-1)<1e-7:
                cylinders.append([cylinder.origin.x*10,cylinder.origin.y*10])
        for x,y in expected:
            matches=[q for q in cylinders if math.dist(q,(x,y))<1e-4]
            measured.append({'assembly':label,'expected_XY_mm':[x,y],'actual_matching_axes_XY_mm':matches,
                             'radius_mm':radius,'pass':bool(matches)})
    hardware=[]
    _,_,design=owned()
    for occurrence in design.rootComponent.occurrences:
        a=occurrence.attributes.itemByName('TrimixRev04','instance_label')
        if not a or a.value not in ('pcb screw 1','pcb insert 1','pcb screw 2','pcb insert 2'):continue
        i=0 if a.value.endswith('1') else 1
        point=[x*10 for x in occurrence.transform2.translation.asArray()]
        hardware.append({'instance':a.value,'XYZ_mm':point,'expected_XY_mm':list(expected[i]),
                         'pass':math.dist(point[:2],expected[i])<1e-4})
    return {'pass':all(r['pass']for r in measured+hardware)and len(hardware)==4,
            'bore_axes':measured,'hardware_axes':hardware,'fixed_hole_spacing_mm':math.dist(*expected),
            'carrier_lumps':carrier[0]['body'].lumps.count,'housing_lumps':housing[0]['body'].lumps.count}


def inspect_axes():
    """Read-only baseline actual bore/hardware alignment; does not change width."""
    app,doc,design=owned();before=(doc.isModified,design.timeline.count);protected=other_documents(app)
    result=hole_axes()
    if before!=(doc.isModified,design.timeline.count)or protected!=other_documents(app):
        raise RuntimeError('Read-only axis inventory changed document state')
    report('width-contract-baseline-hole-axes.json',{'document':doc.name,'datums':datums(),**result,
        'persistent_geometry_modified':False,'other_documents_preserved':protected})


def selected_sections():
    import review_checks
    import wall_fastener_checks as w
    _,_,design=owned();_,rows=review_checks.records()
    specs=[
      ('Carrier web toJ103','Carrier / removable electronics tray',['PcbX+4 mm','36.3 mm','19.5 mm'],['PcbX+4 mm','38.385 mm','19.5 mm'],'Existing2.085mm web follows PCB',2.085),
      ('Carrier thickness','Carrier / removable electronics tray',['PcbX+11.6 mm','37 mm','18.5 mm'],['PcbX+11.6 mm','37 mm','20.5 mm'],'Existing2mm plate',2),
      ('Lower hole material span','Carrier / removable electronics tray',['PcbX+20.525 mm','28 mm','19.5 mm'],['PcbX+24.45 mm','28 mm','19.5 mm'],'Existing3.925mm interval toNPTH edge',3.925),
      ('Coax floor','Carrier / removable electronics tray',['PcbX+4.45 mm','103.4 mm','15 mm'],['PcbX+4.45 mm','103.4 mm','17 mm'],'Existing2mm floor',2),
      ('Coax lower end','Carrier / removable electronics tray',['PcbX+4.45 mm','96.99 mm','18 mm'],['PcbX+4.45 mm','98.99 mm','18 mm'],'Existing2mm end wall',2),
      ('Coax upper end','Carrier / removable electronics tray',['PcbX+4.45 mm','107.81 mm','18 mm'],['PcbX+4.45 mm','109.81 mm','18 mm'],'Existing2mm end wall',2),
      ('Divider holder-to-carrier material','01 Shape A housing',['HolderX+HolderWidth+0.8 mm','70 mm','30 mm'],['PcbX-0.2 mm','70 mm','30 mm'],'Fixed holder-side datum; printed width2→4mm',2)]
    results=[w._section(design,rows,*row)for row in specs]
    return {'sections':results,'pass':all(r['status']=='selected_section_passed'for r in results),
            'existing_pilot_Y_ligament_mm':1.95,
            'limits':'Selected material only;7.2mm web−3.3mm pilot gives existing1.95mm Yligament, preserved not roundedup. No globalwall orretention claim.'}


def _purchased_trial(before,after,design,width_delta):
    """Purchased solids must remain equivalent after pure translation."""
    from width_contract_proposal import compare_physical
    manager=fusion.TemporaryBRepManager.get()
    if set(before)!=set(after):raise RuntimeError('Width trial changed physical body identities')
    printed={f'TMX-A3-P{i:02d}' for i in range(1,12)}
    parts={component.name:component.partNumber for component in design.allComponents}
    rows=[];translated_source={};selected_after={}
    for key,old in before.items():
        new=after[key]
        if parts.get(old['component']) in printed:continue
        a,z=old['body'],new['body'];lo,hi=bounds(a);zl,zh=bounds(z)
        dimensions=max(abs((v-u)-(b-a)) for u,v,a,b in zip(lo,hi,zl,zh))
        volume=abs(a.volume-z.volume)*1000
        topology=(a.faces.count,a.edges.count,a.lumps.count)==(z.faces.count,z.edges.count,z.lumps.count)
        expected=None
        if old['occurrence'].startswith(MAIN):expected=[width_delta,0,0]
        elif old['physical_group']=='usb':expected=[width_delta/2,0,0]
        motion=[b-a for a,b in zip(lo,zl)]
        copied=manager.copy(a);matrix=core.Matrix3D.create()
        matrix.translation=core.Vector3D.create(*(x/10 for x in motion))
        if copied is None or not manager.transform(copied,matrix):
            raise RuntimeError('Cannot construct translated purchased-solid witness')
        translated_source[key]=dict(old,body=copied);selected_after[key]=new
        motion_ok=expected is None or max(abs(a-b)for a,b in zip(motion,expected))<1e-4
        rows.append({'body':key,'max_dimension_error_mm':dimensions,'volume_error_mm3':volume,
                     'topology_counts_unchanged':topology,'translation_mm':motion,
                     'expected_translation_mm':expected,'pass':dimensions<1e-4 and volume<1e-3 and topology and motion_ok})
    equivalence=compare_physical(translated_source,selected_after,manager)
    return {'pass':all(row['pass']for row in rows) and equivalence['pass'],'body_count':len(rows),'bodies':rows,
            'translated_solid_boolean_equivalence':equivalence,
            'scope':'All nonprinted physical dimensions, volumes, topology and bilateral Boolean residuals after measured pure translation; required main/USB translations checked independently. Baseline/restore full-solid checks are separate.'}


def trial(width_mm):
    """Future trial after approved baseline apply; always restores all physical source state."""
    app,doc,design=owned();configure()
    from width_contract_proposal import _load,_snapshots,compare_physical
    import review_checks
    import integrated_clearance as ic
    import verification_a3 as v
    import thickness_fasteners as tf
    spec,digest=_load();marker=design.rootComponent.attributes.itemByName(GROUP,'width_contract_manifest_sha256')
    if not marker or marker.value!=digest:raise RuntimeError('Reviewed width contract must be installed first')
    if width_mm not in (85,85.5,86,86.5,87):raise ValueError('Only the reviewed bounded sample set is prepared')
    parameter=design.userParameters.itemByName('CaseWidth');original=parameter.expression
    if abs(parameter.value*10-85)>1e-6:raise RuntimeError('Start from85mm baseline')
    protected=other_documents(app);manager,before=_snapshots();source_timeline=design.timeline.count
    parameter_snapshot={p.name:p.expression for p in design.allParameters}
    from width_contract_proposal import _main,_children
    main_parent=_main(design)
    children_before={o.fullPathName:(o.nativeObject or o).transform2.asArray() for o in _children(design,main_parent)}
    directory=TRIAL_ROOT/('W'+str(width_mm).replace('.','_'))
    outcome=None
    try:
        parameter.expression=str(width_mm)+' mm'
        if not design.computeAll():raise RuntimeError('Width trial recompute failed')
        adsk.doEvents()
        axes=hole_axes();health=review_checks.health(design);sections=selected_sections()
        _,changed=_snapshots();purchased=_purchased_trial(before,changed,design,width_mm-85)
        children_after={o.fullPathName:(o.nativeObject or o).transform2.asArray() for o in _children(design,main_parent)}
        children_rigid=(children_before==children_after and all((o.nativeObject or o).isGroundToParent for o in _children(design,main_parent)))
        with allocations(directory)as adapted:
            _inputs()
            clearance=adapted.installed()
            inputs=_inputs();main_contract=json.loads(Path(inputs['main']['height_contract_file']).read_text())
            mm,physical=adapted._rows();fixed=[r for r in physical if not r['occurrence'].startswith(MAIN)]
            thin=adapted._main(mm,main_contract,-.16)
            thin_tests=[v._test(mm,'Main maximum/allocation finished thickness1.44mm',thin,fixed,[(0,0,0)],[]),
                v._test(mm,'J301 mate finished thickness1.44mm',[adapted._mate(mm,main_contract,-.16)],fixed+[r for r in thin if r['contract']['reference']!='J301'],[(0,0,0)],[]),
                v._test(mm,'J301 cable/turn finished thickness1.44mm',[adapted._cable(mm,main_contract,-.16)],fixed+[r for r in thin if r['contract']['reference']!='J301'],[(0,0,0)],[])]
            _save(directory,'minimum-thickness-allocations.json',{'tests':thin_tests,'status':'clear' if not any(t['collision_count']for t in thin_tests)else'needs_review'})
            full_service=width_mm in (85,87)
            paths=drivers=fasteners={'status':'not_repeated_at_intermediate_width'}
            if full_service:
                old_output=v.OUTPUT
                adapted_v,old_records=adapted._adapter(False)
                try:
                    adapted_v.OUTPUT=directory
                    paths=adapted_v.audit_paths()
                finally:
                    adapted_v._records=old_records;adapted_v.OUTPUT=old_output
                adapted_v,old_records=adapted._adapter(True)
                try:
                    adapted_v.OUTPUT=directory
                    drivers=adapted_v.audit_drivers()
                finally:
                    adapted_v._records=old_records;adapted_v.OUTPUT=old_output
                previous_report=tf.report;tf.report=lambda name,data:_save(directory,name,data)
                try:fasteners=tf.audit()
                finally:tf.report=previous_report
        outcome={'width_mm':width_mm,'datums':datums(),'actual_hole_alignment':axes,'health':health,
                 'selected_sections':sections,'purchased_geometry':purchased,'all_main_children_rigid_local_poses_preserved':children_rigid,'clearance_status':clearance['status'],
                 'minimum_thickness_allocation_collisions':sum(t['collision_count']for t in thin_tests),
                 'fastener_thickness_status':fasteners['status'],
                 'path_status':paths['status'],'driver_status':drivers['status'],
                 'service_scope':'Full endpoint sampled removal/driver/thickness checks' if full_service else 'Intermediate static/max-allocation/bore/material/rigid-solid sample; full service only at85/87mm endpoints',
                 'input_status':inputs['main'].get('status','source-bound integration'),
                 'core_width_contract_pass':axes['pass'] and health['pass'] and sections['pass'] and purchased['pass'] and children_rigid,
                 'release':False}
    finally:
        parameter.expression=original
        restored_compute=design.computeAll();adsk.doEvents()
        _,restored=_snapshots();comparison=compare_physical(before,restored,manager)
        restored_parameters={p.name:p.expression for p in design.allParameters}
        restoration={'compute_success':restored_compute,'all_parameter_expressions_restored':parameter_snapshot==restored_parameters,
            'all_physical_geometry_restored':comparison,'timeline_unchanged':source_timeline==design.timeline.count,
            'other_documents_preserved':protected==other_documents(app),'health':review_checks.health(design)}
        _save(directory,'trial-summary.json',{'trial':outcome,'restoration':restoration,
            'interpretation':'Keep any source-baseline R301/mated maximum failure visible. Separate no-new-width-regression from overall-fit acceptance; neither implies routed/fabrication release.'})
        if not restored_compute or not comparison['pass']or parameter_snapshot!=restored_parameters or protected!=other_documents(app) or source_timeline!=design.timeline.count or not restoration['health']['pass']:
            raise RuntimeError('Width trial did not restore identical protected source state')
    return outcome
