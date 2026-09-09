from pathlib import Path
import pcbnew as p,json,hashlib,math
D=Path(__file__).resolve().parent;path=D/'r118-r119-frozen.kicad_pcb';b=p.LoadBoard(str(path))
v=next(t for t in b.GetTracks()if isinstance(t,p.PCB_VIA) and abs(p.ToMM(t.GetPosition().x)-4.95)<1e-5 and abs(p.ToMM(t.GetPosition().y)-88.85)<1e-5)
rows=[]
for f in b.GetFootprints():
 for q in f.Pads():
  if math.dist((p.ToMM(q.GetPosition().x),p.ToMM(q.GetPosition().y)),(4.95,88.85))>6:continue
  for L in [p.F_Cu,p.B_Cu]:
   if not q.IsOnLayer(L):continue
   a=v.GetEffectiveShape(L);z=q.GetEffectiveShape(L)
   lo=0;hi=5
   for i in range(22):
    mid=(lo+hi)/2
    if a.Collide(z,p.FromMM(mid)):hi=mid
    else:lo=mid
   rows.append(dict(ref=f.GetReference(),pad=q.GetNumber(),net=q.GetNetname(),layer=b.GetLayerName(L),surface_gap_lower_mm=lo))
rows.sort(key=lambda q:q['surface_gap_lower_mm']);assert rows[0]['surface_gap_lower_mm']>.05
for q in rows:
 if q['net']!=v.GetNetname():assert q['surface_gap_lower_mm']>=.1999,q
(D/'r118-r119-via-pad-clearance.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),via_uuid=v.m_Uuid.AsString(),at_mm=[4.95,88.85],diameter_mm=.5,drill_mm=.25,annulus_nominal_mm=.125,all_nearby_pad_surface_gaps=rows,method='Binary search using native effective pad/annulus shapes, all F/B SMT and PTH lands included. Ordinary .50/.25 via; >=.20 foreign-net gap and >=.05 same-net surface gap.'),indent=2));print(rows[:5])
