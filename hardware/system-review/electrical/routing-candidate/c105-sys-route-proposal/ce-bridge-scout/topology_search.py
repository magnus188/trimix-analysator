"""Read-only bounded all-conductor CE reconnection; in-memory target-track removal."""
import scout as c
import importlib.util,time
p=c.p;math=c.math;heapq=c.heapq;json=c.json
LAYERS=[p.F_Cu,p.In2_Cu,p.B_Cu];STEP=.05;BOUNDS=(.8,78,21,94.4)
helper=c.D.parents[1]/'upper-bus-route-proposal/island_targets.py'
spec=importlib.util.spec_from_file_location('native_islands',helper);mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)
c.b.Remove(c.target)
power=json.loads((c.D/'bounded-sites.json').read_text())['power_reservation']
for a,z in zip(power['hypothetical_points_mm'],power['hypothetical_points_mm'][1:]):
 t=p.PCB_TRACK(c.b);t.SetStart(c.v(a));t.SetEnd(c.v(z));t.SetWidth(p.FromMM(.4));t.SetLayer(p.In2_Cu)
 c.foreign[p.In2_Cu].append(({'reserved':'VSYS','start':a,'end':z},t.GetEffectiveShape(p.In2_Cu)))
index={L:{}for L in c.ALL};smd={L:{}for L in c.ALL};edges={L:{}for L in c.ALL};rules={L:{}for L in c.ALL};vrules={L:{}for L in c.ALL}
def add(target,L,entry):
 s=entry[1];bb=s.BBox();bb.Inflate(p.FromMM(.85));a=c.xy(bb.GetOrigin());z=c.xy(bb.GetEnd())
 for x in range(math.floor(max(BOUNDS[0]-.3,a[0])),math.floor(min(BOUNDS[2]+.3,z[0]))+1):
  for y in range(math.floor(max(BOUNDS[1]-.3,a[1])),math.floor(min(BOUNDS[3]+.3,z[1]))+1):target[L].setdefault((x,y),[]).append(entry)
for L in c.ALL:
 for row in c.foreign[L]:add(index,L,row)
 for row in c.smt:add(smd,L,row)
 for row in c.edges:add(edges,L,row)
 for row in c.rules[L]:add(rules,L,row)
 for row in c.vrules:add(vrules,L,row)
def rows(idx,L,q):return idx[L].get((math.floor(q[0]),math.floor(q[1])),[])
def hits(shape,entries,r):return any(s.Collide(shape,p.FromMM(r))for i,s in entries)
def clear(a,z,L):
 seg=p.SEG(c.v(a),c.v(z));seen=set();n=max(1,math.ceil(math.dist(a,z)/.3))
 for i in range(n+1):
  q=[a[j]+(z[j]-a[j])*i/n for j in [0,1]];cell=(math.floor(q[0]),math.floor(q[1]))
  if cell in seen:continue
  seen.add(cell)
  if hits(seg,rows(index,L,q),.2751)or hits(seg,rows(edges,L,q),.5751)or hits(seg,rows(rules,L,q),.0751):return False
 return True
def pt(n):return [round(n[0]*STEP,6),round(n[1]*STEP,6)]
def island_points(seed):
 targets,receipt=mod.connected_track_targets(c.b,c.NET,seed,BOUNDS,spacing=.2)
 ids=set(receipt['connected_object_uuids'])
 for f in c.b.GetFootprints():
  for q in f.Pads():
   if q.m_Uuid.AsString()in ids:
    xy=c.xy(q.GetPosition())
    if BOUNDS[0]<=xy[0]<=BOUNDS[2]and BOUNDS[1]<=xy[1]<=BOUNDS[3]:targets += [(i,xy)for i,L in enumerate(LAYERS)if q.IsOnLayer(L)]
 return targets,receipt
def nearby(q,l):
 ix,iy=[round(v/STEP)for v in q]
 for dx in [-1,0,1]:
  for dy in [-1,0,1]:
   n=(ix+dx,iy+dy,l);xy=pt(n)
   if clear(q,xy,LAYERS[l]):yield n,math.dist(q,xy)
