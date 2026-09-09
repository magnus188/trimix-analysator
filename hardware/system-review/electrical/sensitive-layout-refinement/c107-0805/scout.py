import setup as c
from setup import p,b,f,D,xy,vec
import math,json,collections,hashlib
sha=hashlib.sha256((D/"source.kicad_pcb").read_bytes()).hexdigest()
def xy(v):return [p.ToMM(v.x),p.ToMM(v.y)]
def vec(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
layer=p.B_Cu;courts=[]
for fp in b.GetFootprints():
 if fp==f:continue
 fp.BuildCourtyardCaches();s=fp.GetCourtyard(layer)
 if s.OutlineCount():courts.append((fp.GetReference(),s))
objs=[q for q in b.GetTracks()if q.IsOnLayer(layer)]+[q for fp in b.GetFootprints()if fp!=f for q in fp.Pads()if q.IsOnLayer(layer)]
shapes=[(q.GetNetname(),q.GetEffectiveShape(layer),q)for q in objs]
vias=[q for q in b.GetTracks()if isinstance(q,p.PCB_VIA)];drillpads=[q for fp in b.GetFootprints()for q in fp.Pads()if q.GetDrillSize().x>0]
edges=[q.GetEffectiveShape()for q in b.GetDrawings()if q.GetLayer()==p.Edge_Cuts]
fp_rules=[z.Outline()for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(layer)and z.GetDoNotAllowFootprints()]
# Local source gateway itself is reserved, no capacitor land may cover X12..15/Y80..82.
reserve=p.SHAPE_RECT(vec((12,80)),p.FromMM(3),p.FromMM(2))
rows=[];reasons=collections.Counter()
for x in [10+i*.125 for i in range(57)]:
 for y in [77+i*.125 for i in range(25)]:
  for a in [0,90,180,270]:
   if abs(x-12.8)<.1 and abs(y-78.6)<.15:continue # prior rejected position, not repeated
   f.SetPosition(vec((x,y)));f.SetOrientationDegrees(a);f.BuildCourtyardCaches();court=f.GetCourtyard(layer)
   if any(court.Collide(s,0)for r,s in courts):reasons['court']+=1;continue
   if any(court.Collide(s,0)for s in fp_rules):reasons['fpkeepout']+=1;continue
   ok=True;blocks={}
   for pad in f.Pads():
    s=pad.GetEffectiveShape(layer);net=pad.GetNetname()
    
    for n,g,q in shapes:
     if n==net:continue
     if s.Collide(g,p.FromMM(.20)):
      blocks[q.m_Uuid.AsString()]=dict(net=n,kind=type(q).__name__,ref=q.GetParentFootprint().GetReference()if isinstance(q,p.PAD)else None,start=xy(q.GetStart())if isinstance(q,p.PCB_TRACK)else None,end=xy(q.GetEnd())if isinstance(q,p.PCB_TRACK)else None,width_mm=p.ToMM(q.GetWidth(layer))if isinstance(q,p.PCB_VIA)else p.ToMM(q.GetWidth())if isinstance(q,p.PCB_TRACK)else None)
    if any(s.Collide(v.GetPosition(),int(v.GetWidth(layer)/2)+p.FromMM(.05))for v in vias):ok=False;reasons['via_SMToverlap']+=1;break
    if any(s.Collide(q.GetEffectiveShape(layer),p.FromMM(.05))for q in drillpads):ok=False;reasons['PTH_SMToverlap']+=1;break
    if any(s.Collide(e,p.FromMM(.5))for e in edges):ok=False;reasons['edge']+=1;break
   if not ok:continue
   pads={q.GetNumber():xy(q.GetPosition())for q in f.Pads()}
   nearest=sorted([v for v in vias if v.GetNetname()=='GND'],key=lambda v:math.dist(pads['2'],xy(v.GetPosition())))[:3]
   score=math.dist(pads['1'],[12.79,81.15])+math.dist(pads['2'],[16.05,78.05])
   if blocks and not (len(blocks)<=2 and all(q['kind']=='PCB_TRACK'for q in blocks.values())):reasons['hardcopper']+=1;continue
   rows.append(dict(position=[x,y],rotation=a,pads=pads,score_mm=score,nearest_GND_vias=[xy(v.GetPosition())for v in nearest],foreign_blocking_tracks=blocks))
rows.sort(key=lambda r:(len(r['foreign_blocking_tracks']),r['score_mm']))

(D/'pose-scout.json').write_text(json.dumps(dict(source_sha256=sha,status='pose-only; no routing/DRC/CAD qualification',reserved_C103=[12,80,15,82],region=[9,75,17,81],step=.25,rows=rows,rejects=dict(reasons)),indent=2)+'\n')
print(json.dumps(dict(count=len(rows),first=rows[:18],rejects=dict(reasons)),indent=2))
