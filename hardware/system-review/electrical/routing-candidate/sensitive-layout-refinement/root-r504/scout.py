"""Isolated R504 placement scout against preserved routed checkpoint, never approval."""
from pathlib import Path
import pcbnew as p
import json,hashlib,collections,sys
D=Path(__file__).resolve().parent
src=Path('hardware/pcb/analyzer/Trimix_Analyzer.kicad_pcb')
sha=hashlib.sha256(src.read_bytes()).hexdigest()
assert sha=='9f274fdf198f1bcb871a4fc360e76693f8a5b048553e6a02998141737956514f'
b=p.LoadBoard(str(src));f=next(f for f in b.GetFootprints()if f.GetReference()=='R504')
side=sys.argv[1]if len(sys.argv)>1 else 'F'
layer=p.F_Cu if side=='F'else p.B_Cu
if side=='B':f.Flip(f.GetPosition(),False)
vec=lambda x,y:p.VECTOR2I(p.FromMM(x),p.FromMM(y))
xy=lambda q:[p.ToMM(q.x),p.ToMM(q.y)]
ind=next(f for f in b.GetFootprints()if f.GetReference()=='L701');ind.SetPosition(vec(19.5,50.65))
removed=next(t for t in b.GetTracks()if t.m_Uuid.AsString()=='918a51d0-58a7-44e8-a4f9-89dfe314382a');b.Remove(removed)
courts=[]
for q in b.GetFootprints():
 if q.GetReference()=='R504':continue
 q.BuildCourtyardCaches();s=q.GetCourtyard(layer)
 if s.OutlineCount():courts.append((q.GetReference(),s))
def nearby(q):
 bb=q.GetBoundingBox()
 return bb.GetRight()>=p.FromMM(13)and bb.GetLeft()<=p.FromMM(26)and bb.GetBottom()>=p.FromMM(42)and bb.GetTop()<=p.FromMM(52)
objs=[t for t in b.GetTracks()if t.IsOnLayer(layer)and nearby(t)]+[q for fp in b.GetFootprints()if fp.GetReference()!='R504'for q in fp.Pads()if q.IsOnLayer(layer)and nearby(q)]
shapes=[(q.GetNetname(),q.GetEffectiveShape(layer),q)for q in objs]
vias=[t for t in b.GetTracks()if isinstance(t,p.PCB_VIA)and nearby(t)]
drilled=[q for fp in b.GetFootprints()for q in fp.Pads()if q.GetDrillSize().x>0 and nearby(q)]
rules=[z.Outline()for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()and z.GetLayerSet().Contains(layer)and z.GetDoNotAllowFootprints()]
rows=[];reject=collections.Counter();courtyard_only=[]
for xi in range(310,471):
 for yi in range(900,961 if side=='F'else 985):
  x,y=xi/20,yi/20
  for a in [0,90,180,270]:
   f.SetPosition(vec(x,y));f.SetOrientationDegrees(a);f.BuildCourtyardCaches();court=f.GetCourtyard(layer)
   hit=next((r for r,s in courts if court.Collide(s,0)),None)
   if hit:reject['court:'+hit]+=1;continue
   if any(court.Collide(s,0)for s in rules):reject['rule']+=1;continue
   hits=[]
   for pad in f.Pads():
    s=pad.GetEffectiveShape(layer)
    hits.extend((n,q.m_Uuid.AsString())for n,g,q in shapes if n!=pad.GetNetname()and s.Collide(g,p.FromMM(.2001)))
    if any(s.Collide(v.GetPosition(),v.GetWidth(layer)//2+p.FromMM(.05))for v in vias):hits.append(('via_interface',''))
    if any(s.Collide(q.GetEffectiveShape(layer),p.FromMM(.05))for q in drilled):hits.append(('drilled_interface',''))
   row=dict(at=[x,y],angle=a,pads=[dict(pin=q.GetNumber(),net=q.GetNetname(),at=xy(q.GetPosition()))for q in f.Pads()])
   if hits:
    reject['copper']+=1
    if y<=47.45:courtyard_only.append(dict(**row,blockers=sorted(set(hits))))
   else:rows.append(row)
rows.sort(key=lambda r:abs(r['at'][0]-18.25)+abs(r['at'][1]-48))
out=dict(status='placement_only_unaccepted',source_sha256=sha,hypothetical_changes=['L701 moved to19.5,50.65; original orientation','HE_EXC_DIV via918a51d0 removed; must reconnect on every original layer'],candidates=rows,courtyard_only=courtyard_only,rejects=dict(reject))
(D/('pose-scout'+('-B'if side=='B'else '')+'.json')).write_text(json.dumps(out,indent=2)+'\n')
assert hashlib.sha256(src.read_bytes()).hexdigest()==sha
print(json.dumps(dict(count=len(rows),first=rows[:20],courtyard_only=len(courtyard_only),rejects=dict(reject)),indent=2))
