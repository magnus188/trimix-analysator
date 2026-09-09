from pathlib import Path
import pcbnew as p,shutil,json,math
D=Path(__file__).resolve().parent
src=p.LoadBoard(str(D/'before.kicad_pcb'))
REMOVE={'beee2072-da87-4c91-8dee-813248aecfd1','3f2e7b6f-4559-441b-9bf4-f8311f062568','8a00984f-c7be-4c1f-94be-6d1a95b01f32','e54d3d63-8f24-44d7-889a-6b3dc5d95df2','49a95ab1-6a49-4ef0-9a1e-1ebb20a405bd','069f4560-7d59-48d6-9f75-f46835698002','5c5f9859-8998-4704-9cd0-fa0a8b85c5c4','f4fabd48-1ec4-48c9-abc4-c15487df9be5','820e048c-2551-4c7f-a328-7d7a3d1b70cc','8493fd8c-d682-416e-a80e-87098cbb5392'}
for t in src.GetTracks():
 if t.GetNetname()=='USB_ILIM_BRANCH' or (t.GetNetname()=='USB_PERMISSION_Q' and not isinstance(t,p.PCB_VIA) and t.GetLayer()==p.F_Cu and max(p.ToMM(q.y)for q in[t.GetStart(),t.GetEnd()])>88):REMOVE.add(t.m_Uuid.AsString())
text=(D/'before.kicad_pcb').read_text();removed=[]
for uid in sorted(REMOVE):
 pos=text.index(uid);lo=max(text.rfind('(segment',0,pos),text.rfind('(via',0,pos));depth=0;quote=False;escape=False;hi=lo
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
 removed.append(dict(uuid=uid,native=text[lo:hi+1]));text=text[:lo]+text[hi+1:]
(D/'removed-source-copper.json').write_text(json.dumps(removed,indent=2)+'\n')
(D/'Trimix_Analyzer.kicad_pcb').write_text(text)
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
for ref,at,angle in [('Q110',(17.5,89.3),90),('R118',(17.4,94.7),90),('R116',(7.75,94.75),0)]:
 f=next(f for f in b.GetFootprints()if f.GetReference()==ref)
 if ref in ['R118']:f.Flip(f.GetPosition(),False)
 f.SetPosition(vec(at));f.SetOrientationDegrees(angle)
track('PACK_P',[(21.5013,90.25),(20.2,90.25),(20.2,91.4),(17.7,91.4),(16.1335,93)],p.F_Cu,.4)
track('USB_D_P',[(13.85,94.85),(15.9,94.85),(16.3,95),(16.3,96.15),(17.45,97)],p.B_Cu)
if __name__=='__main__':save()
