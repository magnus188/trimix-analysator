"""Root's bounded power/return review; no board writes or physical claims."""
from pathlib import Path
import sys,json,hashlib
D=Path(__file__).resolve().parent
sys.path.insert(0,str(D.parent/'current-path-review'))
from inventory import p,NativeGraph,stackup
files=[('limiter-rotation-trial.kicad_pcb','96168e28d9cd7d2fc396e15c9a404e2f6ec07541b285cb1aae62b65994a8278c'),('power-gateway-clean.kicad_pcb','b93bd7190b482e6d6df343627eb468399ebea0e6bef6b6647b078efc490cdef8')]
graphs=[]
for name,digest in files:
 f=D/name;assert hashlib.sha256(f.read_bytes()).hexdigest()==digest
 b=p.LoadBoard(str(f));graphs.append(NativeGraph(b,stackup(f.read_text())))
ground=json.loads((D/'power-gateway-ground.json').read_text())
assert [r['sha256']for r in ground['inputs']]==[h for _,h in files]
assert all(r['In1_ground_filled_regions']==1 for r in ground['inputs'])
assert all(q['direct_barrel_anchors']for r in ground['inputs']for q in r['local_In2_ground_filled_regions'])
regn=[]
for g in graphs:
 w=g.witness(g.pad_index['U101.22'][0],g.pad_index['C107.1'][0]);assert w['status']=='explicit_native_witness';regn.append(w)
assert regn[0]['ordered_item_uuids']==regn[1]['ordered_item_uuids']
g=graphs[1]
input_path=g.witness(g.pad_index['U114.5'][0],g.pad_index['U101.1'][0]);assert input_path['status']=='explicit_native_witness'
assert input_path['layer_summary']['In2.Cu']['minimum_width_mm']>=.399999
def ground_path(ref,at):
 matches=[u for u,q in g.objects.items()if isinstance(q,p.PCB_VIA)and abs(p.ToMM(q.GetPosition().x)-at[0])<1e-6 and abs(p.ToMM(q.GetPosition().y)-at[1])<1e-6]
 assert len(matches)==1
 u=matches[0];v=g.objects[u];assert v.GetNetname()=='GND'and v.IsOnLayer(p.In1_Cu)
 w=g.witness(g.pad_index[ref][0],u);assert w['status']=='explicit_native_witness'
 return {'source':ref,'ground_via_xy_mm':at,'direct_barrel_to_In1':True,'witness':w}
returns=[ground_path('U114.3',[10.45,90.5]),ground_path('C114.2',[11.1,91.1]),ground_path('C101.2',[7.75,85.525]),ground_path('C105.2',[7.75,85.525])]
out={'status':'scoped_geometry_and_conductor_review_passed_for_consolidation','inputs':[{'file':n,'sha256':h}for n,h in files],'viewed':'power-gateway-ground.png','ground_report_sha256':hashlib.sha256((D/'power-gateway-ground.json').read_bytes()).hexdigest(),'In1_continuous_before_after':True,'all_ten_resulting_local_In2_regions_have_ground_barrels':len(ground['inputs'][1]['local_In2_ground_filled_regions'])==10,'input_path':input_path,'direct_ground_returns':returns,'REGN_decoupling_path_unchanged':True,'REGN_U101_22_to_C107_1_before_after':regn,'engineering_disposition':'The new .40mm input trunk changes the In2 partitioning, but the capacitor/charger/controller regions retain direct barrels into continuous In1. The rerouted REGN branch does not replace or lengthen the existing U101.22-to-C107 decoupling path. The F/B power overlay was inspected.','limits':['Partial routing still has open connections and requires combined native DRC/parity.','Trace/barrel estimates use full native item lengths, not exact clipped end-to-end resistance or a current rating.','The unchanged REGN decoupling connection remains an inherited layout to include in final charger-layout review.','No physical charging, transient, thermal, regulator-stability or EMC result is implied.','Any later capacitor rotation or routing changes require a new source-bound return review.']}
assert out['all_ten_resulting_local_In2_regions_have_ground_barrels']
(D/'power-gateway-root-review.json').write_text(json.dumps(out,indent=2)+'\n')
print(out['status'],input_path['layer_summary'])
