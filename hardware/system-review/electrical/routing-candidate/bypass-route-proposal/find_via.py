from pathlib import Path
import sys,math
import sexpdata
from shapely.geometry import Point
from shapely.ops import unary_union
D=Path(__file__).resolve().parent;sys.path.insert(0,str(D.parents[1]/'main-final-independent'))
from cam_geometry import Native
n=Native(sexpdata.loads((D/'capswap-open.kicad_pcb').read_text()))
for net,cx,cy,xlo,xhi,ylo,yhi in [('USB_OVP_5V',14.9,91.6,14.4,16,91.25,92.1),('GND',12.3,93.7,11,13.4,93.0,94.5)]:
 other=unary_union([v['geo']for v in n.vias if v['net']!=net]+[t['geo']for t in n.tracks if t['net']!=net]+[p['geo']for L in ['F.Cu','B.Cu','In1.Cu','In2.Cu']for p in n.pads_on(L)if p['net']!=net])
 own=unary_union([p['geo']for L in ['F.Cu','B.Cu']for p in n.pads_on(L)if p['net']==net])
 got=[]
 for ix in range(round(xlo*40),round(xhi*40)+1):
  for iy in range(round(ylo*40),round(yhi*40)+1):
   x,y=ix/40,iy/40;pt=Point(x,-y)
   if pt.distance(other)>=.451 and pt.distance(own)>=.251:got.append((math.hypot(x-cx,y-cy),x,y,pt.distance(other)))
 print(net,'sites',len(got),'nearest',sorted(got)[:15])
