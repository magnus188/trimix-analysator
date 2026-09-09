from pathlib import Path
import pcbnew as p,json,math
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D/'source.kicad_pcb'));f=next(f for f in b.GetFootprints()if f.GetReference()=='C107');f.Flip(f.GetPosition(),False)
def v(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
def xy(a):return[p.ToMM(a.x),p.ToMM(a.y)]
f.SetPosition(v((13.75,79.0)));f.SetOrientationDegrees(0)
removed=next(t for t in b.GetTracks()if t.m_Uuid.AsString()=='dcf3adfc-98b6-4b63-9e3c-1e074a51d2df');b.Remove(removed)
obs=list(b.GetTracks())+[q for fp in b.GetFootprints()for q in fp.Pads()]
ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
ruleareas=[z for z in list(b.Zones())+[z for fp in b.GetFootprints()for z in fp.Zones()]if z.GetIsRuleArea()]
def label(t):return dict(uuid=t.m_Uuid.AsString(),net=t.GetNetname(),ref=t.GetParentFootprint().GetReference()if isinstance(t,p.PAD)else None,at=xy(t.GetPosition()))
def blocked(a,z,net,width=.25,layer=p.B_Cu):
 hits=[]
 for t in obs:
  if t.IsOnLayer(layer)and t.GetNetname()!=net and t.GetEffectiveShape(layer).Collide(p.SEG(v(a),v(z)),p.FromMM(.2001+width/2)):hits.append(label(t))
 for r in ruleareas:
  if r.GetLayerSet().Contains(layer)and r.GetDoNotAllowTracks()and r.Outline().Collide(p.SEG(v(a),v(z)),p.FromMM(width/2)):hits.append({'rule':r.m_Uuid.AsString()})
 return hits
def via_hits(a,net='GND',dia=.6):
 hits=[]
 for t in obs:
  for L in ALL:
   if not t.IsOnLayer(L):continue
   gap=.2001 if t.GetNetname()!=net else .0501 if isinstance(t,p.PAD)and t.GetAttribute()==p.PAD_ATTRIB_SMD else None
   if gap and t.GetEffectiveShape(L).Collide(v(a),p.FromMM(dia/2+gap)):hits.append(dict(layer=b.GetLayerName(L),**label(t)))
 for r in ruleareas:
  if r.GetDoNotAllowVias()and r.Outline().Collide(v(a),p.FromMM(dia/2)):hits.append({'rule':r.m_Uuid.AsString()})
 return hits
G=(15.225,79.0);REG=(12.275,79.0)
result={'pose':[13.75,79.0,0],'pack_paths':[],'gnd_to_existing':[],'vias':[],'regn':blocked(REG,(12.79,81.15),'/01  CHARGING + BATTERY/BQ_REGN',.25)}
for points in [[(10.64,79.9091),(11.1,79.95),(11.1,77.69),(14.15,77.69),(16.1271,74.422)],[(10.64,79.9091),(10.6,77.4),(13.4,77.4),(16.1271,74.422)],[(10.64,79.9091),(10.65,79.95),(13.25,79.95),(13.65,77.25),(16.1271,74.422)],[(10.64,79.9091),(10.8,80),(13.2,80),(13.2,77.0),(16.1271,74.422)]]:
 result['pack_paths'].append({'points':points,'blocks':[blocked(a,z,'PACK_P',.4)for a,z in zip(points,points[1:])]})
for a in [(19.0625,78.7),(15.925,83.575),(11.9,82.9),(6.2,79.525)]:result['gnd_to_existing'].append({'at':a,'blocks':blocked(G,a,'GND',.25)})
for x in [15.75,16,16.25,16.5,17,17.5,18]:
 for y in [79.5,79.75,80,80.25,80.5]:
  a=(x,y);hits=via_hits(a)
  if not hits:result['vias'].append({'at':a,'line_blocks':blocked(G,a,'GND',.25)})
result['specific_vias']=[{'at':a,'via_blocks':via_hits(a),'line_blocks':blocked(G,a,'GND',.25)}for a in [(16.3,80.3),(16.4,80.25),(16.5,80.25),(16.6,80.0),(16.6,79.5)]]
(D/'trial3-geometry.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
