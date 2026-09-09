from route_bounded import route,c
from island_targets import connected_track_targets
import json,sys
from pathlib import Path
D=Path(__file__).resolve().parent
bounds=(.6,65,29.25,99.2)
targets,receipt=connected_track_targets(c.b,'CHG_INT_N','f4002328-741f-4a4d-a3e1-0de1ad0a95e5',bounds)
# Independent direct-adjacency traversal checks the geometric-island selection.
cn=c.b.GetConnectivity();cn.Build(c.b)
objects=[t for t in c.b.GetTracks()if t.GetNetname()=='CHG_INT_N']+[q for f in c.b.GetFootprints()for q in f.Pads()if q.GetNetname()=='CHG_INT_N']
items={t.m_Uuid.AsString():t for t in objects};seen={receipt['seed_uuid']};todo=list(seen)
while todo:
 u=todo.pop();t=items[u]
 for q in list(cn.GetConnectedTracks(t))+list(cn.GetConnectedPads(t)):
  v=q.m_Uuid.AsString()
  if v in items and v not in seen and any(t.IsOnLayer(L)and q.IsOnLayer(L)for L in[c.p.F_Cu,c.p.In1_Cu,c.p.In2_Cu,c.p.B_Cu]):seen.add(v);todo.append(v)
assert seen==set(receipt['connected_object_uuids']), 'Target-island reader disagrees with native direct adjacency'
receipt['native_direct_adjacency_agrees']=True
assert '0953812a-22b5-40f2-bd99-1d1284fc7924'not in seen,'Lower source already joined?'
(D/'target-island.json').write_text(json.dumps(receipt,indent=2)+'\n')
print('Verified',len(seen),'connected upper island objects;',len(targets),'target points',flush=True)
starts,source_receipt=connected_track_targets(c.b,'CHG_INT_N','0953812a-22b5-40f2-bd99-1d1284fc7924',bounds)
assert not set(source_receipt['connected_object_uuids'])&seen
(D/'source-island.json').write_text(json.dumps(source_receipt,indent=2)+'\n')
print('Source',len(starts),'points',flush=True)
route('CHG_INT_N',(20.9869,97.1977),(18.1454,82.6695),start_layers=(0,1,2),end_layers=(1,),bounds=bounds,targets=targets,starts=starts)
c.save()
