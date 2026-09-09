"""Purchased Guition reference details in three bounded editable BaseFeatures.

No per-contact sketches or dimensions. Three rigid native joints position whole
detail assemblies from DisplayX/DisplayY/DisplayFront. Body dimensions remain
rigid references; the existing Guition purchased parent owns every new detail.
"""
import json
import adsk.core as core
import adsk.fusion as fusion
import connector_photo_review as review


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def snapshot(design):
    """Cheap state witness; does not claim independent per-body equivalence."""
    return {
        'parameters': {p.name: p.expression for p in design.userParameters},
        'occurrences': {o.fullPathName: list(o.transform2.asArray())
                        for o in design.rootComponent.allOccurrences},
        'root_bounds_mm': review.box_bounds(design.rootComponent),
    }


def box(manager, low, high):
    body = manager.createBox(core.OrientedBoundingBox3D.create(
        core.Point3D.create(*[(a+b)/20 for a,b in zip(low,high)]),
        core.Vector3D.create(1,0,0), core.Vector3D.create(0,1,0),
        *[(b-a)/10 for a,b in zip(low,high)]))
    require(body and body.isSolid, 'Temporary box failed')
    return body


def prepared_geometry(manager):
    """Display-local XY and front-glass-relative Z, millimetres, unit scale."""
    rows=[]
    def add(name, low, high, role='details'):
        body=box(manager,low,high)
        rows.append({'name':name,'body':body,'role':role})
        return body
    def cut(body, low, high):
        require(manager.booleanOperation(body,box(manager,low,high),
                fusion.BooleanTypes.DifferenceBooleanType),'Reference cavity failed')

    # This PCB outline is illustrative. 65.06 / 102.6 in the drawing describe
    # case-body dimensions; 60 x 108 is the external casing-ear hole grid.
    # Neither establishes the exposed PCB outline or its own fixing holes.
    top=13.4-6-2.54
    add('PCB outline and thickness — illustrative, not a mounting datum',
        [2.12,4.4,top-1.6],[67.18,112.4,top])
    for name,x,y,w,h,t in [('Core shield',22,31,25,25,3),
                          ('LCD FPC latch',24,19,23,5,2),
                          ('Touch FPC latch',53,90,7,5,1.8)]:
        add(name+' — photo position / unmeasured height',[x,y,top],[x+w,y+h,top+t])
    hx,hy=35.178,100.8025
    add('JP1 reference insulator',[hx-16.51,hy-2.54,top],
        [hx+16.51,hy+2.54,top+2.54])
    for i in range(13):
        for row in range(2):
            pin=2*i+row+1
            x=hx+(i-6)*2.54;y=hy+(-1.27 if row==0 else 1.27)
            add('JP1 pin %02d%s'%(pin,' — pin1 orientation datum' if pin==1 else ''),
                [x-.32,y-.32,7.4],[x+.32,y+.32,13.4])
    for label,x,y in [('left',26.608,95.450),('right',37.922,95.149)]:
        body=add(label+' rear-facing USB-C shell — reference',
                 [x-4.75,y-2.25,top],[x+4.75,y+2.25,top+6])
        cut(body,[x-4.2,y-1.3,top+2],[x+4.2,y+1.3,top+6.1])
        add(label+' USB-C tongue — reference',
            [x-3.35,y-.35,top+2],[x+3.35,y+.35,top+5.3])
    holder=add('microSD left-facing holder — photo XY / Z reference',
               [5.284,60.202,top],[20.468,75.715,top+2.3])
    cut(holder,[4.659,62.479,top+.3],[20.459,73.879,top+1.5])
    add('Installed microSD 15 x 11 x 1 — format reference',
        [4.859,62.679,top+.4],[19.859,73.679,top+1.4],'card')
    add('Unkeyed remote JP1 socket — conditional engineering allowance',
        [hx-17.5,hy-2.75,13.4-6.223],[hx+17.5,hy+2.75,17.8],'mate')
    return rows


