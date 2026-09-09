"""Independent immutable saved-ground and changed-via review; never writes EDA."""
from pathlib import Path
import sys,hashlib,json,collections
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parent/'cap-signal-reconnect/pullup-swap/independent-ground'))
import audit_ground as a
a.OUT=D
expected=['609a6241ce50cbe3d40f7a1676c455092db583875895eeb8236083bf2c5f0ef1','b116e2cce2ee3c3fa5feace5b85cfb85bf47168ddc3b5d846f0f5b15e516bc93']
files=[D/'before.kicad_pcb',D/'after.kicad_pcb']
assert list(map(a.sha,files))==expected
before,after=map(a.load,files)
anchors=[a.anchor_witnesses(b) for b in [before,after]]
rows=[]
for layer in ['In1.Cu','In2.Cu']:
 groups=[a.components(b,layer) for b in [before,after]]
 old,new=[{q['uuid'] for q in r if q['layers'][layer]['contact']} for r in anchors]
 rows.append({'layer':layer,'before_physical_regions':groups[0],'after_physical_regions':groups[1],'lost_ground_contacts':sorted(old-new),'gained_ground_contacts':sorted(new-old),'before_area_mm2':before['physical'][layer].area,'after_area_mm2':after['physical'][layer].area,'fill_delta_mm2':before['physical'][layer].symmetric_difference(after['physical'][layer]).area})
 assert not old-new
 assert all(g['has_anchor_to_In1'] for g in groups[1])
 if layer=='In1.Cu':assert len(groups[1])==1
assert a.zone_definitions(before['native'])==a.zone_definitions(after['native'])
assert not [t for t in after['native'].tracks if t['layer']=='In1.Cu' and t['net']!='GND']
def ids(b,name):return {q['uuid']:q for q in b['native'].__dict__[name]}
ov,nv=ids(before,'vias'),ids(after,'vias')
changed=[v for uid,v in nv.items() if uid not in ov or (v['xy'],v['drill'],v['size'],v['net'])!=(ov[uid]['xy'],ov[uid]['drill'],ov[uid]['size'],ov[uid]['net'])]
via_rows=[]
for v in changed:
 bad=[];gaps=[]
 for pad in after['native'].pads:
  if str(pad['raw'][2])=='smd':
   gap=v['geo'].distance(pad['geo']);gaps.append((gap,pad['ref'],pad['pin']))
   if gap<.049999:bad.append({'ref':pad['ref'],'pin':pad['pin'],'gap_mm':gap,'same_net':pad['net']==v['net']})
 assert not bad,(v['uuid'],bad)
 foreign=[]
 for other in after['native'].vias:
  if other['uuid']!=v['uuid'] and other['net']!=v['net']:foreign.append(v['geo'].distance(other['geo']))
 for pad in after['native'].pads:
  if pad['net']!=v['net']:foreign.append(v['geo'].distance(pad['geo']))
 for t in after['native'].tracks:
  if t['net']!=v['net']:foreign.append(v['geo'].distance(t['geo']))
 assert min(foreign)>.19999
 via_rows.append({'uuid':v['uuid'],'net':v['net'],'xy_mm':[v['xy'][0],-v['xy'][1]],'diameter_mm':v['size'],'drill_mm':v['drill'],'minimum_SMT_land_gap_mm':min(gaps)[0],'nearest_SMT':min(gaps)[1:],'minimum_foreign_copper_gap_mm':min(foreign)})
drc=json.loads((D/'owner-drc.json').read_text());types=dict(collections.Counter(q['type'] for q in drc['violations']))
assert not drc['schematic_parity']
assert set(types)<= {'track_dangling','via_dangling','silk_overlap','silk_over_copper'}
assert len(drc['unconnected_items'])==7
renders=[a.view('ground-and-power',[(before,'In1.Cu','BEFORE In1','anchors'),(after,'In1.Cu','AFTER In1','anchors'),(before,'In2.Cu','BEFORE In2','anchors'),(after,'In2.Cu','AFTER In2','anchors')],(0,70,30,99),'Saved physical ground and actual inner traces. Geometry review only.',2400),a.view('outer-copper',[(before,'F.Cu','BEFORE F.Cu','normal'),(after,'F.Cu','AFTER F.Cu','normal'),(before,'B.Cu','BEFORE B.Cu','normal'),(after,'B.Cu','AFTER B.Cu','normal')],(8,80,25,99),'Actual F/B copper. New monitor paths are low-current branches; RAW load trunk remains unconnected.',2400)]
assert list(map(a.sha,files))==expected
out={'status':'scoped_saved_geometry_passed_not_release','sources':[{'file':f.name,'sha256':h} for f,h in zip(files,expected)],'script_sha256':a.sha(Path(__file__)),'owner_drc_sha256':a.sha(D/'owner-drc.json'),'owner_drc':{'unconnected':7,'violations':types,'parity':0},'ground':rows,'new_or_changed_vias':via_rows,'zone_definitions_preserved':True,'In1_no_signals':True,'renders':renders,'limits':['No physical current, thermal, transient or EMC result','Ground ligament widths are not globally rated by this continuity check','Owner DRC is captured; this script does not run DRC','New/changed-via SMT guard is independent of ordinary DRC; unrelated old lands are not recertified','This source is not fully routed; final combined model and fabrication checks remain required']}
(D/'geometry-review.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'status':out['status'],'drc':out['owner_drc'],'vias':via_rows},indent=2))
