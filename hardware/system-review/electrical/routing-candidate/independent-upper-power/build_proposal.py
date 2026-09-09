from pathlib import Path
import shutil
import pcbnew as p
D=Path(__file__).resolve().parent
text=(D/'before.kicad_pcb').read_text();wanted='083685fa-78b3-4ded-8fb3-cc7af34dad2f';at=text.index(wanted);start=text.rfind('\n\t(segment',0,at);end=text.index('\n\t)',at)+4
assert start>=0
(D/'without-input-stub.kicad_pcb').write_text(text[:start]+text[end:])
for ext,snapshot in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:
 shutil.copyfile(D/snapshot,D/('without-input-stub.'+ext))
b=p.LoadBoard(str(D/'without-input-stub.kicad_pcb'))
nets={name:b.FindNet(name).GetNetCode()for name in ['VOUT_5V','VSYS']}
def v(pt):return p.VECTOR2I(p.FromMM(pt[0]),p.FromMM(pt[1]))
def xy(pt):return (p.ToMM(pt.x),p.ToMM(pt.y))
def track(net,a,c,width=.3,layer=p.F_Cu):
 t=p.PCB_TRACK(b);t.SetStart(v(a));t.SetEnd(v(c));t.SetWidth(p.FromMM(width));t.SetLayer(layer);t.SetNetCode(nets[net]);b.Add(t)
def via(net,at,diameter=.6,drill=.3):
 t=p.PCB_VIA(b);t.SetPosition(v(at));t.SetWidth(p.FromMM(diameter));t.SetDrill(p.FromMM(drill));t.SetViaType(p.VIATYPE_THROUGH);t.SetLayerPair(p.F_Cu,p.B_Cu);t.SetNetCode(nets[net]);b.Add(t)
removed=['083685fa-78b3-4ded-8fb3-cc7af34dad2f']
via('VOUT_5V',(10.25,51.0))
track('VOUT_5V',(11.1625,50.85),(10.4,50.85))
track('VOUT_5V',(10.4,50.85),(10.25,51.0))
via('VSYS',(11.4,54.025))
track('VSYS',(12.4625,54.025),(11.4,54.025))
track('VOUT_5V',(10.25,51.0),(8.456,52.794),.4,p.B_Cu)
vsys_points=[(11.4,54.025),(11.55,54.175),(11.55,55.3),(12.8897,56.6397),(12.8897,58.1006)]
for a,c in zip(vsys_points,vsys_points[1:]):track('VSYS',a,c,.3,p.B_Cu)
via('VOUT_5V',(10.4,48.9),.5,.25)
cap_inner=[(10.25,51),(10.65,50.6),(10.65,49.15),(10.4,48.9)]
for a,c in zip(cap_inner,cap_inner[1:]):track('VOUT_5V',a,c,.2,p.In2_Cu)
track('VOUT_5V',(10.4,48.9),(10.725,48.575),.2,p.F_Cu)
track('VOUT_5V',(10.725,48.575),(10.725,48.1),.2,p.F_Cu)
b.GetDesignSettings().m_TrackMinWidth=p.FromMM(.15)
p.ZONE_FILLER(b).Fill(b.Zones());p.SaveBoard(str(D/'Trimix_Analyzer.kicad_pcb'),b)
print('Replaced VOUT stub',removed)

for ext,snapshot in [('kicad_pro','source-project.kicad_pro'),('kicad_dru','source-rules.kicad_dru')]:
 shutil.copyfile(D/snapshot,D/('Trimix_Analyzer.'+ext))
