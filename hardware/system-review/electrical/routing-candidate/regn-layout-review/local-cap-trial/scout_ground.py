import build_bridge as c
import math,json
p=c.p
c.track('PACK_P',[(10.64,79.9091),(13.6,78.1),(13.85,78.0),(15.5,75.85),(16.1271,74.422)],p.B_Cu,.4)
c.track('/01  CHARGING + BATTERY/BQ_REGN',[(12.79,81.15),(12.8,80.075)],p.B_Cu,.4)
index={};counter={}
def put(shape,margin,label):
 bb=shape.BBox();bb.Inflate(p.FromMM(margin+.001));lo=c.xy(bb.GetOrigin());hi=c.xy(bb.GetEnd())
 for x in range(math.floor(lo[0]),math.floor(hi[0])+1):
  for y in range(math.floor(lo[1]),math.floor(hi[1])+1):index.setdefault((x,y),[]).append((shape,p.FromMM(margin),label))
for t in list(c.b.GetTracks())+[q for f in c.b.GetFootprints() for q in f.Pads()]:
 for L in [p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
  if t.IsOnLayer(L) and t.GetNetname()!='GND':put(t.GetEffectiveShape(L),.5001,t.m_Uuid.AsString())
 if isinstance(t,p.PAD) and t.GetAttribute()==p.PAD_ATTRIB_SMD:
  for L in [p.F_Cu,p.B_Cu]:
   if t.IsOnLayer(L):put(t.GetEffectiveShape(L),.3501,'SMT'+t.m_Uuid.AsString())
 if isinstance(t,p.PCB_VIA) and t.GetNetname()=='GND':put(t.GetEffectiveShape(p.F_Cu),.3001,'GNDvia-spacing')
for z in list(c.b.Zones())+[z for f in c.b.GetFootprints() for z in f.Zones()]:
 if z.GetIsRuleArea() and z.GetDoNotAllowVias():put(z.Outline(),.3001,'keepout')
out=[]
for ix in range(85,181):
 for iy in range(720,811):
  at=(ix/10,iy/10);q=c.vec(at)
  if any(s.Collide(q,r) for s,r,label in index.get((math.floor(at[0]),math.floor(at[1])),[])):continue
  out.append({'at_mm':at,'distance_to_C107_GND_mm':math.dist(at,(12.8,77.125))})
out.sort(key=lambda q:q['distance_to_C107_GND_mm'])
(c.OUT/'ground-via-scout.json').write_text(json.dumps({'status':'native_point_scout_only','source_sha256':c.SHA,'grid_mm':.1,'diameter_mm':.6,'drill_mm':.3,'candidates':out,'limits':['No saved routing result','Ground connection and full DRC pending']},indent=2)+'\n')
print(json.dumps(out[:15],indent=2))
