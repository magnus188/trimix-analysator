"""Independently check explicit SYS against frozen CE+SET and exact CHG delta.

Only in-memory objects are constructed. This script never saves a board.
"""
import power_context as c
from datetime import datetime,timezone
p=c.p
CHG_PATH=c.D/'chg-delta-frozen.json'
def signature(obj):
 r={'net':obj.GetNetname(),'type':'via'if isinstance(obj,p.PCB_VIA)else'segment'}
 if isinstance(obj,p.PCB_VIA):r.update(at=c.xy(obj.GetPosition()),diameter_mm=p.ToMM(obj.GetWidth(p.F_Cu)),drill_mm=p.ToMM(obj.GetDrillValue()))
 else:r.update(start=c.xy(obj.GetStart()),end=c.xy(obj.GetEnd()),width_mm=p.ToMM(obj.GetWidth()),layer=c.b.GetLayerName(obj.GetLayer()))
 return r
def distance(shape,entries):
 lo=0;hi=3
 for _ in range(24):
  mid=(lo+hi)/2
  if c.test(shape,entries,mid):hi=mid
  else:lo=mid
 return {'centreline_distance_lower_bound_mm':lo,'centreline_distance_upper_bound_mm':hi,'copper_clearance_lower_bound_mm':lo-.2,'binding_objects':c.test(shape,entries,hi+.000002)}
def native_graph(net):
 objects={o.m_Uuid.AsString():o for o in list(c.b.GetTracks())+[q for f in c.b.GetFootprints()for q in f.Pads()]if o.GetNetname()==net}
 shapes={uid:{L:o.GetEffectiveShape(L)for L in c.ALL if o.IsOnLayer(L)}for uid,o in objects.items()};keys=list(objects);graph={uid:set()for uid in keys}
 for i,a in enumerate(keys):
  for z in keys[i+1:]:
   if any(shapes[a][L].Collide(shapes[z][L],0)for L in shapes[a].keys()&shapes[z].keys()):graph[a].add(z);graph[z].add(a)
 comps=[];remaining=set(keys)
 while remaining:
  seed=next(iter(remaining));seen={seed};queue=[seed]
  while queue:
   for uid in graph[queue.pop()]-seen:seen.add(uid);queue.append(uid)
  remaining-=seen;comps.append(sorted(seen))
 return objects,graph,sorted(comps,key=lambda x:-len(x))
