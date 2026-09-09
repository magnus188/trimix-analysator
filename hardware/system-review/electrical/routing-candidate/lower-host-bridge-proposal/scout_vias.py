from pathlib import Path
import pcbnew as p,json,math
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D/'before.kicad_pcb'))
NET='CHG_INT_N';layers=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
items=list(b.GetTracks())+[q for f in b.GetFootprints() for q in f.Pads()]
near=[]
for q in items:
 bb=q.GetBoundingBox();bb.Inflate(p.FromMM(1))
 if bb.Intersects(p.BOX2I(vec((7.5,88)),vec((3,7)))):near.append(q)
legal=[]
for xi in range(160,201):
 for yi in range(1770,1891):
  xy=(xi*.05,yi*.05);v=vec(xy);bad=False
  for q in near:
   for L in layers:
    if not q.IsOnLayer(L):continue
    if q.GetNetname()==NET and not(isinstance(q,p.PAD)and q.GetAttribute()==p.PAD_ATTRIB_SMD):continue
    if q.GetEffectiveShape(L).Collide(v,p.FromMM(.4501)):bad=True;break
   if bad:break
  if not bad:legal.append([round(x,3)for x in xy])
(D/'via-scout.json').write_text(json.dumps({'net':NET,'ordinary_vias_mm':[.5,.25],'clearance_mm':.2001,'excludes_zones_and_rules':True,'legal_sites_nominal_only':legal},indent=2)+'\n')
print(len(legal),legal[:20])
