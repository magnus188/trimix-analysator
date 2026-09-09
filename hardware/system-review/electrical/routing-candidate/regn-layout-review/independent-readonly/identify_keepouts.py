from pathlib import Path
import pcbnew as p,json
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D.parent/'local-cap-trial/pack-only-frozen.kicad_pcb'))
def xy(v):return [p.ToMM(v.x),p.ToMM(v.y)]
for owner,zs in [('board',list(b.Zones()))]+[(f.GetReference(),list(f.Zones()))for f in b.GetFootprints()]:
 for z in zs:
  if not(z.GetIsRuleArea()and z.GetDoNotAllowVias()):continue
  bb=z.Outline().BBox();bb.Inflate(p.FromMM(.3));a=xy(bb.GetOrigin());e=xy(bb.GetEnd())
  if a[0]<14<e[0]and a[1]<76.5<e[1]:print(owner,z.GetZoneName(),z.m_Uuid.AsString(),a,e,z.GetLayerSet().FmtHex(),flush=True)
