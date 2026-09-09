from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;b=p.LoadBoard(str(D/'q110-ground-frozen.kicad_pcb'))
obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()];NET='GND';ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
for xy in [(20.3,87.85),(20.75,88.2),(20.35,87.9),(20.8,88.25),(20.7,88.25),(20.6,88.25),(20.3,88.0)]:
 a=[]
 for it in obs:
  for L in ALL:
   if not it.IsOnLayer(L):continue
   if (it.GetNetname()!=NET or isinstance(it,p.PAD)) and it.GetEffectiveShape(L).Collide(c.vec(xy),p.FromMM(.4501)):
    info={'uuid':str(it.m_Uuid.AsString()),'net':it.GetNetname(),'layer':b.GetLayerName(L)}
    if isinstance(it,p.PAD):info.update(ref=it.GetParentFootprint().GetReference(),pad=it.GetNumber())
    else:info['pose']=c.xy(it.GetPosition())
    a.append(info)
 print(xy,a,flush=True)
