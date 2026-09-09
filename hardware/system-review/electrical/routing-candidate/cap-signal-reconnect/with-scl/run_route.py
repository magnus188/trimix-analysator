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
starts,source=checked_island('CHG_INT_N','b7bf0299-1b6d-4268-8ff3-32de030c9570','chg-source')
targets,dest=checked_island('CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5','chg-target');assert not source&dest
route('CHG_INT_N',(9.5,83.25),(11.75,85.9625),starts=starts,targets=targets,bounds=bounds)
c.save()
