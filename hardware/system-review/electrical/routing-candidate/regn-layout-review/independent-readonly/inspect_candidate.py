from pathlib import Path
import pcbnew as p,hashlib,json,math
D=Path(__file__).resolve().parent;src=D.parent/'before.kicad_pcb';sha=hashlib.sha256(src.read_bytes()).hexdigest();b=p.LoadBoard(str(src))
def v(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
def xy(a):return[p.ToMM(a.x),p.ToMM(a.y)]
f=next(f for f in b.GetFootprints()if f.GetReference()=='C107');f.Flip(f.GetPosition(),False);f.SetPosition(v((12.8,78.6)));f.SetOrientationDegrees(270)
for q in f.Pads():print(q.GetNumber(),xy(q.GetPosition()),q.GetNetname())
obs=[t for t in b.GetTracks()if t.m_Uuid.AsString()!='dcf3adfc-98b6-4b63-9e3c-1e074a51d2df']+[q for f in b.GetFootprints()for q in f.Pads()]
# The parent's hypothetical PACK detour is an obstacle, never adopted here.
for a,z in zip([(10.64,79.9091),(13.6,78.1),(13.85,78.0),(15.5,75.85)],[(13.6,78.1),(13.85,78.0),(15.5,75.85),(16.1271,74.422)]):
 t=p.PCB_TRACK(b);t.SetStart(v(a));t.SetEnd(v(z));t.SetWidth(p.FromMM(.4));t.SetLayer(p.B_Cu);t.SetNetCode(b.GetNetsByName()['PACK_P'].GetNetCode());obs.append(t)
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
for a in [(11.9,81.2),(11.8,81.2),(11.7,81.1),(12.0,81.25),(11.9,81.3),(11.85,81.25),(12.0,81.4)]:rows.append({'via_at':a,'via_blockers':via_blockers(a),'ground_stub_blockers':line_blockers((12.8,80.075),a,'GND')})
assert hashlib.sha256(src.read_bytes()).hexdigest()==sha
r={'source':str(src.resolve()),'source_sha256':sha,'hypothetical_C107':{'at':[12.8,78.6],'side':'B','rotation':270,'same_selected_part':True},'point_and_straight_segment_only':True,'proposed_via_diameter_drill_mm':[.6,.3],'results':rows,'board_saved':False,'acceptance':'No placement/routing/ground/DRC acceptance implied.'};(D/'candidate270.json').write_text(json.dumps(r,indent=2));print(json.dumps(rows,indent=1))