def main():
 started=time.time();starts,lower=island_points('228a514a-28cf-4e4b-a43d-b0ea803668ce');targets,upper=island_points('8ded3cc9-54c0-41ba-998d-242419a60348')
 assert not set(lower['connected_object_uuids'])&set(upper['connected_object_uuids'])
 print('native-islands',len(lower['connected_object_uuids']),len(upper['connected_object_uuids']),'points',len(starts),len(targets),flush=True)
 legal_cache={};via_cache={}
 def legal(n):
  if n not in legal_cache:
   q=pt(n);L=LAYERS[n[2]];v=c.v(q)
   legal_cache[n]=BOUNDS[0]<=q[0]<=BOUNDS[2]and BOUNDS[1]<=q[1]<=BOUNDS[3]and not hits(v,rows(index,L,q),.2751)and not hits(v,rows(edges,L,q),.5751)and not hits(v,rows(rules,L,q),.0751)
  return legal_cache[n]
 def via(n):
  k=n[:2]
  if k not in via_cache:
   q=pt(n);v=c.v(q)
   via_cache[k]=all(not hits(v,rows(index,L,q),.4501)for L in c.ALL)and not hits(v,rows(smd,p.F_Cu,q),.3001)and not hits(v,rows(edges,p.F_Cu,q),.7501)and not hits(v,rows(vrules,p.F_Cu,q),.2501)
  return via_cache[k]
 goals={}
 for l,q in targets:
  for n,d in nearby(q,l):
   if legal(n)and(d<goals.get(n,(float('inf'),None))[0]):goals[n]=(d,q)
 target_xy=[q for l,q in targets]
 def heuristic(q):return min(math.hypot(q[0]-t[0],q[1]-t[1])for t in target_xy)
 serial=c.itertools.count();dist={};prev={};orig={};Q=[]
 for l,q in starts:
  for n,d in nearby(q,l):
   if legal(n)and d<dist.get(n,float('inf')):
    dist[n]=d;prev[n]=None;orig[n]=(l,q);heapq.heappush(Q,(d+heuristic(pt(n)),next(serial),n))
 seen=set();found=None;reported=0
 while Q:
  _,_,n=heapq.heappop(Q)
  if n in seen:continue
  seen.add(n)
  if len(seen)//20000>reported:reported=len(seen)//20000;print('visited',len(seen),'elapsed',round(time.time()-started),flush=True)
  if n in goals:found=n;break
  near=[(n[0]+dx,n[1]+dy,n[2],STEP*math.hypot(dx,dy))for dx,dy in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(1,-1),(-1,1),(-1,-1)]]
  if via(n):near +=[(n[0],n[1],l,1.8)for l in range(3)if l!=n[2]]
  for x,y,l,cost in near:
   z=(x,y,l)
   if not legal(z)or(l==n[2]and not clear(pt(n),pt(z),LAYERS[l])):continue
   nd=dist[n]+cost
   if nd>=dist.get(z,float('inf')):continue
   dist[z]=nd;prev[z]=n;orig[z]=orig[n];heapq.heappush(Q,(nd+heuristic(pt(z)),next(serial),z))
 result={'source_sha256':c.EXPECTED,'target_track_removed_in_memory_only':c.UID,'native_lower_island':lower,'native_upper_island':upper,'power_reservation':power,'grid_mm':STEP,'bounds_mm':BOUNDS,'found':found is not None,'visited':len(seen),'elapsed_seconds':time.time()-started,'layers':{c.b.GetLayerName(L):{'count':len([n for n in seen if n[2]==i]),'legal_via_sites':[pt(n)for n in seen if n[2]==i and via_cache.get(n[:2],False)]}for i,L in enumerate(LAYERS)}}
 if found is not None:
  nodes=[];n=found
  while n is not None:nodes.append(n);n=prev[n]
  nodes.reverse();paths=[];vias=[];current=[orig[found][1],pt(nodes[0])];L=LAYERS[nodes[0][2]]
  for a,z in zip(nodes,nodes[1:]):
   if a[2]!=z[2]:paths.append((L,current));vias.append(pt(a));current=[pt(z)];L=LAYERS[z[2]]
   else:current.append(pt(z))
  current.append(goals[found][1]);paths.append((L,current));result['paths']=[];result['new_vias']=vias
  for L,points0 in paths:
   points=[]
   for q in points0:
    if not points or q!=points[-1]:points.append(q)
   simple=[points[0]];i=0
   while i<len(points)-1:
    j=len(points)-1
    while j>i+1 and not clear(points[i],points[j],L):j-=1
    simple.append(points[j]);i=j
   result['paths'].append({'layer':c.b.GetLayerName(L),'points':simple,'width_mm':.15})
  print('FOUND',result['paths'],'vias',vias,flush=True)
 else:print('EXHAUSTED',len(seen),flush=True)
 assert c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED
 result['source_unchanged']=True;(c.D/'topology-result.json').write_text(json.dumps(result,indent=2)+'\n')
if __name__=='__main__':main()
