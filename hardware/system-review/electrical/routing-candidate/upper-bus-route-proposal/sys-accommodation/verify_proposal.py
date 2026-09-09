"""Verify an additive bus patch against its frozen native board and DRC."""
from pathlib import Path
import collections, hashlib, json, sys
import pcbnew as p
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[5]/'hardware/tools'))
from analyzer_sheet import sx,child,children
sha=lambda f:hashlib.sha256(f.read_bytes()).hexdigest()
m=json.loads((D/'delta.json').read_text());before=D/'before.kicad_pcb';after=D/'Trimix_Analyzer.kicad_pcb'
assert sha(before)==m['before_sha256'] and sha(after)==m['after_sha256']
a,b=[sx.loads(q.read_text())for q in[before,after]]
def items(d,names):return{child(q,'uuid')[1]:q for name in names for q in children(d,name)}
old,new=items(a,['segment','via']),items(b,['segment','via']);add={q['uuid']for q in m['added_items']}
removed=set(m['removed_uuids'])
assert removed=={'3c0670f1-c03a-4a0a-bf6a-33687f86a6cc','e1670b7a-858d-41a6-aa2d-11c5439e603d'} and not m['changed_poses']
assert old.keys()-new.keys()==removed and new.keys()-old.keys()==add
assert all(old[k]==new[k]for k in old.keys()-removed),'Unlisted existing copper changed'
assert all(child(old[k],'net')[1]=='CHG_INT_N'for k in removed)
assert items(a,['footprint'])==items(b,['footprint']),'Footprint changed'
for name in ['general','layers','setup','gr_line','gr_arc','gr_rect','gr_poly','dimension']:
 assert children(a,name)==children(b,name),name+' changed'
def zone_rules(d):return[[q for q in z if not isinstance(q,list)or str(q[0])not in['filled_polygon','fill_segments','filled_areas_thickness']]for z in children(d,'zone')]
assert zone_rules(a)==zone_rules(b)
assert sha(D/'frozen-project.json')==sha(D/'Trimix_Analyzer.kicad_pro')
assert sha(D/'frozen-rules.txt')==sha(D/'Trimix_Analyzer.kicad_dru')
prior,post=[json.loads((D/f).read_text())for f in['before-drc.json','after-drc.json']]
def sig(v):return(v['type'],v['severity'],tuple(sorted(q['uuid']for q in v['items'])))
previous={sig(v)for v in prior['violations']};introduced=[v for v in post['violations']if sig(v)not in previous]
assert not introduced and not post['schematic_parity'],introduced
native=p.LoadBoard(str(after));vias=[t for t in native.GetTracks()if isinstance(t,p.PCB_VIA)and t.m_Uuid.AsString()in add]
overlaps=[];gaps=[]
for v in vias:
 nearest=None
 for f in native.GetFootprints():
  for pad in f.Pads():
   if pad.GetAttribute()!=p.PAD_ATTRIB_SMD:continue
   for L in[p.F_Cu,p.B_Cu]:
    if not pad.IsOnLayer(L):continue
    shape=pad.GetEffectiveShape(L);radius=int(v.GetWidth(L)/2)
    if shape.Collide(v.GetPosition(),radius):overlaps.append([v.m_Uuid.AsString(),f.GetReference(),pad.GetNumber()])
    # Binary distance probe over native pad shape, not its rectangular bounds.
    lo,hi=0.,2.
    if not shape.Collide(v.GetPosition(),radius+p.FromMM(hi)):continue
    for _ in range(22):
     mid=(lo+hi)/2
     if shape.Collide(v.GetPosition(),radius+p.FromMM(mid)):hi=mid
     else:lo=mid
    if nearest is None or lo<nearest['gap_mm']:nearest={'reference':f.GetReference(),'pad':pad.GetNumber(),'gap_mm':lo,'same_net':pad.GetNetname()==v.GetNetname()}
 gaps.append({'uuid':v.m_Uuid.AsString(),'at_mm':[p.ToMM(v.GetPosition().x),p.ToMM(v.GetPosition().y)],'nearest_SMD':nearest})
