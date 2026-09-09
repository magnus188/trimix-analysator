"""Deterministic two-layer grid router for this small USB board; native DRC is final arbiter.
Not a general autorouter and not a controlled-impedance USB high-speed design.
"""
from pathlib import Path
import sys,math,heapq,json
import numpy as np
from scipy.ndimage import distance_transform_edt
import pcbnew as p
HERE=Path(__file__).resolve().parent;sys.path.insert(0,str(HERE))
from route_usb import make,v,P,NAME
b,nets,fps=make()
GRID=.025;NX=641;NY=441;XX,YY=np.meshgrid(np.arange(NX)*GRID+100,np.arange(NY)*GRID+100)
shapes=[];pads={};tracks=[];vias=[]
def raster_rect(x,y,w,h):return (abs(XX-x)<=w/2+1e-7)&(abs(YY-y)<=h/2+1e-7)
def raster_disk(x,y,r):return (XX-x)**2+(YY-y)**2<=r*r+1e-8
def shape_rect(net,layer,x,y,w,h):shapes.append((net,layer,raster_rect(x,y,w,h)))
for ref,fp in fps.items():
 for q in fp.Pads():
  pos=q.GetPosition();x,y=p.ToMM(pos.x),p.ToMM(pos.y);sz=q.GetSize();w,h=p.ToMM(sz.x),p.ToMM(sz.y)
  if abs(fp.GetOrientationDegrees())%180==90:w,h=h,w
  # Geometry conservative for circular/oval pads, exact rectangles for finepitch.
  layers=[0,1] if q.GetAttribute()==p.PAD_ATTRIB_PTH else [0]
  for layer in layers:shape_rect(q.GetNetname(),layer,x,y,w,h)
  pads.setdefault((ref,q.GetNumber()),[]).append((x,y,layers,w,h))
def index(x,y):return (int(round((y-100)/GRID)),int(round((x-100)/GRID)))
def point(row,col):return (100+col*GRID,100+row*GRID)
def addtrack(net,xy,width=.15,layer=0):
 for a,c in zip(xy,xy[1:]):
  if math.dist(a,c)<1e-5:continue
  t=p.PCB_TRACK(b);t.SetStart(v(*a));t.SetEnd(v(*c));t.SetWidth(p.FromMM(width));t.SetLayer(p.F_Cu if layer==0 else p.B_Cu);t.SetNet(nets[net]);b.Add(t)
  mask=np.zeros_like(XX,dtype=bool);n=max(2,int(math.dist(a,c)/GRID*2))
  for f in np.linspace(0,1,n):
   r,k=index(a[0]+f*(c[0]-a[0]),a[1]+f*(c[1]-a[1]));
   if 0<=r<NY and 0<=k<NX:mask[r,k]=True
  mask=distance_transform_edt(~mask)*GRID<=width/2+GRID*.71
  shapes.append((net,layer,mask));tracks.append({'net':net,'xy':[a,c],'width':width,'layer':layer})
def addvia(net,x,y,diam=.45,drill=.2):
 for old in vias:
  if old['net']==net and math.dist(old['xy'],[x,y])<.45:
   for ll in (0,1):addtrack(net,[old['xy'],(x,y)],.15,ll)
   return
 q=p.PCB_VIA(b);q.SetPosition(v(x,y));q.SetWidth(p.FromMM(diam));q.SetDrill(p.FromMM(drill));q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNet(nets[net]);b.Add(q)
 for l in (0,1):shapes.append((net,l,raster_disk(x,y,diam/2)))
 vias.append({'net':net,'xy':[x,y],'diameter':diam,'drill':drill})
def pad(ref,n):return pads[ref,n][0][:2]
# Direct, short, external ground returns; no via under U901 paste.
addtrack('GND',[pad('U901','8'),(109.5,105.6)],.2);addvia('GND',109.5,105.6)
addtrack('GND',[pad('D901','2'),(105.25,108.0)],.3);addvia('GND',105.25,108.0,.6,.3)
# Back-plane stitch at USB GND contacts / fixed shell pins.
for n,x in [('A1',104.72),('B1',111.28)]:
 xy=(x,110.19);addtrack('GND',[xy,(x,109.25)],.3);addvia('GND',x,109.25,.6,.3)

