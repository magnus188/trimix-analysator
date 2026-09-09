"""Measurement-derived JJ alternative. No scaling of purchased AO2 geometry.

The user measured -2 mm body diameter and +2 mm overall length, and confirmed
the same thread. An unchanged nose/shoulder location is an explicit assumption,
not an asserted measurement. This hidden component is a configuration reference.
"""
import json
import adsk.core as core
import adsk.fusion as fusion
from runtime import owned,configure,report,bounds,GROUP

NAME='Configuration reference — JJ oxygen sensor measurement envelope'

def build():
    app,doc,d=owned();b=configure()
    if any(c.name==NAME for c in d.allComponents):raise RuntimeError('JJ alternative already exists')
    for n,e,c in [
        ('JJDiameterDelta','-2 mm','Owner measured versus AO2 body; caliper uncertainty not supplied'),
        ('JJLengthDelta','2 mm','Owner measured versus AO2 overall length; shoulder datum unverified')]:
        if d.userParameters.itemByName(n):raise RuntimeError('Unexpected pre-existing '+n)
        d.userParameters.add(n,core.ValueInput.createByString(e),'mm',c)
    c=b.new(NAME,'Owner comparative dimensions; configuration envelope only; no supplier CAD or verified sealing datum')
    c.partNumber='REF-JJ-O2';c.description='Alternative JJ oxygen sensor; measured diameter -2 mm and length +2 mm relative to AO2'
    b.mark(c,'alternative_oxygen_reference')
    c.attributes.add(b.GROUP,'geometry_role','configuration_reference')
    c.attributes.add(GROUP,'variant','JJ')
    c.attributes.add(GROUP,'exclude_from_default_physical_assembly','true')
    basis={'source':'Owner comparison: same thread; 2 mm smaller diameter and 2 mm longer',
           'assumptions':['AO2 nose X32.5..39 mm and shoulder X39 mm retained provisionally; same thread alone does not establish this datum.',
                          'All extra length is provisionally assigned behind the shoulder.',
                          'The 6.5 x 10 x 10 mm cable box is an inherited unmeasured allowance, translated 2 mm; it is not the actual JJ plug.'],
           'not_verified':['Thread tolerance and runout','Sealing face position and diameter','Seal stock/compression','Mated cable size and bend','Complete JJ identity']}
    c.attributes.add(GROUP,'measurement_basis',json.dumps(basis))
    barrel=b.xcyl(c,'JJ dry-body clearance: Ø27.3 ×33.75 reference','CaseWidth-46 mm','CaseHeight-37.5 mm','21.75 mm','(29.3 mm+JJDiameterDelta)/2','31.75 mm+JJLengthDelta')
    nose=b.xcyl(c,'JJ same-thread nominal nose allowance','CaseWidth-52.5 mm','CaseHeight-37.5 mm','21.75 mm','8 mm','6.5 mm')
    cable=b.box(c,'JJ unmeasured mated-cable allowance','CaseWidth-14.25 mm+JJLengthDelta','CaseHeight-42.5 mm','16.75 mm','6.5 mm','10 mm','10 mm')
    for body in (barrel,nose,cable):body.attributes.add(GROUP,'reference_only','true')
    occurrence=next(o for o in d.rootComponent.occurrences if o.component==c)
    occurrence.isLightBulbOn=False
    if not d.computeAll():raise RuntimeError('JJ alternative recompute failed')
    report('oxygen-variant-created.json',{'document':doc.name,'component':c.name,'part_number':c.partNumber,
        'bodies':[{'name':q.name,'bounds_mm':bounds(q)}for q in c.bRepBodies],
        'default_visibility':False,'basis':basis,'AO2_purchased_geometry_scaled':False})

def bind_datums():
    """Existing alternative follows the same width-dependent shoulder as AO2."""
    _,doc,d=owned();expected={'39mm':'CaseWidth - 46 mm','32.5mm':'CaseWidth - 52.5 mm',
                           '70.75mm+JJLengthDelta':'CaseWidth - 14.25 mm + JJLengthDelta'}
    changes=[]
    for p in d.allParameters:
        owner=getattr(p,'createdBy',None)
        if not owner or not owner.name.startswith('JJ '):continue
        old=''.join(p.expression.split())
        if old in expected:
            changes.append({'name':p.name,'old':p.expression,'new':expected[old]})
    if len(changes)!=3:raise RuntimeError('Expected three initial JJ position expressions')
    for row in changes:
        p=d.allParameters.itemByName(row['name'])
        if abs(d.unitsManager.evaluateExpression(p.expression,'mm')-d.unitsManager.evaluateExpression(row['new'],'mm'))>1e-8:raise RuntimeError('JJ datum edit changes baseline geometry')
        p.expression=row['new']
    if not d.computeAll():raise RuntimeError('JJ datum recompute failed')
    report('oxygen-parametric-datums.json',{'document':doc.name,'changes':changes,'baseline_geometry_changed':False,
        'intent':'JJ alternative follows the same shoulder datum as AO2 when CaseWidth changes; no diameter/length scaling.'})
