"""Native isolated CHG gateway scout; reads frozen combined geometry, no PCB writes."""
from pathlib import Path
import pcbnew as p,json,math,time
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D/'combined-unmoved.kicad_pcb'))
L=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
V='551051f9-15ca-4e98-9e17-600b206e2b0c';F='65121007-3de7-4bc3-a370-c282aa06715a';I='d56470aa-89ba-4753-b400-b48efdeb517f'
lookup={t.m_Uuid.AsString():t for t in b.GetTracks()};target=[lookup[x]for x in[V,F,I]]
old=[t for t in b.GetTracks()if t.m_Uuid.AsString()not in[V,F,I]]+[q for f in b.GetFootprints()for q in f.Pads()]
near=[]
for q in old:
 bb=q.GetBoundingBox();a,z=bb.GetOrigin(),bb.GetEnd()
 if p.ToMM(z.x)>=11 and p.ToMM(a.x)<=18 and p.ToMM(z.y)>=86 and p.ToMM(a.y)<=91:near.append(q)
rules=[z for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()]
edges=[e for e in b.GetDrawings()if e.GetLayer()==p.Edge_Cuts]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def at(q):
 target[0].SetPosition(vec(q));target[1].SetEnd(vec(q));target[2].SetStart(vec(q))
def check(t,full=False):
 failures=[];v=isinstance(t,p.PCB_VIA)
 for ly in L:
  if not t.IsOnLayer(ly):continue
  sh=t.GetEffectiveShape(ly)
  for o in near:
   if not o.IsOnLayer(ly):continue
   if o.GetNetname()!=t.GetNetname()and sh.Collide(o.GetEffectiveShape(ly),p.FromMM(.2001)):
    failures.append(['foreign',b.GetLayerName(ly),o.m_Uuid.AsString(),o.GetNetname()])
   if v and isinstance(o,p.PAD)and sh.Collide(o.GetEffectiveShape(ly),p.FromMM(.0501)):failures.append(['pad_exclusion',b.GetLayerName(ly),o.GetParentFootprint().GetReference(),o.GetNumber()])
  for r in rules:
   if r.GetLayerSet().Contains(ly)and(r.GetDoNotAllowVias()if v else r.GetDoNotAllowTracks())and sh.Collide(r.Outline(),p.FromMM(.0001)):failures.append(['rule_area',r.m_Uuid.AsString()])
  for e in edges:
   if sh.Collide(e.GetEffectiveShape(),p.FromMM(.5001)):failures.append(['edge',e.m_Uuid.AsString()])
 if v:
  for o in near:
   if isinstance(o,p.PCB_VIA)and math.dist([p.ToMM(t.GetPosition().x),p.ToMM(t.GetPosition().y)],[p.ToMM(o.GetPosition().x),p.ToMM(o.GetPosition().y)])<(p.ToMM(t.GetDrillValue())+p.ToMM(o.GetDrillValue()))/2+.2501:failures.append(['hole_to_hole',o.m_Uuid.AsString()])
 return failures
if __name__=='__main__':
 report={'explicit':[],'via_only_clear':[],'fully_clear':[]};now=time.time()
 for q in[(15.95,88.35),(16.25,87.8),(16.3,87.8),(16.25,87.75),(16.1,87.9)]:
  at(q);report['explicit'].append({'at':q,'checks':{t.m_Uuid.AsString():check(t,True)for t in target}})
 for ix in range(305,333):
  for iy in range(1745,1779):
   q=(ix*.05,iy*.05);at(q)
   if check(target[0]):continue
   report['via_only_clear'].append(q)
   if not check(target[1])and not check(target[2]):report['fully_clear'].append(q)
 report['fully_clear'].sort(key=lambda q:math.dist(q,(15.95,88.35)));report['elapsed_s']=time.time()-now
 (D/'scout.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