def _rigid_association(parent, occurrence, name):
    target=parent.jointOrigins.createInput(fusion.JointGeometry.createByPoint(parent.originConstructionPoint))
    for axis,expression in [('X','DisplayX'),('Y','DisplayY'),('Z','DisplayFront')]:
        setattr(target,'offset'+axis,core.ValueInput.createByString(expression))
    origin=parent.jointOrigins.add(target);origin.name=name+' display datum'
    source=fusion.JointGeometry.createByPoint(
        occurrence.component.originConstructionPoint.createForAssemblyContext(occurrence))
    request=parent.joints.createInput(source,origin)
    request.setAsRigidJointMotion();request.isFlipped=False
    joint=parent.joints.add(request);joint.name=name+' rigid display association'
    joint.isLightBulbOn=False;origin.isLightBulbOn=False
    return {'joint':joint.name,'origin':origin.name,
            'expressions':['DisplayX','DisplayY','DisplayFront']}


def build():
    app,doc,d=review.owned()
    require(d.timeline.count==1211, 'Must start from saved v1, not recovered partial geometry')
    require(not d.rootComponent.attributes.itemByName(review.GROUP,'photo_model_added'),
            'Photo geometry already present')
    reg=json.loads((review.PHOTO/'registration.json').read_text())
    require(reg['schema']==2 and reg['owner_depth_measurement']['distance_mm']==13.4,
            'Photo / depth source changed')
    require(review.sha(review.PHOTO/'guition-manufacturer/JC4880P443C_I_W_Y.pdf') ==
            reg['manufacturer_dimension_source_sha256'],'Manufacturer source changed')
    originals=[o for o in d.rootComponent.allOccurrences if review._legacy(o.component)]
    require(len(originals)==1,'Expected one obsolete detail occurrence')
    old=originals[0]; old_path=old.fullPathName; context=old.assemblyContext
    require(context and context.component.partNumber=='TMX-A3-C01',
            'Old detail must be under the single purchased Guition parent')
    require(max(abs(a-b) for a,b in zip(context.transform2.asArray(),core.Matrix3D.create().asArray()))<1e-9,
            'Guition parent basis differs; inspect before datum assignment')
    parent=context.component
    before=snapshot(d);before_docs=review.docs(app)
    manager=fusion.TemporaryBRepManager.get()
    bodies=prepared_geometry(manager)
    require(sum(r['name'].startswith('JP1 pin ') for r in bodies)==26,'Contact count')
    review.write('basefeature-started.json',{'status':'prepared_native_stage',
        'document':doc.name,'timeline':d.timeline.count,'source_registration_sha256':review.sha(review.PHOTO/'registration.json'),
        'old_occurrence':old_path,'new_body_count':len(bodies),'before':before,
        'documents':before_docs,'method':'Temporary BRep construction, three BaseFeatures, rigid display-origin joints; no per-pin sketches'})
    # One reversible retirement feature replaces the obsolete nine-body detail
    # occurrence. All casing/glass/frame geometry stays in the purchased parent.
    feature=parent.features.removeFeatures.add(old.nativeObject or old)
    require(feature,'Cannot retire obsolete occurrence')
    feature.name='Retire obsolete Guition PCB connector illustration'
    added=[]
    names={'details':'Guition / photo PCB, JP1, dual USB and SD holder references',
           'card':'Guition / installed microSD format reference',
           'mate':'Guition / candidate unkeyed JP1 socket allocation'}
    for role in ['details','card','mate']:
        o=parent.occurrences.addNewComponent(core.Matrix3D.create());c=o.component;c.name=names[role]
        c.description=('Supplied visual sub-detail of Guition module; not an additional BOM purchase. '
            'Photo-registered XY; exposed PCB outline, base Z, USB/SD dimensions and mounting holes are unmeasured references. '
            '26 contacts / 2.54 mm pitch and owner 13.4 mm glass-to-bare-tip are the established header datums.'
            if role=='details' else 'Card format reference only; actual capacity/MPN unselected.' if role=='card' else
            'Candidate unkeyed remote female. Guition pin7 exists. Selected main-end single-ended P07 cable does not establish this mate. Conditional depth allowance17.8 mm, not a guaranteed manufacturer maximum.')
        c.partNumber=''  # No extra purchasing quantity / manufactured identity.
        c.attributes.add(review.GROUP,'photo_geometry','true')
        c.attributes.add(review.GROUP,'geometry_role','clearance_envelope' if role=='mate' else 'photo_positioned_reference')
        c.attributes.add(review.GROUP,'purchasing_role','excluded_candidate_allocation' if role=='mate' else 'unselected_installed_card_reference' if role=='card' else 'supplied_Guition_subdetail')
        c.attributes.add('TrimixRev04','physical_group','display_harness_mate' if role=='mate' else 'display_card' if role=='card' else 'display')
        base=c.features.baseFeatures.add();base.name='Editable rigid '+role+' reference geometry'
        require(base.startEdit(),'Cannot start '+role+' BaseFeature')
        try:
            for row in bodies:
                if row['role']!=role:continue
                body=c.bRepBodies.add(row['body'],base);require(body,'Cannot add '+row['name']);body.name=row['name']
        finally:require(base.finishEdit(),'Cannot finish '+role+' BaseFeature')
        association=_rigid_association(parent,o,role)
        if role=='mate':o.isLightBulbOn=False
        added.append({'role':role,'component':c.name,'body_count':c.bRepBodies.count,**association})
        review.write('basefeature-progress.json',{'status':'completed_'+role,'added':added,'timeline':d.timeline.count})
    require(d.computeAll(),'Final reference recompute failed')
    after=snapshot(d)
    # Compare all surviving original occurrence transforms and user expressions.
    surviving={k:v for k,v in before['occurrences'].items() if k!=old_path}
    checks={'original_parameters_unchanged':before['parameters']==after['parameters'],
        'original_surviving_occurrence_poses_unchanged':all(after['occurrences'].get(k)==v for k,v in surviving.items()),
        'other_documents_preserved':[x for x in review.docs(app) if not x['name'].startswith(review.NAME)]==[x for x in before_docs if not x['name'].startswith(review.NAME)],
        'native_health':review._health(d)['healthy'],'all26pins_including7':True}
    d.rootComponent.attributes.add(review.GROUP,'photo_model_added',review.sha(review.PHOTO/'registration.json'))
    d.rootComponent.attributes.add(review.GROUP,'photo_build_method','Rigid editable BaseFeatures; 3 native DisplayX/Y/Front joint associations')
    review.write('photo-model.json',{'status':'photo_model_created' if all(checks.values()) else 'needs_review',
        'document':doc.name,'checks':checks,'added':added,'source_registration':reg,
        'source_registration_sha256':review.sha(review.PHOTO/'registration.json'),
        'reference_z_from_glass':{'PCB_top':4.86,'bare_pin_tips_measured':13.4,'mate_engineering_cap':17.8},
        'new_bodies':[{'component':o.component.name,'name':q.name,'bounds_mm':review.box_bounds(q)}
                      for o in d.rootComponent.allOccurrences if o.component.attributes.itemByName(review.GROUP,'photo_geometry') for q in o.bRepBodies],
        'preservation_scope':'Original parameters and surviving assembly transforms checked; only retired-detail occurrence and new BaseFeatures/joints modified. No independent all-body equivalence claimed.',
        'unqualified':['Exposed PCB outline / fixing holes','PCB stack and component Z','Post cross-section and usable insertion','Guition connector MPNs','Remote cable termination','USB service plug','SD socket/eject/grip','Photo parallax','Bend/fold radii'],
        'parameter_scope':'Rigid occurrence positions follow DisplayX/Y/Front; bounded regeneration remains to be tested after fit allocations are established.'})
    require(all(checks.values()),'Photo stage preservation failed; do not save')
