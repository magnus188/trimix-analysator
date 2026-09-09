"""Add only the verified TS branch to immutable lower-bq-base-v2.

The B start is exactly on the existing 45-degree TS segment; purchased
component positions, all existing copper and the plane outlines are retained.
"""
from pathlib import Path
import pcbnew as p
D=Path(__file__).resolve().parent
b=p.LoadBoard(str(D/'before-v2.kicad_pcb'))
net=b.FindNet('/01  CHARGING + BATTERY/PACK_TS').GetNetCode()
def v(pt):return p.VECTOR2I(p.FromMM(pt[0]),p.FromMM(pt[1]))
def segment(a,c,layer):
 t=p.PCB_TRACK(b);t.SetStart(v(a));t.SetEnd(v(c));t.SetWidth(p.FromMM(.15));t.SetLayer(layer);t.SetNetCode(net);b.Add(t)
t=p.PCB_VIA(b);t.SetPosition(v((10.15,89.075)));t.SetWidth(p.FromMM(.5));t.SetDrill(p.FromMM(.25));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(net);b.Add(t)
segment((10.15,89.075),(10.9,89.075),p.F_Cu)
points=[(11.548,85.7),(10.9,85.7),(10.55,86.05),(10.55,88.3),(10.15,88.7),(10.15,89.075)]
for a,c in zip(points,points[1:]):segment(a,c,p.B_Cu)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
p.ZONE_FILLER(b).Fill(b.Zones())
p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
