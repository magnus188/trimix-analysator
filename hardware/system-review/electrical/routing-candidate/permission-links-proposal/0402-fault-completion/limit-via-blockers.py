from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;b=p.LoadBoard(str(D/'q110-ground-frozen.kicad_pcb'))
obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()];NET='USB_LIMIT_SET';ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
for xy in [(6.95,88.6),(7.0,88.6),(6.9,88.55),(6.9,88.5),(6.8,88.5),(6.8,88.6)]:
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
