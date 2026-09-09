"""Reversible individual +2 mm size trials using actual assembly-context BReps.

Only the explicitly selected user parameter is varied. Every trial restores its
original expression in finally. These finite checks do not qualify arbitrary
parameter ranges, actual purchased fit, gas sealing, or manufacturing tolerances.
"""
import json
import importlib
import adsk
from datetime import datetime, timezone
from runtime import owned, configure, report, bounds, other_documents
import review_checks as checks
checks=importlib.reload(checks)

PRINTED={f'TMX-A3-P{i:02d}' for i in range(1,12)}


def _snapshot(d):
    manager, rows=checks.records()
    alternative=[r for r in rows if r['physical_group']=='alternative_oxygen_reference']
    physical=[r for r in rows if r not in alternative]
    data={}
    for r in rows:
        key=r['occurrence']+'/'+r['name']
        if key in data:raise RuntimeError('Non-unique BRep snapshot key: '+key)
        box=bounds(r['body'])
        data[key]={'bounds_mm':box,'dimensions_mm':[v-u for u,v in zip(*box)],'volume_mm3':r['body'].volume*1000}
    comp_parts={c.name:c.partNumber for c in d.allComponents}
    purchased_keys={r['occurrence']+'/'+r['name'] for r in physical
                    if comp_parts.get(r['component']) not in PRINTED}
    return manager,physical,data,purchased_keys


def _differences(before,after,keys,positions):
    if set(before)!=set(after):raise RuntimeError('Parameter trial changed body identities/count')
    changes=[]
    for key in sorted(keys):
        a,b=before[key],after[key]
        dim=max(abs(x-y) for x,y in zip(a['dimensions_mm'],b['dimensions_mm']))
        vol=abs(a['volume_mm3']-b['volume_mm3'])
        pos=max(abs(x-y) for ar,br in zip(a['bounds_mm'],b['bounds_mm']) for x,y in zip(ar,br))
        if dim>1e-4 or vol>1e-3 or (positions and pos>1e-4):
            changes.append({'body':key,'max_dimension_difference_mm':dim,'volume_difference_mm3':vol,
                            'max_position_difference_mm':pos})
    return changes


def trial(parameter):
    app,doc,d=owned();configure()
    if parameter not in ('CaseWidth','CaseHeight','CaseDepth'):raise ValueError(parameter)
    p=d.userParameters.itemByName(parameter)
    original=p.expression; original_value=p.value*10
    others=other_documents(app);timeline=d.timeline.count
    _,_,baseline,purchased=_snapshot(d)
    outcome=None;restoration=None
    try:
        p.expression=f'({original}) + 2 mm'
        if not d.computeAll():raise RuntimeError('Regeneration computeAll returned false')
        adsk.doEvents();app.activeViewport.refresh()
        manager,physical,changed,_=_snapshot(d)
        feature_health=checks.health(d)
        collision=checks.collision_report(manager,physical)
        altered_purchased=_differences(baseline,changed,purchased,False)
        outcome={'parameter':parameter,'from_mm':original_value,'to_mm':p.value*10,
                 'original_expression':original,'trial_expression':p.expression,
                 'health':feature_health,'physical_solid_count':len(physical),
                 'purchased_or_hardware_shape_changes':altered_purchased,**collision}
        outcome['pass']=feature_health['pass'] and not collision['collisions'] and not altered_purchased
    finally:
        p.expression=original
        restored_compute=d.computeAll()
        adsk.doEvents();app.activeViewport.refresh()
        _,_,restored,_=_snapshot(d)
        restored_differences=_differences(baseline,restored,set(baseline),True)
        restored_health=checks.health(d)
        other_unchanged=other_documents(app)==others
        restoration={'expression_restored':p.expression==original,'compute_success':restored_compute,
                     'all_body_shape_and_position_differences':restored_differences,
                     'health':restored_health,'timeline_unchanged':d.timeline.count==timeline,
                     'other_documents_unchanged':other_unchanged}
        restoration['pass']=all([restoration['expression_restored'],restored_compute,not restored_differences,
                                 restored_health['pass'],restoration['timeline_unchanged'],other_unchanged])
        report('regeneration-'+parameter+'.json',{'generated_at_utc':datetime.now(timezone.utc).isoformat(),
               'document':doc.name,'trial':outcome,'restoration':restoration,
               'status':'bounded_trial_pass' if outcome and outcome['pass'] and restoration['pass'] else 'needs_review',
               'limits':['One parameter varied by +2 mm at a time. No arbitrary range qualification.',
                         'Purchased body dimensions and volumes compared without scaling; pose changes are allowed.',
                         'Imported PCB internal package/pad interfaces remain outside enclosure collision scope.',
                         'Physical interfaces, wire bundles, actual sensor seals and printed material performance remain unqualified.']})
        if not restoration['pass']:raise RuntimeError('Parameter trial did not restore healthy identical baseline')
    return outcome


def width():return trial('CaseWidth')
def height():return trial('CaseHeight')
def depth():return trial('CaseDepth')
