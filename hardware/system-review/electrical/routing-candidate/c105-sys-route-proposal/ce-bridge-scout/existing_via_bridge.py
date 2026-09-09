"""Bounded outer layer route from legal new CE via to retained existing CE via."""
import bridge_search as s
c=s.c;p=c.p;math=c.math;heapq=c.heapq
STEP=.05; BOUNDS=(8.5,85.5,13.1,90.25)
def pt(n):return [round(n[0]*STEP,5),round(n[1]*STEP,5)]
def route(starts,end,L):
 goal=tuple(round(q/STEP)for q in end);serial=c.itertools.count();dist={};prev={};orig={};Q=[];legal={}
 def valid(n):
  if n not in legal:
   q=pt(n);legal[n]=BOUNDS[0]<=q[0]<=BOUNDS[2]and BOUNDS[1]<=q[1]<=BOUNDS[3]and c.legal(q,L)
  return legal[n]
 for q in starts:
  n=tuple(round(z/STEP)for z in q);dist[n]=0;prev[n]=None;orig[n]=q;heapq.heappush(Q,(math.dist(q,end),next(serial),n))
 seen=set();found=None
 while Q:
  _,_,n=heapq.heappop(Q)
  if n in seen:continue
  seen.add(n)
  if n==goal:found=n;break
  for dx,dy in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(1,-1),(-1,1),(-1,-1)]:
   z=(n[0]+dx,n[1]+dy)
   if not valid(z)or not c.clear(pt(n),pt(z),L):continue
   nd=dist[n]+STEP*math.hypot(dx,dy)
   if nd>=dist.get(z,float('inf')):continue
   dist[z]=nd;prev[z]=n;orig[z]=orig[n];heapq.heappush(Q,(nd+math.dist(pt(z),end),next(serial),z))
 if found is None:return {'found':False,'visited':len(seen),'reachable_bounds':[[min(n[i]for n in seen)*STEP,max(n[i]for n in seen)*STEP]for i in [0,1]]}
 points=[];n=found
 while n is not None:points.append(pt(n));n=prev[n]
 points.reverse();simple=[points[0]];i=0
 while i<len(points)-1:
  j=len(points)-1
  while j>i+1 and not c.clear(points[i],points[j],L):j-=1
  simple.append(points[j]);i=j
 return {'found':True,'visited':len(seen),'points':simple,'length_mm':sum(math.dist(a,z)for a,z in zip(simple,simple[1:]))}
def main():
 d=c.json.loads((c.D/'bounded-sites.json').read_text());end=[12.75,86.65];result={'source_sha256':c.EXPECTED,'grid_mm':STEP,'bounds_mm':BOUNDS,'existing_destination_via':{'uuid':'8ded3cc9-54c0-41ba-998d-242419a60348','position_mm':end,'existing_size_preserved':True},'routes':{}}
 for L in [p.F_Cu,p.B_Cu]:
  r=route(d['lower_binding_vias'],end,L);result['routes'][c.b.GetLayerName(L)]=r;print(c.b.GetLayerName(L),r,flush=True)
 (c.D/'existing-via-bridge.json').write_text(c.json.dumps(result,indent=2)+'\n')
 assert c.hashlib.sha256(c.SOURCE.read_bytes()).hexdigest()==c.EXPECTED
if __name__=='__main__':main()
