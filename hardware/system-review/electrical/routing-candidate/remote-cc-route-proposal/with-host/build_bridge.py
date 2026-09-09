from pathlib import Path
import pcbnew as p
import shutil
D=Path(__file__).resolve().parent
shutil.copyfile(D/'before.kicad_pcb',D/'Trimix_Analyzer.kicad_pcb')
for ext,snap in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:shutil.copyfile(D/snap,D/('Trimix_Analyzer.'+ext))
b=p.LoadBoard(str(D/'Trimix_Analyzer.kicad_pcb'))
def vec(q):return p.VECTOR2I(p.FromMM(q[0]),p.FromMM(q[1]))
def xy(q):return p.ToMM(q.x),p.ToMM(q.y)
def track(net,points,layer,width=.15):
 for a,z in zip(points,points[1:]):
  if a==z:continue
  q=p.PCB_TRACK(b);q.SetStart(vec(a));q.SetEnd(vec(z));q.SetWidth(p.FromMM(width));q.SetLayer(layer);q.SetNetCode(b.FindNet(net).GetNetCode());b.Add(q)
def via(net,at):
 for old in b.GetTracks():
  if isinstance(old,p.PCB_VIA) and old.GetNetname()==net and xy(old.GetPosition())==at:return
 q=p.PCB_VIA(b);q.SetPosition(vec(at));q.SetWidth(p.FromMM(.5));q.SetDrill(p.FromMM(.25));q.SetViaType(p.VIATYPE_THROUGH);q.SetLayerPair(p.F_Cu,p.B_Cu);q.SetNetCode(b.FindNet(net).GetNetCode());b.Add(q)
def save():
 p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
 for ext,snap in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:shutil.copyfile(D/snap,D/('Trimix_Analyzer.'+ext))
