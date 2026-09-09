from route_bounded import route,c
from island_targets import connected_track_targets
from pathlib import Path
import json
D=Path(__file__).resolve().parent;bounds=(.6,70,23,98.7)
def checked_island(net,seed,name):
 pts,receipt=connected_track_targets(c.b,net,seed,bounds)
 cn=c.b.GetConnectivity();cn.Build(c.b)
 objects=[t for t in c.b.GetTracks()if t.GetNetname()==net]+[q for f in c.b.GetFootprints()for q in f.Pads()if q.GetNetname()==net]
 items={t.m_Uuid.AsString():t for t in objects};seen={seed};todo=list(seen)
 while todo:
  t=items[todo.pop()]
  for q in list(cn.GetConnectedTracks(t))+list(cn.GetConnectedPads(t)):
   u=q.m_Uuid.AsString()
   if u in items and u not in seen and any(t.IsOnLayer(L)and q.IsOnLayer(L)for L in[c.p.F_Cu,c.p.In1_Cu,c.p.In2_Cu,c.p.B_Cu]):seen.add(u);todo.append(u)
 assert seen==set(receipt['connected_object_uuids']);receipt['independent_native_direct_adjacency_agrees']=True
 (D/(name+'-island.json')).write_text(json.dumps(receipt,indent=2)+'\n')
 return pts,seen
starts,source=checked_island('HOST_3V3','41fd647b-7164-4ec7-9a75-fb364fc8ca19','host-source')
targets,dest=checked_island('HOST_3V3','88563c50-ef54-4838-9184-0a3060b72492','host-target');assert not source&dest
route('HOST_3V3',(6.8,75.375),(4.6596,76.2638),starts=starts,targets=targets,bounds=bounds)
targets,dest=checked_island('HOST_3V3','88563c50-ef54-4838-9184-0a3060b72492','host-joined-target')
route('HOST_3V3',(2.575,83.5),(4.6596,76.2638),start_layers=(0,),targets=targets,bounds=bounds)
targets,dest=checked_island('CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5','chg-target')
assert 'c3e3a637-6b86-471a-b769-9a93dc58b2c5'not in dest
route('CHG_INT_N',(4.225,83.5),(11.75,85.9625),start_layers=(0,),targets=targets,bounds=bounds)
c.save()
