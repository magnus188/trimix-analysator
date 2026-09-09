from pathlib import Path
import sys,json,heapq,math
import sexpdata,numpy as np
from shapely import contains_xy
from shapely.geometry import Point,LineString,box
from shapely.ops import unary_union
from shapely import affinity
sys.path.insert(0,str(Path('hardware/system-review/electrical/main-final-independent').resolve()))
from cam_geometry import Native,subs,sub
D=Path(__file__).resolve().parent
raw=sexpdata.loads((D/'before.kicad_pcb').read_text());n=Native(raw)
REM=['4b291ac0-a348-449b-b7c3-96616f0cd57d','a17243ee-dd32-41cb-813f-e6afefdd7a6e','d1a5ec27-128e-4836-bb47-b959be16af99','a2a35e92-71ed-44a8-91c8-52439f48acb5','aa06adf8-6565-4a26-bead-b1d0cd9f6315','03570def-3c4f-4865-8779-e201a5065730','1d68ff45-c177-49d4-9c0b-e53fdfdbbdc6','b92dabf5-e141-4747-a238-9616e909feed','e0960715-2eb2-4e5a-b711-b5a0ffd97772']
for t,r in zip(n.tracks,subs(raw,'segment')):t['uuid']=sub(r,'uuid')[0]
NET={p['ref']+'.'+p['pin']:p['net'] for p in n.pads}

def route(cx,cy,net,start,end,added=[],width=.15):
 obs=[]
 for p in n.pads_on('B.Cu'):
  if p['net']==net:continue
  g=p['geo']
  if p['ref']=='C116':g=affinity.translate(affinity.rotate(g,180,origin=(17,-90)),cx-17,90-cy)
  obs.append(g)
 for t in n.tracks:
  if t['layer']=='B.Cu' and t['net']!=net and t['uuid'] not in REM:obs.append(t['geo'])
 for v in n.vias:
  if v['net']!=net:obs.append(v['geo'])
 for nn,pts,ww in added:
  if nn!=net:obs.append(LineString([(x,-y)for x,y in pts]).buffer(ww/2))
 # y extension is only x16..18.2
 scope=box(15,-91.3,19,-88.5).union(box(16,-91.55,18.2,-91.3))
 union=unary_union(obs).buffer(.201+width/2,quad_segs=32)
 step=.01;x0,y0=15.,88.5;xs=np.arange(15,19.001,step);ys=np.arange(88.5,91.551,step)
 X,Y=np.meshgrid(xs,ys);free=~contains_xy(union,X,-Y)&contains_xy(scope.buffer(.00001),X,-Y)
 def idx(pt):return (int(round((pt[1]-y0)/step)),int(round((pt[0]-x0)/step)))
 def pt(ij):return (round(x0+ij[1]*step,6),round(y0+ij[0]*step,6))
 si,ei=idx(start),idx(end)
 if not free[si] or not free[ei]:return None,('endpointblocked',free[si],free[ei])
 heap=[(0,0,si)];cost={si:0};prev={}
 while heap:
  _,c,p=heapq.heappop(heap)
  if c>cost[p]+1e-8:continue
  if p==ei:break
  for dy,dx in [(0,1),(0,-1),(1,0),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)]:
   q=(p[0]+dy,p[1]+dx)
   if q[0]<0 or q[1]<0 or q[0]>=len(ys)or q[1]>=len(xs)or not free[q]:continue
   v=c+math.hypot(dx,dy)
   if v>=cost.get(q,1e50):continue
   cost[q]=v;prev[q]=p;heapq.heappush(heap,(v+math.hypot(q[0]-ei[0],q[1]-ei[1]),v,q))
 else:return None,('no_path',len(cost))
 path=[ei]
 while path[-1]!=si:path.append(prev[path[-1]])
 path=list(map(pt,path[::-1]));path[0]=start;path[-1]=end
 # Greedy exact collision-safe string pulling.
 simp=[path[0]];i=0
 while i<len(path)-1:
  chosen=i+1
  for j in range(len(path)-1,i,-1):
   l=LineString([(path[i][0],-path[i][1]),(path[j][0],-path[j][1])])
   if not l.intersects(union) and scope.buffer(.00001).covers(l):chosen=j;break
  simp.append(path[chosen]);i=chosen
 return simp,('ok',len(cost))
if __name__=='__main__':
 out=[]
 for cx,cy in [(17.2,90),(17.24,89.96),(17.25,89.95),(17.2,89.96),(17.15,89.96),(17.25,90)]:
  ilm,st=route(cx,cy,NET['R126.1'],(15.4,90.225),(18.75,90.825));print(cx,cy,'ILM',st,ilm,flush=True)
  if not ilm:continue
  gnd,gs=route(cx,cy,'GND',(15.4,89.775),(cx,cy+.775),[(NET['R126.1'],ilm,.15)])
  print('GND',gs,gnd,flush=True)
  if not gnd:continue
  gg,ggs=route(cx,cy,'GND',(cx,cy+.775),(18.75,89.175),[(NET['R126.1'],ilm,.15),('GND',gnd,.15)])
  print('return',ggs,gg,flush=True)
  if not gg:continue
  dvd,ds=route(cx,cy,NET['C116.1'],(15.4,89.3),(cx,cy-.775),[(NET['R126.1'],ilm,.15),('GND',gnd,.15),('GND',gg,.15)])
  print('DVDT',ds,dvd,flush=True)
  if dvd:out.append({'centre':[cx,cy],'rotation':270,'removed':REM,'tracks':[(NET['R126.1'],ilm,.15),('GND',gnd,.15),('GND',gg,.15),(NET['C116.1'],dvd,.15)]})
 (D/'search-results.json').write_text(json.dumps(out,indent=2))
