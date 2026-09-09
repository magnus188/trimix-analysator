"""Actual native VSYS island seeds and short gateway evidence; no board changes."""
import power_context as c
import importlib.util
p=c.p
helper=c.D.parent/'island_targets.py';spec=importlib.util.spec_from_file_location('native_islands',helper);mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
BOUNDS=(.8,78,29.15,94.3);LAYERS=[p.F_Cu,p.In2_Cu,p.B_Cu]
def islands():
 starts,a=mod.connected_track_targets(c.b,c.NET,'e0ff3d79-dfcb-4e4d-bd20-72417ad68f09',BOUNDS,spacing=.3)
 ends,z=mod.connected_track_targets(c.b,c.NET,'bb5aec9b-1ff4-4544-8878-dac6d41c8a1b',BOUNDS,spacing=.3)
 assert not set(a['connected_object_uuids'])&set(z['connected_object_uuids'])
 for targets,r in [(starts,a),(ends,z)]:
  for f in c.b.GetFootprints():
   for q in f.Pads():
    xy=c.xy(q.GetPosition())
    if q.m_Uuid.AsString()in r['connected_object_uuids']and BOUNDS[0]<=xy[0]<=BOUNDS[2]and BOUNDS[1]<=xy[1]<=BOUNDS[3]:targets.extend((i,xy)for i,L in enumerate(LAYERS)if q.IsOnLayer(L))
 return starts,ends,a,z
def main():
 starts,ends,a,z=islands();result={'source_sha256':c.EXPECTED,'native_source_island':a,'native_main_island':z,'native_source_points':starts,'native_main_points':ends,'direct_power_links':[],'local_existing_vias':[]}
 for name,r in [('source',a),('main',z)]:
  for obj in c.b.GetTracks():
   if isinstance(obj,p.PCB_VIA)and obj.m_Uuid.AsString()in r['connected_object_uuids']:
    q=c.xy(obj.GetPosition())
    if BOUNDS[0]<=q[0]<=BOUNDS[2]and BOUNDS[1]<=q[1]<=BOUNDS[3]:result['local_existing_vias'].append({'island':name,'uuid':obj.m_Uuid.AsString(),'position_mm':q,'diameter_mm':p.ToMM(obj.GetWidth(p.F_Cu)),'drill_mm':p.ToMM(obj.GetDrillValue())})
 for la,a0 in starts:
  for lz,z0 in ends:
   if la==lz and c.clear(a0,z0,LAYERS[la]):result['direct_power_links'].append({'layer':c.b.GetLayerName(LAYERS[la]),'start':a0,'end':z0})
 print('islands',len(a['connected_object_uuids']),len(z['connected_object_uuids']),'points',len(starts),len(ends),'direct',result['direct_power_links'],flush=True)
 print('existing vias',result['local_existing_vias'],flush=True)
 q=[7.0507,88.8048];result['source_via_exits']={}
 for L in LAYERS:
  result['source_via_exits'][c.b.GetLayerName(L)]=[end for end in [[7.4,88.125],[7.8,87.05],[8.8,88.8],[6.75,89.1],[6.4,88.35],[8,90],[9.5,88.8]]if c.clear(q,end,L)]
 (c.D/'gateways.json').write_text(c.json.dumps(result,indent=2)+'\n');print('exits',result['source_via_exits'])
 assert c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED
if __name__=='__main__':main()
