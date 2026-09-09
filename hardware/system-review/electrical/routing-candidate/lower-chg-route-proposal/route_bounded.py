"""Isolated CC gap: F/B only; preserve inner-plane allocation."""
import heapq, itertools, math
import build_bridge as c
p=c.p; b=c.b
def route(NET,start,end,end_layers=(0,1,2),start_layers=(0,),width=.15,allow_vias=True,bounds=(7,74,26.5,86.5),targets=None):
 LAYERS=[p.F_Cu,p.In2_Cu,p.B_Cu]; ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
 STEP=.05; BOUNDS=bounds
 index={l:{}for l in ALL}; smd={l:{}for l in ALL}; edge={l:{}for l in ALL}; rule={l:{}for l in ALL}; vrule={l:{}for l in ALL}
 def add_shape(target,layer,shape):
  bb=shape.BBox();bb.Inflate(p.FromMM(1.0))
  lo=c.xy(bb.GetOrigin());hi=c.xy(bb.GetEnd())
  for x in range(math.floor(max(BOUNDS[0],lo[0])),math.floor(min(BOUNDS[2],hi[0]))+1):
   for y in range(math.floor(max(BOUNDS[1],lo[1])),math.floor(min(BOUNDS[3],hi[1]))+1):target[layer].setdefault((x,y),[]).append(shape)
 for it in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]:
  for layer in ALL:
   if not it.IsOnLayer(layer):continue
   shape=it.GetEffectiveShape(layer)
   if it.GetNetname()!=NET:add_shape(index,layer,shape)
   if isinstance(it,p.PAD) and it.GetAttribute()==p.PAD_ATTRIB_SMD:add_shape(smd,layer,shape)
 for it in b.GetDrawings():
  if it.GetLayer()==p.Edge_Cuts:
   for L in ALL:add_shape(edge,L,it.GetEffectiveShape())
 for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
  if not z.GetIsRuleArea():continue
  for L in ALL:
   if not z.GetLayerSet().Contains(L):continue
   if z.GetDoNotAllowTracks():add_shape(rule,L,z.Outline())
   if z.GetDoNotAllowVias():add_shape(vrule,L,z.Outline())
 def shapes(target,layer,q):return target[layer].get((math.floor(q[0]),math.floor(q[1])),[])
 def blocked(q,layer,r):return any(s.Collide(c.vec(q),p.FromMM(r))for s in shapes(index,layer,q))
 def clear(a,z,layer):
  seg=p.SEG(c.vec(a),c.vec(z))
  # Long simplification segments sample every0.25mm to obtain all candidates.
  n=max(1,math.ceil(math.dist(a,z)/.25));seen=set()
  for i in range(n+1):
   q=(a[0]+(z[0]-a[0])*i/n,a[1]+(z[1]-a[1])*i/n)
   cell=(math.floor(q[0]),math.floor(q[1]))
   if cell in seen:continue
   seen.add(cell)
   if any(s.Collide(seg,p.FromMM(.2001+width/2))for s in shapes(index,layer,q)):return False
   if any(s.Collide(seg,p.FromMM(.5001+width/2))for s in shapes(edge,layer,q)):return False
   if any(s.Collide(seg,p.FromMM(.0001+width/2))for s in shapes(rule,layer,q)):return False
  return True
 
 def pt(n):return(round(n[0]*STEP,6),round(n[1]*STEP,6))
 def candidates(q,l):
  ix,iy=round(q[0]/STEP),round(q[1]/STEP);out=[]
  for dx in range(-3,4):
   for dy in range(-3,4):
    n=(ix+dx,iy+dy,l);point=pt(n)
    if clear(q,point,LAYERS[l]):out.append((n,math.dist(q,point)))
  return out
 target_points=targets or [(l,end)for l in end_layers]
 ends={}
 for layer,target in target_points:
  for n,d in candidates(target,layer):
   if n not in ends or d<ends[n][0]:ends[n]=(d,target)
 def heuristic(q):return min(math.dist(q,target)for layer,target in target_points)
 legal_cache={};via_cache={}
 def legal(n):
  if n not in legal_cache:
   q=pt(n);legal_cache[n]=BOUNDS[0]<=q[0]<=BOUNDS[2] and BOUNDS[1]<=q[1]<=BOUNDS[3] and not blocked(q,LAYERS[n[2]],.2001+width/2) and not any(s.Collide(c.vec(q),p.FromMM(.5001+width/2))for s in shapes(edge,LAYERS[n[2]],q)) and not any(s.Collide(c.vec(q),p.FromMM(.0001+width/2))for s in shapes(rule,LAYERS[n[2]],q))
  return legal_cache[n]
 def change(n):
  k=n[:2]
  if k not in via_cache:
   q=pt(n)
   via_cache[k]=not any(s.Collide(c.vec(q),p.FromMM(.7501))for s in shapes(edge,p.F_Cu,q)) and all(not s.Collide(c.vec(q),p.FromMM(.2501))for l in ALL for s in shapes(vrule,l,q)) and all(not blocked(q,l,.4501)for l in ALL) and all(not s.Collide(c.vec(q),p.FromMM(.3001))for l in [p.F_Cu,p.B_Cu]for s in shapes(smd,l,q))
  return via_cache[k]
 dist={};prev={};queue=[];serial=itertools.count()
 for n,d in [q for l in start_layers for q in candidates(start,l)]:
  if legal(n):dist[n]=d;prev[n]=None;heapq.heappush(queue,(d+heuristic(pt(n)),next(serial),n))
 goal=None
 while queue:
  _,_,n=heapq.heappop(queue)
  if n in ends:goal=n;break
  ns=[(n[0]+dx,n[1]+dy,n[2],STEP*math.hypot(dx,dy)*(8.0 if n[2]==1 else 1.0))for dx,dy in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(1,-1),(-1,1),(-1,-1)]]
  if allow_vias and change(n):ns +=[(n[0],n[1],l,2.0)for l in range(3)if l!=n[2]]
  for x,y,l,cost in ns:
   q=(x,y,l)
   if not legal(q):continue
   if l==n[2]and not clear(pt(n),pt(q),LAYERS[l]):continue
   nd=dist[n]+cost
   if nd>=dist.get(q,float('inf'))-.000001:continue
   dist[q]=nd;prev[q]=n;heapq.heappush(queue,(nd+heuristic(pt(q)),next(serial),q))
 if goal is None:
  import json
  (c.OUT/(NET.replace('/','_')+'-reachable.json')).write_text(json.dumps({'step_mm':STEP,'bounds':BOUNDS,'start':start,'end':end,'visited':list(dist),'targets':[(n,ends[n][1])for n in ends]},separators=(',',':')))
  print('visit counts',[(LAYERS[l],len([q for q in dist if q[2]==l]),[min(q[i]for q in dist if q[2]==l)*STEP for i in[0,1]]if any(q[2]==l for q in dist)else[],[max(q[i]for q in dist if q[2]==l)*STEP for i in[0,1]]if any(q[2]==l for q in dist)else[])for l in range(3)])
  print('legal vias', [pt(k+(0,))for k,v in via_cache.items()if v][:50])
  print('goals',len(ends))
 assert goal is not None,('no bounded route',len(dist))
 nodes=[];n=goal
 while n is not None:nodes.append(n);n=prev[n]
 nodes.reverse();paths=[];current=[start,pt(nodes[0])];layer=nodes[0][2]
 for a,z in zip(nodes,nodes[1:]):
  if a[2]!=z[2]:paths.append((layer,current));c.via(NET,pt(a));current=[pt(z)];layer=z[2]
  else:current.append(pt(z))
 current.append(ends[goal][1]);paths.append((layer,current))
 for layer,points in paths:
  simple=[points[0]];i=0
  while i<len(points)-1:
   j=len(points)-1
   while j>i+1 and not clear(points[i],points[j],LAYERS[layer]):j-=1
   simple.append(points[j]);i=j
  c.track(NET,simple,LAYERS[layer],width=width)
  print(b.GetLayerName(LAYERS[layer]),simple,flush=True)
