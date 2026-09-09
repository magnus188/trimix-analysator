from pathlib import Path
import pcbnew as p,hashlib,json,math
D=Path(__file__).resolve().parent;src=D.parent/'local-cap-trial/pack-only-frozen.kicad_pcb';sha=hashlib.sha256(src.read_bytes()).hexdigest();b=p.LoadBoard(str(src))
def v(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
def xy(a):return[p.ToMM(a.x),p.ToMM(a.y)]
f=next(f for f in b.GetFootprints()if f.GetReference()=='C107')
obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()]
def labels(t,L):return{'uuid':t.m_Uuid.AsString(),'net':t.GetNetname(),'layer':b.GetLayerName(L),'ref':t.GetParentFootprint().GetReference()if isinstance(t,p.PAD)else None}
def via_blockers(a):
 out=[]
 for t in obs:
  for L in [p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]:
   if not t.IsOnLayer(L):continue
   rad=.5001 if t.GetNetname()!='GND' else(.3501 if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD else None)
   if rad and t.GetEffectiveShape(L).Collide(v(a),p.FromMM(rad)):out.append(labels(t,L))
 for z in list(b.Zones())+[z for f in b.GetFootprints()for z in f.Zones()]:
  if z.GetIsRuleArea()and z.GetDoNotAllowVias()and z.Outline().Collide(v(a),p.FromMM(.3)):out.append({'keepout':True})
 return out
def line_blockers(a,z,net,width=.4):return[labels(t,p.B_Cu)for t in obs if t.IsOnLayer(p.B_Cu)and t.GetNetname()!=net and t.GetEffectiveShape(p.B_Cu).Collide(p.SEG(v(a),v(z)),p.FromMM(.2001+width/2))]
rows=[]
for a in [(12.8,75.9),(12.8,75.8),(12.0,76.4),(11.8,77.0),(11.6,77.1),(13.7,77.2),(14.0,77.2),(14.0,76.5),(12.0,75.7)]:rows.append({'via_at':a,'via_blockers':via_blockers(a),'ground_stub_blockers':line_blockers((12.8,77.125),a,'GND')})
assert hashlib.sha256(src.read_bytes()).hexdigest()==sha
r={'source':str(src.resolve()),'source_sha256':sha,'hypothetical_C107':{'at':[12.8,78.6],'side':'B','rotation':90,'same_selected_part':True},'point_and_straight_segment_only':True,'proposed_via_diameter_drill_mm':[.6,.3],'results':rows,'board_saved':False,'acceptance':'No placement/routing/ground/DRC acceptance implied.'};(D/'candidate90-top.json').write_text(json.dumps(r,indent=2));print(json.dumps(rows,indent=1))
