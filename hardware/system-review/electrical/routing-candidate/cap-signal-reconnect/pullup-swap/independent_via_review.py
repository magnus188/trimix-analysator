from pathlib import Path
import pcbnew as p,hashlib,json,math
D=Path('/Users/magnustrandokken/Documents/Projects/Trimix/trimix-analysator/hardware/system-review/electrical/routing-candidate/cap-signal-reconnect/pullup-swap');P=D/'Trimix_Analyzer.kicad_pcb';sourcehash=hashlib.sha256(P.read_bytes()).hexdigest();assert sourcehash=='91f4a842065aa728669f056714bcab805d7b96778e27683fa3d7a9d44d147e20',sourcehash;b=p.LoadBoard(str(P));ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def desc(t):return {'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'reference_pad':t.GetParentFootprint().GetReference()+'.'+t.GetNumber()if isinstance(t,p.PAD)else None}
obs={l:[]for l in ALL};smd={l:[]for l in ALL};edge=[];rule={l:[]for l in ALL};vrule={l:[]for l in ALL}
for t in list(b.GetTracks())+[d for f in b.GetFootprints()for d in f.Pads()]:
 for l in ALL:
  if not t.IsOnLayer(l):continue
  s=t.GetEffectiveShape(l)
  if t.GetNetname()!='CHG_INT_N':obs[l].append((t,s))
  if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD:smd[l].append((t,s))
for d in b.GetDrawings():
 if d.GetLayer()==p.Edge_Cuts:edge.append(d.GetEffectiveShape())
for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
 if z.GetIsRuleArea():
  for l in ALL:
   if z.GetLayerSet().Contains(l):
    if z.GetDoNotAllowTracks():rule[l].append(z.Outline())
    if z.GetDoNotAllowVias():vrule[l].append(z.Outline())
def distance(objects,shape,radius):
 nearest=[]
 for t,s in objects:
  if not s.Collide(shape,p.FromMM(1.5)):continue
  lo=0.;hi=1.5
  for _ in range(22):
   mid=(lo+hi)/2
   if s.Collide(shape,p.FromMM(mid)):hi=mid
   else:lo=mid
  nearest.append({'edge_clearance_mm_lower_bound':round(lo-radius,6),**desc(t)})
 return sorted(nearest,key=lambda a:a['edge_clearance_mm_lower_bound'])[:3]
def segment(a,z,l):
 seg=p.SEG(v(a),v(z));hits=[desc(t)for t,s in obs[l]if s.Collide(seg,p.FromMM(.2751))];ed=any(s.Collide(seg,p.FromMM(.5751))for s in edge);ru=any(s.Collide(seg,p.FromMM(.0751))for s in rule[l]);return {'start_mm':a,'end_mm':z,'layer':b.GetLayerName(l),'foreign_copper_hits':hits,'edge_violation':ed,'track_rulearea_violation':ru,'passes':not(hits or ed or ru),'nearest_foreign_copper':distance(obs[l],seg,.075)}
rows=[]
for q in [(19.85,74.15),(19.95,74.30),(19.925,74.275)]:
 hits=[{'layer':b.GetLayerName(l),**desc(t)}for l in ALL for t,s in obs[l]if s.Collide(v(q),p.FromMM(.4501))];sh=[{'layer':b.GetLayerName(l),**desc(t)}for l in ALL for t,s in smd[l]if s.Collide(v(q),p.FromMM(.3001))];ed=any(s.Collide(v(q),p.FromMM(.7501))for s in edge);ru=any(s.Collide(v(q),p.FromMM(.2501))for l in ALL for s in vrule[l]);rows.append({'position_mm':q,'via_diameter_mm':.5,'drill_mm':.25,'copper_hits':hits,'smd_with_0_05_margin_hits':sh,'edge_violation':ed,'via_rulearea_violation':ru,'passes':not(hits or sh or ed or ru),'nearest_by_layer':{b.GetLayerName(l):distance(obs[l],v(q),.25)for l in ALL},'incident_segments':[segment((20.55,73.6),q,p.F_Cu),segment(q,(18.9,73.05),p.In2_Cu)]})
assert hashlib.sha256(P.read_bytes()).hexdigest()==sourcehash
optional={'via_position_mm':[19.95,74.30],'front_waypoints_mm':[[20.55,73.6],[20.0,73.8],[19.95,74.30]],'incident_segments':[segment((20.55,73.6),(20.0,73.8),p.F_Cu),segment((20.0,73.8),(19.95,74.30),p.F_Cu),segment((19.95,74.30),(18.9,73.05),p.In2_Cu)],'recommendation':'Existing route is legal. Optional one-extra-segment detour improves local clearance; requires owner adoption, refill, native DRC and updated ground receipt. A direct via-only move is invalid.'}
out={'optional_bent_variant':optional,'board':str(P),'board_sha256':sourcehash,'method':'Read-only KiCad native effective shapes; binary distance lower bounds, same-net CHG copper excluded, actual Edge.Cuts and board/footprint rule areas included. Filled-zone return geometry is reviewed separately.','rows':rows,'authoritative_geometry_changed':False,'release':False}
(D/'independent-via-review.json').write_text(json.dumps(out,indent=2)+'\n')
for row in rows:print(row['position_mm'],'via',row['passes'],'F/In2',[x['passes']for x in row['incident_segments']],'viagap',min(d['edge_clearance_mm_lower_bound']for rr in row['nearest_by_layer'].values()for d in rr),'segmentgaps',[s['nearest_foreign_copper'][0]['edge_clearance_mm_lower_bound']for s in row['incident_segments']])
