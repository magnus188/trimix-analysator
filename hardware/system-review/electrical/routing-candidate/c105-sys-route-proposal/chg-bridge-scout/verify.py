"""Native effective-shape checks for a scout proposal; no PCB writes."""
from pathlib import Path
import json, sys, hashlib
OUT=Path(__file__).resolve().parent
sys.path.insert(0,str(OUT.parent))
import route_context as c
from island_targets import connected_track_targets
p=c.p
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
name=sys.argv[1]
proposal=json.loads((OUT/(name+'-proposal.json')).read_text())
assert proposal['source_sha256']==c.EXPECTED
removed=[]
for t in list(c.b.GetTracks()):
    if t.m_Uuid.AsString() in proposal['removed_uuids']:
        removed.append(t);c.b.Remove(t)
assert len(removed)==len(proposal['removed_uuids'])
c.track('VSYS',proposal['reserved_SYS']['hypothetical_points_mm'],p.In2_Cu,width=.4)
old=list(c.b.GetTracks())+[q for f in c.b.GetFootprints()for q in f.Pads()]
edges=[d for d in c.b.GetDrawings()if d.GetLayer()==p.Edge_Cuts]
keepouts=[z for z in list(c.b.Zones())+[z for f in c.b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()]
c.added.clear()
new=[]
for rec in proposal['added']:
    if rec['type']=='via':
        c.via(rec['net'],rec['at'],d=rec['diameter_mm'],h=rec['drill_mm'])
    else:
        c.track(rec['net'],[rec['start'],rec['end']],c.b.GetLayerID(rec['layer']),width=rec['width_mm'])
    uid=c.added[-1]['uuid']
    new.append(next(t for t in c.b.GetTracks()if t.m_Uuid.AsString()==uid))
checks=[]
for row,item in zip(proposal['added'],new):
    via=isinstance(item,p.PCB_VIA)
    failures=[]
    for L in ALL:
        if not item.IsOnLayer(L):continue
        shape=item.GetEffectiveShape(L)
        for other in old:
            if not other.IsOnLayer(L):continue
            foreign=other.GetNetname()!=item.GetNetname()
            if foreign and shape.Collide(other.GetEffectiveShape(L),p.FromMM(.2001)):
                failures.append({'rule':'foreign_copper','layer':c.b.GetLayerName(L),'uuid':other.m_Uuid.AsString(),'net':other.GetNetname()})
            if via and isinstance(other,p.PAD)and other.GetAttribute()==p.PAD_ATTRIB_SMD and shape.Collide(other.GetEffectiveShape(L),p.FromMM(.0501)):
                failures.append({'rule':'all_SMT_land_plus_0.05','layer':c.b.GetLayerName(L),'uuid':other.m_Uuid.AsString()})
        for z in keepouts:
            if not z.GetLayerSet().Contains(L):continue
            if (z.GetDoNotAllowVias()if via else z.GetDoNotAllowTracks())and shape.Collide(z.Outline(),p.FromMM(.0001)):
                failures.append({'rule':'keepout','layer':c.b.GetLayerName(L),'uuid':z.m_Uuid.AsString()})
        for edge in edges:
            if shape.Collide(edge.GetEffectiveShape(),p.FromMM(.5001)):
                failures.append({'rule':'board_edge','layer':c.b.GetLayerName(L),'uuid':edge.m_Uuid.AsString()})
    checks.append({'addition':row,'pass':not failures,'failures':failures})
_,joined=connected_track_targets(c.b,'CHG_INT_N',proposal['upper_island']['seed_uuid'],proposal['bounds_mm'])
required=set(proposal['upper_island']['connected_object_uuids'])|set(proposal['lower_island']['connected_object_uuids'])
lost=sorted(required-set(joined['connected_object_uuids']))
result={'source_sha256':c.EXPECTED,'status':'PASS'if all(q['pass']for q in checks)and not lost else 'FAIL','checks':checks,'original_island_objects_rejoined':len(required),'lost_original_island_objects':lost,'reserved_SYS_is_hard_foreign_copper':True,'native_contact_tolerance_nm':0,'clearance_test_mm':.2001,'new_via_all_SMT_exclusion_mm':.0501,'board_edge_clearance_mm':.5001,'source_unchanged':hashlib.sha256(c.P.read_bytes()).hexdigest()==c.EXPECTED,'release':False,'scope':'Native shape and connectivity scout only. Reserved SYS intentionally intersects other unchanged control segments; no DRC or complete-board acceptance claimed.'}
(OUT/(name+'-verification.json')).write_text(json.dumps(result,indent=2)+'\n')
assert result['source_unchanged']
print(json.dumps(result,indent=2))
