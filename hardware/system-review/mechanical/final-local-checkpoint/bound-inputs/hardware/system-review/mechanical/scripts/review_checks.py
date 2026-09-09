"""Bounded SystemReview BRep checks; alternatives never coexist physically."""
import json
from datetime import datetime,timezone
import adsk.fusion as fusion
from runtime import owned,configure,report,bounds,GROUP,other_documents

def health(d):
    import audit_a3 as a
    result=a._health(d)
    retired=[x for x in result['unhealthy_entities'] if x['health']=='suppressed' and x['name'].startswith('USB grounding wing reference')]
    result['intentionally_retired_reference_features']=retired
    result['unhealthy_entities']=[x for x in result['unhealthy_entities'] if x not in retired]
    result['pass']=not result['unhealthy_entities'] and not result['under_constrained_sketches']
    return result

def records():
    configure();import verification_a3 as v
    _,_,d=owned();manager=fusion.TemporaryBRepManager.get()
    rows=v._records(d,manager)
    for r in rows:
        if r['occurrence'].startswith('PCB A3 - main four-layer placement:'):r['physical_group']='pcb'
        elif r['occurrence'].startswith('PCB A3 - routed USB daughterboard:'):r['physical_group']='usb'
    return manager,rows

def oxygen():
    _,doc,d=owned();before=d.timeline.count;manager,rows=records()
    import verification_a3 as v
    refs=[r for r in rows if r['physical_group']=='alternative_oxygen_reference']
    if len(refs)!=3:raise RuntimeError('Expected three JJ reference solids')
    physical=v._without(rows,refs)
    ao2=[r for r in physical if r['component'] in ['Sensor / AO2 dry body with wetted threaded nose','Sensor / AO2 cable connector allowance']]
    if len(ao2)!=2:raise RuntimeError('AO2 variant selection changed')
    nose=[r for r in refs if 'nose allowance' in r['name']]
    dry=v._without(refs,nose)
    fixed=v._without(physical,ao2)
    static=v._test(manager,'JJ dry-body and provisional cable installed',dry,fixed,[(0,0,0)],['Alternative configuration replaces AO2 body and AO2 connector allowance. Nominal nose is excluded only from static mating test because thread/shoulder/seal geometry remains unverified.'])
    g=v._groups(physical)
    moving=v._without(g['closed_chamber'],ao2)+refs
    fixed=v._without(physical,g['closed_chamber'],g['rear_cover'],g['rear_cover_screws'],g['mate'],g['gas_fittings'])
    path=v._test(manager,'JJ closed sampling cartridge rear removal',moving,fixed,v._full_z_path(moving,fixed),['Power off; rear cover removed; battery disconnected; both external gas fittings and chamber harness disconnected. AO2 replaced by JJ configuration reference; lid and sensor parts remain with cartridge.'])
    if d.timeline.count!=before:raise RuntimeError('Read-only oxygen audit changed timeline')
    report('oxygen-variant-checks.json',{'generated_at_utc':datetime.now(timezone.utc).isoformat(),'document':doc.name,
        'status':'bounded_reference_checks_clear' if not static['collision_count'] and not path['collision_count'] else 'needs_review',
        'tests':[static,path],'measurement_assumptions':['Same thread is owner-confirmed; retained6.5mm nose and shoulder position are not measured.',
            'JJ extra2mm assigned to rear of barrel. Connector allowance is inherited, not actual mated plug geometry.'],
        'manufacturing_or_seal_qualification':False,'AO2_geometry_scaled':False})

def collision_report(manager,physical):
    """Exact cross-assembly intersections; excludes internal imported PCB pairs."""
    import verification_a3 as v
    hits=[];candidates=0;internal=0
    for i,p in enumerate(physical):
        for q in physical[i+1:]:
            if not v._numeric_overlap(v._record_bounds(p),v._record_bounds(q)):continue
            # Imported electronic package internals/solder interfaces are a
            # separate PCB package audit, not enclosure clearances.
            same_pcb=next((prefix for prefix in ('PCB A3 - main four-layer placement:','PCB A3 - routed USB daughterboard:') if p['occurrence'].startswith(prefix) and q['occurrence'].startswith(prefix)),None)
            if same_pcb:internal+=1;continue
            candidates+=1
            volume=v._intersection_volume(manager,p['body'],q['body'],True)
            if volume>1e-5:hits.append({'one':v._label(p),'two':v._label(q),'volume_mm3':volume})
    return {"collisions":hits,"candidate_pairs":candidates,"imported_PCB_internal_AABB_pairs_outside_enclosure_scope":internal}

def mechanical():
    app,doc,d=owned();before=d.timeline.count;manager,rows=records()
    import verification_a3 as v
    import audit_a3 as a
    alt=[r for r in rows if r['physical_group']=='alternative_oxygen_reference']
    physical=v._without(rows,alt);pair_report=collision_report(manager,physical)
    hits=pair_report["collisions"];candidates=pair_report["candidate_pairs"];internal=pair_report["imported_PCB_internal_AABB_pairs_outside_enclosure_scope"]
    feature_health=health(d)
    real=[{'index':i,'name':d.timeline.item(i).name,'message':d.timeline.item(i).errorOrWarningMessage,'state':d.timeline.item(i).healthState}
          for i in range(d.timeline.count) if d.timeline.item(i).healthState!=fusion.FeatureHealthStates.HealthyFeatureHealthState and d.timeline.item(i).objectType!=fusion.TimelineGroup.classType()
          and not(d.timeline.item(i).healthState==fusion.FeatureHealthStates.SuppressedFeatureHealthState and d.timeline.item(i).name.startswith('USB grounding wing reference'))]
    # Timeline groups may report Unknown without being a failed CAD feature.
    if d.timeline.count!=before:raise RuntimeError('Mechanical audit changed timeline')
    report('mechanical-audit.json',{'document':doc.name,'generated_at_utc':datetime.now(timezone.utc).isoformat(),
        'status':'bounded_checks_clear' if not hits and not real else 'needs_review',
        'physical_solid_count':len(physical),'alternative_reference_solids':len(alt),'candidate_pairs':candidates,
        'imported_PCB_internal_AABB_pairs_outside_enclosure_scope':internal,'collisions':hits,
        'health':feature_health,'real_nonhealthy_timeline_entities':real,'timeline':before,
        'bodies':[{'name':r['name'],'component':r['component'],'occurrence':r['occurrence'],'bounds_mm':bounds(r['body']),'volume_mm3':r['body'].volume*1000}for r in physical],
        'preserved_other_documents':other_documents(app),
        'limits':['All visible and hidden physical assembly solids tested except explicitly alternative JJ reference.',
                  'Each imported PCB assembly internal package/pad/solder collision is outside this enclosure audit scope.',
                  'Purchased models with unmeasured geometry remain references; zero clashes does not qualify actual fit or sealing.',
                  'No global minimum wall, material strength, wiring bends, leak performance or gas mixing claim.']})
