from pathlib import Path
import json,math,collections
import build_bridge as c
p=c.p;b=c.b
f=next(f for f in b.GetFootprints()if f.GetReference()=='R107')
courts=[]
for q in b.GetFootprints():
 if q.GetReference()=='R107':continue
 q.BuildCourtyardCaches();s=q.GetCourtyard(p.F_Cu)
 if s.OutlineCount():courts.append((q.GetReference(),s))
objects=[t for t in b.GetTracks()if t.IsOnLayer(p.F_Cu)]+[q for fp in b.GetFootprints()if fp.GetReference()!='R107' for q in fp.Pads()if q.IsOnLayer(p.F_Cu)]
shapes=[(q.GetNetname(),q.GetEffectiveShape(p.F_Cu))for q in objects]
edges=[q.GetEffectiveShape()for q in b.GetDrawings()if q.GetLayer()==p.Edge_Cuts]
rules=[z.Outline()for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(p.F_Cu)and z.GetDoNotAllowFootprints()]
rows=[];rejects=collections.Counter()
for x_i in range(10,93):
 for y_i in range(176,268):
  x,y=x_i/4,y_i/4
  for angle in [0,90]:
   f.SetPosition(c.vec((x,y)));f.SetOrientationDegrees(angle);f.BuildCourtyardCaches();court=f.GetCourtyard(p.F_Cu)
   hit=next((r for r,q in courts if court.Collide(q,0)),None)
   if hit:rejects['courtyard:'+hit]+=1;continue
   if any(court.Collide(q,0)for q in rules):rejects['rule']+=1;continue
   bb=court.BBox()
   # The provisional J301 complete mating envelope exceeds its bare courtyard.
   if p.ToMM(bb.GetEnd().x)>=23.245 and p.ToMM(bb.GetOrigin().y)<=71.505:continue
   good=True;score=0;points=[]
   for pad in f.Pads():
    shape=pad.GetEffectiveShape(p.F_Cu);net=pad.GetNetname();pt=c.xy(pad.GetPosition())
    if any(shape.Collide(q,p.FromMM(.2001))for n,q in shapes if n!=net)or any(shape.Collide(q,p.FromMM(.5001))for q in edges):good=False;break
    distances=[math.dist(pt,c.xy(q.GetPosition()))for q in objects if q.GetNetname()==net]
    score+=min(distances)if distances else 100
    points.append({'pin':pad.GetNumber(),'net':net,'at':pt})
   if not good:rejects['pad']+=1
   if good:rows.append({'x':x,'y':y,'angle':angle,'score':score,'pads':points})
rows.sort(key=lambda r:r['score']);(c.OUT/'pose-scout.json').write_text(json.dumps({'source':c.EXPECTED,'removed_source_items':c.removed,'candidates':rows},indent=2)+'\n')
print(json.dumps(rows[:25],indent=2));print(rejects)
