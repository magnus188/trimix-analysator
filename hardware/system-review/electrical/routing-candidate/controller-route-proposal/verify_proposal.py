"""Validate a scoped controller-routing patch against its immutable base."""
from pathlib import Path
import collections, hashlib, json, sys
import pcbnew as p
OUT=Path(__file__).resolve().parent
ROOT=OUT.parents[4]
sys.path.insert(0,str(ROOT/'hardware/tools'))
from analyzer_sheet import sx,child,children
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
after=OUT/'Trimix_Analyzer.kicad_pcb';before=OUT/'before.kicad_pcb'
m=json.loads((OUT/'delta.json').read_text())
assert sha(before)==m['before_sha256'] and sha(after)==m['after_sha256']
a,b=[sx.loads(f.read_text())for f in[before,after]]
def items(d,names):return{child(q,'uuid')[1]:q for name in names for q in children(d,name)}
old,new=items(a,['segment','via']),items(b,['segment','via'])
added={q['uuid']for q in m['added_items']};removed=set(m['removed_uuids'])
assert new.keys()-old.keys()==added and old.keys()-new.keys()==removed
assert all(old[k]==new[k]for k in old.keys()&new.keys()),'Unlisted existing copper modified'
f0,f1=items(a,['footprint']),items(b,['footprint']);assert f0.keys()==f1.keys()
changed=[]
for uid in f0:
 if f0[uid]!=f1[uid]:
  ref=next(q[2]for q in children(f0[uid],'property')if q[1]=='Reference')
  changed.append(ref)
  assert [q for q in f0[uid]if not(isinstance(q,list)and str(q[0])=='at')]==[q for q in f1[uid]if not(isinstance(q,list)and str(q[0])=='at')],ref+' changed beyond position'
assert changed==['C111'],changed
for name in ['general','layers','setup','gr_line','gr_arc','gr_rect','gr_poly','dimension']:
 assert children(a,name)==children(b,name),name+' modified'
def zone_rules(d):return[[q for q in z if not isinstance(q,list)or str(q[0])not in['filled_polygon','fill_segments','filled_areas_thickness']]for z in children(d,'zone')]
assert zone_rules(a)==zone_rules(b)
assert sha(OUT/'frozen-project.json')==sha(OUT/'Trimix_Analyzer.kicad_pro')
assert sha(OUT/'frozen-rules.txt')==sha(OUT/'Trimix_Analyzer.kicad_dru')
prior,post=[json.loads((OUT/f).read_text())for f in['before-drc.json','after-drc.json']]
def sig(v):return(v['type'],v['severity'],tuple(sorted(q['uuid']for q in v['items'])))
s={sig(v)for v in prior['violations']};introduced=[v for v in post['violations']if sig(v)not in s]
assert not introduced and not post['schematic_parity']
native=p.LoadBoard(str(after));fps={f.GetReference():f for f in native.GetFootprints()}
vias=[t for t in native.GetTracks()if isinstance(t,p.PCB_VIA)and t.m_Uuid.AsString()in added]
overlaps=[]
for v in vias:
 for f in native.GetFootprints():
  for pad in f.Pads():
   if pad.GetAttribute()!=p.PAD_ATTRIB_SMD:continue
   for layer in[p.F_Cu,p.B_Cu]:
    if pad.IsOnLayer(layer)and pad.GetEffectiveShape(layer).Collide(v.GetPosition(),int(v.GetWidth(layer)/2)):
     overlaps.append([v.m_Uuid.AsString(),f.GetReference(),pad.GetNumber()])
assert not overlaps
patch=[sx.Symbol('controller_route_patch'),[sx.Symbol('remove')]+[old[k]for k in sorted(removed)],[sx.Symbol('add')]+[new[q['uuid']]for q in m['added_items']],[sx.Symbol('replace_footprint')]+[[f0[k],f1[k]]for k in f0 if f0[k]!=f1[k]]]
(OUT/'route-patch.kicad_sexpr').write_text(sx.dumps(patch)+'\n')
# Include exact original nodes so integration can assert they have not changed.
(OUT/'removed-items.json').write_text(json.dumps([{'uuid':k,'type':str(old[k][0]),'exact_sexpr':sx.dumps(old[k])}for k in sorted(removed)],indent=2)+'\n')
(OUT/'added-items.kicad_sexpr').write_text(sx.dumps([sx.Symbol('controller_route_additions')]+[new[q['uuid']]for q in m['added_items']])+'\n')

def summary(d):return{'violations':len(d['violations']),'types':dict(collections.Counter(q['type']for q in d['violations'])),'unconnected':len(d['unconnected_items']),'schematic_parity':len(d['schematic_parity'])}
out={'status':'bounded_proposal_passed_not_full_board_release','before_sha256':sha(before),'after_sha256':sha(after),'added_segments':sum(q['type']=='segment'for q in m['added_items']),'added_vias':len(vias),'removed_items':len(removed),'modified_existing_items_without_explicit_replacement':0,'modified_footprints':m['changed_poses'],'zones_added':0,'zone_boundaries_rules_and_project_preserved':True,'zones_refilled':True,'new_via_overlap_with_SMD_lands':overlaps,'before_DRC':summary(prior),'after_DRC':summary(post),'introduced_DRC_violations':introduced,'frozen_signal_routes_unchanged':['USB_D_P','USB_D_M','USB_CC1','USB_CC2'],'connector_poses_unchanged':['J301','J401','J402'],'minimum_new_via_nominal_annulus_mm':min((p.ToMM(v.GetWidth(p.F_Cu))-p.ToMM(v.GetDrillValue()))/2 for v in vias),'integration':'Assert original UUID nodes match, remove only listed nodes, append additions, change only C111 at property to the documented pose. Refill zones and rerun native DRC/parity on the owner merged board. Do not replace the owner board wholesale.','limits':['Not an order release; other unconnected and dangling items remain.','C111 position requires the final MCAD height-contract and STEP export refresh.','Native DRC does not qualify EMC, analogue noise, temperature or assembly.']}
for net in out['frozen_signal_routes_unchanged']:
 # Net codes are unchanged in this exact frozen pair.
 code=next(t.GetNetCode()for t in native.GetTracks()if t.GetNetname()==net)
 assert all(old[k]==new.get(k)for k in old if child(old[k],'net')[1]==code),net+' old copper changed'
 assert not any(q['net']==net for q in m['added_items']),net+' additions'
(OUT/'proposal-verification.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps({k:out[k]for k in['status','before_sha256','after_sha256','added_segments','added_vias','removed_items','before_DRC','after_DRC']},indent=2))
