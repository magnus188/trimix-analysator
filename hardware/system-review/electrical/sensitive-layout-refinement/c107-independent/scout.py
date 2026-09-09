"""Read-only, bounded same1206 B-placement scout on frozen9f274. No board save."""
from pathlib import Path
import json,hashlib,math,collections
import pcbnew as p
D=Path(__file__).resolve().parent;src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb');data=src.read_bytes();sha=hashlib.sha256(data).hexdigest();assert sha=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
(D/'source.kicad_pcb').write_bytes(data);b=p.LoadBoard(str(D/'source.kicad_pcb'));f=next(f for f in b.GetFootprints()if f.GetReference()=='C107');f.Flip(f.GetPosition(),False)
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
for x in [9+i*.25 for i in range(33)]:
 for y in [75+i*.25 for i in range(25)]:
  for a in [0,90,180,270]:
   if abs(x-12.8)<.1 and abs(y-78.6)<.15:continue # prior rejected position, not repeated
   f.SetPosition(vec((x,y)));f.SetOrientationDegrees(a);f.BuildCourtyardCaches();court=f.GetCourtyard(layer)
   if any(court.Collide(s,0)for r,s in courts):reasons['court']+=1;continue
   if any(court.Collide(s,0)for s in fp_rules):reasons['fpkeepout']+=1;continue
   ok=True;blocks={}
   for pad in f.Pads():
    s=pad.GetEffectiveShape(layer);net=pad.GetNetname()
    if s.Collide(reserve,0):ok=False;reasons['C103reserved']+=1;break
    for n,g,q in shapes:
     if n==net:continue
     if s.Collide(g,p.FromMM(.20)):
      blocks[q.m_Uuid.AsString()]=dict(net=n,kind=type(q).__name__,ref=q.GetParentFootprint().GetReference()if isinstance(q,p.PAD)else None,start=xy(q.GetStart())if isinstance(q,p.PCB_TRACK)else None,end=xy(q.GetEnd())if isinstance(q,p.PCB_TRACK)else None,width_mm=p.ToMM(q.GetWidth())if isinstance(q,p.PCB_TRACK)else None)
    if any(s.Collide(v.GetPosition(),int(v.GetWidth(layer)/2)+p.FromMM(.05))for v in vias):ok=False;reasons['via_SMToverlap']+=1;break
    if any(s.Collide(q.GetEffectiveShape(layer),p.FromMM(.05))for q in drillpads):ok=False;reasons['PTH_SMToverlap']+=1;break
    if any(s.Collide(e,p.FromMM(.5))for e in edges):ok=False;reasons['edge']+=1;break
   if not ok:continue
   pads={q.GetNumber():xy(q.GetPosition())for q in f.Pads()}
   nearest=sorted([v for v in vias if v.GetNetname()=='GND'],key=lambda v:math.dist(pads['2'],xy(v.GetPosition())))[:3]
   score=math.dist(pads['1'],[12.79,81.15])+math.dist(pads['2'],xy(nearest[0].GetPosition()))
   if blocks and not (len(blocks)<=2 and all(q['kind']=='PCB_TRACK'for q in blocks.values())):reasons['hardcopper']+=1;continue
   rows.append(dict(position=[x,y],rotation=a,pads=pads,score_mm=score,nearest_GND_vias=[xy(v.GetPosition())for v in nearest],foreign_blocking_tracks=blocks))
rows.sort(key=lambda r:(len(r['foreign_blocking_tracks']),r['score_mm']))
assert data==src.read_bytes()
(D/'pose-scout.json').write_text(json.dumps(dict(source_sha256=sha,status='pose-only; no routing/DRC/CAD qualification',reserved_C103=[12,80,15,82],region=[9,75,17,81],step=.25,rows=rows,rejects=dict(reasons)),indent=2)+'\n')
print(json.dumps(dict(count=len(rows),first=rows[:12],rejects=dict(reasons)),indent=2))
