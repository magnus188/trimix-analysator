from pathlib import Path
import pcbnew as p
D=Path(__file__).resolve().parent;b=p.LoadBoard(str(D/'before.kicad_pcb'))
nets={name:b.FindNet(name).GetNetCode()for name in ['VOUT_5V','VSYS']}
def v(pt):return p.VECTOR2I(p.FromMM(pt[0]),p.FromMM(pt[1]))
def xy(pt):return (p.ToMM(pt.x),p.ToMM(pt.y))
def track(net,a,c,width=.3,layer=p.F_Cu):
 t=p.PCB_TRACK(b);t.SetStart(v(a));t.SetEnd(v(c));t.SetWidth(p.FromMM(width));t.SetLayer(layer);t.SetNetCode(nets[net]);b.Add(t)
def via(net,at):
 t=p.PCB_VIA(b);t.SetPosition(v(at));t.SetWidth(p.FromMM(.6));t.SetDrill(p.FromMM(.3));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(nets[net]);b.Add(t)
removed=[]
for t in list(b.GetTracks()):
 if not isinstance(t,p.PCB_VIA)and t.GetNetname()=='VOUT_5V'and t.GetLayer()==p.F_Cu and set([xy(t.GetStart()),xy(t.GetEnd())])=={(11.1625,50.85),(10.15,50.85)}:
  removed.append(t.m_Uuid.AsString());b.Remove(t)
assert len(removed)==1,removed
via('VOUT_5V',(10.25,51.0))
track('VOUT_5V',(11.1625,50.85),(10.4,50.85))
track('VOUT_5V',(10.4,50.85),(10.25,51.0))
track('VOUT_5V',(10.4,50.85),(10.4,48.425))
track('VOUT_5V',(10.4,48.425),(10.725,48.1))
via('VSYS',(11.4,54.025))
track('VSYS',(12.4625,54.025),(11.4,54.025))
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
print('Replaced VOUT stub',removed)
