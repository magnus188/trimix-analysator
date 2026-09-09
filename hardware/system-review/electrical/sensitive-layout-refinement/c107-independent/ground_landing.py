import build_bridge as c,json,math
p=c.p;b=c.b
r=json.loads((c.OUT/'GND-reachable.json').read_text());pts=sorted([(round(q[0]*r['step_mm'],5),round(q[1]*r['step_mm'],5))for q in r['visited']if q[2]==2],key=lambda q:math.dist(q,(15.225,79)))
obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()];ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
rules=[z for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]if z.GetIsRuleArea()and z.GetDoNotAllowVias()]
index={L:{}for L in ALL}
for t in obs:
 for L in ALL:
  if not t.IsOnLayer(L):continue
  if t.GetNetname()=='GND' and not(isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD):continue
  s=t.GetEffectiveShape(L);bb=s.BBox();bb.Inflate(p.FromMM(.85));lo=c.xy(bb.GetOrigin());hi=c.xy(bb.GetEnd())
  for x in range(math.floor(lo[0]),math.floor(hi[0])+1):
   for y in range(math.floor(lo[1]),math.floor(hi[1])+1):index[L].setdefault((x,y),[]).append((s,t))
def hits(pt,rad):
 if any(z.Outline().Collide(c.vec(pt),p.FromMM(rad))for z in rules):return ['via_keepout']
 result=[]
 for L in ALL:
  for s,t in index[L].get((math.floor(pt[0]),math.floor(pt[1])),[]):
   margin=.0501 if t.GetNetname()=='GND'else .2001
   if s.Collide(c.vec(pt),p.FromMM(rad+margin)):result.append(t.GetNetname())
 return result
rows=[]
for dia in [.6,.5]:
 cand=[]
 for a in pts:
  if not hits(a,dia/2):
   cand.append(a)
   if len(cand)==12:break
 rows.append(dict(diameter=dia,drill=.3 if dia==.6 else .25,candidates=cand))
print(rows);(c.OUT/'reachable-landing-scout.json').write_text(json.dumps({'rows':rows,'tested_reachable_positions':len(pts),'no_native_drc':True},indent=2)+'\n')
