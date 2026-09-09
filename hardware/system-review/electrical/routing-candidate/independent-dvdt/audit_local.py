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
added=[describe(u,new[u])for u in sorted(new.keys()-old.keys())];removed=[describe(u,old[u])for u in sorted(old.keys()-new.keys())];changes=[u for u in old.keys()&new.keys()if old[u]!=new[u]]
clearances=[]
for item in added:
 L=item['layer'];net=item['net'];g=LineString([(x,-y)for x,y in[item['start_mm'],item['end_mm']]]).buffer(item['width_mm']/2,quad_segs=128)
 foreign=[(q['id'],q['net'],q['geo'])for q in n.pads_on(L)if q['net']!=net]+[(str(q['a'])+'→'+str(q['b']),q['net'],q['geo'])for q in n.tracks if q['net']!=net and q['layer']==L]+[(q['id'],q['net'],q['geo'])for q in n.vias if q['net']!=net]
 nearest=sorted([(g.distance(o),label,net)for label,net,o in foreign])[:3];clearances.append(dict(uuid=item['uuid'],nominal_nearest_foreign_copper=nearest))
def fps(raw):return {dict((v[1],v[2])for v in subs(q,'property'))['Reference']:q for q in subs(raw,'footprint')}
aa,bb=fps(a),fps(b);changedfps=[ref for ref in aa if aa[ref]!=bb[ref]]
positions={ref:dict(before_at=sub(aa[ref],'at'),after_at=sub(bb[ref],'at'),uuid=sub(bb[ref],'uuid')[0])for ref in changedfps}
drc=json.loads((D/'final-drc.json').read_text());base=json.loads((D/'baseline-drc.json').read_text())
baseitems={q['type']+':'+','.join(sorted(x['uuid']for x in q['items']))for q in base['violations']}
newviol=[q for q in drc['violations']if q['type']+':'+','.join(sorted(x['uuid']for x in q['items']))not in baseitems]
allowed=set(json.loads((D/'ordered-results.json').read_text())[0]['removed']+['51e38235-6fa6-42a4-a681-1ca4736c7fc9','50ab0909-e3af-442a-9258-f6ab20dd176b'])
points=[pt for q in added for pt in[q['start_mm'],q['end_mm']]]
report=dict(status='Complete local DVDT reconnection; isolated proposal, not whole-board release.',source_sha256=sha('before.kicad_pcb'),output_sha256=sha('Trimix_Analyzer.kicad_pcb'),project_sha256=sha('Trimix_Analyzer.kicad_pro'),custom_rules_sha256=sha('Trimix_Analyzer.kicad_dru'),added_copper=added,removed_copper=removed,modified_existing_copper_uuids=changes,changed_footprints=positions,
checks=dict(source_matches_approved=sha('before.kicad_pcb')=='996e9676ff714fa5d2dd904934af3e44114bcfe34cb4e7035ef05024aedc1189',verification_project_matches_snapshot=sha('Trimix_Analyzer.kicad_pro')==sha('source-project.kicad_pro'),verification_rules_match_snapshot=sha('Trimix_Analyzer.kicad_dru')==sha('source-rules.kicad_dru'),only_authorized_copper_removed=set(q['uuid']for q in removed)==allowed,all_retained_copper_unchanged=not changes,only_C116_footprint_changed=changedfps==['C116'],plane_outlines_and_settings_unchanged=[[v for v in z if tag(v)not in ['filled_polygon','fill_segments']]for z in subs(a,'zone')]==[[v for v in z if tag(v)not in ['filled_polygon','fill_segments']]for z in subs(b,'zone')],only_B_tracks_added=all(q['type']=='segment'and q['layer']=='B.Cu'and q['width_mm']==.15 for q in added),all_centreline_points_in_approved_scope=all(15<=x<=19 and 88.5<=y<=91.3 or 16<=x<=18.2 and 91.3<=y<=91.55 for x,y in points),no_new_DRC_violations=not newviol),nominal_copper_clearances=clearances,native_DRC=dict(violations_by_type=dict(collections.Counter(q['type']for q in drc['violations'])),unconnected_items=len(drc['unconnected_items']),schematic_parity=len(drc['schematic_parity']),new_violations=newviol),approved_source_DRC=dict(unconnected_items=32,dangling_only_violations=33,schematic_parity=0),limitations=['Nominal geometry check only; not thermal, analogue, manufacturing-tolerance or whole-board release acceptance.','Integrate this bounded copper and C116-pose delta, not the entire isolated board, then refill and run native DRC on the current owner board.','The narrow ILM path deliberately follows the actual rounded C116 land around the preserved Q via; do not replace with a bounding-box corner or simplify through the via.'])
(D/'final-delta.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({k:report[k]for k in['source_sha256','output_sha256','checks','native_DRC']},indent=2))
