from pathlib import Path
import sys,sexpdata,hashlib,json,collections,math
D=Path(__file__).resolve().parent;sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()));from cam_geometry import *
a,b=[sexpdata.loads((D/f).read_text())for f in ['before.kicad_pcb','Trimix_Analyzer.kicad_pcb']];n=Native(b)
def sha(f):return hashlib.sha256((D/f).read_bytes()).hexdigest()
def copper(raw):return{sub(q,'uuid')[0]:q for q in raw if tag(q)in['segment','via','arc']}
old,new=copper(a),copper(b);added=[]
for uid in sorted(new.keys()-old.keys()):
 q=new[uid];row=dict(uuid=uid,type=tag(q),net=sub(q,'net')[0])
 if tag(q)=='segment':row.update(layer=sub(q,'layer')[0],start_mm=sub(q,'start'),end_mm=sub(q,'end'),width_mm=sub(q,'width')[0])
 else:row.update(at_mm=sub(q,'at'),diameter_mm=sub(q,'size')[0],drill_mm=sub(q,'drill')[0],layers=sub(q,'layers'))
 added.append(row)
clear=[]
for it in added:
 vv=it['type']=='via';L=it.get('layer');net=it['net']
 g=Point(it['at_mm'][0],-it['at_mm'][1]).buffer(it['diameter_mm']/2,quad_segs=128)if vv else LineString([(x,-y)for x,y in[it['start_mm'],it['end_mm']]]).buffer(it['width_mm']/2,quad_segs=128)
 foreign=[(q['id'],q['geo'])for q in n.pads if q['net']!=net and(vv or L in q['layers']or'*.Cu'in q['layers'])]+[(str(q['a'])+'→'+str(q['b']),q['geo'])for q in n.tracks if q['net']!=net and(vv or q['layer']==L)]+[(q['id'],q['geo'])for q in n.vias if q['net']!=net]
 clear.append({'uuid':it['uuid'],'nearest_nominal_foreign_copper':sorted([(g.distance(q),label)for label,q in foreign])[:3]})
 if vv:it['overlapping_any_SMD_land']=[q['id']for q in n.pads if str(q['raw'][2])=='smd'and g.intersects(q['geo'])]
r=json.loads((D/'final-drc.json').read_text());baseline=json.loads((D/'baseline-drc.json').read_text())
def issue_key(q):return(q['type'],tuple(sorted(x['uuid']for x in q['items'])))
old_issues={issue_key(q)for q in baseline['violations']}
new_issues=[q for q in r['violations']if issue_key(q)not in old_issues]
lengths=collections.defaultdict(float)
for q in added:
 if q['type']=='segment':lengths[q['layer']]+=math.dist(q['start_mm'],q['end_mm'])
checks=dict(no_new_native_DRC_violations=not new_issues,expected_frozen_source=sha('before.kicad_pcb')=='20b27514e8a1e858c7afc8e599f33283b9fbe2a249da87b5c0d692a1877cd7a6',project_matches_snapshot=sha('Trimix_Analyzer.kicad_pro')==sha('source-project.kicad_pro'),rules_match_snapshot=sha('Trimix_Analyzer.kicad_dru')==sha('source-rules.kicad_dru'),all_existing_copper_retained=not(old.keys()-new.keys()),all_existing_copper_identical=all(old[u]==new[u]for u in old),all_footprints_identical=subs(a,'footprint')==subs(b,'footprint'),all_added_copper_USB_CC_INT_N=all(q['net']=='USB_CC_INT_N'for q in added),no_In1_signal_tracks=all(q['type']!='segment'or q['layer']!='In1.Cu'for q in added),ordinary_new_vias=all(q['type']!='via'or q['diameter_mm']==.5 and q['drill_mm']==.25 for q in added),no_new_via_over_any_SMD_land=all(not q.get('overlapping_any_SMD_land')for q in added),all_new_tracks_point15=all(q['type']!='segment'or q['width_mm']==.15 for q in added),all_zone_outlines_and_settings_preserved=[[v for v in z if tag(v)not in['filled_polygon','fill_segments']]for z in subs(a,'zone')]==[[v for v in z if tag(v)not in['filled_polygon','fill_segments']]for z in subs(b,'zone')])
assert all(checks.values())
out=dict(status='Isolated CC route on frozen HOST candidate; awaiting parent integration review',source_sha256=sha('before.kicad_pcb'),output_sha256=sha('Trimix_Analyzer.kicad_pcb'),added_copper=added,removed_copper=[],changed_existing_copper=[],checks=checks,added_track_length_mm=dict(lengths),native_DRC=dict(violations_by_type=dict(collections.Counter(q['type']for q in r['violations'])),unconnected_items=len(r['unconnected_items']),schematic_parity=len(r['schematic_parity'])),source_DRC=dict(unconnected_items=20,dangling_only_violations=30,schematic_parity=0),nominal_copper_clearances=clear,limitations=['Nominal geometric/layout evidence only; no current rating, thermal, parasitic or physical signal-integrity acceptance.','Only USB_CC_INT_N copper is added; the HOST source includes other root-owned changes that must not be merged twice.','Before/after In1/In2 and power overlays must be reviewed; see final-plane-audit.json.'])
(D/'final-delta.json').write_text(json.dumps(out,indent=2)+'\n');print(out['output_sha256'],dict(lengths),out['native_DRC'],min(q['nearest_nominal_foreign_copper'][0][0]for q in clear))
