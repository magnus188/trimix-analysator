"""Native copper-connected target points; netname by itself never proves an island.

No board mutations. This deliberately rejects target-net filled zones because
zone thermal connectivity would require an additional native zone-shape graph.
"""
import math
import pcbnew as p
LAYERS=[p.F_Cu,p.In2_Cu,p.B_Cu]
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def xy(v):return[p.ToMM(v.x),p.ToMM(v.y)]
def connected_track_targets(board,net,seed_uuid,bounds,spacing=.4):
 """Return (targets, receipt) for tracks/vias physically joined to seed_uuid.

 targets are (router_layer_index, [x_mm,y_mm]). Original native copper is
 compared on each common copper layer with zero added clearance. A via is one
 graph node shared across all its copper layers. Mechanical copper gaps are
 not bridged merely because two objects have the same net label.
 """
 assert not any(z.GetNetname()==net and not z.GetIsRuleArea()for z in board.Zones()),'Target-net zones require a zone-aware graph'
 objects=[t for t in board.GetTracks()if t.GetNetname()==net]
 objects +=[q for f in board.GetFootprints()for q in f.Pads()if q.GetNetname()==net]
 ids={t.m_Uuid.AsString():t for t in objects};assert seed_uuid in ids,seed_uuid
 shapes={uid:{L:t.GetEffectiveShape(L)for L in ALL if t.IsOnLayer(L)}for uid,t in ids.items()}
 graph={uid:set()for uid in ids};keys=list(ids)
 for i,a in enumerate(keys):
  for z in keys[i+1:]:
   if any(shapes[a][L].Collide(shapes[z][L],0)for L in shapes[a].keys()&shapes[z].keys()):graph[a].add(z);graph[z].add(a)
 visited={seed_uuid};queue=[seed_uuid]
 while queue:
  for uid in graph[queue.pop()]-visited:visited.add(uid);queue.append(uid)
 targets=[];tracks=[]
 def inside(q):return bounds[0]<=q[0]<=bounds[2]and bounds[1]<=q[1]<=bounds[3]
 for uid in visited:
  t=ids[uid]
  if isinstance(t,p.PAD):continue
  tracks.append(uid)
  if isinstance(t,p.PCB_VIA):
   q=xy(t.GetPosition())
   if inside(q):targets.extend((i,q)for i,L in enumerate(LAYERS)if t.IsOnLayer(L))
  else:
   if t.GetLayer()not in LAYERS:continue
   a,z=xy(t.GetStart()),xy(t.GetEnd());n=max(1,math.ceil(math.dist(a,z)/spacing))
   for k in range(n+1):
    q=[a[i]+(z[i]-a[i])*k/n for i in[0,1]]
    if inside(q):targets.append((LAYERS.index(t.GetLayer()),q))
 receipt={'net':net,'seed_uuid':seed_uuid,'same_net_native_objects':len(ids),'connected_object_uuids':sorted(visited),'connected_track_via_uuids':sorted(tracks),'other_island_object_uuids':sorted(ids.keys()-visited),'target_points':len(targets),'bounds_mm':bounds,'native_shape_collision_tolerance_nm':0,'includes_target_net_zones':False}
 return targets,receipt
