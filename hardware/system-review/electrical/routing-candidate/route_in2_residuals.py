"""Targeted conservative raster route on In2, preserving its ground allocation.
Not a general autorouter; use existing through-via/pad endpoints only. Native
DRC is mandatory after each proposal, as raster geometry is conservative.
"""
from pathlib import Path
import argparse,math,json,heapq,hashlib,shutil
import numpy as np
import pcbnew as p
D=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,default=D/'native/Trimix_Analyzer.kicad_pcb');ap.add_argument('--net',required=True);ap.add_argument('--start',required=True);ap.add_argument('--end',required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--width',type=float,default=.15);ap.add_argument('--layer',choices=['In2.Cu','B.Cu','F.Cu'],default='In2.Cu');a=ap.parse_args();layer={'In2.Cu':p.In2_Cu,'B.Cu':p.B_Cu,'F.Cu':p.F_Cu}[a.layer];b=p.LoadBoard(str(a.board));start=tuple(map(float,a.start.split(',')));end=tuple(map(float,a.end.split(',')))
step=.05;x0=0;y0=17;nx=601;ny=1641;blocked=np.zeros((ny,nx),dtype=bool);margin=.201+a.width/2

def local(box):
 ix0=max(0,int(math.floor((box[0]-x0)/step)));ix1=min(nx-1,int(math.ceil((box[2]-x0)/step)));iy0=max(0,int(math.floor((box[1]-y0)/step)));iy1=min(ny-1,int(math.ceil((box[3]-y0)/step)))
 if ix0>ix1 or iy0>iy1:return None
 X=x0+np.arange(ix0,ix1+1)[None,:]*step;Y=y0+np.arange(iy0,iy1+1)[:,None]*step
 return (ix0,ix1,iy0,iy1,X,Y)
def circle(x,y,r):
 t=local((x-r,y-r,x+r,y+r))
 if t:
  i,j,k,l,X,Y=t;blocked[k:l+1,i:j+1]|=(X-x)**2+(Y-y)**2 <=r*r

def line(s,e,r):
 t=local((min(s[0],e[0])-r,min(s[1],e[1])-r,max(s[0],e[0])+r,max(s[1],e[1])+r))
 if not t:return
 i,j,k,l,X,Y=t;dx=e[0]-s[0];dy=e[1]-s[1];dd=dx*dx+dy*dy
 u=np.zeros_like(X+Y)if dd==0 else np.clip(((X-s[0])*dx+(Y-s[1])*dy)/dd,0,1)
 blocked[k:l+1,i:j+1]|=(X-(s[0]+u*dx))**2+(Y-(s[1]+u*dy))**2<=r*r

def rect(box,r=0):
 t=local((box[0]-r,box[1]-r,box[2]+r,box[3]+r))
 if t:
  i,j,k,l,X,Y=t;dx=np.maximum(np.maximum(box[0]-X,0),X-box[2]);dy=np.maximum(np.maximum(box[1]-Y,0),Y-box[3]);blocked[k:l+1,i:j+1]|=dx*dx+dy*dy<=r*r

def poly(points,r):
 box=(min(q[0]for q in points),min(q[1]for q in points),max(q[0]for q in points),max(q[1]for q in points));t=local(box)
 if t:
  i,j,k,l,X,Y=t;inside=np.zeros_like(X+Y,dtype=bool)
  for s,e in zip(points,points[1:]+points[:1]):
   if e[1]!=s[1]:inside^=((s[1]>Y)!=(e[1]>Y))&(X<(e[0]-s[0])*(Y-s[1])/(e[1]-s[1])+s[0])
  blocked[k:l+1,i:j+1]|=inside
 for s,e in zip(points,points[1:]+points[:1]):line(s,e,r)
def xy(v):return(p.ToMM(v.x),p.ToMM(v.y))
# Board edge, same0.50mm manufacturing clearance as the native design.
rect((0,17,30,17.5),a.width/2);rect((0,98.5,30,99),a.width/2);rect((0,17,.5,99),a.width/2);rect((29.5,17,30,99),a.width/2);rect((0,94.3,6.3,99),a.width/2)
for f in b.GetFootprints():
 for q in f.Pads():
  if q.GetNetname()==a.net:continue
  if not q.IsOnLayer(layer)and not(q.GetDrillSize().x or q.GetDrillSize().y):continue
  bb=q.GetBoundingBox();box=tuple(p.ToMM(t)for t in [bb.GetX(),bb.GetY(),bb.GetRight(),bb.GetBottom()]);rect(box,margin)
for t in b.GetTracks():
 if t.GetNetname()==a.net:continue
 if isinstance(t,p.PCB_VIA):
  x,y=xy(t.GetPosition());circle(x,y,p.ToMM(t.GetWidth(layer))/2+margin)
 elif t.GetLayer()==layer:line(xy(t.GetStart()),xy(t.GetEnd()),p.ToMM(t.GetWidth())/2+margin)
for z in b.Zones():
 if not z.GetLayerSet().Contains(layer):continue
 if z.GetIsRuleArea():
  if not z.GetDoNotAllowTracks():continue
 elif z.GetNetname()==a.net:continue
 # Keep ordinary filled ground-zone allocation intact; do not route through
 # it merely because final KiCad refill could create a slot.
 o=z.Outline()
 for i in range(o.OutlineCount()):
  c=o.COutline(i);pts=[xy(c.CPoint(j))for j in range(c.PointCount())];poly(pts,margin)
def cell(pt):return(int(round((pt[1]-y0)/step)),int(round((pt[0]-x0)/step)))
s=cell(start);goal=cell(end);assert not blocked[s],('blocked start',a.net,start);assert not blocked[goal],('blocked end',a.net,end)
g=np.full((ny,nx),np.inf);g[s]=0;par=np.full((ny,nx),-1,dtype=np.int64);done=np.zeros((ny,nx),bool)
def h(q):
 dy=abs(q[0]-goal[0]);dx=abs(q[1]-goal[1]);return max(dx,dy)+(math.sqrt(2)-1)*min(dx,dy)
queue=[(h(s),0,s[0],s[1])];found=False;nvisit=0
while queue:
 _,old,y,x=heapq.heappop(queue)
 if done[y,x]:continue
 done[y,x]=True;nvisit+=1
 if (y,x)==goal:found=True;break
 for dy,dx in [(0,1),(1,0),(0,-1),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)]:
  yy,xx=y+dy,x+dx
  if not(0<=yy<ny and 0<=xx<nx)or blocked[yy,xx]or done[yy,xx]:continue
  if dx and dy and(blocked[y,xx]or blocked[yy,x]):continue
  cost=old+(math.sqrt(2)if dx and dy else 1)
  if cost<g[yy,xx]:g[yy,xx]=cost;par[yy,xx]=y*nx+x;heapq.heappush(queue,(cost+h((yy,xx)),cost,yy,xx))
