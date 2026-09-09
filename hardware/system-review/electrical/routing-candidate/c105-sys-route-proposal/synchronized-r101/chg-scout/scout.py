"""Frozen R101/CE source: native CHG bridge search, no source PCB writes."""
from pathlib import Path
import sys, types, hashlib, json, math, argparse
import pcbnew as p

parser=argparse.ArgumentParser()
parser.add_argument('--with-set',action='store_true')
args=parser.parse_args()
BASE=Path(__file__).resolve().parent
D=BASE.parent
OUT=BASE/'with-set'if args.with_set else BASE
OUT.mkdir(exist_ok=True)
SOURCE=D/'ce-baseline.kicad_pcb'
EXPECTED='983743804bce1804adac244e28080f0941280f5cbc94b070ed20937c75dfb4cc'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
power=json.loads((D.parent/'power-corridor-v2.json').read_text())
sys.path.insert(0,str(D))
from island_targets import connected_track_targets
c=types.ModuleType('build_bridge')
c.p=p;c.b=p.LoadBoard(str(SOURCE));c.OUT=OUT;c.added=[]
c.vec=lambda q:p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
c.xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
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
preapplied=None
if args.with_set:
    preapplied=json.loads((D/'set-scout/proposal.json').read_text())
    removed_set=[]
    for t in list(c.b.GetTracks()):
        if t.m_Uuid.AsString()in preapplied['removed_SET_uuids']:
            assert t.GetNetname()=='USB_OVP_SET'
            removed_set.append(t);c.b.Remove(t)
    assert len(removed_set)==4
    for rec in preapplied['added']:
        assert rec['net']=='USB_OVP_SET'and rec['type']=='segment'and rec['width_mm']==.15
        track(rec['net'],[rec['start'],rec['end']],c.b.GetLayerID(rec['layer']),width=rec['width_mm'])
    c.added.clear()
REMOVE='a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8'
UPPER='0e4a678b-3cca-451f-97dc-36f6f7bc6e0c'
LOWER='699897a5-66eb-4820-96ec-8e0602bad845'
held=[t for t in c.b.GetTracks()if t.m_Uuid.AsString()==REMOVE]
assert len(held)==1
c.b.Remove(held[0])
track('VSYS',power['points_mm'],p.In2_Cu,width=.4)
c.added.clear()
reserved=p.ZONE(c.b);reserved.SetIsRuleArea(True);reserved.SetDoNotAllowTracks(True);reserved.SetDoNotAllowVias(True)
layers=p.LSET()
for L in ALL:layers.AddLayer(L)
reserved.SetLayerSet(layers);reserved.Outline().NewOutline()
for xy in [(15.7,89.3),(18.5,89.3),(18.5,91),(15.7,91)]:reserved.Outline().Append(c.vec(xy))
c.b.Add(reserved)
sys.modules['build_bridge']=c
router=types.ModuleType('bounded_chg_router')
router_code=(D.parent.parent/'cap-signal-reconnect/pullup-swap/route_bounded.py').read_text()
assert 'isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD' in router_code
router_code=router_code.replace('isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD','isinstance(it,p.PAD)')
router_code=router_code.replace('for l in [p.F_Cu,p.B_Cu]for s in shapes(smd,l,q)','for l in ALL for s in shapes(smd,l,q)')
exec(router_code,router.__dict__)
bounds=[.8,78,29.15,98.3]
starts,sr=connected_track_targets(c.b,'CHG_INT_N',UPPER,bounds,spacing=.2)
targets,tr=connected_track_targets(c.b,'CHG_INT_N',LOWER,bounds,spacing=.2)
assert not set(sr['connected_object_uuids'])&set(tr['connected_object_uuids'])
result={'source':str(SOURCE),'source_sha256':EXPECTED,'reserved_SYS_points_mm':power['points_mm'],'reserved_SYS_width_mm':.4,'reserved_all_layer_rectangle_mm':[15.7,89.3,18.5,91],'removed_uuids':[REMOVE],'upper_island':sr,'lower_island':tr,'bounds_mm':bounds,'grid_step_mm':.05,'release':False}
result['preapplied_SET_delta']=preapplied
(OUT/'islands.json').write_text(json.dumps(result,indent=2)+'\n')
print('ISLANDS',len(sr['connected_object_uuids']),len(tr['connected_object_uuids']),'STARTS',len(starts),'TARGETS',len(targets),flush=True)
old=list(c.b.GetTracks())+[q for f in c.b.GetFootprints()for q in f.Pads()]
try:
    router.route('CHG_INT_N',(11.75,86.8),(10.7,89.2),width=.15,bounds=bounds,starts=starts,targets=targets)
