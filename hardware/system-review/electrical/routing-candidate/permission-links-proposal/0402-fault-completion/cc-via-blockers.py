from pathlib import Path
D=Path(__file__).resolve().parent
import route_context as c
p=c.p;b=p.LoadBoard(str(D/'series-base.kicad_pcb'))
obs=list(b.GetTracks())+[q for f in b.GetFootprints()for q in f.Pads()];NET='USB_CC_INT_N';ALL=[p.F_Cu,p.In1_Cu,p.In2_Cu,p.B_Cu]
for xy in [(19.3,89.0),(19.35,89.0),(19.2,89.0),(19.3,89.1),(19.4,89.1),(19.45,89.0),(19.5,88.9),(19.35,88.9),(19.1,88.95)]:
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
