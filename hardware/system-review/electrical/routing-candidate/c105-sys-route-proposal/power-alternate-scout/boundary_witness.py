"""Uncached native witnesses for a legal source gateway and failed outer jumps."""
import power_context as c
p=c.p
def distance(shape,rows):
 lo=0;hi=2
 for _ in range(22):
  mid=(lo+hi)/2
  if c.test(shape,rows,mid):hi=mid
  else:lo=mid
 return {'distance_lower_bound_mm':lo,'distance_upper_bound_mm':hi,'binding_objects':c.test(shape,rows,hi+.000002)}
def main():
 a=c.json.loads((c.D/'via050-additive-result.json').read_text());z=c.json.loads((c.D/'via050-reverse-additive-result.json').read_text())
 result={'source_sha256':c.EXPECTED,'status':'LEGAL_SOURCE_GATEWAY_NO_COMPLETE_ROUTE','gateway':{'position_mm':[9.4,88.7625],'diameter_mm':.5,'drill_mm':.25},'gateway_binding':[],'closest_separated_region_witnesses':{}}
 q=result['gateway']['position_mm'];result['gateway']['blockers']=c.via_blockers(q,.5);assert not result['gateway']['blockers']
 result['gateway']['foreign_distance']=distance(c.v(q),[row for L in c.ALL for row in c.foreign[L]])
 result['gateway']['all_pad_distance']=distance(c.v(q),c.smt);result['gateway']['060_diameter_blockers']=c.via_blockers(q,.6)
 path=[[7.0507,88.8048],[7.4,88.125],[8,87.525],q]
 for start,end in zip(path,path[1:]):
  blockers=c.seg_blockers(start,end,p.In2_Cu);assert not blockers
  result['gateway_binding'].append({'layer':'In2.Cu','start_mm':start,'end_mm':end,'width_mm':.4,'blockers':blockers,'foreign_distance':distance(p.SEG(c.v(start),c.v(end)),c.foreign[p.In2_Cu])})
 for i,L in enumerate([p.F_Cu,p.In2_Cu,p.B_Cu]):
  right={};left={}
  for x,y,k in a['reachable_grid_nodes']:
   if k==i:right[y]=max(x,right.get(y,x))
  for x,y,k in z['reachable_grid_nodes']:
   if k==i:left[y]=min(x,left.get(y,x))
  best=min((((x-x2)**2+(y-y2)**2,(x,y),(x2,y2))for y,x in right.items()for y2,x2 in left.items()))
  start=[v*.05 for v in best[1]];end=[v*.05 for v in best[2]]
  result['closest_separated_region_witnesses'][c.b.GetLayerName(L)]={'start_mm':start,'end_mm':end,'distance_mm':c.math.dist(start,end),'blockers':c.seg_blockers(start,end,L),'interpretation':'Closest grid-frontier pair for the disjoint source/main searched components; direct continuous jump tested against every foreign effective shape. This is a blocker witness, not a proposed track.'}
 for name in ['hypothetical-cc-result.json','via050-hypothetical-cc-result.json']:
  d=c.json.loads((c.D/name).read_text());original=c.json.loads((c.D/('via050-additive-result.json'if name.startswith('via050')else'additive-result.json')).read_text());assert set(map(tuple,d['reachable_grid_nodes']))==set(map(tuple,original['reachable_grid_nodes']))
 result['CC_track_omission_does_not_change_source_reachability_for_either_via_size']=True
 assert c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED;result['source_unchanged']=True
 (c.D/'boundary-witnesses.json').write_text(c.json.dumps(result,indent=2)+'\n');print(c.json.dumps(result,indent=2))
if __name__=='__main__':main()
