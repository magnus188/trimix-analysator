from pathlib import Path
import pcbnew as p,json,shutil
OUT=Path(__file__).resolve().parent/'candidate';OUT.mkdir(exist_ok=True)
b=p.LoadBoard(str(OUT.parent/'source.kicad_pcb'))
def xy(a):return[p.ToMM(a.x),p.ToMM(a.y)]
def vec(a):return p.VECTOR2I(p.FromMM(a[0]),p.FromMM(a[1]))
def track(net,pts,layer,width=.25):
 for a,z in zip(pts,pts[1:]):
  if a==z:continue
  t=p.PCB_TRACK(b);t.SetStart(vec(a));t.SetEnd(vec(z));t.SetWidth(p.FromMM(width));t.SetLayer(layer);t.SetNetCode(b.GetNetsByName()[net].GetNetCode());b.Add(t)
def via(net,at):raise RuntimeError('No new vias allowed in bounded GND route')
f=next(f for f in b.GetFootprints()if f.GetReference()=='C107');f.Flip(f.GetPosition(),False);f.SetPosition(vec((13.75,79)));f.SetOrientationDegrees(0)
old=next(t for t in b.GetTracks()if t.m_Uuid.AsString()=='dcf3adfc-98b6-4b63-9e3c-1e074a51d2df');b.Remove(old)
track('PACK_P',[(10.64,79.9091),(11.1,79.95),(11.1,77.69),(14.15,77.69),(16.1271,74.422)],p.B_Cu,.4)
track('/01  CHARGING + BATTERY/BQ_REGN',[(12.275,79),(12.79,81.15)],p.B_Cu,.25)
p.SaveBoard(str(OUT/'Trimix_Analyzer.kicad_pcb'),b)
for q in Path('hardware/pcb/analyzer').iterdir():
 if q.name.endswith(('.kicad_pro','.kicad_dru','.kicad_sch','.kicad_sym'))or q.name in ['sym-lib-table','fp-lib-table']:shutil.copy2(q,OUT/q.name)
 elif q.is_dir() and q.name.endswith('.pretty'):
  dst=OUT/q.name
  if not dst.exists():dst.symlink_to(q.resolve(),target_is_directory=True)