except AssertionError as e:
    result['status']='NO_BOUNDED_ROUTE';result['error']=str(e)
    reach=json.loads((OUT/'CHG_INT_N-reachable.json').read_text())
    result['reachable_points_by_layer']={L:sum(q[2]==i for q in reach['visited'])for i,L in enumerate(['F.Cu','In2.Cu','B.Cu'])}
    result['reachable_points_total']=len(reach['visited'])
else:
    result['status']='FOUND_REQUIRES_NATIVE_VERIFICATION';result['added']=c.added
    _,joined=connected_track_targets(c.b,'CHG_INT_N',UPPER,bounds)
    result['all_original_island_members_rejoined']=(set(sr['connected_object_uuids'])|set(tr['connected_object_uuids']))<=set(joined['connected_object_uuids'])
    assert result['all_original_island_members_rejoined']
    print('FOUND',json.dumps(c.added),flush=True)
    edges=[d for d in c.b.GetDrawings()if d.GetLayer()==p.Edge_Cuts]
    rules=[z for z in list(c.b.Zones())+[z for f in c.b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()]
    checks=[]
    byid={t.m_Uuid.AsString():t for t in c.b.GetTracks()}
    for row in c.added:
        t=byid[row['uuid']];v=isinstance(t,p.PCB_VIA);failures=[]
        for L in ALL:
            if not t.IsOnLayer(L):continue
            shape=t.GetEffectiveShape(L)
            for o in old:
                if not o.IsOnLayer(L):continue
                if o.GetNetname()!='CHG_INT_N'and shape.Collide(o.GetEffectiveShape(L),p.FromMM(.2001)):
                    failures.append({'rule':'foreign_copper','layer':c.b.GetLayerName(L),'uuid':o.m_Uuid.AsString(),'net':o.GetNetname()})
                if v and isinstance(o,p.PAD)and shape.Collide(o.GetEffectiveShape(L),p.FromMM(.0501)):
                    failures.append({'rule':'all_pad_exclusion','layer':c.b.GetLayerName(L),'uuid':o.m_Uuid.AsString()})
            for z in rules:
                if z.GetLayerSet().Contains(L)and(z.GetDoNotAllowVias()if v else z.GetDoNotAllowTracks())and shape.Collide(z.Outline(),p.FromMM(.0001)):
                    failures.append({'rule':'rule_area','layer':c.b.GetLayerName(L),'uuid':z.m_Uuid.AsString()})
            for e in edges:
                if shape.Collide(e.GetEffectiveShape(),p.FromMM(.5001)):
                    failures.append({'rule':'board_edge','layer':c.b.GetLayerName(L),'uuid':e.m_Uuid.AsString()})
        checks.append({'added':row,'pass':not failures,'failures':failures})
    result['native_geometry_checks']=checks
    result['native_geometry_pass']=all(r['pass']for r in checks)
    result['status']='NATIVE_GEOMETRY_PASS_AWAIT_COMBINED_DRC'if result['native_geometry_pass']else 'NATIVE_GEOMETRY_FAIL'
result['source_unchanged']=hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED
assert result['source_unchanged']
result['limitations']=['Finite-grid search is not proof of global routing impossibility.','No source PCB saved, refilled, or submitted to DRC.','No schematic matching or complete-board acceptance claimed.']
(OUT/'summary.json').write_text(json.dumps(result,indent=2)+'\n')
print('DONE',result['status'],result.get('reachable_points_by_layer',{}),flush=True)
