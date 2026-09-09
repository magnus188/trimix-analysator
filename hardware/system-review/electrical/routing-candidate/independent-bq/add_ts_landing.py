from pathlib import Path
import pcbnew as p
D=Path(__file__).resolve().parent
b=p.LoadBoard(str(D/'before-v2.kicad_pcb'))
net=b.FindNet('/01  CHARGING + BATTERY/PACK_TS').GetNetCode()
def v(x,y):return p.VECTOR2I(p.FromMM(x),p.FromMM(y))
t=p.PCB_VIA(b);t.SetPosition(v(10.15,89.075));t.SetWidth(p.FromMM(.5));t.SetDrill(p.FromMM(.25));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(net);b.Add(t)
t=p.PCB_TRACK(b);t.SetStart(v(10.15,89.075));t.SetEnd(v(10.9,89.075));t.SetWidth(p.FromMM(.15));t.SetLayer(p.F_Cu);t.SetNetCode(net);b.Add(t)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
p.ZONE_FILLER(b).Fill(b.Zones())
p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
