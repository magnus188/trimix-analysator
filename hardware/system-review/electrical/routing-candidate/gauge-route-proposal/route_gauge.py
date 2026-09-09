"""Targeted conservative raster route on In2, preserving its ground allocation.
Not a general autorouter; use existing through-via/pad endpoints only. Native
DRC is mandatory after each proposal, as raster geometry is conservative.
"""
from pathlib import Path
import argparse,math,json,heapq,hashlib,shutil
import numpy as np
import pcbnew as p
D=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--board',type=Path,default=D/'native/Trimix_Analyzer.kicad_pcb');ap.add_argument('--net',required=True);ap.add_argument('--start',required=True);ap.add_argument('--end',required=True);ap.add_argument('--output',type=Path,required=True);ap.add_argument('--width',type=float,default=.15);ap.add_argument('--layer',choices=['In2.Cu','B.Cu','F.Cu'],default='In2.Cu');ap.add_argument('--start-layer',choices=['F.Cu','B.Cu','In2.Cu','all'],default='all');ap.add_argument('--end-layer',choices=['F.Cu','B.Cu','In2.Cu','all'],default='all');ap.add_argument('--outer-only',action='store_true');ap.add_argument('--via-diameter',type=float,default=.5);ap.add_argument('--via-drill',type=float,default=.25);a=ap.parse_args();layer={'In2.Cu':p.In2_Cu,'B.Cu':p.B_Cu,'F.Cu':p.F_Cu}[a.layer];b=p.LoadBoard(str(a.board));start=tuple(map(float,a.start.split(',')));end=tuple(map(float,a.end.split(',')))
step=.025;x0=6;y0=68;nx=581;ny=441;blocked=np.zeros((ny,nx),dtype=bool);margin=.201+a.width/2

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
def build_mask(layer, via=False):
 global blocked, margin
 blocked=np.zeros((ny,nx),dtype=bool);margin=.201+(a.via_diameter/2 if via else a.width/2)
 rect((0,17,30,17.5),(a.via_diameter/2 if via else a.width/2));rect((0,98.5,30,99),(a.via_diameter/2 if via else a.width/2));rect((0,17,.5,99),(a.via_diameter/2 if via else a.width/2));rect((29.5,17,30,99),(a.via_diameter/2 if via else a.width/2));rect((0,94.3,6.3,99),(a.via_diameter/2 if via else a.width/2))
 for f in b.GetFootprints():
  for q in f.Pads():
   if q.GetNetname()==a.net:
    if via and q.GetAttribute()==p.PAD_ATTRIB_SMD:
     bb=q.GetBoundingBox();box=tuple(p.ToMM(t)for t in [bb.GetX(),bb.GetY(),bb.GetRight(),bb.GetBottom()]);rect(box,a.via_diameter/2+.001)
    continue
   if not via and not q.IsOnLayer(layer)and not(q.GetDrillSize().x or q.GetDrillSize().y):continue
   bb=q.GetBoundingBox();box=tuple(p.ToMM(t)for t in [bb.GetX(),bb.GetY(),bb.GetRight(),bb.GetBottom()]);rect(box,margin)
 for t in b.GetTracks():
  if t.GetNetname()==a.net:continue
  if isinstance(t,p.PCB_VIA):
   x,y=xy(t.GetPosition());circle(x,y,p.ToMM(t.GetWidth(layer))/2+margin)
  elif via or t.GetLayer()==layer:line(xy(t.GetStart()),xy(t.GetEnd()),p.ToMM(t.GetWidth())/2+margin)
 for z in b.Zones():
  if not via and not z.GetLayerSet().Contains(layer):continue
  if z.GetIsRuleArea():
   if not(z.GetDoNotAllowVias()if via else z.GetDoNotAllowTracks()):continue
  elif via or z.GetNetname()==a.net:continue
  # Keep ordinary filled ground-zone allocation intact; do not route through
  # it merely because final KiCad refill could create a slot.
  o=z.Outline()
  for i in range(o.OutlineCount()):
   c=o.COutline(i);pts=[xy(c.CPoint(j))for j in range(c.PointCount())];poly(pts,margin)
 return blocked
layers=[p.F_Cu,p.In2_Cu,p.B_Cu]; masks=np.stack([build_mask(L)for L in layers]);
if a.outer_only:masks[1,:,:]=True
vm=build_mask(p.F_Cu,True)
# In2 ground allocation remains forbidden for signal tracks. Conventional
# through-via antipads are allowed, as in the existing native design; final
# return-plane connectivity/CAM checks must verify these isolated holes.
vm=blocked.copy()
def cell(pt):return(int(round((pt[1]-y0)/step)),int(round((pt[0]-x0)/step)))
s=cell(start);goal=cell(end);print('endpoint masks',masks[:,s[0],s[1]].tolist(),masks[:,goal[0],goal[1]].tolist());g=np.full((3,ny,nx),np.inf);par=np.full((3,ny,nx),-1,dtype=np.int64);done=np.zeros((3,ny,nx),bool)
def h(q):
 dy=abs(q[0]-goal[0]);dx=abs(q[1]-goal[1]);return max(dx,dy)+(math.sqrt(2)-1)*min(dx,dy)
