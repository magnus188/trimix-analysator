from pathlib import Path
import sys,sexpdata,hashlib,json,collections
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import *
a=sexpdata.loads((D/'before.kicad_pcb').read_text());b=sexpdata.loads((D/'Trimix_Analyzer.kicad_pcb').read_text());n=Native(b)
def sha(f):return hashlib.sha256((D/f).read_bytes()).hexdigest()
def copper(raw):return {sub(q,'uuid')[0]:q for q in raw if tag(q)in['segment','via','arc']}
old,new=copper(a),copper(b)
def describe(uid,q):
 d=dict(uuid=uid,type=tag(q),net=sub(q,'net')[0])
 if tag(q)=='segment':d.update(layer=sub(q,'layer')[0],start_mm=sub(q,'start'),end_mm=sub(q,'end'),width_mm=sub(q,'width')[0])
 else:d.update(at_mm=sub(q,'at'),diameter_mm=sub(q,'size')[0],drill_mm=sub(q,'drill')[0],layers=sub(q,'layers'))
 return d
added=[describe(u,new[u])for u in sorted(new.keys()-old.keys())]
removed=[describe(u,old[u])for u in sorted(old.keys()-new.keys())]
changes=[u for u in old.keys()&new.keys()if old[u]!=new[u]]
clearances=[]
for item in added:
 via=item['type']=='via';L=item.get('layer');net=item['net']
 g=Point(item['at_mm'][0],-item['at_mm'][1]).buffer(item['diameter_mm']/2,quad_segs=128)if via else LineString([(x,-y)for x,y in[item['start_mm'],item['end_mm']]]).buffer(item['width_mm']/2,quad_segs=128)
 foreign=[(q['id'],q['net'],q['geo'])for q in n.pads if q['net']!=net and(via or L in q['layers']or'*.Cu'in q['layers'])]+[(str(q['a'])+'→'+str(q['b']),q['net'],q['geo'])for q in n.tracks if q['net']!=net and(via or q['layer']==L)]+[(q['id'],q['net'],q['geo'])for q in n.vias if q['net']!=net]
 nearest=sorted([(g.distance(o),label,net)for label,net,o in foreign])[:3]
 clearances.append(dict(uuid=item['uuid'],nominal_nearest_foreign_copper=nearest))
 if via:item['annulus_mm']=(item['diameter_mm']-item['drill_mm'])/2;item['overlapping_SMD_lands']=[q['id']for q in n.pads if str(q['raw'][2])=='smd'and g.intersects(q['geo'])]
drc=json.loads((D/'final-drc.json').read_text())
all_points=[pt for q in added for pt in([q['at_mm']]if q['type']=='via'else[q['start_mm'],q['end_mm']])]
report=dict(status='Three upper residual connections completed in isolated candidate; U201.13 remains unresolved.',
 source_sha256=sha('before.kicad_pcb'),output_sha256=sha('Trimix_Analyzer.kicad_pcb'),
 project_sha256=sha('Trimix_Analyzer.kicad_pro'),custom_rules_sha256=sha('Trimix_Analyzer.kicad_dru'),
 added_copper=added,removed_copper=removed,modified_existing_copper_uuids=changes,
 checks=dict(verification_project_matches_snapshot=sha('Trimix_Analyzer.kicad_pro')==sha('source-project.kicad_pro'),
  verification_rules_match_snapshot=sha('Trimix_Analyzer.kicad_dru')==sha('source-rules.kicad_dru'),
  source_matches_approved=sha('before.kicad_pcb')=='40158632831955192a2603701a928c6f53594d5937f9eee2602a55cd93141205',
  only_allowed_stub_removed=[q['uuid']for q in removed]==['083685fa-78b3-4ded-8fb3-cc7af34dad2f'],
  all_other_existing_copper_unchanged=not changes,all_footprints_unchanged=subs(a,'footprint')==subs(b,'footprint'),
  no_new_In1_tracks=all(q['type']=='via'or q['layer']!='In1.Cu'for q in added),
  plane_outlines_unchanged=[(sub(q,'name'),subs(q,'polygon'))for q in subs(a,'zone')]==[(sub(q,'name'),subs(q,'polygon'))for q in subs(b,'zone')],
  all_new_centreline_points_in_scope=all(8<=x<=21 and 47<=y<=62 for x,y in all_points),
  via_lands_do_not_overlap_SMD=all(not q.get('overlapping_SMD_lands')for q in added)),
 nominal_copper_clearances=clearances,
 native_DRC=dict(violations_by_type=dict(collections.Counter(q['type']for q in drc['violations'])),unconnected_items=len(drc['unconnected_items']),schematic_parity=len(drc['schematic_parity'])),
 approved_source_DRC=dict(unconnected_items=40,dangling_only_violations=39,schematic_parity=0),
 limitations=['Nominal geometry only, not fabrication tolerance/thermal/current-rating qualification.',
  'Planes were refilled around three ordinary through-vias; C302 has a local In2 branch; global return-plane/CAM acceptance remains separate.',
  'Only the listed copper delta should be integrated into the current owner board, then refilled and checked again.',
  'U201.13 PS/SYNC-to-VSYS remains open; no POWER_EN, package land or purchased component position was changed.'])
(D/'final-delta.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:report[k]for k in['source_sha256','output_sha256','checks','native_DRC']},indent=2))
