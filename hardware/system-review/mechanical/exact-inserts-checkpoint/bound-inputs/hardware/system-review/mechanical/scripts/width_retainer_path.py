"""Temporary retainer service diagnosis; no source geometry or service rules edited."""
import json
import adsk
from runtime import owned,configure,BASE,other_documents,bounds,report


def diagnose(width_mm=87):
    from width_contract_proposal import _snapshots,compare_physical
    from width_contract_checks import allocations
    import review_checks
    import verification_a3 as v
    app,doc,design=owned();configure()
    width=design.userParameters.itemByName('CaseWidth')
    if abs(width.value*10-85)>1e-6:raise RuntimeError('Start from restored85mm baseline')
    original=width.expression;parameters={p.name:p.expression for p in design.allParameters}
    timeline=design.timeline.count;protected=other_documents(app);manager,before=_snapshots()
    if width_mm not in (85,87):raise ValueError('Only reviewed endpoint variants')
    folder='retainer-path-diagnosis' if width_mm==87 else 'retainer-path-diagnosis-W85'
    directory=BASE/'verification/width-contract-tests'/folder
    result=None
    try:
        width.expression=str(width_mm)+' mm'
        if not design.computeAll():raise RuntimeError('Cannot compute retainer path endpoint')
        adsk.doEvents()
        with allocations(directory) as adapted:
            adapted_v,old_records=adapted._adapter(True)
            old_path=v._path;old_step=v.MAX_STEP_MM
            v._path=lambda waypoints,max_step_mm=.25:old_path(waypoints,max_step_mm)
            v.MAX_STEP_MM=.25
            try:
                mm,records=adapted._rows()
                # _rows uses review_checks; obtain the explicit maximum/mated
                # source adapter directly so the same actual fixed obstacles
                # plus fitted package allowances accompany the local test.
                records=adapted_v._records(design,mm);groups=v._groups(records)
                moving=[r for r in groups['display_retainers'] if r['component']=='Display / upper rear-release retainer']
                if len(moving)!=1:raise RuntimeError('Expected one actual upper retainer solid')
                fixed=v._without(records,moving,groups['rear_cover'],groups['rear_cover_screws'],
                    groups['mate'],groups['display_retainers_screws'])
                end=v._full_z_path(moving,fixed)[-1][2]
                tests=[]
                for dx in ((-1.0,-1.5) if width_mm==87 else (-1.5,)):
                    tests.append(v._test(mm,'Upper retainer rear6mm then X'+str(dx)+'mm then rear clear',moving,fixed,
                        [(0,0,0),(0,0,6),(dx,0,6),(dx,0,end)],
                        ['Cover off; battery disconnected; upper retainer screw removed.',
                         'Lower retainer remains installed and the factory display remains in its front opening.',
                         'Lift the rigid upper clip6mm rearward to clear its support, shift toward negativeX, then withdraw rearward.',
                         'Chamber, its sealed feedthrough, all other hardware, PCB and source maximum/mated allowances remain obstacles. No rotation or geometry scaling.']))
                result={'width_mm':width_mm,'tests':tests,'actual_upper_body_bounds_mm':bounds(moving[0]['body']),
                    'feedthrough_bounds_mm':[bounds(r['body']) for r in records if r['component']=='Chamber / sealed harness feedthrough allowance'],
                    'status':'staged_path_candidate_clear' if any(not t['collision_count'] for t in tests) else 'needs_chamber_first_sequence_review',
                    'method':'Actual rigid body translated at<=0.25mm intervals; exact temporary BRep Boolean intersections; no persistent retainer movement.',
                    'limits':['Finite sampled paths, not continuous swept-volume proof.','Hand access, actual wire flex and measured display-retainer interface remain unqualified.','A clear staged path is a service-sequence proposal; original straight path failure stays in the endpoint receipt.']}
            finally:
                v._records=old_records;v._path=old_path;v.MAX_STEP_MM=old_step
    finally:
        width.expression=original;computed=design.computeAll();adsk.doEvents()
        _,after=_snapshots();comparison=compare_physical(before,after,manager)
        restoration={'compute':computed,'physical':comparison,'parameters_restored':parameters=={p.name:p.expression for p in design.allParameters},
            'timeline_preserved':timeline==design.timeline.count,'protected_documents_preserved':protected==other_documents(app),
            'health':review_checks.health(design)}
        directory.mkdir(parents=True,exist_ok=True)
        (directory/'diagnosis.json').write_text(json.dumps({'diagnosis':result,'restoration':restoration},indent=2)+'\n')
        if not computed or not comparison['pass'] or not restoration['parameters_restored'] or not restoration['timeline_preserved'] or not restoration['protected_documents_preserved'] or not restoration['health']['pass']:
            raise RuntimeError('Retainer path trial restoration failed')
    print(json.dumps({'status':result['status'],'tests':[(t['name'],t['collision_count']) for t in result['tests']],
                      'restoration_pass':True,'report':str(directory/'diagnosis.json')}))


def baseline():
    """Validate the adopted -X1.5mm staged sequence at restored85mm baseline."""
    return diagnose(85)