queue=[]
for L in range(3):
 if (a.start_layer=='all' or b.GetLayerName(layers[L])==a.start_layer)and not masks[L,s[0],s[1]]:g[L,s[0],s[1]]=0;heapq.heappush(queue,(h(s),0,L,s[0],s[1]))
assert queue,('blocked start all layers',start)
found=False;nvisit=0;reached=None
while queue:
 _,old,L,y,x=heapq.heappop(queue)
 if done[L,y,x]:continue
 done[L,y,x]=True;nvisit+=1
 if (y,x)==goal and(a.end_layer=='all' or b.GetLayerName(layers[L])==a.end_layer):found=True;reached=(L,y,x);break
 moves=[(L,y+dy,x+dx,math.sqrt(2)if dx and dy else 1)for dy,dx in [(0,1),(1,0),(0,-1),(-1,0),(1,1),(1,-1),(-1,1),(-1,-1)]]
 if x%2==0 and y%2==0 and not vm[y,x]:moves +=[(LL,y,x,60)for LL in range(3)if LL!=L]
 for LL,yy,xx,delta in moves:
  if not(0<=yy<ny and 0<=xx<nx)or masks[LL,yy,xx]or done[LL,yy,xx]:continue
  if LL==L and xx!=x and yy!=y and(masks[L,y,xx]or masks[L,yy,x]):continue
  cost=old+delta
  if cost<g[LL,yy,xx]:g[LL,yy,xx]=cost;par[LL,yy,xx]=(L*ny+y)*nx+x;heapq.heappush(queue,(cost+h((yy,xx)),cost,LL,yy,xx))
info={'layer':a.layer,'net':a.net,'start':start,'end':end,'found':found,'visited':nvisit,'source_sha256':hashlib.sha256(a.board.read_bytes()).hexdigest(),'grid_mm':step,'native_DRC_required':True,'order_release':False}
if not found:
 np.savez_compressed(a.output.with_suffix('.npz'),masks=masks,vm=vm,visited=done,start=s,goal=goal,x0=x0,y0=y0,step=step)
 a.output.with_suffix('.json').write_text(json.dumps(info,indent=2)+'\n');print(info);raise SystemExit(2)
path=[];q=reached
while par[q]>=0:
 path.append(q);v=int(par[q]);q=(v//(ny*nx),(v//nx)%ny,v%nx)
path.append(q);path.reverse();corners=[path[0]];last=None
for j in range(1,len(path)):
 direction=tuple(path[j][k]-path[j-1][k]for k in range(3))
 if last is not None and direction!=last:corners.append(path[j-1])
 last=direction
corners.append(path[-1]);pts=[(L,round(x0+x*step,5),round(y0+y*step,5))for L,y,x in corners]
pts[0]=(pts[0][0],*start);pts[-1]=(pts[-1][0],*end);newvias=[];segments=[]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
for s,e in zip(pts,pts[1:]):
 if s[0]!=e[0]:
  assert s[1:]==e[1:]
  if s[1:]not in newvias:
   t=p.PCB_VIA(b);t.SetPosition(v(s[1:]));t.SetWidth(p.FromMM(a.via_diameter));t.SetDrill(p.FromMM(a.via_drill));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(b.FindNet(a.net).GetNetCode());b.Add(t);newvias.append(s[1:])
 else:
  t=p.PCB_TRACK(b);t.SetStart(v(s[1:]));t.SetEnd(v(e[1:]));t.SetWidth(p.FromMM(a.width));t.SetLayer(layers[s[0]]);t.SetNetCode(b.FindNet(a.net).GetNetCode());b.Add(t);segments.append({'layer':b.GetLayerName(layers[s[0]]),'start':s[1:],'end':e[1:],'width_mm':a.width})
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15);p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(a.output),b);info.update({'segments':segments,'new_vias':{'positions_mm':newvias,'diameter_mm':a.via_diameter,'drill_mm':a.via_drill},'cost':float(g[reached]),'output_sha256':hashlib.sha256(a.output.read_bytes()).hexdigest()});a.output.with_suffix('.json').write_text(json.dumps(info,indent=2)+'\n');print({k:v for k,v in info.items()if k!='segments'})
