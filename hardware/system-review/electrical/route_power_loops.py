"""Explicit first-pass power copper; preserve poses and validate in native DRC.

Short pad necks are0.20mm; wide sections0.5–1mm. This is incomplete copper,
not thermal/current capability approval. Each path is individually reviewable.
"""
from pathlib import Path
import pcbnew as p,json,math,shutil
ROOT=Path(__file__).resolve().parents[3];OUT=Path(__file__).resolve().parent;PATH=ROOT/'hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb'
b=p.LoadBoard(str(PATH));fps={f.GetReference():f for f in b.GetFootprints()};back=OUT/'before-power-routes.kicad_pcb'
if not back.exists():shutil.copy2(PATH,back)
def pad(r,n):return next(z for z in fps[r].Pads()if z.GetNumber()==str(n))
def v(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
added=[]
def trace(ref,no,pts,width):
 net=pad(ref,no).GetNetCode()
 for (x,y),(u,vv)in zip(pts,pts[1:]):
  if abs(x-u)+abs(y-vv)<1e-7:continue
  t=p.PCB_TRACK(b);t.SetStart(v(x,y));t.SetEnd(v(u,vv));t.SetWidth(p.FromMM(width));t.SetLayer(p.F_Cu);t.SetNetCode(net);b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'start':[x,y],'end':[u,vv],'width_mm':width})
# TPS63020 paired L2 pins to adjacent inductor left terminal.
trace('U201',6,[(11.6,62),(11.1,62)],.2)
trace('U201',7,[(11.6,62.5),(11.1,62.5)],.2)
trace('U201',7,[(11.1,62.3),(11.1,64.65),(11.815,65.365),(11.815,66)],.5)
trace('U201',8,[(14.4,62.5),(14.8,62.5)],.2)
trace('U201',9,[(14.4,62),(14.8,62)],.2)
trace('U201',8,[(14.8,62.3),(14.8,64.7),(14.185,65.315),(14.185,66)],.5)
trace('U201',6,[(11.1,62),(11.1,62.3)],.2)
trace('U201',9,[(14.8,62),(14.8,62.3)],.2)
# TPS input cap connection, wide after the package escape.
trace('U201',10,[(14.4,61.5),(15.6,61.5)],.2)
trace('U201',11,[(14.4,61),(15.1,61),(15.6,61.5)],.2)
trace('U201',10,[(15.6,61.5),(16.7,62.6),(16.7,63.225)],.6)
# TPS output bank starts directly at pins4/5, with ground pads on the inner side.
def via(ref,no,x,y):
 t=p.PCB_VIA(b);t.SetPosition(v(x,y));t.SetWidth(p.FromMM(.6));t.SetDrill(p.FromMM(.3));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(pad(ref,no).GetNetCode());b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'via_mm':[x,y],'diameter_mm':.6,'drill_mm':.3})
trace('U201',4,[(11.6,61),(10.8,61),(10.8,61.25)],.2)
trace('U201',5,[(11.6,61.5),(10.8,61.5),(10.8,61.25)],.2)
via('U201',4,10.8,61.25)
for x,y in [(6.675,60.25),(6.675,59.55)]:via('U201',4,x,y)
trace('U201',4,[(6.675,59.55),(6.675,68.9)],.6)
route=[(10.8,61.25),(7.675,61.25),(6.675,60.25),(6.675,59.55)]
for start,end in zip(route,route[1:]):
 t=p.PCB_TRACK(b);t.SetStart(v(*start));t.SetEnd(v(*end));t.SetWidth(p.FromMM(.8));t.SetLayer(p.In2_Cu);t.SetNetCode(pad('U201',4).GetNetCode());b.Add(t);added.append({'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'layer':'In2.Cu','start':start,'end':end,'width_mm':.8})
# BQ twoSW pins to short, wide inductor terminal; no central-L101 keepout crossing.
trace('U101',19,[(14.25,82.0375),(14.25,81.2)],.2)
trace('U101',20,[(13.75,82.0375),(13.75,81.2)],.2)
trace('U101',19,[(13.75,81.2),(14.25,81.2),(14.25,80.1),(13.5,79.35),(13.5,79.225)],.6)
trace('L101',2,[(13.5,73.775),(16.65,73.775),(18.125,75.25)],1)
p.SaveBoard(str(PATH),b);(OUT/'power-route-draft.json').write_text(json.dumps({'tracks':added,'status':'native DRC required; current/thermal/complete-loop ground connections pending','order_release':False},indent=2)+'\n');print(len(added),'power draft segments')
