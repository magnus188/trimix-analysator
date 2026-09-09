"""Uncached native evidence for the found detour; board remains unsaved."""
import topology_search as t
c=t.c;p=c.p
REMOVE=['d8e337d6-f633-48d8-8b77-3ad15ac9c500','a28d2371-2f47-4bd8-b54f-07827780d7b9','445c723b-4c7d-49c8-b015-1b8fba0a79cd','63692ad1-fe67-4a80-bdeb-3633828b4083','445daa4f-037a-483f-860c-8b7949426704']
VIA=[6.4,88.35]
SEGMENTS=[(p.B_Cu,[3.2403,91.5022],VIA),(p.In2_Cu,VIA,[7.8,87.05]),(p.In2_Cu,[7.8,87.05],[10.825,85.825])]
def distance(shape,entries):
 lo=0;hi=2
 for _ in range(22):
  mid=(lo+hi)/2
  if c.test(shape,entries,mid):hi=mid
  else:lo=mid
 return {'distance_lower_bound_mm':lo,'distance_upper_bound_mm':hi,'binding_objects':c.test(shape,entries,hi+.000002)}
def main():
 all_foreign=[row for L in c.ALL for row in c.foreign[L]]
 result={'source_sha256':c.EXPECTED,'status':'NATIVE_GEOMETRY_AND_OWN_NET_CONNECTIVITY_PASS_DRC_PENDING','removed_track_uuids':REMOVE,'cleanup':'The four lower In2 tracks from 8.75,88.425 back to existing via 3.2403,91.5022 become an unused tail. Removing them leaves the retained R104 F connection intact.','via':{'position_mm':VIA,'diameter_mm':.5,'drill_mm':.25,'blockers':c.via_blockers(VIA),'foreign_distance':distance(c.v(VIA),all_foreign),'SMT_distance':distance(c.v(VIA),c.smt)},'segments':[],'power_reservation':t.power,'new_vias':1,'new_tracks':3}
 assert not result['via']['blockers']
 new={}
 for i,(L,a,z)in enumerate(SEGMENTS):
  blockers=c.seg_blockers(a,z,L);assert not blockers,blockers
  result['segments'].append({'layer':c.b.GetLayerName(L),'start_mm':a,'end_mm':z,'width_mm':.15,'blockers':blockers,'foreign_distance':distance(p.SEG(c.v(a),c.v(z)),c.foreign[L])})
  tr=p.PCB_TRACK(c.b);tr.SetLayer(L);tr.SetStart(c.v(a));tr.SetEnd(c.v(z));tr.SetWidth(p.FromMM(.15));tr.SetNetCode(c.target.GetNetCode());new['new_track_'+str(i+1)]=tr
 via=p.PCB_VIA(c.b);via.SetPosition(c.v(VIA));via.SetWidth(p.FromMM(.5));via.SetDrill(p.FromMM(.25));via.SetLayerPair(p.F_Cu,p.B_Cu);via.SetViaType(p.VIATYPE_THROUGH);via.SetNetCode(c.target.GetNetCode());new['new_via']=via
 old={obj.m_Uuid.AsString():obj for obj in list(c.b.GetTracks())+[q for f in c.b.GetFootprints()for q in f.Pads()]if obj.GetNetname()==c.NET and obj.m_Uuid.AsString()not in REMOVE}
 objects={**old,**new};shapes={uid:{L:obj.GetEffectiveShape(L)for L in c.ALL if obj.IsOnLayer(L)}for uid,obj in objects.items()};graph={uid:set()for uid in objects};keys=list(objects)
 for i,a in enumerate(keys):
  for z in keys[i+1:]:
   if any(shapes[a][L].Collide(shapes[z][L],0)for L in shapes[a].keys()&shapes[z].keys()):graph[a].add(z);graph[z].add(a)
 seed='228a514a-28cf-4e4b-a43d-b0ea803668ce';seen={seed};queue=[seed]
 while queue:
  for uid in graph[queue.pop()]-seen:seen.add(uid);queue.append(uid)
 result['native_CE_graph']={'objects':len(objects),'connected_objects':len(seen),'all_remaining_CE_connected':len(seen)==len(objects),'connected_uuids':sorted(seen),'new_to_retained_native_contacts':{uid:sorted(graph[uid]&old.keys())for uid in new},'collision_tolerance_nm':0}
 assert len(seen)==len(objects)
 result['route_length_mm']=sum(c.math.dist(a,z)for L,a,z in SEGMENTS)
 result['source_unchanged']=c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED;assert result['source_unchanged']
 result['native_DRC_run']=False;result['board_written']=False;result['release']=False
 (c.D/'verified-detour.json').write_text(c.json.dumps(result,indent=2)+'\n');print(c.json.dumps(result,indent=2))
if __name__=='__main__':main()
