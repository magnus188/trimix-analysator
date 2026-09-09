"""Read-only native copper witnesses for the moved decoupling capacitor."""
from pathlib import Path
import hashlib,json,collections
import pcbnew as p
from island_targets import connected_track_targets
D=Path(__file__).resolve().parent
BOUNDS=(19,65,24.5,72.5);ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
def local_graph(board,net,seed):
 objects=list(board.GetTracks())+[pad for f in board.GetFootprints()for pad in f.Pads()]
 chosen={}
 for item in objects:
  if item.GetNetname()!=net:continue
  bb=item.GetBoundingBox();lo,hi=xy(bb.GetOrigin()),xy(bb.GetEnd())
  if lo[0]>BOUNDS[2]or hi[0]<BOUNDS[0]or lo[1]>BOUNDS[3]or hi[1]<BOUNDS[1]:continue
  chosen[item.m_Uuid.AsString()]=item
 assert seed in chosen
 shapes={uid:{L:t.GetEffectiveShape(L)for L in ALL if t.IsOnLayer(L)}for uid,t in chosen.items()}
 graph={uid:set()for uid in chosen};keys=list(chosen)
 for i,a in enumerate(keys):
  for z in keys[i+1:]:
   if any(shapes[a][L].Collide(shapes[z][L],0)for L in shapes[a].keys()&shapes[z].keys()):graph[a].add(z);graph[z].add(a)
 previous={seed:None};queue=collections.deque([seed])
 while queue:
  for uid in graph[queue.popleft()]-previous.keys():previous[uid]=None;queue.append(uid)
 # Explicit shortest physical copper paths to plated ground vias.
 previous={seed:None};queue=collections.deque([seed])
 while queue:
  current=queue.popleft()
  for uid in graph[current]-previous.keys():previous[uid]=current;queue.append(uid)
 planes=[z.GetFilledPolysList(p.In1_Cu)for z in board.Zones()if not z.GetIsRuleArea()and z.GetNetname()=='GND'and z.GetLayerSet().Contains(p.In1_Cu)]
 anchors=[]
 for uid in previous:
  item=chosen[uid]
  if not isinstance(item,p.PCB_VIA):continue
  hit=any(poly.Collide(item.GetEffectiveShape(p.In1_Cu),0)for poly in planes)
  if not hit:continue
  path=[];k=uid
  while k is not None:path.append(k);k=previous[k]
  anchors.append({'via_uuid':uid,'via_mm':xy(item.GetPosition()),'native_In1_filled_copper_contact':True,'path_from_C707_pad':list(reversed(path))})
 direct=[uid for uid in graph[seed]if not isinstance(chosen[uid],p.PAD)]
 return {'connected_object_uuids':sorted(previous),'direct_trace_or_via_contacts':sorted(direct),'anchored_ground_vias':anchors,'window_mm':BOUNDS}
before=p.LoadBoard(str(D/'before.kicad_pcb'));after=p.LoadBoard(str(D/'Trimix_Analyzer.kicad_pcb'))
def pads(b):return {q.GetNumber():q for f in b.GetFootprints()if f.GetReference()=='C707'for q in f.Pads()}
p0,p1=pads(before),pads(after);assert set(p0)==set(p1)=={'1','2'}
assert p0['1'].GetNetname()==p1['1'].GetNetname()=='HOST_3V3';assert p0['2'].GetNetname()==p1['2'].GetNetname()=='GND'
_,h0=connected_track_targets(before,'HOST_3V3',p0['1'].m_Uuid.AsString(),[0,0,30,99]);_,h1=connected_track_targets(after,'HOST_3V3',p1['1'].m_Uuid.AsString(),[0,0,30,99])
assert set(h0['connected_object_uuids'])<=set(h1['connected_object_uuids'])
g0=local_graph(before,'GND',p0['2'].m_Uuid.AsString());g1=local_graph(after,'GND',p1['2'].m_Uuid.AsString())
shared_traces=set(g0['direct_trace_or_via_contacts'])&set(g1['direct_trace_or_via_contacts']);assert shared_traces
shared_vias={x['via_uuid']for x in g0['anchored_ground_vias']}&{x['via_uuid']for x in g1['anchored_ground_vias']};assert shared_vias
receipt={'status':'passed_native_copper_connectivity_and_ground_return_witness','before_sha256':hashlib.sha256((D/'before.kicad_pcb').read_bytes()).hexdigest(),'after_sha256':hashlib.sha256((D/'Trimix_Analyzer.kicad_pcb').read_bytes()).hexdigest(),'C707_pad1_HOST_original_network_preserved':True,'HOST_connected_objects_before':h0['connected_object_uuids'],'HOST_connected_objects_after':h1['connected_object_uuids'],'GND_before':g0,'GND_after':g1,'unchanged_direct_ground_trace_or_via_contacts':sorted(shared_traces),'retained_ground_vias_with_native_In1_contact':sorted(shared_vias),'method':'Zero-clearance native effective-copper-shape intersections; same net labels alone are insufficient. The local GND graph follows actual traces/pads/plated vias and verifies contact to actual filled In1 ground.','limits':['This proves nominal copper connectivity, not solder quality or transient impedance.','The global ground-return topology is evaluated separately by native DRC and filled-plane geometry review.']}
(D/'C707-connectivity-witness.json').write_text(json.dumps(receipt,indent=2)+'\n');print(receipt['status'],len(shared_traces),'shared ground trace/via contacts,',len(shared_vias),'retained In1 ground anchors')
