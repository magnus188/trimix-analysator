from pathlib import Path
import pcbnew as p,numpy as np,json,hashlib
from PIL import Image,ImageDraw
from scipy.ndimage import distance_transform_edt,label
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon,Circle,Rectangle
D=Path(__file__).resolve().parent
files=[D/'native/Trimix_Analyzer.kicad_pcb',D/'local-set-slot-explicit.kicad_pcb'];fig,axs=plt.subplots(1,2,figsize=(13,8));receipt=[]
for f,ax in zip(files,axs):
 b=p.LoadBoard(str(f));polys=[];areas=[]
 for z in b.Zones():
  if z.GetNetname()=='GND'and z.GetLayerSet().Contains(p.In2_Cu):
   a=z.GetFilledPolysList(p.In2_Cu)
   for i in range(a.OutlineCount()):
    o=a.COutline(i);pts=[(p.ToMM(o.CPoint(j).x),p.ToMM(o.CPoint(j).y))for j in range(o.PointCount())];polys.append(pts);areas.append(abs(o.Area())/1e12);ax.add_patch(Polygon(pts,facecolor='#9cccaa',edgecolor='#35764b',linewidth=.45))
 for t in b.GetTracks():
  if isinstance(t,p.PCB_VIA):
   x,y=p.ToMM(t.GetPosition().x),p.ToMM(t.GetPosition().y)
   if not(7<x<21 and 83<y<94.2):continue
   ax.add_patch(Circle((x,y),p.ToMM(t.GetWidth(p.In2_Cu))/2,facecolor='#40885a'if t.GetNetname()=='GND'else'#f6d275',edgecolor='#666',linewidth=.4))
  elif t.GetLayer()==p.In2_Cu:
   s,e=t.GetStart(),t.GetEnd();x=[p.ToMM(s.x),p.ToMM(e.x)];y=[p.ToMM(s.y),p.ToMM(e.y)]
   if max(x)<7 or min(x)>21 or max(y)<83 or min(y)>94.2:continue
   ax.plot(x,y,color='#af216b'if t.GetNetname()=='USB_OVP_SET'else'#666666',linewidth=p.ToMM(t.GetWidth())*15)
 for t in b.GetTracks():
  if not isinstance(t,p.PCB_VIA) and t.GetLayer()==p.B_Cu and t.GetNetname()in['USB_5V','USB_OVP_5V','USB_CHG_5V','GND']:
   s,e=t.GetStart(),t.GetEnd();x=[p.ToMM(s.x),p.ToMM(e.x)];y=[p.ToMM(s.y),p.ToMM(e.y)]
   if max(x)<7 or min(x)>21 or max(y)<83 or min(y)>94.2:continue
   colors={'USB_5V':'#da7621','USB_OVP_5V':'#2060c0','USB_CHG_5V':'#783c97','GND':'#13472c'}
   ax.plot(x,y,color=colors[t.GetNetname()],linewidth=p.ToMM(t.GetWidth())*15,alpha=.95)
 for ref in ['U115','C114','C115','R123']:
  fp=next(q for q in b.GetFootprints()if q.GetReference()==ref)
  for pad in fp.Pads():
   bb=pad.GetBoundingBox();x,y,w,h=map(p.ToMM,[bb.GetX(),bb.GetY(),bb.GetWidth(),bb.GetHeight()]);ax.add_patch(Rectangle((x,y),w,h,fill=False,edgecolor='#bf493e',linewidth=.7))
  ax.text(p.ToMM(fp.GetPosition().x),p.ToMM(fp.GetPosition().y),ref,fontsize=8,color='#7c201c')
 ax.set_xlim(7,21);ax.set_ylim(94.2,83);ax.set_aspect('equal');ax.set_title('Accepted baseline'if f==files[0]else'Isolated OVP-set proposal');ax.set_xlabel('PCB X / mm');ax.set_ylabel('PCB Y / mm');ax.grid(alpha=.15)
 idx=int(np.argmax(areas));im=Image.new('1',(1401,1121));draw=ImageDraw.Draw(im);draw.polygon([((x-7)*100,(y-83)*100)for x,y in polys[idx]],fill=1);arr=np.array(im,dtype=bool);distance=distance_transform_edt(arr)*.01;sweep=[]
 for r in[0,.05,.1,.15,.2,.25,.3]:
  labs,n=label(arr if r==0 else distance>r);counts=np.bincount(labs.ravel())[1:]*.0001;large=[float(v)for v in counts if v>=.25];sweep.append({'erosion_radius_mm':r,'bulk_regions_at_least_0p25mm2':len(large),'bulk_areas_mm2':large})
 receipt.append({'file':str(f),'sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'filled_GND_outline_areas_mm2':areas,'largest_ground_polygon_erosion_sweep':sweep})
fig.suptitle('Actual native In2 filled copper; red outlines = selected B-side lands\nIn2 SET magenta; B raw USB orange, protected USB blue, limited USB purple, GND dark green.',fontsize=11);fig.tight_layout();fig.savefig(D/'local-set-ground-bcopper-review.png',dpi=180)
(D/'local-set-ground-review.json').write_text(json.dumps({'resolution_mm':.01,'method':'Pixel erosion sensitivity is not an exact global minimum-neck or current-rating calculation. Counts below0.25mm2 are excluded from bulk connectivity; see full native polygon geometry.','boards':receipt},indent=2)+'\n')
