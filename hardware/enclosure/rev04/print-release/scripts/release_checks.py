"""Explicit checks for the revised manufacturing model; reports stay in release."""
import json
import print_runtime as rt

def static():
    rt.owned()
    import audit_a3 as a
    result=a.audit()
    rt.save_report('static-gate.json',{'pass':result['status']=='cad_checks_passed','source':'model-audit.json'})

def interfaces():
    rt.owned()
    import gas_checks_a3 as g,wall_fastener_checks as w,verification_a3 as v
    gas=g.audit();wall=w.audit();drivers=v.audit_drivers()
    rt.save_report('interface-gates.json',{'gas_pass':gas['pass'],'wall_fastener_report':wall,'driver_status':drivers.get('status')})

def paths():
    rt.owned()
    import verification_a3 as v
    v.audit_paths()

def after_leadins():
    static();updated_walls()
    import gas_checks_a3 as g,verification_a3 as v
    g.audit();v.audit_drivers();v.audit_paths()

def regeneration():
    rt.owned()
    import verification_a3 as v
    v.regeneration_test()

def updated_walls():
    rt.owned()
    import wall_fastener_checks as w
    original=w._sections
    def revised(d,records):
        results=[x for x in original(d,records) if x['name']!='Chamber inlet duct upper radial wall']
        specs=[
          ('Revised inlet 45degree roof normal wall','Chamber / A3 top manifold with serial return',
           ['CaseWidth-5 mm','GasY+1 mm','GasZ+sqrt(2)*2.5 mm-1 mm'],
           ['CaseWidth-5 mm','GasY+1 mm+sqrt(2)*1 mm','GasZ+sqrt(2)*2.5 mm-1 mm+sqrt(2)*1 mm'],
           'Replaces obsolete circular-roof sample; 2mm normal offset between45degree inner/outer roofs',2),
          ('Carrier plate','Carrier / removable electronics tray',['65 mm','60 mm','18.5 mm'],['65 mm','60 mm','20.5 mm'],'Printed plate thickness',2),
          ('Lower retainer plate','Display / lower rear-release retainer',['CaseWidth-18.5 mm','10 mm','18.5 mm'],['CaseWidth-18.5 mm','10 mm','20.5 mm'],'Printed retainer plate',2),
          ('Upper retainer plate','Display / upper rear-release retainer',['DisplayX+0.3 mm','123 mm','18.5 mm'],['DisplayX+0.3 mm','123 mm','20.5 mm'],'Printed retainer plate',2),
          ('Printed USB bridge broad plate','USB A3 — hidden metal retaining bridge',['UsbX-6 mm','10 mm','UsbZ+5.2 mm'],['UsbX-6 mm','10 mm','UsbZ+7.2 mm'],'PETG plate',2),
          ('Printed USB bridge reinforced capture','USB A3 — hidden metal retaining bridge',['UsbX','4 mm','UsbZ+6 mm'],['UsbX','4 mm','UsbZ+8 mm'],'Capture lip raised from1.2mm to2mm',2),
          ('USB bezel local panel interface exception','USB A3 — tiny flush metal bezel and hidden flange',['UsbX+6 mm','0 mm','UsbZ'],['UsbX+6 mm','1.8 mm','UsbZ'],'Intentional1.8mm local face panel; reinforced by2mm flange and independent load-carrying frame',1.8),
          ('USB bezel hidden flange','USB A3 — tiny flush metal bezel and hidden flange',['UsbX+8 mm','2.4 mm','UsbZ'],['UsbX+8 mm','4.4 mm','UsbZ'],'Hidden flange structural thickness',2),
          ('USB bezel cosmetic upper face web exception','USB A3 — tiny flush metal bezel and hidden flange',['UsbX','0.8 mm','UsbZ+2.05 mm'],['UsbX','0.8 mm','UsbZ+4 mm'],'Intentional1.95mm cosmetic face web around clearance mouth; connector loads supported by cartridge',1.95),
          ('Battery divider','01 Shape A housing',['48.2 mm','50 mm','25 mm'],['50.2 mm','50 mm','25 mm'],'Nominal2mm divider and rail',2),
          ('Lid sensor stop square stalk','Chamber / A3 four-screw service lid',['21.5 mm','CaseHeight-15.5 mm','30 mm'],['23.5 mm','CaseHeight-15.5 mm','30 mm'],'Provisional MD62 stop2mm width; actual contact surfaces unmeasured',2),
        ]
        for side,x in [('left','Wall+0.25 mm'),('right','CaseWidth-Wall-2.25 mm')]:
            for y in ('61 mm','104 mm'):
                specs.append(('Cover locating tab2mm core '+side+' '+y,'02 Single rear cover',
                  [x,y,'CaseDepth-Cover-1.5 mm'],['('+x+')+2 mm',y,'CaseDepth-Cover-1.5 mm'],
                  'Core behind0.30mm entry chamfer;1.4mm insertion nose is an intentional guide interface',2))
        for spec in specs:results.append(w._section(d,records,*spec))
        return results
    try:
        w._sections=revised
        result=w.audit()
    finally:w._sections=original
    rt.save_report('updated-wall-gate.json',{'status':result['status'],'sections':result['selected_wall_section_count'],
      'failures':[x for x in result['selected_wall_sections']+result['fastener_pairs'] if x['status']=='needs_review'],
      'scope':'Selected sections across all11 printedparts; not a mathematical global minimum. Revised roof sample replaces original cylindrical roof now intentionally empty.',
      'physical_insert_fit':'Nominal generic inserts and pilot bores are reference only; exact series and retention coupon required.'})