def main():
 raw=CHG_PATH.read_bytes();delta=c.json.loads(raw);assert delta['reserved_all_layer_rectangle_mm']==c.RESERVED
 assert c.EXPECTED=='3d72a8d43823f29553d900e0c0820aed391bd7e5e336b70a5869bc3f220a1962'
 lookup={t.m_Uuid.AsString():t for t in c.b.GetTracks()}
 for uid in delta['required_preapplied_SET_delta']['removed_uuids']:assert uid not in lookup
 for row in delta['required_preapplied_SET_delta']['added']:
  sig=signature(lookup[row['uuid']]);assert sig=={k:v for k,v in row.items()if k!='uuid'},(sig,row)
 old_sys,old_graph,old_components=native_graph('VSYS');assert sorted(map(len,old_components))==[40,89]
 removed=delta['removed_CHG_uuids'];assert len(removed)==1
 for uid in removed:assert lookup[uid].GetNetname()=='CHG_INT_N';c.b.Remove(lookup[uid])
 c.foreign={L:[(info,shape)for info,shape in rows if info.get('uuid')not in removed]for L,rows in c.foreign.items()}
 chg_code=next(t.GetNetCode()for t in c.b.GetTracks()if t.GetNetname()=='CHG_INT_N')
 for row in delta['added']:
  if row['type']=='via':
   obj=p.PCB_VIA(c.b);obj.SetPosition(c.v(row['at']));obj.SetWidth(p.FromMM(row['diameter_mm']));obj.SetDrill(p.FromMM(row['drill_mm']));obj.SetLayerPair(p.F_Cu,p.B_Cu);obj.SetViaType(p.VIATYPE_THROUGH)
  else:
   obj=p.PCB_TRACK(c.b);obj.SetStart(c.v(row['start']));obj.SetEnd(c.v(row['end']));obj.SetWidth(p.FromMM(row['width_mm']));obj.SetLayer(c.b.GetLayerID(row['layer']))
  obj.SetNetCode(chg_code);obj.SetUuid(p.KIID(row['uuid']));c.b.Add(obj)
  for L in c.ALL:
   if obj.IsOnLayer(L):c.foreign[L].append((c.info(obj,L),obj.GetEffectiveShape(L)))
 result={'created_utc':datetime.now(timezone.utc).isoformat(),'status':'PENDING','source_sha256':c.EXPECTED,'source_path':str(c.SOURCE),'CHG_delta_path':str(CHG_PATH),'CHG_delta_sha256':c.hashlib.sha256(raw).hexdigest(),'required_SET_geometry_verified_in_source':True,'CHG_delta_applied_in_memory_only':True,'reserved_all_layer_rectangle_mm':c.RESERVED,'SYS_width_mm':.4,'SYS_layer':'In2.Cu','new_power_vias':0,'segments':[],'native_collision_tolerance_mm':.0001}
 points=delta['reserved_SYS_points_mm'];power_nodes={};power_code=c.target.GetNetCode()
 for i,(a,z)in enumerate(zip(points,points[1:])):
  blockers=c.seg_blockers(a,z,p.In2_Cu);assert not blockers,(i,a,z,blockers)
  shape=p.SEG(c.v(a),c.v(z));row={'start_mm':a,'end_mm':z,'foreign_copper_edge_rule_and_reservation_blockers':blockers,'minimum_foreign_clearance':distance(shape,c.foreign[p.In2_Cu])};result['segments'].append(row)
  obj=p.PCB_TRACK(c.b);obj.SetStart(c.v(a));obj.SetEnd(c.v(z));obj.SetWidth(p.FromMM(.4));obj.SetLayer(p.In2_Cu);obj.SetNetCode(power_code);c.b.Add(obj);power_nodes[obj.m_Uuid.AsString()]='SYS_segment_'+str(i+1)
 objects,graph,components=native_graph('VSYS');assert len(components)==1 and len(objects)==len(old_sys)+len(points)-1
 source='e0ff3d79-dfcb-4e4d-bd20-72417ad68f09';target='bb5aec9b-1ff4-4544-8878-dac6d41c8a1b';assert source in components[0]and target in components[0]
 result['native_VSYS_connectivity']={'before_component_sizes':list(map(len,old_components)),'after_component_sizes':list(map(len,components)),'all_129_original_VSYS_objects_rejoined':set(old_sys)<=set(components[0]),'source_via_uuid':source,'main_via_uuid':target,'new_to_retained_contacts':{label:sorted(graph[uid]&old_sys.keys())for uid,label in power_nodes.items()},'old_object_uuids':sorted(old_sys),'collision_tolerance_nm':0}
 chg_objects,chg_graph,chg_components=native_graph('CHG_INT_N');assert len(chg_components)==1
 result['native_CHG_connectivity']={'component_sizes':list(map(len,chg_components)),'all_connected':True}
 result['minimum_SYS_foreign_copper_clearance_mm']=min(x['minimum_foreign_clearance']['copper_clearance_lower_bound_mm']for x in result['segments'])
 assert CHG_PATH.read_bytes()==raw and c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED
 result.update(status='PASS_EXPLICIT_SYS_NATIVE_GEOMETRY_AND_CONNECTIVITY',input_hashes_unchanged=True,board_written=False,native_DRC_run=False,release=False)
 (c.D/'explicit-sys-verification.json').write_text(c.json.dumps(result,indent=2)+'\n');print(result['status']);print('VSYS',result['native_VSYS_connectivity']['before_component_sizes'],'->',result['native_VSYS_connectivity']['after_component_sizes'],'CHG',result['native_CHG_connectivity']['component_sizes']);print('minimum_SYS_copper_clearance_mm',result['minimum_SYS_foreign_copper_clearance_mm']);print('contacts',result['native_VSYS_connectivity']['new_to_retained_contacts'])
if __name__=='__main__':main()