movements=[(-1,0,1),(1,0,1),(0,-1,1),(0,1,1),(-1,-1,1.4142),(-1,1,1.4142),(1,-1,1.4142),(1,1,1.4142)]
def route(net,a,c,width=.15,startlayer=0,goallayer=0):
 # Trace center clearance includes 25um routing discretization margin.
 forbidden=[];viafor=[]
 for l in (0,1):
  occ=np.zeros_like(XX,dtype=bool)
  for nn,ll,m in shapes:
   if ll==l and nn!=net:occ|=m
  dist=distance_transform_edt(~occ)*GRID
  forbidden.append(dist < .15+width/2+GRID*.6)
  viafor.append(dist < .15+.225+GRID*.6)
 # Conservative useful board region. Edge/cutout preservation checked by DRC.
 outside=(XX<101.0)|(XX>115)|(YY<103.5)|(YY>110.375)
 block=np.array(forbidden);block|=outside[None,:,:]
 vm=viafor[0]|viafor[1]|outside
 for pp in pads.values():
  for x,y,ll,w,h in pp:
   if ll==[0]:vm|=raster_rect(x,y,w+.5,h+.5)
 ar,ak=index(*a);cr,ck=index(*c);start=(startlayer,ar,ak);goal=(goallayer,cr,ck)
 # Target actualcenters may be rounded .0125; explicitlyinclude same-net pads.
 block[start]=False;block[goal]=False
 def heuristic(l,r,k):return math.hypot(r-cr,k-ck)+(0 if l==goallayer else 28)
 heap=[(heuristic(*start),0,start)];cost={start:0};parent={};found=False
 while heap:
  _,g,q=heapq.heappop(heap)
  if g!=cost.get(q):continue
  if q==goal:found=True;break
  l,r,k=q
  for dr,dk,dc in movements:
   rr,kk=r+dr,k+dk
   if not(0<=rr<NY and 0<=kk<NX)or block[l,rr,kk]:continue
   if dr and dk and (block[l,r,kk] or block[l,rr,k]):continue
   nq=(l,rr,kk);turn=0
   if q in parent:
    prev=parent[q]
    if prev[0]==l and (r-prev[1],k-prev[2])!=(dr,dk):turn=.3
   ng=g+dc+turn
   if ng<cost.get(nq,1e20):cost[nq]=ng;parent[nq]=q;heapq.heappush(heap,(ng+heuristic(*nq),ng,nq))
  if not vm[r,k] and not block[1-l,r,k]:
   nq=(1-l,r,k);ng=g+45
   if ng<cost.get(nq,1e20):cost[nq]=ng;parent[nq]=q;heapq.heappush(heap,(ng+heuristic(*nq),ng,nq))
 if not found:raise RuntimeError('No route '+net+repr((a,c)))
 path=[goal]
 while path[-1]!=start:path.append(parent[path[-1]])
 path.reverse();segments=[];current=[a];layer=startlayer;lastdir=None
 for i,(l,r,k)in enumerate(path):
  xy=point(r,k)
  if l!=layer:
   current.append(xy);addtrack(net,current,width,layer);addvia(net,*xy);current=[xy];layer=l;lastdir=None
  else:
   if i==0:current.append(xy);continue
   prev=path[i-1];d=(r-prev[1],k-prev[2])
   if lastdir is not None and d!=lastdir:current.append(point(prev[1],prev[2]))
   lastdir=d
 current.append(point(*path[-1][1:]));current.append(c);addtrack(net,current,width,layer)
 print(net,a,c,'steps',len(path),'visited',len(cost),flush=True)

# TI Table4-2 explicitlypermits theseexternalcopperlinks; no internal links assumed.
for net,left,right in [('USB_CC1','1','10'),('USB_CC2','2','9'),('USB_D_P','4','7'),('USB_D_M','5','6')]:addtrack(net,[pad('U901',left),pad('U901',right)],.15)
# Reserve shortconnector escapes before any other net can enclose a pad.
connector={'A5':('USB_CC1',(106.75,109.3)),'B5':('USB_CC2',(109.75,109.3)),
           'A6':('USB_D_P',(107.75,109.3)),'B6':('USB_D_P',(108.75,109.3)),
           'B7':('USB_D_M',(107.25,108.9)),'A7':('USB_D_M',(108.25,108.9))}
for pin,(net,xy) in connector.items():addtrack(net,[pad('J901',pin),xy]);addvia(net,*xy)
# Power trunks are0.60mm; diode is a shortshunt, not a serial narrow neck.
for pin in ('A4','A9'):
 x,y=pad('J901',pin);rear=(x,110.10);addtrack('USB_5V',[(x,y),rear],.3);route('USB_5V',rear,pad('J902','1'),.6)
route('USB_5V',pad('D901','1'),pad('J901','A4'),.3)
# Route exposed pin to clamp, then from opposite external land to harness.
for net,pin,esd,out,harness,second in [('USB_CC1','A5','1','10','3',None),('USB_CC2','B5','2','9','4',None),('USB_D_P','A6','4','7','5','B6'),('USB_D_M','B7','5','6','6','A7')]:
 route(net,connector[pin][1],pad('U901',esd),startlayer=1)
 route(net,pad('U901',out),pad('J902',harness))
 if second:route(net,connector[second][1],pad('U901',esd),startlayer=1)
for layer in (p.F_Cu,p.B_Cu):
 z=p.ZONE(b);z.SetLayer(layer);z.SetNet(nets['GND']);z.SetLocalClearance(p.FromMM(.15));z.SetMinThickness(p.FromMM(.15));z.SetThermalReliefGap(p.FromMM(.2));z.SetThermalReliefSpokeWidth(p.FromMM(.3))
 poly=z.Outline();poly.NewOutline()
 for x,y in [(99,99),(117,99),(117,117),(99,117)]:q=v(x,y);poly.Append(q.x,q.y)
 b.Add(z)
p.SaveBoard(str(P/f'{NAME}.kicad_pcb'),b)
(HERE/'route-intent.json').write_text(json.dumps({'tracks':tracks,'vias':vias,'algorithm':'Offline deterministic2layerAstar; DRC required','power_trunk_width_mm':.6,'VBUS_ESD_shunt_width_mm':.3},indent=2)+'\n')
print('saved',len(tracks),'tracks',len(vias),'vias')