def restore_baseline_report():
    import adsk.core as core,adsk.fusion as fusion
    import audit_a3 as a
    app,_=rt.owned();review=app.activeDocument
    baseline=next(doc for doc in app.documents if doc.name=='Trimix_Enclosure_A3 v3')
    if baseline.isModified:raise RuntimeError('Preserve modified baseline')
    old=a.OUTPUT
    try:
        baseline.activate();a.OUTPUT=rt.BASE.parent/'verification'
        result=a.audit()
        if result['status']!='cad_checks_passed':raise RuntimeError('Baseline differs unexpectedly')
    finally:
        a.OUTPUT=old;review.activate()
    print('Restored baseline read-only audit from preserved A3 v3; original native remains unchanged')

def step_precise():
    import release_step
    release_step.verify('very_high')

def final_geometry_exports():
    import release_assets,release_step
    release_assets.save();native_reopen()
    try:release_step.verify('very_high')
    except RuntimeError:
        report=json.loads((rt.BASE/'verification/step-roundtrip.json').read_text())
        comparison=report.get('comparison',{})
        if not (report.get('status')=='geometry_mismatch' and comparison.get('placed_solid_count_matches') and
                comparison.get('bounds_pass') and report.get('native_geometry_unchanged') and
                report.get('native_instance_poses_unchanged') and report.get('native_timeline_unchanged')):raise
        step_surface_diagnostic()
        rt.save_report('step-disposition.json',{'status':'dimensional_diagnostic_passed_with_retained_volume_exception',
          'strict_volume_gate_pass':False,'comparison':comparison,'source':'step-roundtrip.json',
          'sampled_surface_source':'step-surface-diagnostic.json','native_design_authoritative':True})

