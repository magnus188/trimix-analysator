"""Single bounded retry on frozen CE candidate plus corrected SYS reservation."""
from pathlib import Path
import sys, types, hashlib, json, math
import pcbnew as p

OUT=Path(__file__).resolve().parent
D=OUT.parent.parent
SOURCE=D/'ce-bridge-scout/candidate/Trimix_Analyzer.kicad_pcb'
EXPECTED='3ba04d481d49b39d87a800c941448d665bcbd465af761bb2b0d617c23429b469'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
power=json.loads((D/'power-corridor-v2.json').read_text())
assert power['source_sha256']==EXPECTED
sys.path.insert(0,str(D))
from island_targets import connected_track_targets
c=types.ModuleType('build_bridge')
c.p=p;c.b=p.LoadBoard(str(SOURCE));c.OUT=OUT;c.added=[]
c.vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
c.xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
NETS={str(k):v.GetNetCode()for k,v in c.b.GetNetsByName().items()}
def track(net,pts,layer=p.F_Cu,width=.15):
    for a,z in zip(pts,pts[1:]):
        if math.dist(a,z)<1e-6:continue
        t=p.PCB_TRACK(c.b);t.SetStart(c.vec(a));t.SetEnd(c.vec(z));t.SetLayer(layer);t.SetNetCode(NETS[net]);t.SetWidth(p.FromMM(width));c.b.Add(t)
        c.added.append({'uuid':t.m_Uuid.AsString(),'type':'segment','net':net,'start':a,'end':z,'width_mm':width,'layer':c.b.GetLayerName(layer)})
def via(net,q):
    t=p.PCB_VIA(c.b);t.SetPosition(c.vec(q));t.SetWidth(p.FromMM(.5));t.SetDrill(p.FromMM(.25));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(NETS[net]);c.b.Add(t)
    c.added.append({'uuid':t.m_Uuid.AsString(),'type':'via','net':net,'at':q,'diameter_mm':.5,'drill_mm':.25})
c.track=track;c.via=via
REMOVE='a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8'
UPPER='0e4a678b-3cca-451f-97dc-36f6f7bc6e0c'
LOWER='699897a5-66eb-4820-96ec-8e0602bad845'
held=[t for t in c.b.GetTracks()if t.m_Uuid.AsString()==REMOVE]
assert len(held)==1
c.b.Remove(held[0])
track('VSYS',power['points_mm'],p.In2_Cu,width=.4)
c.added.clear()
sys.modules['build_bridge']=c
router=types.ModuleType('bounded_chg_router')
exec((D.parent/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text(),router.__dict__)
bounds=[.8,78,29.15,98.3]
starts,sr=connected_track_targets(c.b,'CHG_INT_N',UPPER,bounds,spacing=.2)
targets,tr=connected_track_targets(c.b,'CHG_INT_N',LOWER,bounds,spacing=.2)
assert not set(sr['connected_object_uuids'])&set(tr['connected_object_uuids'])
result={'source':str(SOURCE),'source_sha256':EXPECTED,'reserved_SYS':power,'removed_uuids':[REMOVE],'upper_island':sr,'lower_island':tr,'bounds_mm':bounds,'grid_step_mm':.05,'release':False}
(OUT/'islands.json').write_text(json.dumps(result,indent=2)+'\n')
print('ISLANDS',len(sr['connected_object_uuids']),len(tr['connected_object_uuids']),'STARTS',len(starts),'TARGETS',len(targets),flush=True)
try:
    router.route('CHG_INT_N',(11.75,86.8),(10.7,89.2),width=.15,bounds=bounds,starts=starts,targets=targets)
except AssertionError as e:
    result['status']='NO_BOUNDED_ROUTE';result['error']=str(e)
    reach=json.loads((OUT/'CHG_INT_N-reachable.json').read_text())
    result['reachable_points_by_layer']={L:sum(q[2]==i for q in reach['visited'])for i,L in enumerate(['F.Cu','In2.Cu','B.Cu'])}
    result['reachable_points_total']=len(reach['visited'])
    result['limitations']=['One .05 mm finite grid search; not proof of global routing impossibility.','Only a0d0b138 removed. No extra foreign control tracks ignored.','No PCB saved, refilled, or submitted to DRC.']
else:
    result['status']='FOUND_REQUIRES_NATIVE_VERIFICATION';result['added']=c.added
    _,joined=connected_track_targets(c.b,'CHG_INT_N',UPPER,bounds)
    result['all_original_island_members_rejoined']=(set(sr['connected_object_uuids'])|set(tr['connected_object_uuids']))<=set(joined['connected_object_uuids'])
    assert result['all_original_island_members_rejoined']
    print('FOUND',json.dumps(c.added),flush=True)
result['source_unchanged']=hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
assert result['source_unchanged']
(OUT/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('DONE',result['status'],result.get('reachable_points_by_layer',{}),flush=True)
