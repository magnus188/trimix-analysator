from pathlib import Path
import json,hashlib,pcbnew as p
D=Path(__file__).resolve().parent
P=D/'ce-bridge-scout/candidate/Trimix_Analyzer.kicad_pcb';SHA='3ba04d481d49b39d87a800c941448d665bcbd465af761bb2b0d617c23429b469'
assert hashlib.sha256(P.read_bytes()).hexdigest()==SHA
b=p.LoadBoard(str(P));old=json.loads((D/'power-corridor-scout.json').read_text())['hypothetical_points_mm'];up=json.loads((D/'upper-power-approach/proposal.json').read_text())['added'];pts=old[:old.index([17.825,86.225])+1]+[r['end']for r in up]
def v(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return [p.ToMM(q.x),p.ToMM(q.y)]
obs=[t for t in list(b.GetTracks())+[a for f in b.GetFootprints()for a in f.Pads()]if t.IsOnLayer(p.In2_Cu)and t.GetNetname()!='VSYS']
rows=[];hits={}
for a,z in zip(pts,pts[1:]):
 seg=p.SEG(v(a),v(z));bad=[]
 for t in obs:
  if t.GetEffectiveShape(p.In2_Cu).Collide(seg,p.FromMM(.4001)):
   q={'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'type':type(t).__name__,'start':xy(t.GetStart()),'end':xy(t.GetEnd())};bad.append(q);hits[q['uuid']]=q
 rows.append({'start':a,'end':z,'foreign_clearance_blockers':bad})
allowed={'a0d0b138-e4e0-41c6-a8c9-2fd0fa5a83d8','238c72db-0c93-4635-a03c-2391a67458ec','40b1bf21-f6b5-4820-b4be-583e59537237'}
assert set(hits)==allowed,(set(hits)-allowed,allowed-set(hits))
for a,z in zip(pts,pts[1:]):
 seg=p.SEG(v(a),v(z))
 for g in b.GetDrawings():
  if g.GetLayer()==p.Edge_Cuts:assert not g.GetEffectiveShape().Collide(seg,p.FromMM(.7001))
 for g in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
  if g.GetIsRuleArea()and g.GetLayerSet().Contains(p.In2_Cu)and g.GetDoNotAllowTracks():assert not g.Outline().Collide(seg,p.FromMM(.2001))
out={'status':'HYPOTHETICAL_THREE_SIGNAL_CROSSINGS_REMAIN','source':str(P),'source_sha256':SHA,'points_mm':pts,'segments':rows,'barriers':list(hits.values()),'upper_approach_foreign_clearance_native_pass':True,'existing_CE_detour_in_source':True,'release':False}
(D/'power-corridor-v2.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({'points':pts,'barriers':list(hits.values())},indent=2))
