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

# Root-approved isolated Q110 shift, same exact physical footprint.
REMOVE={'e72fd8cc-d93e-4395-a288-c9a2037529d8','5867a57f-1105-49ea-8456-ae5df67663eb','8a427806-9e97-4bd5-a946-f3792bed96c5'}
text=(D/'before.kicad_pcb').read_text()
for uid in REMOVE:
 pos=text.index(uid);lo=text.rfind('(segment',0,pos);depth=0;quote=False;escape=False;hi=lo
 for hi in range(lo,len(text)):
  ch=text[hi]
  if quote:
   if escape:escape=False
   elif ch==chr(92):escape=True
   elif ch=='"':quote=False
  elif ch=='"':quote=True
  elif ch=='(':depth+=1
  elif ch==')':
   depth-=1
   if depth==0:break
 assert lo>=0 and uid in text[lo:hi+1]
 text=text[:lo]+text[hi+1:]
(D/'Trimix_Analyzer.kicad_pcb').write_text(text)
b=p.LoadBoard(str(D/'Trimix_Analyzer.kicad_pcb'))
f=next(f for f in b.GetFootprints()if f.GetReference()=='Q110');f.SetPosition(vec((18.2,89.2)))
track('USB_ILIM_SERIES',[(17.2625,90.15),(16,88.4)],p.F_Cu)
via('USB_ILIM_SERIES',(16,88.4))
