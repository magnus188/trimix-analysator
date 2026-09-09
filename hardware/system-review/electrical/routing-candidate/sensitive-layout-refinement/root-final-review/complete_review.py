"""Bind root-reviewed layout results without claiming physical or factory release."""
from pathlib import Path
import json,hashlib
D=Path(__file__).resolve().parent;bundle=D.parent/'frozen-local-bundle';E=D.parents[2]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.load(open(bundle/'review/geometry-handoff-manifest.json'))
checks=[dict(path=r['path'],sha256=sha(bundle/r['path']),passed=sha(bundle/r['path'])==r['sha256']and(bundle/r['path']).stat().st_size==r['bytes'])for r in m['files']]
assert all(r['passed']for r in checks)
a=json.load(open(E/'routing-candidate/final-cleanup/root-review/current-paths/inventory.json'));b=json.load(open(D/'current-paths/inventory.json'));p=json.load(open(D/'refined-local-paths.json'));g=json.load(open(D/'refined-ground-review.json'))
assert a['source_sha256']=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
assert b['source_sha256']==p['source_sha256']==g['after_sha256']==m['board_sha256']=='0962ad86f9834ce71b6439d0f95db603753801153490e78f387a88521e582788'
pairs=[]
for x,y in zip(a['pairs'],b['pairs']):
 assert(x['source'],x['target'])==(y['source'],y['target'])and x['ordered_edges']==y['ordered_edges']and y['status']=='explicit_native_witness'
 pairs.append(dict(source=y['source'],target=y['target'],same_ordered_native_edges=True))
assert len(pairs)==29 and len(p['paths'])==35 and p['all_five_target_paths_shorter']
assert g['layers']['In1.Cu']['removed_ground_anchor_uuids']==['65de2131-f4a0-4d16-a224-ebeb297b275a']
assert not g['layers']['In1.Cu']['lost_contacts_on_retained_anchors']and not g['layers']['In2.Cu']['lost_contacts_on_retained_anchors']
assert g['layers']['In2.Cu']['added_fill_mm2']==g['layers']['In2.Cu']['removed_fill_mm2']==0
drc=json.load(open(bundle/'review/drc.json'));assert not drc['violations']and not drc['unconnected_items']and not drc['schematic_parity']
visuals=[D/'refined-ground-comparison.png',D/'refined-local-copper.png',bundle/'review/co.png',bundle/'review/bq.png']
assert all(q.is_file()for q in visuals)
g['visual_review']=dict(status='PASSED_SCOPED_REVIEW',images=[dict(path=str(q.resolve()),sha256=sha(q))for q in visuals[:2]],finding='In1 remains one connected reference, with new local grounded barrels; no retained ground contact is lost. In2 geometry is unchanged. Local routing changes are confined to reviewed converter/capacitor/resistor regions.')
g['removed_ground_anchor_disposition']=dict(uuid='65de2131-f4a0-4d16-a224-ebeb297b275a',old_xy_mm=[8,71.775],reason='Old C107 front capacitor ground branch removed when capacitor moved to rear. New short branch reaches ordinary via16.05,78.05 and connectedIn1.',replacement_uuid='17d7cffd-21ed-4b7b-bfa5-65d7f8062f72')
g['status']='SAVED_GROUND_TOPOLOGY_AND_VISUAL_REVIEW_PASSED'
(D/'refined-ground-review.json').write_text(json.dumps(g,indent=2)+'\n')
sources=[bundle/'review/geometry-handoff-manifest.json',D/'refined-local-paths.json',D/'refined-ground-review.json',D/'current-paths/inventory.json',E/'final-power-layout-review/review_refined_native.py',E/'final-power-layout-review/review_refined_ground.py',E/'current-path-review/inventory.py',E/'routing-candidate/cap-signal-reconnect/pullup-swap/independent-ground/audit_ground.py',E/'sensitive-layout-refinement/c107-0805/root-source-and-layout-review.json',E/'sensitive-layout-refinement/r504-independent/verification-receipt.json',Path(__file__)]
r=dict(status='PASSED_DIGITALLY_FOR_SCOPED_POWER_LAYOUT_AND_GROUND_REVIEW',board_sha256=m['board_sha256'],geometry_manifest_checks=checks,power_paths=pairs,local_trace_path_count=35,layout_comparisons=p['selected_layout_comparisons'],output_capacitor_ground_return=p['direct_output_ground_return'],native_DRC=dict(violations=0,opens=0,parity=0),ground_summary={k:dict(physical_regions=len(v['physical_regions']),anchors=v['after_anchor_count'],retained_contacts_lost=len(v['lost_contacts_on_retained_anchors']))for k,v in g['layers'].items()},visuals_inspected=[dict(path=str(q.resolve()),sha256=sha(q))for q in visuals],bound_sources=[dict(path=str(q.resolve()),sha256=sha(q))for q in sources],disposition='Four identified layout corrections are implemented: shorter bootstrap/REGN, shortCOfeedback and closeoutputcap with directFgroundreturn. This is a layout improvement under manufacturer guidance, not a regulator stability or gas-noise qualification.',limits=['FreshERC/sourcevalidation, manufacturingCAM/process acceptance and finalCADfit have separate gates.','C107 startup demand, biasedcapacitance/ripple and thermal behaviour remainphysicaltestingpending.','R504 filteredexcitationmonitor is covered byIn1below northerninductoredge; actualpickup/qualification-window behaviour remainsunmeasured.','Sourcecurrent/transientprotection, Guitionpowerentry, actualcells/connectormates and externalfactoryapproval stillblockordering.'],order_release=False)
(D/'root-power-layout-review.json').write_text(json.dumps(r,indent=2)+'\n');print(dict(status=r['status'],geometry_files=len(checks),power_paths=len(pairs),local_paths=35))
