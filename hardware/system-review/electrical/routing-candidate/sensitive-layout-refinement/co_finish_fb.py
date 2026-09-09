from pathlib import Path
import sys,types,shutil,json,math
import pcbnew as p
D=Path(__file__).resolve().parent;OUT=D/'co-fb-complete';shutil.copytree(D/'co-he-routed',OUT,dirs_exist_ok=True)
board=OUT/'Trimix_Analyzer.kicad_pcb';b=p.LoadBoard(str(board))
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return p.ToMM(q.x),p.ToMM(q.y)
def track(net,points,layer,width=.15):
 for a,z in zip(points,points[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetLayer(layer);t.SetWidth(p.FromMM(width));t.SetNet(b.FindNet(net));b.Add(t)
def via(net,q):
 v=p.PCB_VIA(b);v.SetPosition(vec(q));v.SetWidth(p.FromMM(.5));v.SetDrill(p.FromMM(.25));v.SetViaType(p.VIATYPE_THROUGH);v.SetLayerPair(p.F_Cu,p.B_Cu);v.SetNet(b.FindNet(net));b.Add(v)
f=next(f for f in b.GetFootprints()if f.GetReference()=='R702');pads={q.GetNumber():xy(q.GetPosition())for q in f.Pads()};print(pads)
LAYERS=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu];NET='GND';start=pads['2'];objs=[(t,t.GetEffectiveShape(l),l)for t in list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]for l in LAYERS if t.IsOnLayer(l)]
rules=[z.Outline()for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()and z.GetDoNotAllowVias()];rows=[]
for xi in range(350,409):
 for yi in range(1040,1100):
  at=(xi*.05,yi*.05);q=vec(at);seg=p.SEG(vec(start),q)
  if any(s.Collide(q,p.FromMM(.4501))for t,s,l in objs if t.GetNetname()!=NET):continue
  if any(s.Collide(q,p.FromMM(.3001))for t,s,l in objs if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD):continue
  if any(s.Collide(q,p.FromMM(.2501))for s in rules):continue
  if any(s.Collide(seg,p.FromMM(.3001))for t,s,l in objs if l==p.F_Cu and t.GetNetname()!=NET):continue
  rows.append((math.dist(at,start),at))
rows.sort();print('GND choices',rows[:6]);assert rows
at=rows[0][1];via('GND',at);track('GND',[start,at],p.F_Cu,.2)
track('CO_FB',[pads['1'],(18.7875,55.8)],p.F_Cu,.15)
c=types.SimpleNamespace(p=p,b=b,OUT=OUT,vec=vec,xy=xy,track=track,via=via)
code=(D.parent/'upper-bus-route-proposal/route_bounded.py').read_text().replace('import build_upper_bus as c','').replace('for l in range(3)if l!=n[2]','for l in (0,2)if l!=n[2]');g={'c':c};exec(compile(code,'bounded_native_route','exec'),g)
g['route']('CO_FB',(17.05,55.375),pads['1'],start_layers=(0,),end_layers=(0,),allow_vias=True,bounds=(15.5,52.9,20.1,57.5))
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(board),b)
