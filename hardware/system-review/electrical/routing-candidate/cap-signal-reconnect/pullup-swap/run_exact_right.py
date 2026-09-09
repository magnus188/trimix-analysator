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
bounds=(.6,76,12,87)
targets,dest=checked_island('I2C_SCL','b2dc55a6-c65e-41f9-895e-6b1b250b706a','scl-target')
route('I2C_SCL',(4.225,83.5),(4.2905,85.2995),start_layers=(0,),targets=targets,allow_vias=False,bounds=bounds)
c.track('CHG_INT_N',[(24.325,75),(25.0233,74.3017),(25.0233,72.5)])
bounds=(11,50,29.8,84.5)
targets,dest=checked_island('CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5','chg-target')
starts,source=checked_island('CHG_INT_N','c3e3a637-6b86-471a-b769-9a93dc58b2c5','chg-source');assert not source&dest
route('CHG_INT_N',(25.0233,72.5),(27.265,54.005),starts=starts,targets=targets,bounds=bounds)
c.save()
