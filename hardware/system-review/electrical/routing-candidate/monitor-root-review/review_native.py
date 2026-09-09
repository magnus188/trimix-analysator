"""Independent trace/barrel witnesses on frozen source; no save or zone inference."""
from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parents[1]/'current-path-review'))
from inventory import p,NativeGraph,stackup,estimate_edge,BASE
SHA='b116e2cce2ee3c3fa5feace5b85cfb85bf47168ddc3b5d846f0f5b15e516bc93'
f=D/'after.kicad_pcb';digest=lambda:hashlib.sha256(f.read_bytes()).hexdigest()
assert digest()==SHA
b=p.LoadBoard(str(f));g=NativeGraph(b,stackup(f.read_text()))
out=[]
for start,end in [('J101.1','R110.1'),('J101.1','TP1002.1'),('U115.6','R113.1'),('U114.5','U101.1'),('U114.5','C101.1')]:
 w=g.witness(g.pad_index[start][0],g.pad_index[end][0]);assert w['status']=='explicit_native_witness',(start,end,w)
 out.append({'from':start,'to':end,'witness':w})
w=next(q['witness'] for q in out if q['to']=='U101.1')
tracks=[g.items[u] for u in w['ordered_item_uuids'] if g.items[u]['kind']=='track']
necks=[q for q in g.items.values() if q['kind']=='track' and q['net']=='USB_CHG_5V' and q['layers']==['F.Cu'] and q['width_mm']<.399999]
assert len(necks)==1 and abs(necks[0]['width_mm']-.25)<1e-6 and abs(necks[0]['full_item_length_mm']-.5375)<1e-6,necks
assert all(q['width_mm']>=.399999 for q in tracks if q['layers']==['In2.Cu'])
assert digest()==SHA
wide=g.objects['55e55af1-694e-4910-8010-799afd29d059'];pad=g.objects[g.pad_index['U101.1'][0]]
assert pad.GetEffectiveShape(p.F_Cu).Collide(wide.GetEffectiveShape(p.F_Cu),0)
r={'status':'five_explicit_native_paths_passed','source_sha256':SHA,'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'paths':out,'remaining_nominal_025_segment':necks[0],'wide_track_directly_overlaps_U101_pin1_land':True,'nominal_025_segment_needed_by_selected_witness':necks[0]['uuid'] in w['ordered_item_uuids'],'limitations':['Trace witnesses ignore filled-zone paths and do not infer continuity through ICs','Reported path lengths include complete native items, including overlapping terminal tails','The retained 0.25mm segment is a nominal CAD item; its complete length must not be mistaken for an exposed narrow conductor when pad/wide copper overlap it','Minimum widths and connectivity do not establish current/thermal/transient performance','USB source monitoring is connected; separate RAW current feed to U115 is still unfinished']}
(D/'native-witnesses.json').write_text(json.dumps(r,indent=2)+'\n')
print(r['status'],necks[0])