info={'layer':a.layer,'net':a.net,'start':start,'end':end,'found':found,'visited':nvisit,'source_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'grid_mm':step,'native_DRC_required':True,'order_release':False}
if not found:a.output.with_suffix('.json').write_text(json.dumps(info,indent=2)+'\n');print(info);raise SystemExit(2)
path=[];q=goal
while q!=s:path.append(q);v=int(par[q]);q=(v//nx,v%nx)
path.append(s);path.reverse();corners=[path[0]];last=None
for j in range(1,len(path)):
 direction=(path[j][0]-path[j-1][0],path[j][1]-path[j-1][1])
 if last is not None and direction!=last:corners.append(path[j-1])
 last=direction
corners.append(path[-1]);pts=[(round(x0+x*step,5),round(y0+y*step,5))for y,x in corners];pts[0]=start;pts[-1]=end
for s,e in zip(pts,pts[1:]):
 t=p.PCB_TRACK(b);t.SetStart(p.VECTOR2I(p.FromMM(s[0]),p.FromMM(s[1])));t.SetEnd(p.VECTOR2I(p.FromMM(e[0]),p.FromMM(e[1])));t.SetWidth(p.FromMM(a.width));t.SetLayer(layer);t.SetNetCode(b.FindNet(a.net).GetNetCode());b.Add(t)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(a.output),b);info.update({'polyline_mm':pts,'length_mm':g[goal]*step,'output_sha256':hashlib.sha256(a.output.read_bytes()).hexdigest()});a.output.with_suffix('.json').write_text(json.dumps(info,indent=2)+'\n');print(info)
