from pathlib import Path
import pcbnew as p,hashlib,json,math
D=Path('/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/system-review/electrical/routing-candidate/cap-signal-reconnect/pullup-swap');P=D/'Trimix_Analyzer.kicad_pcb';h=hashlib.sha256(P.read_bytes()).hexdigest();assert h=='91f4a842065aa728669f056714bcab805d7b96778e27683fa3d7a9d44d147e20',h;b=p.LoadBoard(str(P));ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return[p.ToMM(q.x),p.ToMM(q.y)]
old=next(t for t in b.GetTracks()if t.m_Uuid.AsString()=='532da661-1898-4d38-b7fc-5d71fe61ab57');print('oldsize',p.ToMM(old.GetWidth(p.F_Cu)),p.ToMM(old.GetDrillValue()))
obs={l:[]for l in ALL};smd={l:[]for l in ALL};edge=[];rule={l:[]for l in ALL};vrule={l:[]for l in ALL}
for t in list(b.GetTracks())+[d for f in b.GetFootprints()for d in f.Pads()]:
 for l in ALL:
  if not t.IsOnLayer(l):continue
  s=t.GetEffectiveShape(l)
  if t.GetNetname()!='I2C_SCL':obs[l].append((t,s))
  if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD:smd[l].append((t,s))
for d in b.GetDrawings():
 if d.GetLayer()==p.Edge_Cuts:edge.append(d.GetEffectiveShape())
for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
 if z.GetIsRuleArea():
  for l in ALL:
   if z.GetLayerSet().Contains(l):
    if z.GetDoNotAllowTracks():rule[l].append(z.Outline())
    if z.GetDoNotAllowVias():vrule[l].append(z.Outline())
def name(t):return t.GetNetname()+':'+(t.GetParentFootprint().GetReference()+'.'+t.GetNumber()if isinstance(t,p.PAD)else t.m_Uuid.AsString())
def clearance(sh,l):
 objects=[(t,s)for t,s in obs[l]if s.Collide(sh,p.FromMM(.9))];lo=0;hi=.9
 for _ in range(18):
  mid=(lo+hi)/2
  if any(s.Collide(sh,p.FromMM(mid))for t,s in objects):hi=mid
  else:lo=mid
 return lo

def seg(a,z,l):
 sh=p.SEG(v(a),v(z));hit=[name(t)for t,s in obs[l]if s.Collide(sh,p.FromMM(.2751))];ed=any(s.Collide(sh,p.FromMM(.5751))for s in edge);ru=any(s.Collide(sh,p.FromMM(.0751))for s in rule[l]);return {'start':a,'end':z,'layer':b.GetLayerName(l),'hits':hit,'edge':ed,'rule':ru,'clearance_mm':round(clearance(sh,l)-.075,6),'passes':not(hit or ed or ru)}
def via(q):
 hits=[(b.GetLayerName(l),name(t))for l in ALL for t,s in obs[l]if s.Collide(v(q),p.FromMM(.4501))];sh=[(b.GetLayerName(l),name(t))for l in ALL for t,s in smd[l]if s.Collide(v(q),p.FromMM(.3001))];ed=any(s.Collide(v(q),p.FromMM(.7501))for s in edge);ru=any(s.Collide(v(q),p.FromMM(.2501))for l in ALL for s in vrule[l]);legs=[seg((25.25,75.15),q,p.F_Cu),seg(q,(25.1,74.5326),p.B_Cu)];return {'at':q,'hits':hits,'SMT_plus_0_05_hits':sh,'edge':ed,'rule':ru,'passes':not(hits or sh or ed or ru)and all(z['passes']for z in legs),'via_copper_gap_mm':round(min(clearance(v(q),l)for l in ALL)-.25,6),'legs':legs}
rows=[via(q)for q in [(25.1,75.15),(25.2,75.15),(25.2,75.3),(25.25,75.3),(25.25,75.325),(25.225,75.275)]]
for r in rows:print(r)
legal=[]
for x in range(1004,1021):
 for y in range(3005,3021):
  r=via((x*.025,y*.025))
  if r['passes']:r['minimum_copper_gap_mm']=min(r['via_copper_gap_mm'],*[z['clearance_mm']for z in r['legs']]);legal.append(r)
legal.sort(key=lambda r:(-r['minimum_copper_gap_mm'],math.dist(r['at'],(25.1,75.15))))
assert hashlib.sha256(P.read_bytes()).hexdigest()==h
(D/'independent-scl-via-review.json').write_text(json.dumps({'board_sha256':h,'via_uuid':old.m_Uuid.AsString(),'diameter_mm':p.ToMM(old.GetWidth(p.F_Cu)),'drill_mm':p.ToMM(old.GetDrillValue()),'tested_named_candidates':rows,'best_legal_candidates':legal[:15],'method':'Native effective-shape checks; .2001 copper clearance; .05 margin outside all SMT; actual board/footprint track/via rule areas and Edge.Cuts. Binary geometric distances, all computations read-only.','geometry_changed':False,'requires_native_DRC_after_adoption':True},indent=2)+'\n')
print('best',[(r['at'],r['minimum_copper_gap_mm'],r['via_copper_gap_mm'],[z['clearance_mm']for z in r['legs']])for r in legal[:10]])