assert not overlaps
assert all(q['net']in['I2C_SCL','CHG_INT_N']for q in m['added_items'])
assert all(q['layer']!='In1.Cu'and q['width_mm']==.15 for q in m['added_items']if q['type']=='segment')
assert all(q['diameter_mm']==.5 and q['drill_mm']==.25 for q in m['added_items']if q['type']=='via')
patch=[sx.Symbol('upper_bus_route_patch'),[sx.Symbol('remove')]+[old[k]for k in sorted(removed)],[sx.Symbol('add')]+[new[q['uuid']]for q in m['added_items']],[sx.Symbol('replace_footprint')]]
(D/'route-patch.kicad_sexpr').write_text(sx.dumps(patch)+'\n');(D/'added-items.kicad_sexpr').write_text(sx.dumps([sx.Symbol('upper_bus_additions')]+[new[q['uuid']]for q in m['added_items']])+'\n');(D/'removed-items.json').write_text(json.dumps([{'uuid':k,'exact_sexpr':sx.dumps(old[k])}for k in sorted(removed)],indent=2)+'\n')
def summary(d):return{'violations':len(d['violations']),'types':dict(collections.Counter(q['type']for q in d['violations'])),'unconnected':len(d['unconnected_items']),'schematic_parity':len(d['schematic_parity'])}
out={'status':'isolated_scoped_proposal_passed_native_DRC_not_board_release','before_sha256':sha(before),'after_sha256':sha(after),'added_segments':sum(q['type']=='segment'for q in m['added_items']),'added_vias':len(vias),'removed_items':len(removed),'modified_existing_copper_without_explicit_replacement':0,'modified_footprints':0,'zones_added':0,'zone_boundaries_rules_and_project_preserved':True,'zones_refilled':True,'new_via_SMD_overlaps':overlaps,'new_via_nearest_land_gaps':gaps,'before_DRC':summary(prior),'after_DRC':summary(post),'introduced_DRC_violations':introduced,'In1_signal_additions':0,'new_trace_width_mm':.15,'new_via_diameter_drill_mm':[.50,.25],'new_via_annulus_mm':.125,'approved_SYS_accommodation':{'removed_CHG_uuids':sorted(removed),'reserved_SYS_In2_path_mm':[[15.84,84.25],[17.5,83.9],[19,83.3]],'reserved_SYS_width_mm':.40},'integration':'Remove only the two exact approved CHG nodes after matching its frozen content, then append the exact new segment/via UUID nodes; do not replace the owner board. Refill zones and rerun native DRC/parity on the merged board. Review actual inner-plane cuts and parent HOST/QON overlays.','limits':['Not an ordering release: other unconnected and dangling findings remain.','No component positions, package dimensions or board outlines changed; two original CHG segments are replaced by the approved SYS crossing; other original copper is preserved.','Native DRC does not qualify noise, power return impedance, temperature, EMI or fabrication.']}
assert out['after_DRC']['unconnected']<=out['before_DRC']['unconnected']
from island_targets import connected_track_targets
original=p.LoadBoard(str(before));connectivity={}
for net,seed in [('I2C_SDA','63ebb62c-ea26-4749-8643-c85664c750fa'),('I2C_SCL','0ee9e820-7ebd-475d-8dca-983bb85d13d0'),('CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5')]:
 _,old_island=connected_track_targets(original,net,seed,[0,0,30,99])
 _,new_island=connected_track_targets(native,net,seed,[0,0,30,99])
 assert set(old_island['connected_object_uuids'])-removed<=set(new_island['connected_object_uuids']),net+' original connectivity broken'
 connectivity[net]={'before':old_island,'after':new_island}
assert 'c3e3a637-6b86-471a-b769-9a93dc58b2c5'in connectivity['CHG_INT_N']['after']['connected_object_uuids']
if any(q['net']=='I2C_SCL'for q in m['added_items']):assert '532da661-1898-4d38-b7fc-5d71fe61ab57'in connectivity['I2C_SCL']['after']['connected_object_uuids']
out['native_copper_connectivity']=connectivity
out['files']={name:sha(D/name)for name in['delta.json','route-patch.kicad_sexpr','added-items.kicad_sexpr','before-drc.json','after-drc.json','build_sys_bridge.py','run_routes.py','route_bounded.py']}
(D/'proposal-verification.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
