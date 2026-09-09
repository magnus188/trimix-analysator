from route_bounded import route,c
from island_targets import connected_track_targets
from pathlib import Path
import json
D=Path(__file__).resolve().parent;net='USB_OVP_UVLO';bounds=(.6,82.75,29.25,99.2)
cn=c.b.GetConnectivity();cn.Build(c.b)
objects=[t for t in c.b.GetTracks()if t.GetNetname()==net]+[q for f in c.b.GetFootprints()for q in f.Pads()if q.GetNetname()==net]
items={t.m_Uuid.AsString():t for t in objects}
def native_check(receipt):
 seen={receipt['seed_uuid']};todo=list(seen)
 while todo:
  u=todo.pop();t=items[u]
  for q in list(cn.GetConnectedTracks(t))+list(cn.GetConnectedPads(t)):
   v=q.m_Uuid.AsString()
   if v in items and v not in seen and any(t.IsOnLayer(L)and q.IsOnLayer(L)for L in[c.p.F_Cu,c.p.In1_Cu,c.p.In2_Cu,c.p.B_Cu]):seen.add(v);todo.append(v)
 assert seen==set(receipt['connected_object_uuids'])
 receipt['independent_native_direct_adjacency_agrees']=True
 return seen
starts,sr=connected_track_targets(c.b,net,'9d9c2e65-7935-4076-9ce2-2910124dadc3',bounds)
targets,tr=connected_track_targets(c.b,net,'f289a247-9b6c-4af0-88ee-a154ab128d75',bounds)
s=native_check(sr);t=native_check(tr);assert not s&t
(D/'islands.json').write_text(json.dumps({'source':sr,'destination':tr},indent=2)+'\n')
print('Native source objects',len(s),'target',len(t),'sourcepoints',len(starts),'targetpoints',len(targets),flush=True)
route(net,(13.675,90.975),(17.75,87.775),starts=starts,targets=targets,bounds=bounds)
c.save()