def native_reopen():
    import adsk.fusion as fusion
    import hashlib,zipfile
    from audit_a3 import _bodies
    app,d=rt.owned();source=app.activeDocument;path=rt.BASE/(rt.NAME+'.f3d')
    expected=_bodies(d)
    parameters={p.name:(p.expression,p.value,p.unit) for p in d.userParameters}
    timeline=d.timeline.count
    with zipfile.ZipFile(path) as archive:
        bad=archive.testzip()
        if bad:raise RuntimeError('Archive CRC failed: '+bad)
    reopened=None
    try:
        reopened=app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(path)))
        if not reopened:raise RuntimeError('Fusion archive could not reopen')
        reopened.activate();check=fusion.Design.cast(app.activeProduct)
        actual=_bodies(check)
        def geom(rows):
            return sorted((r['name'],r['solid'],json.dumps(r['bounds_mm'],sort_keys=True),round(r['volume_mm3'],5)) for r in rows)
        same_geometry=geom(actual)==geom(expected)
        same_parameters=parameters=={p.name:(p.expression,p.value,p.unit) for p in check.userParameters}
        same_timeline=timeline==check.timeline.count
        report={'archive':str(path),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
          'body_count':len(actual),'timeline_count':check.timeline.count,'user_parameter_count':len(parameters),
          'geometry_matches':same_geometry,'parameters_match':same_parameters,'timeline_matches':same_timeline,
          'pass':same_geometry and same_parameters and same_timeline}
        rt.save_report('native-reopen.json',report)
        if not report['pass']:raise RuntimeError('Native archive roundtrip differed')
    finally:
        if reopened:reopened.close(False)
        source.activate()

def step_surface_diagnostic():
    """Bidirectional deterministic surface sampling of the three numeric outliers.

    This is an additional dimensional diagnostic, not a replacement or relaxed
    result for the retained one-ppm volume comparison.
    """
    import adsk.core as core,adsk.fusion as fusion,adsk,hashlib,math
    from audit_a3 import _instances
    app,d=rt.owned();source=app.activeDocument;path=rt.BASE/(rt.NAME+'.step')
    names=['Sensor / AO2 dry body with wetted threaded nose','Chamber / AO2 hand-tight adapter reference','Chamber / A3 top manifold with serial return']
    manager=fusion.TemporaryBRepManager.get()
    native={c.name:manager.copy(body) for o,c,i,body in _instances(d) if c.name in names}
    def sample(body):
        result=[]
        for face in body.faces:
            result.append(face.pointOnFace)
            calc=face.meshManager.createMeshCalculator();calc.surfaceTolerance=.0001;calc.maxSideLength=.1
            mesh=calc.calculate();nodes=mesh.nodeCoordinates
            stride=max(1,math.ceil(len(nodes)/120))
            result.extend(nodes[::stride])
        return result
    native_samples={name:sample(body) for name,body in native.items()}
    imported=None;report={'step_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'tolerance_mm':.02,
      'method':'Every face point plus up to120 deterministic tessellation nodes per face, in both directions; mesh chord0.001mm, maximumedge1mm. Point-to-body minimum distances in Fusion. Sampled dimensional evidence, not an exhaustive Hausdorff bound or replacement for the strict volume diagnostic.', 'parts':[]}
    try:
        imported=app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(path)))
        if not imported:raise RuntimeError('STEP import failed')
        imported.activate();check=fusion.Design.cast(app.activeProduct)
        bodies={c.name:manager.copy(body) for o,c,i,body in _instances(check) if c.name in names}
        for name in names:
            row={'component':name,'directions':[]}
            for direction,points,target in [('native_to_STEP',native_samples[name],bodies[name]),('STEP_to_native',sample(bodies[name]),native[name])]:
                worst=0.;where=None
                for i,pt in enumerate(points):
                    value=app.measureManager.measureMinimumDistance(pt,target).value*10
                    if value>worst:worst=value;where=[pt.x*10,pt.y*10,pt.z*10]
                    if i%200==0:adsk.doEvents()
                row['directions'].append({'direction':direction,'sample_count':len(points),'maximum_distance_mm':worst,'worst_point_mm':where,'pass':worst<=.02})
            report['parts'].append(row)
        report['sampled_dimensions_pass']=all(x['pass'] for p in report['parts'] for x in p['directions'])
        rt.save_report('step-surface-diagnostic.json',report)
        if not report['sampled_dimensions_pass']:raise RuntimeError('STEP dimensional sample exceeded0.02mm')
    finally:
        if imported:imported.close(False)
        source.activate()
