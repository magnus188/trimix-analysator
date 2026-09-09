from pathlib import Path
import pcbnew as p,json,math
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D/'before.kicad_pcb'));NET='USB_OVP_UVLO'
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def pos(v):return [p.ToMM(v.x),p.ToMM(v.y)]
pad_owner={q.m_Uuid.AsString():f.GetReference()for f in b.GetFootprints()for q in f.Pads()}
objects=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]
shapes=[]
for t in objects:
 for L in ALL:
  if t.IsOnLayer(L)and t.GetNetname()!=NET:
   shape=t.GetEffectiveShape(L);bb=shape.BBox();bb.Inflate(p.FromMM(1));org=pos(bb.GetOrigin());end=pos(bb.GetEnd())
   if end[0]>=11 and org[0]<=14.5 and end[1]>=90 and org[1]<=92:shapes.append((t,L,shape))
d=json.loads((D/(NET+'-reachable.json')).read_text());points=sorted(set((n[0]*.05,n[1]*.05)for n in d['visited']))
rows=[]
for q in points:
 v=vec(q);lo=0;hi=.7
 for i in range(12):
  mid=(lo+hi)/2
  if any(s.Collide(v,p.FromMM(mid))for t,L,s in shapes):hi=mid
  else:lo=mid
 blockers=[]
 for t,L,s in shapes:
  if s.Collide(v,p.FromMM(.4501)):
   info={'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'layer':b.GetLayerName(L)}
   if isinstance(t,p.PAD):info.update(ref=pad_owner[t.m_Uuid.AsString()],pin=t.GetNumber())
   blockers.append(info)
 rows.append({'xy_mm':q,'minimum_foreign_copper_distance_mm':lo,'ordinary_via_blockers':blockers})
rows.sort(key=lambda q:q['minimum_foreign_copper_distance_mm'],reverse=True)
(D/'escape-scout.json').write_text(json.dumps(rows,indent=2)+'\n')
for r in rows[:8]:print(r)
